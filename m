Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946F38F22E
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfHOR3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 13:29:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37772 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfHOR3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:29:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1so989421pgp.4;
        Thu, 15 Aug 2019 10:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FKRKDbU9S4M5oykmChG6j3tcdYNbDh8DcchmeEeC/cM=;
        b=gFc99nv7p3ZVWxUmr/LNI6Qe2AMMWiYtv3qR70vS6g9di4iWwJE70RltZUXZXx4EY/
         YK0FTCBv4ybf6DyPHtg2wkFOb8D/OecQxRRr6c/JdJWrZXMh3gOKb/fUq4vhVtWmic06
         s4/WXyczXn1rcG2w5O+0NJqf/IhuKo9ILKiLt4/gGcuyYGQz+H2iuCUuaDxvRXlu9HFe
         0/Nnp1KjEgs3Tfim6WPCh9PxjzN0oxdZWShrgigBs3HTPGtJaLzgco+XegfIz6V195e7
         2lNFPG7RStnIZiwDYPlLsWh1FCfWommugB0DbnWYNarIjsLCAJolZZ2FfXHUvSXS+kZD
         08nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FKRKDbU9S4M5oykmChG6j3tcdYNbDh8DcchmeEeC/cM=;
        b=Q0Z1t+OOuL1PdQZ8SOD/zlzdv/f2a2OH9fvIbbVe6+vHTpgkuzjXeN3UybS2HZw753
         SJUuRs42o2NWZtjwYmaTn0etSqwhU8aVoy16NEUjR86LtFHuW+asGbdLozyJEHIz4lpR
         lZHad3ADTNo+wM2U1LBijCBfs5HB4mWuD3wuUoyeC06JdBPH0KJKs+amC76FdbjfNhgq
         HpPlTlYaOKetyF56bq4mIUjo0+SGkyyWZuF15bga01qc7gfFfFxkZT5UzHmI2GyGcPU+
         quQ9Mo8VOeSWTemcRoOLKvONbIbRWKi01wnnTUHaRhUMlqptwCrkNpHAzyAEhk+7CYx9
         6qwQ==
X-Gm-Message-State: APjAAAULOdwxE8Z4rfX/E5iaNQ7Kltn//KlwSpOzXxZgobNaazDrGZ+7
        BarYdDtNhZ5+pRfrHjqgK14=
X-Google-Smtp-Source: APXvYqwu7xZzO2Wk+NqvTdSS/nAjz6TALfbZn2ytrJWT5JTYy0nYbx3JzfquRelt3ZoUGhJ+qHAVCQ==
X-Received: by 2002:a17:90a:b30e:: with SMTP id d14mr3104375pjr.26.1565890140860;
        Thu, 15 Aug 2019 10:29:00 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::e9c1])
        by smtp.gmail.com with ESMTPSA id g2sm4919678pfq.88.2019.08.15.10.28.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 10:28:59 -0700 (PDT)
Date:   Thu, 15 Aug 2019 10:28:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
References: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:24:54AM +0000, Jordan Glover wrote:
> On Wednesday, August 14, 2019 10:05 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > On Wed, Aug 14, 2019 at 10:51:23AM -0700, Andy Lutomirski wrote:
> >
> > > If eBPF is genuinely not usable by programs that are not fully trusted
> > > by the admin, then no kernel changes at all are needed. Programs that
> > > want to reduce their own privileges can easily fork() a privileged
> > > subprocess or run a little helper to which they delegate BPF
> > > operations. This is far more flexible than anything that will ever be
> > > in the kernel because it allows the helper to verify that the rest of
> > > the program is doing exactly what it's supposed to and restrict eBPF
> > > operations to exactly the subset that is needed. So a container
> > > manager or network manager that drops some provilege could have a
> > > little bpf-helper that manages its BPF XDP, firewalling, etc
> > > configuration. The two processes would talk over a socketpair.
> >
> > there were three projects that tried to delegate bpf operations.
> > All of them failed.
> > bpf operational workflow is much more complex than you're imagining.
> > fork() also doesn't work for all cases.
> > I gave this example before: consider multiple systemd-like deamons
> > that need to do bpf operations that want to pass this 'bpf capability'
> > to other deamons written by other teams. Some of them will start
> > non-root, but still need to do bpf. They will be rpm installed
> > and live upgraded while running.
> > We considered to make systemd such centralized bpf delegation
> > authority too. It didn't work. bpf in kernel grows quickly.
> > libbpf part grows independently. llvm keeps evolving.
> > All of them are being changed while system overall has to stay
> > operational. Centralized approach breaks apart.
> >
> > > The interesting cases you're talking about really do involved
> > > unprivileged or less privileged eBPF, though. Let's see:
> > > systemd --user: systemd --user is not privileged at all. There's no
> > > issue of reducing privilege, since systemd --user doesn't have any
> > > privilege to begin with. But systemd supports some eBPF features, and
> > > presumably it would like to support them in the systemd --user case.
> > > This is unprivileged eBPF.
> >
> > Let's disambiguate the terminology.
> > This /dev/bpf patch set started as describing the feature as 'unprivileged bpf'.
> > I think that was a mistake.
> > Let's call systemd-like deamon usage of bpf 'less privileged bpf'.
> > This is not unprivileged.
> > 'unprivileged bpf' is what sysctl kernel.unprivileged_bpf_disabled controls.
> >
> > There is a huge difference between the two.
> > I'm against extending 'unprivileged bpf' even a bit more than what it is
> > today for many reasons mentioned earlier.
> > The /dev/bpf is about 'less privileged'.
> > Less privileged than root. We need to split part of full root capability
> > into bpf capability. So that most of the root can be dropped.
> > This is very similar to what cap_net_admin does.
> > cap_net_amdin can bring down eth0 which is just as bad as crashing the box.
> > cap_net_admin is very much privileged. Just 'less privileged' than root.
> > Same thing for cap_bpf.
> >
> > May be we should do both cap_bpf and /dev/bpf to make it clear that
> > this is the same thing. Two interfaces to achieve the same result.
> >
> 
> systemd --user processes aren't "less privileged". The are COMPLETELY unprivileged.
> Granting them cap_bpf is the same as granting it to every other unprivileged user
> process. Also unprivileged user process can start systemd --user process with any
> command they like.

systemd itself is trusted. It's the same binary whether it runs as pid=1
or as pid=123. One of the use cases is to make IPAddressDeny= work with --user.
Subset of that feature already works with AmbientCapabilities=CAP_NET_ADMIN.
CAP_BPF is a natural step in the same direction.

