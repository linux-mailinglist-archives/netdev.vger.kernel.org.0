Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA8D23D7A7
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 09:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgHFHsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 03:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbgHFHrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 03:47:43 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FFEC061756
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 00:47:34 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id 1so19098709vsl.1
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 00:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0t+oHy+3tXSv0Fyo8sj7nLYPLgMZk4rOQH5zJCrsUw=;
        b=mmO64tyBsv+JgYuCiVyrAC9dV/zesXAcDYptXbHbTy4W8WXtXbVWPIOs51jgsbEwN3
         HhXWe+f/qbuFvdAhQUwRBnYyDtQkKTwom+nj/bIY8e2tBjpbRMQwYA/mO3SqrIt98nwT
         ra9b6d/QmxEpGikM9bJy8QITxjvVXBLrvoxFkUVpYbmnHlJkpgXjxr1pM0NwEq35WKDI
         Yu7mXGNnpAeeKTujMpr7d82Epw3cGUSK/7QLXPNOuLPg9ur0TbkWJFeRaBIIhWndag9O
         MJ5eDNE6ElyNqBNB73YNa0pKfS56drZJ+EY+hNc2AdhgZGEE/49fUu+Uqq/POqk0UH9X
         arkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0t+oHy+3tXSv0Fyo8sj7nLYPLgMZk4rOQH5zJCrsUw=;
        b=Oldln0XWmkykgcdchwgYmQECK8gURHfJ9/Ki235pXsLWtOq2q6tk5s+vB0LiqUCc1J
         pHwt3LXmMFx/O/A8Q+DmRptN4AgW4j011TjM+45W8+QotrjomLErKLH1QsPFIcVbCWxL
         5rSGc4jf95EOCwvSjf0diZBS65Thgf5nD5UbSNMW3ISzHxlht7x04gilUDuwRsbZ+niT
         gbQfoFS6C2W+33o34EBa7T1p95Fdcwh8A+/BL9YRAghzB6JZgNFeT6cPlmRpoUhw0shD
         Pq0c3xw931gdwJ/3ynWL14oCaFf6OUrGb1pf56VCjy6nCrCCxCmsgziHZltfciG3rit2
         6pgw==
X-Gm-Message-State: AOAM532k3RWMuYtduS0poyylb3ho7UHS6N1h4nV8Ktnqa3mO7HCsXPnU
        WE0RluuIdYwCDJaZaychhwOxYQcx/48=
X-Google-Smtp-Source: ABdhPJw7LLpQ67nPg10kjLKrmj8tduMa32GCdrIMhDBfnRJ1Wg+1ii7Ez3XHDv4XLHL1jKxlO+ODIA==
X-Received: by 2002:a67:fd5b:: with SMTP id g27mr5195861vsr.230.1596700051315;
        Thu, 06 Aug 2020 00:47:31 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id l76sm905719vki.9.2020.08.06.00.47.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 00:47:30 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id q68so11485126uaq.0
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 00:47:29 -0700 (PDT)
X-Received: by 2002:ab0:1892:: with SMTP id t18mr633054uag.108.1596700049106;
 Thu, 06 Aug 2020 00:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200806015040.98379-1-xie.he.0141@gmail.com>
In-Reply-To: <20200806015040.98379-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 6 Aug 2020 09:46:52 +0200
X-Gmail-Original-Message-ID: <CA+FuTSeOhYOqKjHk5ZBFiY=_+pXgUKe4BKx1S+gu9T9X2c1+bQ@mail.gmail.com>
Message-ID: <CA+FuTSeOhYOqKjHk5ZBFiY=_+pXgUKe4BKx1S+gu9T9X2c1+bQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/lapbether: Added needed_headroom and a
 skb->len check
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 3:51 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> 1. Added a skb->len check
>
> This driver expects upper layers to include a pseudo header of 1 byte
> when passing down a skb for transmission. This driver will read this
> 1-byte header. This patch added a skb->len check before reading the
> header to make sure the header exists.
>
> 2. Changed to use needed_headroom instead of hard_header_len to request
> necessary headroom to be allocated
>
> In net/packet/af_packet.c, the function packet_snd first reserves a
> headroom of length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and assumes the user to provide the
> appropriate link layer header.
>
> So according to the logic of af_packet.c, dev->hard_header_len should
> be the length of the header that would be created by
> dev->header_ops->create.
>
> However, this driver doesn't provide dev->header_ops, so logically
> dev->hard_header_len should be 0.
>
> So we should use dev->needed_headroom instead of dev->hard_header_len
> to request necessary headroom to be allocated.
>
> This change fixes kernel panic when this driver is used with AF_PACKET
> SOCK_RAW sockets.
>
> Call stack when panic:
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
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Cc: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

The in-band signal byte is required, but stripped by lapbeth_xmit.
Subsequent code will prefix additional headers, including an Ethernet
link layer. The extra space needs to be reserved, but not pulled in
packet_snd with skb_reserve, so has to use needed_headroom instead of
hard_header_len.
