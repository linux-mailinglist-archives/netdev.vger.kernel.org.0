Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5062936CF7C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 01:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhD0XUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 19:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbhD0XUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 19:20:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0268EC061574;
        Tue, 27 Apr 2021 16:19:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f6-20020a17090a6546b029015088cf4a1eso8086667pjs.2;
        Tue, 27 Apr 2021 16:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7Wv20ZDMGbYNHC9aSlg9hjol9w8rXAxwJ2DXVd7fRS0=;
        b=NZSDx9segpXXD1bosNnZFPerWUayaD8gjugGprFa8vSEXcYkyiR/2xGQyau9+d1sKm
         bh215pdZhbQPjQ+d4ayYZC/yNWNeLu5gfvcttu+rdqIR71Mh4GwpmHMmPbbBxE167j54
         61nhqTroPq6OwnAf/ccvyoFIKL0k72CPibx+HQJ4IxbJHXb1UyA8aVaaFPDOsNWlu6YA
         p5vyDBUWBMDcnY77ybFxLZkBRlh6Ds3A0FC6DdrZozuT+mPiQLSRtCDelcUqax42wauH
         VMVPvLhFA2Z2Mzpzd9nVezliCuhVrR1zEy8M8TuDFMww2jDUBjtQ6RBuiiXXGCKIJgGM
         c6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7Wv20ZDMGbYNHC9aSlg9hjol9w8rXAxwJ2DXVd7fRS0=;
        b=KKRKac/D3ZQH/r1Kxqu2GiGpixkHKXCB4DakdXoBqUYz2j+rR5BwAiqEjJGB9Wo9Xw
         H1Brtr1mo5yVUA3lbRKHDUKxqWqhq+Hf9z+EMLs8EwSx1kTkVI+tQY5lEkCzsRh6265J
         AQ9Yke2F34BLhCf0j/pmZHv1vPhOATpkEtx8bZ7OE51kcHrRU8rncFOiTkK+XhndA76S
         Z/k/E19w29ya7FQYUsFg7igA4cItoy2VPuGfRfxMzLFj54Is5YzRRQU1sH36siW1uumQ
         BK1ygBHr4upMRaf0OSb4zFAuZkNXLeCOthG01AMsQnfHoQGX3boVMEe25N5DOh5eOE0H
         TRUw==
X-Gm-Message-State: AOAM533F82nEM4+zp7pzA/BaOAMk7fvZE1P3dpneHB5BLXRl5rrfhoAe
        +3JSLvlG7HdckNbA7iJBHO26PwYLYdo=
X-Google-Smtp-Source: ABdhPJzpYBk+oYOsdkqdChopP3djnr73oHXwKqkPG9R9Ibz5333kqUxJdrXVX3yNziCjE1fddN/b2A==
X-Received: by 2002:a17:90b:1c0f:: with SMTP id oc15mr30814984pjb.228.1619565558552;
        Tue, 27 Apr 2021 16:19:18 -0700 (PDT)
Received: from localhost ([47.15.118.129])
        by smtp.gmail.com with ESMTPSA id u20sm675545pgl.27.2021.04.27.16.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 16:19:18 -0700 (PDT)
Date:   Wed, 28 Apr 2021 04:49:15 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210427231915.4tz4fs6hmthatufm@apollo>
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
 <20210427180202.pepa2wdbhhap3vyg@apollo>
 <9985fe91-76ea-7c09-c285-1006168f1c27@iogearbox.net>
 <7a75062e-b439-68b3-afa3-44ea519624c7@iogearbox.net>
 <87sg3b8idy.fsf@toke.dk>
 <8e6d24fa-d3ef-af20-b2a5-dbdc9a284f6d@iogearbox.net>
 <87pmyf8hp1.fsf@toke.dk>
 <b1a576ad-5c34-a6e6-6ab0-0ac07356f9ea@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1a576ad-5c34-a6e6-6ab0-0ac07356f9ea@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 04:44:23AM IST, Daniel Borkmann wrote:
> On 4/28/21 12:51 AM, Toke Høiland-Jørgensen wrote:
> > Daniel Borkmann <daniel@iogearbox.net> writes:
> > > On 4/28/21 12:36 AM, Toke Høiland-Jørgensen wrote:
> > > > Daniel Borkmann <daniel@iogearbox.net> writes:
> > > [...]
> > > > > Small addendum:
> > > > >
> > > > >        DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = 42, .which = BPF_TC_INGRESS|BPF_TC_EGRESS);
> > > > >
> > > > >        err = bpf_tc_hook_create(&hook);
> > > > >        [...]
> > > > >
> > > > > ... is also possible, of course, and then both bpf_tc_hook_{create,destroy}() are symmetric.
> > > >
> > > > It should be allowed, but it wouldn't actually make any difference which
> > > > combination of TC_INGRESS and TC_EGRESS you specify, as long as one of
> > > > them is set, right? I.e., we just attach the clsact qdisc in both
> > > > cases...
> > >
> > > Yes, that is correct, for the bpf_tc_hook_create() whether you pass in BPF_TC_INGRESS,
> > > BPF_TC_EGRESS or BPF_TC_INGRESS|BPF_TC_EGRESS, you'll end up creating clsact qdisc in
> > > either of the three cases. Only the bpf_tc_hook_destroy() differs
> > > between all of them.
> >
> > Right, just checking. Other than that, I like your proposal; it loses
> > the "automatic removal of qdisc if we added it" feature, but that's
> > probably OK: less magic is good. And as long as bpf_tc_hook_create()
> > returns EEXIST if the qdisc already exists, the caller can do the same
> > thing if they want.
>
> Yes exactly. Less magic the better, especially given this has global effect.
>

Everything sounds good. I'll do a resend.

> Thanks,
> Daniel

--
Kartikeya
