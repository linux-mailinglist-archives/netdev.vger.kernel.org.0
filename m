Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A8643D218
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243795AbhJ0ULC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:11:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243780AbhJ0ULB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635365315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VJyQQirrZwuNXLBhFZlxTeutqhrfo+TWoiIbs1ysy2s=;
        b=AUyKUHu1Rtv5sX5J2buxGUl5QHgZFsBvyDC7ZecjAZAmY0vCX7FjfuXgWGFR6y6gr/FxSP
        eYScXfNxn9jLADuJHwnbZK4Vp6FZZPNWDoOCx8AKBinorLxKqxv47gQyzYK4V9cFfX430s
        UiiQxcORdYraFc2V/mJiYcX76+vzvYw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-0mZFpk9iMtOSDVuVaeybCQ-1; Wed, 27 Oct 2021 16:08:34 -0400
X-MC-Unique: 0mZFpk9iMtOSDVuVaeybCQ-1
Received: by mail-ed1-f69.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so3391720edv.10
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VJyQQirrZwuNXLBhFZlxTeutqhrfo+TWoiIbs1ysy2s=;
        b=DuEgyw9uaB3UfYCBcase0NXd60/K/pUJoVttXN5NJ6fB7IeEtN4RX4fX6D6t6p7YhT
         0Pk76v6SkW0kuASBBoO66Wxpa6moq9t5L/KBypUloz8pZ0RuS3FQQVdLhglh5qMVRJvf
         JUhRRVgmmhIX2vG7QQfPc7NNKKvjkNAvHuYtZaMp/x6t1yWuYvcZqRBIxCVin4rgvhj6
         TkOsKCuF9DlzjZg2xLkDdUoLfh3FdBTyHSrPQUTBzCveUS8G3SEbU3m08CoRBcgnHAqu
         pNw4xwdXPK1YW5MAcGVEgixiy/B3PKExR5yf01ShkGYSM69+UdS5Rs9okvD0SY3pA6K6
         No/A==
X-Gm-Message-State: AOAM533Rp4FNswpwgIowAPxzxR50XQRbHYd9+cPmlssYYnUbvwcETBkR
        1vcq7XdtZqVqc94Xmk5izDSJRxTrjuj3HEGvwLhILu/N5vI2xDvfuuKYpcR1WFQ1hZOSUMj3tyw
        YFI/jBBNxzfIKaNUE
X-Received: by 2002:a17:906:c18d:: with SMTP id g13mr40156608ejz.518.1635365312935;
        Wed, 27 Oct 2021 13:08:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpFHN76pLgh4LdmFOeHgtbBOiaO/TarBKKy+bAQpZOaQQRa5m1hagk9YBfjHLP3LAg3Zp+BQ==
X-Received: by 2002:a17:906:c18d:: with SMTP id g13mr40156577ejz.518.1635365312743;
        Wed, 27 Oct 2021 13:08:32 -0700 (PDT)
Received: from redhat.com ([2.55.137.59])
        by smtp.gmail.com with ESMTPSA id u9sm253017edf.47.2021.10.27.13.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:08:32 -0700 (PDT)
Date:   Wed, 27 Oct 2021 16:08:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, mst@redhat.com, vincent.whitchurch@axis.com,
        xieyongji@bytedance.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20211027160829-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 64222515138e43da1fcf288f0289ef1020427b87:

  Merge tag 'drm-fixes-2021-10-22' of git://anongit.freedesktop.org/drm/drm (2021-10-21 19:06:08 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 890d33561337ffeba0d8ba42517e71288cfee2b6:

  virtio-ring: fix DMA metadata flags (2021-10-27 15:54:34 -0400)

----------------------------------------------------------------
virtio: last minute fixes

A couple of fixes that seem important enough to pick at the last moment.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Vincent Whitchurch (1):
      virtio-ring: fix DMA metadata flags

Xie Yongji (2):
      vduse: Disallow injecting interrupt before DRIVER_OK is set
      vduse: Fix race condition between resetting and irq injecting

 drivers/vdpa/vdpa_user/vduse_dev.c | 29 +++++++++++++++++++++++++----
 drivers/virtio/virtio_ring.c       |  2 +-
 2 files changed, 26 insertions(+), 5 deletions(-)

