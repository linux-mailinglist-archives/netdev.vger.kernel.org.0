Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033A26BAB55
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjCOI7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjCOI7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:59:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BBA62320;
        Wed, 15 Mar 2023 01:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678870750; x=1710406750;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0EmbmHQz9xt6c86A3zGSNyZhzudWtXEsjtWDWqoq4uI=;
  b=YuB4XaD2hs/xA/uPmSRyvg5dzUiO3CYd419YTa/SJZ218P3gzB9xKqXI
   YKubuEuCn/hdxPTQB0HU6t4VvK+bA7zlypznCc5svtyNeRkba5Egu0KYh
   eeMLov3lQ6SXfVaHhKz2V7LNFvtIuIFEXX8yWYDv+8Sml/KS3PwzvHw93
   suDKFGGpP7l8AMG7tqJ9ga4SIh9ov07lyR1JhRUX1s7Ix9MXQ4y5iBfPR
   xIxztkaonbw7hKGnng98nmQh7jHmLcnvOvwxZYheD2aeD+HchI6lO+LiE
   91fo7L5s7AP3/ij9BJe/cxh+gNfLmBf18hfpK35/0y/lXBxMx7Qykvv6P
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="340012832"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340012832"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 01:59:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="629381460"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="629381460"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 15 Mar 2023 01:59:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 01:59:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 01:59:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 01:59:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 01:59:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkZExllMY7UG3H3cJH3vq+NSPuz6RXKh9FsqowVLyVA8XOtjV1PeWaNpHfLPudNv3vhIuZVmjet3/FyP6tbaX+mz0p3Nlpb64GvwYpuql9LmNONgN6uzYNg+0DXZq6lQfFPnvelmiDEE1119yTlWRijgN0HizbfewocuWHGwHrWy2plvMy5RXvhOARcKHoXBcnBQ6Nfa4pRgkHnx40/uUF/0IdNeb6JT/2w1BH3p1DBZVqVdolLtKS+Fpc2uYEMiuv0w/p+jUWR8H5mdp9Kxwwe07VuY2We6SjijQ4iOW/+q3JSUpx8rltcxRnVrv9teNTJ9bQZXXLFEc8w2h8jnVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7BKwGUb2F08CpaYhRP+u9exTLJLRpahy1Io4ttV0/I=;
 b=P8PGe0Z6lXsXilUtzFcg8xvGzjqxYZrHLP1GVDQ14/bAk6tOBLnHrd8iaFwMgx726Daon7kVi37uPplbFgkuxN6a++0yx7OSpnZ/733ZWc/rD28e7PJ3mR5RMGu3VV/rwe4jkm6CN+v7m8CGvvIoD3ZWgBpsX/MbgMVHepVqNltzbTrcz2ullUOWPqyg7wZ9w+MKW1YNBgbqbd8D/OXBsuVQ4FhBQxAYxNjU2zlFeFoyuGAW/Y9vzbFs9fLqWmSwQVLKlBfYylDx+1qCJwJzIkL6xg1AlDQeqPMDIMq3YvL+/+qc1ZGu6W9PqQWyBWhAt8AxKUoySukMcKm/SNoY9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by CY5PR11MB6187.namprd11.prod.outlook.com (2603:10b6:930:25::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 08:59:06 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 08:59:06 +0000
Date:   Wed, 15 Mar 2023 09:59:01 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
CC:     <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong Boon Leong" <boon.leong.ong@intel.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net: stmmac: Premature loop termination check
 was ignored
Message-ID: <ZBGI1TxdNJHxPwtu@nimitz>
References: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
 <20230314123759.132521-2-jh@henneberg-systemdesign.com>
 <ZBCIM//XkpFkiC4W@nimitz>
 <878rfzgysa.fsf@henneberg-systemdesign.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <878rfzgysa.fsf@henneberg-systemdesign.com>
X-ClientProxiedBy: LO2P123CA0094.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::9) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|CY5PR11MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: a4fb88a8-6a3b-4146-dee3-08db2533885e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kn3+3jLsoFC/AP/o0TgUC5mlKr1YHYazm/SduFaiAKGu/11L76JBEkQeGQAZ8HonraERJTet/3CqJjnPNyHEA9r6TcIM1VGTpIroGos45Zrgfp4Mjp35e0FL+GFDhm2ilBa3rmH6EW48DC075Ig806XGfPQ0WgFQ2G7iVZH5oWcPUrAvTw+RFjx2aJWukT321k572hUGV4wcY0GayomT24madQK/uWJNP07EQiL8fUgwyB8QcCPEQAuMq4szPgMS2v1m9HNx8/38AnO9Ks8RSpJlP76YBlp/pLRdWTPscwhSWlwhcwVtExqU93UB34+/ht9ui8RRbqUQxH8fKHDJ6dy2FmG2AW5KtBfGo78SPw/bPZC/gEo+8oA33DqhW98nFzljqbxyXFwDGBNCR2/oRocr3q7p8juRPx9JiAVKcHrwnain2KH/qe9GKxdnXjRHojIChArNN+sSLIUXBIPKDSwmG75nZRmDbtMMpebjU+kjIJK4UBsvPIHr1PsPF3KekU+mNW/tqOKnNl0hWj0bYcXL7B2wyfugvzYvdmBCbvOaJsAMliKR4qtNjF3td5fRsrwOG9bR90KA7PmuYfR/QBEGs2hwZsJhetfGY0qYAMwgVd5IKp5GzcKITEaOxtju
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199018)(6486002)(966005)(38100700002)(2906002)(6666004)(66556008)(4326008)(8676002)(6916009)(66946007)(66476007)(86362001)(26005)(6506007)(6512007)(9686003)(478600001)(186003)(82960400001)(83380400001)(316002)(33716001)(44832011)(41300700001)(8936002)(54906003)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/OQ2qhGJOdU06WctPtkawk0izqCWIvUinWv2s2tn/FCum61kkFWYnM+jGLP?=
 =?us-ascii?Q?iUWCuFcEO7AYIPWazYyRQToihjF3SOcfgvqmSq4TRbvSDVYoHvYzM962Qewy?=
 =?us-ascii?Q?WWnIJR0Dot+qTFGQOyNgmUk3NsCdAmKHk/2/gVxEcoS60qKf860Kd657Bkj1?=
 =?us-ascii?Q?LOL334VImhg+gVn6BecS3iUOLqafR51olP418UC8p8/dlV65RODRI0evuGMw?=
 =?us-ascii?Q?AYpQEeajD3bNDCwEBMTLVE7xOeYCst3st0pGSi4VVBdBGrmR1BAvTZA8jasm?=
 =?us-ascii?Q?UiH10BjB0p2SnkhLyDkOkX7wDI01nxJFTAu3I0IX/qXBB+iYwqlHkSV88CxL?=
 =?us-ascii?Q?kKwHIqzTO+bmNdzyEEIGs1ke6thN3r/BdFSE4RHcKQzXUD3edxzQjShWGaE1?=
 =?us-ascii?Q?vXEzhPelOXgZsirMuyEu7l7wHugy1OImkjYOPKligNLCRd4J7WpETpy+h27R?=
 =?us-ascii?Q?s0fRmEjLZqObNUsrqoVHXm8u6VkeAS2Lh9R3yjLI3QCMwCPp3TC1Wc85sNa2?=
 =?us-ascii?Q?eVizJbcWYR9MeI4CwCAnkBXIHmdW6hHS0H/htlwc8Kmp7XxqDrobdcmdw6cd?=
 =?us-ascii?Q?DHa3naPdapPOvu2FBBystxnMSGE+RgwB+SJc/31fasIHFXmubMTFtZ/S9qW7?=
 =?us-ascii?Q?7OBjubBrB7GkIhiOCJrVdTDGMVCwx/00JSae5xnDoT3pmOzv3hyD/wf7wXsi?=
 =?us-ascii?Q?AysqRdmKioQin25582UhiwOAFwMU7FvP8bw3CVacNH1tNqRyV8gBPpDkKK9s?=
 =?us-ascii?Q?7mNsaANQUjkzviGpgaQeb3BasE05G4yfoR2+YMSvg504FScKTFjKrrsl0P4L?=
 =?us-ascii?Q?yOH9lgjbNMaRmD2eLn/TYT/T0PN77GXUTx1FjWAWdmqsnfUlSYHfQQREL2oU?=
 =?us-ascii?Q?VqKyOztz6lP/qZgmOGWtW9z5VyyEF6RsTXcby5fYP3AzfKmeivyqZ8egCiTS?=
 =?us-ascii?Q?F1VVjBM1hoXU5ZrPiACYxAf05w1w6coE7bY4LaCFuvXIhq1qy2s+VzYcBmMs?=
 =?us-ascii?Q?vpSoXG5InoVB/Eqlwkj4BgWx9KQKMiiWROuYl+a0Hk9YH+YUgVS6CeF0+aIA?=
 =?us-ascii?Q?+83YEhR5BrwN+CECHj47gUlBiteBX4x73P9AiKZOeNE5FanaMBB58Oos5NP7?=
 =?us-ascii?Q?jHelMzPLVmeGkFkqGwwgiLEoCZCbLV1tfrhlZ96EZLjaMeXejsWP/PwxgMyT?=
 =?us-ascii?Q?qBDQ2jZoZTAmsAeEAhsZj64YRs9lGRuY5Wnc3zu9aAz2jnsN+LcxVXo9WChc?=
 =?us-ascii?Q?oUK0wv99XHCUAjvYhq444j+ecjkAcTIzIM0zghsAxLlzIyHppT57fNWuZsDM?=
 =?us-ascii?Q?59DJrcSjQh0N0XfmE0oeu9kpkTt6fETHR+/ZyloQYSMhfw4AhsqOkeg0/QSB?=
 =?us-ascii?Q?uGykEGhJ+uO/Zw3k+LtfFw+cmMjwuwj+qzluIYi1Y+/hL3Nv3Ti3LLi99qpD?=
 =?us-ascii?Q?FbNcsQPFrCpnXm9w/lA5GitnpapnA8wocgSZE5r8AhtKMkn3V+7FL4E0WxSN?=
 =?us-ascii?Q?aVSqoU9KfZL83OFR9nHMB2BEyA1NvPXdlKuOdhZ24CBZljeB6nJZ2zCamktj?=
 =?us-ascii?Q?DObdwegk2zoAG6CQ3xDxYX6pEevGTmg0vrULBeZ/Oi4JyCRiGApdI7m+zG8F?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fb88a8-6a3b-4146-dee3-08db2533885e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 08:59:06.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4UG6g+U5+TWYkkQkpelJqugRqAQIFd17LmLS6UhJ7ymUNo5ceGHEexTKi1SAYuRJZKnFDAOkLhVE4MteJF6YCdGLXad/quU2vxzoPlD7ec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6187
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:01:11PM +0100, Jochen Henneberg wrote:
> 
> Piotr Raczynski <piotr.raczynski@intel.com> writes:
> 
> > On Tue, Mar 14, 2023 at 01:37:58PM +0100, Jochen Henneberg wrote:
> >> The premature loop termination check makes sense only in case of the
> >> jump to read_again where the count may have been updated. But
> >> read_again did not include the check.
> >
> > Your commit titles and messages seems identical in both patches, someone
> > may get confused, maybe you could change commit titles at least?
> >
> > Or since those are very related one liner fixes, maybe combine them into
> > one?
> 
> I was told to split them into a series because the fixes apply to
> different kernel versions.
> 
Makes sense, thanks. However I'd still at least modify title to show
which patch fixes zc path or anything to distinguish them beside commit
sha.
> >
> > Also a question, since you in generally goto backwards here, is it guarded from
> > an infinite loop (during some corner case scenario maybe)?
> 
> In theory I think this may happen, however, I would consider that to be
> a different patch since it addresses a different issue.
> 

Right, it just caught my attention, probably just make sense to check
it.
> >
> > Other than that looks fine, thanks.
> > Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> >
> >> 
> >> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
> >> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
> >> ---
> >>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> >> index e4902a7bb61e..ea51c7c93101 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> >> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
> >>  			len = 0;
> >>  		}
> >>  
> >> +read_again:
> >>  		if (count >= limit)
> >>  			break;
> >>  
> >> -read_again:
> >>  		buf1_len = 0;
> >>  		buf2_len = 0;
> >>  		entry = next_entry;
> >> -- 
> >> 2.39.2
> >> 
> 
> 
> -- 
> Henneberg - Systemdesign
> Jochen Henneberg
> Loehnfeld 26
> 21423 Winsen (Luhe)
> --
> Fon: +49 172 160 14 69
> Url: https://www.henneberg-systemdesign.com
