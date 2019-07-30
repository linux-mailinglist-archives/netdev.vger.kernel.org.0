Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077407B3FF
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfG3UEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:04:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38870 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfG3UEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:04:13 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so64231912qtl.5
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 13:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R5G+J2CfJFGQTteb/6rfIV/g2hGiN14CsEzigoU7POI=;
        b=CjoWrBZ922n0H3FvaNp/8daO2rhHRrCodR6ZQQGsemHGVzDFoEIVWwPCbxWHPkejt/
         UPgycxgKSGmDs3PJV/IJPzaK7czd/vDm44AjP11M67aoirIQ9b3DBKJmvbkS3WMDm9Or
         mEpgeajxy+xhNbC7o18O1KuTxsVrrlaYvy6kJzoMv7A3BG03nm3qK8mjwo9OSQVRQEih
         C0Pf9jPX3gixJ2kg8IPGpTQGZlfhEQoC2xHCK3h3lna/0lYcdh1t8bdw3wNwC7PNtlDC
         /93AyYjnCJdm5oTMUBheU+hLF/K/g++gSMxcU/jTz10IBTzwmkfxTmcHFcJ0nebZkRgX
         U2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R5G+J2CfJFGQTteb/6rfIV/g2hGiN14CsEzigoU7POI=;
        b=oswY5Arv5fP4JlAMUcBc6GtbThOBGwARFMyfHdWY2nHIHBu7w45kDGqkAbZ5q/56ge
         NShi4VtwXNShcsXK6pXOycYxKWpTdGClw4lib751uJHv9V6KZAnzrSM6IEHzorj1Mka+
         2hBheo5NCdDtYGVapzOi0a/g353dNnmYfJHZcfYM16MBVYtSC+nAfq9RlKBnxmsNprye
         AZkjU2Up+9pePvEvtct4M5epK39dLxKglkQGZOxIil8F075ZxMCwoD9kxnHoJk/ANyYx
         KFDBP/5z9sh3HTOj4jIenbPQys8dSZOl+O4lWUhLnaIo1Bpnm5yxjMP0jK2xPYZ06S8V
         uJ9w==
X-Gm-Message-State: APjAAAUnepSam8O8vQzXYq19hKStoibvu6M6KdOEMaa4Ut/zZJWYh8zj
        FERc8a9DqJM77FQvuVWWfk4wISHCJdWB7t3p0i4=
X-Google-Smtp-Source: APXvYqz53I/pXpY7jM3UG4xR0xKx4hOYGG+kBlNJ9EPiUbIFuZGuWNFgvbxlzPfzLXw/MS2CjInu8G2X+78Q+xyUqG0=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr86243864qvv.38.1564517051960;
 Tue, 30 Jul 2019 13:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190730184821.10833-1-danieltimlee@gmail.com>
In-Reply-To: <20190730184821.10833-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jul 2019 13:04:00 -0700
Message-ID: <CAEf4BzZTNTdiHs1VYzeKSBGka8ayq_9WCf5cJxzW94nR3FOFQQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load XDP
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 11:48 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, bpftool net only supports dumping progs loaded on the
> interface. To load XDP prog on interface, user must use other tool
> (eg. iproute2). By this patch, with `bpftool net (un)load`, user can
> (un)load XDP prog on interface.
>
>     $ ./bpftool prog
>     ...
>     208: xdp  name xdp_prog1  tag ad822e38b629553f  gpl
>       loaded_at 2019-07-28T18:03:11+0900  uid 0
>     ...
>     $ ./bpftool net load id 208 xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     enp6s0np1(5) driver id 208
>     ...
>     $ ./bpftool net unload xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     ...
>
> The word 'load' is used instead of 'attach', since XDP program is not

Let's be consistent and "attach" everything. Tracing BPF programs
(kprobe, tracepoints) are also not attached with BPF_PROG_ATTACH, but
it's still a process of attaching BPF program to a BPF hook (a point
in the system which can execute BPF program).

Even better, if you can check what we recently did for tracing APIs
with struct bpf_link and can add similar APIs for XDP programs, it
would be a nice step towards consistency of APIs (and terminology as
well). Please consider doing that. Thanks!

> considered as 'bpf_attach_type' and can't be attached with
> 'BPF_PROG_ATTACH'. In this context, the meaning of 'load' is, prog will
> be loaded on interface.
>
> While this patch only contains support for XDP, through `net (un)load`,
> bpftool can further support other prog attach types.
>
> XDP (un)load tested on Netronome Agilio.
>
> Daniel T. Lee (2):
>   tools: bpftool: add net load command to load XDP on interface
>   tools: bpftool: add net unload command to unload XDP on interface
>
>  tools/bpf/bpftool/net.c | 160 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 159 insertions(+), 1 deletion(-)
>
> --
> 2.20.1
>
