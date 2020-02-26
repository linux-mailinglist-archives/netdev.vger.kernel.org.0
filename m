Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73616F6F2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 06:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgBZFPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 00:15:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37030 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgBZFPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 00:15:40 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so1356308wrx.4
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 21:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2mmwcPt7FYwEo0xY8XBsaqPBRihA0DEsv6KzigsLQ58=;
        b=GFtc1XjesUgCXUHiWoX/bNXIOX68YtbiUIv3KeypQbKO5nzN9EtNHzPQKWx0AS5kQJ
         QisbhnZZnyRyZjREV911pnrbH5+8FGTnjfq8Q5XVQa2GK8NZ2DcgdwFhmh+qZM3Cwlwl
         Q7kmyK8YZbxd1bbdUd4Kx+IkQ7qvTY57UKgSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2mmwcPt7FYwEo0xY8XBsaqPBRihA0DEsv6KzigsLQ58=;
        b=HVJ9nOjolFoiOCwbw3N7VhfG6aSS6t1qkiIcInXQAbWtgcOQVGq4deN2D9r1/qLcRy
         3UtyL72O3cOYBdGpbOIEjtf5wGqKP1q38WBg2jyxe658omQ2yeqn3NzZ/8l4AQn1Weh+
         0x1EJA94xCE04LFhLXwu9D6dDdoAbt+mZAvbpFh/pKyFtS8Yn8emD3WlU/0sTFStGJCy
         hSh7GPApaMYaNvt2zdxxmk9Iuh88HlQDF1dP0uOq1osmjm9HwUSo1+ptXHPjMlnLkTFV
         t1GGvKEdYaecZf0BIz0DKNvoyxIAw13XgFQGwuptWAUyxTYiarNu/b4t2KGl19IJUZdA
         l2gA==
X-Gm-Message-State: APjAAAXoDYfdOLnESQhiJfOVVzTnMOF5LZx8np+WU+3IwJkvNqaLL83c
        hflnBM54/SM4gKmU0l3Nhk4RkQ==
X-Google-Smtp-Source: APXvYqz2IaEWwjMKpkbhNY7SJ8fg1XpAhmBgB4RAX5kpwm8067vORT93Ydflic8x7eX4NRlr6w4xtQ==
X-Received: by 2002:adf:fc85:: with SMTP id g5mr3094802wrr.52.1582694138040;
        Tue, 25 Feb 2020 21:15:38 -0800 (PST)
Received: from chromium.org (77-56-209-237.dclient.hispeed.ch. [77.56.209.237])
        by smtp.gmail.com with ESMTPSA id m22sm389298wmc.41.2020.02.25.21.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 21:15:37 -0800 (PST)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Wed, 26 Feb 2020 06:15:35 +0100
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
Message-ID: <20200226051535.GA17117@chromium.org>
References: <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook>
 <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
 <20200224171305.GA21886@chromium.org>
 <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
 <202002241136.C4F9F7DFF@keescook>
 <20200225054125.dttrc3fvllzu4mx5@ast-mbp>
 <4b56177f-8148-177b-e1e5-c98da86b3b01@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b56177f-8148-177b-e1e5-c98da86b3b01@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25-Feb 16:30, Casey Schaufler wrote:
> On 2/24/2020 9:41 PM, Alexei Starovoitov wrote:
> > On Mon, Feb 24, 2020 at 01:41:19PM -0800, Kees Cook wrote:
> >> But the LSM subsystem doesn't want special cases (Casey has worked very
> >> hard to generalize everything there for stacking). It is really hard to
> >> accept adding a new special case when there are still special cases yet
> >> to be worked out even in the LSM code itself[2].
> >> [2] Casey's work to generalize the LSM interfaces continues and it quite
> >> complex:
> >> https://lore.kernel.org/linux-security-module/20200214234203.7086-1-casey@schaufler-ca.com/
> > I think the key mistake we made is that we classified KRSI as LSM.
> > LSM stacking, lsmblobs that the above set is trying to do are not necessary for KRSI.
> > I don't see anything in LSM infra that KRSI can reuse.
> > The only thing BPF needs is a function to attach to.
> > It can be a nop function or any other.
> > security_*() functions are interesting from that angle only.
> > Hence I propose to reconsider what I was suggesting earlier.
> > No changes to secruity/ directory.
> > Attach to security_*() funcs via bpf trampoline.
> > The key observation vs what I was saying earlier is KRSI and LSM are wrong names.
> > I think "security" is also loaded word that should be avoided.
> 
> No argument there.
> 
> > I'm proposing to rename BPF_PROG_TYPE_LSM into BPF_PROG_TYPE_OVERRIDE_RETURN.
> >
> >> So, unless James is going to take this over Casey's objections, the path
> >> forward I see here is:
> >>
> >> - land a "slow" KRSI (i.e. one that hooks every hook with a stub).
> >> - optimize calling for all LSMs
> > I'm very much surprised how 'slow' KRSI is an option at all.
> > 'slow' KRSI means that CONFIG_SECURITY_KRSI=y adds indirect calls to nop
> > functions for every place in the kernel that calls security_*().
> > This is not an acceptable overhead. Even w/o retpoline
> > this is not something datacenter servers can use.
> 
> In the universe I live in data centers will disable hyper-threading,
> reducing performance substantially, in the face of hypothetical security
> exploits. That's a massively greater performance impact than the handful
> of instructions required to do indirect calls. Not to mention the impact

Indirect calls have worse performance implications than just a few
instructions and are especially not suitable for hotpaths.

There have been multiple efforts to reduce their usage e.g.:

  - https://lwn.net/Articles/774743/
  - https://lwn.net/Articles/773985/

> of the BPF programs that have been included. Have you ever looked at what

  BPF programs are JIT'ed and optimized to native code.

> happens to system performance when polkitd is enabled?

However, let's discuss all this separately when we follow-up with
performance improvements after submitting the initial patch-set.

> 
> 
> >
> > Another option is to do this:
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 64b19f050343..7887ce636fb1 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -240,7 +240,7 @@ static inline const char *kernel_load_data_id_str(enum kernel_load_data_id id)
> >         return kernel_load_data_str[id];
> >  }
> >
> > -#ifdef CONFIG_SECURITY
> > +#if defined(CONFIG_SECURITY) || defined(CONFIG_BPF_OVERRIDE_RETURN)
> >
> > Single line change to security.h and new file kernel/bpf/override_security.c
> > that will look like:
> > int security_binder_set_context_mgr(struct task_struct *mgr)
> > {
> >         return 0;
> > }
> >
> > int security_binder_transaction(struct task_struct *from,
> >                                 struct task_struct *to)
> > {
> >         return 0;
> > }
> > Essentially it will provide BPF side with a set of nop functions.
> > CONFIG_SECURITY is off. It may seem as a downside that it will force a choice
> > on kernel users. Either they build the kernel with CONFIG_SECURITY and their
> > choice of LSMs or build the kernel with CONFIG_BPF_OVERRIDE_RETURN and use
> > BPF_PROG_TYPE_OVERRIDE_RETURN programs to enforce any kind of policy. I think
> > it's a pro not a con.
> 
> Err, no. All distros use an LSM or two. Unless you can re-implement SELinux

The users mentioned here in this context are (I would assume) the more
performance sensitive users who would, potentially, disable
CONFIG_SECURITY because of the current performance characteristics.

We can also discuss this separately and only if we find that we need
it for the BPF_OVERRIDE_RET type attachment.

- KP

> in BPF (good luck with state transitions) you've built a warp drive without
> ever having mined dilithium crystals.
> 
> 
