Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9908F8A64D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfHLS1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:27:48 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45752 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHLS1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:27:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id k13so6520681qtm.12
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UFmJ62GtoLvqYi8njDlQ/qQ9sPttM8EaiQ4r4JYkXe0=;
        b=XtCnOr53PPSxq71/F9W7J5eLqFcScA4btlXZ2JipJBhYMBwgo8nEJxrZl1uH+k/EzA
         KhygmQ1CZvkM/lywroLJERHWxk/14KpkGWW2P1Cy2ZRkIuLRG2mTtTUo+V6GcrniwrUf
         DfhnLTARcc48Kd041g/E3ndDl7YhukfPRPz9bXFxiErw22WXgNKWWIgYAoaGiifyWK0j
         fEnwXobmD49f17y9TzEhacgUxS1zVewX+eLIMDkOc8UXihAqD5uW8EqKD4Yug+0coNrM
         3gLXVGYorktiBFHDoRwMpJdHMNr3XAwqneHZRKdrmYdY13gRTQbDAfg45cvuW8hf27Aq
         6Gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UFmJ62GtoLvqYi8njDlQ/qQ9sPttM8EaiQ4r4JYkXe0=;
        b=NcL27xUw5+4nH5mtVHGKnuQ3inwBJ4WDhvK15lfB0ZDnvwS7SUkuv3Y/LkilMB7osq
         2/1uBa4YStCogqA8JRUUNai4b/P9TDGWeof3/jFlWwCjvx7tM+4BXJiS34ItlngFHBs0
         Yi/++2dVOKz7EZuU/5PbbPhAM03Ptjl1M2eoyr8yKNe67Kabv/Ob4unvkfVppuKehl9x
         YUgnSOxmpVN4K6CVB/76gFVsCwJAjShtSKj0uzUS+vIXYmqoWc5kPGsmGhKiZKSMq1+X
         bYEWxU5m/Lm57ijPmlaB4w1v7NjdUi9c1IAstfRfxMBLEDHe4ruJ6dBV3q6aDybd3R+T
         wVZQ==
X-Gm-Message-State: APjAAAWIDz1zuW0pfxSqp9oi/CgUruelzRC1Vs7jAKA3TkSgXnLh365b
        95vy/uozxBBwaJOkUMRs2QVgmJAWS0sDDwniSOU=
X-Google-Smtp-Source: APXvYqw94lGVzW4lm5XzcFI9r0MqZgK1q9JSVbghkN+CPCS3LQEKQ7t0vTC0Ak2nrfLMTOk3jn8WG/hLZGos9yIgHv8=
X-Received: by 2002:ac8:32a1:: with SMTP id z30mr31249580qta.117.1565634467266;
 Mon, 12 Aug 2019 11:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAAej5NbkQDpDXEtsROmLmNidSP8qN3VRE56s3z91zHw9XjtNZA@mail.gmail.com>
In-Reply-To: <CAAej5NbkQDpDXEtsROmLmNidSP8qN3VRE56s3z91zHw9XjtNZA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 12 Aug 2019 11:27:36 -0700
Message-ID: <CAEf4BzZ27SnYkQ=psqxeWadLhnspojiJGQrGB0JRuPkP+GTiNQ@mail.gmail.com>
Subject: Re: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
To:     Fejes Ferenc <fejes@inf.elte.hu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 1:59 AM Fejes Ferenc <fejes@inf.elte.hu> wrote:
>
> Greetings!
>
> I found a strange error when I tried to load a BPF_CGROUP_INET_EGRESS
> prog with bpftool. Loading the same program from C code with
> bpf_prog_load_xattr works without problem.
>
> The error message I got:
> bpftool prog loadall hbm_kern.o /sys/fs/bpf/hbm type cgroup/skb

You need "cgroup_skb/egress" instead of "cgroup/skb" (or try just
dropping it, bpftool will try to guess the type from program's section
name, which would be correct in this case).

> libbpf: load bpf program failed: Invalid argument
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> ; return ALLOW_PKT | REDUCE_CW;
> 0: (b7) r0 = 3
> 1: (95) exit
> At program exit the register R0 has value (0x3; 0x0) should have been
> in (0x0; 0x1)
> processed 2 insns (limit 1000000) max_states_per_insn 0 total_states 0
> peak_states 0 mark_read 0
>
> libbpf: -- END LOG --
> libbpf: failed to load program 'cgroup_skb/egress'
> libbpf: failed to load object 'hbm_kern.o'
> Error: failed to load object file
>
>
> My environment: 5.3-rc3 / net-next master (both producing the error).
> Libbpf and bpftool installed from the kernel source (cleaned and
> reinstalled when I tried a new kernel). I compiled the program with
> Clang 8, on Ubuntu 19.10 server image, the source:
>
> #include <linux/bpf.h>
> #include "bpf_helpers.h"
>
> #define DROP_PKT        0
> #define ALLOW_PKT       1
> #define REDUCE_CW       2
>
> SEC("cgroup_skb/egress")
> int hbm(struct __sk_buff *skb)
> {
>         return ALLOW_PKT | REDUCE_CW;
> }
> char _license[] SEC("license") = "GPL";
>
>
> I also tried to trace down the bug with gdb. It seems like the
> section_names array in libbpf.c filled with garbage, especially the

I did the same, section_names appears to be correct, not sure what was
going on in your case. The problem is that "cgroup/skb", which you
provided on command line, overrides this section name and forces
bpftool to guess program type as BPF_CGROUP_INET_INGRESS, which
restricts return codes to just 0 or 1, while for
BPF_CGROUP_INET_EGRESS i is [0, 3].

> expected_attach_type fields (in my case, this contains
> BPF_CGROUP_INET_INGRESS instead of BPF_CGROUP_INET_EGRESS).
>
> Thanks!
