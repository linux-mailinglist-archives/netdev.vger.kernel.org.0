Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAFB6E6723
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjDRO2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjDRO2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:28:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD27DD
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:28:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcBgQpgCSKm8n+2cQTr8bBtaN6JI8gjfNh4wdk0j0jSED2JsMtrdo8eYakaSUvtQQcWKVgX0dJBjH7PO8W+VQ84mHqSUX9/SJFNkiujx3KGWThZzQvR/Qc9adyHzvg+dl3XpJf9fPM2KmrFdflWn2KHEp3dSPVcg+8geXzBoKDnpsV1Z8AAyEOVPyCMb+Mw3TZsEAGBW325Rw+U3shjFOTJGngyrwwAekFhIv6N+icJoJG3BlTlG1LYRzY3VCaGLlAtuuQXNhYLcszVBV2mvZeSwKuHTQ9uG0Qtwi+ayITXhfrCvMl6Z7xrjzZ+TjXanbyW1AVXoizOeSR2nqraqcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yt7DYpBpJ/kTZCtV1ALrdO+9KpgbKDBR9GryamZbo8U=;
 b=n3EHpScqQS29w0hv+0TDMxZp4fiRLgM80FIcOia8qDaoGtUlrSX4sFwo4pYdjeuNaSPDOChdEOMnBO/z1jfnJ4ur7D3F1wG4UD1qKkxVJSBudDtt2EcW/bPkt6nyGK+CDnjQgsnd+0ZhPQSmBjvgaiInxkmN8Er+FJxG5yqN5VUDb09sNhyU/mzepbZW0phTjSizJB16d0DziCLjDPByCAa/06DlyPN0ll5EeVkANzMtG5J82OCOi4ixULl+k+NRslNFxAtKyfXI24jr4gdnc2nDPO040SgOOfT0gOcXPiEJFH1lpLzpjiQG5hyD3HIncGWrJpsYbcRDP/fKZ2Km3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt7DYpBpJ/kTZCtV1ALrdO+9KpgbKDBR9GryamZbo8U=;
 b=Dq+/4jLtQ9dL1qxX6qCsLDAMI6A5IGfMxrKlWBJoRI8SkPYHfWxq5E+3o4r4XPGmFU4kKWEgTtVvo5EhpxYxUzKtSrBH26IrwidI+W2FsWXhbl40uX91QY/rvzLhcDHSqrn6OFp/iLaw+vC0CnPjDBJEwjAv2kb9+nBlc098r0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3799.namprd13.prod.outlook.com (2603:10b6:610:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 14:28:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 14:28:32 +0000
Date:   Tue, 18 Apr 2023 16:28:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     daire.mcnamara@microchip.com
Cc:     nicholas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        conor.dooley@microchip.com
Subject: Re: [PATCH v2 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <ZD6pCdvKdGAJsN3x@corigine.com>
References: <20230417140041.2254022-1-daire.mcnamara@microchip.com>
 <20230417140041.2254022-2-daire.mcnamara@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417140041.2254022-2-daire.mcnamara@microchip.com>
X-ClientProxiedBy: AM0PR03CA0005.eurprd03.prod.outlook.com
 (2603:10a6:208:14::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3799:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a04a226-0153-4604-e1b1-08db40192fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFXmB1xQDXaeLQaGNu2Bw9NzpPDLufC4aD0Wn0999MEpulWOAvFS3oraomcj6aTAWGt4VUe8yJFQLknOWRe/3dc4pXRYafvtizDFN5o01M86pO224zaPWPlLbY0vwWSHYO+tXVKyfkPsfwuIkwhivmgb9RNVgJX1RrkKSxPpuOeffCplsGsSEOg170dyOLIPDJg0FSro8VHKR1etwtdPKijpVxo3wuF6iXDTFkJMFBcfMYe4vFx8KvNd1u8sjDYWEeIOV8wrlXR0MvtDPNhIhMynUsbhMym0xJ0JgKa7SRJEPm+IaHmpopUulqhw8sO1l8KroiA1a4udVMv6thydQFpE06h0gzth5UxOBZTfeUQtyH9eAXq0++FrmPkS/D1DlbDO/aJh5O82mKdGc2nZKtyJUvRvQ4jNu7XalbEDmlArEcftd+OiVv197T15v7CauhdSPWuDfoS98AXyOTl2sPgASCRoG+EQkaK9TlZsGTdsPgI9ujXnX2UqGo7rrFPNfdZCGp7IRyjAw+9GZJyEoG4e/0BRd+xkpB59CjswGCaNmvhik8hd7pyVGXaC0Bmy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(366004)(376002)(396003)(136003)(451199021)(36756003)(44832011)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(2616005)(6506007)(6512007)(186003)(6666004)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(83380400001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gM2TAQkhjCDV78CfPGan6UfRY4XtDhkKIYBjuvYQou82MMg1UeVvZvqDlSbc?=
 =?us-ascii?Q?ENicR19btdEJ4wqk+cG3XoF+cTaw9je73D4mTXAQb0fbgIf/vey0Ax8OR+4Q?=
 =?us-ascii?Q?xhxIEQTyLqahsNWKATXfQXDDHj/LaxO+uGSiMuG9A+JHGIL3WfBwm3rT6Sy8?=
 =?us-ascii?Q?wQntE0SltxIqkkspjTcKbvD9AafR7jrkBcuvo1FJloBYX00D5wjQF0rVfd5R?=
 =?us-ascii?Q?AuLEZnxA/xyiA2IcZqVc+pFKr3hIAG4TXJobsc9WutGpq9scBgEAhfGk7d1C?=
 =?us-ascii?Q?5buSK0KMOORxkj7A4rOqT4Z6+p5dlqFijmjngwktQb6Q3RWyBoidk+mTpyj8?=
 =?us-ascii?Q?9x7ugsywqQtQYFJM3CNlzC2DEjSC7ycY5OqBOBCNdlMfrLVjdC3Kd/WST6fd?=
 =?us-ascii?Q?/KoDndauBJc7gXY5Sl5HduMxHyZhfNF/0CM1YAwIktUhxuE1EXskE6bta99b?=
 =?us-ascii?Q?F+T0Lk1nWdb/Ev9PqyaKam2EdvAo3GJ7h/XYmHV0thpOMWQoTFFyxxQT7j9X?=
 =?us-ascii?Q?pIpAq+nttsfVWwVnbr2O3xZT+9Uc9l4PdYgLbUPq04Ci/Ht0SuWv5GzlOqh9?=
 =?us-ascii?Q?aI+hqqeMPJDEmK9oPDVl4hK1/DLpucLtq1Sc8H5yNdSxhfAr5RXHAuldrfLG?=
 =?us-ascii?Q?CpR8yINukkna53d1AjQzE6H9JG41jSr/dnmXqB19OssTMkVIuzKlomTUPr2n?=
 =?us-ascii?Q?flNdDhtjilkpXbvxcES5qqipFWS2P8LA72p+KLme1Mqo88I7XkxRloLDzKOx?=
 =?us-ascii?Q?cUBy00ZUkrzyruSKjDmvBQ61zpWrrkbPHVHHfbu20/j+lxVDatbCo8O71uJh?=
 =?us-ascii?Q?iY1XxiAWyKg2mY7dsbviJzJJjyxCC7FUbLuSnIdXvfMSuSB9Vk/mK/gOm6v6?=
 =?us-ascii?Q?KbiiTMBzQWZ11bx5Oz/Bp9zvHlH2Ok08HO+/iks9XbxJ4yDhJ7kgNKoiMXr8?=
 =?us-ascii?Q?9SdQYG5n6Hj3K+kAZEHuRPeSyz5jgkDK7xfOB9NfoxDFbEGnKoDcQ3sIfz8w?=
 =?us-ascii?Q?GZG0ET3P0Ms3MQfeZpPbJ+MWC8YZohStiuAbRAtS8WOFBOMxq1ZciftyJ4fS?=
 =?us-ascii?Q?pGaaH/THCOn2fwYhcYf6j3dlNlPRNVOX8wwbEkHNFDSj+682zZPKzepnIxBl?=
 =?us-ascii?Q?YxzVk72wHahEJWhdSy+usJRGSbxSS0Mp7Qop0jqxdIRLETR4rKbDUIhe1Ykt?=
 =?us-ascii?Q?SZcxpkoTKADzZpMweDJTrxyhcM8voIg9vO0Aee5x7l5lAKq6Ui/+hZ01cgud?=
 =?us-ascii?Q?lICY8EghGd9zPNOykBcoFj4wdxnDTxLrNlcXiKwXBSEx7R9vPUn+OjRj2OJr?=
 =?us-ascii?Q?O58uZ1+W2lSV2YqgWBT1N8EK7wV696OX0Wo6BAwr39gIKii8d4/z+v22BUfB?=
 =?us-ascii?Q?ZK0KrK2lD446aaIUZdKaz1LDVKba6M8btE6EepuVlL7r/XySDqEc+BCnbLuq?=
 =?us-ascii?Q?w9/eu84FC7jDH/XGfpyfOtaXbor5QDDBkG2dQtEmuHHROuv3shDaRtoKk6jM?=
 =?us-ascii?Q?PZUuy7Jz8ahSad3P1kt+6+h6uDhDcsvdc0wyqZJskJhSAz4qLf2qtct1YUje?=
 =?us-ascii?Q?pv2ox8uvfCvYYs5GpP+bgHtn+7WNM0vcUCcLslevF2ViPZi7vGJ75jdNrEeM?=
 =?us-ascii?Q?p+JLOoqK0Wwoyso2lI8KAU8M6rN/v9LoV+Vx9BQwV6oHWHXd89ghAd+hFkAE?=
 =?us-ascii?Q?3rzTNw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a04a226-0153-4604-e1b1-08db40192fc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 14:28:32.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNJgdULlOJpn98GQa38cRwoxen6jei/fk4Kpsi+GK/H2y/NazhlvsRgVYYnXEJcX+TOr5OjbLgqUWeLbkmyRT4Tp4oLbv62nspgUpbwQfrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3799
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 03:00:41PM +0100, daire.mcnamara@microchip.com wrote:
> From: Daire McNamara <daire.mcnamara@microchip.com>
> 
> On mpfs, with SRAM configured for 4 queues, setting max_tx_len
> to GEM_TX_MAX_LEN=0x3f0 results multiple AMBA errors.
> Setting max_tx_len to (4KiB - 56) removes those errors.
> 
> The details are described in erratum 1686 by Cadence
> 
> The max jumbo frame size is also reduced for mpfs to (4KiB - 56).
> 
> Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>

...

>  static const struct macb_config sama7g5_gem_config = {
> @@ -4986,8 +4985,17 @@ static int macb_probe(struct platform_device *pdev)
>  	bp->tx_clk = tx_clk;
>  	bp->rx_clk = rx_clk;
>  	bp->tsu_clk = tsu_clk;
> -	if (macb_config)
> +	if (macb_config) {
> +		if (hw_is_gem(bp->regs, bp->native_io)) {
> +			if (macb_config->max_tx_length)
> +				bp->max_tx_length = macb_config->max_tx_length;
> +			else
> +				bp->max_tx_length = GEM_MAX_TX_LEN;
> +		} else {
> +			bp->max_tx_length = MACB_MAX_TX_LEN;
> +		}

Hi Daire,

no need to refresh the patch on my account.
But can the above be simplified as:

               if (macb_is_gem(bp) && hw_is_gem(bp->regs, bp->native_io))
                       bp->max_tx_length = macb_config->max_tx_length;
               else
                       bp->max_tx_length = MACB_MAX_TX_LEN;

>  		bp->jumbo_max_len = macb_config->jumbo_max_len;
> +	}
>  
>  	bp->wol = 0;
>  	if (of_property_read_bool(np, "magic-packet"))
> -- 
> 2.25.1
> 
