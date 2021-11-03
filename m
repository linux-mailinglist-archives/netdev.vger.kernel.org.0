Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A2B4446FA
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhKCRY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:24:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhKCRY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:24:57 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A3H62PK010837;
        Wed, 3 Nov 2021 10:22:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=G0krCx+nusd96owQ4zonhnXq6yGsjxO9q8wW0p8u/OY=;
 b=Egd6i+apgOfQMV2v5EkfKjOhs3OMORTfeg42GiNnD01+EVIuB+dNcHdYmWxeub+lMT3V
 3zZGyoMcEcppPtRoa0yF6mURt4vI8sPOvThRGMwvs2o3YyrihrZow7+Gfla52BXTWGfK
 Dgc5vspQ4r37gUU8lsCgpfyLxN1zn5ZzBeE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c3dch6s2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Nov 2021 10:22:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 3 Nov 2021 10:22:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWoyZHrRVZKl+PHirWroDuzxwsLzqS1DhvqqXo1YLeo/NDUhs+4emMgf5rJcSBMhBxSMFJCpSzp52Jd1KJsgCTVM38El5JB3Dgq54BsbTqcr0Xk0ahKMb+pm1P4ccWFOkVpPu1C9fv8suSwhSNxoeng7kHMOScauJExbWUuGfxrJLumz78j++FJJ6Nh540PHzbGywJIn+0jCrUK9RqCdLVjKhYzvhTO9F8cFPH/YEcJbRul4BCryJ1lybxWHWx3qtl1Xl7e8RZ7xUdkA2vCkUOYzKLkajQDJ6R1dZkKRWKFrPmvoji2fOqtNvxKHeekHErhkTbLVL1EEiiujJpO5Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0krCx+nusd96owQ4zonhnXq6yGsjxO9q8wW0p8u/OY=;
 b=TiiolY0o9MuwkhVK3lQietgHj4HY7Tv+PMxK7n6cWZfpS1oV1rJq9qwmNJL3+Ak2eMZtNZPCoR2aG+DNR9uPtCI0ZkfsH8ckSCPIzbsDrntPX+txHtry+ucSPWUm3cFTB9LWUTjM9rkp+9VbQLAvLXeYAFWRN8wxxnn9U6S/OeFQ3/xsMHVFH/vAMg+nRmsogHu8CkIXsAk3pl51JAM3FLusvlDsT6qtsZE6hTs3GWTKSvB/RZP3/kJB/qVqYOSbEKJubSHPpRA+lIgK72kGnAkGtbNDQ+hk4JZplSpUjDUOOsiEAiIh3LaqvBrgy+N2E8nlnZw0mxekt7KpkQo1bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: yandex-team.ru; dkim=none (message not signed)
 header.d=none;yandex-team.ru; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2512.namprd15.prod.outlook.com (2603:10b6:805:28::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 17:22:13 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4669.010; Wed, 3 Nov 2021
 17:22:13 +0000
Date:   Wed, 3 Nov 2021 10:22:09 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <ycheng@google.com>, <zeil@yandex-team.ru>
Subject: Re: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
Message-ID: <20211103172209.7ywfmm6zoyjxhqng@kafai-mbp.dhcp.thefacebook.com>
References: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com>
 <20211102183235.14679-1-hmukos@yandex-team.ru>
 <eb593fea-b5a5-c871-a762-a48127e91f75@gmail.com>
 <20211102231737.nt6o7jehcm7qzjbx@kafai-mbp.dhcp.thefacebook.com>
 <81A927CB-03C7-409C-BE3F-B37D24DA4FE0@yandex-team.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <81A927CB-03C7-409C-BE3F-B37D24DA4FE0@yandex-team.ru>
X-ClientProxiedBy: MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::7) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:791b) by MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Wed, 3 Nov 2021 17:22:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d98fa5d7-138d-4b96-f4f2-08d99eee79c2
X-MS-TrafficTypeDiagnostic: SN6PR15MB2512:
X-Microsoft-Antispam-PRVS: <SN6PR15MB2512FE2A147AF33939DC47D8D58C9@SN6PR15MB2512.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:341;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FbKy8KLR2Rn2SGbeyX8MkLWQdcPCjzE7eXY9K7JtyKn+CinDge7REFWhYoGpzr0Cg+O9c6JQncW8eZIiwtUAOwbDEZE1XJtbOp5NDz2ppu8vT0ypnjxsC9hOUzcppwwP3TxsWBsbZfeCPkkZhGOhKqQrybkNOS/+1nEUbm+7yiQoXgBJqGfYXL7y2ESxcq1yx6rwPvnbki42Bt+uZya+Lq3ZZv2PlZUctMaNDJlvCtqymCzyDnfsuxraOtjRXcyw56ksvM+LlfT9TgAa9GgYB6nNlno2i8e7bdHAAotk/MXccJql2z+QVI8Zoz54cMQJM2g6xdB1a2BAViM7PNx90lwBX90e2Q9ZSpOaFBhsHS9FlSR4eA8ap+O6+v/6k9z2+cdzSfZJZwACKsMGj0Le4CO6XeTkDoUqxHk4gUn42Q3lby6i+4/z1mPhpv2UrcAq85HWsBqjVgxqnDrVn5YnCtDQtqGt4pDDNen5wNnPffp+ornwUbB0z6VHaGEXyz8tmNkMVAb/KfeKBjBJKZCqa1rmacBdHS9SUglJ7pysHJ6UnLc0KUqpphx6YVduxa51Gx9QrHkpeLdWIBvkUckQCKD/osnEEHkSivTl3UbIlrLQdI5FOb5/HqDbcpnsBe0L2cgMi6eHbzz+d+Qql9dZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(53546011)(186003)(54906003)(6666004)(66946007)(83380400001)(86362001)(8676002)(66476007)(66556008)(55016002)(5660300002)(6506007)(1076003)(52116002)(508600001)(316002)(8936002)(2906002)(6916009)(9686003)(38100700002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0QO7m623j73hlyqNrbpoZhQpfajX30wycvGwZb9FI1DHrv8L89QsQEnMmz9Q?=
 =?us-ascii?Q?o2WtNM0O8OqgsFgTePSXRnk/d5PQ+SQBR6VySCxdDGRUbwBcukMtiQ6p5DUX?=
 =?us-ascii?Q?4OItYWmxd5Og3HiwXgz4BB/6gwGkR9qBoHRfi2F5rm+slDDebYcbAJ/VXhvd?=
 =?us-ascii?Q?u1Ar2V/AdZ48i2IXg3Lsj6KQmswALawcHrW3EE0W3Nn+UaphhIGdPEZ6fsR3?=
 =?us-ascii?Q?uf4yS5npdk4rBBTYM0rSXLYGW7iEDJ4mBlFXXMuZIBmWQZUIdeNv1YCiX9Pc?=
 =?us-ascii?Q?olUkliaordrLBcyzJnamUfYoy1FrXMSWXigOC+AU9sku8l01IPBbexuL9hPh?=
 =?us-ascii?Q?qYtjAWlpNagMuZpTGEMlwNMJw/ZsL5lLdUMTkfWDNdLx4eREHQEcLV7hqDZa?=
 =?us-ascii?Q?SCX66ZsdL/1cwVNnZjMNKw1OaziZRU/7WHF2QGiXBwQ3xhES/3PP8rroktQ5?=
 =?us-ascii?Q?DSsL4Aay9IV2V5GF2Vv2HiCdFxBErPWXEYU6nnVVFDEGcB24UC/LQJiMBcGR?=
 =?us-ascii?Q?h4W6nl5R67M/UcxcbiSiVltQezEh1YqeR9Bbdu03u0s2anVMKnQXrikFEzQP?=
 =?us-ascii?Q?JClzQzRjNHMjgg3m2qOcac2DPI8S2ntqZzF4hqIiWxB12P/NJEDdgP3zcsou?=
 =?us-ascii?Q?21UNRIOS77Tbug6xjgQIFKzoAOmCNwbfYrGpytxgelCp/HGZaHfmW9h4kgit?=
 =?us-ascii?Q?fxODjGg1y2GHex19f519HLnJrR+tagF30wKCDMvVyVHAgCsIylwDsw/jX3LL?=
 =?us-ascii?Q?7bfs6T4xl8igJUAYdsA7RhYRJ7i1pDzBpEBP4Bq4Yk9pGMZf06oAHq02A6bt?=
 =?us-ascii?Q?EOJGu4H/yUy9ETGJ1G7IQ68l3omKpsU4CdDu+sMDIWL/mCMVGbcn/b1IHRwP?=
 =?us-ascii?Q?oiDlc+PnN9t7579ZD1IP815fY+2AJsTNYiJjDeuWHEHuwdyNp9VICdLJE1en?=
 =?us-ascii?Q?9rND/eDdBD4a6gwpX2oQ8Uh0e81+t9Pi12u0RUcQ0nuNLoTdNqeVHh6ST2WE?=
 =?us-ascii?Q?idcnN5ls0bFWsKv9lMHZce6skyT267y6Dr0ixGmTYzkW2nXYmDv8UfS/SoGo?=
 =?us-ascii?Q?JeCjKHhHi5mraYcmiaeh1TfgWrpFT5at9dk3neVJfmB8Tlvt9Q1EYWYAUfOc?=
 =?us-ascii?Q?Qz3zGwywGRTsMv+naDie2mTXFenI7WKt0ssWgQCn7iPGh6rvuRHFig2acEfP?=
 =?us-ascii?Q?3VDJTSZ255bYboFtsaSDSUMqaBtFn7Vg617jnJwZfYB7O5U1A6DSNFSr+bdF?=
 =?us-ascii?Q?Jvqrgi0omhiMMxH+mGyj694x+N1WgayJtGP8blKW+1hA7vzFCNkBiAvXeMgq?=
 =?us-ascii?Q?K6cN4eezhOqDDl3Ur1JFcxCai+1T3cVHjDxMm2v5q1P7CPs78SNldvysjXMY?=
 =?us-ascii?Q?ZDT8JVuAJOMS/qAoTa5i4kL6S0dc0uFnlB4P/ck2myyBEFISbGr9LuBfeksG?=
 =?us-ascii?Q?QenwHSH9NYUAIg1Ty6Kvf+CezRJZSfpQ/yPk6UtR128jaPeTevVOZU5eS/d9?=
 =?us-ascii?Q?6XDkZ/OXI1j2NnDmpTofixICCMemEnJyn5dgN1wl8yt1ZKhcuKis5dpBZcQA?=
 =?us-ascii?Q?PGBYEwP8kyodlwSh2j5w2vp7gZYq8UTCXEs4/oyg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d98fa5d7-138d-4b96-f4f2-08d99eee79c2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 17:22:13.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8fxHm623b8ry8fk9XKHSl7N7BxE/zxrsapUNErWB+rlVhvfANdzz54F6pnG5ncI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2512
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ntNzVEIion2DpopqWAZQyun7t_Wtnaa3
X-Proofpoint-ORIG-GUID: ntNzVEIion2DpopqWAZQyun7t_Wtnaa3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-03_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=797 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111030093
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 12:31:46PM +0300, Akhmat Karakotov wrote:
> > On Nov 3, 2021, at 02:17, Martin KaFai Lau <kafai@fb.com> wrote:
> > 
> > On Tue, Nov 02, 2021 at 03:06:31PM -0700, Eric Dumazet wrote:
> >> 
> >> 
> >> On 11/2/21 11:32 AM, Akhmat Karakotov wrote:
> >>> When setting RTO through BPF program, some SYN ACK packets were unaffected
> >>> and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> >>> option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> >>> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> >>> retransmits now use newly added timeout option.
> >>> 
> >>> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> >>> ---
> >>> include/net/request_sock.h      | 2 ++
> >>> net/ipv4/inet_connection_sock.c | 2 +-
> >>> net/ipv4/tcp_input.c            | 8 +++++---
> >>> net/ipv4/tcp_minisocks.c        | 4 ++--
> >>> 4 files changed, 10 insertions(+), 6 deletions(-)
> >>> 
> >>> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> >>> index 29e41ff3ec93..144c39db9898 100644
> >>> --- a/include/net/request_sock.h
> >>> +++ b/include/net/request_sock.h
> >>> @@ -70,6 +70,7 @@ struct request_sock {
> >>> 	struct saved_syn		*saved_syn;
> >>> 	u32				secid;
> >>> 	u32				peer_secid;
> >>> +	u32				timeout;
> >>> };
> >>> 
> >>> static inline struct request_sock *inet_reqsk(const struct sock *sk)
> >>> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
> >>> 	sk_node_init(&req_to_sk(req)->sk_node);
> >>> 	sk_tx_queue_clear(req_to_sk(req));
> >>> 	req->saved_syn = NULL;
> >>> +	req->timeout = 0;
> >>> 	req->num_timeout = 0;
> >>> 	req->num_retrans = 0;
> >>> 	req->sk = NULL;
> >>> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> >>> index 0d477c816309..c43cc1f22092 100644
> >>> --- a/net/ipv4/inet_connection_sock.c
> >>> +++ b/net/ipv4/inet_connection_sock.c
> >>> @@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct timer_list *t)
> >>> 
> >>> 		if (req->num_timeout++ == 0)
> >>> 			atomic_dec(&queue->young);
> >>> -		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> >>> +		timeo = min(req->timeout << req->num_timeout, TCP_RTO_MAX);
> >> 
> >> I wonder how much time it will take to syzbot to trigger an overflow here and
> >> other parts.
> >> 
> >> (Not sure BPF_SOCK_OPS_TIMEOUT_INIT has any sanity checks)
> > Not now.  It probably makes sense to take this chance to bound
> > it by TCP_RTO_MAX.
> Where do you suggest to bound to TCP_RTO_MAX? In tcp_timeout_init?
Right, tcp_timeout_init should work.
