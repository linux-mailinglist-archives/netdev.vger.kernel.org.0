Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD484F5BE6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350628AbiDFKtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350873AbiDFKrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:47:52 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60123.outbound.protection.outlook.com [40.107.6.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ED0502836;
        Wed,  6 Apr 2022 00:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qlsm+6E0FG/k8/3Kg5t570/dYsDS2Vc50FLIVVhvgzDfO0Cttjdf58paW9XczgEspBX9XJzzQgw2YHoBhdqnuhNyQvaHjtXwbijIgBruRE6ksRmcR2X7SD1ZsoVHpb5GN+mBVcT0qqz1RhEcZhFLftjpXsh0F0WDtBS27KX+Sc6ZtDHL2gGSLWh7fa8C8Em9mGFSJKl4QdAPKjPAw3iNsyueafDpQ91cR3bZDsqntTxZrx5XMTylqclAXTX4idcJVbCFkOFck9b/uEN6w5S4zfYCrHAtiasQF1xKkfqf7KDy7wDeI4hg25Pf61KV01xeWEHehyq29rWomnKQSollfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAKaDrqBPQu8KA9BFDTRMDsdo9K98EkJaTG2m9eb3GY=;
 b=VWiqha1DU05pZatYjcCE+trg9hzUJzSH87V4JxdMRaEKBOO9d4vd6rcnFa2SpDgp+DKgVCdzhPNQ6phDRE5wm6S9DNBtuO6Z65zYI09vauwcqfUuhiQlh6zUeX7f3ghYHXiQ/1t7nkpj+bnHEPjs8RZ3zyLnbrJlLk2pD/+Jwyu19Ikj22KvCDOliAeu5Wv4Hh7EZncDebFUxfrEyTSO9MvVPluuXEdwNHY52nVFrl6u5+L8qh4IXxqWNGeyh6zRbOV4UikpBOiWsBb2gkh4pO8nXAOdJ2oDd79cYD81fmfmTju52BLzMOwOaOt9ry5uHwSn8ANRPpCN0KdU+qu1Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAKaDrqBPQu8KA9BFDTRMDsdo9K98EkJaTG2m9eb3GY=;
 b=XV09DW1OKiKvGlJA0ZuSOhX3vuVzZjEIn50mpjYvvGJnOG5c9V4UFcp+dNt+77QpmDW1vpMhQs4V4oPDSpLMjSFZxkrtrcrxiqrQrTIFCV53Ou1WdznAXZVwxYMBlOoElsOiTq6Ha+v0YnJI+jHmxq0UahQNHCg8Hr+4D1gQfF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by DU2PR10MB5093.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:2d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 07:11:19 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ac3d:2f31:c9d8:75bc]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ac3d:2f31:c9d8:75bc%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 07:11:19 +0000
Message-ID: <961fd021-3391-da16-1ebe-508110a5d173@kontron.de>
Date:   Wed, 6 Apr 2022 09:11:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 9/9] arm64: dts: imx8mm-kontron: fix ethernet node name
Content-Language: en-US
To:     Shawn Guo <shawnguo@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     =?UTF-8?Q?Beno=c3=aet_Cousson?= <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Tony Lindgren <tony@atomide.com>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
 <20220216074927.3619425-10-o.rempel@pengutronix.de>
 <20220406011310.GC129381@dragon>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20220406011310.GC129381@dragon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR07CA0024.eurprd07.prod.outlook.com
 (2603:10a6:20b:451::7) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 379e5acf-52d8-4ce7-6d54-08da179ca5bc
