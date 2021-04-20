Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A637366274
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhDTXZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:25:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233964AbhDTXZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 19:25:15 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KNFw9T026893;
        Tue, 20 Apr 2021 16:24:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=zauSE0ThT8ucdhPl9boD3qGnm/y5/MojVXIkthKi84Q=;
 b=Bz9q1dWV97JF2nxTDTSJyZpwv0gEsU2o3Elz9KNLMKv7WsO+Sy2XLU52tmRbm8pjgyTK
 2YNOz2xTCQCrdHGO3TPRsQgY7hYVuq4WRFMCk8jXbwO3oOvT8ObZjOGRP6tR7k8oNCfX
 cLBWuxojT3biz1fC9TKWro3Y1n2fvDI5U6M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 381q7y5hn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 16:24:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 16:24:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inPtBaHmYUhxehfGdtOXhUvML5VBV0UN93NIXrBBkRQG89XN5ZDRCii6S8I+gLs2he0OR7199SwnJ6ROWwFQoLYgTf6COXU3jWLg7MtyZDLoqX4JjVt7eYgBkppJNN7888jeyu43tD08vXLP/XxtWVDvO9rhGWkslZ7KboVo+RyeDq6ymp0PFJ5BkvgrDYvGXgJns6vTOlZ7QprhLiZfuJmgMEtWDWd2im+MtRU2HUqa7PkIVFEcuuYVE1DT/RNYkrt9gFTl6xtk604qjmg9H2WNq7MN3OAoJLMmNXL/6mGEtxVOclj2jW9Tn58bOWIqz3TP5sgQnMR6Vi9OWp1WVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87y/rAUVI/OPCJPACXWtsyoJYf7O+lAcFGmzxX09hp8=;
 b=PYBQLvlrtrUcz9t49LzC3/aJJ0ne/JhTUofAZWSwtOQAzEEWo1EVrtIGS0i2lIY4JCfjHUNmvDe2JtDVlwvLXqHGHpMJU5wzQL/m4z5dB6GH7jFivDgAhBXPEQr4t7ZnguGxlfOSF09F1x+MAgspqFiLv5sDy7bXf/vyIto4kgGC+69W3eU1J4+HLkAa+l/6f422JT20womUX+t8/kd5tUxU+dlCnlUjUNIVGTG16t58duLb/Tf9OdRC+kNh1PvB2sTFO9uJtAHN40/V6G53K/DuDIn/c1wSrlhVZO/KgtpEIgfIhIBXrYVtZvasBlje5L5Kb7Z+h9evIKoJKSUT3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4235.namprd15.prod.outlook.com (2603:10b6:a03:2e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 23:24:01 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 23:24:01 +0000
Date:   Tue, 20 Apr 2021 16:23:57 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Hangbin Liu <liuhangbin@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv8 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Message-ID: <20210420232357.yda7kpl7sdcsve6d@kafai-mbp.dhcp.thefacebook.com>
References: <20210415135320.4084595-1-liuhangbin@gmail.com>
 <20210415135320.4084595-2-liuhangbin@gmail.com>
 <20210420182854.rsis4npditizm5pu@kafai-mbp.dhcp.thefacebook.com>
 <87o8e8ektj.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8e8ektj.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:c047]
