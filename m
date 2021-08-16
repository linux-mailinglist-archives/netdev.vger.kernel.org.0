Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFCE3ED326
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhHPLhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 07:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhHPLhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 07:37:06 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E243C061764;
        Mon, 16 Aug 2021 04:36:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id d11so31160330eja.8;
        Mon, 16 Aug 2021 04:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VzNlum+DSRQasFc6iJsqTAHfGRqIbtECs/5GE9/2M24=;
        b=D9FZU7bCfxstwmg1IwQvB+ltXSZM37ASypF9qRxJd5tPLZ0TXCHD0LPEdbQAnxNYiP
         6LxBXw+oTeAfMCSdBsBRsk59ZjuxCYONNDnLGFynbBwxB7nHzHqQzS70pck0osw6Capu
         V0op9grEOW3v4dVdEjUunlgmUguhkRVOgHh18a5kHLSt0/4o4zWbX7AkZnUzeB/JP4F1
         cpSZUukjN/BLQTjEDwEgP4Ayx8G4dRHVx3oTaR8gKCRhCuq2ILPLuGGwxgpL5sfjVIkk
         +2mO60nTluhIuUbh3/w/7K6QyWwnJKQ1j/5YGUKfdkZwXkf4uBiIbunZKOhZsg8+DWM0
         rVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VzNlum+DSRQasFc6iJsqTAHfGRqIbtECs/5GE9/2M24=;
        b=gjEeBUK4jmHmjuW+ecQqtaEDEs+2gNNVD8hdC5UYYlfba/2/m4BJEmcnOZDe2sxwdT
         73MytLh9cX/Ko4uk+lXnOPGYdNZrEB/g6a+0K7up58jA8XHqKor8gpcpNqzJ127eIoHh
         uaxvF10r0u/OF5Cr1auDJJ0MB6GPrLRCSqZIVh1ziukWR92hoZHfQMuhkyAh/B8YREvs
         y5OnqKlyLcQnRGmZzGKy3CoADlLTDkKysl6jza/4tg+HZVediaYahwuSPL9Hi8uU4lC+
         FtM9wDd4E6WlFsEAVcXELIG9eiyvLxvIdTV2Xy/OyQoCQHNFp6FCsmqDQxg08gxQnn6R
         Y72A==
X-Gm-Message-State: AOAM530ch19K0Typ0fmnfqmd8G7nTxqLvxd1m+5DCbGcAgCPcMpylBct
        x+a0BEg/2hZPpNsXhKukR6hbmfkrlsyOLrUe6Qzv6oQ0+2tG4rS3
X-Google-Smtp-Source: ABdhPJycUVUTWsimWAN1jnk4SNTHhC0Ilmg56FLbekv1lC0i8ZX/z7lqzStoBV7RLX1VYjqF33milOiInanqSKNa+xo=
X-Received: by 2002:a17:906:8310:: with SMTP id j16mr14322832ejx.135.1629113793086;
 Mon, 16 Aug 2021 04:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210816073832.199701-1-mudongliangabcd@gmail.com> <20210816075346.GA10906@gondor.apana.org.au>
In-Reply-To: <20210816075346.GA10906@gondor.apana.org.au>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 16 Aug 2021 19:36:07 +0800
Message-ID: <CAD-N9QWwmRuPOKZ2BX8ACde4K2GNFUsAWzcciKVG9BwLPcM2-A@mail.gmail.com>
Subject: Re: [PATCH] net: xfrm: fix bug in ipcomp_free_scratches
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com,
        stable@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 3:53 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 16, 2021 at 03:38:29PM +0800, Dongliang Mu wrote:
> >
> > -     for_each_possible_cpu(i)
> > -             vfree(*per_cpu_ptr(scratches, i));
> > +     for_each_possible_cpu(i) {
> > +             void *scratch = *per_cpu_ptr(scratches, i);
> > +             if (!scratch)
> > +                     vfree(scratch);
> > +     }
>
> This patch is unnecessary.  Please check the implementation of
> vfree, it already checks for NULL pointers just like most of our
> free primitives.

Hi Herbert,

since there is no reproducer in the syzbot, I guess the problem might be:

if vmalloc_node in the ipcomp_alloc_scratches returns a NULL pointer,
it directly returns NULL without updating the per_cpu_ptr(scratches,
i).

Therefore, in the ipcomp_free_scratches, vfree will take an invalid
and outdated per_cpu_ptr as its argument, leading to the bug - BUG:
unable to handle kernel paging request in ipcomp_free_scratches.

Any idea?

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
