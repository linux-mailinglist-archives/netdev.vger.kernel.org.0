Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACB7CF53D
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfJHIrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 04:47:22 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35581 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730137AbfJHIrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 04:47:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id w2so15895467qkf.2;
        Tue, 08 Oct 2019 01:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fEbtEhAEfJotxoHiDxf90K1SxeKU7aOyeAokgjoiW14=;
        b=s5BLKOYmB1f/bm8kTdDPkE/gZyquvlZ02+0aoYl3q+OPcs2IuhVXb0mSdTIVDq6W12
         olCHqvjWvAAYVhtVJfbIoP0r8SCz2qfI+68WaYPOv9fLRXxNLisolb9k4Ji7oHJUYhG4
         R5hszW8IY225CeRwCzlTiY6CWBo0Hkq65k4O/SCJmN+8m3wDIvcDiWJKgg201eV3K1qG
         5fCsEKRlKF5Rj2aXt/uTZaG2ESkZOKiw26UP1ix7TRw+raJOpkPnNmdfHFb9RqAXOTUc
         XaucCVIgwOIagHVpk3b7y69frjmh+GqVXSo1Cc8fcVikQ+WiPR/1FNlfGYXn9uQ/mmWX
         mC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fEbtEhAEfJotxoHiDxf90K1SxeKU7aOyeAokgjoiW14=;
        b=nIGre+Jr6WkfxIi9OTQ9bPyfL4fsuPvrfd/LQSKaImNkA+O51DuOF57VfNAHfJbPCd
         vvwKrsIyCEw+xBVee3Xb2CGpatXnwwrADTSXsUJDPbyA1Es21vzhaN9dN1gD2rr7S2AO
         VywCXswoWSpQ7rBz44L89iO2UhbAqnU+/zufBxeQP1WUvIxWJavfGQgHVRR/zrX3Cwz5
         ZTLToF4MN74Kq3FElyDfEwZZhxlELHMcOma/vwYaSXceuWYT5Kfpi4puV3Chhnzy7uk1
         u2ZQtgAZr+mmh+pJBs887W/l4pE1KFa4XosTQS1eppJ2vusbbhmuR6lCWXKHMT5j9Cls
         ltqA==
X-Gm-Message-State: APjAAAVLzlOjNWhUAAfNJ+K9IHFv9M65OHV9nTs+eOfVCR87i1CvYS1k
        kAbje6aQdRTJ1Pr63OrxSXBuQZ8WA/OGMgCVUUc=
X-Google-Smtp-Source: APXvYqwawXCJKLXg09yH8++kGFLLLYB7xi/bDdB/hwSiA6kDwvZgIRzAoTS3Z0oVwpLhjbhbGRJ0bcDP213gNnX+prU=
X-Received: by 2002:a37:4b02:: with SMTP id y2mr27772546qka.493.1570524440934;
 Tue, 08 Oct 2019 01:47:20 -0700 (PDT)
MIME-Version: 1.0
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com> <875zkzn2pj.fsf@toke.dk>
In-Reply-To: <875zkzn2pj.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 8 Oct 2019 10:47:09 +0200
Message-ID: <CAJ+HfNhcvRP34L3px6ipAsCiZdvLXG02brecwB=T-sXMaT5yRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive packets
 directly from a queue
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 at 08:59, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> Sridhar Samudrala <sridhar.samudrala@intel.com> writes:
>
> >  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> >                   struct bpf_prog *xdp_prog)
> >  {
> >       struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info)=
;
> >       struct bpf_map *map =3D READ_ONCE(ri->map);
> > +     struct xdp_sock *xsk;
> > +
> > +     xsk =3D xdp_get_direct_xsk(ri);
> > +     if (xsk)
> > +             return xsk_rcv(xsk, xdp);
>
> This is a new branch and a read barrier in the XDP_REDIRECT fast path.
> What's the performance impact of that for non-XSK redirect?
>

The dependent-read-barrier in READ_ONCE? Another branch -- leave that
to the branch-predictor already! ;-) No, you're right, performance
impact here is interesting. I guess the same static_branch could be
used here as well...


> -Toke
>
