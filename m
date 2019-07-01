Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDA45B2D2
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 03:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfGAB55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 21:57:57 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45877 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfGAB54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 21:57:56 -0400
Received: by mail-yw1-f67.google.com with SMTP id m16so7687938ywh.12
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 18:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFR6j8SKCuDXXz6OZkYXiMr44/fm3ptL/43Z6dI06Vo=;
        b=qqBONOxnLloCecqJEnWRzyUkTpdPJoDzItToH3N//9Vjj9H3RtQdyB07NQ/LFHibEb
         Hc6G+P9UjtfJA3dh5VlF2mPC8hw9qSVFwwq9VXbBJupgyaX9oOvVNamwI7w/Amx5DWYg
         gYat/rOce5S74Q5IGzoZieY0G1tfSld3M/RSnzQQnDOPLcEBmzKIFBshVW6bAahSxEir
         GDc6+ZsK3YSTZIXi63qG9stN3CdWg4BR2zSOaYY03AAe08bGs/5o3xbvcQ90/BsSrLdQ
         iF4kOV8LwSHU4gEKfxVJKIkaGTXd+qwIbFWRiKmJy7Wv9tCg7K2v8Jqvd5pJyjTYTQP5
         Id3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFR6j8SKCuDXXz6OZkYXiMr44/fm3ptL/43Z6dI06Vo=;
        b=VuIL4TnsWKxqdll91m5Fbrnte0Jfmp8HzBzcG40qyQpPNkz8ALvNR29NIn3+yG9tNf
         MIRdi1xtLbPPRLuxZF8DjbLbxeM1sFgFY/XUis/uFYsVgo8p6iX61BwhX8Jmz+7CPdOo
         flJV1UPhTjnQnNFkJlbIcntenZAPXxy+AlwMGFOLBdBk/ZRcSsT8GinPTjL+wteOUg5N
         5DDN27+zcprXA/IcJ0vQlSdAerj4UNJzwCMpWxHnPYD66FoN0q8183xOK+UcT8RAxx+g
         e1dD8/RcD7fJPvYDD6LelVCGXQ/0oDYvl8d3kYHQWvmB/lLVsemi46vDNZISk9sAIzHv
         XheA==
X-Gm-Message-State: APjAAAU2FeWR76J4ytCTWNc/RgENUSoXjiYzdFFk7EFH+ei3nZokyy8C
        WzJQijQ2JdwuPpJco2BGR/wZIK5N
X-Google-Smtp-Source: APXvYqyMNLKpJn54smgA/+U7aWu+q8C4tda/MpQGa1q27C+lBbYHdJuAzXok/BPVwh0M6JVh2/wn8w==
X-Received: by 2002:a81:f011:: with SMTP id p17mr13332211ywm.89.1561946275420;
        Sun, 30 Jun 2019 18:57:55 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id y71sm2307578ywy.5.2019.06.30.18.57.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 18:57:54 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id j190so6865569ywb.0
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 18:57:54 -0700 (PDT)
X-Received: by 2002:a81:8357:: with SMTP id t84mr12748490ywf.109.1561946273869;
 Sun, 30 Jun 2019 18:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <e748ac8df5f8a3451540ad144a2c0afb962632f8.camel@domdv.de>
In-Reply-To: <e748ac8df5f8a3451540ad144a2c0afb962632f8.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 30 Jun 2019 21:57:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfih0pBbOnXxkw4UpmiqDnNLf4k8O-=7XW4m7fj5ogqXw@mail.gmail.com>
Message-ID: <CA+FuTSfih0pBbOnXxkw4UpmiqDnNLf4k8O-=7XW4m7fj5ogqXw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] macsec: remove superfluous function calls
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
>
> Remove superfluous skb_share_check() and skb_unshare().
> macsec_decrypt is only called by macsec_handle_frame which
> already does a skb_unshare().

There is a subtle difference. skb_unshare() acts on cloned skbs, not
shared skbs.

It creates a private copy of data if clones may access it
concurrently, which clearly is needed when modifying for decryption.

At rx_handler, I don't think a shared skb happen (unlike clones, e.g.,
from packet sockets). But it is peculiar that most, if not all,
rx_handlers seem to test for it. That have started with the bridge
device:

commit 7b995651e373d6424f81db23f2ec503306dfd7f0
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Oct 14 00:39:01 2007 -0700

    [BRIDGE]: Unshare skb upon entry

    Due to the special location of the bridging hook, it should never see a
    shared packet anyway (certainly not with any in-kernel code).  So it
    makes sense to unshare the skb there if necessary as that will greatly
    simplify the code below it (in particular, netfilter).

Anyway, remove the check only if certain.

>
> Signed-off-by: Andreas Steinmetz <ast@domdv.de>
>
> --- a/drivers/net/macsec.c      2019-06-30 22:02:54.906908179 +0200
> +++ b/drivers/net/macsec.c      2019-06-30 22:03:07.315785186 +0200
> @@ -939,9 +939,6 @@
>         u16 icv_len = secy->icv_len;
>
>         macsec_skb_cb(skb)->valid = false;
> -       skb = skb_share_check(skb, GFP_ATOMIC);
> -       if (!skb)
> -               return ERR_PTR(-ENOMEM);
>
>         ret = skb_cow_data(skb, 0, &trailer);
>         if (unlikely(ret < 0)) {
> @@ -973,11 +970,6 @@
>
>                 aead_request_set_crypt(req, sg, sg, len, iv);
>                 aead_request_set_ad(req, macsec_hdr_len(macsec_skb_cb(skb)->has_sci));
> -               skb = skb_unshare(skb, GFP_ATOMIC);
> -               if (!skb) {
> -                       aead_request_free(req);
> -                       return ERR_PTR(-ENOMEM);
> -               }
>         } else {
>                 /* integrity only: all headers + data authenticated */
>                 aead_request_set_crypt(req, sg, sg, icv_len, iv);
>
