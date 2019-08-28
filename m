Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBE8A0E44
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfH1Xif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:38:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45804 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfH1Xif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:38:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so522126pgp.12;
        Wed, 28 Aug 2019 16:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=fQBcZOpUJiUHS2we/DrlhO+EYWoRvMOhrARVg7f4x9o=;
        b=b5U1ivpNcAMKWLVJl1vmhIHUu1NPEDy3tBIOu/XpH1RZfhcZCoYqRhhP2gck9t81cx
         SsZ3mOdsnbDW52nMhXv/NzSaaxBCRcwEEF2dVlORUSxdmGX9xwQGIR/hqUED8x8Ojc+W
         Ptbj6qaUvav0ebEX1opg1lBIgcIKDRjMHUZ9Knu+QM/a+O4SPDO+L5Usvaxo1uL0UzTV
         kUSCiIzFZiTPw/bGmHVvl/dKD6GWMYOYRjmcUmP/T2PcTkiBUiJc2C/Hqql5r8n4CWbx
         miEJ5OoXCuWyX/o26dIDSX9ECf5eXcxZq0ZzsMXLZE6vRAurhd+28067sR+4P/IvlfSu
         X5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fQBcZOpUJiUHS2we/DrlhO+EYWoRvMOhrARVg7f4x9o=;
        b=tKMP6PMYXkgaf+tfucy2IfWyEiVHJBNjSwoNnKtCxyYbWiurXJm5PHgHwDBoQ1Vb82
         VreC5eB9FzGr01FMBMwNtpuwLj62Y0aBzvOusJ9qzGeEKOv7FBSqyN8fiTGQhHzK/FjK
         sk4KBEoPvs5Ja/fxqWJxQ+XRmPFZPsY77vVO8sfUynaR8kwiu88P7R67iTfgG4r3sd6v
         qpdllg+MxtiVd1VJymW7dq9VvXmEU1dv/6P948Hm267gOqEoi+LDU32LhlajMyNeLHGP
         0zy964foqGNe9I4nT0RRhxliQU0mpNyfaCqthmnPDSo0e9AyCLqYgUfwvWuYWNW/Oy+V
         SsJw==
X-Gm-Message-State: APjAAAUvz4lFlgnwSnnv1SFgh1aIfSd/vFUgfdT2Fv8fNQ9UjkgnSBW/
        f0gRpryEmPuQnLkVymPqgwI=
X-Google-Smtp-Source: APXvYqzUFAZB5tZFhl5oiGI2xmpnGhUNujlyQhqy9Q3FE47Rx6N24d9tc+mAfcd6POZ+GfBCOIYsXQ==
X-Received: by 2002:a63:6904:: with SMTP id e4mr1581105pgc.321.1567035513785;
        Wed, 28 Aug 2019 16:38:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::5983])
        by smtp.gmail.com with ESMTPSA id k8sm255572pgm.14.2019.08.28.16.38.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 16:38:32 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:38:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190828233828.p7xddyw3fjzfinm6@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com>
 <20190828044903.nv3hvinkkolnnxtv@ast-mbp.dhcp.thefacebook.com>
 <CALCETrX-bn2SpVzTkPz+A=z_oWDs7PNeouzK7wRWMzyaBd4+7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrX-bn2SpVzTkPz+A=z_oWDs7PNeouzK7wRWMzyaBd4+7g@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 11:20:19PM -0700, Andy Lutomirski wrote:
> On Tue, Aug 27, 2019 at 9:49 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 27, 2019 at 07:00:40PM -0700, Andy Lutomirski wrote:
> > >
> > > Let me put this a bit differently. Part of the point is that
> > > CAP_TRACING should allow a user or program to trace without being able
> > > to corrupt the system. CAP_BPF as you’ve proposed it *can* likely
> > > crash the system.
> >
> > Really? I'm still waiting for your example where bpf+kprobe crashes the system...
> >
> 
> That's not what I meant.  bpf+kprobe causing a crash is a bug.  I'm
> referring to a totally different issue.  On my laptop:
> 
> $ sudo bpftool map
> 48: hash  name foobar  flags 0x0
>     key 8B  value 8B  max_entries 64  memlock 8192B
> 181: lpm_trie  flags 0x1
>     key 8B  value 8B  max_entries 1  memlock 4096B
> 182: lpm_trie  flags 0x1
>     key 20B  value 8B  max_entries 1  memlock 4096B
> 183: lpm_trie  flags 0x1
>     key 8B  value 8B  max_entries 1  memlock 4096B
> 184: lpm_trie  flags 0x1
>     key 20B  value 8B  max_entries 1  memlock 4096B
> 185: lpm_trie  flags 0x1
>     key 8B  value 8B  max_entries 1  memlock 4096B
> 186: lpm_trie  flags 0x1
>     key 20B  value 8B  max_entries 1  memlock 4096B
> 187: lpm_trie  flags 0x1
>     key 8B  value 8B  max_entries 1  memlock 4096B
> 188: lpm_trie  flags 0x1
>     key 20B  value 8B  max_entries 1  memlock 4096B
> 
> $ sudo bpftool map dump id 186
> key:
> 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> 00 00 00 00
> value:
> 02 00 00 00 00 00 00 00
> Found 1 element
> 
> $ sudo bpftool map delete id 186 key hex 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00
> [this worked]
> 
> I don't know what my laptop was doing with map id 186 in particular,
> but, whatever it was, I definitely broke it.  If a BPF firewall is in
> use on something important enough, this could easily remove
> connectivity from part or all of the system.  Right now, this needs
> CAP_SYS_ADMIN.  With your patch, CAP_BPF is sufficient to do this, but
> you *also* need CAP_BPF to trace the system using BPF.  Tracing with
> BPF is 'safe' in the absence of bugs.  Modifying other peoples' maps
> is not.

That lpm_trie is likely systemd implementing IP sandboxing.
Not sure whether it's white or black list.
Deleting an IP address from that map will either allow or disallow
network traffic.
Out of band operation on bpf map broke some bpf program. Sure.
But calling it 'breaking the system' is quite a stretch.
Calling it 'crashing the system' is plain wrong.
Yet you're generalizing this bpf map read/write as
"CAP_BPF as you’ve proposed it *can* likely crash the system."
This is what I have a problem with.

Anyway, changing gears...
Yes. I did propose to make a task with CAP_BPF to be able to
manipulate arbitrary maps in the system.
You could have said that if CAP_BPF is given to 'bpftool'
then any user will be able to mess with other maps because
bpftool is likely chmod-ed 755.
Absolutely correct!
It's not a fault of the CAP_BPF scope.
Just don't give that cap to bpftool or do different acl/chmod.

> If the answer is the latter, then maybe it would make sense to try to
> implement some of the unprivileged bpf stuff and then to see whether
> CAP_BPF is still needed.

<broken_record_mode=on> Nack to extensions to unprivileged bpf.

