Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6699365F23
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhDTSXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:23:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16154 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232879AbhDTSXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:23:18 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KIEG4D010450;
        Tue, 20 Apr 2021 11:21:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=lMzMem1F+uYCKN/b19dVaxRTWB65xQA5ZTojYz2v2rE=;
 b=i42SH/oaleSHZCvkVI1VlLzw0MUCGTooG+ACMJksV8GxGCQD7jW52ZI185FqWdz8iUR5
 ReY0xAdAZTjk7K9oiCxIqpJQvjdsqnuObdmO5m+ner48HE5XW+Qcukk11K+YbR2hVPAM
 /nlnLyBs1DCArhdIcCveI6hGqZF9I0kAUvQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 381mxecew5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 11:21:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 11:21:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifaWbV0gwS9JQveuqg9cyywgpCx/L6n3XU9BdF8oIBTpweXGHrAw19xBGwuG/5jcYaUfZte+UnkD0QM46N6LhiL0gvg98yTmSH8he8FBWZ1+gAZw3Ts7aGjdYMXQCyIlX31kn5mTs+uVZpLhtEe374+4nv1jOYsAuDSk+RjXwA8QB7WRWspS3AAMxJ5DVpWGTpwOdhkMT9AmXr5DDcYXpzOPYb2N12HTdU8wyMkFqSH4G6DqmHs7vavxViMYBL9l0evS7wDFpvuH71VWgVGHd/SSg030lrXrEUWo6z5x5PjaTvxGEc2qTmKfC6QdQQcEFD5KSQS9a6gNKthroK3RJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIgp2YOkkXNxj5u2Ui1IrHyVi6lPdtV4bOk8FvQgjhQ=;
 b=kzSHSKOsc+v4MeGp/AUwNvJxO++WWTlvHMXNfe+Lx/z8o1UH8my+L+yVCzKJtx5JcC1Dg3SCNG6sKDnN3nxy7uFexJaeUnDCNBcpfn4k+0rNnDL+0ApKE5yr11hx0eWh7a1muM5Et4u9OCSm0W4QCVhpEdOuuEGqMCBJLq8CUZtaPjqaG+iOkZuco7N8toleoiEWuqq8akvfSsDfMc+J2vbfcnbPU3k/c1wlNdZi7advyIWqBklzUrR+yBL9xY/l0bLa2Jf5IBgx3KLB6MUV5o0LvpOx9IlASaebRcpqP2st2gtgbf3hv1vJqzEWuMzbH3Ii1A338aoJ0cCmX+AgUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3716.namprd15.prod.outlook.com (2603:10b6:a03:1b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 18:21:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 18:21:48 +0000
Date:   Tue, 20 Apr 2021 11:21:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
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
Subject: Re: [PATCHv8 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210420182143.om3gheczszoovp2y@kafai-mbp.dhcp.thefacebook.com>
References: <20210415135320.4084595-1-liuhangbin@gmail.com>
 <20210415135320.4084595-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210415135320.4084595-3-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:a3ad]
X-ClientProxiedBy: MWHPR1601CA0003.namprd16.prod.outlook.com
 (2603:10b6:300:da::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a3ad) by MWHPR1601CA0003.namprd16.prod.outlook.com (2603:10b6:300:da::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 18:21:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3578801-e8f1-4920-9ff5-08d90429291b
X-MS-TrafficTypeDiagnostic: BY5PR15MB3716:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3716EEF96316EB8461F13422D5489@BY5PR15MB3716.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6y/mrx+fIzdPdDSksJMm8gHBguUA1sLtcop8cMkunUmzx500ai9qZW0+IYLKjPzwum52tbLEFF02elW4mORVcdG53QvJElCwYQas0+JOvjzPbM9Sf27TKOdu7fEaEstT9QGvq+GjuJg9Iwb3P8MbTBeizcD3ojl8aJa5S9HqQmGKYuX0Ew8Tcq16cMgVg1a7GyL7lZggdh/HDexGMGPnyUNk1BF1aN1G/RF3T2M2IP1Xqi9RwIH+4natwlVXRzwSVL9ltq+bu7zU/a87Eh0OsNYHdXJzUQ1t+UMXJDIDjrDf86hKYGHXaYrfdwmGLzhP81im4xPVhP2nWJJF0GfOtqns89DavV97PhMsev7bW+p17TuONLmoxmdHm6r36GdTjxzmFpLCPKEPOTFWqjy34+Y81+vDmXSe2wfaBUZZGr6p8FK5FevBqaQLjvVVjbD8BvZ4y1q5PFFSuNXskZXJHJkmGxGGMT4BJuVkz8Wl+LE8SdrOPpF3MAyKfklsfsyEA3JvagdX87aQlYgWuLVMJ7HrdR7TegwEQiPE2hv/bZC0UqNBazQ2+WR+BaVUisMT7FZjsEKeUCJgGniBRtGbyIMe1Bo9r3aJcN6Z8+drigk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(366004)(39860400002)(4326008)(86362001)(38100700002)(478600001)(186003)(8936002)(8676002)(52116002)(1076003)(6506007)(6666004)(316002)(55016002)(9686003)(66556008)(66946007)(6916009)(66476007)(2906002)(5660300002)(7416002)(16526019)(54906003)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?GWz/ZD09/lmpIVBiw3lPBlix9jWR9MRVpWAW093ej2F5ET1ucd/htO8QFR?=
 =?iso-8859-1?Q?CLVcinEH5T7jcDGTPH40xCzgFU4ayj0lr5o1REXAKLR0rgHBsO/930q6HD?=
 =?iso-8859-1?Q?epAuSeKEVfr5jiY1qPvnYqOT65r3pt0AGXTJKHCbmBi8Q8YFvwFDsYHjSP?=
 =?iso-8859-1?Q?VNAl0EoNhRw9TQrpqh/ZI1nnuIVHyNsiguP4gyYTXBhc5oFEg+37icjLcV?=
 =?iso-8859-1?Q?c8/g5aEDxqctYPWrQ+RLa0gC5zTldXaoppXm0+DSRO/vwWIRU7tslkbpmc?=
 =?iso-8859-1?Q?NfsM0saWcwFLKRWrT/OJHxZldkP1InvfjS/TWtT1KQKtjwuW5/QihaL1Kx?=
 =?iso-8859-1?Q?LlwJRNLDejFh9V84IZPKanVCASAx9lbMBHbWZfhVCNoR3RE3Iwl9NMihzO?=
 =?iso-8859-1?Q?xp1UAtNimlvYxkutHtWRG9JEpv6/BOtRPazU4v/gITDgJSCYlDFMsNRHtw?=
 =?iso-8859-1?Q?xyOP5v/5rDr4T6hCXwRQ58nXJkCceLLPEF0+QdfU2C41ofPrKfg38VTLkb?=
 =?iso-8859-1?Q?TX7s6QCgp6GUeHaGsLCC97gnF1OwNS9jE3L0+kvQSgjT6VPWHiLSNaM9to?=
 =?iso-8859-1?Q?V0W5QC3YoBhuZj2wzfGOKF2bswVUFPI5V5ZrzoBEw77BK/fdzWqQn3wsrb?=
 =?iso-8859-1?Q?xNl60I95jeASgTotaxKnSlqEvsJ5xaCvkB+urAN/mf+jU1GyKOO3mXGkxc?=
 =?iso-8859-1?Q?eoiOYbvFPBLlJR1tuSEmKXDHrh5KWAB2rPv+fzEzMQt8KL3nkxl8MyWtFR?=
 =?iso-8859-1?Q?h7VnrVrOQStvXUiEd/OG8HkHkkoVV0WHoszPI2VP0IHMB7F/By0W+79pcZ?=
 =?iso-8859-1?Q?isc/pP+8xOnmhoak0GkAxYRttRMzlzG+1Lr4ovcy1jGCTHLL1aapOIcR9l?=
 =?iso-8859-1?Q?ZLar6/yKLUZK8uCZc6nPfBX5CKqXcdj9mYRGSoehJBdzkS7t0bnFxlV8nV?=
 =?iso-8859-1?Q?Ssb5a/WIvzSasiwh/j2aO98qaSukY73UKZ1DnZuePVeCKM2VMVpJh0YGs3?=
 =?iso-8859-1?Q?JvC4v3N4U8KU2zqcQ5oy12CvUbC71HA/m1YEALoCgffOoHiJea3gYM8UKx?=
 =?iso-8859-1?Q?zGgSc2Ee0860aDkhjqccRSKdvS5hGlIHOw97vuPKvzTMJ8ZcVOzaKwHSj/?=
 =?iso-8859-1?Q?KHa2iuxtqNPp0aZwPL+YuuqqF/nyPAnlRkaxQRS5K0d6ixRt1feS1OkK1e?=
 =?iso-8859-1?Q?PJbRHUYfr4vK7ui8xD/LjZNfPbsVUztHhs51E4kHw9USkspKRS2BNgslls?=
 =?iso-8859-1?Q?ikiPA1YrpvQ1vxJyGs8uW6MSKistXuTLpB7LRYdLg3AF9vpG1jQOn+rATx?=
 =?iso-8859-1?Q?IdE0DgcJPhymAkKbyPLquK8tcJNJAenU8no5U/uF/BTv7SdTCVC1YVAgcf?=
 =?iso-8859-1?Q?Wa/rq4/ug8zUdvCYnXP1RdsUu2tJx/oA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3578801-e8f1-4920-9ff5-08d90429291b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 18:21:48.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QkPW8xB5Eix9w6f5mA+MRMzHsGL7eUzACblAWu1caExCB/akHNII2HLKedKgtX4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3716
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: RQEbtunwzw-X6K8-l8ORAjvbKeOtZw8o
X-Proofpoint-ORIG-GUID: RQEbtunwzw-X6K8-l8ORAjvbKeOtZw8o
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_08:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=662 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 09:53:18PM +0800, Hangbin Liu wrote:
> This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
> extend xdp_redirect_map for broadcast support.
> 
> With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
> in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
> excluded when do broadcasting.
> 
> When getting the devices in dev hash map via dev_map_hash_get_next_key(),
> there is a possibility that we fall back to the first key when a device
> was removed. This will duplicate packets on some interfaces. So just walk
> the whole buckets to avoid this issue. For dev array map, we also walk the
> whole map to find valid interfaces.
> 
> Function bpf_clear_redirect_map() was removed in
> commit ee75aef23afe ("bpf, xdp: Restructure redirect actions").
> Add it back as we need to use ri->map again.
> 
> Here is the performance result by using 10Gb i40e NIC, do XDP_DROP on
> veth peer, run xdp_redirect_{map, map_multi} in sample/bpf and send pkts
> via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> 
> There are some drop back as we need to loop the map and get each interface.
> 
> Version          | Test                                | Generic | Native
> 5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
> 5.12 rc4         | redirect_map        i40e->veth      |    1.7M | 11.7M
> 5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3M
> 5.12 rc4 + patch | redirect_map        i40e->veth      |    1.7M | 11.4M
> 5.12 rc4 + patch | redirect_map multi  i40e->i40e      |    1.9M |  8.9M
> 5.12 rc4 + patch | redirect_map multi  i40e->veth      |    1.7M | 10.9M
> 5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |    1.2M |  3.8M
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> ---
> v8:
> use hlist_for_each_entry_rcu() when looping the devmap hash ojbs
Acked-by: Martin KaFai Lau <kafai@fb.com>
