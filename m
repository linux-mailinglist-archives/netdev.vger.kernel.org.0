Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CB48E04F
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 00:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfHNWFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 18:05:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32898 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfHNWFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 18:05:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so200975pfq.0;
        Wed, 14 Aug 2019 15:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=akGGQ0T5s15xdYfV8Yi0U9bWHmBXQ1uj+JTu67HUzEs=;
        b=GDDJVCA307fH25acwfSdT5jUUfgk+stFEQ6Yz0NWq/9TtAuha61v6KY3RcV9zLp1pI
         twghte/CD7pPEABWggNnTA6jCAP5gHOLBA8Uu8vjvi1j0BkBDSkUacytr70EbS1aE3ZC
         tlbcUXvBOQKW/PH+jfqsZmmtasbgmvfD7DHb9E12HJTLMqohP518Tv/UXLEE0C503a29
         1j4bPdYgGoFXvXAJdIs7EFGu7pkK1R2+nXE256gPftPV82pKQzqUR1Q+RxP6AqCyT2x0
         93FU595RIA+j53da2O/jl6EE17K5XuRzRAGYdQHbpiCQP06LuO5jzTMME3PswZI2P1rN
         4Alw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=akGGQ0T5s15xdYfV8Yi0U9bWHmBXQ1uj+JTu67HUzEs=;
        b=qNtQ/NhHFjBVud7CMXBoTdJx55zT8ThHg7hIPISzsITyTKsvako6y2x9rcEaZmg7CF
         z5OZ8EU8ijQ0Zd6o5V1EQTdXDd27DvC/HHZHHNaSiNwxcAZxphx1QCk/t6PsKtzltbOs
         9KKuJ5IMfwmOKNgsroU4QT4gXo2cEQZo/OLSG9yNkWCnkNAW+jjZ6+Pb+zjPOeGkZiYL
         V7OowrbQqXLKPRofbg+IXJJn9JlCKQAlKjBCtMj26vOHv/AlOf0g3oBTiTUXq/iTVCgL
         zDJRSpA6KXmzsl4j34DKFCFCuJk5oIitl/YPlR4t9D8GEYo2NPO1TIV630UvWRkaWMJS
         8cKw==
X-Gm-Message-State: APjAAAUpWKie9wEVs0iz5LuPdA2j3G34C6rPzz/T0l4a5a6zlYd8pP4X
        oyZBWxk7zIWoY3xzTc0fmH4=
X-Google-Smtp-Source: APXvYqzbUrMXQzjnhLxDu+G49xTwQ95XyI+0sXhsDrQiMvY00hrNmHq67WfHNy6je1K1NlY3tb8VXA==
X-Received: by 2002:a65:5c02:: with SMTP id u2mr1053362pgr.367.1565820350217;
        Wed, 14 Aug 2019 15:05:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::d35d])
        by smtp.gmail.com with ESMTPSA id g11sm970137pfk.187.2019.08.14.15.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 15:05:49 -0700 (PDT)
Date:   Wed, 14 Aug 2019 15:05:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Daniel Colascione <dancol@google.com>,
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
Message-ID: <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
References: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 10:51:23AM -0700, Andy Lutomirski wrote:
> 
> If eBPF is genuinely not usable by programs that are not fully trusted
> by the admin, then no kernel changes at all are needed.  Programs that
> want to reduce their own privileges can easily fork() a privileged
> subprocess or run a little helper to which they delegate BPF
> operations.  This is far more flexible than anything that will ever be
> in the kernel because it allows the helper to verify that the rest of
> the program is doing exactly what it's supposed to and restrict eBPF
> operations to exactly the subset that is needed.  So a container
> manager or network manager that drops some provilege could have a
> little bpf-helper that manages its BPF XDP, firewalling, etc
> configuration.  The two processes would talk over a socketpair.

there were three projects that tried to delegate bpf operations.
All of them failed.
bpf operational workflow is much more complex than you're imagining.
fork() also doesn't work for all cases.
I gave this example before: consider multiple systemd-like deamons
that need to do bpf operations that want to pass this 'bpf capability'
to other deamons written by other teams. Some of them will start
non-root, but still need to do bpf. They will be rpm installed
and live upgraded while running.
We considered to make systemd such centralized bpf delegation
authority too. It didn't work. bpf in kernel grows quickly.
libbpf part grows independently. llvm keeps evolving.
All of them are being changed while system overall has to stay
operational. Centralized approach breaks apart.

> The interesting cases you're talking about really *do* involved
> unprivileged or less privileged eBPF, though.  Let's see:
> 
> systemd --user: systemd --user *is not privileged at all*.  There's no
> issue of reducing privilege, since systemd --user doesn't have any
> privilege to begin with.  But systemd supports some eBPF features, and
> presumably it would like to support them in the systemd --user case.
> This is unprivileged eBPF.

Let's disambiguate the terminology.
This /dev/bpf patch set started as describing the feature as 'unprivileged bpf'.
I think that was a mistake.
Let's call systemd-like deamon usage of bpf 'less privileged bpf'.
This is not unprivileged.
'unprivileged bpf' is what sysctl kernel.unprivileged_bpf_disabled controls.

There is a huge difference between the two.
I'm against extending 'unprivileged bpf' even a bit more than what it is
today for many reasons mentioned earlier.
The /dev/bpf is about 'less privileged'.
Less privileged than root. We need to split part of full root capability
into bpf capability. So that most of the root can be dropped.
This is very similar to what cap_net_admin does.
cap_net_amdin can bring down eth0 which is just as bad as crashing the box.
cap_net_admin is very much privileged. Just 'less privileged' than root.
Same thing for cap_bpf.

May be we should do both cap_bpf and /dev/bpf to make it clear that
this is the same thing. Two interfaces to achieve the same result.

> Seccomp.  Seccomp already uses cBPF, which is a form of BPF although
> it doesn't involve the bpf() syscall.  There are some seccomp
> proposals in the works that will want some stuff from eBPF.  In

I'm afraid these proposals won't go anywhere.

> So it's a bit of a chicken-and-egg situation.  There aren't major
> unprivileged eBPF users because the kernel support isn't there.

As I said before there are zero known use cases of 'unprivileged bpf'.

If I understand you correctly you're refusing to accept that
'less privileged bpf' is a valid use case while pushing for extending
scope of 'unprivileged'.
Extending the scope is an orthogonal discussion. Currently I'm
opposed to that. Whereas 'less privileged' is what people require.

> It will remain extremely awkward for containers and
> especially nested containers to use eBPF.

I'm afraid we have to agree to disagree here and move on.

