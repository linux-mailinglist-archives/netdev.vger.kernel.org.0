Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FFD3183A6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 03:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBKCnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 21:43:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31406 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229598AbhBKCnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 21:43:05 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B2f2Kx009282;
        Wed, 10 Feb 2021 18:42:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4VejklgIZYTHHTZTTbp3rbHGRH9yRIvn9gmmPBoWGyg=;
 b=rQhHr6wIMPF3Mr2YijOIFCm5LwO2+WTicDF5GZ2nHCri5gZTfAZjiyY6BPFKiIKJ62zD
 56eL/97lzjca3ToDFemWiFkMHqatSQG+N9FtUaaiz447+GiDpt6+QQhwd8WcUPMY9PvH
 DKQrChCo5rLwWOjcdH4h97zk8UkhmdsHFpM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36m6wfeewc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Feb 2021 18:42:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 18:42:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Guxp5B/gczzwJjZQKv4uBy35fEnamPDAyVDxNR/dBGwdp1EPvmwTw8z9YA6tCcmJidQ7/M4lvHT/jcsd9eCjcWzwuf4g/gDx7WKRBKYkFLULxDqVlLX9JNQe0kfxSkSABH/CBW3G5lyEt1s6JM7yAaVW98iJ6jtonuItSeA6EVhznzjpv1DgJlD4T/TNjGogHnW8R2Fz4cLdY30FmukiI9Qw54zSARLWoSh8p8q4AGpSPKtTOVxnlHZ4QXOFVYmgyHFIqnZyaQ93MQdVgPnoFgmayaxKDSwntFTdKdnO29zoDBbwxOc+m/9mgTpyk3f2Z3OEi0SNzETyayKRnwIpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VejklgIZYTHHTZTTbp3rbHGRH9yRIvn9gmmPBoWGyg=;
 b=GCo26VkP3iCvoG81MEzQOr3vqp5rs0Mi+22d9ojAnLOYzcjpn++h6f6zJLGUNxIgQMMgaXXlORvka1ymL29Jv6ISdzyk00LrZH2RB+e/5zE9K+W/B9fcE2JxuBKU7Xiv6LQ9fZ1o1M2iuMoSkQwAhg8tIFmt1yXmtCK2qxNgIlEPJ5sQXu696u5kXE58i62TqOxkMasVbZcbkhVZS3l/WwkviwkI9hGTAvAOvUbDd0ULBopUfmHxlhb8H2XaLeZdC0hP8bXY/i760FsqfCbUlM3RgDLuHgFvfwNrkS3UiIwztmLnt7QEb+t9jY3Kbj29sBW8XmccwgNiy9Z+fendEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2456.namprd15.prod.outlook.com (2603:10b6:a02:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Thu, 11 Feb
 2021 02:42:08 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 02:42:08 +0000
Date:   Wed, 10 Feb 2021 18:42:01 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to
 struct_ops
Message-ID: <20210211024201.3uz4yhxfqdzhqa35@kafai-mbp.dhcp.thefacebook.com>
References: <20210209193105.1752743-1-kafai@fb.com>
 <20210209193112.1752976-1-kafai@fb.com>
 <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com>
 <20210210211735.4snmhc7gofo6zrp5@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbhBng6k5e_=p0+mFSpQS7=BM_ute9eskViw-VCMTcYYA@mail.gmail.com>
 <20210211015510.zd7tn6efiimfel3v@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza_cNDTuu8jQ3K4qeb3e_nMEasmGqZqePy4B=XJqyXuMg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4Bza_cNDTuu8jQ3K4qeb3e_nMEasmGqZqePy4B=XJqyXuMg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:3dd9]
