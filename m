Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126601EB189
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgFAWM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAWM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:12:27 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E960DC061A0E;
        Mon,  1 Jun 2020 15:12:26 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z6so10076302ljm.13;
        Mon, 01 Jun 2020 15:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X01eqMYc81woUcmpSUPGRzlhDRJtCzDWeyGqFlG4/aM=;
        b=W7GZXmfjdyx6EeH96XtbpIu/ZotOs7kxcv68Tr3n1LYMX3vilT9eeX6i1VNaSl/r8C
         jbRwFTUbJQESCEE53wpdlx8QglW8Edg07FIwCAw2K1g5GDOL06WRgQBz+wsPe6qeCqaq
         wo8jetELFD+vtGHS0fJ7yAemb6nz/Q6VPzgM+T8DQQ22E4scsExbr3kEkcbtVuzUfonb
         1tMsGCce3wYdzdwaJFu0AGvtQm/fD/1MhewlBy5IQmS+L+bqAM0vW+UQMMDXKaE/aYAx
         Wj8xB7PQPEd65nm+oR9VEJFcExAbfnMy3FSN43LcSnAOxu7cUJjTidAk69cXmkKpXorx
         328w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X01eqMYc81woUcmpSUPGRzlhDRJtCzDWeyGqFlG4/aM=;
        b=rlqbaPnvD6jhSRg5ChuAX5b0H8Y3kPUIv0FjEYCIvMr1/1RQuYh/wYk3bzlbXRvesq
         0kJU7XI+1d+4gb+d5afprZDlEMKzX/O6/mf9e1AhPmqzLJoJZ9xRpDXCzVv2xQdLTwXJ
         4F4mRMmHMjnarfD4U0f8t5cnxK2CIC+6HjW7ERowixNsNjsGmNl2ydAgYcx/0Ac4cDut
         3u1h01/NPDWLBxyRpGQea+eve6ifq4cyM8zBdhsrJHZxSgwHG24FKBmVNu626vLSAL7i
         ewMBfnDul6SEd3cRJkzcNsE23VuyKMmCgFX9nsHIZfACkSsWKQ3nMswr+IYM56nV5MUD
         OGjQ==
X-Gm-Message-State: AOAM532X5cQzuiHlyi1OmmmPU31eEjwIANCPd6+p7jdDo33hY8rXs/Z7
        zVvEtp02xOUqwBA/Fdfg4E3EQKBrBOJwBb9VAwM=
X-Google-Smtp-Source: ABdhPJyyqVlDOt0cSfSbu61KA5r+u2wYZXbj6Li03g9ye+KgwdbDawFbwJsH8hJR0yU4dk2Rhx71muBqAnig14njZnU=
X-Received: by 2002:a2e:81d1:: with SMTP id s17mr12109318ljg.91.1591049545292;
 Mon, 01 Jun 2020 15:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200531154255.896551-1-jolsa@kernel.org> <CAPhsuW7HevOVgEe-g3RH_OmRqzWedXzGkuoNNzJfSwKhtzGxFw@mail.gmail.com>
In-Reply-To: <CAPhsuW7HevOVgEe-g3RH_OmRqzWedXzGkuoNNzJfSwKhtzGxFw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 15:12:13 -0700
Message-ID: <CAADnVQJquAF=XOjbyj-xmKupyCa=5O76QXWf6Pjq+j+dTvaEpg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Use tracing helpers for lsm programs
To:     Song Liu <song@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 12:00 PM Song Liu <song@kernel.org> wrote:
>
> On Sun, May 31, 2020 at 8:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Currenty lsm uses bpf_tracing_func_proto helpers which do
> > not include stack trace or perf event output. It's useful
> > to have those for bpftrace lsm support [1].
> >
> > Using tracing_prog_func_proto helpers for lsm programs.
>
> How about using raw_tp_prog_func_proto?

why?
I think skb/xdp_output is useful for lsm progs too.
So I've applied the patch.

> PS: Please tag the patch with subject prefix "PATCH bpf" for
> "PATCH bpf-next". I think this one belongs to bpf-next, which means
> we should wait after the merge window.

+1.
Jiri,
pls tag the subject properly.
