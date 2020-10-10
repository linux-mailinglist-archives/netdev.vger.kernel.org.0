Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724A3289D15
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgJJBbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgJJBH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 21:07:57 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26017C0613D8
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 18:07:56 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 67so12179506iob.8
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 18:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rc8tqnECubGYldyyTKxBoVCaW5BiCQxv2CE/ih4Dug8=;
        b=XNwNGF/O0mf0yaNe+/odMJ/ZDbaXCOnDD1I3+IGErlLggP5O3bZ0Xhv8oHusUo35Lz
         BERLKhfnhh3b6NNxc53HUs3ALBSvWHHrtUnS/EjzZ33BEZOQFvPh+B4yQJebagIkbjEV
         c9wiJ19XbsbA8CWwvwdApvboaONb4EvUQ102CNSZ37sKECkMjNmzLXTY7yl1srLzq8j7
         H0xudbqQbotKWSNxYLSz4M8rbyFX9jgWC7OT3ViJyZh6nBC/K7pFDBsTudnNczTe01Bo
         JLxzuB9axILZqnrx41gORACgq0W8XTA1K9a3f1ubzwMeHryA//tGoQg0zRPbgNJaCDUB
         b8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rc8tqnECubGYldyyTKxBoVCaW5BiCQxv2CE/ih4Dug8=;
        b=mgkL5qVL8ztnzMgPsd0hSV48bZezwp4+5QS0irdGlLpjE/flK0DiUMorSiy1Nlu2SA
         fSnOhB59VB7CbfSwQBrdu5nvsAlfJTRm0yR2IF23vnW80uX9yF4dAgiMWmKZ3Xl1D/mO
         KIEemZwznXzra6whNSKklv83TiZE2e7mUYuvhxvYVHIhiAZPGLjrIMySff66Ny7AakTY
         /apL/nDVODVLaVQfsLPMnyYF7Vk11naFdOng67qma5VvXAa2zm2jI82EWL8M873C+N79
         pa9hTGCAehVjJ25l05H01r1ZWhSDOhOthgJxJGrRshTZwOfon2fCRAttiuxWeLB4uw0w
         goqw==
X-Gm-Message-State: AOAM531ftF+u+hu8cr6SV9SJaopV6rI83WxGqFbE6wN/pidIr5tjmz3O
        SjIMO531RyfEfuEXunUYwEBbyBreUwM7lai0ohI=
X-Google-Smtp-Source: ABdhPJygJU6/EaDK30C2+AjEgMXLMfzOpwkzpVdMzIESY9dkjaiXxO7uWJgcGe50Tw5wOuFB++dRkWETxVs/jYsX+c8=
X-Received: by 2002:a6b:b446:: with SMTP id d67mr6901470iof.134.1602292075231;
 Fri, 09 Oct 2020 18:07:55 -0700 (PDT)
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
 <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com> <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com>
In-Reply-To: <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 9 Oct 2020 18:07:43 -0700
Message-ID: <CAM_iQpVhrFZ4DWg9btEpS9+s0QX-b=eSkJJWzPr_KUV-TEkrQw@mail.gmail.com>
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

On Fri, Oct 9, 2020 at 1:38 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Interesting point. I think needed_headroom is 0 until we call
> ipgre_changelink(), but needed_headroom is already being used
> in multiple places for skb_cow_head() in the same file, I guess
> they should be replaced with hard_head_len because for GRE tunnel
> those are its link-layer header. What makes it more complicated
> is that header_ops is actually set conditionally, so should be
> hard_header_len/needed_head_room accordingly.

Looking a bit deeper, I doubt the ipgre_header_ops->create is necessary,
because 1) all other tunnels devices do not have it (ip_tunnel_header_ops
only contains ->parse_protocol); 2) GRE headers are pushed in xmit
anyway, so at least SOCK_DGRAM does not need it; 3) ipgre_header()
creates the GRE header, later ipgre_xmit() pulls it back, then __gre_xmit()
builds GRE header again...

Please correct me if I am wrong.

Thanks.
