Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280C16DE2E2
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjDKRn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDKRn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:43:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2109.outbound.protection.outlook.com [40.107.223.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697624C1D;
        Tue, 11 Apr 2023 10:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKOmZpMIafwVD9SqIMKmEFuhXQcuPfh4gQt2MKpKJTyKfUP6xT2gu0orK3T+W0dRlDFwGfLNyUadzt/OyAlUADNltadp101HQYh8EREbHzkyLAgNRsa8e3Y9vO/Yw1qzIGDsquQs+NUxMutKx65ps131qkgkqbVg0QXqc3gICHJn7MNtZFJENKLJZfy98+qmFPSKW9XCAoKtljsAYY2CJRYjAqgw6oBSvK0X7ESPvlR6Hiy/PgFAE5K6OFQPwgGsaHmH+CaYwPqITt4toQu+pYMHnfAp0gjcENGPJhlACx0mge63dQJvh1qRUblSVsQZ/AK6ZYFLMMB5PP+2mZjJyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTThCp7diPj0G0CkPEZ1Hprp9i3GNg0w6hwWPy296nI=;
 b=Duypa6AO2LoVOHs1a8E+Ba/+Z/SFqV1VqgSK5rJXDsyi7pEeA9674QJrFFQsztBkDXzMifOZpbSL55lsNg7Gyy8CUSlb6EdlmF/ZF8RClJRucal615iocvrma+GZb2Ph91HFG3qTjlwueIu2Z4TdLcalbvuqnnRnH66/bJGRibJ92A04zdTCh1cuyDi13GH0cbCEvPeEYURjg1nft8iC4eIvUi22ExLiO7Zt2KPa3uE8qJuO0cyMAdyXUwE59SfMVYuqGwPQFbEfKB7Hq5o6G5fB+tHbIFl9mVSyECc/W5bMTG4PiV2b/RBTCcRROwYTld/CUyIysFCUe8UfP1BjwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTThCp7diPj0G0CkPEZ1Hprp9i3GNg0w6hwWPy296nI=;
 b=KYkUT8lxUjDCX/62KV0OuH/rqNpNFHnjwgkiyhicGmcRw6Wh1f2NmstnFbSVaU6A2FRwn4RaGmOPeAOBRxGf/6ElU4oLnsCNSOP+TsVLB1LT8Oiye6qaB64kJxrG85r+53cQDMjNjfBceCjR7ePGgVKhLqlJrgov3ku2dVd5UO0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5995.namprd13.prod.outlook.com (2603:10b6:303:1cc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 17:43:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 17:43:50 +0000
Date:   Tue, 11 Apr 2023 19:43:39 +0200
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
Message-ID: <ZDWcSxNivNUHyDOR@corigine.com>
References: <20230331214549.756660-1-ahalaney@redhat.com>
 <20230331214549.756660-9-ahalaney@redhat.com>
 <ZChIbc6TnQyZ/Fiu@corigine.com>
 <20230407173453.hsfhbr66254z57ym@halaney-x13s>
 <20230410212422.2rztlqspw5vjtb4d@halaney-x13s>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410212422.2rztlqspw5vjtb4d@halaney-x13s>
X-ClientProxiedBy: AS4P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: b480b3a7-a92c-4615-8585-08db3ab44f0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYgVz4fr08fEhb3eklGSrGNH6bWmLehMNl+4AWqJYoW+in5wzLV0+J+3A3a6XXV1cv27FZJGBGNHEWZB3rOWWl0tYSpTwcVIxSFc4aUe9n4dblk345o8MsowJKdLTSD0oqBmTI5XI4PeY34n9aKW1c8+GeA9u7ImUwLPTM0Typvc6y39AgEWAQvkRV99paptyfBUIt7PrxdReRzVglCXRpIUtIui1vgopoDAMzsITk8U2XCt4zuSvBlyelgfKW9I/WSZOp3hbQHaSRelAJ5XisB5hvtJ05hICm1mv/N6pjM/Sx3xRTlSd3r5nJpfObSY4PuhxYi6ieOB3vNN4fAB/s5MNWggHPN2GZEzKT89p3sOm/N/IvxaI2TsruRDUAJf26ZTrmWPlJaZzJxe8SAX/1ghh9Odo2fvIyQ2jzeaZaJTtQE9aelcvMJ5eEJBKtfwPRCHaCksK5AvOxfODGTNsvOOzbV9kuj1HjIuV4gxkyoU2E5jTWmsHthldrPn6CiYy5z5z9z7NqdOXNbrsPeyNNSvcQ8eo/JAA3DS5KZmyjU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39850400004)(366004)(396003)(136003)(451199021)(36756003)(44832011)(7406005)(2906002)(5660300002)(7416002)(8936002)(86362001)(38100700002)(8676002)(966005)(6512007)(6486002)(6666004)(6506007)(478600001)(2616005)(186003)(66946007)(41300700001)(66556008)(66476007)(4326008)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CUNX1cJ4HiSl1glHSAfvUlGpO45kduezSJR8Lggx5VImC2DjhG94itkhdhqr?=
 =?us-ascii?Q?EqOr9Bho7YiVUBUbidlWcPcEFtz892UMK9WVW7XRbNSQsq/sFT4DuHjff0oy?=
 =?us-ascii?Q?I7Xo3+sUE9L3c09sgLLuVQ+BR6N/xPXwJwxvqtI+VtfPNNk9zv5y4/74c4Jp?=
 =?us-ascii?Q?4/x0SRIK5shr0JpY2g991uFgAQ4rFiRduzpFM9yQIqGkpyGyKSaBKwA2IKAC?=
 =?us-ascii?Q?fxSaxG5I1liOAcdCUbmz0A6kQaReCDKzmP7njSUwV7AIfql7Xjzjk5JbPZfR?=
 =?us-ascii?Q?OTm0dP0XynVX2lPcDsx9JJewYpyQvEE5LoB/4/Bry5BQUfVwdU/MoD2Qg1Nh?=
 =?us-ascii?Q?uK2U61xC6oOUdkG8YyvbUMtP7NEi0m4atri1ojlYFDv9EsXWbHz3SAcEtAnp?=
 =?us-ascii?Q?HTpyZSZJtqmFLPO6oofRitckn/vSTKs7dl5/kinKH3DOQVNlgrUPHItevKD+?=
 =?us-ascii?Q?0chCM6sWofXPcpcTcZTwYYs33yk7AWDjrmMwmzMRWpQwu4P+Gw0jssg3EFi7?=
 =?us-ascii?Q?bl2M1BzFzinMMWCyeDKtwQQQKX5cx5/PrKvJNwqExODb3RINEx7FuqByKxPd?=
 =?us-ascii?Q?3QXPtTQAxoW0a6fykpb+xUKNyy0QRzlIk4/Db/yajyURdEqmHCfZyPxJQ07Y?=
 =?us-ascii?Q?uoOaWwpSAlxioeiQWhX7cN8SIlyuzO0QO0C4alwKPg6rMesory6rIUdo6p7O?=
 =?us-ascii?Q?squCNIqwO/kW+QC3mQrzo69cQsI/Wx+GmkTWyDTwldU1sAnbC+stf018ZvA9?=
 =?us-ascii?Q?KfpBoCM1cWZKW24r4DURi4Cfo4hETGjOB5K5CukSvgcValqXzmNyxF6AXuN3?=
 =?us-ascii?Q?5qokS4pEP+Lgbbzj/Gx0rRnD0UyLNf50U4DIHrdpR2AJ+85l4ds055pYwmYu?=
 =?us-ascii?Q?yfFOv7AEWeibYbaQlTpqwKAs93BsWscM4gAxgWYmBL7bQ7n0nIL9X68SMYMt?=
 =?us-ascii?Q?2V2UUaRP7g+39WbiSdk/dbER4tKFKhsluIUiqYZB0YtDyJ0JM+5jX347LREA?=
 =?us-ascii?Q?M5kPtp9Vctlde6IP6MCFv54fYeNDxvc6gT33zXwFW0kxbd21rz7eKuRPviUm?=
 =?us-ascii?Q?jO9veo1jBFsLv2pv2ccIGKA25M4XvEHp2qW8VLqdGSq1pcwoj6+VyRU7Ddck?=
 =?us-ascii?Q?GuOQbl7lpys9m1zUSx8UHjW3ElWaI4mVF/86DWjxvVVgatfhCeOKp1heqTws?=
 =?us-ascii?Q?MdekN3l6EyqnpVbJpIib1tsW/hoeTwOI27oxU1OwdzjEyMG5+vu0nD8kXHV4?=
 =?us-ascii?Q?LsJEUSd8Yiy9NI0UoBvfBgkcFT3YX8VPPCItCcffCqkQZDn2k6wpAw/6mLzs?=
 =?us-ascii?Q?yiw0I53hbct8BmGgYqg1bVaGJwpcvnsc53Bag44/iF+Bb2yET3+zzabsnYfg?=
 =?us-ascii?Q?fqgoGjOz1vR4SEorvnCs/xIx9ViU++3HyVkvmcLcJML2fNerG30XDvX0+FHt?=
 =?us-ascii?Q?dNTM6kEY96rvrhcxQ94ajGyI1CGDwB4qYnf54MT2yIcpDsmouxoY5gu/oYEw?=
 =?us-ascii?Q?mL3Lv5QcAeP9VyDW61j6ZtoYEYr/6UE4sYXTkhmhdKNeOtOXlq+E+3zaveCX?=
 =?us-ascii?Q?ictyRYORppVvmabY7O23XqwG/3cF93gXJcmWc3XSQkhBRBgVJzK26zywggxV?=
 =?us-ascii?Q?gG+Qm0xIS8C6ifWdvfZz4mcl0svyPSg0oMlLk82N92oXN0cqcc+uvXznZiyU?=
 =?us-ascii?Q?/hIhbw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b480b3a7-a92c-4615-8585-08db3ab44f0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:43:50.1006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1rNNDEZTOMkOzp/UmG2MGW5S4laPu9dhOffChMPHCcUowfNm4qgElAZDhG53yjCqQipilbLtNOCp34bTd4Q64jqd+Qr2+p792CGXgAt44k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5995
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 04:24:22PM -0500, Andrew Halaney wrote:
> On Fri, Apr 07, 2023 at 12:34:53PM -0500, Andrew Halaney wrote:
> > On Sat, Apr 01, 2023 at 05:06:21PM +0200, Simon Horman wrote:
> > > On Fri, Mar 31, 2023 at 04:45:45PM -0500, Andrew Halaney wrote:
> > > > Passing stmmac_priv to some of the callbacks allows hwif implementations
> > > > to grab some data that platforms can customize. Adjust the callbacks
> > > > accordingly in preparation of such a platform customization.
> > > > 
> > > > Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> > > 
> > > ...
> > > 
> > > >  #define stmmac_reset(__priv, __args...) \
> > > > @@ -223,59 +240,59 @@ struct stmmac_dma_ops {
> > > >  #define stmmac_dma_init(__priv, __args...) \
> > > >  	stmmac_do_void_callback(__priv, dma, init, __args)
> > > >  #define stmmac_init_chan(__priv, __args...) \
> > > > -	stmmac_do_void_callback(__priv, dma, init_chan, __args)
> > > > +	stmmac_do_void_callback(__priv, dma, init_chan, __priv, __args)
> > > 
> > > Hi Andrew,
> > > 
> > > Rather than maintaining these macros can we just get rid of them?
> > > I'd be surprised if things aren't nicer with functions in their place [1].
> > > 
> > > f.e., we now have (__priv, ..., __priv, ...) due to a generalisation
> > >       that seems to take a lot more than it gives.
> > > 
> > > [1] https://lore.kernel.org/linux-arm-kernel/ZBst1SzcIS4j+t46@corigine.com/
> > > 
> > 
> > Thanks for the pointer. I think that makes sense, I'll take that
> > approach for these functions (and maybe in a follow-up series I'll
> > tackle all of them just because the lack of consistency will eat me up).
> > 
> 
> I tried taking this approach for a spin, and I'm not so sure about it
> now!
> 
> 1. Implementing the functions as static inline requires us to know
>    about stmmac_priv, but that's getting into circular dependency land
> 2. You could define them in hwif.c, but then they're not inlined
> 3. There's still a good bit of boilerplate that's repeated all over
>    with the approach. Ignoring 1 above, you get something like this:
> 
> static inline int stmmac_init_chan(struct stmmac_priv *priv,
> 				   void __iomem *ioaddr,
> 				   struct stmmac_dma_cfg *dma_cfg, u32 chan)
> {
> 	if (priv->hw->dma && priv->hw->dma->init_chan) {
> 		priv->hw->dma->init_chan(priv, ioaddr, dma_cfg, chan);
> 		return 0;
> 	}
> 	return -EINVAL;
> }
> 
> that is then repeated for every function... which is making me actually
> appreciate the macros some for reducing boilerplate.
> 
> Am I suffering from a case of holiday brain, and 1-3 above are silly
> points with obvious answers, or do they make you reconsider continuing
> with the current approach in hwif.h?

I'm about to embark to the holiday brain zone.

But before I do I wanted to acknowledge your concerns and that, yes,
it may be easier said than done.
