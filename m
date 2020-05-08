Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2250A1CA6D7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 11:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgEHJJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 05:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgEHJJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 05:09:46 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D64C05BD43;
        Fri,  8 May 2020 02:09:46 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i15so963493wrx.10;
        Fri, 08 May 2020 02:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p7Oo79oNhd+kPxJh16w5kfZK0RMqQPZw5ze2he5tSgc=;
        b=F/1Uj08hspKQEDMOT/fANLhevQMMgy1SrXgay+9/oz3+A+3g+I/kYYv4mCt56wYv+t
         QlCxjvI9rbnaKepUCyioR8Qr90rMcB1JvD4oiw1bLZ+rJnJxCkaUUhtQueUhwDXrlRIO
         QsNB5Qs1AYdhREh367/sJa9cBWTk2KsSplFdrWqk812a0eRpuVGXEejWkDTuI4PJiPJJ
         cYrAN/VpGrc30og0FCrwjuR8n/AjYp7pv9tMHoESmN8ksePSMA52F6z5MlBfpD8cFEAt
         Uq4N81qdnZn71LDDLDOTRx1ljDXapqgm6D/s4cT+GCLQ3zcZyJ2c8Tf/Udx7MbFdCuM8
         4T1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p7Oo79oNhd+kPxJh16w5kfZK0RMqQPZw5ze2he5tSgc=;
        b=bk5F8sP5tOoD4vEXWZShlm1MsQuXZU74IwjubWQqLAv4pqZO4aElNB0L+cxhwbC4VZ
         FFS17lsz32C0eHFyAmvei9mTPdT/22G8MiSYipWNGiyEAXG1uQq2+O+UY01PEONTvcot
         tDgUCzV3YDl2+s1In8SmDvs1BOHL8sMMj5daOEC7jHpYhU91bl2n+rut3zZEJ/51oYNZ
         WktC6nahjDuCXskVAlKsZMW6MIbForVcqyWK39FOzijKPxden6V0b+NfwxPMq7KNYFm3
         +Lwp++r2Vlz8Ro3JxV9kGknrJAvT+rfPpsRMY7oPaa2mIJLb1EeSDhQr+c/IkyO8RMOl
         97Ng==
X-Gm-Message-State: AGi0PuaMWaYcAlAjGMmkmK8NYogZmQoz9+YkhpufBGcc1i4PfTS6bT3u
        gBiPIVvxJ+T+DvAIZRmCkPj7+nKo09pb3LDwYk8DN/AlAp06+A==
X-Google-Smtp-Source: APiQypIPE+pqGebuZBg0T794AuAfiq1oUvgxKv7siZkTjYleX0sB+eynC0pSSDgNAhZJZmCVHD7JBh7IvpsSvOfjKt0=
X-Received: by 2002:a5d:4107:: with SMTP id l7mr1787338wrp.160.1588928984754;
 Fri, 08 May 2020 02:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com>
 <877dxnkggf.fsf@toke.dk> <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com>
 <871rnvkdhw.fsf@toke.dk> <5eb44eb03f8e1_22a22b23544285b87a@john-XPS-13-9370.notmuch>
In-Reply-To: <5eb44eb03f8e1_22a22b23544285b87a@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 8 May 2020 11:09:33 +0200
Message-ID: <CAJ+HfNhXq=17650ztPcnTSP4ztj8K1zwbC-GojYkZviPBdOGxA@mail.gmail.com>
Subject: Re: XDP bpf_tail_call_redirect(): yea or nay?
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 at 20:08, John Fastabend <john.fastabend@gmail.com> wrot=
e:
>
[]
>
> I'm wondering if we can teach the verifier to recognize tail calls,
>
> int xdp_prog1(struct xdp_md *ctx)
> {
>         return xdp_do_redirect(ctx, &xsks_map, 0);
> }
>
> This would be useful for normal calls as well. I guess the question here
> is would a tail call be sufficient for above case or do you need the
> 'return XDP_PASS' at the end? If so maybe we could fold it into the
> helper somehow.
>

No, that was just for handling the "failed call", bpf_tail_call() style.