X-ClientProxiedBy: MWHPR10CA0020.namprd10.prod.outlook.com (2603:10b6:301::30)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3dd9) by MWHPR10CA0020.namprd10.prod.outlook.com (2603:10b6:301::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 02:42:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b121b3b4-b20f-402d-b044-08d8ce369fed
X-MS-TrafficTypeDiagnostic: BYAPR15MB2456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB245669EE43CFB0C72E634BDBD58C9@BYAPR15MB2456.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62MxmMHnSOtveCJe47Pg8hNdaYfD5na37B3vhekx5tmUx9kdcQDwo27JmayAsf3YxB/jzQqx/zqGbGbqDR5URWoq6QUwwdzqHiOxkFAhRF937aWm4hwEsVMWdjUf4IRcAFLInEuNXflhE8WX/McqhiJFvh4uH7iOau/WUH4ZbDse4lDP03k3+/rBANi2SRtNRdosnKsWFvX0oTDI83sTh4qPAS3GIqpuY6CWyhy7RkM8RYkANgQUjJ39zBWSs33PWJcQf9qpCtNkU+a9VFwsQxIqg93vQzzSA79s5kkUFMtfWISHjIQ/kPLvguJMAkCGEqE2bEHtd0Kphts6UndjrrBoYhekRsbEC4U/YtSeK7cMt+X3QiFctwd3YpBkwgbDo9UnUHWqUpt5wV/JPmXOS7nv9UBdHAh4LF9msAAiF2Aawz/K7Ld4zpI9n644drBEIpJlmsuXTjHUyB+a/JZI5KQsfUHtT+mjCB+ETCf6V1yb1gk/vn9yRLcVq9BK7GRWpzP4XHprIZSwlM11n3QwFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(346002)(39860400002)(7696005)(5660300002)(86362001)(478600001)(52116002)(1076003)(186003)(9686003)(6916009)(66946007)(8936002)(55016002)(316002)(16526019)(53546011)(6506007)(8676002)(2906002)(4326008)(6666004)(66556008)(54906003)(66476007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1EwXZOdix3Iai7dozZmhcH8z1Zq3OByIKmMi6M0WxiIl4Ud7I57rw2ESX2Rf?=
 =?us-ascii?Q?IhCjbJKdpn4baKguhd/2QfLPO27EDZ7tSHlz/pYfQ/VzrbuET0TnG0fGyTk9?=
 =?us-ascii?Q?xhfMXs0UhbNYb8hqH/ACBjATamJEGjo8O4oMqVWrRcTyk1ud4m+0/fkaN7wq?=
 =?us-ascii?Q?VcHhtMUmDJzdViXPeh5oGEODGrkozvSdcRP5Rc0uLQQnFiaCMSGDMVmF/0Iy?=
 =?us-ascii?Q?0FI1v5lMN8K8pP/9CXySw9PiVTkriQ7AG234yr6FyPWNGZbYAR+g5diHbMUZ?=
 =?us-ascii?Q?oaIGwzC9KNjsy+HQXTDZ2FsM7xaDHf5yXdTXmvkDq6crgx3lynrj27Ql+U/S?=
 =?us-ascii?Q?g1UAhG3/okJZiRG84FunWLg9hgL1AGJ6L/pgexNXtjsdl8d0y3yYEv7xWzMn?=
 =?us-ascii?Q?h6WKRHT2X5TUbNFyUphZeui/ZH5W0udNQIKztR7UEKTZf2TGNevyqBk+FD4r?=
 =?us-ascii?Q?yxiPlBCBqQ3puDA3GJ5UkDOYJAAvIfKFcw5oUc/itrsO7vQVYk/qC3Db4If3?=
 =?us-ascii?Q?Tfm4fE+Zsni51qWoS+7fAH7oacykHXbV1upP5ZZJjJq1/Zb8K4IT6FyCkYje?=
 =?us-ascii?Q?czFJPYqebDINkS1ZfO9STQIUKfs+P48JZ+6OgDAK/6FunnZvJL95q3MRqVam?=
 =?us-ascii?Q?DUffhwRq/1y1BZIvdpILBKEaQJJzBkstqv3JqyIpt+YK6kR4EbD/r0gIKplk?=
 =?us-ascii?Q?zntrvRVSYw0m9aUJjciEWmolK3K6+bNtrsXy3Lo4IzNSXBw9h/rCGih2dwzl?=
 =?us-ascii?Q?tbUx3om4SKv52WMQFg7cmsDJ2wmiUCCxib+817R4BkCD0xnJcaQzI8dxNrGb?=
 =?us-ascii?Q?aTcCrqT6p1VrpTvAmgyMQVIO5YWE+RU+6rYV9Sb1ndZKiB0w75x1B31BjMtF?=
 =?us-ascii?Q?an9/BCW1JT/UIzw1JTFygSuEDyvEEHhyKWgz3sinGZHpgb00/r4xe47Ri79n?=
 =?us-ascii?Q?s8u78QfFH8ILRFhS+Z5m0yuGfZCaQHdPXTdK2XHI41PZFbqmQzEX9ZTfHHjo?=
 =?us-ascii?Q?OQJhvl3TfoyJQDx1f8v7R9GECTcUjjYAcgiRyDPgd4+yPl3ut5Rxp/cbyMfa?=
 =?us-ascii?Q?2nqr8lm5ypoFWk36z0RQrWHPyL0og2XKWdKsthHMWyQ8nZEzBj+EA1hAeOho?=
 =?us-ascii?Q?xCFdnMKNkyWDAyNzNvt9M9Ec9WB1bS3jqkdZb6hVzr+ghAcPFEmlVYD3MOwh?=
 =?us-ascii?Q?3tVz5xElRlKI9dWESbRtTSea7Eh3uCjZdbCBl3ImlkVTaiKvoxv/7I4IF1yX?=
 =?us-ascii?Q?MVLwqeiRd0Bz/D2/a2EUsi8FsaBu1vUE4SDERTlZ+THNiT/6nuaShKg55ZRo?=
 =?us-ascii?Q?VFc3lqPC8JlZkqS/+qeDkAR9pIjHDLtcNcM7D3dUHxNkPK5VkZJZH1CbGf0l?=
 =?us-ascii?Q?IDUzZw0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b121b3b4-b20f-402d-b044-08d8ce369fed
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 02:42:08.2653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UbOVhHCt9ExsK772gUAV4rauX1NQvkMSyCznC+0DulXFGZXBrzn9oV2DBtwkn0x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2456
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=864
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110017
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 06:07:04PM -0800, Andrii Nakryiko wrote:
> On Wed, Feb 10, 2021 at 5:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Feb 10, 2021 at 02:54:40PM -0800, Andrii Nakryiko wrote:
> > > On Wed, Feb 10, 2021 at 1:17 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Wed, Feb 10, 2021 at 12:27:38PM -0800, Andrii Nakryiko wrote:
> > > > > On Tue, Feb 9, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > This patch adds a "void *owner" member.  The existing
> > > > > > bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
> > > > > > can be loaded.
> > > > > >
> > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > ---
> > > > >
> > > > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > > > >
> > > > > What will happen if BPF code initializes such non-func ptr member?
> > > > > Will libbpf complain or just ignore those values? Ignoring initialized
> > > > > members isn't great.
> > > > The latter. libbpf will ignore non-func ptr member.  The non-func ptr
> > > > member stays zero when it is passed to the kernel.
> > > >
> > > > libbpf can be changed to copy this non-func ptr value.
> > > > The kernel will decide what to do with it.  It will
> > > > then be consistent with int/array member like ".name"
> > > > and ".flags" where the kernel will verify the value.
> > > > I can spin v2 to do that.
> > >
> > > I was thinking about erroring out on non-zero fields, but if you think
> > > it's useful to pass through values, it could be done, but will require
> > > more and careful code, probably. So, basically, don't feel obligated
> > > to do this in this patch set.
> > You meant it needs different handling in copying ptr value
> > than copying int/char[]?
> 
> Hm.. If we are talking about copying pointer values, then I don't see
> how you can provide a valid kernel pointer from the BPF program?...
I am thinking the kernel is already rejecting members that is supposed
to be zero (e.g. non func ptr here), so there is no need to add codes
to libbpf to do this again.

> But if we are talking about copying field values in general, then
> you'll need to handle enums, struct/union, etc, no? If int/char[] is
> supported (I probably missed that it is), that might be the only
> things you'd need to support. So for non function pointers, I'd just
> enforce zeroes.
Sure, we can reject everything else for non zero in libbpf.
I think we can use a different patch set for that?
