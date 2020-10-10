Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AFA28A391
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390230AbgJJW4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbgJJV7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 17:59:24 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88F7C0613D2
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 14:49:19 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 144so10010447pfb.4
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 14:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=st0s2kzUicjbj8R7EOC27K/dfyNUBDh27Z/gJXV3eFE=;
        b=i4YhDPS9+Mji198d+x6U1u+SVAKOrEoQqJrheGtHHDbqB2tP9gwMhopcV1+96I9rMq
         ndjvMpca0MLaupN/vjdNOQ5JcnG7Ml7XlEUAXW1fzWlhpzEkrTCqqiD+jb6KxP1BUBvK
         8Ref2yCAxSW7cqH7ekFS0ORivmr6WYT2NTOq0CX/SJ61cWpjDZLECt1lymrVT/u42iQg
         87fII+BE3dlsbZn8L7icvI6PAkYNjT4r3YKsLkOyk2Vfpj2lJcsH4OiC0NxrZmnfybCV
         YkApSCuTKWcR+stwTVzevZ+OuGVt9lLHoMMQYxS8xmQ+OUcohm9RQOP363TyGQCp54qt
         kgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=st0s2kzUicjbj8R7EOC27K/dfyNUBDh27Z/gJXV3eFE=;
        b=HE/XHF25rGZa5kH4owEG+zj67Ajkd8Cb4j1C1t7chgA/hEO4LqnXssSjHVEzSEp5OV
         WeKxnC8mPB2je+bQ2TLc0IrYLyWpc+ZtVZvtWD3Q6xuaZ8iu/lcxVJipOTt8PpYp1XKf
         d+edtqHqz4E6JO9xxdnIJp3njt6kmaqokverw3iRkuhZXFMLrS2cWWvAfXaIUD0qLwum
         x3juAEG7ov/J6g08Gkp7jUxvH33UVc9rIH5Xb05bB8979mzGOJF3vB7Ckp+XuTo5Hb7y
         k6k73JRnz3+LX8RxlJPNlCm1hbKq80gnMKfhPdQINSD/+GyxO4aXCSkGjefigkJMbWKJ
         AjSA==
X-Gm-Message-State: AOAM530bYgPA1t6QLF4ycXRo+x+h7RUt/NehufOsqDPjixg/8ynGjMAT
        Qqya2VONLgETpTnmxJglvxeMheEjRVPMmjuCXKs=
X-Google-Smtp-Source: ABdhPJwRBZi6ge/S8ckiMDKMlvBoL+BMVno3Ds6vn3OXlMTv+FhAadFwvANiWfj3P/7AgpOk50RPLYc+x+5/uyW/EXI=
X-Received: by 2002:a17:90a:bf92:: with SMTP id d18mr11810763pjs.210.1602366558204;
 Sat, 10 Oct 2020 14:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
 <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
 <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
 <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
 <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com>
 <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com>
 <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com>
 <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com>
 <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com>
 <CAM_iQpVhrFZ4DWg9btEpS9+s0QX-b=eSkJJWzPr_KUV-TEkrQw@mail.gmail.com>
 <CAJht_EO99yYQeUPUFR-qvWwrpZQfXToUu6x7LBS+0yhqiYg_XQ@mail.gmail.com> <CAM_iQpX0zjZUDE_iuf4WWXiodwb2UpqyjjQPYrfD0CMXnMSymQ@mail.gmail.com>
In-Reply-To: <CAM_iQpX0zjZUDE_iuf4WWXiodwb2UpqyjjQPYrfD0CMXnMSymQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 10 Oct 2020 14:49:07 -0700
Message-ID: <CAJht_EPQ8OXUeRxn7Q2AU9NsEuFB14Vs8Q0xBs-j9ka36RUVWQ@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 11:58 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 8:10 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > This seems so weird to me. If a user is using an AF_PACKET/RAW socket,
> > the user is supposed to do what the header_ops->create function does
> > (that is, creating two headers and leaving two holes to be filled in
> > later). I think no user would actually do that. That is so weird.
>
> Well, AF_PACKET RAW socket is supposed to construct L2 headers
> from the user buffer, and for a tunnel device these headers are indeed its
> L2. If users do not want to do this, they can switch to DGRAM anyway.
>
> I know how inconvenient it is to construct a GRE tunnel header, I guess
> this is why all other tunnel devices do not provide a header_ops::create.
> GRE tunnel is not a special case, this is why I agree on removing its
> ->create() although it does look like all tunnel devices should let users
> construct headers by definition of RAW.
>
> Of course, it may be too late to change this behavior even if we really
> want, users may already assume there is always no tunnel header needed
> to construct.

Another reason why tunnel devices usually don't provide
header_ops->create might be to keep consistency with TAP devices. TAP
devices are just like tunnel (TUN) devices except that they use an
additional Ethernet header after the tunnel headers. I guess that TAP
devices would usually use Ethernet's header_ops to expose only the
Ethernet header to the user, but hide the outer tunnel headers from
the user and let them be constructed on the transmission path (so that
TAP devices would appear exactly like Ethernet devices). If we want to
keep TUN devices consistent with TAP devices, we should hide the
tunnel headers from the user for TUN devices, too.

Actually, a lot of devices expose a fake L2 header in header_ops,
instead of their real L2 header anyway. Wi-Fi devices usually pretend
to be Ethernet devices and expose an Ethernet header in header_ops. So
I think it is acceptable to not expose the real L2 header in
header_ops. (This is also what needed_headroom is created for - to
request additional header space for headers not exposed in
header_ops.)
