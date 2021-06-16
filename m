Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A373A8D43
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 02:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhFPAPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 20:15:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30348 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229811AbhFPAPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 20:15:18 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15G09heQ014115;
        Tue, 15 Jun 2021 17:12:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KHxdhTgX73RLbtuFBJawRFp8vIxuXfBI7MMVDnbrNb4=;
 b=XOZLb3F0w71i0QyL41TnMCrl+B3ma6l7otcvQgNyc8cstqqBd++JBlKsg6FLh5NaRAzi
 InrYmUyk8WOqIxuBl+7O7B3YA4qneKiFihoHxHl7xSST5iQQhwx1aDfl8D+y97R0OadD
 ImEecgx86YqgGMJguXdukniTxjeAcgOAx8k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 396ef580b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Jun 2021 17:12:56 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 17:12:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNLfy2yXEWjt4ZTszVQfQ904xh971hY+UyGuFnSORI8yWWl2sUcbY9gg65yGXkLalX3H97yXOvKzNy9f+GJxszUah4IkHhHjn6+0mhzLFF9fyKOr9IUw4DeS1zbRB9qIrwp+aI9jC1HoM8X2zOz3KgcJ0L6c6hUWyUwT72Oa2/p4o/0lksE3KHJ2GsqJ7Fwd7BecOe09wH5t6Ar+06UdZpyLnVoLOs2unDoYo7ECI4wk5fWQG7fwfatjbyS7735N9qYHcYyWurQiCB+AtDxUW01IKH3y5JZmQrzEE+WlqEtFTbMM8k6aB1gs7D03KuzlmmjggfAC2HLQwfzdPSJ8vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHxdhTgX73RLbtuFBJawRFp8vIxuXfBI7MMVDnbrNb4=;
 b=M9XwS8uQdNYD6vN/YXvG8t+OmOp8zzePU2Vi+kLXFhJu+kkShiPtc6DObSHciLBuKhRJerMBFrbVj1QnJ8pHZw13hdJDOE6mW0mFX1wcbYqafcauZEm8tIu1oUT5Unwk7jySkvXOwJYyvEiXyKCB3XNyUA8tkJVADe9W+BBwweSjS8ghwLofEdjxmK8KrPkoKwubFh3oS2jmeeX/T6tzbvsIcnxQ/Br1GtewaSWWf0mwvVG15iZdei4HVK/0civFCyvaa+Mt8v/uwfaFDgc0Y3BjAIdYg2rh6Chnd4e6UklECiNac2ampT7D0v8mksQ6k4Q8e4JHIAl8Wf3QniTXvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB4127.namprd15.prod.outlook.com (2603:10b6:805:63::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Wed, 16 Jun
 2021 00:12:54 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 00:12:54 +0000
Date:   Tue, 15 Jun 2021 17:12:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next v6 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210616001251.atqtz54qin4z2pg7@kafai-mbp>
References: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
 <20210615001100.1008325-2-tannerlove.kernel@gmail.com>
 <20210615222501.i7uvj63jv5h4faz4@kafai-mbp>
 <CAHrNZNgAqOMDn0qnmbaY0d=h8RPDu_nFamA2t_o8AJxnsYFTqw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHrNZNgAqOMDn0qnmbaY0d=h8RPDu_nFamA2t_o8AJxnsYFTqw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:5306]
