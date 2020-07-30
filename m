Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6739D23390C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbgG3TaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:30:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34538 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726581AbgG3TaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596137407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Zo62zBr05G4i/w6uOCrF5bcIwehfjUuSBLT3HlEcuYQ=;
        b=Ezxbxa9XNbsqgIwto1nIFCZd7eA2QQNfmnF67HzrXSniqzpiI4iI+Ck+Q8bClbt9JQer15
        VzrtM5Z+Mm5RVXnM5PHw+Ha7YgiYZDYXYMaRd9bPX1GHmEKrfzl+8J47eHNop237+U1HyV
        wgwC/zeTl4Fc1ULLo24le0uGEcCkh38=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-mQ5qaVkdM8SlSjJYLqgsBg-1; Thu, 30 Jul 2020 15:30:04 -0400
X-MC-Unique: mQ5qaVkdM8SlSjJYLqgsBg-1
Received: by mail-wr1-f70.google.com with SMTP id r29so3967955wrr.10
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Zo62zBr05G4i/w6uOCrF5bcIwehfjUuSBLT3HlEcuYQ=;
        b=UE32gKVpPmqfdONlO/xqTDg3C80Mgiv6PNyHP/008HF6fLBv/1FOmwLjS87brSllKP
         5cMAC0tF6fJlJROHH3jRDJxmTdDa7ZO4hdRzXItoO1X6HFjYTSrLOASJDdyFOl7n2tmM
         gJCpU3as7ogEfPRGI3w9yndeEqvid4biLmR3Ujbr/eEvykpdb8/EzDFT0FQy6pEaxu7q
         G71QZvEybtboz/EGJZECwZ+oBke3d3hod63JojGAuUUK7hGK2MKpFM0Fe6kFBGvibw69
         KWeQnLdfNroFFcpZcWwyoTmEJCArypFDdIl9LuARP/8hc3WW+dTnBQyWYf12eRdha2xb
         2x9Q==
X-Gm-Message-State: AOAM5329QbG3IM4CagQRk0plw3oGYbBQ4uyFqC2jLUjLR1EtNADY52qK
        iQ0nO5fz3J7rSf/qo43lkls7YYhwMgG2VBGME3GZb70iXknR1BU7iS1S5kYuYv/IZ6StBSjfFJt
        8l1LiXlfoRlEHafGa
X-Received: by 2002:a5d:538a:: with SMTP id d10mr267398wrv.280.1596137403065;
        Thu, 30 Jul 2020 12:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM38R/gaJ4B9lHJnwY7CoXgiuKGr1JOva2N2K51sHps4St8QHQsZSys7gU+zLzyFwcYWboVQ==
X-Received: by 2002:a5d:538a:: with SMTP id d10mr267372wrv.280.1596137402764;
        Thu, 30 Jul 2020 12:30:02 -0700 (PDT)
Received: from redhat.com (bzq-79-179-105-63.red.bezeqint.net. [79.179.105.63])
        by smtp.gmail.com with ESMTPSA id w64sm9081104wmb.26.2020.07.30.12.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:30:01 -0700 (PDT)
Date:   Thu, 30 Jul 2020 15:29:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, chenweilong@huawei.com,
        david@redhat.com, jasowang@redhat.com, mst@redhat.com,
        rdunlap@infradead.org, stable@vger.kernel.org, wu000273@umn.edu
Subject: [GIT PULL] virtio, qemu_fw: bugfixes
Message-ID: <20200730152958-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 92ed301919932f777713b9172e525674157e983d:

  Linux 5.8-rc7 (2020-07-26 14:14:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a96b0d061d476093cf86ca1c2de06fc57163588d:

  virtio-mem: Fix build error due to improper use 'select' (2020-07-30 11:28:17 -0400)

----------------------------------------------------------------
virtio, qemu_fw: bugfixes

A couple of last minute bugfixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alexander Duyck (1):
      virtio-balloon: Document byte ordering of poison_val

Michael S. Tsirkin (2):
      vhost/scsi: fix up req type endian-ness
      virtio_balloon: fix up endian-ness for free cmd id

Qiushi Wu (1):
      firmware: Fix a reference count leak.

Weilong Chen (1):
      virtio-mem: Fix build error due to improper use 'select'

 drivers/firmware/qemu_fw_cfg.c  |  7 ++++---
 drivers/vhost/scsi.c            |  2 +-
 drivers/virtio/Kconfig          |  2 +-
 drivers/virtio/virtio_balloon.c | 11 ++++++++++-
 4 files changed, 16 insertions(+), 6 deletions(-)

