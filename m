Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24E339649
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbfFGT6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:58:09 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:35852 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731269AbfFGT6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:58:09 -0400
Received: by mail-pg1-f169.google.com with SMTP id a3so1700416pgb.3
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 12:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWyeuCRufUS6eZsmUA6uA67/Ma2SThIZq5J+AXara/4=;
        b=Gy9PLl2p+FP25sFcEg7/EmmrEH+rGEKyFqBEXPLSil6kwETemL6EqBfYvLMeQHdmrS
         C0nPPHh8h7LTc3byWEO00KwIznV+wZRSu6kHd8F+4IZhu2NOygSztChQnoy1cjpPXo64
         TZsQHyxwgNnvuddvM2H5nPQ89F2TiypOicTCuluVEpVO5N9knG40GCsXHsOBBTq8+Fmz
         dDhL5gimN+iSBle6GJIXsbEFDaTCohdLlmaDTWo2lUjCVk25NcwiS2RjFbwKM3Nc6E4O
         CzACY6AY75c56lp90GMzaaXloptlVxZldIzETgoEfkI5B62XJlnYRZnFZGhfo/CFa34K
         qX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWyeuCRufUS6eZsmUA6uA67/Ma2SThIZq5J+AXara/4=;
        b=aHNB8FqYHQ+egezj+w7mo9YSA8CKHBS/IoYhUlAJIq5tyGHQkZ/2+0BBlCYcT8FLgC
         W0zTfbBrqH1QD3kVxAEkAM1Wk3B7t4qhgTEuJSzBgg+hovXxwksgMasJUFIA3IvItnk2
         7mNVDsx8OWYSqxAX5aTTPLr+tebtZk4mNjOmhnTHpfwrNoj4cmRVKJgMZK0geQdqVSbV
         WugegrtSN2KOzTytvZnOU9PO2llnU2SFd6MEmjIhJa57UFLVZpBlteBdgJOCcOFEezA0
         HwfOkQT1iboCztTpYwJMiaao4WBsZSV39CmY5vNiWo/sdIy/mBMoR0iKeEKjuoC9dAkk
         kycw==
X-Gm-Message-State: APjAAAVmZxsB88UzSw0wAREkKYjzmQAoWNWcH8I5bX9s4wB+lk+PMvDC
        4PQRX9mctGhBOolyDv7a/Y+UP/S12h72K9CdiPI=
X-Google-Smtp-Source: APXvYqw53mg4iifQm2wPbvTn+G3qVHFfsTQtHHajwi5f+ZRzm6ZW4BNdZ20+zstNY+JEztaYNGwkcv/5fBiqOdsMi2g=
X-Received: by 2002:a17:90a:de08:: with SMTP id m8mr7653961pjv.50.1559937488566;
 Fri, 07 Jun 2019 12:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190530083508.i52z5u25f2o7yigu@sesse.net> <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
 <20190605072712.avp3svw27smrq2qx@sesse.net> <CAM_iQpXWM35ySoigS=TdsXr8+3Ws4ZMspJCBVdWngggCBi362g@mail.gmail.com>
 <20190606073611.7n2w5n52pfh3jzks@sesse.net>
In-Reply-To: <20190606073611.7n2w5n52pfh3jzks@sesse.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 7 Jun 2019 12:57:57 -0700
Message-ID: <CAM_iQpVFq8TdnHSOsC7+6tK3KEoeyF1SFOQ-DheLW7Y=g77xxg@mail.gmail.com>
Subject: Re: EoGRE sends undersized frames without padding
To:     "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 12:36 AM Steinar H. Gunderson
<steinar+kernel@gunderson.no> wrote:
>
> On Wed, Jun 05, 2019 at 06:17:51PM -0700, Cong Wang wrote:
> > Hmm, sounds like openvswitch should pad the packets in this scenario,
> > like hardware switches padding those on real wires.
>
> Well, openvswitch say that they just throw packets around and assume they're
> valid... :-)

_If_ the hardware switch has to pad them (according to what you said),
why software switch doesn't?

>
> In any case, if you talk EoGRE to the vWLC directly, I doubt it accepts this,
> given that it doesn't accept it on the virtual NICs.
>
> >> Yes, but that's just Linux accepting something invalid, no? It doesn't mean
> >> it should be sending it out.
> > Well, we can always craft our own ill-formatted packets, right? :) Does
> > any standard say OS has to drop ethernet frames shorter than the
> > minimum?
>
> I believe you're fully allowed to accept them (although it might be
> technically difficult on physical media). But that doesn't mean everybody
> else has to accept them. :-)

Sure, Linux is already different with other OS'es, this also means Linux
doesn't have to reject them.

>
> >>> Some hardware switches pad for ETH_ZLEN when it goes through a real wire.
> >> All hardware switches should; it's a 802.1Q demand. (Some have traditionally
> >> been buggy in that they haven't added extra padding back when they strip the
> >> VLAN tag.)
> > If so, so is the software switch, that is openvswitch?
>
> What if the other end isn't a (virtual) switch, but a host?

Rather than arguing about this, please check what ethernet standard
says. It would be much easier to convince others with standard.

Depends on what standard says, we may need to pad on xmit path or on
forwarding path (switch), or rejecting shorter frames on receive path.

Thanks.
