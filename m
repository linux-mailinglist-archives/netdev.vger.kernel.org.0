Return-Path: <netdev+bounces-5267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC297107BC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B3A628147A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D075ABE77;
	Thu, 25 May 2023 08:40:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2195848A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:40:11 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2090.outbound.protection.outlook.com [40.107.212.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA30283
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:40:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Man8Mvy9jjkvElayNEfkShXilNfPu8zww45m41/4Zfxm74Wdl+PfwT3vIm8lkzUP3SroZw4NLL/ne3A+FT6S95ZjD/oPsvADXEDSf5QQ0WWs+CsW+XgjkJVLSQ/RlSVFC5IM95joePrukHJPSs7AMO98fGXuEcxwoqmnhib90oAV+O4V4VLukxY49bmHO9KLrifqbzUQaG5bzH+agn/LXXLSX2gvPUUEEAQLgPGHvKEEX4x1zHTSTe1QfJ8LQoNdQt0X/I635KNCTsVSTSvOkWoE/4+FPx5dRQuFLib6g1V8GPYNfFXU/FiqQIFxFDQ1L3qJNO70vjofnJPDPSpLtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gUFr5bm4peiCWLXkPghEJIewvdWfD0DXArkpx6zSN8=;
 b=GmVvwEKPy6+swdD8Y/7M7Vugvbg6AkgJ3O3M2pi9QDazwdHfxBf2UPG6C6Hd5CdeJAqTKpC8WXuZ6Jl7GIbkyIuvq8WwSK6NP8HFGS+HbIvX/znTaLMI4STIY0nbkXDJqfUtEHgdwkJE7HZVk+bkGp0CZ9DJhBZuAxtydbxODwjLjUhshGqISXr7Awg+DCApj7SUWPsDyIOkbQ3MSpIy2HUPU3V8Qs3/kq5CTyPu2oEMeMy5aZ21VGWvo9q1LYG6KqFq9V2M7NBkcxSIgEFH23QZr8VORaYak21qdbBZXqJb0xL5SotsW5yHy6FL88Cz46oulLj4D/vsFGET/V5ePw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gUFr5bm4peiCWLXkPghEJIewvdWfD0DXArkpx6zSN8=;
 b=uosDrhbjwH3LXyqhjYQCxMuyT0qVf0VwpvGlLiPZBVqotLKfcTdSg0u7vNQufFSbHzsxtqh9mx1FVapx31XFYKLdtVI3HwJw4sfz/O1gW96gelZwCGmKRTH7AD3d13wE1oQHTrYUYOlXF/YfhxTT+xEc+xCc768VhruQoJE/Vi8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4734.namprd13.prod.outlook.com (2603:10b6:5:3a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 08:40:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 08:40:08 +0000
Date: Thu, 25 May 2023 10:40:02 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Raju Rangoju <Raju.Rangoju@amd.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, Shyam-sundar.S-k@amd.com,
	Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: Re: [PATCH net] amd-xgbe: fix the false linkup in xgbe_phy_status
Message-ID: <ZG8e4h0jsUPyjLTP@corigine.com>
References: <20230524174902.369921-1-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524174902.369921-1-Raju.Rangoju@amd.com>
X-ClientProxiedBy: AM0PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4734:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf1926a-9bdb-48e7-46cc-08db5cfba508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v96z69VvBG/RVHeJhZLG3gPzdmLi8eYaupXi4031I3ZA/tm8n+KeqaZH1ZW8mLssI7C1EH1bxD13B6fVLLLfK2xtI0zRmmK1AM8qW7VUOR9n4QZV+xhCHycBD4gZtlPI3sOQsb08mrxaLVWCnHEFaNz6JAsdpkLbY40RJjJL5yZvF+Xx1kDE9AHow6ydTHDdWTqTLo6cpVuK4K/bYKl6xSbJa0CZDYUpnuOgEotpQftrpp3qrWzpD1mBmStXJCQs43r6a6EoIYlG95otf8DMPax6mQD9pDrpYJYqfL2bdHEuqP6gxxxXH8dlrvRu3yeT/SFRzydSeRq0wvGXgD1ehpz5/6pwrJMg+t1EmQcd/6sGXqg8Ox/tCHiIXq91Oq/5vKb7L4mwAKUVyzexK42MVhjOLfbQgmBZpy/0Ai0lBQnrAxtAY0l9hjTw0MuiOoxm34hFn7CjDZa+XioR1bbWxM/Oc3vKfOv9oV0wu8lCKmgmkrIq08sb8XIoFxZXNaPL0F7vjuvG6ES6NZ/cS8vfhrtfr41Jrv0NBytANbUpyyPSjxSSACHfEv2p8U7oX2vJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(39840400004)(396003)(376002)(451199021)(6512007)(6506007)(186003)(38100700002)(44832011)(2616005)(36756003)(4744005)(2906002)(6486002)(41300700001)(316002)(6666004)(66556008)(66946007)(66476007)(6916009)(4326008)(86362001)(8676002)(8936002)(5660300002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pRPrDpN0OlVvJ6ksFjLJzqLxOUQe95+rLg6wx2SMhWpG72RDYlv0L/0tAGp5?=
 =?us-ascii?Q?bGKWj0mUyomOMXsNoG3iMIHwJVQu1SuXDjUNTibVJvxjU0fi6/B0a3+YnoZX?=
 =?us-ascii?Q?+5bTfuyC3oHu3qdV6HqaOCAqVe4GAy1mMT9RUZ7CKhPTcSrJqfk4Rq8WvjO/?=
 =?us-ascii?Q?to36ePUgwUZ+uWm4P/Ng2D+w7icHlDSPpVjVcK6fTSE/WPs+nJ9kpHnQb6Wu?=
 =?us-ascii?Q?2loEyWWjVAKIF+nJ08gvp4aMT/qG2L/e3PozdV1ITRAPkwRE6Vqh9dwM7OQM?=
 =?us-ascii?Q?OnGwKtsMcH5nnQ5m7XXPSdIC6R3sx9ZNSnxAZzq+TqOA+uf644/g2A07cZco?=
 =?us-ascii?Q?h3MbPym9wxoy3yaKZ8FFyuUbqJC35vpp39xsCszCaknrkl17wSTAS9LtjCbk?=
 =?us-ascii?Q?dHM9OoOreDhFroVSWyc/YeGyScmMPGtarbpSLtm3Rs7ZghBE/5yp/I2w1RU7?=
 =?us-ascii?Q?iiH9PzJpCX7wgmM6gWVZWSs/1NBP/pjQtf+cxWr3DyfDfflumexbLimhQQX7?=
 =?us-ascii?Q?KCwbIyf8f/kPDSuwZ9+QxUxIZwUZI2XbayDwVDbhenHHSmryNPedL8k9LMUO?=
 =?us-ascii?Q?M4RtmvJrl3OKDKzeNtIx1Btc02zjgtt2opsIB3NQzBiuicn1gjWB1tMD1X9A?=
 =?us-ascii?Q?KG3kPNyJt7UNQPV+bUK5n9M6mwcpl3XH/dv5OzNZEG5vfvKqO045czWztZHk?=
 =?us-ascii?Q?yAnZ7yETqWF2oZbpaJ3sRDOJIXe6ss/vab1xrcOtXxdfRA/RNj78I/357UX9?=
 =?us-ascii?Q?Wp0KNW4TlnQACZpmdKPZSAQz48Nza1Q13XBRh8brlP+HL5dXJlWbmWPK7wsN?=
 =?us-ascii?Q?JH+2rsYINClsFc0NG3IjRnkOvzzFAwexJF6N+TAD2vmeXmxKODLa2usrKYus?=
 =?us-ascii?Q?T8kIeATjy5rkA5kL17qOOumpReKhWicIfatKOqmpz0DwpEw9derxoRUVjsIU?=
 =?us-ascii?Q?GlY6uJQNF5Lf2GKdPp2zr0rTmkLVX4HQn2V81a0VmaAthx9iZB/3j8otURSD?=
 =?us-ascii?Q?cmFw4cjM6oxQkasbGUe5s1RH/RptrfaezJVmEOgWTRiCcIWAsYVCbU1MPHV5?=
 =?us-ascii?Q?hVlcOMmQ1XtgHx2TTt0qcBGYrBV7aHBA8Wm1qe4E3OIZoFNoM8s3klPriSKu?=
 =?us-ascii?Q?fFaPaaXuBMct1MCNziXZ/mG/Jfo4+7OCimcAaxHhH+sSq+Fojc0Zyuaxcf9C?=
 =?us-ascii?Q?8CXVXeWHne9cL1GRAVMstujJOGkcjd7AkbalSCDG2uWFoJmS+H5Gbj7ai3CB?=
 =?us-ascii?Q?D5kuMKXiBm/fgFDoiiaNecBX1h8FHAPtMhABAhQx9hJslSIdLfe0BzGlhYCX?=
 =?us-ascii?Q?zOpKfJvB/2vXvrZ6c48BwlJhmj3b7hz3RaenjzOJizaK7EG7eTwxbSYcTVpQ?=
 =?us-ascii?Q?gUGq6Twd2U7rinKpKXnQQk4wHwXCzAdabPrGew1lrcClmgMk63g/T1uyPIMd?=
 =?us-ascii?Q?P/o7s9bLi1ubBtnfZAzQ6JdauQhS8W0FitFR4IAqGm4vV+ls86SgutQgLq8C?=
 =?us-ascii?Q?NCO+VvadPCCfMIccOEuo6QYHnqrGH4hIDF6hP65tmkLiEky+zWwYp7GQLzHL?=
 =?us-ascii?Q?nFVLGHY1Zn5fZBjPcLCetOLlcRUORO87f1EEVYDFT4LjcNyP4oTat0y88RQC?=
 =?us-ascii?Q?NNFSsnoTKewMS6mpYi6OFI3jkf1WHVqLSD0fOOnEc/rKsrkphZB/JVuxSCd2?=
 =?us-ascii?Q?t2mrxw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf1926a-9bdb-48e7-46cc-08db5cfba508
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 08:40:08.0121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFxA4tWl4Uj+hsYH6NgSUU56hAIg54zjWmmS8OPiSrolbVWA49g93cDA8tfTB6dEiw+/4AZSoDBRf5fnCRukcveoSsCXFC3OZbCv7krCpfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4734
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 11:19:02PM +0530, Raju Rangoju wrote:
> In the event of a change in XGBE mode, the current auto-negotiation
> needs to be reset and the AN cycle needs to be re-triggerred. However,
> the current code ignores the return value of xgbe_set_mode(), leading to
> false information as the link is declared without checking the status
> register.
> 
> Fix this by propogating the mode switch status information to

nit: s/propogating/propagating/

     It's probably not worth respinning this patch just to fix spelling.
     But please do consider running checkpatch --codespell

> xgbe_phy_status().
> 
> Fixes: e57f7a3feaef ("amd-xgbe: Prepare for working with more than one type of phy")
> Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>

The above nit notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