X-ClientProxiedBy: SJ0PR05CA0147.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:5306) by SJ0PR05CA0147.namprd05.prod.outlook.com (2603:10b6:a03:33d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Wed, 16 Jun 2021 00:12:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65c86e18-0011-4948-2e34-08d9305b7c88
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4127:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB412768E99CEA141D561032D7D50F9@SN6PR1501MB4127.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cFU7ZHnOTXBxNax8MyNIKIIY1DZuJtVpGXzzzs6LlMhR+sgVkmgsK00VCCwte3Wxf6wWAQCfRf84Bi/+GG+vy768Xly2mEFNR2Xh/ICisN+aJxBZjIojDYcqIlQmCqQKWHy+7y/L1H40Y3nwtUA+Z5kDfiqMgddJ3ylX8eoTmlRaR9VgiZEwZHqIEe4HPyY1eXfRKRaTJQ4orDqPBfnat+WkMVfbBUIfEjY97Y/KakRtjpVnj1KNP1cC+QDzy2ai4TeztqU6w4uztI3kwD8YFK0DPfzWGYNmCrcV3TVJ17HsIeZzmjTPJLXw0BCn8T/9bmdtbtkXPoweKAXJe+4UHu/6fPkrx2d2JbNGAhFaojQXuXf1si1qfVOPaL8DVMTMl9ZhEI5XN8Oi3fkPhAL7fKoHQDkmE39mmWKc+FtIRlgOUt6KtgqkO4I5rhM+zyVyWLbR68J4QwXizJ7LVailcLeSN/ZB00ZcZ4x9V6IsqEkM6EN2Qq+sjZsU2d2wWBeUtVIsgTVRPfrVUUzsJJUhiRUXVUxg1wCVzkaGTxgYA/j16R9ijlpXpZay2KkOBS2OBAOeL1WTQGfEA8P/TioGAX+89IaIDWsGVs6gn+S05tc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(66476007)(66946007)(33716001)(86362001)(66556008)(478600001)(6496006)(8676002)(38100700002)(52116002)(6916009)(54906003)(1076003)(83380400001)(16526019)(186003)(9686003)(8936002)(316002)(2906002)(7416002)(55016002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JwsUByeBvM4OyMxMoeev8bkEpqz9x34+add9C/6oAGaKBwh+piRIfIG7Xlro?=
 =?us-ascii?Q?JyCOdvv61coboCH7+VFpBVxojajy9nF033UyIXNfQbsj0zKREMtCGSflt0Aq?=
 =?us-ascii?Q?b8eKq8ahfZ3O0KtUY1h1iqhxXhDngWRle9oMBy3AhZqtk99vk/I6wa33f0/V?=
 =?us-ascii?Q?gN0HhP8MYlk8wOQVAZ9PKMV0H+h9fqshCjikhBd06CT6QNdoWZURnoRw87ha?=
 =?us-ascii?Q?ihvBFtULNm6thTNgPQZBjalAKef37cGLe1LJ9+HNANHVauCwXcNvedjKjTAa?=
 =?us-ascii?Q?XjlqiEUrb5wtUUb+ayTpGXhyYtU87RzVGGYvOEJ7BMChFyVmAaDNd8CIAIdd?=
 =?us-ascii?Q?MdSbf5gikn7E2vrR/Ffn/LhX8NjYtQJqbR2K6kbXT1fz60Rm0YT92LTdGhAh?=
 =?us-ascii?Q?H88z29zR9fD+HazFEMEWwpBMxSuCKB9O3dtfD5m2PMg/x6m0ho2eEgH4co/u?=
 =?us-ascii?Q?+764F9NdrbV35Uix9aNpIjVsE4cW1oc6K9DXZJv3w7v5aIouUU3FCPv0ga9z?=
 =?us-ascii?Q?zVMqouDJ4hIUAjbI0yQvORDmGOv9eOTvbcJt1HKRwdxgcWOv0T4QHbPNYR4e?=
 =?us-ascii?Q?vtGbj6PNPKXo+t6eabzb6+HcaZcP/beDsW7ytmu8zW8vhs9WiFEhi7QfgH5o?=
 =?us-ascii?Q?iHWGla98YHMjQ4PYZvh2oyY+17O9Fy43CcODH6oX+Qs3Ai8BlRFt/PdcFyV1?=
 =?us-ascii?Q?GVdwquhJKgmlt1qfc6EhZQLKaxfhJXAHWWcz2ogxsSPYZdHdRWu5eFWJiAWk?=
 =?us-ascii?Q?pXkNahElN1A7PAc+cXKTdpbmPvgGxLdV9s+3AswqMoLHSR5Rkk+wZ4gznYsy?=
 =?us-ascii?Q?ys4Bwnfv908/UO79EXaEPJCswxRxJA7LOwOdKhLiytYF/Yzrf7AQNbhv9vVM?=
 =?us-ascii?Q?SXgqk3nP2Fjc/Bf698VQBM8L1a67oBlmvQsLVZnhW2bsmHvolms8/l/+uznl?=
 =?us-ascii?Q?lOccr0DvL0EillHbTni7Ipbx7w3kAB7wQ8rJfx4xnJq7N6klCMQU2xvGdUWO?=
 =?us-ascii?Q?OLRVCtN2apVg6R4mWMCTtzdQcoWHxIKapj453NpH3IPbLqtauJLbzp7vwo5Y?=
 =?us-ascii?Q?xm8C3Ll4dOA6XK3ot6I8cyiGtmLSt32xn9N/uDf0t/fhwWEI/S60Bhwz+vw1?=
 =?us-ascii?Q?H20A+fX26BbeASURmOMgDYGRMfYfilxJQZgjqABuCLkkNa1PoGiKo+6HvSbg?=
 =?us-ascii?Q?aRvBE+OmfPwbBLHLDddc5uJ1p2DYVSLNZn/gXh3ar1OKttasp75MtTpJEORC?=
 =?us-ascii?Q?MFxa0TwgGrE+FG51eU4Xc2abCXdM8sL9HD25AB/xrsA/AbSlRx1haHM78pvd?=
 =?us-ascii?Q?Q8J2crABSZOuYFb9yvfMN8O9Tz9+odl6gFUInFogaxc7vQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c86e18-0011-4948-2e34-08d9305b7c88
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 00:12:54.0177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7DvKDYRDUis+qkCBXTFJiAwzwX2X+m3bfNfpzZthuTLkg91PwbiVL7mTB0ZG+sY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4127
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 6bdKuVh5GHZx-iJdDhXo7BVUf6aT0ii0
X-Proofpoint-GUID: 6bdKuVh5GHZx-iJdDhXo7BVUf6aT0ii0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_07:2021-06-15,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxlogscore=918 adultscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 04:50:53PM -0700, Tanner Love wrote:
[ ... ]

> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 418b9b813d65..e1ac34548f9a 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
> > >       };
> > >       __u32   flags;
> > >       __be32  flow_label;
> > > +     __bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
> > > +     __u8    vhdr_is_little_endian;
> > I am not familiar with virtio.  A question on the "vhdr_is_little_endian" field.
> > The commit message said
> > "to handle the case of a version 1+ header on a big endian machine".
> > iiuc, version 1+ is always in little endian?
> 
> That's right.
> 
> > Does it mean most cases are in little endian?
> > and at least will eventually be moved to version 1+?
hmm..... so the common cases are little endian or
at least the remaining cases will eventually be moved to
version 1+ which is little endian?

> >
> > I wonder if this field will eventually be useless (because of always
> > true) and can it be avoided from the uapi now.  The current uapi
> > fields (e.g. in bpf_sock) are always in one particular order.
> >
> > If it is in big endian, can it be changed to little endian first
> > before calling the bpf prog?
> 
> In fact, v1 of this patch set did the conversion prior to passing
> the fields to the bpf prog, which meant that the bpf prog did not
> have to do anything about endianness. I changed that, though,
> at the suggestion of Alexei; Alexei suggested that we pass a
> pointer to struct virtio_net_hdr, rather than copying the individual
> virtio_net_hdr fields. V1 did the endianness conversion as part
> of that copying process. If we go back to doing it like that, then
> we lose the advantage that Alexei's suggestion aimed to achieve
> (i.e. avoiding the cost of copying the fields).
If the common case is little endian, then the vhdr pointer can still
be passed to bpf prog as-is directly for speed.  A deep copy and
conversion are only needed for the less common big endian case which
eventually will be moved to version 1+?

