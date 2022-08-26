Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE555A20F3
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244874AbiHZGhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiHZGhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:37:37 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA558C9264;
        Thu, 25 Aug 2022 23:37:35 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PM4FI5007927;
        Thu, 25 Aug 2022 23:37:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qXNAl9U+2sPMBSoNFaPp5Qqmr4TewV/xwNvyPOOvlvY=;
 b=gzbGgFkVCNsbrIFRWZQTrZ/9wVJgSboa6K77fVIMJQUP97gS7zdnFPpZPkqBgd+VFkkn
 hW2NRyWa84SMxT299D+iNjD4f8cpO6mYBI8m8EGRe8kylJlBx6nroBlBGbxF+kDYSMz7
 YZo8gDqwuk7YEGwVgInuLM9PZUCpzZMbZWs= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j6cfwmq6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 23:37:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kj5GsEWFkCnpDHyeuGzm65sEE+lDBdosknKH1Jyi7nKgF4po0YKLGDE0bE15E8NM8JB28qJW7aWNcAFG3acJLZnmYStQs6+sQ3qEHRtoJM3pDo0OHXEAEihz+UgeANVqIpfGm+J4FahLGzEdUScbDahk41mjfig2aaw3+5iiy+1Wo512LW6i3MeVV7An+KKn7xB10u7EtXBHwOloJAY2beF3Tg9r7VBnocKXYBBBLxjv2KwmaajvpWVQRwaPx/ed+6TR+aMjcgypgqj3bEHqBJBogCO1AaUAAQB9UTAoYtrAJLzeT1bQd63Y5O0tyU2CvFnxzBLh99J/Lggouhlcyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXNAl9U+2sPMBSoNFaPp5Qqmr4TewV/xwNvyPOOvlvY=;
 b=IQdYuCsgusSJblfMKvYzzxVcz3YK+p6sPU/XfH08zFGRlSM9e225lx8xO1X+vvh+9UbfFiJA1Q8YARpUzx1ocoIGrS+/1ea23PRGrC/qsYqoETXaeES7n8QJhGzrYnr2wmaWEy5gBecWvJzI1DbX9LtN/6fei5jo/nhkU0Pjc4/YfObzpYWF0QGY1UjImpH+g9RsHLCuLMdYiVWrtJXFL2dJ0bfhgkiP8x1MdaYY24wnyOUAP7ejKxQeYvF3lHYXBgp9DAFv+19HN31lxr5AObQD/Z2HzfB8ehuqO5XWLJVsYxrZz8HzMeaN1F4NUw3tnbXVDjWV0fW9iTiDCeTLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BN8PR15MB2625.namprd15.prod.outlook.com (2603:10b6:408:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 06:37:15 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e%3]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 06:37:08 +0000
Date:   Thu, 25 Aug 2022 23:37:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        "brouer@redhat.com" <brouer@redhat.com>, lorenzo@kernel.org
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
Message-ID: <20220826063706.pufgtu4rff4urbzf@kafai-mbp.dhcp.thefacebook.com>
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com>
 <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <878rnehqnd.fsf@toke.dk>
 <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
 <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0146.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::31) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3d067a3-224b-4ee5-345a-08da872d6634
