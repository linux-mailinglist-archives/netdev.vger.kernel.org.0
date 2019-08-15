Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9625B8E1DB
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfHOAgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 20:36:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33297 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfHOAgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 20:36:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so485575pgn.0;
        Wed, 14 Aug 2019 17:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Ox1a+VYIewcAFQ4OELZh4Q4lPxZBMpjjQSeyyCBfAt4=;
        b=A1xFdzx3J2IXK/YfLZxOnTYElXzObtSe6u3KhDmJDc8TgZ+VnTSTh61oqnbyUPy+Cy
         lxSU8sPqGQaTsvXMI7wtAtOB0Sn7PAYrUgHtwso47YnJSvKoYnyTdq2J7aRGfMDrhUwt
         ImQ/5f0aeYBF4P9VrX74i1K2sPgmIeb/CqsgC8xCwJymBWzn5SaBCFA5Xqoow6Q9Px/z
         7VG1XvyMm7L+ucKqVH8FYqLJg8hrjQOj/q0H8rmCSewXpul7vGKTXAEljSgTiEBnQtfW
         Jo3QDU/1IYquFf5cC+pqFebJOJauI0Ht+0cbnfwUOrUqas8HYYfE2/Jqz1Ey34hVxPz7
         gB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Ox1a+VYIewcAFQ4OELZh4Q4lPxZBMpjjQSeyyCBfAt4=;
        b=koMb44YADjpgWsgj8LCkZ271dQv4xFUZBYWoA6nu98MKPxnUUMFg8Vl2Zv4kW9hiMj
         7p1oLu9epoy6n9b5HJTberjrBuGSWmS5oWz9IbIELruLI9wWrdo8BdVEqfUMqZ/Vkwn7
         HMUhazGKAXlKS1XSoDuwzOls73yokMNbqOi+5X7bkflaOXwyn/Q9tWJXZ33eqcLu7VDX
         LLmq5dbqLd/QsNEsHh7Gjx7tNeL1yHcS+50KlmbV+5Pao9SiTOlV0qAkJwssDZ0U+Ek3
         7tE7bYPy3XUa9rt+9M9lYiIjiaZYtlEuZvSTcnqtyWzjD7aihuiktR6Nfh3wXa3DNL8m
         nqAA==
X-Gm-Message-State: APjAAAWOEOJeoIOGfO5eqLmvxj7QUUdVdfSADrpGcR2TtbmUsvI62Vxx
        kZF/Zpq5VrL5MloYipA8vZkxTEb/
X-Google-Smtp-Source: APXvYqzyqVrWOuZQ7tt8Apmsd9fEcv9DPHmv1boZGITqn9Jjg9JKSj2CKRgIubY7ay+Lz4swzKpT4A==
X-Received: by 2002:a62:8281:: with SMTP id w123mr2742961pfd.36.1565829367438;
        Wed, 14 Aug 2019 17:36:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::d35d])
        by smtp.gmail.com with ESMTPSA id g19sm1117977pfh.27.2019.08.14.17.36.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 17:36:06 -0700 (PDT)
Date:   Wed, 14 Aug 2019 17:36:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@amacapital.net>
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
Message-ID: <20190815003602.yp3udcr5mtgw6qrv@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <AD211133-EA60-4B91-AB1B-201713F50AB2@amacapital.net>
 <20190814233335.37t4zfsiswrpd4d6@ast-mbp.dhcp.thefacebook.com>
 <317422C3-ACE3-42A7-A287-7B8FEE12E33A@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <317422C3-ACE3-42A7-A287-7B8FEE12E33A@amacapital.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 04:59:18PM -0700, Andy Lutomirski wrote:
