Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBCA6D31D6
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 17:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjDAPGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 11:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDAPGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 11:06:39 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2096.outbound.protection.outlook.com [40.107.96.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7216111EA0;
        Sat,  1 Apr 2023 08:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6sPdqBJBfqXIvulU8srVFrkuWntw0kAfC/VkyBDOg8NVrSYDuKoSvobCd8nFeCz3ARFN8dZ/Exhvbbs5zyKzPGj6JCsuliB0hJucvwxIf3MbSmQuUeT9V0RnYtaVItNF0pmKHm2cKYNG0+4T5vsYjexxePdtmLNCNedCcU8WiPaN2qhkexsvZ+NuTf3WFiFqELHazlQlS1USIuDoJHRyH6ZxxBcRlxlIbkLyCw7iAa2+1caJo84h4i3PW3ugXaPYwnQ1LSCk6QcqhqvsOKbnLzW8Z7zhu+HEM3u+g+z6/PTOaz7g2IaJUHnwZz9j/oJYQSU59jmu1aCKGNLGJ9hlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSvdWUxRhqVMRZjVYvUOvm7q8A0gdi9vlSZxmqDKm5A=;
 b=C+iGwyoGHJW9kDCViQE3cKcm5l/y6JPpVWi+tRB0fWMFbGjKO4BT0NnNrV7IUEgCWYYUysKo+xZsw2Tjhq88bwf+D/rrOLjeX17yPL03H/JuUQ8bbsfNSXI2gn3fpwNVWUfak9Ft0OkgHAA+h3QFlVeNPGrIDoeobqphFPJtMxgDoFTr6jBIhF6AUcXZNk+KnAGF3q6zxXs6GxV14vGoV77xS0t76HZ/8758qdiWgm1DwCF2tw6H1Xwn8RsLeqJbbK83Axs0uIGwJF/ao1I4TCZ/l4IWZ/e1b/PAmVtzQTijLGWGOybFTgUnnHnOHToXlC9/dIOCLUMc4m9xB3apRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSvdWUxRhqVMRZjVYvUOvm7q8A0gdi9vlSZxmqDKm5A=;
 b=qDaxKVHSp6i4yPdHKLG4SIsJJPmnvI1qnOVYLynNwjVZa6eSWWfQ/5WjRWsOED90AclOg0Id3oBJQsD4AndlQCMkxMcMV4R/k4eO64qeZbFYEVeaiSSJinhiGU7HGUPNLq5nwXTuv1vfjlA3BHE+xEt/KMW43jHemZq1AT3adcU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4477.namprd13.prod.outlook.com (2603:10b6:5:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sat, 1 Apr
 2023 15:06:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 15:06:32 +0000
Date:   Sat, 1 Apr 2023 17:06:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v3 08/12] net: stmmac: Pass stmmac_priv in some
 callbacks
Message-ID: <ZChIbc6TnQyZ/Fiu@corigine.com>
References: <20230331214549.756660-1-ahalaney@redhat.com>
 <20230331214549.756660-9-ahalaney@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331214549.756660-9-ahalaney@redhat.com>
X-ClientProxiedBy: AM0PR04CA0072.eurprd04.prod.outlook.com
 (2603:10a6:208:1::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4477:EE_
X-MS-Office365-Filtering-Correlation-Id: b3acb836-9e4a-4acb-09a8-08db32c2adb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uiP5TD3i3X17lFBHCbKG7Vie0xtBKPsIc50jmrztGu2XKEaFwOehgGCv1T2SvGbH0QkJlMdV6xrwJp6Eq2/Qt2CsFoFSZA/iVWHdlHl7WagUP7IyZO6bOCaRXTslpiMjwYHyTNFA59L8J4qB6Vp5N0gt6muhcdi+jmjg8fK91ep8OlmpScPmhpg16N1KzBiY4y06XbfilFQmaQ/G7PPxXuiOMKEJeVyLoxgDQbG+cvuZ3T1gsiZ/k05qbFsmL2853fLegxqmfvQo2Kaf8zkqfrNqujVGInT44nVOlR2+B44wUYDZeZ2uVlEYDImVJownePi3FzofNr/fex1QRZjudN6qUQ1KEk4euSsQcOkNpz8yFQHpYPTM8dkL60Gvwz8wHeZQEqi5+kbEvnkFnrVWTKvlaphXnz1AIw9yxPRnp0RtST1T7ePZ1+jxfhE2MOotBHBVN88bHh8gjfpnQJ3IpbCXbb6efN8XY+b0JpgpCBFtA94vGbsM9Gz8huaGdNLdTl6bIY2DA5GCekvpKzEZbAltt5zfkKccP4mC4jEEGaKGs2a1tzHnTkgFvc6puqitSsWMS31gJrD2DP1U8eqGVMn2ZcGu9Y7LatAw9QNYFZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39830400003)(346002)(136003)(376002)(451199021)(2906002)(44832011)(38100700002)(8676002)(7416002)(7406005)(5660300002)(66476007)(66556008)(8936002)(66946007)(36756003)(6916009)(4326008)(41300700001)(316002)(2616005)(6486002)(966005)(186003)(6512007)(6666004)(6506007)(478600001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uSc+dL60KxEs3RECw7Y+9Rh+7QjbHOgU1YJrIMkU+Wm700ptlI3L1MA0q4rM?=
 =?us-ascii?Q?vlVB5+XiaRQ1ZLb8X4h9vnDnQdEeybZvvPGRMnyRWylVFRmrH/uKeGgSNP/n?=
 =?us-ascii?Q?Fj4+suiMDk/Wfi+qbSMsZYfiCga4FGgAf0ERnr3mcW0wbU0dAgA86vhWiku9?=
 =?us-ascii?Q?zVRVq+vKxmlc0p4OchPOQKB1VsDAcS/0FJyaSyAj3NqMRrsEj+n1PY9l3mDC?=
 =?us-ascii?Q?R/fq5dHBLqSGBpYfvjXgqe0LlqthzIdqwkXUmpxf/a8gasbu64WeItVwYOGe?=
 =?us-ascii?Q?UxXTwllrgMS0r3P6x8Y0+4OAQ7274Xn4xZJNNXPT3xmFEHfDuixqgIGHlCC6?=
 =?us-ascii?Q?7G6iJNFCLn5Yxs+3Ufepj09ivxBlQIvaDBjIc4Fmz9ZVKmslghNFfi/2Fedc?=
 =?us-ascii?Q?Feylui5wmjWftI5ukRFNZ+IcHhO+YPSsfd0V+afppGKFGpYJoEIEaQkrCD1f?=
 =?us-ascii?Q?B/OBfoljJjtmGUzJl0jHEB+iEViTU973lDtJsjVTahjkIgP6rCQzXojbhju9?=
 =?us-ascii?Q?ICK8AOulJKGS2KzHgQV7bfZX+Rnf8bQbd7AXGRSJMmdd7TJ4N+YmOu3ox8lW?=
 =?us-ascii?Q?G0mZom990Da4DScdjiz2n4YV0TffwEt8EWuouak6U77H18+j8mp73slwak0w?=
 =?us-ascii?Q?qXOoQbJ8hSvFeWFWZ4/BHZcfjve1z3Z4QUJMk662n6nHfwJWXPPgGH9XlOVH?=
 =?us-ascii?Q?ckkFPAS+lnr8LRkmorSa4SJc2ysBdl0Ek0zMOIld7D9ZGUCQ9CB2I3FktYRj?=
 =?us-ascii?Q?K3vqSbEpgAVK1jYCLjoAO17t4z3xuNxdhvm6IPmKWzHMgQTzTTstwf57Oo3F?=
 =?us-ascii?Q?5kdX3ZNp87n67PLBpq13immFiN53nH6o/4vVl0mO+UZWz0eyTxYm09dod1R4?=
 =?us-ascii?Q?p6chkZQaGP7YcO24OjyaWrucyI2XW0RVemw6pjYDsxAcnMSF0YyTpoe3KqNU?=
 =?us-ascii?Q?0WnvRF9D8tyJKRlf2YSSdJANmd0mMhtnpumE5hGgZWlpMwe0DeXZewEzV4Zy?=
 =?us-ascii?Q?AhbYqYiODjROz7NjiY6ov7iDLm7A3yKi+9DXyBOXviIG3tknAWjzwJRqf+TQ?=
 =?us-ascii?Q?IpJ56jPJZi8Fn9QNFo1IgYAqfQj+At6+5R4IYjCPMKKHu5Q0tpksqihoOZ6e?=
 =?us-ascii?Q?uvT2dgSUFXz0RDk1hu0Yf3vB7kcvNQNGkDsHDZrSbso8NglfhfFt8Hp5PozS?=
 =?us-ascii?Q?8Fijso6A8Gg2vU+wgJM4lqeMDNMSr6R4bL0TQo+jjEOSBiZ953fO/Aiz5hNy?=
 =?us-ascii?Q?bT7ODWwR8tyGQqH901ruAxOMbimcew52Gty881KK8TSk5BhZH0FGK3Fhwc9y?=
 =?us-ascii?Q?obXWAj6OEnRqxfxb+CvnzamS8MsYdmfSt7xL/XSmxHFuv0SM6i8zZrwG2/7i?=
 =?us-ascii?Q?n7/M3Gec1Lfhe0BkZgwtV+rzPB0rW12eQhDHe1AP/LfQ6zycUGz37RqaIQy2?=
 =?us-ascii?Q?y3eXITxi12gsDVZdZj3H7shrmtYkl0K4narxYW/SPbTUpUYltNgYniFTsDiU?=
 =?us-ascii?Q?Ysd1Oe1ZdG0SmJUnH5omjXJBS/RcLeaKKqzO9I3DzZoRxS9M7jXbP78oosAK?=
 =?us-ascii?Q?s6MHy4hIcvWpY/+iJp3pXVKplm3l616nK21c3zZlw9S3kvjxH92D2tr9oPDb?=
 =?us-ascii?Q?imiWuUvVe8pEk9c+E1trpa8cLPA1rV5Gfr25wWJTmZ5AmWGDFwSUnRG9Piyb?=
 =?us-ascii?Q?/2gJMg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3acb836-9e4a-4acb-09a8-08db32c2adb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 15:06:32.5603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfDEYx0jK2juj/EFfHyY3fMcSkAPT6PzYWPbl2ocDED4+Dr1R6KS9w0tQRxiaNlwwIGt35kvLD0R8J4OhNxru/YC0rqs4bTOye4aq26c084=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4477
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:45:45PM -0500, Andrew Halaney wrote:
> Passing stmmac_priv to some of the callbacks allows hwif implementations
> to grab some data that platforms can customize. Adjust the callbacks
> accordingly in preparation of such a platform customization.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

...

>  #define stmmac_reset(__priv, __args...) \
> @@ -223,59 +240,59 @@ struct stmmac_dma_ops {
>  #define stmmac_dma_init(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, dma, init, __args)
>  #define stmmac_init_chan(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, init_chan, __args)
> +	stmmac_do_void_callback(__priv, dma, init_chan, __priv, __args)

Hi Andrew,

Rather than maintaining these macros can we just get rid of them?
I'd be surprised if things aren't nicer with functions in their place [1].

f.e., we now have (__priv, ..., __priv, ...) due to a generalisation
      that seems to take a lot more than it gives.

[1] https://lore.kernel.org/linux-arm-kernel/ZBst1SzcIS4j+t46@corigine.com/

>  #define stmmac_init_rx_chan(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, init_rx_chan, __args)
> +	stmmac_do_void_callback(__priv, dma, init_rx_chan, __priv, __args)
>  #define stmmac_init_tx_chan(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, init_tx_chan, __args)
> +	stmmac_do_void_callback(__priv, dma, init_tx_chan, __priv, __args)
>  #define stmmac_axi(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, dma, axi, __args)
>  #define stmmac_dump_dma_regs(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, dump_regs, __args)
> +	stmmac_do_void_callback(__priv, dma, dump_regs, __priv, __args)
>  #define stmmac_dma_rx_mode(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, dma_rx_mode, __args)
> +	stmmac_do_void_callback(__priv, dma, dma_rx_mode, __priv, __args)
>  #define stmmac_dma_tx_mode(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, dma_tx_mode, __args)
> +	stmmac_do_void_callback(__priv, dma, dma_tx_mode, __priv, __args)
>  #define stmmac_dma_diagnostic_fr(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, dma, dma_diagnostic_fr, __args)
>  #define stmmac_enable_dma_transmission(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, dma, enable_dma_transmission, __args)
>  #define stmmac_enable_dma_irq(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, enable_dma_irq, __args)
> +	stmmac_do_void_callback(__priv, dma, enable_dma_irq, __priv, __args)
>  #define stmmac_disable_dma_irq(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, disable_dma_irq, __args)
> +	stmmac_do_void_callback(__priv, dma, disable_dma_irq, __priv, __args)
>  #define stmmac_start_tx(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, start_tx, __args)
> +	stmmac_do_void_callback(__priv, dma, start_tx, __priv, __args)
>  #define stmmac_stop_tx(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, stop_tx, __args)
> +	stmmac_do_void_callback(__priv, dma, stop_tx, __priv, __args)
>  #define stmmac_start_rx(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, start_rx, __args)
> +	stmmac_do_void_callback(__priv, dma, start_rx, __priv, __args)
>  #define stmmac_stop_rx(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, stop_rx, __args)
> +	stmmac_do_void_callback(__priv, dma, stop_rx, __priv, __args)
>  #define stmmac_dma_interrupt_status(__priv, __args...) \
> -	stmmac_do_callback(__priv, dma, dma_interrupt, __args)
> +	stmmac_do_callback(__priv, dma, dma_interrupt, __priv, __args)
>  #define stmmac_get_hw_feature(__priv, __args...) \
>  	stmmac_do_callback(__priv, dma, get_hw_feature, __args)
>  #define stmmac_rx_watchdog(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, rx_watchdog, __args)
> +	stmmac_do_void_callback(__priv, dma, rx_watchdog, __priv, __args)
>  #define stmmac_set_tx_ring_len(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, set_tx_ring_len, __args)
> +	stmmac_do_void_callback(__priv, dma, set_tx_ring_len, __priv, __args)
>  #define stmmac_set_rx_ring_len(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, set_rx_ring_len, __args)
> +	stmmac_do_void_callback(__priv, dma, set_rx_ring_len, __priv, __args)
>  #define stmmac_set_rx_tail_ptr(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, set_rx_tail_ptr, __args)
> +	stmmac_do_void_callback(__priv, dma, set_rx_tail_ptr, __priv, __args)
>  #define stmmac_set_tx_tail_ptr(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, set_tx_tail_ptr, __args)
> +	stmmac_do_void_callback(__priv, dma, set_tx_tail_ptr, __priv, __args)
>  #define stmmac_enable_tso(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, enable_tso, __args)
> +	stmmac_do_void_callback(__priv, dma, enable_tso, __priv, __args)
>  #define stmmac_dma_qmode(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, qmode, __args)
> +	stmmac_do_void_callback(__priv, dma, qmode, __priv, __args)
>  #define stmmac_set_dma_bfsize(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, set_bfsize, __args)
> +	stmmac_do_void_callback(__priv, dma, set_bfsize, __priv, __args)
>  #define stmmac_enable_sph(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, dma, enable_sph, __args)
> +	stmmac_do_void_callback(__priv, dma, enable_sph, __priv, __args)
>  #define stmmac_enable_tbs(__priv, __args...) \
> -	stmmac_do_callback(__priv, dma, enable_tbs, __args)
> +	stmmac_do_callback(__priv, dma, enable_tbs, __priv, __args)
>  
>  struct mac_device_info;
>  struct net_device;
> @@ -307,21 +324,23 @@ struct stmmac_ops {
>  	/* Program TX Algorithms */
>  	void (*prog_mtl_tx_algorithms)(struct mac_device_info *hw, u32 tx_alg);
>  	/* Set MTL TX queues weight */
> -	void (*set_mtl_tx_queue_weight)(struct mac_device_info *hw,
> +	void (*set_mtl_tx_queue_weight)(struct stmmac_priv *priv,
> +					struct mac_device_info *hw,
>  					u32 weight, u32 queue);
>  	/* RX MTL queue to RX dma mapping */
>  	void (*map_mtl_to_dma)(struct mac_device_info *hw, u32 queue, u32 chan);
>  	/* Configure AV Algorithm */
> -	void (*config_cbs)(struct mac_device_info *hw, u32 send_slope,
> -			   u32 idle_slope, u32 high_credit, u32 low_credit,
> -			   u32 queue);
> +	void (*config_cbs)(struct stmmac_priv *priv, struct mac_device_info *hw,
> +			   u32 send_slope, u32 idle_slope, u32 high_credit,
> +			   u32 low_credit, u32 queue);
>  	/* Dump MAC registers */
>  	void (*dump_regs)(struct mac_device_info *hw, u32 *reg_space);
>  	/* Handle extra events on specific interrupts hw dependent */
>  	int (*host_irq_status)(struct mac_device_info *hw,
>  			       struct stmmac_extra_stats *x);
>  	/* Handle MTL interrupts */
> -	int (*host_mtl_irq_status)(struct mac_device_info *hw, u32 chan);
> +	int (*host_mtl_irq_status)(struct stmmac_priv *priv,
> +				   struct mac_device_info *hw, u32 chan);
>  	/* Multicast filter setting */
>  	void (*set_filter)(struct mac_device_info *hw, struct net_device *dev);
>  	/* Flow control setting */
> @@ -341,8 +360,9 @@ struct stmmac_ops {
>  	void (*set_eee_lpi_entry_timer)(struct mac_device_info *hw, int et);
>  	void (*set_eee_timer)(struct mac_device_info *hw, int ls, int tw);
>  	void (*set_eee_pls)(struct mac_device_info *hw, int link);
> -	void (*debug)(void __iomem *ioaddr, struct stmmac_extra_stats *x,
> -		      u32 rx_queues, u32 tx_queues);
> +	void (*debug)(struct stmmac_priv *priv, void __iomem *ioaddr,
> +		      struct stmmac_extra_stats *x, u32 rx_queues,
> +		      u32 tx_queues);
>  	/* PCS calls */
>  	void (*pcs_ctrl_ane)(void __iomem *ioaddr, bool ane, bool srgmi_ral,
>  			     bool loopback);

...

> @@ -422,17 +442,17 @@ struct stmmac_ops {
>  #define stmmac_prog_mtl_tx_algorithms(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, mac, prog_mtl_tx_algorithms, __args)
>  #define stmmac_set_mtl_tx_queue_weight(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, mac, set_mtl_tx_queue_weight, __args)
> +	stmmac_do_void_callback(__priv, mac, set_mtl_tx_queue_weight, __priv, __args)
>  #define stmmac_map_mtl_to_dma(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, mac, map_mtl_to_dma, __args)
>  #define stmmac_config_cbs(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, mac, config_cbs, __args)
> +	stmmac_do_void_callback(__priv, mac, config_cbs, __priv, __args)
>  #define stmmac_dump_mac_regs(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, mac, dump_regs, __args)
>  #define stmmac_host_irq_status(__priv, __args...) \
>  	stmmac_do_callback(__priv, mac, host_irq_status, __args)
>  #define stmmac_host_mtl_irq_status(__priv, __args...) \
> -	stmmac_do_callback(__priv, mac, host_mtl_irq_status, __args)
> +	stmmac_do_callback(__priv, mac, host_mtl_irq_status, __priv, __args)
>  #define stmmac_set_filter(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, mac, set_filter, __args)
>  #define stmmac_flow_ctrl(__priv, __args...) \
> @@ -454,11 +474,11 @@ struct stmmac_ops {
>  #define stmmac_set_eee_pls(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, mac, set_eee_pls, __args)
>  #define stmmac_mac_debug(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, mac, debug, __args)
> +	stmmac_do_void_callback(__priv, mac, debug, __priv, __args)
>  #define stmmac_pcs_ctrl_ane(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, mac, pcs_ctrl_ane, __args)
>  #define stmmac_pcs_rane(__priv, __args...) \
> -	stmmac_do_void_callback(__priv, mac, pcs_rane, __args)
> +	stmmac_do_void_callback(__priv, mac, pcs_rane, __priv, __args)
>  #define stmmac_pcs_get_adv_lp(__priv, __args...) \
>  	stmmac_do_void_callback(__priv, mac, pcs_get_adv_lp, __args)
>  #define stmmac_safety_feat_config(__priv, __args...) \
> @@ -506,8 +526,6 @@ struct stmmac_ops {
>  #define stmmac_fpe_irq_status(__priv, __args...) \
>  	stmmac_do_callback(__priv, mac, fpe_irq_status, __args)
