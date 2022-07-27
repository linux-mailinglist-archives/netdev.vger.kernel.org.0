Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB52C5834C8
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiG0VV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiG0VVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:21:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C0B2B610;
        Wed, 27 Jul 2022 14:21:54 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26RLAYvR020740;
        Wed, 27 Jul 2022 14:21:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gEW5GBRUudldNOLBj1/j37cRG4Kmi8IQn1RSVDGZgas=;
 b=lx5cHsuDz3UpMfaj/w6X/LnbIa3u2cSjPvwAHs8aVzZSwyTZTJs3PrsD1nYKkLRYoycR
 jzT28xK4Mq4cvBHZ0eYIaS2IdkWOUSf3JlnCFCOhdvXzlD+aYedlAJ9P9YpOOBWt6R2X
 2valL1ptqseWqF1yPc8BpEoouM3q4J5ykkw= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hjj4eb2j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 14:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4+9jfL3N17lJCvTz9/PMtKm78VrILNPGqg6drlnKxM0oV9tq5X0jZfnnkNxEDd1xacbHH3AgGe6/jL9I2CwSFDm/pr0AKzoprXzcddLlO3avMLN1McFbiE4xC+J7KgmLayQnPFUjxcp8sJzjwZB5obijVhqrQXpcTGXlwz40lkRR+4eZ4OACy5pGODfPzYzAYoIo7kaBxos0zO+InMHp+N/Fz5iZIDrsmv9ABq62IefKBZwYF97vjeUMKbIhnKuWXPkXWnASlCF4Nt2oZ3lI7xhcgKoDzWIeOV6uTH1k/95nSY9PuSlj7HYur61PBm4N9KoF54+b8a/YOk46MzMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEW5GBRUudldNOLBj1/j37cRG4Kmi8IQn1RSVDGZgas=;
 b=H39f+O7TWS1UNngi6FSrzoNrzWEmhM3FqygaAUYsaTpwBYEkT8ktZPsbk/f9TBA0coPiWhGwYPNeDyij12l0bgjysZDPlz6HoAukRyD7T9YEyJETghylHy3bRWP2AvQn6r49Hm9VyY7lJGGg+DBpHXw2OK3OfmHet9P9bLNePJu1oRilWFgS3duSP3q+qNTiPNmzkN2BDjhJO6YUJFFB/hIZw4RCNLSshzBOM1KoTwADDbqrELNOoLL3mRD/QlnEByn7BX/yNtyZVbhIJpeVTf/tZi2pSiDAAEAICQfD/KtNnFct9y0Yrcgb960e0udQe2cL4YfkMTmF9ewSiq+R3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM4PR15MB5504.namprd15.prod.outlook.com (2603:10b6:8:88::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.25; Wed, 27 Jul 2022 21:21:34 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Wed, 27 Jul 2022
 21:21:34 +0000
Date:   Wed, 27 Jul 2022 14:21:33 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060909.2371812-1-kafai@fb.com>
 <YuFsHaTIu7dTzotG@google.com>
 <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::33) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26e30636-884f-4276-0734-08da7015fb98
