Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A66A6F4326
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbjEBL4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbjEBL4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:56:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BA649CD;
        Tue,  2 May 2023 04:56:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rgz8lhGyfrssJOBPIZuyNOxZQZ9XUusPnxMMU3fjzaMYIp8GkghHEhHQNazxWgjqGJPQUi5YK1VQel8q72hg0Juj7RMhAxKM+4kTxXey5YxEFhKyIiVpEtArshecMXv9pz686uC1N58vyd6/kmfykhDqk3/WgTO512PcsO3yaVA75Hod9Ka/6CyQSdYC3g+DzP6TNAUyhBmcOQe8wi1OGInm1le1a4QHJcAR5O51cCen83+7sSRen1hWpD9cx4DdltcPGAbYcMZOT26rtmHkqdDnU0xfOcX8OWQedWB9QbK3LweUw26qqHhLDVk1VEMLqZMLdDhZgJGTU7DWRwDktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHQ3YRkewuZS3erDAoZ3sSageix05zh6D7CDJQwtsOY=;
 b=loa5DJq496l245lFVp353QlMUXzsfQsouKXIbUNABJ92sgRtuza4tNcebNEr+37LIDpZLrv/e3nIKgfNbzBhfvWPuNnfgsiYufw6SiAOXkpwWyTITq5OR+LqlND8vsk6p6t69VCi46VhYLt9Crp/zgRabopUO/UUoS4J/hhBW25/PLnpclZHl8UTv/lZXXrLUs1iFX9xYv8uFcIgxH/TosnG7o/cXVne/hdzNefWkJEgxHSLJuNDPP+GaYIXq6ES9kvoI2OiI4iGrsS412IxAS8hrktGPzAyzJUeoeUMRIBsNjJo9ZoihM0rykX2PknyKTTAhNk85faeXEjafi/ACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHQ3YRkewuZS3erDAoZ3sSageix05zh6D7CDJQwtsOY=;
 b=JUHHvGFVVlXJz3ANVR3a778PEyA7S91m32KYvS4gTyMTlRBs63fHw11LWOwHXiqEUTKQzx6z0GOv0SB1U2BKDEUCPwiX3FooH4W8ReXfYYqVLp/mLDmvyAjTKttv4G4DqnC5mvvGgxDgucwca5SARTv1v2F4q7L6TRyx2ZYHy6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4721.namprd13.prod.outlook.com (2603:10b6:208:327::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 11:56:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 11:56:08 +0000
Date:   Tue, 2 May 2023 13:56:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Message-ID: <ZFD6UgOFeUCbbIOC@corigine.com>
References: <20230502082622.2392659-1-Ilia.Gavrilov@infotecs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502082622.2392659-1-Ilia.Gavrilov@infotecs.ru>
X-ClientProxiedBy: AM4PR0101CA0060.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4721:EE_
X-MS-Office365-Filtering-Correlation-Id: ec41c4d0-e8dc-4540-eacd-08db4b04373a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z129qO398j2dODTBBiaVG+q3EJj/Rp7Fo1DAWSKW8zeCzedCiHUT8zRhff2u2nvz7kdnkzcze7vBKt1dLlqDkMVRzBcJRv5JQSPvQN5RS4MWKUaSEYKyjNZZ4VwzTSN1fJr3e/IpTYHvHpNUmzSqsMif+RpU0H5/zQM8F/Skw4BlZRl4LzxDeJLVaeZFDHE/eoPcVfKwglRGGZdt3oThkEtQtLnDB5Qj+1o6wH2VA8ykyPXZNw92axICEAWBszpO4kzCmB9cdaqeFIP3LoYaB1WLZV5NuAiGPsC16iczzwHefvBQmIYzMHlHBEAiibome/4qNrS5gQSxmFEt2IMlgTW1IBYbv07J/cXuql0cXAtbmnEtRwxkKNKwNha31slGb6ZFWklT/7sGMxj5I9W5l1m8eWQ2840DuGVRpY6SEecj7s+L6WIzLuxBs5k2OOFzn465M3DhhUXR0YrXLFwk45Px6Ju+2pTrsqyMn55kT2KsFPui+tCBfZK/tC5PIekhEYVPkDyLrw9A2yeQGmCbXcDZKyq1BMkFpYTriJtxCfsMO1ncPGCtYqoUrQoFG0Xb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39830400003)(366004)(451199021)(38100700002)(478600001)(8936002)(8676002)(86362001)(66946007)(6916009)(66476007)(36756003)(4326008)(66556008)(41300700001)(54906003)(83380400001)(44832011)(7416002)(2906002)(186003)(316002)(6506007)(6512007)(2616005)(5660300002)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Na+DR/3S1I1adMnAdPP6PCYjhE8aqj+xeQG+/hHnwASUjDNgIL5zfw8CnN6V?=
 =?us-ascii?Q?OCfHa/pgQk+utvltD48JCupZ+nF24U6vVLs/mKkEKvnrkxdSJgaOF/7v5DIB?=
 =?us-ascii?Q?fN2hLkXTMtWgt3YdxHzPyA9tOKZppSrWyYDO2lnhIEIn9TuLOlVeJ11K9neK?=
 =?us-ascii?Q?0+BuBswvt9E2rKhfxculJ2uB3MvAvv0Vl8Mq8F7LlBm1ISRvMRXktNl5DH4Y?=
 =?us-ascii?Q?Alrt79f1k3nMDawM44cJzKUhGQ0pZSPeVlbcsWiRWVQlmLUJNOYWXcNucHWl?=
 =?us-ascii?Q?DcIX2v4e1ol6UUblb1KJd+O6/d/wbwaKAWkSVuCOdbiaXoVTTIz2e/zWCBY9?=
 =?us-ascii?Q?2JO5R3gHDgoPQPMSanAO6ckhATja5TuxWWVtimIfZpehVj4y7hVtkcGhOgst?=
 =?us-ascii?Q?6wbLQRwdA+8bEPuKWEUdRUFt0Fw0XgEEcInjC0HCTKKy/h0fKspsEat5NTLT?=
 =?us-ascii?Q?knfw3ygnyy3xo/y1Fwt++Da4nsBF2q4sP/j2KXdzslOnPAFgj+Q/P/o0rmf5?=
 =?us-ascii?Q?OChyfh+W/cl1i4LAfQAdPW7fRSsERPtJvPonw1nvSFe8P2w6a7kFuMUimQOn?=
 =?us-ascii?Q?gzqefVM5zwQd65FPZis9D1VGkkz3UdJOgYJcd8dRWv7EH03Fq+jX7BgsUksR?=
 =?us-ascii?Q?kYgxxLDpflsaluqUoW48bxKxgm09aVx64YFIQB3eCj7EZT/Y0viTOw9m8cgz?=
 =?us-ascii?Q?R0Uug9oDQanmzGOTcPiz5FBhI9r+lKObr3u/Y3OnpZsROJ8s9XLGvD9djmEl?=
 =?us-ascii?Q?RobnAJC4iKMiLkHVDv8awomWsHh8VwKKmi5qTi13IMlFwJ2dAEl96Pas1FOw?=
 =?us-ascii?Q?LiVD2oACBFSxNZGuSgENzQq9XW5Y08538q+9SJdnszNnj3ydaSb9yxgkG83Z?=
 =?us-ascii?Q?NhTew0nZRhiVnZ3Ldr+HCo6yKipIAII+NE9WfW3xfzAueEouYOdTJ0gg6vLc?=
 =?us-ascii?Q?IzLVNIdx9ik6Xp9TSYTs6tuP2MSJDjAHKRNzjIVXjeaCfj9Y087OzE5MWLcu?=
 =?us-ascii?Q?3FC3KkNKqoFRzLelhF4kOrnkyGPfSisqyMzuPSmjyewUvGFnKA00P1GDkZU+?=
 =?us-ascii?Q?eNsHWquGe/qs9fwVNlxZQHOlPNFcE6kkICRCMaN5ruwOfOATc0OYG6ufk0J0?=
 =?us-ascii?Q?S5TOWV2Tw6VOIj1HC7JGfVS/kPg8BN34hrA2yj8Id7m7/8wBfsgTKpC7+NhT?=
 =?us-ascii?Q?XYXHY9GT7Msx2ctXEqpnPLGJ7Pmj1zjTK5JDeqBiGXZeIhhacxtqjFuhzjxN?=
 =?us-ascii?Q?1gtZMm4tqw3Yuc08diVrnMIohI6dIpJX2oQm0C2cQcZslunK85enoJ7OyH5n?=
 =?us-ascii?Q?mcXYmQ20V5iyJ6XL+qK0TLch1LIt7R5580Gv9b5nveYkhjyfn37rFSMVzSsZ?=
 =?us-ascii?Q?P6M6G4Wl8sszevdeOe01Nipt8JUh3m80j29cRlL7IzHjswetJCJFEXuAT+1i?=
 =?us-ascii?Q?XRhgj48jOMFwFZLp/ZVZX58+npV6UaH8n98auK6zwitiZ3Sb2PskRKjXEla3?=
 =?us-ascii?Q?iOl5gdrpZUPpqyPazPiJ59bG/WBo/B+CkebtqshUxK+TcvsxDB4ub5ykWo13?=
 =?us-ascii?Q?n6s2Q75L0gD2s4BWJRluJrGdRHRjc/gdex94QXE0yeWmewKz+pxE5qNMfKps?=
 =?us-ascii?Q?t83ymq8v2WpPMWpWa7beQ47YzFEr+kqaCCi9o3BQtK09eaTqfjnVB7ZC182E?=
 =?us-ascii?Q?qWdiaA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec41c4d0-e8dc-4540-eacd-08db4b04373a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 11:56:08.2686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDDLd51b/H5uBWDLP5XGXWqDoZYFOrN06w6dFDu0vxGiFBai7ZVzxNCx0kkgWepCKavQ10TMn08FkHAbTNtS92adLOpHw6rFxm+2XRatqWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4721
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 08:26:30AM +0000, Gavrilov Ilia wrote:
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.
> 
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/sctp/stream_sched.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index 330067002deb..a339917d7197 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_stream *stream)
>  int sctp_sched_set_sched(struct sctp_association *asoc,
>  			 enum sctp_sched_type sched)
>  {
> -	struct sctp_sched_ops *n = sctp_sched_ops[sched];
> +	struct sctp_sched_ops *n;

nit: reverse xmas tree - longest line to shortest - for local variable
     declarations in networking code.

>  	struct sctp_sched_ops *old = asoc->outqueue.sched;
>  	struct sctp_datamsg *msg = NULL;
>  	struct sctp_chunk *ch;
>  	int i, ret = 0;
>  
> -	if (old == n)
> -		return ret;
> -
>  	if (sched > SCTP_SS_MAX)
>  		return -EINVAL;
>  
> +	n = sctp_sched_ops[sched];
> +	if (old == n)
> +		return ret;
> +
>  	if (old)
>  		sctp_sched_free_sched(&asoc->stream);
>  
> -- 
> 2.30.2
> 
