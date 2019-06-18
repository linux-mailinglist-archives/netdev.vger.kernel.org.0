Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075784AA60
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbfFRSxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:53:55 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38984 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730341AbfFRSxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:53:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so6085084pls.6
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jmVrM81H59ifNJSt4cq3fPpG2nhJ0Gp5lc98D4z5+wI=;
        b=XKPiUQXCiT/toiTDoI6uNqg828RGKNlxgSAE7i2nOkfwaAda34IJ7f/EW9fbsx3ui5
         9JkIILAJ1RFg3miyjqejz1aupLO9zs9QkEGBqzXwn1vJ0YxWlEqOfHmjc/3a3x8iuXyq
         idMqsNkt0uP/4nz9daNc0aIAoxIy2gowupunZOtSe8Ibymm5mi0eUyQZrSupYkVB5/Cr
         jmaDuFb1TJxIdEltt55i98o/bOg3uPH0l1pKP4I8bshA9dwQiiDD+xAx/SReNHXRMdYC
         vv3pbUBCEAxJioJm8vTU9tNDT+nzh2+y9u1HHlbWsXDMETlobGtvw0QR1J2i0KDgWO1f
         AIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jmVrM81H59ifNJSt4cq3fPpG2nhJ0Gp5lc98D4z5+wI=;
        b=t0R9CgQpOOBrBZAnjPePyO8gfjcDUmR77jZo4WJlfJCi5HBCXOnMDgEXx1z/oz8rKL
         WMOt6amfAbAEPiA604Du4dNQP5kRKQWqaYhZB1N6cBBN/yET9IoaOBxlnWYsQh1q4qI9
         EuX18X3XFNWapplyupxbuWUuaPHAtQWgLiQBcaY7CsJG+LH8zO7xOH3vqUW1h7mphIwS
         nIlOjKzDzuRb1IRbqHh1IuakoI42H6QhQUjD96EN3BGtpBi+l6mnFnx0/tJw+OC7klPe
         ZWxNCrnNK/lB9UmIkeT+84zFPu1l50oBnhQK8m9t9v6LAWe5eBsuILoHWJC+0zJ+oS6E
         DeOg==
X-Gm-Message-State: APjAAAWL3BFDUTBlFOSn2tL+ON+ZCBDqYN3yswyDg2wNC67BxLZ+uynD
        mKtMjB9lp2sWgYeXDpCEzDwTHA==
X-Google-Smtp-Source: APXvYqx2SySAp9rUR8HbQ9AupN7FOYXWA+7/W/Jw1j5yv6xQBFxxIxvoTVTVoDI44JgjR/Hg1Ep5JQ==
X-Received: by 2002:a17:902:aa8a:: with SMTP id d10mr78531487plr.159.1560884034108;
        Tue, 18 Jun 2019 11:53:54 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id e20sm15137247pfi.35.2019.06.18.11.53.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:53:53 -0700 (PDT)
Date:   Tue, 18 Jun 2019 11:53:52 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v6 1/9] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190618185352.GK9636@mini-arch>
References: <20190617180109.34950-1-sdf@google.com>
 <20190617180109.34950-2-sdf@google.com>
 <20190618163117.yuw44b24lo6prsrz@ast-mbp.dhcp.thefacebook.com>
 <20190618164913.GI9636@mini-arch>
 <20190618180944.GJ9636@mini-arch>
 <CAADnVQ+kymi+zJww+PfPd4WWhvNA67ynGVTd7oj6jiU+XFeguQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+kymi+zJww+PfPd4WWhvNA67ynGVTd7oj6jiU+XFeguQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/18, Alexei Starovoitov wrote:
> On Tue, Jun 18, 2019 at 11:09 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 06/18, Stanislav Fomichev wrote:
> > > On 06/18, Alexei Starovoitov wrote:
> > > > On Mon, Jun 17, 2019 at 11:01:01AM -0700, Stanislav Fomichev wrote:
> > > > > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > > > > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > > > >
> > > > > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > > > > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > > > > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > > > >
> > > > > The buffer memory is pre-allocated (because I don't think there is
> > > > > a precedent for working with __user memory from bpf). This might be
> > > > > slow to do for each {s,g}etsockopt call, that's why I've added
> > > > > __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> > > > > attached to a cgroup. Note, however, that there is a race between
> > > > > __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> > > > > program layout might have changed; this should not be a problem
> > > > > because in general there is a race between multiple calls to
> > > > > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > > > >
> > > > > The return code of the BPF program is handled as follows:
> > > > > * 0: EPERM
> > > > > * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> > > > > * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
> > > > >      prog exits
> > > > >
> > > > > Note that if 0 or 2 is returned from BPF program, no further BPF program
> > > > > in the cgroup hierarchy is executed. This is in contrast with any existing
> > > > > per-cgroup BPF attach_type.
> > > >
> > > > This is drastically different from all other cgroup-bpf progs.
> > > > I think all programs should be executed regardless of return code.
> > > > It seems to me that 1 vs 2 difference can be expressed via bpf program logic
> > > > instead of return code.
> > > >
> > > > How about we do what all other cgroup-bpf progs do:
> > > > "any no is no. all yes is yes"
> > > > Meaning any ret=0 - EPERM back to user.
> > > > If all are ret=1 - kernel handles get/set.
> > > >
> > > > I think the desire to differentiate 1 vs 2 came from ordering issue
> > > > on getsockopt.
> > > > How about for setsockopt all progs run first and then kernel.
> > > > For getsockopt kernel runs first and then all progs.
> > > > Then progs will have an ability to overwrite anything the kernel returns.
> > > Good idea, makes sense. For getsockopt we'd also need to pass the return
> > > value of the kernel getsockopt to let bpf programs override it, but seems
> > > doable. Let me play with it a bit; I'll send another version if nothing
> > > major comes up.
> > >
> > > Thanks for another round of review!
> > One clarification: we'd still probably need to have 3 return codes for
> > setsockopt:
> > * any 0 - EPERM
> > * all 1 - continue with the kernel path (i.e. apply this sockopt as is)
> > * any 2 - return after all BPF hooks are executed (bypass kernel)
> >           (any 0 trumps any 2 -> EPERM)
> >
> > The context is readonly for setsockopt, so it shouldn't be an issue.
> > Let me know if you have better idea how to handle that.
> 
> I think we don't really need 2.
> The progs can reduce optlen to zero (or optname to BPF_EMPTY_SOCKOPT)
> and do ret=1.
> Then the kernel can see that nothing to be be done and return 0 to user space.
> Since parent prog in the chain will be able to see that child prog
> set optlen to zero, it will be able to overwrite if necessary.
Ack, optlen=0 sounds good. In that case parent prog can poke into optval
because optval_end still points to the valid end of the data (and, as you
said, can override optlen back if necessary). Thanks!

> getsockopt wil be clean as well.
> all 1s return whatever was produced by progs to user space.
> and progs will be able to see what kernel wanted to return because
> the kernel's getsockopt logic ran first.
> ret=2 doesn't have any meaning for getsockopt, so nice to keep
> setsockopt symmetrical and don't do it there either.
Agreed.
