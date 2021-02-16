Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94A731C9FF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBPLmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:42:33 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:40287 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhBPLjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:39:47 -0500
Date:   Tue, 16 Feb 2021 11:38:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613475543; bh=lgg1wNkMT8XQOATCoVN+lIKDRAuSPLux4jRMr6UVN+I=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=kRikEzujlWdzrBVi4Dx0Xz5LhZzxIrb5LfYMfBGlM5nTOW+bUs+21MuBqmX1zmk9O
         jm2kJpBabl+dn67ZNrH+cl/gi7YEqL5rKup+LasdzlRtxirxiXAfMs8DS7O0a5iW1V
         5zCxNBYgRj5sFRHxlenLBuldFWrGUsUfonFGIq3Kr1t4wy8KFV+1hVplUAGp6fbBAe
         p8dTqvXcRrhtnL8vmgWcShRBP02VdkhSp8RWPd4yEnfoMC0N7BFSAqLUdOnldqgTfN
         HVMlWjoc16wpi7PrapZZdZa0JCY43hfpuCqRGH7JaSgxH+Zf3AxtPhuxjlK8iI9hMG
         imErVytrMh7zA==
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 bpf-next 4/6] virtio-net: support IFF_TX_SKB_NO_LINEAR
Message-ID: <20210216113740.62041-5-alobakin@pm.me>
In-Reply-To: <20210216113740.62041-1-alobakin@pm.me>
References: <20210216113740.62041-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Virtio net supports the case where the skb linear space is empty, so add
priv_flags.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba8e63792549..f2ff6c3906c1 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2972,7 +2972,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 =09=09return -ENOMEM;
=20
 =09/* Set up network device as normal. */
-=09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
+=09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
+=09=09=09   IFF_TX_SKB_NO_LINEAR;
 =09dev->netdev_ops =3D &virtnet_netdev;
 =09dev->features =3D NETIF_F_HIGHDMA;
=20
--=20
2.30.1


