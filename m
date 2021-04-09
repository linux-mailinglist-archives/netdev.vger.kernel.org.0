Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B7735A3EF
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhDIQsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:48:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232395AbhDIQsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 12:48:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617986904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Chg6IKEuKKojYi7mhUKaMLERMRmxIjzmO/LXSZ+TUHU=;
        b=fWN7UcRXuIoI7jmib68jpV0YbctgHeJetl4QJTvh+iuysD3Vt1leS4AQs3VFt6iNwioB14
        SXlFTqrbXGt6vVeU/AbbKPJ64SwHo44xtmZzRifZxB9j4oLRBnAFzJR6VWGO/A9J0f3Qdy
        yWG9eIdYEE8NdZWVVTK1kZsBDHMKLT0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-yABDH4QuP2uNk47F9zUpGQ-1; Fri, 09 Apr 2021 12:48:20 -0400
X-MC-Unique: yABDH4QuP2uNk47F9zUpGQ-1
Received: by mail-wm1-f69.google.com with SMTP id c81-20020a1c9a540000b0290127367b3942so553613wme.0
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 09:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Chg6IKEuKKojYi7mhUKaMLERMRmxIjzmO/LXSZ+TUHU=;
        b=Af2C1dkY4EGFgfwZjZlQ0Rzm5bLReCHGxzddknRpPZGrkwm/+G4h4ckdw/o3EzORZ6
         Zna9bLCaIyYy+sqVxHiKVD8EyIz4UpSbgY5fHOCawd1fULHUenn2Ew28LHZtm9+GTUPu
         u2tlIwJQ9o9ZjpSdlXkq1TWZscYmqE2Lxm6R66Ub708Q4ccHzHZgO5SHhudqenKh3xrK
         iEf1vfy3LhRbzlBtHlVq7mXfBXlCnWWY52PSxc+zr4s9DnOA4ki4LQVkk6f2iZmG/kyA
         lOM/3B859X92FggWlEel5kJQ+A/Ap9Yo7r+QGNpdSp/A7CjS/HnC1GUMOVNIqMf0xtgh
         wHWA==
X-Gm-Message-State: AOAM532rfrFQkuvS5r3AkVWSesiU8jdaiTyuuBwYhzBZIVYl1G0iVLea
        84FdDs/azWZJG77PcCJMv62ePFX/qhWsr6uwbcLYda/0l+FsOPeJNhDIcc9SCq8xp/IFrbXU4UA
        coJXTEO7Cr4yHKhJU
X-Received: by 2002:a1c:9a16:: with SMTP id c22mr7681446wme.7.1617986899513;
        Fri, 09 Apr 2021 09:48:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2SClI5Njn6xjA2MPYxm2kpYJCEchwrX/9+aQChXy3FOe+I3afHnDGXz6jYj0V+5m4e1Tm6w==
X-Received: by 2002:a1c:9a16:: with SMTP id c22mr7681431wme.7.1617986899273;
        Fri, 09 Apr 2021 09:48:19 -0700 (PDT)
Received: from redhat.com ([2a10:800e:f0d3:0:b69b:9fb8:3947:5636])
        by smtp.gmail.com with ESMTPSA id o25sm6618101wmh.1.2021.04.09.09.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 09:48:18 -0700 (PDT)
Date:   Fri, 9 Apr 2021 12:48:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com,
        si-wei.liu@oracle.com
Subject: [GIT PULL] vdpa/mlx5: last minute fixes
Message-ID: <20210409124816-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit e49d033bddf5b565044e2abe4241353959bc9120:

  Linux 5.12-rc6 (2021-04-04 14:15:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to bc04d93ea30a0a8eb2a2648b848cef35d1f6f798:

  vdpa/mlx5: Fix suspend/resume index restoration (2021-04-09 12:08:28 -0400)

----------------------------------------------------------------
vdpa/mlx5: last minute fixes

These all look like something we are better off having
than not ...

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (4):
      vdpa/mlx5: Use the correct dma device when registering memory
      vdpa/mlx5: Retrieve BAR address suitable any function
      vdpa/mlx5: Fix wrong use of bit numbers
      vdpa/mlx5: Fix suspend/resume index restoration

Si-Wei Liu (1):
      vdpa/mlx5: should exclude header length and fcs from mtu

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
 drivers/vdpa/mlx5/core/mr.c        |  9 +++++++--
 drivers/vdpa/mlx5/core/resources.c |  3 ++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 40 +++++++++++++++++++++++---------------
 4 files changed, 37 insertions(+), 19 deletions(-)

