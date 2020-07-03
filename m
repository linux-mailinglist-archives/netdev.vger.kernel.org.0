Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13AC2130D5
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 03:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgGCBIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 21:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGCBIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 21:08:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3C8C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 18:08:06 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so34649038ljg.13
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 18:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xhJ/3m0KcF51XQMCDykPvx6FH+Zxv6t6Wm2boNZX4GA=;
        b=HRnc8Z/UWD1VH3SDqiH4lfspf3ok3r+xS7c66s+ynb3ZzlBkN2PSz5kYMKHrzl7TQ4
         fZ8+IFqVBJWm7YWqXIR8IP8nkdyQC3joTYpIj49kaBTa633kHTrhJhFkqzD8TramRmM1
         Yo4ZUFvd4iiBdz/qOIz2C16Di7gBSp0vYJurQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xhJ/3m0KcF51XQMCDykPvx6FH+Zxv6t6Wm2boNZX4GA=;
        b=lEKpTmxogNTg5WFRccl45nCAfMHV2QV4pDE03OE3EbOcrfYhmA+NtNxL8TJrmEuCEo
         dBfnYR/LJ1LLC9bmd4fZdf5DDopX6Lc4XMlB8ZvVUShUcPZsC2KNp9f7iRLinbN5irKJ
         0W+y/izogt2ZUFmpIewxPaYfsFJ+bBOKhLNLtqjjletycVvAO/yKivAbhPDB6ZLmhOMs
         Oq5dFULwWW8DtIbxgmBLSqZbxonJgwnCbxByetg86jPqWFlYx80EIGyh+v7ZJSlFPU19
         U1KdjLDVks0isY/l0VL6EDeVW35+0h5CzBEEfZu7Qe/XMDOUrgykMcT1IWzs3Ylt2S1W
         H7Iw==
X-Gm-Message-State: AOAM530Pb+5y6G+mCPnPCihReQAnxYvwlSa2L2WilZq8WKN7tkwcbQVs
        5cawEiuSgZSVU3mXhodiQtEcqzpZKuU=
X-Google-Smtp-Source: ABdhPJyArSv8eduVi4UUve4IhipFirXRO2zIvwylPICHi6r6jSmNd3WY7l70DlWmrQ+w8uQ/GNEB0g==
X-Received: by 2002:a2e:8601:: with SMTP id a1mr16568083lji.255.1593738484126;
        Thu, 02 Jul 2020 18:08:04 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id d23sm4003148lfm.85.2020.07.02.18.08.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 18:08:03 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id m26so17360661lfo.13
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 18:08:03 -0700 (PDT)
X-Received: by 2002:a2e:9c92:: with SMTP id x18mr12604594lji.70.1593738033657;
 Thu, 02 Jul 2020 18:00:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200702232638.2946421-1-keescook@chromium.org> <20200702232638.2946421-5-keescook@chromium.org>
In-Reply-To: <20200702232638.2946421-5-keescook@chromium.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Jul 2020 18:00:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
Message-ID: <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
Subject: Re: [PATCH 4/5] kprobes: Do not expose probe addresses to non-CAP_SYSLOG
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable <stable@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 4:26 PM Kees Cook <keescook@chromium.org> wrote:
>
> The kprobe show() functions were using "current"'s creds instead
> of the file opener's creds for kallsyms visibility. Fix to use
> seq_file->file->f_cred.

Side note: I have a distinct - but despite that possibly quite
incorrect - memory that I've discussed with somebody several years ago
about making "current_cred()" simply warn in any IO context.

IOW, we could have read and write just increment/decrement a
per-thread counter, and have current_cred() do a WARN_ON_ONCE() if
it's called with that counter incremented.

The issue of ioctl's is a bit less obvious - there are reasons to
argue those should also use open-time credentials, but on the other
hand I think it's reasonable to pass a file descriptor to a suid app
in order for that app to do things that the normal user cannot.

But read/write are dangerous because of the "it's so easy to fool suid
apps to read/write stdin/stdout".

So pread/pwrite/ioctl/splice etc are things that suid applications
very much do on purpose to affect a file descriptor. But plain
read/write are things that might be accidental and used by attack
vectors.

If somebody is interested in looking into things like that, it might
be a good idea to have kernel threads with that counter incremented by
default.

Just throwing this idea out in case somebody wants to try it. It's not
just "current_cred", of course. It's all the current_cred_xxx() users
too. But it may be that there are a ton of false positives because
maybe some code on purpose ends up doing things like just *comparing*
current_cred with file->f_cred and then that would warn too.

              Linus
