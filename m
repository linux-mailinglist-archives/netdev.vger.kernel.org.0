Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F10C53F5CE
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 08:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbiFGGA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 02:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbiFGGA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 02:00:26 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931DFD6814;
        Mon,  6 Jun 2022 23:00:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d22so13938343plr.9;
        Mon, 06 Jun 2022 23:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=06YiQnCTLd5+IQB6eXqgaLf++LDjcMK7rR414je5dOY=;
        b=jWviNME3YsmPHQnUEFob9W3TsQfumpYy3G2hoT8Xwv+bPVLL0AShvAoofPWPEj27/9
         JAeEd/zyzotrim6XDv/yXxxBLWTs9//AgGOG/lRiRCKGNm4XpSMkAiMB7XQf3AayZ/AN
         jZq7wQTMz6cfyNsKRVe3/rlft4ePiH5RYVCHrPC6a6TUYd1Qm8xIVkPUMu8Hplvhct1r
         +orzG3sdIj7Ngtycmk2DUfbk6kBHVAkTsq/Iy8sz2aCJgLPrnThKP5Yku0nqs+DRsWIs
         HlVFJHex+z87DaXfZTqDbf9ov46Cnooq6G3R+jCdEjZ/0PZTYDifiZxSp+udkWALl0n6
         dHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=06YiQnCTLd5+IQB6eXqgaLf++LDjcMK7rR414je5dOY=;
        b=APvnTLqa15ynQivEOHImlBTIcZ56goKdbSLFjY2rcmL3d8BweTJglybwJw3U30gsGi
         o1kkTEnSISeeF8I5eJx50wC+Eskuyqo8i/0UoPF301nPND8b5RCaRAWdmwnOrqvc+XZw
         VYGAxcjOFTUdeTGC2rEwHIoGBOtByOCraNRzpE5HWDYtbfWt0xeiCcZKwcCW4fY3unKP
         cpYkFx+Cd2EBPyH2cSvnxBc36b4WulRSKLp5UbNbrk9npRzpN9SeYcfabWln1kvws3rt
         c1NXB5JhR2A1ua/S1r8WQAhavwZrrNJjtx94bZzXFyIBL7+IBCX1QnN9evCIuEFjGP4D
         kFyw==
X-Gm-Message-State: AOAM5311JsX5WEj/Fxfi/2wjY2pn23Aj7AI3dMYkbMfM+DyTS5NXXm4p
        bxLddd9DgWHlHpmd9BG/NTfW9nLHpBkZQDWam4o=
X-Google-Smtp-Source: ABdhPJy98K3dFZdWUpY1H5byGsN7XsxK98I40zUcgCabUgZi04SNg6kbDuJYCQH2TmvqTsb9yx5saMbPMAin0dx/mR4=
X-Received: by 2002:a17:902:7884:b0:167:4d5b:7a2f with SMTP id
 q4-20020a170902788400b001674d5b7a2fmr20240300pll.18.1654581624998; Mon, 06
 Jun 2022 23:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220605162537.1604762-1-yury.norov@gmail.com>
 <CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com>
 <CAHk-=wib4F=71sXhamdPzLEZ9S4Lw4Dv3N2jLxv6-i8fHfMeDQ@mail.gmail.com> <CAHk-=wicWxvuaL7GCj+1uEvpvpntdcB=AHot_h3j4wpenwyZ2Q@mail.gmail.com>
In-Reply-To: <CAHk-=wicWxvuaL7GCj+1uEvpvpntdcB=AHot_h3j4wpenwyZ2Q@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 6 Jun 2022 23:00:13 -0700
Message-ID: <CABBYNZJfqAU-o7f9HhLCgTmL46WfwNQbM5NsCACsVVDLACMLYw@mail.gmail.com>
Subject: Re: [PATCH] net/bluetooth: fix erroneous use of bitmap_from_u64()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Guo Ren <guoren@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-csky@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Sun, Jun 5, 2022 at 5:02 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Jun 5, 2022 at 11:51 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > *Most* of the accesses to those connection flags seem to be with
> > hci_dev_lock() held, and the ones that aren't can't possibly depend on
> > atomicity since those things are currently copied around with random
> > other "copy bitmaps" functions.
>
> I've committed that patch as commit e1cff7002b71 ("bluetooth: don't
> use bitmaps for random flag accesses").
>
> That basically ends up reverting
>
>   a9a347655d22 ("Bluetooth: MGMT: Add conditions for setting
> HCI_CONN_FLAG_REMOTE_WAKEUP")
>   6126ffabba6b ("Bluetooth: Introduce HCI_CONN_FLAG_DEVICE_PRIVACY device flag")
>
> which did horrible things, and would end up overwriting the end of the
> bitmap allocation on 32-bit architectures.
>
> Luiz, if the reason for the change to use a bitmap type was because of
> some atomicity concerns, then you can do that by
>
>  (a) change 'hci_conn_flags_t' to be an 'atomic_t' instead of a 'u8'
>
>  (b) change the regular accesses to it to use 'atomic_read/write()'
>
>  (c) change the "bitfield" operations to use 'atomic_or/andnot()'
>
> but honestly, when it used to mix atomic ops
> (set_bit/clear_bit/test_bit) with random non-atomic users
> (bitmap_from_u64(), bitmap_to_arr32() etc) it was never atomic to
> begin with.
>
> Regardless, trying to use bitmaps for this was absolutely not the
> right thing to ever do. It looks like gcc randomly started complaining
> when 'bitmap_from_u64()' was changed, but it was buggy before that
> too.

Right, thanks for fixing it. About some of the changes perhaps we
should use BIT when declaring values in enum hci_conn_flags?


-- 
Luiz Augusto von Dentz