> 
> 
> > On Aug 14, 2019, at 4:33 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> >> On Wed, Aug 14, 2019 at 03:30:51PM -0700, Andy Lutomirski wrote:
> >> 
> >> 
> >>>> On Aug 14, 2019, at 3:05 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >>>> 
> >>>> On Wed, Aug 14, 2019 at 10:51:23AM -0700, Andy Lutomirski wrote:
> >>>> 
> >>>> If eBPF is genuinely not usable by programs that are not fully trusted
> >>>> by the admin, then no kernel changes at all are needed.  Programs that
> >>>> want to reduce their own privileges can easily fork() a privileged
> >>>> subprocess or run a little helper to which they delegate BPF
> >>>> operations.  This is far more flexible than anything that will ever be
> >>>> in the kernel because it allows the helper to verify that the rest of
> >>>> the program is doing exactly what it's supposed to and restrict eBPF
> >>>> operations to exactly the subset that is needed.  So a container
> >>>> manager or network manager that drops some provilege could have a
> >>>> little bpf-helper that manages its BPF XDP, firewalling, etc
> >>>> configuration.  The two processes would talk over a socketpair.
> >>> 
> >>> there were three projects that tried to delegate bpf operations.
> >>> All of them failed.
> >>> bpf operational workflow is much more complex than you're imagining.
> >>> fork() also doesn't work for all cases.
> >>> I gave this example before: consider multiple systemd-like deamons
> >>> that need to do bpf operations that want to pass this 'bpf capability'
> >>> to other deamons written by other teams. Some of them will start
> >>> non-root, but still need to do bpf. They will be rpm installed
> >>> and live upgraded while running.
> >>> We considered to make systemd such centralized bpf delegation
> >>> authority too. It didn't work. bpf in kernel grows quickly.
> >>> libbpf part grows independently. llvm keeps evolving.
> >>> All of them are being changed while system overall has to stay
> >>> operational. Centralized approach breaks apart.
> >>> 
> >>>> The interesting cases you're talking about really *do* involved
> >>>> unprivileged or less privileged eBPF, though.  Let's see:
> >>>> 
> >>>> systemd --user: systemd --user *is not privileged at all*.  There's no
> >>>> issue of reducing privilege, since systemd --user doesn't have any
> >>>> privilege to begin with.  But systemd supports some eBPF features, and
> >>>> presumably it would like to support them in the systemd --user case.
> >>>> This is unprivileged eBPF.
> >>> 
> >>> Let's disambiguate the terminology.
> >>> This /dev/bpf patch set started as describing the feature as 'unprivileged bpf'.
> >>> I think that was a mistake.
> >>> Let's call systemd-like deamon usage of bpf 'less privileged bpf'.
> >>> This is not unprivileged.
> >>> 'unprivileged bpf' is what sysctl kernel.unprivileged_bpf_disabled controls.
> >>> 
> >>> There is a huge difference between the two.
> >>> I'm against extending 'unprivileged bpf' even a bit more than what it is
> >>> today for many reasons mentioned earlier.
> >>> The /dev/bpf is about 'less privileged'.
> >>> Less privileged than root. We need to split part of full root capability
> >>> into bpf capability. So that most of the root can be dropped.
> >>> This is very similar to what cap_net_admin does.
> >>> cap_net_amdin can bring down eth0 which is just as bad as crashing the box.
> >>> cap_net_admin is very much privileged. Just 'less privileged' than root.
> >>> Same thing for cap_bpf.
> >> 
> >> The new pseudo-capability in this patch set is absurdly broad. I’ve proposed some finer-grained divisions in this thread. Do you have comments on them?
> > 
> > Initially I agreed that it's probably too broad, but then realized
> > that they're perfect as-is. There is no need to partition further.
> > 
> >>> May be we should do both cap_bpf and /dev/bpf to make it clear that
> >>> this is the same thing. Two interfaces to achieve the same result.
> >> 
> >> What for?  If there’s a CAP_BPF, then why do you want /dev/bpf? Especially if you define it to do the same thing.
> > 
> > Indeed, ambient capabilities should work for all cases.
> > 
> >> No, I’m not.  I have no objection at all if you try to come up with a clear definition of what the capability checks do and what it means to grant a new permission to a task.  Changing *all* of the capable checks is needlessly broad.
> > 
> > There are not that many bits left. I prefer to consume single CAP_BPF bit.
> > All capable(CAP_SYS_ADMIN) checks in kernel/bpf/ will become CAP_BPF.
> > This is no-brainer.
> > 
> > The only question is whether few cases of CAP_NET_ADMIN in kernel/bpf/
> > should be extended to CAP_BPF or not.
> > imo devmap and xskmap can stay CAP_NET_ADMIN,
> > but cgroup bpf attach/detach should be either CAP_NET_ADMIN or CAP_BPF.
> > Initially cgroup-bpf hooks were limited to networking.
> > It's no longer the case. Requiring NET_ADMIN there make little sense now.
> > 
> 
> Cgroup bpf attach/detach, with the current API, gives very strong control over the whole system, and it will just get stronger as bpf gains features. Making it CAP_BPF means that you will never have the ability to make CAP_BPF safe to give to anything other than an extremely highly trusted process.  Unsafe pointers are similar. 

'never to less trusted process' ? why do you think so?
I don't see a problem adding /dev/bpf/foo in the future and make things
more granular. There is no such use case today. Hence I don't want to
spend time and design something without clear use case in mind.

> Do new programs really need the by_id calls? 

yes. Lorenz gave an example earlier. map-in-map returns map_id.
To operate on that map by_id is needed.

