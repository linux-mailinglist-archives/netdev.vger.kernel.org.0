Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69799F819
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 04:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfH1CAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 22:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbfH1CAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 22:00:55 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B2E23406
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 02:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566957653;
        bh=AP7WKXMKH8JAGUlgFkOqC5LEdoLGq2navL+/ozcyKKA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iRaaimshFuvzXzlPUgD9XckqINKOZ17QCJ5V164gp6IYXiuuvRXq7IsPh7Z6ymT6S
         cHT8FqVb5xACaMkIFmuiF5HvaOqiF361Ak9DJh7w1776AFSDhlMijXKd8j08xBXBNI
         akDtGBQsNMzUlh3cyuBInwV9XzvpTuJo9GGzwirg=
Received: by mail-wm1-f44.google.com with SMTP id d16so1050798wme.2
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 19:00:53 -0700 (PDT)
X-Gm-Message-State: APjAAAUUQYPNWfGZUQwj6n6b3RYWHvDcRSeSPzD+LBtKWjnfvFsdMKUj
        7h5mq/4ms+tF2U60odSr8H+NeR7ySxEOXs3tTNpBBQ==
X-Google-Smtp-Source: APXvYqyk9NE8dUGaMeQjdAeSfVuPRR4HyKn+obwNgjsa5cGe+ce+JC26pUDP8pHyW/dLbAv+UggkDAJu9kj8VuL8y+o=
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr1448267wmu.76.1566957651897;
 Tue, 27 Aug 2019 19:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com> <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
In-Reply-To: <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 27 Aug 2019 19:00:40 -0700
X-Gmail-Original-Message-ID: <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com>
Message-ID: <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Aug 27, 2019, at 5:55 PM, Andy Lutomirski <luto@kernel.org> wrote:
>
> On Tue, Aug 27, 2019 at 5:34 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>

> From the previous discussion, you want to make progress toward solving
> a lot of problems with CAP_BPF.  One of them was making BPF
> firewalling more generally useful. By making CAP_BPF grant the ability
> to read kernel memory, you will make administrators much more nervous
> to grant CAP_BPF.  Similarly, and correct me if I'm wrong, most of
> these capabilities are primarily or only useful for tracing, so I
> don't see why users without CAP_TRACING should get them.
> bpf_trace_printk(), in particular, even has "trace" in its name :)
>
> Also, if a task has CAP_TRACING, it's expected to be able to trace the
> system -- that's the whole point.  Why shouldn't it be able to use BPF
> to trace the system better?

Let me put this a bit differently. Part of the point is that
CAP_TRACING should allow a user or program to trace without being able
to corrupt the system. CAP_BPF as you=E2=80=99ve proposed it *can* likely
crash the system.  For example, CAP_BPF allows bpf_map_get_fd_by_id()
in your patch.  If the system uses a BPF firewall that stores some of
its rules in maps, then bpf_map_get_fd_by_id() can be used to get a
writable fd to the map, which can be used to change the map, thus
preventing network access.  This means that no combination of
CAP_TRACING and CAP_BPF ends up allowing tracing without granting the
ability to reconfigure or otherwise corrupt the system.
