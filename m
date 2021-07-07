Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123573BF20F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhGGW2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:28:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51676 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230313AbhGGW2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 18:28:52 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MHx6Z018761;
        Wed, 7 Jul 2021 15:26:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=E+F15jyVTMMlNn/8rrCIdUBd4pIgGbhQkpWeBEN7uMo=;
 b=e+rERULZ8z15bisC4dQxc6qO5j+t4auMxHdSzzj2eLY0gAo6fzvgkseJBCfgfP1LAYPh
 KUhOQFpFm01K32U2CW9TmMcRU7teX/9/JRNF3Iii88ukSMbaUHwi36bJRhhDmS4MZKK3
 DVcYVaftfijP5aISKdP4dkQwP/4cdb3rvnA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39mmxn3fs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Jul 2021 15:26:00 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 15:25:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7qptL6prclvfOoSZeDnDxokxqpddw32XaxYnNIRcxZLiDLiLT6at5pHhaQ63agYCmSVTWPg+gXcva9Fjyjzz4MA9y53xZxwExdDwblxYHN8gdoX9EK/eARzSau7d88siOe9kqfNt0yhIn9gLvtR/vto/Gs2zHJLZYKErM1wyWELREeO29L/isfHQwx/0JaO+jEQ7LwgZ1GO2Roef6mXwMEAyss3lVBRtVFs7ZweRyXin6HYsFZFD38SMiA+2OTKMQkKIcmlwqJyAF/qlhT4/L/z5Gszrcueve5j0OrkK/KzCiPCdpRyqpLOpP28sJixEpuowiiApEtRASOYHqKnEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+F15jyVTMMlNn/8rrCIdUBd4pIgGbhQkpWeBEN7uMo=;
 b=joj5o1Sde9OXvxhXlNSrhHq5Zj8rbcS5+ZX8W+xeQWVHSCiJz4E4tjyGTDiGgrXOjRV9cVQPxUmHB7aHalmcJfqnmrrNjbmyLfFY5iMgalvfJkL7+I4lTzgGEs6lWiqKZP/iEXmKyzmHhfS1+31SxjzIcY/OHUfIVnq0OpUqViRNYPA7AbfEVOTU7EMc8III+pWWNdcZc/WFw2mfpTnmkW1CK6CSyAGPV0ytlodd6CnsSn0eZ3olnbsJzCpmqQRR24FIUNHX2HHrYq2qFwp2ORiC6kRzdz95kJ0VK7LQ20Rd6mUQcwVBQSlT2okma5Zf6ZGfkzJLWkJN9p0LEjSM3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB4127.namprd15.prod.outlook.com (2603:10b6:805:63::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:25:58 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%7]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 22:25:58 +0000
