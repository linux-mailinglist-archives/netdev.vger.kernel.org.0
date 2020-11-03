Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDF82A4E08
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgKCSMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:12:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19432 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729268AbgKCSM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:12:26 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3IApEE032673;
        Tue, 3 Nov 2020 10:12:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9GTcIZB1mSpuFwcAyWNKV2m0Po4twk5AZT2Qher33D0=;
 b=LxVoTDDDDEnPjnoP3/0F3+DOAjhxa5PyKSQNcy/eF5bpsQqkWuNGrShnsAcHGyrkrh9r
 +93g6S0NDLwVn0l+vIp3GpXWQGA4WjfHy4jqsDtbtK++SAPYNLxtzkALRJqWnQ4uXIdp
 wO2R8V9gojep6SWkyP9T+kHxY+w9K3e4EbY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqducw3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Nov 2020 10:12:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 3 Nov 2020 10:12:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1yf/mTffvnCiOyoY/Pi5eKqE4jpKKuK70fPxxAVUMBIZ4nr3tmyo9WoHNrksh/azBkH4Sh8CC9NLbzCtXs7Prezaa3U8TWE8x3AcYHLfl965DjrRqWrfg7YrEJRaOCEpnjieGUrrtuVDKk6RdZsnWLUUzuqmSe7oImSq5UeMVKq0ismQk2JDGcLECdOLQ1jexAMkDFJD/ek5zetQ3r0kVRxkH1ggXY5Yq0sQVucfJrFurBuPS+E5Fl6LiBBzvkcagoNJSjSZyRNkrM5wVOjjvh0VxMzR6E6ZvrHRx2bpm/dMyh7kxo2kyagRjt9UyZ9RVcWa0C3KrrblzQXoG3peg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GTcIZB1mSpuFwcAyWNKV2m0Po4twk5AZT2Qher33D0=;
 b=iGWLqAaLW7+MDUwE9ILUGFOR1TIRITr3XQ/U3vRCZQMUn+UJCsl81pNOC3YRVbd+f0Nfj+ZSbvRyYo4IKi7wpgyAgNjPMDOS2b94cRU3QDXH76eYxot+7ukLvBQXB4HDiroIJvVTZQT9rP9Sr2Epxnih4Kh3k7DaSxeo9Dt+blQG4N/VdQYdMG4N7Qghik1A9YMHQzcTMWRHCLpY7/6vDD4m1Id5MjY4YDZYtnXjL/42K/oqDvDOHZA2nRtVUaLcngmTNmoXqUoZMaU+hGNAezBuNl8L3tKSKTc/qW+SKGqut0HwnRxlgg3ppvaSNXX0wTOOhRwvhCQzO+SsG50nBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GTcIZB1mSpuFwcAyWNKV2m0Po4twk5AZT2Qher33D0=;
 b=etRdOhkzabmDP7IlO2mqS6bhGQ+hoER32gMYAelzDtu2zm/Rtj2PHrT4oqa3ju3rrLQ5EdDxHQdLOsLOGNfNUMWGREVFrf032QmsvzkUh4+lu2Edmu8jNpjfe/o9zYlWUdSIXuSwAjdU5qhMpn4icMooJsGHP5P1wKgK7QpqKUA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2840.namprd15.prod.outlook.com (2603:10b6:a03:b2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 18:12:07 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 18:12:07 +0000
Date:   Tue, 3 Nov 2020 10:12:00 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH v2 5/5] selftest/bpf: Use global variables
 instead of maps for test_tcpbpf_kern
Message-ID: <20201103181200.5h4pp4p3issazgpd@kafai-mbp.dhcp.thefacebook.com>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417035730.2823.6697632421519908152.stgit@localhost.localdomain>
 <20201103012552.twbqzgbhc35nushq@kafai-mbp.dhcp.thefacebook.com>
 <CAKgT0UebGOEf4aqAqsisUVKzU6+pas+qFkHy-OoHeHYTCAE_+A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UebGOEf4aqAqsisUVKzU6+pas+qFkHy-OoHeHYTCAE_+A@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1da0]