X-MS-TrafficTypeDiagnostic: BN8PR15MB2625:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tqsq7CkTlnWgYyNpoRFzHYf8l/yehgMAFyAyq+8GgI/6nyqTJ7mkJncx+VlpT11thEtSPf4w0FF3s9C16IoBkq43GuxLnRIq5ZsyY9BvhPWsTvCQ8b57NI+LiN2NQxgEElBXxF46PItFeM+9zTCYZit0z+AdQAToisj+ABG5/z+3mWuRi6z8plBzfPVrTGBp7Y9UnDh8xeaitQUgxlmr/L4670lO7jMZl7yo06Ij891LPSewfvckK9Oa22nQNFGjgfV2sxDIsiFPen5SDD2Fxfic2POEd67omJSYH4bKW2umEwme5PdjC9t/UbvFlvcPZ1iGBOdyf4G8GPqORjUM7Z4uYGyCbnac9bsBntrYC1yE6LxNxhtfjs83BQS+jIzC68oLLXh1YECfkCpvE58HcH3fmpSrCZjZc1BiruElyoF8vBt2twpOCcYoqeiiPZUKyoyiK3DP7wFNSxo2/YJZAskpEsGsdHmqy+Ubm+2aVGvCS+CkNTXrAnReHgNYo89zPJwqntKIi+pS6Gx7IlDFG7sK/2IMVk1uHFQEcdVHEZzzSzDxTxAFmGdrdAsltIPjYekZgIPej3trWTA3lOruRU2iz/ZLJEbXDHxmOS+MTPcoAW27zcuHTidC1pcdwVd5qVOPVW9ZhlKNtdE6gtZ5hCNXswR2XhMQmxdrU9OvPvEIuec3gW7NJxjq1WbrVKdxdWmeDaSABaTza9uEHYc1K7lDWob4hnzEQYcqUXuoYIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(41300700001)(316002)(5660300002)(7416002)(54906003)(8936002)(66946007)(6916009)(38100700002)(966005)(4326008)(8676002)(66556008)(66476007)(478600001)(6486002)(2906002)(6506007)(52116002)(186003)(6512007)(9686003)(1076003)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mvlh5DbyVxqUO13DheiU5oMDuvyj1apl9jXWYslIUKCN5Uf1NKYQuSC1mE6u?=
 =?us-ascii?Q?W7ZEA/Y5NWkediq8amoFbCqgCnyBwd7/lCmJ8lWya2P2VGViduizk/TJVZFG?=
 =?us-ascii?Q?4Cpl6di6bVKb5LgFgORZQO7v5oHD6DTryuUhv8oYkv39XXtk9UwkvcEUI/eT?=
 =?us-ascii?Q?CL29XFPilr/Ui7143jyGAiLTc8mwAU0BbsAO9OENw61Qgcf+kupP5Di2ftu4?=
 =?us-ascii?Q?o8Ex74DfbvXHIt85yVIx2KlS+APgQ+z2/juzHiRl4oY8w+tEvyS/+YrMqAP1?=
 =?us-ascii?Q?kcuWCKw/eov57p5sKTn9GLq4wkP1Q0zN2mu9tavLxD+8w4btinzgdK6kU5u8?=
 =?us-ascii?Q?PcogV5+ipNH8YmeNj+e1feHOxxpUEXpJfkFAFBbFlW/Urc+UBQVH6CFMyG/8?=
 =?us-ascii?Q?hCwGctM/ZynwIbE8oB23czv6YQNHx2m6TB8qn1+nrCW3UZhBhjYoZtA4fii0?=
 =?us-ascii?Q?b4wTEZWv7NynF4rXZRu/rMQqwYMSqm4aIxE8k3s/R0xhKwPNJ5GqPyREo1kR?=
 =?us-ascii?Q?8anhQwZGOYUIXGhBgP/CpUxItrHbqUGrkWZC0nONGq20+a7cQEqVicH/SlQt?=
 =?us-ascii?Q?IPxClAK9UOhmixgLNuEHH9QW+MPbWuBF4cAoY798pPxSJYkrXkvh3rSfo2hr?=
 =?us-ascii?Q?GJXYZzkX/p/uG06HBrwn7MNuLYVawlZZ4vo8DJcc7ZaH/iMN09tC2TgQ94+t?=
 =?us-ascii?Q?yyjdRE++tefutoWHBvy4NHtXh+kHEzxuBLavOynBT/ZblQ3rGsCHGrGR40H8?=
 =?us-ascii?Q?8ujRI8YO75ioVYsFvcWs0jkGeDrl/7uSJtVanWkF76rgW+HMZOa98V3LPOB5?=
 =?us-ascii?Q?ZZT8fOAuHwKOm38FxW936m8HcfFX/+JUrKM+cCYDTw32OepTYKC9S4FQOIja?=
 =?us-ascii?Q?/EDGcdMWkrHLzf32jQ1iBWi9A31lBhKIxY2pkGzgfFvgJZAKXz/TDTZoZj2m?=
 =?us-ascii?Q?nIvL6IXmS0lDc/Ui3nhkGFb4wUrBe6v8W571TVPC4bCF+OwEcuth+gVf75hR?=
 =?us-ascii?Q?ixNu6fGTtt0nOV0IG/FZbJuXkGiWwUPxZUsO3Ca4Nq9yN7pwwF+jsB4qxr/2?=
 =?us-ascii?Q?bj2uUehBmObFtBMTMP7P8dBhotB1Bz22bhIWl6RPpF6I1b+KPVPpNogi8mXa?=
 =?us-ascii?Q?vSaFtbu6f0Qdb1LBRzbW010Jh4E+gKuytmFBfJ4ah1zRE+AYwswARvjtMNvI?=
 =?us-ascii?Q?8TqcT3foYfNBuB8/4kar6UjYRbSiEV+LSb/enWr6JeNADKRUk1Z7QaJz0koS?=
 =?us-ascii?Q?nG7ecETfvqixPojOmOJqOXvHelctjZqn9UuppaWW41RTHaOx4zHThiSPEaaN?=
 =?us-ascii?Q?PpI5RmVYpS0F+z5rBRPYsDVb8zc0N5xDltNxZ/0j0vZ6jyuOjiBwtWO8qEOB?=
 =?us-ascii?Q?qbDCLSb0p3T+2x/BDOCo1mzkzWzcNs5HekS04OusAM6mZXfcw/vM6O+CUDgX?=
 =?us-ascii?Q?a7tSQooR9uoHiZm6bjzxsZltGBolFkRPHkiJxGpJo19E9dbpd3jGyJaHXl9m?=
 =?us-ascii?Q?RtJkaqXoGDOScBc9UDqGpsLEQMtEk/7xoXJss1fwiMgAA0wZI6FUgpSUtSbj?=
 =?us-ascii?Q?lzQOtZCL6MWx1IcjkzPhRio6sdgHzh2IJFAjhurGSWXP8zlOAX0ys6iXbSyL?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d067a3-224b-4ee5-345a-08da872d6634
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 06:37:08.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /V5cYrff78zKkeVPREzu2q2L93ddXeZcFQxAQ4oHCEKYicl/HjOh4cB8k2oS8Be+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2625
X-Proofpoint-GUID: GHk4nv-5ClBB5NY7ZwIlFNHgeMffp3KG
X-Proofpoint-ORIG-GUID: GHk4nv-5ClBB5NY7ZwIlFNHgeMffp3KG
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_02,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 01:04:16AM +0200, Kumar Kartikeya Dwivedi wrote:
> On Wed, 24 Aug 2022 at 20:11, Joanne Koong <joannelkoong@gmail.com> wrote:
> > I'm more and more liking the idea of limiting xdp to match the
> > constraints of skb given that both you, Kumar, and Jakub have
> > mentioned that portability between xdp and skb would be useful for
> > users :)
> >
> > What are your thoughts on this API:
> >
> > 1) bpf_dynptr_data()
> >
> > Before:
> >   for skb-type progs:
> >       - data slices in fragments is not supported
> >
> >   for xdp-type progs:
> >       - data slices in fragments is supported as long as it is in a
> > contiguous frag (eg not across frags)
> >
> > Now:
> >   for skb + xdp type progs:
> >       - data slices in fragments is not supported
I don't think it is necessary (or help) to restrict xdp slice from getting
a fragment.  In any case, the xdp prog has to deal with the case
that bpf_dynptr_data(xdp_dynptr, offset, len) is across two fragments.
Although unlikely, it still need to handle it (dynptr_data returns NULL)
properly by using bpf_dynptr_read().  The same that the skb case
also needs to handle dynptr_data returning NULL.

Something like Kumar's sample in [0] should work for both
xdp and skb dynptr but replace the helpers with
bpf_dynptr_{data,read,write}().

[0]: https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.com/T/#mf082a11403bc76fa56fde4de79a25c660680285c

> >
> >
> > 2)  bpf_dynptr_write()
> >
> > Before:
> >   for skb-type progs:
> >      - all data slices are invalidated after a write
> >
> >   for xdp-type progs:
> >      - nothing
> >
> > Now:
> >   for skb + xdp type progs:
> >      - all data slices are invalidated after a write
I wonder if the 'Before' behavior can be kept as is.

The bpf prog that runs in both xdp and bpf should be
the one always expecting the data-slice will be invalidated and
it has to call the bpf_dynptr_data() again after writing.
Yes, it is unnecessary for xdp but the bpf prog needs to the
same anyway if the verifier was the one enforcing it for
both skb and xdp dynptr type.

If the bpf prog is written for xdp alone, then it has
no need to re-get the bpf_dynptr_data() after writing.

> >
> 
> There is also the other option: failing to write until you pull skb,
> which looks a lot better to me if we are adding this helper anyway...
