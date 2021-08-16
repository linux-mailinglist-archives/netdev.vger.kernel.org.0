Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F5E3ED11B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 11:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhHPJgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 05:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhHPJgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 05:36:49 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C985FC061764;
        Mon, 16 Aug 2021 02:36:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w5so30581280ejq.2;
        Mon, 16 Aug 2021 02:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E2Rvzjvi6R+oFoAZuUoPNfaxp02MAp+SZJiXPUDEsDI=;
        b=c10cuBx2vzf3cr0FQqrQ02VGeaBexcvxqOrGzWxJPMM8o0eBgAloczf4dIEY1Ojfdv
         +HpN7CAEL1Fo7EzR30sAXx6gGZP0jMb2fNxqo3h5w4aRZD0MLgsEz3booOIp92MDAhhK
         TbbjfXCPl8GcTydbqDvOziIA590IYTL+l9+Kb7k5iMZh2sddHa78OWL76AcWxqt7oKRg
         27uwkYZNUvgkd4GYTthCvfPIxgEumOzIs3kQCISAIQxz5x0mVJb99Ywuk1dS+eIY/vAG
         KGYqfoEIfE27CYeWhLc0hxsUAwHdL9cl8v+zAVn4M4ComQORiER6qWrKdCWvZ3abn5sX
         k+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E2Rvzjvi6R+oFoAZuUoPNfaxp02MAp+SZJiXPUDEsDI=;
        b=uQN4fxY8h6uZSL73tiZijMgtNxF7/Xwa+XSAc4het/ac+R7/9z7rrga66NdBxMipb1
         2LIjyq2c7DqNe7kHDyhbVYZzQ8TPXV+PoejvJn/eZc8YV9pyCK45eMpK/eNmBKjNjsfA
         XcQnv4CBc935Kg2ClggONezOfM+iuJtnRZ0fWSxDq2gmBWd9OSivTQzEPDqWhZwdUWID
         iPTLk/c9ldc/ZAcs4MGx9ZoDh7BN6O1fjn4IEv07Eo/6wvz2yNJk/PfHlUWqnwBCPZ6I
         J9fQPIvcFuiWo0zskzFjh+bkcIdbuVie4xZmMHllWhiJOnRZYI5VwWE6xjZVBY2dFxtW
         8j4g==
X-Gm-Message-State: AOAM5338V3HlwlQleeZenJ29oCbBAwHGy0uR8GwxntxW9fGW/I8McYic
        YwkPN/XPGVbWkUtFsNQlBsQ9gPV56fxJ3YcmkQY=
X-Google-Smtp-Source: ABdhPJx5XOhfmT8pxOOmwMbabIR1y9n8lrBw4tbNRP6h/8vEDRDuuPV/mNT6hK0pDb1jCKi1+Y4PL60CA7ZNe+YrAUA=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr14950797ejc.160.1629106576420;
 Mon, 16 Aug 2021 02:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210816073832.199701-1-mudongliangabcd@gmail.com> <20210816075346.GA10906@gondor.apana.org.au>
In-Reply-To: <20210816075346.GA10906@gondor.apana.org.au>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 16 Aug 2021 17:35:49 +0800
Message-ID: <CAD-N9QXGZ1UrEpv7uZSJGuoM434kVbphOVQ79T45RQYYUg=jGg@mail.gmail.com>
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

Yes, you're right. Let me double-check the code and find out where the
problem is.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
