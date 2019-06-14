Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D585B45147
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfFNBmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:42:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44104 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfFNBms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 21:42:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so356636pfe.11;
        Thu, 13 Jun 2019 18:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jzpsxDMNS8UK2eBklpzPEuRsJqMsHGf25d9GyayeVBU=;
        b=fP72U4Jzyu/hdEUfkHd+/kxVS0GZzofrREsXKD5z7ReAmedvFcwhMNgKOlC6OfJLDa
         V9nlW8T8zIQJDXoay6F2sNIiWLn584W4wd0kQr4jF6aK5yUok1M9rG3u3DfrjpwcWbCc
         DCKJ4HLttSPBVWs9mdeoIHRgj8gGDNQwaYRmaviigZ6IxBPRVJVg8LJkqMtdbZeparav
         QRjnSZmbiGWcn1W8ibp9D30d4UyZ4+ELykxQXzMmR54KGcxxS9ES21XUNV3dDbdX8R5K
         VdJJY2jImistWBp56Od6pZptOGrPwrb3ikDhsdRXwwTIu/bDIEPANBN3EKKfF3oBPDDq
         pP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jzpsxDMNS8UK2eBklpzPEuRsJqMsHGf25d9GyayeVBU=;
        b=gvyBfKysJmokwm0kFzIsgsk89roIaS7gH2j3us9F4dblaD4USYl63M7/J7lIOO5aVT
         fj0rt1AFAAwf6cbd1kWQJIl0gnDxZqFFnII8z9ByA/85WwblgFh2fkf/ysN+LYEZM+42
         H/GtZpvYknDJb4wgcKPbtofQYNGBPRy4lK6v0sRDiQTV5i9fK3EZUKBBHKGnnOFTTjJk
         VCJOm09VdPQBMoSMRJkjzZr6AydgvKMDbdRgjp2WU6sVDY44hXdWs9jsVn1IdWznVVhy
         dCNdjGNO6ucJCG0aH68+Z/AEgfpfzj8zCwrI53WT+NWwNgHaZMMRjTg0r71Zh7wu39JM
         GnnA==
X-Gm-Message-State: APjAAAUed1M9di6Bb4POirLtEV750/OaGhFN6xDfMGpOuNQ0pS2ODVmH
        vqZfYSEgBrOUGg3xCDrd8wQ=
X-Google-Smtp-Source: APXvYqxe4jUXdpT8c/VlouFhB7WXfU8y0toA0DuZKPYzHYc5c1XwlppkrZhNCOc2Xo6zRdibOccz/Q==
X-Received: by 2002:a17:90a:5d09:: with SMTP id s9mr8237778pji.120.1560476567770;
        Thu, 13 Jun 2019 18:42:47 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:e034])
        by smtp.gmail.com with ESMTPSA id j2sm975015pgq.13.2019.06.13.18.42.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 18:42:46 -0700 (PDT)
Date:   Thu, 13 Jun 2019 18:42:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614013051.6gnwduy4dsygbamj@treble>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:30:51PM -0500, Josh Poimboeuf wrote:
> On Thu, Jun 13, 2019 at 03:00:55PM -0700, Alexei Starovoitov wrote:
> > > @@ -392,8 +402,16 @@ bool unwind_next_frame(struct unwind_state *state)
> > >  	 * calls and calls to noreturn functions.
> > >  	 */
> > >  	orc = orc_find(state->signal ? state->ip : state->ip - 1);
> > > -	if (!orc)
> > > -		goto err;
> > > +	if (!orc) {
> > > +		/*
> > > +		 * As a fallback, try to assume this code uses a frame pointer.
> > > +		 * This is useful for generated code, like BPF, which ORC
> > > +		 * doesn't know about.  This is just a guess, so the rest of
> > > +		 * the unwind is no longer considered reliable.
> > > +		 */
> > > +		orc = &orc_fp_entry;
> > > +		state->error = true;
> > 
> > That seems fragile.
> 
> I don't think so.  The unwinder has sanity checks to make sure it
> doesn't go off the rails.  And it works just fine.  The beauty is that
> it should work for all generated code (not just BPF).
> 
> > Can't we populate orc_unwind tables after JIT ?
> 
> As I mentioned it would introduce a lot more complexity.  For each JIT
> function, BPF would have to tell ORC the following:
> 
> - where the BPF function lives
> - how big the stack frame is
> - where RBP and other callee-saved regs are on the stack

that sounds like straightforward addition that ORC should have anyway.
right now we're not using rbp in the jit-ed code,
but one day we definitely will.
Same goes for r12. It's reserved right now for 'strategic use'.
We've been thinking to add another register to bpf isa.
It will map to r12 on x86. arm64 and others have plenty of regs to use.
The programs are getting bigger and register spill/fill starting to
become a performance concern. Extra register will give us more room.