Date:   Wed, 7 Jul 2021 15:25:55 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
Message-ID: <20210707222555.tdhqvvqbz5ocbrep@kafai-mbp.dhcp.thefacebook.com>
References: <20210707154630.583448-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210707154630.583448-1-eric.dumazet@gmail.com>
X-ClientProxiedBy: MW4PR04CA0358.namprd04.prod.outlook.com
 (2603:10b6:303:8a::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5a54) by MW4PR04CA0358.namprd04.prod.outlook.com (2603:10b6:303:8a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 7 Jul 2021 22:25:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f60e365-999a-4773-490e-08d9419631b1
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4127:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB4127568E953964C7F965C7C6D51A9@SN6PR1501MB4127.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VzvOxf6ywjf0BeZ31tskqioRnYt5K6PkLAgxlvTFyhLYGJjbZ5wtz8/GZt8/I+x/qzRMsPNIGw6NSbTdYIQGQk70C14NYrQHj8Of1qScFX6VMfHUruq/kXMkYZbDxtGbCrxRRo0UV8KGc2w0FO/9PTaPgpArn8Y3IqTM7eilre4V5YRR92n9QIPlIUNszq044JHuiyBhOCsQFz6hgtS/ke3Y3RvWVJDdhC3PX5kpoV5LxZKkEPPYMvCq/vDrIHKEotujd9eOzSevBMOkBxx/V90ctqVL9Rf/aA5CtGsrbNb++A01u0B9+VhYEnZt6xho7FvOmjUhRW3/r9bJDkuVh3hI6T92y01xvYFsUyF8VcEh8jAaGaKm1mKUQP7tI6qjMwqpeC01RtaX/P+QlhyowCsjcswHqjI6795/Xd5mFz4f1sdJIDgkl5eEmXKVr6P1VGGGVwtrPg50J+WcxLbAk1r5YxdrnoOpXkMDU9MUzuNy136OZiKA1TUGh4VMBBDMENrUFQAw70THmLPMuKiAS2YCSg6tPloNt4dr911Mtv0qDsxgnoaFvGv/r0BMlfqTMmV0IUyKzn7At+W2yonNBQHlY6UJ94naIlmzJd3n075IqW4g3C7gC7pftZ3IvJf0qbMu2Fw1fWAE/IwDHQMvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(66556008)(86362001)(8936002)(2906002)(83380400001)(5660300002)(55016002)(478600001)(4744005)(9686003)(1076003)(7696005)(66476007)(8676002)(186003)(4326008)(52116002)(38100700002)(54906003)(6506007)(66946007)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Jf8rDUOQsXhLsnIiUa7tJd0x42vpz8ewQ4sKnwMhsGqg+xk6mIfiIuos9oF?=
 =?us-ascii?Q?LxEf1PKfuTNP5vT0AUuzpysHQyPh0+H1lY8KO+7XYMkGJXU7ttuOSqOYrqR+?=
 =?us-ascii?Q?wvuQqVmMrg5ANWR6SJFBK86GAug3Q9YhZz/q4MgHGVlq1wKWBiCxWKcpxZxs?=
 =?us-ascii?Q?RlTm95si35stMr4g5/QywAV3ryFbbbiC+9/uE0KrrdVBkoK/HxuTgjBjXA6R?=
 =?us-ascii?Q?Lif80HauSa68o4pU4PcYH96RPdTQYGcbDSZIdiXOWw6V8OnvUR5OrBQF6Y+r?=
 =?us-ascii?Q?rjFPA4CziZgcBI+g82/Voe8Y0amnFHEMMAdAE6CX/KwOAG01y+ngeWpyFOxv?=
 =?us-ascii?Q?3mnYygtESPfN79navY9aX3v4INLYliGH/Dh55m2EqRUlxmsjmgLDxuHnp+Fg?=
 =?us-ascii?Q?DjzDh/nh1EqVsLXSthAWa882idSN9uWfsO7O3pbHgSxtUBwiNpuQUt279zdj?=
 =?us-ascii?Q?s0irmdX4V/hGk+OKHB5f7wgZSOvMyuQaNzxKtoaZtxQ8koB7jsLmKFmbtTOO?=
 =?us-ascii?Q?JzWMEKzhftDsgEP6PvxzQqpE4h99F025DqEUB7rpWgsJgByXxlhUtFnijE39?=
 =?us-ascii?Q?0RK5zyzdJVqejuqE3eq+xUJEKpBrCUAaLegZ78wNtPt7EIRVrERlNb1Qx6ZY?=
 =?us-ascii?Q?2qjvjQSckDBqZUyTvRQ+N7lL/LwnDUcDabZIpq2q9cN6/SP5AS2srwboPd2K?=
 =?us-ascii?Q?0cFv9kQMrKjrtPSbKXaz3eYP6tgzfn0EiItF9CQTCDvNniVLDbYdydVB4M9/?=
 =?us-ascii?Q?uf9a4u3x1LLHtGLxCEUrAnQchkp0mM7pJCfAt4Rp248IA56VAPBnn3sbGLj0?=
 =?us-ascii?Q?Yph3AYjxV8QI7xgFAjOZUnRUrn02Tw9/WWTw630ZkeYnadD0H6v0TbX6jsMr?=
 =?us-ascii?Q?q3Dxt8r6OY1dpMGNRiRcYx0BKInGH+VbKMLwRLFqDXh2I//FPybeUZUcwCe9?=
 =?us-ascii?Q?UyCMCE3wRVMaS4lI/YeoPx0St3bNS/kdkKFHkKMBaifY0HjDe+dxJEOL0jhL?=
 =?us-ascii?Q?3HdQIo0Tl1BnSMYTLzGl9qXG1HBKoJwwF6CBcM5JBx1KcoWyg8qZ83Ct/32y?=
 =?us-ascii?Q?jF+go+BM9uXdkl/RqD+h5wmtspaSgp+tk372egP8nwDvI6AJsoQhtQNo/yZR?=
 =?us-ascii?Q?boyfYP3kNT69Dr8BvmdcVHZSLY8i0L/G3d1OPGILqQeg9T+EAyDwB/MFdFbp?=
 =?us-ascii?Q?l4kH5USHRqF/2QdjyQ6B7UtWH6Bpl9Y+tLTn1kdvbLv5I1+08IwnBAq6GddG?=
 =?us-ascii?Q?3H/eBKxelHy6kRCNjry7SrOK6d2dFbCXvIqwZUhd0E5fXykZcycQKgTFlt13?=
 =?us-ascii?Q?Cvo18YDS3QDn6Yf1y1DKOaUGqD+MPr+sE78Mc5SSYW2YCw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f60e365-999a-4773-490e-08d9419631b1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:25:58.6328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ypr4lyw/5sCpdK7v07Bu1MPiur93JDJ7NCHd3e+KpmrJ68aZhQh09GJcYzWO/Ytp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4127
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: iwE2xbJhQrxLHCbqZ2cKY5KyJlQw7J8U
X-Proofpoint-ORIG-GUID: iwE2xbJhQrxLHCbqZ2cKY5KyJlQw7J8U
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_10:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=894 mlxscore=0 phishscore=0 clxscore=1011
 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 08:46:30AM -0700, Eric Dumazet wrote:
[ ... ]

> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 593c32fe57ed13a218492fd6056f2593e601ec79..bc334a6f24992c7b5b2c415eab4b6cf51bf36cb4 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -348,11 +348,20 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  static void tcp_v6_mtu_reduced(struct sock *sk)
>  {
>  	struct dst_entry *dst;
> +	u32 mtu;
>  
>  	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
>  		return;
>  
> -	dst = inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info));
> +	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
> +
> +	/* Drop requests trying to increase our current mss.
> +	 * Check done in __ip6_rt_update_pmtu() is too late.
> +	 */
> +	if (tcp_mss_to_mtu(sk, mtu) >= tcp_sk(sk)->mss_cache)
Instead of tcp_mss_to_mtu, should this be calling tcp_mtu_to_mss to
compare with tcp_sk(sk)->mss_cache?
