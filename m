Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12701C98DB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgEGSI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726467AbgEGSI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:08:58 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF72AC05BD43;
        Thu,  7 May 2020 11:08:57 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id j8so1562056iog.13;
        Thu, 07 May 2020 11:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xsOZEjIQEncD2S0u2BwDL3mPS8GtyzOt2wkpIZXJQFA=;
        b=YOM0mv67e7jJfrMyLF2/xuKSNYfGuVHSw3d12DwmS6Z8rT3C2G18bzDlM5A5lJIRSR
         fdNjMYmwlzqIaj/K4XknQs/XglZd/ZlQEBNn6L+d01RKahixoSZkTQXICkeIX9WAr2jv
         tmTXW3mDjHyDwQZ0oFeb2jwKP128eQTfkRwBo7p1WIr51k3Y57SltfyteYMf3cQ0ncfk
         6Uoqju0sBM/aLs/sp++bgftOCOpzQyI//tSFn9xLhOBaar/hOIUUMNXqgwjkaNYAYPqC
         /AphYT2EjHI11R9/Rz+WcMbjQ9NVziwQWCTvNNmKEno1qYFQhtldSuvme2fUCUN2eI5m
         mMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xsOZEjIQEncD2S0u2BwDL3mPS8GtyzOt2wkpIZXJQFA=;
        b=oDlFdi4CpkOB/AyYDS8va1pKIVGHkA6JOgACjYTQ2xM8BPv362WYVmtUWbdhkGqsnX
         eGSA25+BEfSU/8C9hjsHWrAyC/WGw/tism79EP3iTSlJeUtvuYdDLt/0QIA1ALxjEo75
         XY1R41YKzmF+7rfKCo10D/n8SHJZ+2/CqVkDUQEFL1cLNmSrXhOWFt8yH1bG3xKogFKU
         cklBarigqhZu6TvKEeMsyzMpsvW0LNGct1f3eNt6cor/fDOljJJ6zn5yRikwybygmlgV
         kFVQTZeNsmJT/biuFwby2mKN2fwA8Y2OZEIrk0etoKA5NMC0H61moLix1KfA52huw0hg
         EjHw==
X-Gm-Message-State: AGi0PuaX1OLFJlEyMDtA6RbFCxC6uTSzBPEYfX8hNQMai1zpkPduYY/O
        lDRVhFd38huAID633rtMbmI=
X-Google-Smtp-Source: APiQypJobp+PBLdpwW3dPS2WA5H2nDI8F93yDy7M9URdT4jdvy0xERhRNGj2rzh9XzRRAT9MU3eaiA==
X-Received: by 2002:a05:6638:62f:: with SMTP id h15mr14607637jar.102.1588874936987;
        Thu, 07 May 2020 11:08:56 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l14sm2773698ioj.12.2020.05.07.11.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 11:08:56 -0700 (PDT)
Date:   Thu, 07 May 2020 11:08:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <5eb44eb03f8e1_22a22b23544285b87a@john-XPS-13-9370.notmuch>
In-Reply-To: <871rnvkdhw.fsf@toke.dk>
References: <CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com>
 <877dxnkggf.fsf@toke.dk>
 <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com>
 <871rnvkdhw.fsf@toke.dk>
Subject: Re: XDP bpf_tail_call_redirect(): yea or nay?
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> =

> > On Thu, 7 May 2020 at 15:44, Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> >>
> >> > Before I start hacking on this, I might as well check with the XDP=

> >> > folks if this considered a crappy idea or not. :-)
> >> >
> >> > The XDP redirect flow for a packet is typical a dance of
> >> > bpf_redirect_map() that updates the bpf_redirect_info structure wi=
th
> >> > maps type/items, which is then followed by an xdp_do_redirect(). T=
hat
> >> > function takes an action based on the bpf_redirect_info content.
> >> >
> >> > I'd like to get rid of the xdp_do_redirect() call, and the
> >> > bpf_redirect_info (per-cpu) lookup. The idea is to introduce a new=

