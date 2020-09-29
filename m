Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7857527BE65
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgI2Hur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727561AbgI2Hun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:50:43 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601365842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ZH5RUsiNCBnwQO3HdBH/S2GadrEkNWR9w8D2mfkC+xk=;
        b=KgvHl16Wswmk2dGHcQwcqzyP+ljW5etLxraLl4KE+1U8YzByMKm7xRm8UdCTsl2IwtN/bc
        7iAjJ1jMT4Ljyq9IZio1yl3raXunBvmkWx/8b5L7k8pJLdAihXJhGa90ozQFE0Bp9L0K91
        vGTtFFRUcBGZoSQchuIWT2yJ8p5g1cY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-gehjtmMXPByxJWa2-BAknQ-1; Tue, 29 Sep 2020 03:50:38 -0400
X-MC-Unique: gehjtmMXPByxJWa2-BAknQ-1
Received: by mail-wr1-f71.google.com with SMTP id h4so1404399wrb.4
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ZH5RUsiNCBnwQO3HdBH/S2GadrEkNWR9w8D2mfkC+xk=;
        b=MNSHoj1662BBSNhxgQPrbif8tGeORH3edzoyeqTHYZDusnN8Y6fRUap3TGQJELGZmP
         J6OjimgY2aqEHZr26M9iU4kVb6mL3/RlELFzpq8LtC8xfY4Sc/qxDyaSUPbGh3zkgGZn
         Bcu2WJ07zDFXHh7rApddWWCWeFqVb0GmIxB/TRv6v+XdSE5a4pW7V/rXTwU+klD17801
         ba5MTobkIhvW+r1nrEbMo4U6rVNRiuGWPbccl9pXBcasYwKzEh7LZ6Vq+Rv22x9JNiz+
         vYBPpiF5cazGhJWZ4p073LHt33hROKoL/k4pUtOPrGV3ieYrzP3KR7Hd0DNuWouv55dy
         W/dA==
X-Gm-Message-State: AOAM532G2L/W5Frx+ulT3kvyB9LzXv6uGrrN9MRh/5Hxc+QgkC+GdFok
        AvneRHkGjsER5/E+I9Gb8Qoh8/nMacNSK2QdO1BokOrjYBTLhkXWmojLBXuT+RWXFZ6IcrGlo4y
        0lJ+zKVPOvtkHiNrA
X-Received: by 2002:a5d:660f:: with SMTP id n15mr2849630wru.103.1601365837345;
        Tue, 29 Sep 2020 00:50:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9yDNuK/HRBfrUSRppU/hB6f1n2dAKzHM+mssOZcfIMLGHfW5jc72hMkHH51Lh+uUsHHthwg==
X-Received: by 2002:a5d:660f:: with SMTP id n15mr2849612wru.103.1601365837164;
        Tue, 29 Sep 2020 00:50:37 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id o15sm4204743wmh.29.2020.09.29.00.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 00:50:36 -0700 (PDT)
Date:   Tue, 29 Sep 2020 03:50:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, eli@mellanox.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, mst@redhat.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20200929035034-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately there are a couple more reported issues in vhost and vdpa,
but those fixes are still being worked upon, no reason to
delay those that are ready.

The following changes since commit ba4f184e126b751d1bffad5897f263108befc780:

  Linux 5.9-rc6 (2020-09-20 16:33:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a127c5bbb6a8eee851cbdec254424c480b8edd75:

  vhost-vdpa: fix backend feature ioctls (2020-09-24 05:54:36 -0400)

----------------------------------------------------------------
virtio: last minute fixes

A couple of last minute fixes

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vhost: Fix documentation

Jason Wang (1):
      vhost-vdpa: fix backend feature ioctls

 drivers/vhost/iotlb.c |  4 ++--
 drivers/vhost/vdpa.c  | 30 ++++++++++++++++--------------
 2 files changed, 18 insertions(+), 16 deletions(-)