X-ClientProxiedBy: MWHPR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:300:4b::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1da0) by MWHPR02CA0009.namprd02.prod.outlook.com (2603:10b6:300:4b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 18:12:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 790b5c3e-1116-4e35-1067-08d88023f982
X-MS-TrafficTypeDiagnostic: BYAPR15MB2840:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2840529A9074EEC248D274F5D5110@BYAPR15MB2840.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwHxROnq8zi5BWFhOItnXoDN+M5eR0DW9V+ixWSCC40t9JKfigBsWt/qKdI6CK00juAL7znTTUzjZy5JNcBTXLJuWLlLh37m1TF6q27QRYm0c4+hwm8OzxJvRBH5DDZRAXlvsJYIe61cSLEVDj2Fztb02AcSATXliCrP34UaXj3idOOjkNI43Ha5RWb2DxRVXZdH0jFEUf0Rj+oXCKS7wuiAownnZQ2VTFpJ1OIUXRD3yHCGWYbcomhqfpokQcmf4MjpStGvSIXNeuPpNzgZpKaqbiKty0Yazx4Bot6n1IT8rumVKEsqfUvG5tcU72bt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39860400002)(366004)(376002)(7696005)(16526019)(54906003)(316002)(52116002)(186003)(6666004)(66476007)(66946007)(66556008)(478600001)(6916009)(2906002)(8676002)(83380400001)(86362001)(5660300002)(8936002)(4326008)(9686003)(53546011)(6506007)(55016002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /Jp++xnCePKoQPXOkae5o8dVlswghqv5ghF636mJ6Am2TEdHuO2q0dF+2Qp8CQjVEPumtb05FTAsJCk2d1Kbyh07wMZaqZHWRWcyGriOXxHcNh7Yx1detLuT2xW098r2YZI62Pf4b41OSDZowuE2sRVzBloRycZcKaHa6ublTh06tIs1aEBByNdtYf2RdOZdeCSNDIT5xGiL0rrHeG5jdocO8qMxwZUMpbVureo1YeeOkHv3sCuDS/z9bV86CHV/gzqBpTLNoPcmJRj9mRV8jmDe8lmqvacGVLqBOCeQvQZgh01f+dFlbBGieVU2Pf2WYXQ7RN+RBp5vYKEYXBwsmPeRoyaB8VZFyUpsTz4a1kq6DBLep0uXp3yPwMcW8UOMufBzjmrSkv7AykNsRMxfbQjHCz3bvD6h5tiqguuKsetegU5b2uIRXo5W2dcNvoZUyGON+veMV9AFEpwSXopRDnT0CyiaUA3I0k0vkMUp9Cwq7Mh/Mjra23E+eL7HKIM/oT48zaId7QR9jg+FcXRwDVJHWHie82O36AGSDXwBsmCH5Oe3zlMu5HGtI5rCLToGrfkn4/5j7L+ef1foxt2GaHRfDh4PMUcU9lyt9ICrGpqCfw8WximuCNEktWgCDuJs5P/SaqeZih+am2scjoQW/m4IKd/RgkQO8dG94zWpmGM=
X-MS-Exchange-CrossTenant-Network-Message-Id: 790b5c3e-1116-4e35-1067-08d88023f982
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 18:12:07.3365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yetGtiA8WNnHTHpYUN3vhkmIuRgAnby6s3mnby2a21vM332/GZENf0cmsi5ExsWq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=708 priorityscore=1501 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 07:42:46AM -0800, Alexander Duyck wrote:
> On Mon, Nov 2, 2020 at 5:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Sat, Oct 31, 2020 at 11:52:37AM -0700, Alexander Duyck wrote:
> > [ ... ]
> >
> > > +struct tcpbpf_globals global = { 0 };
> > >  int _version SEC("version") = 1;
> > >
> > >  SEC("sockops")
> > > @@ -105,29 +72,15 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> > >
> > >       op = (int) skops->op;
> > >
> > > -     update_event_map(op);
> > > +     global.event_map |= (1 << op);
> > >
> > >       switch (op) {
> > >       case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
> > >               /* Test failure to set largest cb flag (assumes not defined) */
> > > -             bad_call_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
> > > +             global.bad_cb_test_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
> > >               /* Set callback */
> > > -             good_call_rv = bpf_sock_ops_cb_flags_set(skops,
> > > +             global.good_cb_test_rv = bpf_sock_ops_cb_flags_set(skops,
> > >                                                BPF_SOCK_OPS_STATE_CB_FLAG);
> > > -             /* Update results */
> > > -             {
> > > -                     __u32 key = 0;
> > > -                     struct tcpbpf_globals g, *gp;
> > > -
> > > -                     gp = bpf_map_lookup_elem(&global_map, &key);
> > > -                     if (!gp)
> > > -                             break;
> > > -                     g = *gp;
> > > -                     g.bad_cb_test_rv = bad_call_rv;
> > > -                     g.good_cb_test_rv = good_call_rv;
> > > -                     bpf_map_update_elem(&global_map, &key, &g,
> > > -                                         BPF_ANY);
> > > -             }
> > >               break;
> > >       case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
> > >               skops->sk_txhash = 0x12345f;
> > > @@ -143,10 +96,8 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> > >
> > >                               thdr = (struct tcphdr *)(header + offset);
> > >                               v = thdr->syn;
> > > -                             __u32 key = 1;
> > >
> > > -                             bpf_map_update_elem(&sockopt_results, &key, &v,
> > > -                                                 BPF_ANY);
> > > +                             global.tcp_saved_syn = v;
> > >                       }
> > >               }
> > >               break;
> > > @@ -156,25 +107,16 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> > >               break;
> > >       case BPF_SOCK_OPS_STATE_CB:
> > >               if (skops->args[1] == BPF_TCP_CLOSE) {
> > > -                     __u32 key = 0;
> > > -                     struct tcpbpf_globals g, *gp;
> > > -
> > > -                     gp = bpf_map_lookup_elem(&global_map, &key);
> > > -                     if (!gp)
> > > -                             break;
> > > -                     g = *gp;
> > >                       if (skops->args[0] == BPF_TCP_LISTEN) {
> > > -                             g.num_listen++;
> > > +                             global.num_listen++;
> > >                       } else {
> > > -                             g.total_retrans = skops->total_retrans;
> > > -                             g.data_segs_in = skops->data_segs_in;
> > > -                             g.data_segs_out = skops->data_segs_out;
> > > -                             g.bytes_received = skops->bytes_received;
> > > -                             g.bytes_acked = skops->bytes_acked;
> > > +                             global.total_retrans = skops->total_retrans;
> > > +                             global.data_segs_in = skops->data_segs_in;
> > > +                             global.data_segs_out = skops->data_segs_out;
> > > +                             global.bytes_received = skops->bytes_received;
> > > +                             global.bytes_acked = skops->bytes_acked;
> > >                       }
> > > -                     g.num_close_events++;
> > > -                     bpf_map_update_elem(&global_map, &key, &g,
> > > -                                         BPF_ANY);
> > It is interesting that there is no race in the original "g.num_close_events++"
> > followed by the bpf_map_update_elem().  It seems quite fragile though.
> 
> How would it race with the current code though? At this point we are
> controlling the sockets in a single thread. As such the close events
> should already be serialized shouldn't they? This may have been a
> problem with the old code, but even then it was only two sockets so I
> don't think there was much risk of them racing against each other
> since the two sockets were linked anyway.
> 
> > > +                     global.num_close_events++;
> > There is __sync_fetch_and_add().
> >
> > not sure about the global.event_map though, may be use an individual
> > variable for each _CB.  Thoughts?
> 
> I think this may be overkill for what we actually need. Since we are
> closing the sockets in a single threaded application there isn't much
> risk of the sockets all racing against each other in the close is
> there?
Make sense.

Acked-by: Martin KaFai Lau <kafai@fb.com>
