Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F31B234780
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 16:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgGaONI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 10:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgGaONG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 10:13:06 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF42C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 07:13:06 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id h21so16610594qtp.11
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 07:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2GP4/P8BNSu+od4wsMwtfP/yDFgc8ZIVwv55ct9zSQ=;
        b=IEmGQ/HdZENzGYgPx1CJ2uC963/arPCJHc5WnW7wDJCYiNwQ7cFHQDoHiFCHjQyznp
         4OYuiAfGIrcd+PUleNOx+jKcNmXa9nbxxktypwKG8p4Jf3UbT9NdQp8LN4NfMiwAE61P
         nCbX03sBdClB4Of/hOeF0DZ1BCTvsUVTB4sNYXGPl6Uk6fypqJDJXUIvt79WKkeu/o70
         y4SKrNexWp18qy0TJPTWUZJcTVd+cNp71J4Yw0hWF4g7WvvKB/2GJPK5aTCiceEfaLYc
         wfurlLqlnN9CKzXM5qtaYoBNSYoq5g5x9RNmExxG/W05iRAPREToBw7v2QmELjmcBsVi
         j6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2GP4/P8BNSu+od4wsMwtfP/yDFgc8ZIVwv55ct9zSQ=;
        b=dcHb9fQhvrNlUEsZmihTx9wy1ZliMsG8vE2FzCCpI+JrQt+qeOdvuvd4Q+Zf8JmEfY
         bNbM4Tr7IvtAqvHBk3KdF+AWVepVGTjGrXIfr/mw3UykuX/c4HNvkMXb2Cj7f/3eVoqF
         OQgZ9F3WuXCsvcSBdwg+/6TMaR7dSoYbwYPg2zK0w8NStf6XHH5dd0at0r7ulvcyKfuE
         QfQ8Fxj0tqHSTv1H2QCbGwMql1Fci3xDddFvyBm5F6oxPViN9xsjQ71SOxNW/kRXgMHi
         esFcppxPjKb8T9DP3S1trE6LLWC1x5RN05Ad02KfzTnBJSY4zuOgRxaE7QxBr2qzFl6B
         IzWQ==
X-Gm-Message-State: AOAM532UGfCySz+hHMXQBb0dHnZFJe0cfXhJVh8euvq1siq0Mgm/mLs+
        u7HbgqweDH9jA25bbcjyLoXVCxXk
X-Google-Smtp-Source: ABdhPJzHbh8ZXJHNK8KDD6CRE7qDfwuLziZmOmOGVy/dhUpLtxT4/2HE/FJzdQuOCr8wQGGzSmIHSw==
X-Received: by 2002:ac8:1c08:: with SMTP id a8mr3793252qtk.323.1596204784248;
        Fri, 31 Jul 2020 07:13:04 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id c9sm7963427qkm.44.2020.07.31.07.13.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 07:13:03 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id c18so8873426ybr.1
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 07:13:03 -0700 (PDT)
X-Received: by 2002:a25:6d87:: with SMTP id i129mr6392592ybc.315.1596204782541;
 Fri, 31 Jul 2020 07:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200730073702.16887-1-xie.he.0141@gmail.com> <CAJht_ENjHRExBEHx--xmqnOy1MXY_6F5XZ_exinSfa6xU_XDJg@mail.gmail.com>
