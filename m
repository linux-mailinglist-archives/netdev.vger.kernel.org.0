Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA53688FA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbhDVWVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:21:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239079AbhDVWVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 18:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619130023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=tgQyxuFNIWv2WFwGCh6y2wdSkYdHkTXHx4X2Bpzjy2I=;
        b=CqO5V47Jsr0+OoTL3rN5LFEkD1cYPQF/QgLGQb8qCkSLjTdZmr7lzccRc6erIn49VUAKFo
        sgPwwoU0t9nt0pW5oD/cQYowRyclXctthv2xxd3YMNJ5kPZB3uPed5UwYnfeMexDC6OFWS
        DqAQFBEiLSBgT84cfD3vldxhdet2rSk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-v6K0izOcMzCZtRHIZzR8xg-1; Thu, 22 Apr 2021 18:20:20 -0400
X-MC-Unique: v6K0izOcMzCZtRHIZzR8xg-1
Received: by mail-ed1-f69.google.com with SMTP id f9-20020a50fe090000b02903839889635cso15536338edt.14
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 15:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tgQyxuFNIWv2WFwGCh6y2wdSkYdHkTXHx4X2Bpzjy2I=;
        b=AXMcmWMABg0exZbpBZDCoi90EBgjd1sFOTKfrIQ29JRo60mRgXOzPznMacmL1Hp9gv
         u2U0pY8QWj5+ywPYpPc6ixpIZIbi51mIBEtfnOMbWQK11n7j1x1gbmSdRAQfGRLUlV1F
         Oeg5fIF4O+zAs//kax8jGw2mAqFTPddli+Wm6iHk98NNzqvC70VdZ8sIjw4JoAxo8tEh
         6IboVsHT0BdNMj3sqdJcBKi5n1lqCrGszsYn4Seta0aztfqUZaDmzsXZ4qBi8fXdRpe/
         n/iXO+hd5TYUHGh+z7P6D1YgdnHMcpSaYWcvmHV/OnIpmZvXBKG3/5y0fvj9H+CJDyvP
         5g2Q==
X-Gm-Message-State: AOAM532MdFq14ETxM3vs3W0t6zyp+yxQcg9WS+mA+V6qJwzmNGF0TBDI
        UfC0XLwNJ5ECXJikFiEfM8cyKJ4PU9NMVNSlX8pl3mfz49VakNh7ZIcVPmthOFMjNiBdtWb81b3
        pBxIu9JPYJyn8qz10
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr807283edz.184.1619130019728;
        Thu, 22 Apr 2021 15:20:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJy1AtNvC1yqgjKWu6Iev/lJ2pAgqjtkiG2OyAAr4aeu8ke3P5mSsVUhBCU4b2QDNeMyBTxQ==
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr807263edz.184.1619130019602;
        Thu, 22 Apr 2021 15:20:19 -0700 (PDT)
Received: from redhat.com (212.116.168.114.static.012.net.il. [212.116.168.114])
        by smtp.gmail.com with ESMTPSA id u1sm3177747edv.90.2021.04.22.15.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 15:20:18 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:20:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, jasowang@redhat.com,
        lkp@intel.com, mst@redhat.com, stable@vger.kernel.org,
        xieyongji@bytedance.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20210422182016-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit bc04d93ea30a0a8eb2a2648b848cef35d1f6f798:

  vdpa/mlx5: Fix suspend/resume index restoration (2021-04-09 12:08:28 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to be286f84e33da1a7f83142b64dbd86f600e73363:

  vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails (2021-04-22 18:15:31 -0400)

----------------------------------------------------------------
virtio: last minute fixes

Very late in the cycle but both risky if left unfixed and more or less
obvious..

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails

Xie Yongji (1):
      vhost-vdpa: protect concurrent access to vhost device iotlb

 drivers/vdpa/mlx5/core/mr.c | 4 +++-
 drivers/vhost/vdpa.c        | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