X-MS-TrafficTypeDiagnostic: DU2PR10MB5093:EE_
X-Microsoft-Antispam-PRVS: <DU2PR10MB50930D5D1B1BED4536215770E9E79@DU2PR10MB5093.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k4bdsBXOJltwiGVzRCp6Axt5T+xMCYvqCdRWsr82l98lXDb/X/iDiw2ZcWz5BNbSx/G0plUxy6jCeRMeTE6k49lqBlXr7pqJQsPtu642TBBIe6Dz+dO5CP+NUCLXV+fUmM1TvWG5F7NZ5TarvjYav3B1rGsqCa6Rr8DdznpTXCH5CT/KNd/H/etBqqPdVm+DF4LPgGnvFJ/Qa8Lm/MjtUUdZWLhiksFkrmUYcHABJPD7c5BC7/YwMcZPGduOPjiIaxnwhMCTHbSr/5ZA/yJOq/R0l5NXmoeTLLKq3L2gGx5fNNZPswXVjxkPxuISFb5Q80D3FS3hpUb2iz/a6EZIXbs1C4X+zn8sJfnHY5U9M4YCUMn3HetCBi9q8jtoVtAcEfDRmfYEDgZ2Tu0L5FHCFwR5FA25cCZCtzxdhgL7xrg8k1sHfn0cq3NretE7X4xXWRsXgfMHM5of8IqC0tV+b08HPlomO5cdL7znUAOXDz8gTzdQ3KLKYoX2OesYzRO7+NjNHyi1P8HdapG+5PmCOFLZcvpvM7kLXrOG8T6rKVZtuFpfNQb8FrLXKiOxhZu83MR1mf2g790mijuG4Uk89McQdp1ag3XbzMo/KtfsNDLrH/fuFqoFQHpezfzWKrv9VVZ9NNBz/R3fVwvloaxyRu26EsC7igPqp+VfRI3TO73foOgwD5T3ND+79y7CeXOFbPx2p1TG+FiQ631sTbBGL5oyNSq0mcqT84h1raYxfAis12R7qdsG1jEAiRSEZQd6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(7416002)(5660300002)(66476007)(36756003)(38100700002)(508600001)(31686004)(8936002)(44832011)(66946007)(316002)(2906002)(8676002)(4326008)(6512007)(6666004)(83380400001)(6486002)(110136005)(31696002)(54906003)(86362001)(2616005)(186003)(26005)(6506007)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGdxRXhZRW03OGFJbGtwSXUxL3hQUE8xS0U3WVU0TzZVY0k4RUZKYW1BekNz?=
 =?utf-8?B?aFlHaEZra2tzbllTcDNueGY2RFRqeTBuSDZFRWplMTZTRjh0cHZsOEJEOUsr?=
 =?utf-8?B?NkFoVFk2cVA2Z3dsODlXTW02aTRmUWlaMmxweGNKSm45YkM0SmZLVDZsRFZL?=
 =?utf-8?B?Y1hjYmUrTldIVzR4NkRyMzFEYkIrdXVVdXlmeUdTcVF1S1pXOHhEYjh3ckRL?=
 =?utf-8?B?SDRRZGdOVDNsM0pPRi85N25vM044ZEdwT2dzb05FSEd3a2tqNFdKcGdXOGhu?=
 =?utf-8?B?UTUrRUJnaEhhYjFzUXN2KzUyRzBqeW9haHBES2RnWjRlRXBITEVVV1k3VE1i?=
 =?utf-8?B?OWxxS2JvQmRFZVR3eGpYTEhRRnRFWkVqZDBiaHFnVFp3OHlnYzEzK2d4M0Uw?=
 =?utf-8?B?Ty9tR3d2UG9nU1RoOW5aQ0tIZWpwK0l6RUN1Uy9WS0NKMDB5bFV5RkJSeURB?=
 =?utf-8?B?d0t2MDRzUExQWU9xUW1SM3dlb3VBMnF6clhXVVhwclVVU3oxdTU4bG5UU0d5?=
 =?utf-8?B?c0xxN2VMMDRTWlVzazNnU0RYY0ZvenNhcXFSUUhQSTlZZEpueHNzcnp3b3hT?=
 =?utf-8?B?WjlyNDkzQmtTZzNtWG1TOGlRUnZNOFRkb3N6c3hlTVZIUUZZS25rN2xhZ0Np?=
 =?utf-8?B?K2pURFYzZXdic3BKWFdZaU83c0dFNTA3NVMzQnFQTGF2N3dyM1YwcTZjSVBX?=
 =?utf-8?B?QmFqa1owcXVmMFVXZ1hqUiszSFRLSDBwbVVjOHhwblUzVWM2d2RzQVZUWk8v?=
 =?utf-8?B?UCsxWkFHU3VTc3gzNllISjdidW5tL0NhTERWMzRqODhxYVBCVzJ0ZVh2QlVi?=
 =?utf-8?B?bjUzeGJqZTlTTTN4c3pLTFZaOFhPY002ellVOXdzSkxpRUFsNXVRbXlFRFRh?=
 =?utf-8?B?enJkemxUSFNLaXJFUWNVenVzU1lxN2hwTHVrYk42bks4UW9seVpxMXhzNDFT?=
 =?utf-8?B?ZjlsSE9VaFZHL2lmTmRPRkJBQmU1S3MrbHRTM1JBRzdoNlh2STdoS3IrYkV4?=
 =?utf-8?B?ZWtDQ2JDeGlYZmZOMnZzZ2ZPdSthWUFkdVVTRS9Uc1YyeFZoWjJkOGRmTnVl?=
 =?utf-8?B?OVdwSkRaNVVJazNNTkF2U1Z2R3EzTUd2RVVaeXl3d2FHSFNEZG5RZUlUYmVm?=
 =?utf-8?B?ZDU4UDVacUpjdXUzaFpWeUdIRWRZSVZEamJ4bUJ3RVlSbzFxc09QMlptbmxt?=
 =?utf-8?B?aHhFeHZVK2xQSjZ3ZTZSOTVFWW9Pci85c3hWUXdrc1pNalVETGJRc1pvR0VJ?=
 =?utf-8?B?VWUvTzZ0RTQwK3hwV05zUnpWcVNNVGhpOVMrREJGYzZwcW5iZGdVWVJJRVcx?=
 =?utf-8?B?L2lSd1Jacmp3MU9DdGRKWWRjTUVIbkwxTjlwRVhZMUpTZmxUV2RKRUhrS1ZH?=
 =?utf-8?B?Z2NFcWV3Qm4wSHhYZmNLaHczKzBOUFpUa0RJbUNrK2QzZ05oaGlYRjVyeURI?=
 =?utf-8?B?MnZtdEZVYkpROGdXNTlGU29RTUtsRXpFUUVHZ3RSTnNUQ2JrMkdZWEJ1bWR4?=
 =?utf-8?B?ai8vUjExZVNnSUZGaFZhR0k0cFZHUjdlN3N3dzgvWHBXZkF4QlVpNk56UjR4?=
 =?utf-8?B?NXE4VDVHVWd6dGIwT0drT2g4dGE3b1l0SmFoVUlDNC92Z3JaL1hRdmRrR1VV?=
 =?utf-8?B?YXZGTmdtNDBPbTdUZ0RvNjcvaGNiMEFmc0ZMSFk2OFNCbTh5TVB1cjVNbGZY?=
 =?utf-8?B?OXlRMXFucWE5UUovTU16dnU1S0M3eVVBaElML2NZU1NWNFNSY0VTbnI0dytk?=
 =?utf-8?B?ZStjNFR0QVZIaWo4algvb2xtZllLTE5mdXRhdHd1ZitoY0JYa2NQb0Vpb2pk?=
 =?utf-8?B?ZFA1THhlcmxnZnhEbzJabWFGNGFwcmd4QWpRMU1WbmlDNjFQWmkyYjQ2aVpP?=
 =?utf-8?B?bXJrMTFlRmwrY0V5U1l2YU9UYUtvRVVVZzFiNDI1YjNkWGhsSytYSFJ5UU9M?=
 =?utf-8?B?czVIR2d3dWVpc25jbnpBVFVCT1lEVjdDUGtKZDRlOVFrR2h5bUxFTFhtc2ky?=
 =?utf-8?B?VGg1TnQ2Y1Z4R0VjcU43TmdXaEJrOVI0eWRuZDVncDZidWlpMHIrb0RNTDNE?=
 =?utf-8?B?dW4yckluVnVOWG5sdXFOQU5XMTczc2FWV1pXaTJlQThXSTBGRjlmQnllQXkv?=
 =?utf-8?B?angrc2FBVVB4N0FuTlpIQzdacEVyNnpXNkhkc1pWcEZqWnY3OUc2U1NsQ2Ja?=
 =?utf-8?B?YWJnTUxMdmlPSWtOVTg0Y09BYjlJWDZKYnlWRHA2WXI1YkJYT2xnaG1yVVNE?=
 =?utf-8?B?dXBjWnh4U005QTRzbHBpTTh0VUJCcDFRSUpUVjMyYkltZ3RYSlhWRUhyYkF3?=
 =?utf-8?B?WlpieFI2UDBSNzFiRUpKVi80eDQzUENJZDhpa05RbjViOEIrWWZDSVRoMklE?=
 =?utf-8?Q?r4/1NQMvYQqKk11Y=3D?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 379e5acf-52d8-4ce7-6d54-08da179ca5bc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 07:11:19.0522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0kHuSKE9jkfvJs/pi607v1OcbVLjR8Ku05bAwrLdRSz9a0KsQ1jZJfK7rTNjLD+wRNqtH3DBZNE67yanFnJD7cu7ThLn6d7WxR36EWqYuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR10MB5093
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 06.04.22 um 03:13 schrieb Shawn Guo:
> + Frieder Schrempf who is the board owner.
> 
> On Wed, Feb 16, 2022 at 08:49:27AM +0100, Oleksij Rempel wrote:
>> The node name of Ethernet controller should be "ethernet" instead of
>> "usbether" as required by Ethernet controller devicetree schema:
>>  Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>
>> This patch can potentially affect boot loaders patching against full
>> node path instead of using device aliases.
> 
> Frieder,
> 
> Are you okay with that?

Yes!

> 
> Shawn
> 
>>
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Acked-by: Frieder Schrempf <frieder.schrempf@kontron.de>

>> ---
>>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> index d40caf14ac4a..23be1ec538ba 100644
>> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> @@ -182,7 +182,7 @@ usb1@1 {
>>  		#address-cells = <1>;
>>  		#size-cells = <0>;
>>  
>> -		usbnet: usbether@1 {
>> +		usbnet: ethernet@1 {
>>  			compatible = "usb424,ec00";
>>  			reg = <1>;
>>  			local-mac-address = [ 00 00 00 00 00 00 ];
>> -- 
>> 2.30.2
>>