In-Reply-To: <CAJht_ENjHRExBEHx--xmqnOy1MXY_6F5XZ_exinSfa6xU_XDJg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 31 Jul 2020 10:12:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf_nuiah6rFy-KC1Taw+Wc4z0G7LzkAm-+Ms4FzYmTPEw@mail.gmail.com>
Message-ID: <CA+FuTSf_nuiah6rFy-KC1Taw+Wc4z0G7LzkAm-+Ms4FzYmTPEw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>, briannorris@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 9:36 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> I'm really sorry to have re-sent the patch when the patch is still in
> review. I don't intend to be disrespectful to anyone. And I apologize
> for any disrespectfulness this might appear. Sorry.
>
> I'm also sorry for not having sent the patch with the proper subject
> prefixed with "net" or "net-next". If anyone requests I can re-send
> this patch with the proper subject "PATCH net".
>
> This patch actually fixes a kernel panic when this driver is used with
> a AF_PACKET/RAW socket. This driver runs on top of Ethernet
> interfaces. So I created a pair of virtual Ethernet (veth) interfaces,
> loaded this driver to create a pair of X.25 interfaces on top of them,
> and wrote C programs to use AF_PACKET sockets to send/receive data
> through them.
>
> At first I used AF_PACKET/DGRAM sockets. I prepared packet data
> according to the requirements of X.25 drivers. I first sent an
> one-byte packet ("\x01") to instruct the driver to connect, then I
> sent data prefixed with an one-byte pseudo header ("\x00") to instruct
> the driver to send the data, and then I sent another one-byte packet
> ("\x02") to instruct the driver to disconnect.
>
> This works fine with AF_PACKET/DGRAM sockets. However, when I change
> it to AF_PACKET/RAW sockets, kernel panic occurs. The stack trace is
> as follows. We can see the kernel panicked because of insufficient
> header space when pushing the Ethernet header.
>
> [  168.399197] skbuff: skb_under_panic: text:ffffffff819d95fb len:20
> put:14 head:ffff8882704c0a00 data:ffff8882704c09fd tail:0x11 end:0xc0
> dev:veth0
> ...
> [  168.399255] Call Trace:
> [  168.399259]  skb_push.cold+0x14/0x24
> [  168.399262]  eth_header+0x2b/0xc0
> [  168.399267]  lapbeth_data_transmit+0x9a/0xb0 [lapbether]
> [  168.399275]  lapb_data_transmit+0x22/0x2c [lapb]
> [  168.399277]  lapb_transmit_buffer+0x71/0xb0 [lapb]
> [  168.399279]  lapb_kick+0xe3/0x1c0 [lapb]
> [  168.399281]  lapb_data_request+0x76/0xc0 [lapb]
> [  168.399283]  lapbeth_xmit+0x56/0x90 [lapbether]
> [  168.399286]  dev_hard_start_xmit+0x91/0x1f0
> [  168.399289]  ? irq_init_percpu_irqstack+0xc0/0x100
> [  168.399291]  __dev_queue_xmit+0x721/0x8e0
> [  168.399295]  ? packet_parse_headers.isra.0+0xd2/0x110
> [  168.399297]  dev_queue_xmit+0x10/0x20
> [  168.399298]  packet_sendmsg+0xbf0/0x19b0
> ......
>
> After applying this patch, the kernel panic no longer appears, and
> AF_PACKET/RAW sockets would then behave the same as AF_PACKET/DGRAM
> sockets.

Thanks for fixing a kernel panic. The existing line was added recently
in commit 9dc829a135fb ("drivers/net/wan/lapbether: Fixed the value of
hard_header_len"). I assume a kernel with that commit reverted also
panics? It does looks like it would.

If this driver submits a modified packet to an underlying eth device,
it is akin to tunnel drivers. The hard_header_len vs needed_headroom
discussion also came up there recently [1]. That discussion points to
commit c95b819ad75b ("gre: Use needed_headroom"). So the general
approach in this patch is fine. Do note the point about mtu
calculations -- but this device just hardcodes a 1000 byte dev->mtu
irrespective of underlying ethernet device mtu, so I guess it has
bigger issues on that point.

But, packet sockets with SOCK_RAW have to pass a fully formed packet
with all the headers the ndo_start_xmit expects, i.e., it should be
safe for the device to just pull that many bytes. X25 requires the
peculiar one byte pseudo header you mention: lapbeth_xmit
unconditionally reads skb->data[0] and then calls skb_pull(skb, 1).
This could be considered the device hard header len.

[1] https://lore.kernel.org/netdev/86c71cc0-462c-2365-00ea-7f9e79c204b7@6wind.com/
