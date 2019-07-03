Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F325DB2A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfGCBvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:51:12 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42182 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGCBvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:51:12 -0400
Received: by mail-yw1-f65.google.com with SMTP id n127so378198ywd.9
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FpqwjPLz3qKsSQsne+q+/HAtmLYclnEssSjW53066EE=;
        b=AF/zf4dEuQSmx9zBo/xsY6LDdlP4XCcXCbTMC/A51Kt8ql5xWK7D2UQXSeujIaIgYm
         L/QLErod5DGg4P78V82bFliio/9q/nHTRcQ66mrDpzAYsxY2OQGL4ff4sOYeah8DYPsY
         DrTQg3ultxq9e+1aA4peuIxjVlD3khMIuBlB/UaaTPDWSWHy9YskCQtIik2rtHgX/1kW
         iwHf1rP7yFOP3X8ymMY0qaBGUWxEZEp0dmxy3dlBb6fL/Rlik29z2XyMQ8ySrprNMaS6
         Qg2S5sJiCCVjgUWu8+rVTdqtP0tATCF3jYfEHmSxs/P6ne4DTcqNr+CcV3TDhEqENBaW
         Q6kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FpqwjPLz3qKsSQsne+q+/HAtmLYclnEssSjW53066EE=;
        b=FIqIvcbYSSL9n1WtZMEKiMIjOGYZyx06C7PayO5/TrSkkt2iNjfBrCvH+nnWkGjPoc
         L1CsbzOjJXmtFEZ3hK7d1Ori33TygY0Fgjihi9Bra0kRRBfKOGX1uKniyalXBNEEz1lf
         cxV4dMbxqDnH61cSpeYbJyj864MGODVf9d2gfPp/htKeV8xc1v6eECYVj4kYFa9mtYsw
         XXkILACuta7452KoQ4njNbSfYExvaNu7vrm+GFqzdBOqWkxr1UWqYymFK8GtAdWkdNo9
         X+689O+iiYFI8WUVfpg2Yf1Yer5EYnJCmoVj8VXg2ZhA6CjLl5ecotkssYP9RI89HUyU
         5COQ==
X-Gm-Message-State: APjAAAVB6IoV5ZkWr5nOaBhopXgxYnoRiwnUrYPr+SsCuHuinQ1/zsi5
        rcsxjaQUsk3DKOgABVEAyF35UKuj
X-Google-Smtp-Source: APXvYqyQYfbiyvKuaimLQghVZr9KGhC3lXvPit/rA2O+PUOnhpw24Sm9E2FbHAYYLqGS3eIa22jnbA==
X-Received: by 2002:a81:170c:: with SMTP id 12mr6955073ywx.54.1562118670860;
        Tue, 02 Jul 2019 18:51:10 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id p185sm239172ywb.92.2019.07.02.18.51.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 18:51:10 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id q128so399949ywc.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:51:10 -0700 (PDT)
X-Received: by 2002:a0d:c0c4:: with SMTP id b187mr19229690ywd.389.1562118669661;
 Tue, 02 Jul 2019 18:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <e748ac8df5f8a3451540ad144a2c0afb962632f8.camel@domdv.de> <CA+FuTSfih0pBbOnXxkw4UpmiqDnNLf4k8O-=7XW4m7fj5ogqXw@mail.gmail.com>
In-Reply-To: <CA+FuTSfih0pBbOnXxkw4UpmiqDnNLf4k8O-=7XW4m7fj5ogqXw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jul 2019 21:50:33 -0400
X-Gmail-Original-Message-ID: <CA+FuTScf_wNwLdph=GY6f==tu_cM-BeVbAUgnMVuyubGB2-T=g@mail.gmail.com>
Message-ID: <CA+FuTScf_wNwLdph=GY6f==tu_cM-BeVbAUgnMVuyubGB2-T=g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] macsec: remove superfluous function calls
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Andreas Steinmetz <ast@domdv.de>,
        Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 9:57 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
> >
> > Remove superfluous skb_share_check() and skb_unshare().
> > macsec_decrypt is only called by macsec_handle_frame which
> > already does a skb_unshare().
>
> There is a subtle difference. skb_unshare() acts on cloned skbs, not
> shared skbs.
>
> It creates a private copy of data if clones may access it
> concurrently, which clearly is needed when modifying for decryption.
>
> At rx_handler, I don't think a shared skb happen (unlike clones, e.g.,
> from packet sockets). But it is peculiar that most, if not all,
> rx_handlers seem to test for it. That have started with the bridge
> device:
>
> commit 7b995651e373d6424f81db23f2ec503306dfd7f0
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Sun Oct 14 00:39:01 2007 -0700
>
>     [BRIDGE]: Unshare skb upon entry
>
>     Due to the special location of the bridging hook, it should never see a
>     shared packet anyway (certainly not with any in-kernel code).  So it
>     makes sense to unshare the skb there if necessary as that will greatly
>     simplify the code below it (in particular, netfilter).
>
> Anyway, remove the check only if certain.

Did you see this point? I notice the v2 without this mentioned. I
don't think you can remove an skb_share_check solely on the basis of a
previous skb_unshare. I agree that here a shared skb is unlikely, but
that is for a very different, less obvious, reason.




>
> >
> > Signed-off-by: Andreas Steinmetz <ast@domdv.de>
> >
> > --- a/drivers/net/macsec.c      2019-06-30 22:02:54.906908179 +0200
> > +++ b/drivers/net/macsec.c      2019-06-30 22:03:07.315785186 +0200
> > @@ -939,9 +939,6 @@
> >         u16 icv_len = secy->icv_len;
> >
> >         macsec_skb_cb(skb)->valid = false;
> > -       skb = skb_share_check(skb, GFP_ATOMIC);
> > -       if (!skb)
> > -               return ERR_PTR(-ENOMEM);
> >
> >         ret = skb_cow_data(skb, 0, &trailer);
> >         if (unlikely(ret < 0)) {
> > @@ -973,11 +970,6 @@
> >
> >                 aead_request_set_crypt(req, sg, sg, len, iv);
> >                 aead_request_set_ad(req, macsec_hdr_len(macsec_skb_cb(skb)->has_sci));
> > -               skb = skb_unshare(skb, GFP_ATOMIC);
> > -               if (!skb) {
> > -                       aead_request_free(req);
> > -                       return ERR_PTR(-ENOMEM);
> > -               }
> >         } else {
> >                 /* integrity only: all headers + data authenticated */
> >                 aead_request_set_crypt(req, sg, sg, icv_len, iv);
> >
