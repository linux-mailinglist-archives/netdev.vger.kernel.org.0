Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DAF6BEABF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCQOKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjCQOKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:10:04 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B583612CF7
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:10:01 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id n2so5695470qtp.0
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679062201;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LaY7l5oaeABDYKyl6QYFTtEJWOZEXvI3J/Zz61gycg=;
        b=kQiYMc/q0Bgi3HQ/X40A2/46Z6aqi/RnERkznjFr+i8TK0KO3vvH79N9cAtw7LlFH1
         /CSemX0f/57qoOyghH/G9xtRQLleLSlgaK3h3ylsHmcPOS20uSUX7ZZDD0rN4PnyGQcy
         OYGSNi/ZUAl5rlwXHLzy66WevdF1HYG6YiuUx9u/1WNd5vzrJ88JFXcXmUsO/w7HRPCP
         XvpJ09HRa01FHvahIgzxVLiBoxOhBkBELSqx/sDARAsT9H4OJFJ3gpoRcRr1p4XciEBl
         4vZzKCCKdYEIH0yG/ZunobLk+9lnTL+ugZKvWcLKpcvEXHwCSl6McjMV00zGkzzUS+Og
         kuCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679062201;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3LaY7l5oaeABDYKyl6QYFTtEJWOZEXvI3J/Zz61gycg=;
        b=beYrbyrgiri+nr6F5olwGTbA+k9708DNaMt/gh4Q4YrD+jKscQI9LyBrw2RHjqQf65
         i3gsuwp82aywHmqYAvnTItHgQJa6GMlfF+eDmtrCG1y0/r1qDWcxKG3C/5NqsLBqYeZ5
         wc4p6pwY9cG4G4VdZxKxz+vBRB/uavzJgmVKKBXwsdF9Xoi33f0oJdBTXbIUfyHfxYAf
         lE5ppGmfaysOXGf8q0cbTqYZDtutp+8QZcAfuy7UgSPBKhFZ10ceWlot634l0Ol0rm3V
         Yvwg5qyLdE5qmfBIonaRy5483FgwZ4kl3feqtEGDa02Kuh6QXz6EQFbM2y6Us7MUZbE/
         +8Kw==
X-Gm-Message-State: AO0yUKXdLBB/AY2A5KYS+GbojamDTDiZOlA9G7Df8jQluLED3b1MrASs
        au7Cmr1M+C11FEq6T28CGjo=
X-Google-Smtp-Source: AK7set82oFC4mKVHBWKdOIbk659/4WpBFYOqhmBnGl0ftda0/QgCnoyJPAv5L5y0HZoFhABXJ4kicQ==
X-Received: by 2002:a05:622a:1443:b0:3bf:d7f8:4f85 with SMTP id v3-20020a05622a144300b003bfd7f84f85mr12459691qtx.12.1679062200778;
        Fri, 17 Mar 2023 07:10:00 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id e10-20020ac8670a000000b003ba2a15f93dsm1556437qtp.26.2023.03.17.07.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:10:00 -0700 (PDT)
Date:   Fri, 17 Mar 2023 10:09:59 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        netdev@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, mst@redhat.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Message-ID: <641474b7cf005_36045220894@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230317074304.275598-1-amy.saq@antgroup.com>
References: <20230317074304.275598-1-amy.saq@antgroup.com>
Subject: RE: [PATCH v5] net/packet: support mergeable feature of virtio
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> From: Jianfeng Tan <henry.tjf@antgroup.com>
> =

> Packet sockets, like tap, can be used as the backend for kernel vhost.
> In packet sockets, virtio net header size is currently hardcoded to be
> the size of struct virtio_net_hdr, which is 10 bytes; however, it is no=
t
> always the case: some virtio features, such as mrg_rxbuf, need virtio
> net header to be 12-byte long.
> =

> Mergeable buffers, as a virtio feature, is worthy of supporting: packet=
s
> that are larger than one-mbuf size will be dropped in vhost worker's
> handle_rx if mrg_rxbuf feature is not used, but large packets
> cannot be avoided and increasing mbuf's size is not economical.
> =

> With this virtio feature enabled by virtio-user, packet sockets with
> hardcoded 10-byte virtio net header will parse mac head incorrectly in
> packet_snd by taking the last two bytes of virtio net header as part of=

> mac header.
> This incorrect mac header parsing will cause packet to be dropped due t=
o
> invalid ether head checking in later under-layer device packet receivin=
g.
> =

> By adding extra field vnet_hdr_sz with utilizing holes in struct
> packet_sock to record currently used virtio net header size and support=
ing
> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
> sockets can know the exact length of virtio net header that virtio user=

> gives.
> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from=

> corresponding packet_sock, and parse mac header correctly based on this=

> information to avoid the packets being mistakenly dropped.
> =

> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>

Another patch set was just merged that this will have merge conflicts
with. Please respin.

https://lore.kernel.org/netdev/20230316011014.992179-4-edumazet@google.co=
m/T/
