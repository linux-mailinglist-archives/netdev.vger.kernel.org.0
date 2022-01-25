Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6683249AA39
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325055AbiAYDfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:35:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21856 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S3415324AbiAYBn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 20:43:59 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20P0RLls013327;
        Mon, 24 Jan 2022 17:17:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=pcERiuSJ5sW21VKUEXE26BYRjKXdyaIg0YOqwMG2484=;
 b=FJxipa55ItGRfO5rhuxnfnOkG1A/mmMuPO1Zp0uYAq2H+Gca09alxloTIEHqC9xxWQtC
 5MEVgUnS0DkymSV4uyQwX/mLRp2ziDMzBCeozmqzGyNltJvdzaUlgmA9u4a23SkO9vQt
 uy8jlsbCEk32k6oXLMH8fgBHgodhwHsofqw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dswcpvg1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Jan 2022 17:17:07 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 24 Jan 2022 17:17:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmPaucD4zaQz/cZAeULEbvNldsOdbf4+3+ICAFgftGJZzqhJvvFpM1tCYcvHOXMxFpdmIn0tg5FJyDWLwbjX/KF+DNEF29FKXRdQXo2RFesJBS/UqhBOjz003Lt07pcAFAG+ql8QvNRDzBU4ZE+qFEJ/rlm3oYCUtHSo0F4axcfJCtq8UH/coQi72dEs5BvyKjbB/FR6JIBh+fBrSfZKDZuoOoIuf4YiF8m7/WU4vNqWNTCoElN9y4YxqRErgNoNsiXCtT19CTH5CfxHzHRfEz1x9RSBy+3ci4/Is2XJlCdDhHkxnXcvPZLXzLahsO6zuJpppQwyTg+xZxqiGvysPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcERiuSJ5sW21VKUEXE26BYRjKXdyaIg0YOqwMG2484=;
 b=D2D4MccKnfTlo4PJgvkYlXKnDe+keYytp4IooYaO4HmyGFEsrhBAMfkK0gVy/Dex5OUC/KlR4n3B1DsW0uPRRX5pbUrmxSJTw5fc6sP5S8OF5KbJk5DGZPxZ6pWuhRPdmqCGJmp0nH9lrMvMhxiq06JkwelIVdEq+oNlq689i+2oom6UcAs9QBBgVxQWf4bbVu+Qa5uTjrP4QIqfyxbtcn2EMSbQC1Wiuk9fYcRAeFE5Ocm2z4o3vF2uXen7/NYibJFRqbmELGKaQjFyJcyfVa9AqmYnjDzbMkkdZc1rLfedTNcvLQCaXU1PdV0q4TEYwMNhI/o1BN0RCxWqcZxfag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM5PR1501MB2133.namprd15.prod.outlook.com (2603:10b6:4:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 01:17:00 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 01:17:00 +0000
Date:   Mon, 24 Jan 2022 17:16:55 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Menglong Dong <menglong8.dong@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, <flyingpeng@tencent.com>,
        <mungerjiang@tencent.com>, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct
 bpf_sock'
Message-ID: <20220125011655.qpb7gelbik4tdwcf@kafai-mbp.dhcp.thefacebook.com>
References: <20220113070245.791577-1-imagedong@tencent.com>
 <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
 <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
 <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com>
 <CADxym3b-Q6LyjKqTFcrssK9dVJ8hL6QkMb0MzLyn64r4LS=xtw@mail.gmail.com>
 <CAADnVQKaaPKPkqYfhcM=YNCxodBL_ME6CMk3DPXF_Kq2zoyM=w@mail.gmail.com>
 <20220125003522.dqbesxtfppoxcg2s@kafai-mbp.dhcp.thefacebook.com>
 <CAADnVQ+xnnuf3ssgmkR3Nui46WT6h37RUU1zsjhOhy+vCfVdXA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAADnVQ+xnnuf3ssgmkR3Nui46WT6h37RUU1zsjhOhy+vCfVdXA@mail.gmail.com>
X-ClientProxiedBy: MN2PR19CA0058.namprd19.prod.outlook.com
 (2603:10b6:208:19b::35) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c04f556-b864-4931-c0ae-08d9dfa06303
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2133:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1501MB2133E60CDFE3148357DEB4BFD55F9@DM5PR1501MB2133.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: if4ihsgpwfBK5bg1N+s7KhBMQ7HZH+vVMvRjAMbEreVnW2pXXjjr0Oqx3vgL8KEv1ACDO4vvAojihHQdTvGSfpIrh2LOxNCn4fiKxxTDe6figV0KEyfNj8/kipjtlbJJtuYZg8W+P/gvlXRbF6JbVicB2AxodzoqZb7v3Ffcr2TxuRbYreR14dA321w/7X1w8auJ2cBBmEMn65CUTiOZRKHS6FfOfK8uCzqk4lCRVHxd0TgopGw7wk5ud1HYZD7KKPi6w5y5EY8CivPlKiUFImTVDjmZcLlLLeT1UdgRr64QGIW3xIaR1zYMBFewxM0+xAJM+318SaXwyxKtZAwxKeg6AuQWJbhFPpHppDkR9FQKbCxIP3ygKaUdKJbaP+pi0PXYy2NniysN9ZiRa1f+Vyhxe5R4JwO3uO3upiJrHH15L2yeYoRzQ1kOjVHIxjWUlnV4F5vOJKiQJiIHkVGT+AVbUtblX46RPcle8LNT8Re/E33WACnPXzBCEb40qAGNNpr7Mk9IhDGhVt9Tnh9zfxr/eAhAoODwgzQyD95+VQalN7oOhH3LwIDet9+2XOwt1QaTkaEUuPUYXxKburAAJS7fgpYw/+VTfBqIUe221dFtFv2ak9eZLWngbkXzCGU+jP+AQN0WObfzDjpWQlVZPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(2906002)(9686003)(66476007)(66946007)(316002)(6486002)(508600001)(186003)(6512007)(8676002)(8936002)(66556008)(52116002)(7416002)(38100700002)(86362001)(1076003)(5660300002)(6506007)(54906003)(53546011)(6666004)(83380400001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JbAg0SdD7NCE1pCKXYbHFjQYFE9zJr8ob1PsNEVygmwmLxDXUwpXjC55mywH?=
 =?us-ascii?Q?Cr/z2KhAm79sobyjgu0HtJUn/sKHugNRDUlSU5TBOEvCqyMcPnpvcO7x8Pee?=
 =?us-ascii?Q?4luK8D29nHRTbhA6MJaRVIfyXd30TZRqB6+NnMkSrZ6MFH304Bv4yTtln5t2?=
 =?us-ascii?Q?2wLn/pmMdyXblrRtPiiW4wJn7hKQJ8ZKWVp+d+G0RNUaTZeHJtY5LHj73Um2?=
 =?us-ascii?Q?2AM2S6Eie0QfmQDhhPI0Vv4geztf+53Cifzo+TtOirjb9oDc/xkt/Nl8SdaJ?=
 =?us-ascii?Q?PtNhYZ90S13Xj1mby8JE9VuIGn448mOWUfQm3uuKluUMe9U6bh3Bnko62Mkf?=
 =?us-ascii?Q?tWzX3AGw9UUPemsgn2gX+0+ENeRX1VjrnbNfIbpdXUa5JjZfGxhLg0pbk4xx?=
 =?us-ascii?Q?KgUuVVzx8mpPvh0HYrppDMcufeQKzr97tHo/YvQvEexgoGWSXPyijwXDDhm5?=
 =?us-ascii?Q?RTHX8aTx89CLVJMhRaTXVB4sJjgicYebcGZMeo8yGQvpV7JNBdkfYAxdDG70?=
 =?us-ascii?Q?/H4SfM/vHEijbMBpm7rNOQqR5tgXL+joxthfAE4wR9wVVlCqJRs/k99C46oE?=
 =?us-ascii?Q?ixIU7bEwyXbXGkk6oEzRuguICljLi9+/FmXyI2C2exeOQmHBZ2qrBKmQHyFh?=
 =?us-ascii?Q?TgsLVSlTcD+ViSiQ1F6NF0mINcerc66W86yuHgaz9SPDt6+F6wk1qJ8Yl5Ld?=
 =?us-ascii?Q?331jA2vVSJVgzpxFx4VqiFJiTkl0Ht3uKz/7xDqO/lm9ytLNBdXZoGR9ZIgP?=
 =?us-ascii?Q?T90C0wp16cAb25a955kPoqRJZeUqo/7SxTTOKrdwz3AVHFT7QJA8ww8nuzb8?=
 =?us-ascii?Q?U/kZUJPBbWpxOTie8ZyCBjOInW3CWVsucwTdwKvLel/l1zm7iCnVOJwEkAhO?=
 =?us-ascii?Q?LIq093IehPe4RfzT9CbtdzyvVJmEDe+rYT2WdFK0vrCL5jaoourANAfRLq6Q?=
 =?us-ascii?Q?8GDnhAG0pKM3kn5YMDsguVF0tDyINpOZsJLcjNxOoAMUJW5KRn0z7N28x+hb?=
 =?us-ascii?Q?QQgGF5JXAEc4KXeGn+XwbY2wdGiJzld21nwa0okg5qTrw7e45z2IIdGKwTgH?=
 =?us-ascii?Q?rkDAUFi32NDZAuY4wVH2XVhQRwCgXdFyfl8PjK0V1u02B3IKoOE8KqrrB7s3?=
 =?us-ascii?Q?s+FXmaK1Q669CrmRsEBMbBmgCO/atRE0QsMwWgcuEUsqRu//zYbSW2My5F2L?=
 =?us-ascii?Q?lgiyK+ONuiLN+pZ5A6q5q5sOdAR0d4PKSc2PVwMHc2ZNZWdToAIM2WqRJGwg?=
 =?us-ascii?Q?HjCK5tOaeYRkWxnZ/NkSEOvVhsPMCJ4ajB12J7s+yTBU3LyF/dhShixLR9eT?=
 =?us-ascii?Q?4OA0p0ti6VbiSMlJfPyL6YXTwMngcHEyRCyC4OQdEXbSW0WsZ8qpV6ZDCY7c?=
 =?us-ascii?Q?s3tzEUfVPyylTKo/UQAOWD9/BRd1pVky+cOtWhzzPdhZga8cW/wwUifDXi20?=
 =?us-ascii?Q?FcYWf/thcOgnv8vWmufrBYl00aBp5iQiIE9oe+EQm4MU/IJPi3c+6QR+WUzl?=
 =?us-ascii?Q?Di02/5quFrXQn0kg7NmkPqStHPIY/3E1w95C8kBRMR3T1CaMkRmhasuQkBc1?=
 =?us-ascii?Q?ZrNnkozLjlyAuSVcjgmKaHtMZOQrom3BRh9bEFr8kGZMYpNFaZ/KANlMxWp+?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c04f556-b864-4931-c0ae-08d9dfa06303
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 01:17:00.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyikVt5Ltie1sDv+ENmVlvKwAbevr4nODGw9FrJUDr2wbi/5I37evpF4iLxVOP7L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2133
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: TIyuLgzJY02b9vjWH53_5p8PmUZM8Ta4
X-Proofpoint-ORIG-GUID: TIyuLgzJY02b9vjWH53_5p8PmUZM8Ta4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_10,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201250006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 05:03:20PM -0800, Alexei Starovoitov wrote:
> On Mon, Jan 24, 2022 at 4:35 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Jan 20, 2022 at 09:17:27PM -0800, Alexei Starovoitov wrote:
> > > On Thu, Jan 20, 2022 at 6:18 AM Menglong Dong <menglong8.dong@gmail.com> wrote:
> > > >
> > > > On Thu, Jan 20, 2022 at 12:17 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Thu, Jan 20, 2022 at 11:02:27AM +0800, Menglong Dong wrote:
> > > > > > Hello!
> > > > > >
> > > > > > On Thu, Jan 20, 2022 at 6:03 AM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >
> > > > > > [...]
> > > > > > >
> > > > > > > Looks like
> > > > > > >  __sk_buff->remote_port
> > > > > > >  bpf_sock_ops->remote_port
> > > > > > >  sk_msg_md->remote_port
> > > > > > > are doing the right thing,
> > > > > > > but bpf_sock->dst_port is not correct?
> > > > > > >
> > > > > > > I think it's better to fix it,
> > > > > > > but probably need to consolidate it with
> > > > > > > convert_ctx_accesses() that deals with narrow access.
> > > > > > > I suspect reading u8 from three flavors of 'remote_port'
> > > > > > > won't be correct.
> > > > > >
> > > > > > What's the meaning of 'narrow access'? Do you mean to
> > > > > > make 'remote_port' u16? Or 'remote_port' should be made
> > > > > > accessible with u8? In fact, '*((u16 *)&skops->remote_port + 1)'
> > > > > > won't work, as it only is accessible with u32.
> > > > >
> > > > > u8 access to remote_port won't pass the verifier,
> > > > > but u8 access to dst_port will.
> > > > > Though it will return incorrect data.
> > > > > See how convert_ctx_accesses() handles narrow loads.
> > > > > I think we need to generalize it for different endian fields.
> > > >
> > > > Yeah, I understand narrower load in convert_ctx_accesses()
> > > > now. Seems u8 access to dst_port can't pass the verifier too,
> > > > which can be seen form bpf_sock_is_valid_access():
> > > >
> > > > $    switch (off) {
> > > > $    case offsetof(struct bpf_sock, state):
> > > > $    case offsetof(struct bpf_sock, family):
> > > > $    case offsetof(struct bpf_sock, type):
> > > > $    case offsetof(struct bpf_sock, protocol):
> > > > $    case offsetof(struct bpf_sock, dst_port):  // u8 access is not allowed
> > > > $    case offsetof(struct bpf_sock, src_port):
> > > > $    case offsetof(struct bpf_sock, rx_queue_mapping):
> > > > $    case bpf_ctx_range(struct bpf_sock, src_ip4):
> > > > $    case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
> > > > $    case bpf_ctx_range(struct bpf_sock, dst_ip4):
> > > > $    case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
> > > > $        bpf_ctx_record_field_size(info, size_default);
> > > > $        return bpf_ctx_narrow_access_ok(off, size, size_default);
> > > > $    }
> > > >
> > > > I'm still not sure what should we do now. Should we make all
> > > > remote_port and dst_port narrower accessable and endianness
> > > > right? For example the remote_port in struct bpf_sock_ops:
> > > >
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -8414,6 +8414,7 @@ static bool sock_ops_is_valid_access(int off, int size,
> > > >                                 return false;
> > > >                         info->reg_type = PTR_TO_PACKET_END;
> > > >                         break;
> > > > +               case bpf_ctx_range(struct bpf_sock_ops, remote_port):
> > >
> > > Ahh. bpf_sock_ops don't have it.
> > > But bpf_sk_lookup and sk_msg_md have it.
> > >
> > > bpf_sk_lookup->remote_port
> > > supports narrow access.
> > >
> > > When it accesses sport from bpf_sk_lookup_kern.
> > >
> > > and we have tests that do u8 access from remote_port.
> > > See verifier/ctx_sk_lookup.c
> > >
> > > >                 case offsetof(struct bpf_sock_ops, skb_tcp_flags):
> > > >                         bpf_ctx_record_field_size(info, size_default);
> > > >                         return bpf_ctx_narrow_access_ok(off, size,
> > > >
> > > > If remote_port/dst_port are made narrower accessable, the
> > > > result will be right. Therefore, *((u16*)&sk->remote_port) will
> > > > be the port with network byte order. And the port in host byte
> > > > order can be get with:
> > > > bpf_ntohs(*((u16*)&sk->remote_port))
> > > > or
> > > > bpf_htonl(sk->remote_port)
> > >
> > > So u8, u16, u32 will work if we make them narrow-accessible, right?
> > >
> > > The summary if I understood it:
> > > . only bpf_sk_lookup->remote_port is doing it correctly for u8,u16,u32 ?
> > > . bpf_sock->dst_port is not correct for u32,
> > >   since it's missing bpf_ctx_range() ?
> > > . __sk_buff->remote_port
> > >  bpf_sock_ops->remote_port
> > >  sk_msg_md->remote_port
> > >  correct for u32 access only. They don't support narrow access.
> > >
> > > but wait
> > > we have a test for bpf_sock->dst_port in progs/test_sock_fields.c.
> > > How does it work then?
> > >
> > > I think we need more eyes on the problem.
> > > cc-ing more experts.
> > iiuc,  I think both bpf_sk_lookup and bpf_sock allow narrow access.
> > bpf_sock only allows ((__u8 *)&bpf_sock->dst_port)[0] but
> > not ((__u8 *)&bpf_sock->dst_port)[1].  bpf_sk_lookup allows reading
> > a byte at [0], [1], [2], and [3].
> >
> > The test_sock_fields.c currently works because it is comparing
> > with another __u16: "sk->dst_port == srv_sa6.sin6_port".
> > It should also work with bpf_ntohS() which usually is what the
> > userspace program expects when dealing with port instead of using bpf_ntohl()?
> > Thus, I think we can keep the lower 16 bits way that bpf_sock->dst_port
> > and bpf_sk_lookup->remote_port (and also bpf_sock_addr->user_port ?) are
> > using.  Also, changing it to the upper 16 bits will break existing
> > bpf progs.
> >
> > For narrow access with any number of bytes at any offset may be useful
> > for IP[6] addr.  Not sure about the port though.  Ideally it should only
> > allow sizeof(__u16) read at offset 0.  However, I think at this point it makes
> > sense to make them consistent with how bpf_sk_lookup does it also,
> > i.e. allow byte [0], [1], [2], and [3] access.
> 
> Sounds like the proposal is to do:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a06931c27eeb..1a8c97bc1927 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8276,9 +8276,9 @@ bool bpf_sock_is_valid_access(int off, int size,
> enum bpf_access_type type,
>         case offsetof(struct bpf_sock, family):
>         case offsetof(struct bpf_sock, type):
>         case offsetof(struct bpf_sock, protocol):
> -       case offsetof(struct bpf_sock, dst_port):
>         case offsetof(struct bpf_sock, src_port):
>         case offsetof(struct bpf_sock, rx_queue_mapping):
> +       case bpf_ctx_range(struct bpf_sock, dst_port):
>         case bpf_ctx_range(struct bpf_sock, src_ip4):
> 
> and then document bpf_sock->dst_port and bpf_sk_lookup->remote_port
also bpf_sock_addr->user_port

> behavior and their difference vs
>   __sk_buff->remote_port
>   bpf_sock_ops->remote_port
>   sk_msg_md->remote_port
> ?
Yes, agree on the code change and adding doc.

> I suspect we cannot remove lshift_16 from them either,
> since it might break some prog as well.
Right, I believe the existing lshift_16 has to stay.
