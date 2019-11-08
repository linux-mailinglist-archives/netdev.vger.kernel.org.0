Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B26F3C98
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfKHAJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:09:48 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45920 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfKHAJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:09:48 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so3497812pfn.12;
        Thu, 07 Nov 2019 16:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zCR8oUQK5kp581mP/9rQKPpZgXuEy24IW0l4icrKZ4g=;
        b=Mlv7i7E9HgBvRVYHjrP+5+XFDpAteTyNzjobGa4ve2Q7hcMknaMXFi8TH09TA4nr/7
         rgDt+Xpz8v4mcXQuPPiWoH2wr/POrplf/IHIr9CyY6dlqSnpx0vE2jnsP2BtFkL/uXfg
         gV+rbkBN6hsBmxtbMHFW0jnPBf0EMcJ3NNKWdUhiUXQqRUujMzbaV/806mNZqRwT7R4S
         UWysJkXW6zprkAxcaSpUhEQjhIxh3czPpLZS/xAHms7EJyaNlKpPHb8B0MLrJzWq4J5t
         lklA3wKe3DFaHwc8jjyw6RfGWOCgw8a/rO1JRJFdOc4DtXuMlYymTApLkNaWPQ+CSQNC
         TNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zCR8oUQK5kp581mP/9rQKPpZgXuEy24IW0l4icrKZ4g=;
        b=Jp/rkLWO25Cf9GlmbxI46IjP3R+xmP9/2SF7nJW52faVF2DaK4lgQ7TpwcNo8jWiIr
         kSqzM4nubjxXpsUDzwyF0wQ2vN+kSJHlWSY2uJNFOH/SCY9sINNlR/CQtX6e72MYmlea
         rzamo0z+oersRvMlPvuB+11TrGT2TH1znKEG7bPV6xE3ikkD74/X1q67WxeZVToDOjyL
         mk/Ufvis1IqU6SPsjDfHgqva+T9vXSuGWZ7SUI3v7q+6Kq+WYv5DvZ91K9VjCGouxRfA
         fMIKTLZLeu98CzhAip8UicXxZ7vD7K+7cyksjYZnNqvqx8lncIKofCs4+e4B9yeONzIh
         JTaA==
X-Gm-Message-State: APjAAAWw9qKoBZe5WosfCzQlMhGycFrEN56NTFmVLnbHKV4DEuvIYzS5
        Fm/EvPoykTzci6UMhyTnWoT3dqVX
X-Google-Smtp-Source: APXvYqzYhgn7kyjgBHfW6W2xhGF4SoRGQl7R9nKdJ7SLCx6xj4G0UK6r/AgJaC5FZgxbWivSAhcAfg==
X-Received: by 2002:a63:5605:: with SMTP id k5mr8231883pgb.14.1573171785665;
        Thu, 07 Nov 2019 16:09:45 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:d046])
        by smtp.gmail.com with ESMTPSA id 6sm3676514pfz.156.2019.11.07.16.09.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 16:09:44 -0800 (PST)
Date:   Thu, 7 Nov 2019 16:09:43 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Message-ID: <20191108000941.r4umt2624o3j45p7@ast-mbp.dhcp.thefacebook.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
 <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
 <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com>
 <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
 <22015BB9-7A84-4F5E-A8A5-D10CB9DA3AEE@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22015BB9-7A84-4F5E-A8A5-D10CB9DA3AEE@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 11:16:20PM +0000, Song Liu wrote:
> 
> 
> > On Nov 7, 2019, at 3:09 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Thu, Nov 07, 2019 at 11:07:21PM +0000, Song Liu wrote:
> >> 
> >> 
> >>> 
> >>> 
> >>>>> +
> >>>>> +static int bpf_trampoline_update(struct bpf_prog *prog)
> >>>> 
> >>>> Seems argument "prog" is not used at all? 
> >>> 
> >>> like one below ? ;)
> >> e... I was really dumb... sorry..
> >> 
> >> Maybe we should just pass the tr in? 
> > 
> > that would be imbalanced.
> 
> Hmm.. what do you mean by imbalanced?

I take it back. Yeah. It can be tr.

> 
> > 
> >>> 
> >>>>> +{
> >>>>> +	struct bpf_trampoline *tr = prog->aux->trampoline;
> >>>>> +	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
> >>>>> +	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
> >>>>> +	if (err)
> >>>>> +		goto out;
> >>>>> +	tr->selector++;
> >>>> 
> >>>> Shall we do selector-- for unlink?
> >>> 
> >>> It's a bit flip. I think it would be more confusing with --
> >> 
> >> Right.. Maybe should use int instead of u64 for selector? 
> > 
> > No, since int can overflow.
> 
> I guess it is OK to overflow, no?

overflow is not ok, since transition 0->1 should use nop->call patching
whereas 1->2, 2->3 should use call->call.

In my initial implementation (one I didn't share with anyone) I had
trampoline_mutex taken inside bpf_trampoline_update(). And multiple link()
operation were allowed. The idea was to attach multiple progs and update
trampoline once. But then I realized that I cannot do that since 'unlink +
update' where only 'update' is taking lock will not guarantee success. Since
other 'link' operations can race and 'update' can potentially fail in
arch_prepare_bpf_trampoline() due to new things that 'link' brought in. In that
version (since there several fentry/fexit progs can come in at once) I used
separate 'selector' ticker to pick the side of the page. Once I realized the
issue (to guarantee that unlink+update == always success) I moved mutex all the
way to unlink and link and left 'selector' as-is. Just now I realized that
'selector' can be removed.  fentry_cnt + fexit_cnt can be used instead. This
sum of counters will change 1 bit at a time. Am I right?

