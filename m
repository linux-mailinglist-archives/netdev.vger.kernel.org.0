Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F051C2991
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 06:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgECEYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 00:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgECEYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 00:24:12 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C34C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 21:24:12 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id t3so2151273otp.3
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 21:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mif5fpoVTE803zhOIG7KijChbP05Nv/41pjjBrEXjb8=;
        b=XAJWG93w+TV6dHeT+2otMsMY4+D1/0K+To9GgA0U7lMkFrhzRo0e78Zy0wpSorfLxe
         lSgxeuiYDuO7X20TaeyO5MZiOltrV/kIjsn+1ZqX6dlD0qUe52mA5538Ky7xHRQbI1KI
         FVPuvMf2EQJ9/huIs0hVwXfBZ6bohxEnHvRiV0M4SY7FmUNaZZTMhZtLVgEutDWe71hO
         Pd44/tPrfiGEUwBWqYvz9r7vdY6yGeU6DAssCDUCtrZW50oS55vXeSIyPm4TOp8pqEFx
         YrZPH+LycfLS36i3x3rXhsKiBZxVevJl8ZJ1QV97jCz3oLWasFlr/LiOqDe37a/d/I05
         mQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mif5fpoVTE803zhOIG7KijChbP05Nv/41pjjBrEXjb8=;
        b=J2yvZKVz7GKxs9IAL91Fhtt0XdyIVqONmbtcnLDeTs4mb4PrQAU88KN5fP/kUK0cri
         rynEWW9jKA3tPigxkkX93xCfzY7VqQrM75ZFQAcLgv5CkEd3X0E3JSM8Oto+0a6Kpyro
         dl6w/nl3nYJ7O5/PloK4is45FVbrZmSkBNiknu/wTRDE2Ul+tmp6wtYRGs1fmBc9DyVB
         G1Q5FEXgcjm6QyV0mTxIfH2dd5aBXy9Ewv2G3shY6c29U4gtfHM5ORSRTcLnCQb7y0Q2
         UIFQruYLfUH1IuVSvr50b/MgMsI+yoLgYmfloVXVRF5CMtxDWgWy/jz6nE9E6HuTCiK9
         GyLg==
X-Gm-Message-State: AGi0PuZScd1cnYoDYELFjNDPkFZROBnz15VBeDZ+0pNdcs4X+HJagOE1
        itndBqx5wrKyoQ3nQIK/W9+79OGXV79/UCSli5k=
X-Google-Smtp-Source: APiQypI1VAYjuKj6zq1/SKN4md79Iplvr29z58zimgchDJxTZoXhwMs42H8me7JTqggF2PQsyARerIZI9RXSNzLw//Q=
X-Received: by 2002:a9d:4a1:: with SMTP id 30mr9303168otm.319.1588479851640;
 Sat, 02 May 2020 21:24:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200428060206.21814-1-xiyou.wangcong@gmail.com>
 <20200428060206.21814-2-xiyou.wangcong@gmail.com> <CAMArcTU2r2undM5119_1W=pc2fu5AtUDp2RtizjVayRY=fGVEg@mail.gmail.com>
 <CAM_iQpWdf+K7n+YfZv-+_Cz5b9+kxXV0F0PfYuUyHJ574OEGsA@mail.gmail.com> <CAMArcTVei4AF7TdUEawZbJZKpf6ABAu7UwL+5iP9jVQsxqOWSQ@mail.gmail.com>
In-Reply-To: <CAMArcTVei4AF7TdUEawZbJZKpf6ABAu7UwL+5iP9jVQsxqOWSQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 2 May 2020 21:24:00 -0700
Message-ID: <CAM_iQpUK2r7+tO4XfRKuZ4DbAKX9j8v+ve8e36uqcftG5Vp4fw@mail.gmail.com>
Subject: Re: [Patch net-next 1/2] net: partially revert dynamic lockdep key changes
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 2, 2020 at 12:36 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Fri, 1 May 2020 at 15:02, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
>
> Hi Cong,
>
> > On Thu, Apr 30, 2020 at 12:40 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > > +static void vlan_dev_set_lockdep_one(struct net_device *dev,
> > > > +                                    struct netdev_queue *txq,
> > > > +                                    void *_subclass)
> > > > +{
> > > > +       lockdep_set_class_and_subclass(&txq->_xmit_lock,
> > > > +                                      &vlan_netdev_xmit_lock_key,
> > > > +                                      *(int *)_subclass);
> > >
> > > I think lockdep_set_class() is enough.
> > > How do you think about it?
> >
> > Good catch. I overlooked this one. Is lockdep_set_class() safe
> > for vlan stacked on vlan?
> >
>
> I think this is safe because of the LLTX flag.
> Also, I tested nested VLAN interfaces with lockdep_set_class().
> I didn't see any lockdep warning.

Great! I will update and send v2.

Thanks.
