Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FC51CA6D2
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEHJIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 05:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgEHJIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 05:08:55 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627F1C05BD43;
        Fri,  8 May 2020 02:08:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z8so983536wrw.3;
        Fri, 08 May 2020 02:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=79tjuFVpCKsIYx/Y/a85HAqfNcGLWpvA8YjB6eufvyI=;
        b=m7bJC0euHfJm3bY5wZ3xvMRocJZj2IJhiDjqd5uRPIuETSIjaL8Y/5wjpw9nWjUGn8
         254hbouXElBIZbmoTDCo5KBmSZgB165v5JcgwfbY5zY6b8OwVPNO020qGb+dmj9QQCAU
         GB0mFsTI7GTasEotl3gsp3bUkC0VY5CrqpCI5ljfziEONDfx1hJF4uZVRkVCbSJrpC41
         Juv4HmvMl83s9h6wBdmNqpB7Jqm0+xOqMf5+QSQR+rO/Qr5xY4EAMH15EJfffZWpBw+P
         aHrdPaUaqRO4BkimtVZyp6qyriiVOSSDrZ51JuJ2PaWbpBxdxspOC0vgSiel1WF7Rin1
         fJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=79tjuFVpCKsIYx/Y/a85HAqfNcGLWpvA8YjB6eufvyI=;
        b=BsewSmBsftnw0aFSCpQ0WYE41vCa3dKhtlbkB/0DS/eRVvYf2t3JDYmhu1vOycA6+B
         aZ0DX7Zo5FfhVWGvZ27duzfjhijw7C8E1sBiLdkzm3pLV5stLRBKuJW53fUm9riI2iXX
         jUIgucn0YtcsRuWYese3yLNteQdmI+z2y1Sd711+E0rJUAryuCMZ+zhIivtwIX9B05yn
         WxMeZtJ3jjQe7N+7H/z9zyJj2bZwqCfLRvsgnA8Pyws/hjsWcLy/sndrupthW+36SISW
         gTGoS4bzknVEkgYe+J7ayutx98UDNyA+By8p5avPtHN4wR8sI3q7/gp6AKT5vI4nzxM9
         mYOg==
X-Gm-Message-State: AGi0PuZh7asXBkbcU1KOLarwCqXtsG8yOjLlErkVeKr8QYhdIbmBCA6X
        0QSuCoQwH2TkfoK7ckFRhqKG3PFJApEVaFXqLrw3574e+Y2EvA==
X-Google-Smtp-Source: APiQypIxdn2ZxZq5/VQl9MZZjHgNwzaDai5Ru4Qf04svSGccWip/P0BIm0Mw0kLoLoXeV0AoJfOdKTzwuZOG5lwolDo=
X-Received: by 2002:a5d:4107:: with SMTP id l7mr1782804wrp.160.1588928932151;
 Fri, 08 May 2020 02:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com>
 <877dxnkggf.fsf@toke.dk> <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com>
 <871rnvkdhw.fsf@toke.dk>
In-Reply-To: <871rnvkdhw.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 8 May 2020 11:08:40 +0200
Message-ID: <CAJ+HfNim_4pZz4SvV06R5pZ0AffT=v7G6AqRNm=mz+OBgOpm7A@mail.gmail.com>
Subject: Re: XDP bpf_tail_call_redirect(): yea or nay?
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 at 16:48, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
[]
> Well, my immediate thought would be that the added complexity would not
> be worth it, because:
>
> - A new action would mean either you'd need to patch all drivers or
>   (more likely) we'd end up with yet another difference between drivers'
>   XDP support.
>

Right, but it would be trivial to add for drivers that already support
XDP_REDIRECT, so I'm not worried about that particular problem. That
aside, let's move on. I agree that adding action should be avoided!

> - BPF developers would suddenly have to choose - do this new faster
>   thing, or be compatible? And manage the choice based on drivers they
>   expect to run on, etc. This was already confusing with
>   bpf_redirect()/bpf_redirect_map(), and this would introduce a third
>   option!
>

True. For the sake of the argument; Adding flags vs adding a new
helper, i.e. bpf_redirect_map(flag_with_new_semantic) vs a new helper.
Today XDP developers that use bpf_redirect_map() need to consider
whether the kernel support the "pass action via flags" or not, so this
would be a *fourth* option. :-P

I'm with you here. The best option would be a transparent one.


> So in light of this, I'd say the performance benefit would have to be
> quite substantial for this to be worth it. Which we won't know until you
> try it, I guess :)
>

Hear, hear!

> Thinking of alternatives - couldn't you shoe-horn this into the existing
> helper and return code? Say, introduce an IMMEDIATE_RETURN flag to the
> existing helpers, which would change the behaviour to the tail call
> semantics. When used, xdp_do_redirect() would then return immediately
> (or you could even turn xdp_do_redirect() into an inlined wrapper that
> checks the flag before issuing a CALL to the existing function). Any
> reason why that wouldn't work?
>

Sure, but this wouldn't remove the per-cpu/bpf_redirect_info lookup.
Then again, maybe it's better to start there. To clarify, just a flag
isn't sufficient. It would need to be a guarantee that the program
exists after the call, i.e. tail call support. From clang/BPF
instruction (Alexei's/John's replies), or something like
bpf_tail_call(). Unless I'm missing something... Or do you mean that
the flag IMMEDIATE_RETURN would perform the action in the helper? The
context would be stale after that call, and the verifier should reject
a program that pokes the context, but the flag is a runtime thing. It
sounds like a pretty complex verifier task to determine if
IMMEDIATE_RETURN is set, and then reject ctx accesses there.


Thanks for the input, and good ideas!
Bj=C3=B6rn

> -Toke
>
