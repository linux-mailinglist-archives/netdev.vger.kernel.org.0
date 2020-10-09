Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F282899D5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390459AbgJIUjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390305AbgJIUjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:39:06 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E5BC0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 13:39:05 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id p16so1984456ilq.5
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 13:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hAe9ETz06pxyDt6Pbp5ekqxqf61u/LFZY9bHsqTAeHM=;
        b=bZz0eTFlbwNTQ0zP6oP3XKO9Q69ylukVJD2ZgHRuvbDjp2E1MflkC4uT+4mExaCLcD
         yxu4XuBvFDqsbqhgfU8liPtv55FYjYS2cIMK4uThPL4NwcMi56zkAYPREg1dU1hEhyWm
         7FSVV4+kSNj4bZfdHhroNnQB594f0j6bUwlPwMR9k3TVnPbE2TkbNvgAxyz7c4GobzvN
         ul+E7bvVJjl/NwT96j3N3ycE0NCSzcLiMge0/CMWLmNwNGv1xJqIuBx7KrDf+m3Kq9Y/
         yl4tQ27fzyMiPdkYeF8r91A3sedd5jYuLZmgQeIsxQz+oqwDYDjtREQKgs/fbR4Cj9jD
         RiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hAe9ETz06pxyDt6Pbp5ekqxqf61u/LFZY9bHsqTAeHM=;
        b=EmgF0euxZAPlHtIecQ8RNfDTdCa4uQFjaRMwk0BC0XsRqCeDI2P4U19/EjIYsdt8F4
         TjXqYuPSh5o2tLvuyMigiugrQCB/k1f+xcpV+Wxv4f6kNZMXVibXWtF8RtXZQ5DGBn+6
         INloGzwn3bWVvfKn7O0W0RCMjX57aCunBsukTB7JGHxDGGHa/lpHWDs9fPWzORsF+Nfq
         T9wjjWBTXtGvZ5DPd4vtb3jd1p+cr4Y6s23PH9QgrRyJAJCjBeRyJDSmE/FJyRuMpLDh
         Ah+dJcOf4wQL2A7U4km3L1gE+mVMBK+j89kwQcZiO1g7Cw7UxupaIn7fO+KL4n8sLTUf
         TcCw==
X-Gm-Message-State: AOAM530/+v47aGAy8pHMVANWXOCFKjCb6f2br5Viryn4aivXc+DktVwC
        QfP9J7vfvripzypP4Rba9BzWwxDaMd9k5vECG3I=
X-Google-Smtp-Source: ABdhPJyuDTXYXxDnPIIJ98+H3bmNnm8khBa90M4qCm87WhQHpE/bdgr5AJLxiuNyBKxRE2peJO911JZM0yVBSMgAiIU=
X-Received: by 2002:a92:d28a:: with SMTP id p10mr11892403ilp.22.1602275944165;
 Fri, 09 Oct 2020 13:39:04 -0700 (PDT)
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
 <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com> <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com>
In-Reply-To: <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 9 Oct 2020 13:38:52 -0700
Message-ID: <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 12:51 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 12:41 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > Thanks. But there is still something that I don't understand. What is
> > needed_headroom used for? If we are requesting space for t->encap_hlen
> > and t->tun_hlen in hard_header_len. Do we still need to use
> > needed_headroom?
>
> It seems to me that the original code includes t->encap_hlen,
> t->tun_hlen, and the IP header length in needed_headroom. (Right?) If
> we are including these in hard_header_len, we need to move them out of
> needed_headroom.

Interesting point. I think needed_headroom is 0 until we call
ipgre_changelink(), but needed_headroom is already being used
in multiple places for skb_cow_head() in the same file, I guess
they should be replaced with hard_head_len because for GRE tunnel
those are its link-layer header. What makes it more complicated
is that header_ops is actually set conditionally, so should be
hard_header_len/needed_head_room accordingly.

Thanks.
