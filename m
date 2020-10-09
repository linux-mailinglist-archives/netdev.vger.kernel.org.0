Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA0289914
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391381AbgJIUIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403957AbgJITvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 15:51:33 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2B4C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 12:51:33 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id k8so7745980pfk.2
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 12:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQP+p2o3bSg4p+m0Ed1H9TagX8PjA07znc4r4rz+S7g=;
        b=MX1nXM5eS+J7Qu1+AFPVFzYZ4ia4WgHQChNRDMDtRW/mx/n+7XCW3hgibozqJ8Ps+g
         pztA8Jlq3TsbBVhwZFAnN2hyIkefsQXMwEVzBSfGnk5X3HWimHJh2TxqvmbSZbnu+TA7
         fydyKi4hnkVlo8Egwm/87qTxpVaeGn7Dr9MFiHsp6FYHO7tOohD8fzvkNW/jEfb0FmNr
         8RljNlWWOEWSrpBJUQL1h/55ZijcQerL2yWQ13ifw31gWmusHshr74qcQ7cWf9X3OIRJ
         TTWkeeamgmf/bcrLM0JfjKKyalhxSNAjQot4vZR9oMNlpdzcaMzS4WBnjTyhX3zGeOIQ
         M6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQP+p2o3bSg4p+m0Ed1H9TagX8PjA07znc4r4rz+S7g=;
        b=baUCOgFABlDmr1oPictIaUbzgQtjDrnO48DlY0O57oBAca0piAmetmW8d1CIBi51QL
         XZd6NgVTBD3lduNBMX9cCqOTDsFi1Miyf/gT//VeTwwNpTGOU6Qi49ZTCcmdGe/8pM+5
         9ilX/VrO2pMHedoxMsGw3JG19oitX+nkKFwPRCg3ZRAKf5VKO4upQnY6Y89HzcvKyz6P
         vfspVgJRkgPDdGQsB0Z6VG1JGtWngivBITfP/5Zc6QCp1KiL+Cv9a7sgBIdPfUhZmuQe
         +plo/ua/NjoCdhTs+4QKqLWEJlGgLQCmoqEqCXwhE/1eNsxh4dwd3B3OU2CH4kXkwOwP
         NaYA==
X-Gm-Message-State: AOAM533tRoa/XGOJLBngDWguLL/Trb96qvFQ+sEvzCvaJGfJt8f4uWLS
        32tH7mKNWxYUBMWBVwExc/jM2zJM9BgvEKXE/x9lpcHHdUw=
X-Google-Smtp-Source: ABdhPJw6ZmZ0o+k/VkQcvq7fV9PTGuQjurqbxRs1/+xxsSXO50w8AFcvKMbbZajxKioyDrVabLNDNAy77GN+lyrxlwk=
X-Received: by 2002:a63:7347:: with SMTP id d7mr1893371pgn.63.1602273092665;
 Fri, 09 Oct 2020 12:51:32 -0700 (PDT)
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
 <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com> <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com>
In-Reply-To: <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Oct 2020 12:51:21 -0700
Message-ID: <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com>
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

On Fri, Oct 9, 2020 at 12:41 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> Thanks. But there is still something that I don't understand. What is
> needed_headroom used for? If we are requesting space for t->encap_hlen
> and t->tun_hlen in hard_header_len. Do we still need to use
> needed_headroom?

It seems to me that the original code includes t->encap_hlen,
t->tun_hlen, and the IP header length in needed_headroom. (Right?) If
we are including these in hard_header_len, we need to move them out of
needed_headroom.

> Also, if we update hard_header_len or needed_headroom in
> ipgre_link_update, would there be racing issues if they are updated
> while skbs are being sent?
>
> If these are indeed issues, it might not be easy to fix this driver.
> Willem, do you have any thoughts?
