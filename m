Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E311D110
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 23:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfENVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 17:11:59 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42107 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfENVL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 17:11:59 -0400
Received: by mail-qk1-f195.google.com with SMTP id d4so167215qkc.9
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 14:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=qULCzBdQcxHh1C2O8j06vBUB9AzYlN4esxwCWasX1SQ=;
        b=N3AiWxU+l3dWmpmpvvIzpBLrRvacTu1BRidnQIpATHuBUfiXWd4c6veCYS4zppYuby
         uKTT88HWhYiCXIIcJG/lQVvnqvRr/ullXjWtzaO039sb2Ejm0fpO2bM19H+p/uKNRP6F
         gM9eteE4hOHUd4b/j//OqfHYuFf0qljl+ACCO8yUUUVKiQBfVVBZxz1fUt7333YuvbCU
         o/zPzfmwiYkjQ+wejrzr1ZX6Fuf1WxFhaS1q7wWRP7h3r2/GZjXQ4Nazjc7Z3k7jyC7r
         ZtpvQGlpgAoBBkFjW41MskD9FJodLHVRnXL+1+tyiMebxtf6VK5u5aFgir1tEy8j3xKE
         ZQug==
X-Gm-Message-State: APjAAAVAcdeSKT36aOOHD+Aikb7FLKCm1ZhnpDGNdVQoZSxWB7syxS/g
        bNs1trqT3mnVHMVBycJ146EjZg==
X-Google-Smtp-Source: APXvYqxmZ0SoPCfFH0lsC6mFWej9UEaIAHl3b5sj9Rk3s8zGc9PLlPE58FGHNqVgQ1TOJiOuRs78Bw==
X-Received: by 2002:a37:4f8a:: with SMTP id d132mr16914864qkb.272.1557868318291;
        Tue, 14 May 2019 14:11:58 -0700 (PDT)
Received: from redhat.com ([185.54.206.10])
        by smtp.gmail.com with ESMTPSA id f16sm8168845qkk.19.2019.05.14.14.11.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 14:11:57 -0700 (PDT)
Date:   Tue, 14 May 2019 17:11:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.parri@amarulasolutions.com, benbjiang@tencent.com,
        jasowang@redhat.com, j.neuschaefer@gmx.net, mst@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, yuehaibing@huawei.com
Subject: [PULL] vhost: cleanups and fixes
Message-ID: <20190514171147-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd:

  Linux 5.1 (2019-05-05 17:42:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 050f4c4d2fbbd8217d94dc21051cc597d2a6848b:

  virtio/s390: enable packed ring (2019-05-12 13:11:36 -0400)

----------------------------------------------------------------
virtio: fixes, features

s390 has packed ring support.
several fixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Halil Pasic (3):
      virtio/s390: use vring_create_virtqueue
      virtio/s390: DMA support for virtio-ccw
      virtio/s390: enable packed ring

Jiang Biao (1):
      virtio/virtio_ring: do some comment fixes

Jonathan Neuschäfer (1):
      tools/virtio/ringtest: Remove bogus definition of BUG_ON()

Paolo Bonzini (1):
      vhost-scsi: remove incorrect memory barrier

YueHaibing (1):
      virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed

 drivers/s390/virtio/virtio_ccw.c | 52 +++++++++++++++++++---------------------
 drivers/vhost/scsi.c             |  1 -
 drivers/virtio/virtio_ring.c     | 28 ++++++++++++----------
 include/linux/virtio.h           | 17 -------------
 tools/virtio/ringtest/ptr_ring.c |  1 -
 5 files changed, 40 insertions(+), 59 deletions(-)