X-MS-TrafficTypeDiagnostic: DM4PR15MB5504:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ia3buLosKdajoWYI3WvP0wa7P7gxEE/tOlF7K0cVWwaKFBdduCMK7JiXCQ2BYjucPbX1ztR/kWl8hi8W9rjOSv/crFIpUbF+XYu6x0vUKX/O0H+tYI8WaP4vaJu3fxy2Kll1IHVeEKjrbvN3Iiw+2m4Mlm7UbqqOxb/QNmYxwRx5NeKMl5ouEtmhBglUpmSHtCV8PvQM+DS05lWi1vZ7t4QhXWj4aVKQfLNt8ltmhIEeOLPupAcP4p02m3nWvY8W+7wFGOQokJplcQMYE7HpSkg+GtJzmAKD2JtaKOljidWQ45AWmzIlVcIs5HXRedo0QnCVLAnA0Lv4Mb4SJyN7kpzKLET1f0f/vKRLGUz7ywN0lDDzNE30l2VHP7X3AovydcseFdRsd5IYFUfWg6a8ZitM1/vhU6g1s8QM8npRanCXt51sgosriFzkVk9s9EyPR7wuml3pIzlXLFG9zTKcR8kpET4oup3i+qWFrTf/bKMbGLPrRwwYxxpWGai1arD5SvCeaUD/h+Ib2RYVu7NXG9GJEyuxw6CeGioyox8JeswHNtkzT6HpwW31j4J7vivqIgNxVKkoG7iQquOaOf6pDEHoX18QmP2yogXwnBp5k4Ppm8u++qz/yNuICnJSjzI/lrmWLzsIDl5mJ8RGPD737jkmE2T7L347N7BYyMX+llOB4ji1qrQmmTP3ixAl/HKJVCFD/HvQzJmXCesnAh26iJXfTCAlF4k+gwfIspMGJHHxntKgWHaHvDEQPfLfulZy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(52116002)(41300700001)(186003)(1076003)(53546011)(9686003)(6512007)(6506007)(2906002)(83380400001)(6916009)(7416002)(54906003)(38100700002)(316002)(66946007)(8676002)(5660300002)(66476007)(8936002)(66556008)(86362001)(478600001)(6486002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gZdIY3oiyleegpkjKTsPgOHxSfeC0HW43JlsfYYA0ghC1zpTNBiNCtSsqPA5?=
 =?us-ascii?Q?ePPc3rVlddYi8NSV69dSgKMEAcVqkcRHsgMX+hk8ElZTzEGPROKkfPEdiN9D?=
 =?us-ascii?Q?aQrsPho6c0+P8cH2Fuu7I9eKEZgMP//AdUmOZRiXO5irqhhl0m10cNf7uE78?=
 =?us-ascii?Q?dRl0d36F5tOWZJVJu54uY5d0QBwFW+IFw3xFjlGfu5oUZST24lSR6PNUzF1r?=
 =?us-ascii?Q?Dq3rmbNBPeXq8Usd94+LtqBvGjEvvltniawlMXmdqOjdurUj5tkSWQj08umS?=
 =?us-ascii?Q?Q/d1VyJqndCyc0YgoXHQDXrpa2pHw4YxvX34jFHe7tcBgc/BpNI2movuBfcx?=
 =?us-ascii?Q?mEjhrR7nG8V+Vilv1GYBdfmwg1weLcMurrfP5DpjHG+UbaaafziLrRtA8Mzm?=
 =?us-ascii?Q?22wavuuBw68VTOyNgyUCZG6k1E6VZ4rwGqtOUQksnzneYXPop6mqZK7lmQ4O?=
 =?us-ascii?Q?K3Pag3p2rdaRWgWVG7pxHpAhrHmPOG9mH+1Mx/cYp2ZyKvO58CbtKc8Rk5rF?=
 =?us-ascii?Q?ZzJgPsIIeWvtBkOCWc5EpHh03OreJ7DjA0w4NiB4XAA63e00oHKR99fd2vo4?=
 =?us-ascii?Q?m4jSARQWfJvyU1+NV339yOfOg8RI6q4LXyGP7wXLUzfV+Me4Wy9pkyQnHxOT?=
 =?us-ascii?Q?MdtmeUuO0eWjPp+FnFWnb4KUlG1isT3uVNaZFhBLninvMlrBd2PlEf37tGof?=
 =?us-ascii?Q?c2FbMoaSWKhVv40EritwBD+hvG9F46DkVZRAY1Kx5YMg+cweUG8gHtye/sk1?=
 =?us-ascii?Q?4ARu25YiAPHJqaxlcmNm9qi0onLX+YYqpIZcgLIQ6IucLW37xFBohAltk8Jb?=
 =?us-ascii?Q?Ph22hR9lz8F1apzOHRA2VB4Z1aBGdwxYj1OfD6A96pl6GATRob7KVGFyREyK?=
 =?us-ascii?Q?W9bLXV7p4FSQw7WT/h5JPu12/hzj0gPlEt/ZJV/08ZPu7z58t8X6JfHdiUQU?=
 =?us-ascii?Q?vWenkCWQ4FHCHZOfqso7bscTsK3SK7piqHYiAUQklSY76DzhUk4Efmb3uO1d?=
 =?us-ascii?Q?oiuFT9mSyOjHy0hOB12pXpcZEfJuLwS3ssWRB/zVUzpZ3bnGtIPtlDm1Eja0?=
 =?us-ascii?Q?iBKkIoNTpdxKnBgDd/fDKVcLIASGCAp1KvSINn2v15gba2sHf/6GOW3LpWKy?=
 =?us-ascii?Q?1I8Xa5Adx6g2RFxhJM+wH7iJqeknfVpOOSvUR7rLHA7BQtS6QYr/WRjc9Lez?=
 =?us-ascii?Q?gAgvLnTubo/YBQWj/kn+AiXtHa1XYkYX2F1EzIMMclSCrbLUnSpdvGBnBf1A?=
 =?us-ascii?Q?Y+edN4iR7mYSrA60plhPk2x2eUoiN2UB9m1HU44Fa8sur1xl7Zv7v28AjaVb?=
 =?us-ascii?Q?zYM9iKgpQfKSgjkshz47YK3KnWrnxPwc9wRnzpDXa6sy4x5RCFmd3Ht0RtTa?=
 =?us-ascii?Q?QxpSj1QJkZC7psx7TX5162ruTxweL2PXfUli2TAhnKqG2pU3wMvxqGWKJZ9I?=
 =?us-ascii?Q?GhxlfT4xzV6DAcqfIrAXQVx75PMedzPt3PCeQZmYJShd4KGGyqA+05HySERw?=
 =?us-ascii?Q?MTjkGvjyp6Tz/e14SOF8FzA0Rx3CL9RcAVIFFxDIEt8dE6nr6gH2C36GP8f0?=
 =?us-ascii?Q?3uieay6Q2UdGcRz4xLTBc/b5Gdy+4ZBDO9VgXrWULUvbJVJGR6nmpJ/sfPCd?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e30636-884f-4276-0734-08da7015fb98
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 21:21:34.5421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdsY84ZBoEHkkgQ6wPxsNinfl3KuOmogzxCynbW8S5LbtvpbNotcP+lbjJz6N9rm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5504
X-Proofpoint-ORIG-GUID: -Zlg3WcQViASD1ou0ymdg37xy2IV6vAJ
X-Proofpoint-GUID: -Zlg3WcQViASD1ou0ymdg37xy2IV6vAJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:39:08PM -0700, Stanislav Fomichev wrote:
> On Wed, Jul 27, 2022 at 11:37 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Jul 27, 2022 at 09:47:25AM -0700, sdf@google.com wrote:
> > > On 07/26, Martin KaFai Lau wrote:
> > > > Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > > the sock_setsockopt().  The number of supported options are
> > > > increasing ever and so as the duplicated codes.
> > >
> > > > One issue in reusing sock_setsockopt() is that the bpf prog
> > > > has already acquired the sk lock.  sockptr_t is useful to handle this.
> > > > sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> > > > memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> > > > has already been ensured by the bpf prog.
> > >
> > > Why not explicitly call it is_locked/is_unlocked? I'm assuming, at some
> > > point,
> > is_locked was my initial attempt.  The bpf_setsockopt() also skips
> > the ns_capable() check, like in patch 3.  I ended up using
> > one is_bpf bit here to do both.
> 
> Yeah, sorry, I haven't read the whole series before I sent my first
> reply. Let's discuss it here.
> 
> This reminds me of ns_capable in __inet_bind where we also had to add
> special handling.
> 
> In general, not specific to the series, I wonder if we want some new
> in_bpf() context indication and bypass ns_capable() from those
> contexts?
> Then we can do things like:
> 
>   if (sk->sk_bound_dev_if && !in_bpf() && !ns_capable(net->user_ns,
> CAP_NET_RAW))
>     return ...;
Don't see a way to implement in_bpf() after some thoughts.
Do you have idea ?

> 
> Or would it make things more confusing?
> 
> 
> 
> > > we can have code paths in bpf where the socket has been already locked by
> > > the stack?
> > hmm... You meant the opposite, like the bpf hook does not have the
> > lock pre-acquired before the bpf prog gets run and sock_setsockopt()
> > should do lock_sock() as usual?
> >
> > I was thinking a likely situation is a bpf 'sleepable' hook does not
> > have the lock pre-acquired.  In that case, the bpf_setsockopt() could
> > always acquire the lock first but it may turn out to be too
> > pessmissitic for the future bpf_[G]etsockopt() refactoring.
> >
> > or we could do this 'bit' break up (into one is_locked bit
> > for locked and one is_bpf to skip-capable-check).  I was waiting until a real
> > need comes up instead of having both bits always true now.  I don't mind to
> > add is_locked now since the bpf_lsm_cgroup may come to sleepable soon.
> > I can do this in the next spin.
