Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F29613CB5E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgAORtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:49:43 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36240 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgAORtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:49:43 -0500
Received: by mail-pj1-f65.google.com with SMTP id n59so265188pjb.1;
        Wed, 15 Jan 2020 09:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OziLB12L1c4/xldafs8TFNbJdMMXchHDGr185qg7eQQ=;
        b=sPjEhRYgwWsw4PQWVVjNy5OfarApTQkAfsrrgaZtEhQx2FL8jE3fwhu3Kf5RGpF+PG
         uOLYmEHfq/rdptTOHcymPBrhJoXv2pqft9wxGmAyrj/dFUp7elA30miAY0Il+x3i8alo
         6MNtX95tkZQ1N8KN5XUeDolRcBFzHTrjXeoA34KAC/liejS8xsSjDZ+tSu93AG4olksU
         tEfEHMrlekKPKU+6kyMr6ppHuuIo1pY8ks8gQVVEB3qrJ6ikWl1wpz6jzOHZwJM6TDPx
         BNGKLeQJOtJwoPTaqDV1zNdA20qYuE87yvkgnpkdUq426CMqAQeI5lnUU4gUL/BcidR/
         Stuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OziLB12L1c4/xldafs8TFNbJdMMXchHDGr185qg7eQQ=;
        b=fBOKBq4LyeYiK7yPlrKCRKWDWNdmOOT5HwHQ2ZKW7DGtoPOQJQu97Pycpawn/CrEN0
         wZbqHDPDJmTRmh4cQFIAQrZZcvM7Fkbqr6rJHDNxFIEVqa7lrrOnMQiPwNhDhqndUSBv
         E3HBBtcYJH0f+kQ4jquYvERqQBgfQx+l/TXH3No+rM/GDSR/EnZcGrlKuHJwgiDE0FIR
         O2WNgtJfb9Rx+GZptQAw1lhtpheyAG4PLVnJUsk70cuniFifYJhYpoOVc4HOxAq9QiEs
         cUdBrf+9NW+HIewXdvFIQ2TLiqYG+qDIar/kMcKxBi9w9rbDKjR5QAa+XBpG/KknMT9t
         3C7w==
X-Gm-Message-State: APjAAAUxyScmQ6+vRqdvZt1rDrrybbNKTpPma2pS4SHZ86UtiPPnbStl
        3e+Pm5HMXisIQz3PJK9oHKs=
X-Google-Smtp-Source: APXvYqxVxzOx9wj/g2ZqslqwknaIumrpdyqw/rcb151ThwL914v3ucf1lPVSJ94xGLmkCxkGq04Bog==
X-Received: by 2002:a17:902:9889:: with SMTP id s9mr19185233plp.252.1579110582314;
        Wed, 15 Jan 2020 09:49:42 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id m19sm433584pjv.10.2020.01.15.09.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 09:49:41 -0800 (PST)
Date:   Wed, 15 Jan 2020 09:49:41 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e1f50b55663_201b2acc3bfce5b8da@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQ+Kr_zv9eWF2+eDLJVtva48o04Jj0v4wjzmERVGKSA+ng@mail.gmail.com>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk>
 <CAADnVQ+Kr_zv9eWF2+eDLJVtva48o04Jj0v4wjzmERVGKSA+ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/2] xdp: Introduce bulking for non-map
 XDP_REDIRECT
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Mon, Jan 13, 2020 at 10:11 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >
> > Since commit 96360004b862 ("xdp: Make devmap flush_list common for al=
l map
> > instances"), devmap flushing is a global operation instead of tied to=
 a
> > particular map. This means that with a bit of refactoring, we can fin=
ally fix
> > the performance delta between the bpf_redirect_map() and bpf_redirect=
() helper
> > functions, by introducing bulking for the latter as well.
> >
> > This series makes this change by moving the data structure used for t=
he bulking
> > into struct net_device itself, so we can access it even when there is=
 not
> > devmap. Once this is done, moving the bpf_redirect() helper to use th=
e bulking
> > mechanism becomes quite trivial, and brings bpf_redirect() up to the =
same as
> > bpf_redirect_map():
> >
> >                        Before:   After:
> > 1 CPU:
> > bpf_redirect_map:      8.4 Mpps  8.4 Mpps  (no change)
> > bpf_redirect:          5.0 Mpps  8.4 Mpps  (+68%)
> > 2 CPUs:
> > bpf_redirect_map:     15.9 Mpps  16.1 Mpps  (+1% or ~no change)
> > bpf_redirect:          9.5 Mpps  15.9 Mpps  (+67%)
> >
> > After this patch series, the only semantics different between the two=
 variants
> > of the bpf() helper (apart from the absence of a map argument, obviou=
sly) is
> > that the _map() variant will return an error if passed an invalid map=
 index,
> > whereas the bpf_redirect() helper will succeed, but drop packets on
> > xdp_do_redirect(). This is because the helper has no reference to the=
 calling
> > netdev, so unfortunately we can't do the ifindex lookup directly in t=
he helper.
> >
> > Changelog:
> >
> > v2:
> >   - Consolidate code paths and tracepoints for map and non-map redire=
ct variants
> >     (Bj=C3=B6rn)
> >   - Add performance data for 2-CPU test (Jesper)
> >   - Move fields to avoid shifting cache lines in struct net_device (E=
ric)
> =

> John, since you commented on v1 please review this v2. Thanks!

hmm don't think I had an initial comment but will review regardless ;)=