X-ClientProxiedBy: MWHPR2001CA0013.namprd20.prod.outlook.com
 (2603:10b6:301:15::23) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:c047) by MWHPR2001CA0013.namprd20.prod.outlook.com (2603:10b6:301:15::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 23:24:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d2d1f2b-511b-4646-0969-08d90453615b
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4235:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB42357E4A86816668A1184712D5489@SJ0PR15MB4235.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w7Es77wTpyowJUs0nGH7tYIIojLbBXyopQLyyqb3DlQM7uJ0CRBvFsxHSzj+t0zceERiwamGmGzaw40qa0r8yXjI4KIGwj2peMeq6S/7RegLHLwwA7x4A/D3BX1cvtFcyDFjT+ourQaVDGKTh+l84ifB8r74TwchFT/4n5ybhJMnZrQZ+ACjrHwdgHypShueiknhbBR3t54hkcFqU8T3iiB4EN9s9S/6NPNLqApzGBkAXlXwd4Q2HeEWHYvBSUbDP94w5zrp1NzYFHFprO/kHtp49QjbJD8VXWMiCVIqjca2O7OvYp8MvSt/Ag+hokCqjPBhXIzcWx13J2d7r9cU2m3J/W3NKzuyCSyx/LEVmfMidOD4HJlVUFAM1BqWQkLPLnpN30AHPd1+eG9Ps7yTrJDGQb/UNHYmxOaJfL3Kd0cbUKicSSP9LpfvxKLm1Nsl3EQDEujKwdSeRHN0RVd9DXyBuXSCY3+YkPSjRZtqFPCW8ekGByGCxA+wfs2o1t0G/RpQ0JCvlPEcaKyGlw49+6dx5iOb93kkDD6C7S53hA6BdcfMdtXgeXcnjhrIEUAdW83PpiexpQyeHLgNKgIoLyPyaBArxJDdVTfaboPXMPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(376002)(346002)(396003)(55016002)(186003)(66476007)(7696005)(52116002)(6666004)(66556008)(66946007)(86362001)(38100700002)(1076003)(9686003)(6506007)(2906002)(66574015)(5660300002)(83380400001)(316002)(478600001)(8676002)(8936002)(54906003)(7416002)(6916009)(16526019)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?wB0RnLiHxpuhUWVrX/VR6PxADwXSc6Mbv6DPnqMDhu6ki+EGSytJihZFSS?=
 =?iso-8859-1?Q?P8diD2lkA+SP8wBb3tZIZ7xuAoogwAMxhpIQ9V7JQAXVWfVtZBmdyeUCqV?=
 =?iso-8859-1?Q?xV2TyKBhxWjBNRtzTi3b5KFDq94Snrmo2kqMYhnnmLN9MY4d/M4cgw6+9s?=
 =?iso-8859-1?Q?PyGCRQGr8xwmWxiBS5vAUXfzUdTeuIuUTZwll/tiMweerHuJqnSHrvsgB3?=
 =?iso-8859-1?Q?TWCStbckJo4c6y9dzhzSYpvD39+/agUPYVy+wfHW15/evIM2Xp6O8RDm/h?=
 =?iso-8859-1?Q?+ifWIeBo+51XWjotGaUFdVG/iNb0+s0l5a+qF1vS12QZ5vhm2jpJXAKRw2?=
 =?iso-8859-1?Q?Zje+2S9UxDLQxF/uUq5gXwG55fdleAE36Tye2qS4VWHAZ5TUkJkxwILcyl?=
 =?iso-8859-1?Q?trhePchnH03erGUob7iwfzFm191eNib6rLb/olFtDSiOChkYMdcL7TbpkF?=
 =?iso-8859-1?Q?coGNw8E45TkbduC36pg+E19WUC3NK3Lh3mXlLw5Sd0pr0KMNJPEs1FXNCl?=
 =?iso-8859-1?Q?YsuHjxiKcWRaGEvlP1ej4iteBJDxQ9biogtomFqcZTJ+xf+Nzz0EH0568X?=
 =?iso-8859-1?Q?GEZJft9Ak2gCIaKoaqllRLYsVAO5UCduU/JZA0zcg4DegaWDedT70YemmD?=
 =?iso-8859-1?Q?0cM0NkkCgTCTXN/VaTPs1GkhYFEYS9OHMG4QsnrbrMekVYyFAIiWjeWdXP?=
 =?iso-8859-1?Q?9MxGY6o9JsDi/+6WXW/+Fni+ceeX7LJT3x1gBpSPQjFFXvu9vK17P9K9kV?=
 =?iso-8859-1?Q?8HhLfPTtWpGBYPrgDAKtC/KI9K41URdu0VWiAB8qbn93gfN22xqf+cBvHA?=
 =?iso-8859-1?Q?6yb7Yp8ymzv4rymdGCOei2YepVJtVZng9d3+E7ewWthgoClyBR6DrNBmhC?=
 =?iso-8859-1?Q?w7ASBfXP7s6iZR1DTEY5Q9ktxmJuEIbzSAOYKanDBLWr6gLXD5GJ+13whk?=
 =?iso-8859-1?Q?ubeKRz2Ia8C+aFw+q2Kebe6yqz0iLNbwg0eHD59bV7uSH/uVgRSPDbHZzy?=
 =?iso-8859-1?Q?N5h/o0lbbxFA7IKRwkdV8J7SfIddfGHP7ExxolAFV8iwg5+DijB7s18m5L?=
 =?iso-8859-1?Q?bjZ4xzKX2Gf5RFEPAK+PCBjGw8dwEDdr3vU74sx68wE+WgaN/oniu1Ygtg?=
 =?iso-8859-1?Q?DO62v54RVjif0XKxGMvgAbQOKsg2vB3lISRXNgNW28xgJVImDh8T6TCp5Q?=
 =?iso-8859-1?Q?CUocbWLtdWWPNh2XSOOBg1G1hL29DNUYCUU9bT9GSGbRXwDIdOQKsKxYKK?=
 =?iso-8859-1?Q?JTk2BYr8Gm3E1Alhw7PCVahpx79Z+CykOVkiNoVpyVpwBl0NOaFlpjk+aA?=
 =?iso-8859-1?Q?uDY1H02Gp54vnuVlgkHha75iLxf2V/X9PfcLGJeRa0osoqxx87knfmy1q+?=
 =?iso-8859-1?Q?1baxBY7LEZ8MuWxgs0zoD8/HTAE9xF8A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d2d1f2b-511b-4646-0969-08d90453615b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 23:24:01.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhzMZTvPBDWHlnnzG7MLBf3obJzFh38CMuU4szIGqWmj0NcxIuvHocsIWAHrLOIp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4235
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: R7vyjBK_z2oFku1rROVn_L_43y8tsTiE
X-Proofpoint-ORIG-GUID: R7vyjBK_z2oFku1rROVn_L_43y8tsTiE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_11:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 adultscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200165
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 10:56:56PM +0200, Toke Høiland-Jørgensen wrote:
> Martin KaFai Lau <kafai@fb.com> writes:
> 
> > On Thu, Apr 15, 2021 at 09:53:17PM +0800, Hangbin Liu wrote:
> >> From: Jesper Dangaard Brouer <brouer@redhat.com>
> >> 
> >> This changes the devmap XDP program support to run the program when the
> >> bulk queue is flushed instead of before the frame is enqueued. This has
> >> a couple of benefits:
> >> 
> >> - It "sorts" the packets by destination devmap entry, and then runs the
> >>   same BPF program on all the packets in sequence. This ensures that we
> >>   keep the XDP program and destination device properties hot in I-cache.
> >> 
> >> - It makes the multicast implementation simpler because it can just
> >>   enqueue packets using bq_enqueue() without having to deal with the
> >>   devmap program at all.
> >> 
> >> The drawback is that if the devmap program drops the packet, the enqueue
> >> step is redundant. However, arguably this is mostly visible in a
> >> micro-benchmark, and with more mixed traffic the I-cache benefit should
> >> win out. The performance impact of just this patch is as follows:
> >> 
> >> When bq_xmit_all() is called from bq_enqueue(), another packet will
> >> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
> >> flush_node in bq_xmit_all() is redundant. Move the clear to __dev_flush(),
> >> and only check them once in bq_enqueue() since they are all modified
> >> together.
> 
> (side note, while we're modifying the commit message, this paragraph
> should probably be moved to the end)
> 
> >> Using 10Gb i40e NIC, do XDP_DROP on veth peer, with xdp_redirect_map in
> >> sample/bpf, send pkts via pktgen cmd:
> >> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> >> 
> >> There are about +/- 0.1M deviation for native testing, the performance
> >> improved for the base-case, but some drop back with xdp devmap prog attached.
> >> 
> >> Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
> >> 5.12 rc4         | xdp_redirect_map   i40e->i40e  |    1.9M |   9.6M |  8.4M
> >> 5.12 rc4         | xdp_redirect_map   i40e->veth  |    1.7M |  11.7M |  9.8M
> >> 5.12 rc4 + patch | xdp_redirect_map   i40e->i40e  |    1.9M |   9.8M |  8.0M
> >> 5.12 rc4 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  12.0M |  9.4M
> > Based on the discussion in v7, a summary of what still needs to be
> > addressed will be useful.
> 
> That's fair. How about we add a paragraph like this (below the one I
> just suggested above that we move to the end):
> 
> This change also has the side effect of extending the lifetime of the
> RCU-protected xdp_prog that lives inside the devmap entries: Instead of
> just living for the duration of the XDP program invocation, the
> reference now lives all the way until the bq is flushed. This is safe
> because the bq flush happens at the end of the NAPI poll loop, so
> everything happens between a local_bh_disable()/local_bh_enable() pair.
> However, this is by no means obvious from looking at the call sites; in
> particular, some drivers have an additional rcu_read_lock() around only
> the XDP program invocation, which only confuses matters further.
> Clearing this up will be done in a separate patch series.
lgtm
