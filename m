Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F2C414032
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 05:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhIVDyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 23:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhIVDyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 23:54:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E50C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 20:53:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h3-20020a17090a580300b0019ce70f8243so3533442pji.4
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 20:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b9rma2+WCiDAaibv4zCFjnrkJeQWoLIuMHHc45sp3Mg=;
        b=MJybSiaH8BUgjKYS9r/ilfDIAVb9ibSuzp/LRybzf0eii6cH6OjNc6oclSh+aNdnfi
         LC29VAMF9IGfZMm7vDldbbVe/zLtEeh4jzmZ/DRAQMDVK5VZojScdVzgz+a1/LeTCSMS
         H+qirLXzMm3ZiQRv18ANUFU0veUvMQn8JMKfHzqUMBV0wPCIkJg4Fzo8/wmcQ+O1kFrG
         hxOKHIIBUhpTVoP4uvWMVF4k0DPEir9pPDcztSsDGgNwWfXSs2TSeLqjz91lVJ7yTorS
         fg96DXimbH1/PQokKwqJd0xAq7+95QHu3EOz9+0l3HSa72YD+ygvfPafytmz7w34YgBI
         yvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b9rma2+WCiDAaibv4zCFjnrkJeQWoLIuMHHc45sp3Mg=;
        b=25FETIY/XrGAl7MfF5ml2w5DBwaIpdG/+f0pmIUamhs4kGV/0hYUoA0kZUp2yWtR9C
         DLwn4bMf4d5oNggvCNKfH2KQTJeIaye6gWOIXsp7+g3TWwMS31DeGhqYA1ycxIs6jKTg
         1EoQqoIcz9oirJCOgONVMkLCmsn0xZOsSpFvBXWvi9FtTBHgkeMRgRlqYJK68pvXBLt4
         +L7dKpPnma0Ng+41rCujPeRUyF8mhEFtOrjz2sW4mAd9sWUz2+H4us8XCyMSR3q8XtLW
         iS69XJR8g5p2OoWTTiazsAaCoQKGa7Bj3ErAmFgE+cx96jFxnemRO3PPydSpeou++7MG
         I9NQ==
X-Gm-Message-State: AOAM5311YPAGsXjjHHJHIMBj16U7hBEtRK31OPhIoyAMaY7/63bMwIxU
        8+07OAoqH1Ke+41KKQWxoRIHnJ9y8pmiEZzHW0Y=
X-Google-Smtp-Source: ABdhPJyiA0+3j2FliIFOQgcc7zdEitRgLDKalF5mNlmIe92u2phCOTDXmv1tRoZczJDAYpF4LOCKi5Ne9uJQrZ7Abds=
X-Received: by 2002:a17:903:32cd:b0:13d:9b0e:7897 with SMTP id
 i13-20020a17090332cd00b0013d9b0e7897mr19476821plr.30.1632282782567; Tue, 21
 Sep 2021 20:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <a1253d4c38990854e5369074e4cbc9cd2098c532.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpVvZY2QrQ83FzkmmEe_sG8B86i+w_0qwp6M9WaehEW+Zg@mail.gmail.com> <CADvbK_c_C+z6aaz0a+NFPRRZLhR-hMvFMXvaNyXpd84qzPFKUg@mail.gmail.com>
In-Reply-To: <CADvbK_c_C+z6aaz0a+NFPRRZLhR-hMvFMXvaNyXpd84qzPFKUg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 21 Sep 2021 20:52:51 -0700
Message-ID: <CAM_iQpU+CMLbDGyTQvo3=MwfbPghnb5C0tPLFmrhe_kaYzP6UA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: sched: also drop dst for the packets toward
 ingress in act_mirred
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 12:02 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Sep 21, 2021 at 2:34 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > Without dropping dst, the packets sent from local mirred/redirected
> > > to ingress will may still use the old dst. ip_rcv() will drop it as
> > > the old dst is for output and its .input is dst_discard.
> > >
> > > This patch is to fix by also dropping dst for those packets that are
> > > mirred or redirected to ingress in act_mirred.
> >
> > Similar question: what about redirecting from ingress to egress?
> We can do it IF there's any user case needing it.
> But for now, The problem I've met occurred in ip_rcv() for the user case.

I think input route is different from output route, so essentially we need
a reset when changing the direction, but I don't see any bugs so far,
except this one.

Thanks.
