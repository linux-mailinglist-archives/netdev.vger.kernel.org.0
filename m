Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C887C287F39
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 01:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgJHXks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 19:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbgJHXks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 19:40:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAFEC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 16:40:48 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y14so5271848pfp.13
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 16:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Udjn1bvkZ4meZbMXj7IPyV+N7NltxAtY/GaXzekbmYw=;
        b=MdEQ8wHYUW6g0sHwmFgeY6CfVeTPhc47FBHmDJRvscDz1i4UmgbMOGd63Cf4VHJabQ
         1BW0YGbLW2rsjwadXiAaBlXROR/azoYKS7T/2ZXGk/NZP3Ls3CuIGK4OxTl2RP0CZiXD
         oDCp0ODrB8h0sgmLirw40DkW3wl6Dcsflv5odUjZO1aD1QVdQxMB01pYryn9bJVKnYcW
         O9I3U3yf+5Rn7BWscc/pHR95AVK8Zn2o02S47iacdHKL6g2LCEOLC5qu68e7wiUkWRgD
         JzcciVRPA/XA64dsSmDQt7bPtjQDEMlIDv4x3MWTe9YKYFI9EuIZ8gVLVSHnBCS4Rp4y
         HHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Udjn1bvkZ4meZbMXj7IPyV+N7NltxAtY/GaXzekbmYw=;
        b=CTtCfWN6pRU2XI2QZTq95Fq4OHxPiOZqasb10aIeCo1b661l66A9/TdZdc7yifJmmo
         7TujEV8ejVaguwr60YHn1C/9T73piucl0Nkvocsc2tE6NOG0D7J2pLzie7NV3kVOMdWM
         cUlFKsBAHOIW9oVcmcfEWgSw3g3rDoHaNAMJKgnk5MEBpRd7Zof9nIsvbZTdvUoDLZRB
         Oas28UVcZQY4XVx3DMowusxmV3YxCXGj02O8QljuoDAR4ldJX9YI6/F3fDWPZPL6u3v1
         eDC2cb9hmovTBqAs8ra9wKljTbpohXuB2NIiP3b4Q+30AIaVD5CwYUUWMDI88QnNrkzF
         UlKg==
X-Gm-Message-State: AOAM533UtWlxw8G7UeXstVc4aq8ioz+Bw2NszYEZINofrIYDrsZUvU4L
        xIQCmql4bZ8dJ6jYsD9v9xjBSfIXDcrFgwN5G9Y=
X-Google-Smtp-Source: ABdhPJyVaj90e3JRini8mZtD+iFti3Pxz9kLoveteQbzFyRVvh1qxL37C6tbslh7aP2mf9tpVL8tWECwdKM2SWrqY60=
X-Received: by 2002:a17:90a:aa91:: with SMTP id l17mr1370226pjq.198.1602200447705;
 Thu, 08 Oct 2020 16:40:47 -0700 (PDT)
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
 <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com> <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
In-Reply-To: <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 8 Oct 2020 16:40:36 -0700
Message-ID: <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 2:54 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> OK. If the t->encap_hlen header needs to be placed before the GRE
> header, then I think the ipgre_header function should leave some space
> before the GRE header to place the t->encap_hlen header, rather than
> leaving space after the GRE header.

I found another possible issue. Shouldn't we update hard_header_len
every time t->tun_hlen and t->hlen are updated in ipgre_link_update?
