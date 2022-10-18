Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FAA602045
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJRBQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJRBQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:16:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08BC1BEB3;
        Mon, 17 Oct 2022 18:16:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n7so12403667plp.1;
        Mon, 17 Oct 2022 18:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpEpjcyHF7jz80loTbdXf/AAOyMIPKO2S8szE++9VZI=;
        b=WhUONCMUMMc8v5I2GWZe97A8uWfODv+nkDBmG+lXETGimW1BOH+xe5295RSTbNTMIC
         0TOENt0oAOCQ1W0CsvZ/d4dAtZbnBZCOF+/qQRq0c599u0vhvV5rGsBoRIaX76Fdp1VO
         qr/RjJ4o6Zp3tlIn2RGfzA6EIbZEDqq2uSzeUwWKGhxOX7q+IWhjChu0P+u/BndiFmpK
         NEhFmDWcjAUoURwHuYXjkraMIkU6M3UFSekZaKfG52As46kLGB9YlsVeZ80Y5EEHsi2K
         WyjvhE04Q+Jneraj5I6c7zcdvIT3c1kfuY5iWC/nbRXoMIREpbOjF/BPgvXFcHC6+aAC
         kZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DpEpjcyHF7jz80loTbdXf/AAOyMIPKO2S8szE++9VZI=;
        b=CO9RJJaChByid7XdOMH0+SEN1Mp8rVBiM4gbrs2TmGgo+JQbhbVMfNS7ZRtblKjn75
         JZM9CQLyQXt1K7t1jTdVsT17zXPu7ZRetRUcecLN8VOTsMu+gi0DIV7NVZx7hxcvJPZD
         YVAo1j/1sUR6zp3mZmuNgqyER9GefEw2Rp3DXMiTWbrJlXu5nKLmBzxp35g0SpTNbsBy
         HHOHK9a2e5VkF5FPE0F6tFzBoUh6aPLlBt1621Mp/N7BYZZm3YlRvUpoXq6eRuyh46wz
         kOUBHKX94sCEttAZFyDqy9cuv8BFkzjr6zB32yEbV6KjgWdYH9ze3qgSmULlYFyW4zvT
         MhuA==
X-Gm-Message-State: ACrzQf3huCUU+L81HK0oJ4bRad+JeedkVifKpHMT/J56I8h20QXrG0BC
        1N6mZ4rogf+dkk2jkKaZTTw=
X-Google-Smtp-Source: AMsMyM53vKA5OgJvWPF5eH3SHqvWgZ3/51HP4Ztvo3RuTt/NKT23WkhVgax/NyljQqSkCRnF47kazg==
X-Received: by 2002:a17:902:b942:b0:178:4a7e:da04 with SMTP id h2-20020a170902b94200b001784a7eda04mr463329pls.8.1666055765056;
        Mon, 17 Oct 2022 18:16:05 -0700 (PDT)
Received: from localhost ([159.226.94.113])
        by smtp.gmail.com with ESMTPSA id b8-20020a170903228800b001830ed575c3sm7215952plh.117.2022.10.17.18.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 18:16:04 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     luiz.dentz@gmail.com
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] Bluetooth: L2CAP: Fix memory leak in vhci_write
Date:   Tue, 18 Oct 2022 09:16:00 +0800
Message-Id: <20221018011601.3619-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CABBYNZ+ycRfx3JQNwfCzXBP3G=+a=5qkdExkC2rV5+wiHUBTeA@mail.gmail.com>
References: <CABBYNZ+ycRfx3JQNwfCzXBP3G=+a=5qkdExkC2rV5+wiHUBTeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 at 04:01, Luiz Augusto von Dentz <luiz.dentz@gmail.com> wrote:
>
> Hi Hawkins,
>
> On Mon, Oct 17, 2022 at 12:47 AM Hawkins Jiawei <yin31149@gmail.com> wrote:
> >
> > Syzkaller reports a memory leak as follows:
> > ====================================
> > BUG: memory leak
> > unreferenced object 0xffff88810d81ac00 (size 240):
> >   [...]
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff838733d9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:418
> >     [<ffffffff833f742f>] alloc_skb include/linux/skbuff.h:1257 [inline]
> >     [<ffffffff833f742f>] bt_skb_alloc include/net/bluetooth/bluetooth.h:469 [inline]
> >     [<ffffffff833f742f>] vhci_get_user drivers/bluetooth/hci_vhci.c:391 [inline]
> >     [<ffffffff833f742f>] vhci_write+0x5f/0x230 drivers/bluetooth/hci_vhci.c:511
> >     [<ffffffff815e398d>] call_write_iter include/linux/fs.h:2192 [inline]
> >     [<ffffffff815e398d>] new_sync_write fs/read_write.c:491 [inline]
> >     [<ffffffff815e398d>] vfs_write+0x42d/0x540 fs/read_write.c:578
> >     [<ffffffff815e3cdd>] ksys_write+0x9d/0x160 fs/read_write.c:631
> >     [<ffffffff845e0645>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff845e0645>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > ====================================
> >
> > HCI core will uses hci_rx_work() to process frame, which is queued to
> > the hdev->rx_q tail in hci_recv_frame() by HCI driver.
> >
> > Yet the problem is that, HCI core does not free the skb after handling
> > ACL data packets. To be more specific, when start fragment does not
> > contain the L2CAP length, HCI core just reads possible bytes and
> > finishes frame process in l2cap_recv_acldata(), without freeing the skb,
> > which triggers the above memory leak.
> >
> > This patch solves it by releasing the relative skb, after processing the
> > above case in l2cap_recv_acldata()
> >
> > Fixes: 4d7ea8ee90e4 ("Bluetooth: L2CAP: Fix handling fragmented length")
> > Link: https://lore.kernel.org/all/0000000000000d0b1905e6aaef64@google.com/
> > Reported-and-tested-by: syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com
> > Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> > ---
> >  net/bluetooth/l2cap_core.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index 1f34b82ca0ec..e0a00854c02e 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -8426,9 +8426,8 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
> >                  * expected length.
> >                  */
> >                 if (skb->len < L2CAP_LEN_SIZE) {
> > -                       if (l2cap_recv_frag(conn, skb, conn->mtu) < 0)
> > -                               goto drop;
> > -                       return;
> > +                       l2cap_recv_frag(conn, skb, conn->mtu);
> > +                       goto drop;
>
> Let us use break; instead of goto drop since we have copied the skb into rx_sbk.
Thanks for your suggestion. I will refactor this patch as you suggested.

>
> >                 }
> >
> >                 len = get_unaligned_le16(skb->data) + L2CAP_HDR_SIZE;
> > @@ -8472,7 +8471,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
> >
> >                         /* Header still could not be read just continue */
> >                         if (conn->rx_skb->len < L2CAP_LEN_SIZE)
> > -                               return;
> > +                               goto drop;
> >                 }
> >
> >                 if (skb->len > conn->rx_len) {
> > --
> > 2.25.1
> >
>
>
> --
> Luiz Augusto von Dentz
