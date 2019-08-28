Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C51F9FA54
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfH1GUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfH1GUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:20:34 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B4822CF5
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 06:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566973232;
        bh=Kpur9phQ2EXOoC2gEFS6X8rOZ61aH6EJmQNSMTQQzGs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Icvo6qVDRoaNS520LvHU9ehBnK9ZaMAU9Lg1DQyI0eU9zBBDbCJgQTS1zOw2FDZaJ
         EzT+xxwOxyW8SyloqzEd/YsaLl4wnPwupYfow8iaXd5sV51KhgRGHXqzeIOlKPIn29
         FNJXvc3kQ+owT9eux0Gs4bnpgFwl/uVR/K4bav8c=
Received: by mail-wm1-f43.google.com with SMTP id e8so4031870wme.1
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 23:20:32 -0700 (PDT)
X-Gm-Message-State: APjAAAUdR2Q9lzrBXwOJmtqM8v62V+StRvpnqK7u0I8aRT5kEtqsUTUF
        nPwcbtLjbo7DPYJ+mK7gyWUotB+6ygmARcbkYQMSXQ==
X-Google-Smtp-Source: APXvYqz3bvX3jRPeqDgNi/vT7/rlVue0wfdhO4v9+En2T98E4aslyf3V6KCSsA7oQXgDYVfTVYOgsIVAIJNxL1477cY=
X-Received: by 2002:a1c:c5c2:: with SMTP id v185mr2746446wmf.161.1566973231079;
 Tue, 27 Aug 2019 23:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com> <20190828044903.nv3hvinkkolnnxtv@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190828044903.nv3hvinkkolnnxtv@ast-mbp.dhcp.thefacebook.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 27 Aug 2019 23:20:19 -0700
X-Gmail-Original-Message-ID: <CALCETrX-bn2SpVzTkPz+A=z_oWDs7PNeouzK7wRWMzyaBd4+7g@mail.gmail.com>
Message-ID: <CALCETrX-bn2SpVzTkPz+A=z_oWDs7PNeouzK7wRWMzyaBd4+7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
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

On Tue, Aug 27, 2019 at 9:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 27, 2019 at 07:00:40PM -0700, Andy Lutomirski wrote:
> >
> > Let me put this a bit differently. Part of the point is that
> > CAP_TRACING should allow a user or program to trace without being able
> > to corrupt the system. CAP_BPF as you=E2=80=99ve proposed it *can* like=
ly
> > crash the system.
>
> Really? I'm still waiting for your example where bpf+kprobe crashes the s=
ystem...
>

That's not what I meant.  bpf+kprobe causing a crash is a bug.  I'm
referring to a totally different issue.  On my laptop:

$ sudo bpftool map
48: hash  name foobar  flags 0x0
    key 8B  value 8B  max_entries 64  memlock 8192B
181: lpm_trie  flags 0x1
    key 8B  value 8B  max_entries 1  memlock 4096B
182: lpm_trie  flags 0x1
    key 20B  value 8B  max_entries 1  memlock 4096B
183: lpm_trie  flags 0x1
    key 8B  value 8B  max_entries 1  memlock 4096B
184: lpm_trie  flags 0x1
    key 20B  value 8B  max_entries 1  memlock 4096B
185: lpm_trie  flags 0x1
    key 8B  value 8B  max_entries 1  memlock 4096B
186: lpm_trie  flags 0x1
    key 20B  value 8B  max_entries 1  memlock 4096B
187: lpm_trie  flags 0x1
    key 8B  value 8B  max_entries 1  memlock 4096B
188: lpm_trie  flags 0x1
    key 20B  value 8B  max_entries 1  memlock 4096B

$ sudo bpftool map dump id 186
key:
00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
00 00 00 00
value:
02 00 00 00 00 00 00 00
Found 1 element

$ sudo bpftool map delete id 186 key hex 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00
[this worked]

I don't know what my laptop was doing with map id 186 in particular,
but, whatever it was, I definitely broke it.  If a BPF firewall is in
use on something important enough, this could easily remove
connectivity from part or all of the system.  Right now, this needs
CAP_SYS_ADMIN.  With your patch, CAP_BPF is sufficient to do this, but
you *also* need CAP_BPF to trace the system using BPF.  Tracing with
BPF is 'safe' in the absence of bugs.  Modifying other peoples' maps
is not.

One possible answer to this would be to limit CAP_BPF to the subset of
BPF that is totaly safe in the absence of bugs (e.g. loading most
program types if they don't have dangerous BPF_CALL instructions but
not *_BY_ID).  Another answer would be to say that CAP_BPF will not be
needed by future unprivileged bpf mechanisms, and that CAP_TRACING
plus unprivileged bpf will be enough to do most or all interesting BPF
tracing operations.

If the answer is the latter, then maybe it would make sense to try to
implement some of the unprivileged bpf stuff and then to see whether
CAP_BPF is still needed.
