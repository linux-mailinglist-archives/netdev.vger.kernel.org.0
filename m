Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622672B448B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgKPNOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:14:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgKPNOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605532473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=bcklXraRLL6YuQnGUW+mYhCFhDJ3s3DEvlUM79PK4ZQ=;
        b=GfU+pUnS38bLsTeEj7sCezW+xZ/DQrx/MXvSq5+zHilRMeGbhHvtTzmK9etlU+ZhfDQPdY
        RPRawCiFKXnM91T8bIhQnkieyp5UQUSzDPGz5XEXhbIyqVw53rEnq14orKPprhMYvVt5i+
        rGEBs8Gtq1T5s9NWo6blvunGKl5XcbY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-rh8j20yrNcyGT8BBFn_7rA-1; Mon, 16 Nov 2020 08:14:31 -0500
X-MC-Unique: rh8j20yrNcyGT8BBFn_7rA-1
Received: by mail-wm1-f70.google.com with SMTP id u123so8693811wmu.5
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 05:14:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bcklXraRLL6YuQnGUW+mYhCFhDJ3s3DEvlUM79PK4ZQ=;
        b=J3fuu9Q/KXSuaYZEyMIgyvgk99ABRojIo61GFR+AfKvozg4NIMjWgVNnJwT+HPJ/tR
         /dDI1870W4defigtkZWe0i4WCWGGd2cSbSAh0fI4v7u/7LgzbF7yzd5hh1dxQfJ5mzqS
         eRpxBuuzbXkdSxZsVnfUdnzOyx7QMse+lqlF9TzNHJfybPG3oGOQWbyJJYuhk7kmUndc
         2dpS/aRFXXic+JCZjiE7C2+qAuaApv4grYKkOWbB17JIYWwEXp2t6eHzACqXN8V64Okf
         Hro7REdWqzxJhv/Wnhrjb2dZ2E9KdgtbmmAd1iKP/kYymXZIG9wcLoW4KpDlJMsuFIwk
         g9Jg==
X-Gm-Message-State: AOAM533C8x+nvZ4pcY+MXuAOAxcM9fD9mjnBtvl47S1d6RI+wQGnWHUP
        UFB7f2EAl7m3LpftLaP0Vevz0qqOneYbUqJu4ALdbJ1bug3dKprrPgDrMlapRyOY9x+YJaw+GUW
        AirULGhsGUl1hv29e
X-Received: by 2002:a1c:6002:: with SMTP id u2mr14508770wmb.29.1605532467575;
        Mon, 16 Nov 2020 05:14:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoKOhCtfX4RQPxreiVjgYctq5k6WupqM3uofRLxRDRD1VbWHuNBhZz0uRXMRsQybcwkP1lsQ==
X-Received: by 2002:a1c:6002:: with SMTP id u2mr14508747wmb.29.1605532467415;
        Mon, 16 Nov 2020 05:14:27 -0800 (PST)
Received: from redhat.com ([147.161.8.56])
        by smtp.gmail.com with ESMTPSA id e5sm21249161wrs.84.2020.11.16.05.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:14:26 -0800 (PST)
Date:   Mon, 16 Nov 2020 08:14:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, lkp@intel.com, lvivier@redhat.com,
        michael.christie@oracle.com, mst@redhat.com, rdunlap@infradead.org,
        sfr@canb.auug.org.au, stefanha@redhat.com
Subject: [GIT PULL] vhost,vdpa: fixes
Message-ID: <20201116081420-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 0c86d774883fa17e7c81b0c8838b88d06c2c911e:

  vdpasim: allow to assign a MAC address (2020-10-30 04:04:35 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to efd838fec17bd8756da852a435800a7e6281bfbc:

  vhost scsi: Add support for LUN resets. (2020-11-15 17:30:55 -0500)

----------------------------------------------------------------
vhost,vdpa: fixes

Fixes all over the place, most notably vhost scsi IO error fixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Laurent Vivier (1):
      vdpasim: fix "mac_pton" undefined error

Mike Christie (5):
      vhost: add helper to check if a vq has been setup
      vhost scsi: alloc cmds per vq instead of session
      vhost scsi: fix cmd completion race
      vhost scsi: add lun parser helper
      vhost scsi: Add support for LUN resets.

Stephen Rothwell (1):
      swiotlb: using SIZE_MAX needs limits.h included

 drivers/vdpa/Kconfig    |   1 +
 drivers/vhost/scsi.c    | 397 ++++++++++++++++++++++++++++++++++--------------
 drivers/vhost/vhost.c   |   6 +
 drivers/vhost/vhost.h   |   1 +
 include/linux/swiotlb.h |   1 +
 5 files changed, 289 insertions(+), 117 deletions(-)