> I think it would also address Toke's concerns, no new action so
> bpf developers can just develope like normal but "smart" developers
> will try do calls as tail calls. Not sure it can be done without
> driver changes though.
>

Take me though this. So, the new xdp_do_redirect() would return
XDP_REDIRECT? If the call is a tail call, we can "consume" (perform
the REDIRECT action) in the helper, set a "we're done/tail call
performed" flag in bpf_redirect_info and the xdp_do_redirect() checks
this flag and returns directly. If the call is *not* a tail call, the
regular REDIRECT path is performed. Am I following that correctly? So
we would be able to detect if the optimization has been performed, so
the "consume" semantics can be done.

Or do you mean that xdp_do_redirect() is only allowed if it can be
tailcall optimized?

int xdp_prog1(struct xdp_md *ctx)
{
        int ret;

        ret =3D xdp_do_redirect(ctx, &xsks_map, 0);
        // If xdp_do_redirect() consumes the context, the ctx is stale
        // here.
        ...
        return ret;
}

Let me clarify what I'm trying to do. bpf_redirect_map() performs a
lookup into the map. It would make sense to perform the action here as
well, since everything (maptype/item)is known. Today,
bpf_redirect_info is populated, and then the maptype is looked up
again from xdp_do_redirect(), and bpf_redirect_info() is cleared. I'd
like to get rid of bpf_redirect_info and xdp_do_redirect(), when
possible.

> > >> >
> > >> > -->8--
> > >> >
> > >> > The bpf_tail_call_redirect() would work with all redirectable maps=
.
> > >> >
> > >> > Thoughts? Tomatoes? Pitchforks?
> > >>
> > >> The above answers the 'what'. Might be easier to evaluate if you als=
o
> > >> included the 'why'? :)
> > >>
> > >
> > > Ah! Sorry! Performance, performance, performance. Getting rid of a
> > > bunch of calls/instructions per packet, which helps my (AF_XDP) case.
> > > This would be faster than the regular REDIRECT path. Today, in
> > > bpf_redirect_map(), instead of actually performing the action, we
> > > populate the bpf_redirect_info structure, just to look up the action
> > > again in xdp_do_redirect().
> > >
> > > I'm pretty certain this would be a gain for AF_XDP (quite easy to do =
a
> > > quick hack, and measure). It would also shave off the same amount of
> > > instructions for "vanilla" XDP_REDIRECT cases. The bigger issue; Is
> > > this new semantic something people would be comfortable being added t=
o
> > > XDP.
> >
> > Well, my immediate thought would be that the added complexity would not
> > be worth it, because:
> >
> > - A new action would mean either you'd need to patch all drivers or
> >   (more likely) we'd end up with yet another difference between drivers=
'
> >   XDP support.
> >
> > - BPF developers would suddenly have to choose - do this new faster
> >   thing, or be compatible? And manage the choice based on drivers they
> >   expect to run on, etc. This was already confusing with
> >   bpf_redirect()/bpf_redirect_map(), and this would introduce a third
> >   option!
> >
> > So in light of this, I'd say the performance benefit would have to be
> > quite substantial for this to be worth it. Which we won't know until yo=
u
> > try it, I guess :)
>
> Knowing the number would be useful. But if it can be done in general
> way it may not need to be as high because its not a special xdp thing.
>

Yeah, I need to do some experimentation here!

> >
> > Thinking of alternatives - couldn't you shoe-horn this into the existin=
g
> > helper and return code? Say, introduce an IMMEDIATE_RETURN flag to the
> > existing helpers, which would change the behaviour to the tail call
> > semantics. When used, xdp_do_redirect() would then return immediately
> > (or you could even turn xdp_do_redirect() into an inlined wrapper that
> > checks the flag before issuing a CALL to the existing function). Any
> > reason why that wouldn't work?
>
> I think it would work but I it would be even nicer if clang, verifier
> and jit caught the tail call pattern and did it automatically.
>

Yes. :-)


Thanks for the input, and the ideas!
Bj=C3=B6rn

> >
> > -Toke
> >
