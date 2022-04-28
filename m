Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1111512968
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241312AbiD1CTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiD1CTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:19:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A16C403D3;
        Wed, 27 Apr 2022 19:16:31 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l18so6762656ejc.7;
        Wed, 27 Apr 2022 19:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g6n4I6TzHwm8R8g8eqrBG0aoEKEyYwydlynw+Z/STwg=;
        b=ku/E4116+dMLILT4mN2sMMQur+bfyHDMJSM0bzMZjVR8KiOgz7dtnUCnuRD739CQKz
         D6FQW0KYHyHbH3ZlllgrLiOPipzpU0k4fqC+ba7POBnZgCrpmpTgM/jYEZtEE3gPtcIm
         Gf01Llh57JZ2sHPyZbS0pkzKheRjPWmBZDrcgIvUvEAsjh+XvA1vz9mDPYe02aFDsRJ0
         1WguS39fo+cs7JoopiE31hJENrH7rXLfCa0VEucRrCEf69SvmFCrz+8xOCWFcWNFB8jv
         ydXxRzfWZIwRgtEZJeiZVKfERtRLpVjnmKb0fWzMng2x1yudKxpSoGIMfZ7CqF44yGlc
         EIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g6n4I6TzHwm8R8g8eqrBG0aoEKEyYwydlynw+Z/STwg=;
        b=RUp/w6LVd1aFXW5NFqT8YUvcGuTFRyPvpcCViZFG97WB4mLr69oSsG3JlduR5bThtQ
         kfXtaG6QhgxKR4dsNuVdTqg0WFIT1gPSTz+VbFdK43ODbmFMshR2B4zSX3uZagyJyxWI
         DxNPMxw1Uag9yYB+ncI7l/g+OYd2sLSe6Xoga6BDa7HdtufXrkjb12RksAUi0HQXz4q6
         1UmhSeEydaiKMUbVpZIXBl9vAAOEOKgE7JMj23Ke+vXcA2W5Bgib0EXp9XDeaK9Gka+z
         MhGD87SNeCl0SIwIt4gqRjXK2OGv2EJcUX1fk31wNkT0GJtcpr3GImskh24EPtlBZG41
         sD0g==
X-Gm-Message-State: AOAM533vYZIYBjh8mA5/QWKVYynUM6goqaWGwhueT+WAUnYQ1aRrf17u
        RvK58E0s+I3hx5dqg6+KQ8iLM9+CS4lij5Ugi5o=
X-Google-Smtp-Source: ABdhPJzuVrDZHKHiIgL3id6MfcVjsETQberIVpBsIg8AwLyb07WsbDXgKe2XUscNBJikhYAOJI7NidpImlXQDpns3TQ=
X-Received: by 2002:a17:907:c06:b0:6e0:9149:8047 with SMTP id
 ga6-20020a1709070c0600b006e091498047mr28563176ejc.765.1651112189989; Wed, 27
 Apr 2022 19:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220427070644.319661-1-imagedong@tencent.com> <CAEf4BzaED-93fAR9YYA2RcCYNgzqAQki6exMyoabiZfJMVd-aQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaED-93fAR9YYA2RcCYNgzqAQki6exMyoabiZfJMVd-aQ@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 28 Apr 2022 10:16:18 +0800
Message-ID: <CADxym3bt0c52iZjtfjT+pQtDhWo6YuwPS1W59E-yQh28m2k3Rg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: bpf: support direct packet access in
 tracing program
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 4:08 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Apr 27, 2022 at 12:08 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, eBPF program of type TRACING is able to access the arguments
> > of the function or raw_tracepoint directly, which makes data access
> > easier and efficient. And we can also output the raw data in skb to
> > user space in tracing program by bpf_skb_output() helper.
> >
> > However, we still can't access the packet data in 'struct sk_buff'
> > directly and have to use the helper bpf_probe_read_kernel() to analyse
> > packet data.
> >
> > Network tools, which based on eBPF TRACING, often do packet analyse
> > works in tracing program for filtering, statistics, etc. For example,
> > we want to trace abnormal skb free through 'kfree_skb' tracepoint with
> > special ip address or tcp port.
> >
> > In this patch, 2 helpers are introduced: bpf_skb_get_header() and
> > bpf_skb_get_end(). The pointer returned by bpf_skb_get_header() has
> > the same effect with the 'data' in 'struct __sk_buff', and
> > bpf_skb_get_end() has the same effect with the 'data_end'.
> >
> > Therefore, we can now access packet data in tracing program in this
> > way:
> >
> >   SEC("fentry/icmp_rcv")
> >   int BPF_PROG(tracing_open, struct sk_buff* skb)
> >   {
> >         void *data, *data_end;
> >         struct ethhdr *eth;
> >
> >         data = bpf_skb_get_header(skb, BPF_SKB_HEADER_MAC);
> >         data_end = bpf_skb_get_end(skb);
> >
> >         if (!data || !data_end)
> >                 return 0;
> >
> >         if (data + sizeof(*eth) > data_end)
> >                 return 0;
> >
> >         eth = data;
> >         bpf_printk("proto:%d\n", bpf_ntohs(eth->h_proto));
> >
> >         return 0;
> >   }
> >
> > With any positive reply, I'll complete the selftests programs.
>
> See bpf_dynptr patches that Joanne is working on. That's an
> alternative mechanism for data/data_end and is going to be easier and
> more flexible to work with. It is the plan that once basic bpf_dynptr
> functionality lands, we'll have dynptr "constructors" for xdp_buff and
> sk_buff. I think it's a better path forward.
>

Yeah, bpf_dynptr seems to be a nice feature, which I didn't notice :/
Thanks for your explanation.

Menglong Dong

> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/bpf.h      |  4 +++
> >  include/uapi/linux/bpf.h | 29 ++++++++++++++++++++
> >  kernel/bpf/verifier.c    |  6 +++++
> >  kernel/trace/bpf_trace.c | 58 ++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 97 insertions(+)
> >
>
> [...]
