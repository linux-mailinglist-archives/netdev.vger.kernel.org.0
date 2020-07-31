Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C58233CE6
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbgGaBgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728080AbgGaBgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 21:36:36 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8BBC061574;
        Thu, 30 Jul 2020 18:36:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so15899740pls.5;
        Thu, 30 Jul 2020 18:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=unNkakX66uz1a8NwuDIWTVZkGEyN5ilSTI7FY3j0SNA=;
        b=L1u1vSnIvxCrTsbprGLnPNvMYpTghiUZV9ALHMPH/7GGcpcXgAkqsU/NHJ1vvMrck5
         eAdHIPnKemAt37IRtdNBI6CN4RpCUiLxt/TRxso0w4MoHB4ojXMBdC1v1ebqYyKxe53y
         HNOHUXc9YjZffpb2dYNdlywhJg3y3CHsX2YmrGYzTsRazISvKoCWMMgBZOxL3QHcMeEL
         iFTKkkOpibBFDnNqOwZlPNPuoOzcXXZmvikjntTvHVA+ajhwh3wxmBWSy7Dnm9Fw/JNX
         Lde2+mZcbbo9Mg8FR0UVbg5G+sZdcITWW1fs1AlQOjQm4O4rBA1ZCn9Tf3PJhFxvWIty
         7IDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=unNkakX66uz1a8NwuDIWTVZkGEyN5ilSTI7FY3j0SNA=;
        b=cwPNBjm302yaoWye58I2qxYn3tWv0qc/JDbF+8ZA++TWewrE3BuzKtDbIhtxTar+lT
         paIXt/HZy6A6wvvFGqwsqU8vOmo0YU5BRSNVDwqoryAd/0wvW5HHMvgR8rjc7OciHubd
         qBP8I3W7/GDnnPuRVPHm+Pxwky/WMmipJT9TOxLESuH978/SC8oNpHs+Wvqte3cWa4k8
         w1LcXyMxenoqhBdihMqBDbOm26aqhVNBUs8amyP28oT2o1d6WuroLrSMIqCf8d0MPMzv
         MFnAP83p/v331CiLxOQ+rcoNgwvZd/37ZLgwhDhezpdbFznVJDWuPJYNvUAaXIfsOpZM
         +lhg==
X-Gm-Message-State: AOAM5331PyA0xL/YwOJQ0KxDV7h7qaJkEu1c9HanCYnbNHjaosTaWmkn
        QHie1VHnICfLkwZbpokW5C6HHtw/xgWOcUDmGGYsZskY
X-Google-Smtp-Source: ABdhPJzVA+O/8B02DuuSBuOGAZP7Ze1ToCSzfGnOyyBIPv80gzyS07s2MKeTbAYxBcysu6qbfmsN3xD6FR+kU5LkJ3I=
X-Received: by 2002:a63:e057:: with SMTP id n23mr1471867pgj.368.1596159395958;
 Thu, 30 Jul 2020 18:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200730073702.16887-1-xie.he.0141@gmail.com>
In-Reply-To: <20200730073702.16887-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 30 Jul 2020 18:36:25 -0700
Message-ID: <CAJht_ENjHRExBEHx--xmqnOy1MXY_6F5XZ_exinSfa6xU_XDJg@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm really sorry to have re-sent the patch when the patch is still in
review. I don't intend to be disrespectful to anyone. And I apologize
for any disrespectfulness this might appear. Sorry.

I'm also sorry for not having sent the patch with the proper subject
prefixed with "net" or "net-next". If anyone requests I can re-send
this patch with the proper subject "PATCH net".

This patch actually fixes a kernel panic when this driver is used with
a AF_PACKET/RAW socket. This driver runs on top of Ethernet
interfaces. So I created a pair of virtual Ethernet (veth) interfaces,
loaded this driver to create a pair of X.25 interfaces on top of them,
and wrote C programs to use AF_PACKET sockets to send/receive data
through them.

At first I used AF_PACKET/DGRAM sockets. I prepared packet data
according to the requirements of X.25 drivers. I first sent an
one-byte packet ("\x01") to instruct the driver to connect, then I
sent data prefixed with an one-byte pseudo header ("\x00") to instruct
the driver to send the data, and then I sent another one-byte packet
("\x02") to instruct the driver to disconnect.

This works fine with AF_PACKET/DGRAM sockets. However, when I change
it to AF_PACKET/RAW sockets, kernel panic occurs. The stack trace is
as follows. We can see the kernel panicked because of insufficient
header space when pushing the Ethernet header.

[  168.399197] skbuff: skb_under_panic: text:ffffffff819d95fb len:20
put:14 head:ffff8882704c0a00 data:ffff8882704c09fd tail:0x11 end:0xc0
dev:veth0
...
[  168.399255] Call Trace:
[  168.399259]  skb_push.cold+0x14/0x24
[  168.399262]  eth_header+0x2b/0xc0
[  168.399267]  lapbeth_data_transmit+0x9a/0xb0 [lapbether]
[  168.399275]  lapb_data_transmit+0x22/0x2c [lapb]
[  168.399277]  lapb_transmit_buffer+0x71/0xb0 [lapb]
[  168.399279]  lapb_kick+0xe3/0x1c0 [lapb]
[  168.399281]  lapb_data_request+0x76/0xc0 [lapb]
[  168.399283]  lapbeth_xmit+0x56/0x90 [lapbether]
[  168.399286]  dev_hard_start_xmit+0x91/0x1f0
[  168.399289]  ? irq_init_percpu_irqstack+0xc0/0x100
[  168.399291]  __dev_queue_xmit+0x721/0x8e0
[  168.399295]  ? packet_parse_headers.isra.0+0xd2/0x110
[  168.399297]  dev_queue_xmit+0x10/0x20
[  168.399298]  packet_sendmsg+0xbf0/0x19b0
......

After applying this patch, the kernel panic no longer appears, and
AF_PACKET/RAW sockets would then behave the same as AF_PACKET/DGRAM
sockets.
