Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505B7508D0B
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 18:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380473AbiDTQUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 12:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380464AbiDTQUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 12:20:46 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2112F3AE;
        Wed, 20 Apr 2022 09:18:00 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b5so1313846ile.0;
        Wed, 20 Apr 2022 09:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XbhXfA4i8EWyzfGIfVps9mO1QV1q4FKoW3ua2nrNi4U=;
        b=XLg/7DADRcCpwg8VP68vQDBAh7NGr50XxillDADzF6rWFaNUCfB97v7o+PY9wG4ssO
         3jZ15HFGeKpYzlmIw8nqxu70NeImXaWd6ixiKQOA3Ccxb/8bCT6j1SYqQjIrogbW/ASN
         bbrtIq+fGxuFqWE8jSsIJ7gSHKVt2LlR1Ejo2KJYERwvdjgKPtw57x9rz9kfo73/MPVZ
         gX7ob3cH9hKzrVAnckdvJuXU5G/FfU1E+3lWR7aHr1g2GssSqU65PaM9UWe7/EuJE5tA
         V7ZO3wg+Is0IG5GsJO2QJTU1wiKbsFbFoY3Ml5TPLM7cl8R3GlGxAbmx8it6sTFdbIXe
         6Z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XbhXfA4i8EWyzfGIfVps9mO1QV1q4FKoW3ua2nrNi4U=;
        b=6Pr3CuybFL2CcYWfQ+1qMICDmiDOoHULQFxbBRC9m8MT0ims3GoBVX/cOtXl9Dx01J
         D//74JzQCEAQmzG1NC6vaGfTTez3qwekpegUzFtJLmA99AqJkPzbGtiQXazmhbjK2vt+
         Syw2jMd+K6XqgDR7fs+Iq8AWwACJK5Fwd3YhY2ZgaOZlicLIq+UFNxegcClER/zy8BvC
         yqHBZxfKCXYCADo5x7iv2AZcv16QAQ0pj3wxgAjNpr2OPWq6QaiF++f8XNur3eUBPjL9
         JmmNUvFGUYsik5H4JfrGMSrYyPMCHrkSCHb8kWwZt/HxM6dS6z22t+navGqtk8dMz/7r
         9oAA==
X-Gm-Message-State: AOAM533S5CvCaSOaExjwY+f1CN243vHRmrCcRwVio1vtAMYttOT77yYS
        Fbvb38LAnYwqAdcwZVWH+poYuerh8VI2LSIaSMY=
X-Google-Smtp-Source: ABdhPJxezi1FVoE6RbVvyQLeVbrRqsbrVP3qd8jdamfsRgiRwH2kLnxLNHD/y26thb9QSFWo6/YswMONn/fJu9WWd/s=
X-Received: by 2002:a92:c247:0:b0:2cc:1798:74fe with SMTP id
 k7-20020a92c247000000b002cc179874femr8160249ilo.239.1650471479496; Wed, 20
 Apr 2022 09:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220420122307.5290-1-xiangxia.m.yue@gmail.com> <878rrzj4r6.fsf@toke.dk>
In-Reply-To: <878rrzj4r6.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 09:17:48 -0700
Message-ID: <CAEf4Bzafe3Am5uep7erd7r+-pgdGRc9hsJASYfFH47ty8x9mTA@mail.gmail.com>
Subject: Re: [net-next v1] bpf: add bpf_ktime_get_real_ns helper
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 5:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@kern=
el.org> wrote:
>
> xiangxia.m.yue@gmail.com writes:
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch introduce a new bpf_ktime_get_real_ns helper, which may
> > help us to measure the skb latency in the ingress/forwarding path:
> >
> > HW/SW[1] -> ip_rcv/tcp_rcv_established -> tcp_recvmsg_locked/tcp_update=
_recv_tstamps
> >
> > * Insert BPF kprobe into ip_rcv/tcp_rcv_established invoking this helpe=
r.
> >   Then we can inspect how long time elapsed since HW/SW.
> > * If inserting BPF kprobe tcp_update_recv_tstamps invoked by tcp_recvms=
g,
> >   we can measure how much latency skb in tcp receive queue. The reason =
for
> >   this can be application fetch the TCP messages too late.
>
> Why not just use one of the existing ktime helpers and also add a BPF
> probe to set the initial timestamp instead of relying on skb->tstamp?
>

You don't even need a BPF probe for this. See [0] for how retsnoop is
converting bpf_ktime_get_ns() into real time.

  [0] https://github.com/anakryiko/retsnoop/blob/master/src/retsnoop.c#L649=
-L668

> -Toke
