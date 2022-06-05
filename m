Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5220153DF04
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 01:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348701AbiFEX5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 19:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351832AbiFEX5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 19:57:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8CB49F13
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 16:56:57 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h19so16754672edj.0
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 16:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRX+dAaHFYHOMUkkn7e8l97Dwcch2sYAXae8M4f8XjE=;
        b=B+w0Y6o1NT9jGOE9kjSjrSBAJ9eA6U+dI1XGTGNKFUSIW1CGxv58Uvz8TroRpXFL1I
         jOVUYOxXT6wmSLmfjsCY84xZJczlEuYLR0s8LaRgKZd9k2S+h1lWW2reAZZdqlSLPNu4
         ZeJUTW8DlEBxbtUxbl/awnYiB+zDYOwZ9VUro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRX+dAaHFYHOMUkkn7e8l97Dwcch2sYAXae8M4f8XjE=;
        b=tu6Qv4JacG8n6zNYzVP4qPC8kE+EjGyzzHoy01Qr2GRwSgibR3nj3FZeGAezkZG+jk
         oSX/Cemavj2seU+NhvZhI9iev0MbOafMRTJUxL9T7Ku4jqrMPz75GSVMDq7XoFsbsVd/
         xNluuBmIsl5HXHokESJnLjHVtHoOLHWspByjKSX+1V1GGDt1bjbLpCcSi2nVsIhdwmdZ
         dbAvHbAV9LRhOSalifnLw/8WS8mg2CbIuzDn6ltguvQDL9qZLGTtmQu3vKBrGpPSiRuj
         v5QpdQGyytfzMf78eZ9LtFDHp1FIVXnM2F4OcAtYHGNM40o8g2AA3vScxpCNaSxnqkkU
         kEQw==
X-Gm-Message-State: AOAM530ew1iNxljoxHkq/KvW2cA2scs1bgBc0i582Yb0VmOAD20LMo7I
        s4G4aUTsR+xJWS/xZlFLq5y7uuAuYxpvPrw5AYg=
X-Google-Smtp-Source: ABdhPJy9dgIk+X1zl882ssH6NjBTsWeMmujemDWpkhx6PRusE5XCcIQ75dDXNg16PCrpDTeEdRgvSg==
X-Received: by 2002:a50:fc0d:0:b0:42d:c1ae:28bc with SMTP id i13-20020a50fc0d000000b0042dc1ae28bcmr24146238edr.24.1654473415445;
        Sun, 05 Jun 2022 16:56:55 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id p4-20020a170906784400b00702d8b43df3sm5600385ejm.167.2022.06.05.16.56.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jun 2022 16:56:53 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id q7so17735589wrg.5
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 16:56:53 -0700 (PDT)
X-Received: by 2002:a05:6000:1b0f:b0:210:313a:ef2a with SMTP id
 f15-20020a0560001b0f00b00210313aef2amr18555328wrz.281.1654473412987; Sun, 05
 Jun 2022 16:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220605162537.1604762-1-yury.norov@gmail.com>
 <CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com> <CAHk-=wib4F=71sXhamdPzLEZ9S4Lw4Dv3N2jLxv6-i8fHfMeDQ@mail.gmail.com>
In-Reply-To: <CAHk-=wib4F=71sXhamdPzLEZ9S4Lw4Dv3N2jLxv6-i8fHfMeDQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 5 Jun 2022 16:56:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wicWxvuaL7GCj+1uEvpvpntdcB=AHot_h3j4wpenwyZ2Q@mail.gmail.com>
Message-ID: <CAHk-=wicWxvuaL7GCj+1uEvpvpntdcB=AHot_h3j4wpenwyZ2Q@mail.gmail.com>
Subject: Re: [PATCH] net/bluetooth: fix erroneous use of bitmap_from_u64()
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
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
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 5, 2022 at 11:51 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> *Most* of the accesses to those connection flags seem to be with
> hci_dev_lock() held, and the ones that aren't can't possibly depend on
> atomicity since those things are currently copied around with random
> other "copy bitmaps" functions.

I've committed that patch as commit e1cff7002b71 ("bluetooth: don't
use bitmaps for random flag accesses").

That basically ends up reverting

  a9a347655d22 ("Bluetooth: MGMT: Add conditions for setting
HCI_CONN_FLAG_REMOTE_WAKEUP")
  6126ffabba6b ("Bluetooth: Introduce HCI_CONN_FLAG_DEVICE_PRIVACY device flag")

which did horrible things, and would end up overwriting the end of the
bitmap allocation on 32-bit architectures.

Luiz, if the reason for the change to use a bitmap type was because of
some atomicity concerns, then you can do that by

 (a) change 'hci_conn_flags_t' to be an 'atomic_t' instead of a 'u8'

 (b) change the regular accesses to it to use 'atomic_read/write()'

 (c) change the "bitfield" operations to use 'atomic_or/andnot()'

but honestly, when it used to mix atomic ops
(set_bit/clear_bit/test_bit) with random non-atomic users
(bitmap_from_u64(), bitmap_to_arr32() etc) it was never atomic to
begin with.

Regardless, trying to use bitmaps for this was absolutely not the
right thing to ever do. It looks like gcc randomly started complaining
when 'bitmap_from_u64()' was changed, but it was buggy before that
too.

                 Linus