> >> > (oh-no!) XDP action, say, XDP_CONSUMED and a built-in helper with
> >> > tail-call semantics.
> >> >
> >> > Something across the lines of:
> >> >
> >> > --8<--
> >> >
> >> > struct {
> >> >         __uint(type, BPF_MAP_TYPE_XSKMAP);
> >> >         __uint(max_entries, MAX_SOCKS);
> >> >         __uint(key_size, sizeof(int));
> >> >         __uint(value_size, sizeof(int));
> >> > } xsks_map SEC(".maps");
> >> >
> >> > SEC("xdp1")
> >> > int xdp_prog1(struct xdp_md *ctx)
> >> > {
> >> >         bpf_tail_call_redirect(ctx, &xsks_map, 0);
> >> >         // Redirect the packet to an AF_XDP socket at entry 0 of t=
he
> >> >         // map.
> >> >         //
> >> >         // After a successful call, ctx is said to be
> >> >         // consumed. XDP_CONSUMED will be returned by the program.=

> >> >         // Note that if the call is not successful, the buffer is
> >> >         // still valid.
> >> >         //
> >> >         // XDP_CONSUMED in the driver means that the driver should=
 not
> >> >         // issue an xdp_do_direct() call, but only xdp_flush().
> >> >         //
> >> >         // The verifier need to be taught that XDP_CONSUMED can on=
ly
> >> >         // be returned "indirectly", meaning a bpf_tail_call_XXX()=

> >> >         // call. An explicit "return XDP_CONSUMED" should be
> >> >         // rejected. Can that be implemented?
> >> >         return XDP_PASS; // or any other valid action.
> >> > }

I'm wondering if we can teach the verifier to recognize tail calls,

int xdp_prog1(struct xdp_md *ctx)
{
	return xdp_do_redirect(ctx, &xsks_map, 0);
}

This would be useful for normal calls as well. I guess the question here
is would a tail call be sufficient for above case or do you need the
'return XDP_PASS' at the end? If so maybe we could fold it into the
helper somehow.

I think it would also address Toke's concerns, no new action so
bpf developers can just develope like normal but "smart" developers
will try do calls as tail calls. Not sure it can be done without
driver changes though.

> >> >
> >> > -->8--
> >> >
> >> > The bpf_tail_call_redirect() would work with all redirectable maps=
.
> >> >
> >> > Thoughts? Tomatoes? Pitchforks?
> >>
> >> The above answers the 'what'. Might be easier to evaluate if you als=
o
> >> included the 'why'? :)
> >>
> >
> > Ah! Sorry! Performance, performance, performance. Getting rid of a
> > bunch of calls/instructions per packet, which helps my (AF_XDP) case.=

> > This would be faster than the regular REDIRECT path. Today, in
> > bpf_redirect_map(), instead of actually performing the action, we
> > populate the bpf_redirect_info structure, just to look up the action
> > again in xdp_do_redirect().
> >
> > I'm pretty certain this would be a gain for AF_XDP (quite easy to do =
a
> > quick hack, and measure). It would also shave off the same amount of
> > instructions for "vanilla" XDP_REDIRECT cases. The bigger issue; Is
> > this new semantic something people would be comfortable being added t=
o
> > XDP.
> =

> Well, my immediate thought would be that the added complexity would not=

> be worth it, because:
> =

> - A new action would mean either you'd need to patch all drivers or
>   (more likely) we'd end up with yet another difference between drivers=
'
>   XDP support.
> =

> - BPF developers would suddenly have to choose - do this new faster
>   thing, or be compatible? And manage the choice based on drivers they
>   expect to run on, etc. This was already confusing with
>   bpf_redirect()/bpf_redirect_map(), and this would introduce a third
>   option!
> =

> So in light of this, I'd say the performance benefit would have to be
> quite substantial for this to be worth it. Which we won't know until yo=
u
> try it, I guess :)

Knowing the number would be useful. But if it can be done in general
way it may not need to be as high because its not a special xdp thing.

> =

> Thinking of alternatives - couldn't you shoe-horn this into the existin=
g
> helper and return code? Say, introduce an IMMEDIATE_RETURN flag to the
> existing helpers, which would change the behaviour to the tail call
> semantics. When used, xdp_do_redirect() would then return immediately
> (or you could even turn xdp_do_redirect() into an inlined wrapper that
> checks the flag before issuing a CALL to the existing function). Any
> reason why that wouldn't work?

I think it would work but I it would be even nicer if clang, verifier
and jit caught the tail call pattern and did it automatically.

> =

> -Toke
> =
