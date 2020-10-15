Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D19928EC50
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgJOEdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOEda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:33:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FEFC061755;
        Wed, 14 Oct 2020 21:33:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n9so1065471pgf.9;
        Wed, 14 Oct 2020 21:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BoSX3rBWIH0BfpEjF76Dmbb/3sKDbh5PYS0JdSEYDAA=;
        b=W2vCDoxSf13zj8g9zZY1eIf+g4kb/0I6Rs4x2A6doe9Aw9+/dn1Fh5A90ARpCMc2r+
         VwNVOY7sRAsdtXRizSsUzHpnr703Df4rPXB9wpE3s30ytolY2/y0G2qD2AT7X1PaxbbW
         S2yakTx0cFnEVeHAaLnNNZSvHGHnz+/lDlLB0ejvbDtFsOY+3D00h/mG8D3RONbjLxJe
         HO3vGaEHQoWiOzjLUgv1ApaVPNdEcbGFvrpWAilhBKT1FYeteMOzuqMIJCmH+zp4L/Jh
         EzADXMoYrrXJIKImlLqq/mhoviaj4ug9+QjMifRLIncmpjhFrd5ArydKNnMyu5IOWOyG
         nYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BoSX3rBWIH0BfpEjF76Dmbb/3sKDbh5PYS0JdSEYDAA=;
        b=E1b4f5zLISztN5oV9oTH6bNbsSAuld9B8x0Xbmbp2cpfrHF1SN7JjGNnDoLgBSNmnD
         E2eDkOpqg2xIP0LVX7TlkbD9HtYYsqBxPpCopJCN4XJgj34mbzAZc183PswyEWek5FQW
         qIY8HwQoTdUUPaxBg3xrYXopvrdUCaNtpwpAkXbdAVy0A7BDocYtfR8DLYBI4UDHR1FK
         D5D9FhseqeY0HbnpDBsx1rA+haL7LemKOLP+oS2ZN+QG+qrcLOtIYjLvzmGM47IGNY4s
         5lM7GaQWq6Ac0zdTQLY8y2O+MFBF8ZSDjMxz30wM9AAKYnEERA5pO6T4v/YKYBU08vx4
         HX8Q==
X-Gm-Message-State: AOAM53355DH41liREA1DYeU6/fyYqOWb/eeA8f1isr1qWggzkBe5fK3J
        s6NijA68mCvX8fWMyW8pwZ4=
X-Google-Smtp-Source: ABdhPJyfUA7VeZdb0UrSGUs4ReOt9DflZquI1UGtleSJyhY3oG3RlPdoVwjivuTKkZgWo8IGVZxt7A==
X-Received: by 2002:a63:d40d:: with SMTP id a13mr1952033pgh.344.1602736409526;
        Wed, 14 Oct 2020 21:33:29 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f594])
        by smtp.gmail.com with ESMTPSA id kc21sm1264251pjb.36.2020.10.14.21.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:33:28 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:33:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
Message-ID: <20201015043327.stqhrupw2adhd5hl@ast-mbp.dhcp.thefacebook.com>
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
 <CAEf4BzaF2fDWoRg8h3dUKftvcastYqzEhGS2TG6MoV462fd_8Q@mail.gmail.com>
 <5f87ca47436f3_b7602088f@john-XPS-13-9370.notmuch>
 <20201015041952.n3crk6kvtbgev6rw@ast-mbp.dhcp.thefacebook.com>
 <5f87cfa5b1a77_b7602087e@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f87cfa5b1a77_b7602087e@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 09:27:17PM -0700, John Fastabend wrote:
> Alexei Starovoitov wrote:
> > On Wed, Oct 14, 2020 at 09:04:23PM -0700, John Fastabend wrote:
> > > Andrii Nakryiko wrote:
> > > > On Wed, Oct 14, 2020 at 10:59 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > >
> > > > > The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> > > > > true or false branch. In the case 'if (reg->id)' check was done on the other
> > > > > branch the counter part register would have reg->id == 0 when called into
> > > > > find_equal_scalars(). In such case the helper would incorrectly identify other
> > > > > registers with id == 0 as equivalent and propagate the state incorrectly.
> > > 
> > > One thought. It seems we should never have reg->id=0 in find_equal_scalars()
> > > would it be worthwhile to add an additional check here? Something like,
> > > 
> > >   if (known_reg->id == 0)
> > > 	return
> > >
> > > Or even a WARN_ON_ONCE() there? Not sold either way, but maybe worth thinking
> > > about.
> > 
> > That cannot happen anymore due to
> > if (dst_reg->id && !WARN_ON_ONCE(dst_reg->id != other_branch_regs[insn->dst_reg].id))
> > check in the caller.
> > I prefer not to repeat the same check twice. Also I really don't like defensive programming.
> > if (known_reg->id == 0)
> >        return;
> > is exactly that.
> > If we had that already, as Andrii argued in the original thread, we would have
> > never noticed this issue. <, >, <= ops would have worked, but == would be
> > sort-of working. It would mark one branch instead of both, and sometimes
> > neither of the branches. I'd rather have bugs like this one hurting and caught
> > quickly instead of warm feeling of being safe and sailing into unknown.
> 
> Agree. Although a WARN_ON_ONCE would have also been caught.

Right. Such WARN_ON_ONCE would definitely have been nice either in the caller
or in the callee. If I could have thought that id could be zero somehow here.
In retrospect it makes sense that there is possibility that IDs of regs in
this_branch and other_branch may diverge.
Hence I'm adding the warn to check for this specific divergence.
