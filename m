Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC5C4DD10F
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 00:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiCQXMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 19:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCQXMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 19:12:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D875D292D9D
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 16:11:29 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22HM3UU5031227;
        Thu, 17 Mar 2022 16:11:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/JMfq6bci+pxiP60gzqfacu6wGwhNOySIw27/ILND7Y=;
 b=JT0kBAXRklogmmtgWAWwbFW8d8v64GXel8XOfVqhtnyO/jo2lvKs6+RWmVcqsGApjH/F
 popesCBPnqaNI0F+DGGsW7t20aflJ5Vz87CEiyGEZmT7Tvnl4RYcWccaZwMkoCfvhGRd
 dCA+gJkkO4Fsj7VMaTQGvMrv+2gt9Hih73Q= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eutf001xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 16:11:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSJevS+pkFvbvUKThyNBg1rewWetuWqBNNhqGg0HOPu0sGzXza2+hDk2k4h4+LY+Eu2YYr3GVDgQPmPyERe2B5dZDZfYws7ws7odqGJf6K1AJQ749U8/OZ+y+NTLG+CNLb5mczWWhK0TyO9kFDar8u4Eshbse/pL6Bwj8xIbcaJAUOGzo0L8XuN2YQc2j8nLAqsrgqqzXCAKVFVv9fcpmK8z8plWCgW1cjt1HWSSC1Y3geMG+Xc2aXSyHhTq5tKN27ydufi/tGg4CQi2cUM2kYEqV5AcHQLTvLyzEd6nltYhz6nYdwcfXcPkaAu7KU5pQCheScTRhbpEWV+SwcK4Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JMfq6bci+pxiP60gzqfacu6wGwhNOySIw27/ILND7Y=;
 b=ggnVz4tKJmk7cuviuj2Icad9zG9uPhVEHdDgBVWwKJxtTeOwaqfwlRuYP89Y9ujV/XSzSgIkUPm4XSYoJYAOqvvJYfv+OdSP8Z0nsFUwJ162Ica49ar1iMwVgQxN9WzxDt81G62as4WsweGiBrEOU0+/yRXfrudh6FlCV5rgWcTo0Xbr3VBNWp4ddNZR00z7fUg0dlgiJPkZsde5DL44lzlzDNvJ2uajHi2NjpPAhSGuOJ3uCxGxCPi/w8VxHdRtlMBua5Ge+SZUViz9pl0bTNGRSetufFfPhRcz4INxZf6AxIZvcKAdGN1Ok5h9qri9nqKoeJmvaIjR2kSE8gFeTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2190.namprd15.prod.outlook.com (2603:10b6:805:5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 23:11:23 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 23:11:23 +0000
Date:   Thu, 17 Mar 2022 16:11:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, ycheng@google.com,
        weiwan@google.com, netdev@vger.kernel.org, ntspring@fb.com
Subject: Re: [RFC net] tcp: ensure PMTU updates are processed during fastopen
Message-ID: <20220317231120.3l3ow3vb7vgs6twb@kafai-mbp.dhcp.thefacebook.com>
References: <20220316235908.1246615-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316235908.1246615-1-kuba@kernel.org>
X-ClientProxiedBy: MW4P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::22) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceb74265-3d52-4a5d-ca97-08da086b7441
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2190:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB21904145D9C9DCCE5B452A98D5129@SN6PR1501MB2190.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLTo6H/zh1QW4U141uEYYrnnRcspAGnss3yVASekrpSuRG7LXrMhanWNjrxhGhGwAAo8N763dlWG4K3LbvPiI+y5SoN1a1pS88qQ+iQxj+Hn1K44pDaW2BH7TLDr44zB9IUtXOJwgYkvOvGI1ylmkaZpSO2RN13GsRhJnKzhek8lsb28XnkAG+G/L/ZIzK4rT5CFrSYwgh4rwA7Oikr1gDnI/3vSKjESk9YZxCF88rXfnUtBOYUSzY1CoulfdYIN9vOOHWwW81tPMgR2reROl3s0WSrOruo7eZiRHrab2eCuOT0CS5sGMBT/QlD6PkBk9xp+f9auvyenPUWcrz8yjShA0nyER70D9bAlV8u5P4RZ4Awx7MyXF8J7tjW6QduSuDnjzojZV2m8o/aj7NuQ1CWubdAAKlTrEy2Rj0LjzoqefF5e6byQgcPWm1pGbF9GbgPuyPMg/vcVrdIxSLJNQXlcJR9fe/RadFDsUCyZSNBufA2q/EQh0cwKSuk6wgw18TaZ8qMOdr0pzOSwe6w6IpbQq+uSzR61YQYnflIegqsq4HffluZehMO3hr34eMhEPatpbF5N14qp55SyAs2R75IuVcMknMK49A6RSkTJ1WFJ3Mdx0xCeWmETlU1EmPzYPYEmotqzDgfWgCnUwydNxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(8936002)(508600001)(86362001)(4744005)(38100700002)(15650500001)(6486002)(316002)(66476007)(8676002)(4326008)(66946007)(6506007)(66556008)(6916009)(1076003)(186003)(83380400001)(9686003)(2906002)(6512007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrZOWVEjDm8EbjphnGN2jTtmWQZp+zeceBmgJUpar9XVA8/qFW3tlTKBqb5b?=
 =?us-ascii?Q?wpGvt9dOJBCmYWCTZmT2PmtB8StlQq8n30usqBHU0jnYwwtLt5N5Ijk9S2du?=
 =?us-ascii?Q?rtjDJ4WCweTEwZwuC4NElOQ8gIte2flsvKtYmSd8FFlirv9gXapTufSdpD/w?=
 =?us-ascii?Q?zSTr3CFbebSYLdWRw3yGM/waZHGl+07B5uXBJahvYrRyp1UO2lYlWL2k5PkD?=
 =?us-ascii?Q?RgMAAhRzur2zLeGKrAh4B1tG244EPRPf7ld2ML65mJI/I96EmV54JdNuKYvp?=
 =?us-ascii?Q?xOyFzQRvtFD7Gong4sPjBxeVv6PvVDEaN+vpqVGV8QYJNx3Dleo3rozC/WKl?=
 =?us-ascii?Q?BzrrrE5I3tf+FlB4JNiSKu9JQGy2315EaVmlHfnWWDUAHcFNLavmE3sCl2Ob?=
 =?us-ascii?Q?8YI90DO382k7gDUShIoBd4M3VjdRWhx2U9AYF3CjiwRzQUBE9g/KUZM3w0FM?=
 =?us-ascii?Q?/WQjdvwweVZwX9p0iWbC7XUQUQPq42gaxuHHku2sw0oXZCv/8rzd9ArAc2i1?=
 =?us-ascii?Q?AlvBUoHlpewAKM+K67lcC2kw7iikCUFOH+lyFyYJEmVgX9Kj86cZIOfGGawF?=
 =?us-ascii?Q?b0XHA1YBMYwxTHVETUl5e1cH/J4fAWVLKNWjEolO1vhuS8+HT4rl+wCYhj4q?=
 =?us-ascii?Q?iHAyC4hrIkk5KYR61KS4LhQ6+1sxyMvGzEGtelMwNAeYm7EXtKk9DFrNHsUd?=
 =?us-ascii?Q?23q1WKymY/xe5R7GuvpS72HA7g3caME9eQZS+k3eBeSFbu6EyUQR4XO3kuRK?=
 =?us-ascii?Q?0U3xtbVCfrFPoHKcu5BFCOAd6HjLF9+YZVY383NMV1vKwR2QcqXyfSp+zpsx?=
 =?us-ascii?Q?BXbRymoKX61bNWz3jXDNZGUjKAW/2mgGu5/T3D5zTKQCuxRJqcwYfBZqcgr1?=
 =?us-ascii?Q?Izk/woujFgPj5JzPNcXslR28eePjRt8Kbl++ahkQOvOMYA9oivQ0hMwtnEwV?=
 =?us-ascii?Q?tvHZ+ifxW08BhJCHKYf4oeeTfSW3hAdjKCgcgrHGw3t+4fLe13Hi7pIGRLVp?=
 =?us-ascii?Q?AAALVifDUA8Nb/2WE+Tz/SXB2ZJsSbw7Smtm4/KBkX4G0JRIiHXWO8M/kaV2?=
 =?us-ascii?Q?J44PC995Ft+NpKvoHf3ZBq8+TzXFYZG+2pZslHnS6QPwNFw/zKMkG9V+lhOw?=
 =?us-ascii?Q?okEerqIPSbLTryEIMz1OUFk6j2Lw5VsweD+hXhv/TraSvqo9DgcFyptyL/Fi?=
 =?us-ascii?Q?aPVDT1P/XHZncdAxB68DNBsA7I8/WIwkTQGXbz2AFKgXoeTKt4DJaqng11hU?=
 =?us-ascii?Q?4xSGb1l5wvsU6mkcGZmgHYTMAESLJz2kbLkRCp0/7LmffFjKrOgC21YwbRo2?=
 =?us-ascii?Q?/vCylSwZeE/ZeVxbYKGitdobYo30RmfEYYqXLL0FtHiWjrZQoOyMV0ArLcPA?=
 =?us-ascii?Q?2NuBlrPNJyBryXnQ7zpBTKkLbWHRjtyHbCOUKfsmmSTa2IO67iQQ0hom2zB0?=
 =?us-ascii?Q?OQjcGW6BGJI0EcUEEUgawK0WzFnIPqU0XIwweBSkSb2l8jkqXmNj9w=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb74265-3d52-4a5d-ca97-08da086b7441
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 23:11:23.3368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xq4sAzaDy3IrQ1CV7DNkXC7mslVOKlVHmoqooWxT75sP6z8J/Jxp1hj2pq9I1G4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2190
X-Proofpoint-GUID: bX8jmdq9BwpuFc89ni-lbj5Mv5MNIZU-
X-Proofpoint-ORIG-GUID: bX8jmdq9BwpuFc89ni-lbj5Mv5MNIZU-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_07,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 04:59:08PM -0700, Jakub Kicinski wrote:
> tp->rx_opt.mss_clamp is not populated, yet, during TFO send so we
> rise it to the local MSS. tp->mss_cache is not updated, however:
> 
> tcp_v6_connect():
>   tp->rx_opt.mss_clamp = IPV6_MIN_MTU - headers;
>   tcp_connect():
>      tcp_connect_init():
>        tp->mss_cache = min(mtu, tp->rx_opt.mss_clamp)
>      tcp_send_syn_data():
>        tp->rx_opt.mss_clamp = tp->advmss
> 
> After recent fixes to ICMPv6 PTB handling we started dropping
> PMTU updates higher than tp->mss_cache. Because of the stale
> tp->mss_cache value PMTU updates during TFO are always dropped.
> 
> Thanks to Wei for helping zero in on the problem and the fix!
> 
> Fixes: c7bb4b89033b ("ipv6: tcp: drop silly ICMPv6 packet too big messages")
> Reported-by: Andre Nash <alnash@fb.com>
> Reported-by: Neil Spring <ntspring@fb.com>
> Reviewed-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
