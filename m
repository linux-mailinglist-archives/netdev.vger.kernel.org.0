Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33C22CBBF5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbgLBLxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:53:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388675AbgLBLxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:53:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606909916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=eZnLI0Wik0eaxTfaNNAVKLQ21xyT2CoTcJpXnx1wngM=;
        b=JUGMOAD9YYGKleU4USNxLe4Sw7QC7ROPssaPv2FJNswckY44jGA+OooL7i8CITuJ/CkYP/
        HH+EOoOkly3PriNcduDxKArpsqXiGoBwMB+PJy37n0sg1P20xpUIlUUbYV/GlX9AkD0EpJ
        ksbekilRXRqpDXQk5IDs3bHkCYPj0Ko=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-4Oa29oA_MFeTYSbVlo3spA-1; Wed, 02 Dec 2020 06:51:52 -0500
X-MC-Unique: 4Oa29oA_MFeTYSbVlo3spA-1
Received: by mail-wm1-f72.google.com with SMTP id r5so3394802wma.2
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 03:51:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=eZnLI0Wik0eaxTfaNNAVKLQ21xyT2CoTcJpXnx1wngM=;
        b=VaecU83y1yYg6yHBEGJLXT33nxHa8bHAiJFGSNOTh2ERdlyvQMkN/1iDX6QUovrAVw
         rDHiLeZWwDg9t99UrYKGwPkyoSxrNgpVaBNPkoNSd6ahY6DYmhH4SgZiQCkqtvXA3J7P
         HkBMrfif+Yx4kDOB3/i6eh/2idIK2lHpnb1qt4iueekuN7WWtrjkua5+xNcI2uDsnhDl
         UErvBcBYrPfjl87arSW8w8GKcpni4QH3fcZv5DYZHkcL4KsXQ84W1Hic7nHr2SSYYCQ9
         M8Sb93HKM6UtVievxTcgs1lF5IzOWp8f/vOYw4u0+qRQYssiEJYb5oi2RXtCWFOcZQIz
         /fTw==
X-Gm-Message-State: AOAM531x2JxJ7RjMUrtLkim5ADB3iHr8mZ3TmXZBj6Epp5PGe5KATfSe
        e73lJ7XXUqDoKKRuyUBhYv17yIRbXdFgToZZbAXKays8ZnhC6T18FK5n8SP69stDmBMLBygaxGm
        2pIxEmG3lvAuACJts
X-Received: by 2002:a05:600c:2106:: with SMTP id u6mr1002278wml.4.1606909911246;
        Wed, 02 Dec 2020 03:51:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDk/79fb5VUyBoaUX2SQVUTrvAjsll90UI65W+kVpuHWCvrrBFwGplb9GAKNlrMm4UMxEqKg==
X-Received: by 2002:a05:600c:2106:: with SMTP id u6mr1002258wml.4.1606909911075;
        Wed, 02 Dec 2020 03:51:51 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id f7sm1766312wmc.1.2020.12.02.03.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 03:51:50 -0800 (PST)
Date:   Wed, 2 Dec 2020 06:51:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, eli@mellanox.com, jasowang@redhat.com,
        leonro@nvidia.com, lkp@intel.com, mst@redhat.com,
        parav@mellanox.com, rdunlap@infradead.org, saeedm@nvidia.com
Subject: [GIT PULL] vdpa: last minute bugfixes
Message-ID: <20201202065147-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple of patches of the obviously correct variety.

The following changes since commit ad89653f79f1882d55d9df76c9b2b94f008c4e27:

  vhost-vdpa: fix page pinning leakage in error path (rework) (2020-11-25 04:29:07 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 2c602741b51daa12f8457f222ce9ce9c4825d067:

  vhost_vdpa: return -EFAULT if copy_to_user() fails (2020-12-02 04:36:40 -0500)

----------------------------------------------------------------
vdpa: last minute bugfixes

A couple of fixes that surfaced at the last minute.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dan Carpenter (1):
      vhost_vdpa: return -EFAULT if copy_to_user() fails

Randy Dunlap (1):
      vdpa: mlx5: fix vdpa/vhost dependencies

 drivers/Makefile     | 1 +
 drivers/vdpa/Kconfig | 1 +
 drivers/vhost/vdpa.c | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

