Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B489431C48C
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 01:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBPATS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 19:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhBPATR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 19:19:17 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E77C061574;
        Mon, 15 Feb 2021 16:18:37 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id f20so8458802ioo.10;
        Mon, 15 Feb 2021 16:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AwL+hqtLgXytckx1IuR+ul+fmCz+1zDAfOI1doww3rs=;
        b=CY+Cq4fnEUr7ll/T73HohYP9qxMDPMTpKK39lESvMNSO+byN5D5SPeGqQL362oeMSd
         hfesNtLbdYdgTL49IrLpssszJTHdhy5gKGVsIIlQm/GSp+35Y22DiHB/5iNm63IpaIGR
         H3pF77Qd1N/H9vkvhZINrOBQOarLoiawG5/ZnJeEu7XcuHmgGf2lKcTPonvWcA8k/Kmi
         nsXIV0pMWOlKVFQnE92ShJSEB7/dDz7ZLiMd+L/eG96xb+TMAh3KfZ1qZ8kN+gW/+fjc
         +hgwX2PfR8jY1r+bCDukA9gwMyKoGCEZiy4ltShqMwaus93jnJIIxTSyn1zLKiMqy5FG
         CyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AwL+hqtLgXytckx1IuR+ul+fmCz+1zDAfOI1doww3rs=;
        b=gUy4TgvHihK64bHW1veKU58v8wI1xqgoMWJbgwuv36oBgM6rhAiRheREzzP6EgrSlc
         EEFIg+iTREai7P6x8KGI3tEBReWwEmkF0w/4w65Ohg4hta3f8KKuKi79VkKjnHwdZCiN
         8PBzvtJa1fb3UjekF29CcTALJtC7FQvjE1KO7+iRCghf0Z0SuTYD4ywyLBTHgyz0Lhre
         4omE/pSmGe1guCrRr8xInDQq7s+NPqwa1pZYmI0U3/3c+nhquyaAugI08OYd2dCtRVwa
         +BHTZVEfZpqHNvqhME/pL3WBdO8WIjEpgJpDjpcYCka8mbipyfNMZxMWNBzwySYIgFho
         9nZw==
X-Gm-Message-State: AOAM532aw8qvwF0Djgtf2yYpxKITEiSE5DTdCmxEYmlJDE/tkhMdAYS1
        nIuMPuqh1NjY+lpekfhcGvQbFBbNb48=
X-Google-Smtp-Source: ABdhPJxX0ovef/HbilX6nWgiRfKOazv58wjDoIBcAuYuTcaXgwYc7+Bi5aJ85WuaRM2gabrQxsr8ig==
X-Received: by 2002:a02:cb5c:: with SMTP id k28mr8549051jap.104.1613434716933;
        Mon, 15 Feb 2021 16:18:36 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id j10sm462614ilk.30.2021.02.15.16.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 16:18:36 -0800 (PST)
Date:   Mon, 15 Feb 2021 16:18:28 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Message-ID: <602b0f54c05a6_3ed41208dc@john-XPS-13-9370.notmuch>
In-Reply-To: <8735xxc8pf.fsf@toke.dk>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
 <8735xxc8pf.fsf@toke.dk>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> >> > However, in libxdp we can solve the original problem in a differen=
t way,
> >> > and in fact I already suggested to Magnus that we should do this (=
see
> >> > [1]); so one way forward could be to address it during the merge i=
n
> >> > libxdp? It should be possible to address the original issue (two
> >> > instances of xdpsock breaking each other when they exit), but
> >> > applications will still need to do an explicit unload operation be=
fore
> >> > exiting (i.e., the automatic detach on bpf_link fd closure will ta=
ke
> >> > more work, and likely require extending the bpf_link kernel suppor=
t)...
> >> >
> >> =

> >> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
> >> we're months ahead, then I'd really like to see this in libbpf until=
 the
> >> merge. However, I'll leave that for Magnus/you to decide!
> >
> > Did I miss some thread? What does this mean libbpf 1.0/libxdp merge?
> =

> The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff to=

> libxdp (so the socket stuff in xsk.h). We're adding the existing code
> wholesale, and keeping API compatibility during the move, so all that's=

> needed is adding -lxdp when compiling. And obviously the existing libbp=
f
> code isn't going anywhere until such a time as there's a general
> backwards compatibility-breaking deprecation in libbpf (which I believe=

> Andrii is planning to do in an upcoming and as-of-yet unannounced v1.0
> release).

OK, I would like to keep the basic XDP pieces in libbpf though. For examp=
le
bpf_program__attach_xdp(). This way we don't have one lib to attach
everything, but XDP.

> =

> While integrating the XSK code into libxdp we're trying to make it
> compatible with the rest of the library (i.e., multi-prog). Hence my
> preference to avoid introducing something that makes this harder :)
> =

> -Toke
> =


OK that makes sense to me thanks. But, I'm missing something (maybe its
obvious to everyone else?).

When you load an XDP program you should get a reference to it. And then
XDP program should never be unloaded until that id is removed right? It
may or may not have an xsk map. Why does adding/removing programs from
an associated map have any impact on the XDP program? That seems like
the buggy part to me. No other map behaves this way as far as I can
tell. Now if the program with the XDP reference closes without pinning
the map or otherwise doing something with it, sure the map gets destroyed=

and any xsk sockets are lost.

Thanks!
John=
