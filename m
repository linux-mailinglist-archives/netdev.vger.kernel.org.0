Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE7252FC9
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgHZN2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:28:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730204AbgHZN20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598448502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=i67+aNF8QtmkXbZ+5JSUQwpOse6+0MGUqtdEKnlOGYo=;
        b=Q4SObXwIqXhBVDXo5ddCXC0ao/UUQJinuE+m/FsbGLI3qQ9NO3KPWnr+UxBSYRZFjuvx0K
        CEKj815+pBPfN0ZM0xRZB0cT7U2oACkXsfZPc4ACCZZVagm5/G2ZFYV/XnU1LXotHbzTUZ
        jtfJhKTkM72coH1njWVDRfX95WmHkGg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-vUtzJLkGNcq90rzi7kLy0A-1; Wed, 26 Aug 2020 09:28:20 -0400
X-MC-Unique: vUtzJLkGNcq90rzi7kLy0A-1
Received: by mail-wm1-f71.google.com with SMTP id z1so756647wmf.9
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 06:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=i67+aNF8QtmkXbZ+5JSUQwpOse6+0MGUqtdEKnlOGYo=;
        b=OQEFEZ7cYLd2XZ5zeyvqi5MnZ1m4qX3IbbyEqZsnFeOtrfgVNxWoo9tvj7SPdbsZ4f
         Tok6DNigKy8MwdAgSmVt7R4Lr53tyc7vYwsVDyeuOpsBeuPpPGVC6HfCG5aLWqvmo30o
         EGjwKkuhl2Rogld6K3V81hzlLvsXMQqND7mG5meSa3kX3lPiez6j1ql/ghNMLr+fMlz4
         c5JHQqoCXwHlluNVpXN7bpwz9n1RxeG7zr6SQTrcLYRbq1KZuvJJHc8steOQyZyS50wY
         +hxGtp5IdhYtz81YSWwpb6BAAXBxM7/sNySU6GU5u3nS2ogOv++N3AmmDyKwcMjSNCtv
         jLuQ==
X-Gm-Message-State: AOAM533uwajV2anUh9cB9NZ0qIL/YZLxfctWjbRVhyKg1airVmFN6hXY
        wRziuU0qyLmliUQj1Amj8wk0O1SkkNYsPB1iUV3DfEWlf2yH7Kpi+e/ph/cXhDCoYWTk3hV50na
        5KvUcoAlCg8X48Ulm
X-Received: by 2002:a1c:105:: with SMTP id 5mr7557740wmb.83.1598448499406;
        Wed, 26 Aug 2020 06:28:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE5CXik9B/yf7SlhoMl9P+rB1tllMpEuE0RJnSmFjwzWrgc4RXpHi+O77/0mfTHMtg2dZEVQ==
X-Received: by 2002:a1c:105:: with SMTP id 5mr7557705wmb.83.1598448499198;
        Wed, 26 Aug 2020 06:28:19 -0700 (PDT)
Received: from redhat.com (bzq-109-67-46-169.red.bezeqint.net. [109.67.46.169])
        by smtp.gmail.com with ESMTPSA id g62sm5158616wmf.33.2020.08.26.06.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:28:18 -0700 (PDT)
Date:   Wed, 26 Aug 2020 09:27:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        maxime.coquelin@redhat.com, mst@redhat.com,
        natechancellor@gmail.com, rdunlap@infradead.org,
        sgarzare@redhat.com
Subject: [GIT PULL] virtio: bugfixes
Message-ID: <20200826092731-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit d012a7190fc1fd72ed48911e77ca97ba4521bccd:

  Linux 5.9-rc2 (2020-08-23 14:08:43 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to cbb523594eb718944b726ba52bb43a1d66188a17:

  vdpa/mlx5: Avoid warnings about shifts on 32-bit platforms (2020-08-26 08:13:59 -0400)

----------------------------------------------------------------
virtio: bugfixes

A couple vdpa and vhost bugfixes

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (2):
      vdpa: ifcvf: return err when fail to request config irq
      vdpa: ifcvf: free config irq in ifcvf_free_irq()

Nathan Chancellor (1):
      vdpa/mlx5: Avoid warnings about shifts on 32-bit platforms

Stefano Garzarella (1):
      vhost-iotlb: fix vhost_iotlb_itree_next() documentation

 drivers/vdpa/ifcvf/ifcvf_base.h   |  2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c   |  9 +++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 50 +++++++++++++++++++--------------------
 drivers/vhost/iotlb.c             |  4 ++--
 4 files changed, 35 insertions(+), 30 deletions(-)

