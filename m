Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128CF42785D
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJIJUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:20:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230455AbhJIJUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 05:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633771082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2UwzU/Hl4oyLBnA1BVpvqm3h7gRDiFiszHCb/NTENEE=;
        b=iBcETVhgA4p8GbAIwkvff4+QshGlKlQqJVwoph6/Njh/kVKSlTfOSyALNRYNcfJCq8qCTU
        G+oXx41VOCIT6QpEsaQpmJdonrtmYjn4KnDz4ZUwRHe9OgaIjFVC9/akZtszqOatrypcoZ
        9y3gHG28jCH9anJmiCrNxYa9OZFb/LA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-TrZxQ74ENd6shhhtAt48eQ-1; Sat, 09 Oct 2021 05:18:01 -0400
X-MC-Unique: TrZxQ74ENd6shhhtAt48eQ-1
Received: by mail-ed1-f70.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so9332619edy.14
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 02:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=2UwzU/Hl4oyLBnA1BVpvqm3h7gRDiFiszHCb/NTENEE=;
        b=eijzIAwvHPlQqg/AnyXgTxoRZ5zKoQFWP+xm9kw33fllESlLC6H7vSTpF/wqlJxVEq
         mjQn9dz4Kp/ztgCEzONTQxODju7T+GZUeQm+0P2XA9I8Q6w19OwImcqMIL+D+c3wEu8z
         2mFklkkb4XvgodCBalik52kBEFsLZli3/GZDclF/tbes2hafxutZbGqLOqfpAzmQf2C6
         RSfodY7LV5FnsV09jGS2bnfDsix/sMedNOBg7dQ9W+u9KwWxF9E/l8MNQjRvFhB61H0v
         w68RQxIumAd3jRBE0fXUADEA4c2m/QC05upprFvF7rWLbdLqo0oy24unSCrTRNS4Mi/t
         ZzvQ==
X-Gm-Message-State: AOAM532w7mrpIUQQCgGKTJ7JHZJWziT/VO2rqZJeoGBrk+/9xcAt2DBp
        P+kDoTBUZSxY5ipZRixh+RIWM3VTIFf5FcQYGvSbwAtfjJm1aRolmis0nUKqwjZWrzVVHONBiAs
        siRU3ZmFfLOCFNN2i
X-Received: by 2002:a05:6402:5202:: with SMTP id s2mr15544701edd.67.1633771080221;
        Sat, 09 Oct 2021 02:18:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGfmIQZR+1/PAQ0xIABJbC6CJzPRKYIoGKikbdWi9pwKm3KdMLPvApqQ8MIxMgBYddw5gdjQ==
X-Received: by 2002:a05:6402:5202:: with SMTP id s2mr15544541edd.67.1633771078558;
        Sat, 09 Oct 2021 02:17:58 -0700 (PDT)
Received: from redhat.com ([2.55.132.170])
        by smtp.gmail.com with ESMTPSA id ck9sm722624ejb.56.2021.10.09.02.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 02:17:57 -0700 (PDT)
Date:   Sat, 9 Oct 2021 05:17:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Corentin =?utf-8?B?Tm/Dq2w=?= <corentin.noel@collabora.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net] virtio-net: fix for skb_over_panic inside big mode
Message-ID: <20211009091604.84141-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

commit 126285651b7f ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net")
accidentally reverted the effect of
commit 1a8024239da ("virtio-net: fix for skb_over_panic inside big mode")
on drivers/net/virtio_net.c

As a result, users of crosvm (which is using large packet mode)
are experiencing crashes with 5.14-rc1 and above that do not
occur with 5.13.

Crash trace:

[   61.346677] skbuff: skb_over_panic: text:ffffffff881ae2c7 len:3762 put:3762 head:ffff8a5ec8c22000 data:ffff8a5ec8c22010 tail:0xec2 end:0xec0 dev:<NULL>
[   61.369192] kernel BUG at net/core/skbuff.c:111!
[   61.372840] invalid opcode: 0000 [#1] SMP PTI
[   61.374892] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.14.0-rc1 linux-v5.14-rc1-for-mesa-ci.tar.bz2 #1
[   61.376450] Hardware name: ChromiumOS crosvm, BIOS 0

..

[   61.393635] Call Trace:
[   61.394127]  <IRQ>
[   61.394488]  skb_put.cold+0x10/0x10
[   61.395095]  page_to_skb+0xf7/0x410
[   61.395689]  receive_buf+0x81/0x1660
[   61.396228]  ? netif_receive_skb_list_internal+0x1ad/0x2b0
[   61.397180]  ? napi_gro_flush+0x97/0xe0
[   61.397896]  ? detach_buf_split+0x67/0x120
[   61.398573]  virtnet_poll+0x2cf/0x420
[   61.399197]  __napi_poll+0x25/0x150
[   61.399764]  net_rx_action+0x22f/0x280
[   61.400394]  __do_softirq+0xba/0x257
[   61.401012]  irq_exit_rcu+0x8e/0xb0
[   61.401618]  common_interrupt+0x7b/0xa0
[   61.402270]  </IRQ>

See
https://lore.kernel.org/r/5edaa2b7c2fe4abd0347b8454b2ac032b6694e2c.camel%40collabora.com
for the report.

Apply the original 1a8024239da ("virtio-net: fix for skb_over_panic inside big mode")
again, the original logic still holds:

In virtio-net's large packet mode, there is a hole in the space behind
buf.

    hdr_padded_len - hdr_len

We must take this into account when calculating tailroom.

Cc: Greg KH <gregkh@linuxfoundation.org>
Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Fixes: 126285651b7f ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reported-by: Corentin Noël <corentin.noel@collabora.com>
Tested-by: Corentin Noël <corentin.noel@collabora.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

David, I think we need this in stable, too.

 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 096c2ac6b7a6..6b0812f44bbf 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -406,7 +406,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
 	 */
 	truesize = headroom ? PAGE_SIZE : truesize;
-	tailroom = truesize - len - headroom;
+	tailroom = truesize - len - headroom - (hdr_padded_len - hdr_len);
 	buf = p - headroom;
 
 	len -= hdr_len;
-- 
MST

