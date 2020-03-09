Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AC017DA46
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgCIIIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:08:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58662 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726071AbgCIIIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583741315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=T8KT/+n14Cn5HelmWM4TG6Zo6L21o7FLn2E43AQONUI=;
        b=I7sjVMFrQyszBieK7l81PBbXu3hkzHcGu1wuxeWxaxy9mt8RSC0xHZHxIpqw6fCdX+kdjD
        LJZeHKJOz3OCKFK+WvKMsJJkcgBYPptT+LM8wEl1p8plGMF4Dxb8a7S9QVfzUbhds9JWPM
        eFNtJt5Hel2J2my9omQ3Hwovm7F6RS4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-irExr1-wPKOvRuDqFtp5Zw-1; Mon, 09 Mar 2020 04:08:33 -0400
X-MC-Unique: irExr1-wPKOvRuDqFtp5Zw-1
Received: by mail-qt1-f200.google.com with SMTP id i25so6280502qtm.17
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 01:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=T8KT/+n14Cn5HelmWM4TG6Zo6L21o7FLn2E43AQONUI=;
        b=naRbz8w5ze+5aIlm4SbtUQ9DLep6TvCPBqN+xIy3j8mhCjaS0pm504ljujQnb00VR0
         hN46VEnIa0dFVBkeUqW0OC7pK0zsejspOsVMnol1qPWLrsL9sZm1CzqkUcxnErgD6Mmr
         DQDVi3JWvwg2zTaIpa8AJV25yQKCDADODO9XwaR4jL1kheXY4cT0UAPpICLpBFr3BnHk
         W3ySZ3aalgLUIMwTf0Wx+pTXS9WfXOPipQAlGgb4AvjMEIzmzluVMglIsWA3PFWZvvZ4
         NYc4ug1nB3ZYOeWttsezOyrxfVMIEm09BC6W3XEZpZXSi7TFW5ePm5Kk5ceJn7gmkUIx
         V/IQ==
X-Gm-Message-State: ANhLgQ2qVh0KoOekwUlIG7w4kS9DjA0rIhwLBgNsiUJvXdreimyBrH/B
        Xp06jZtNR+cYGUEVl5puPiLvLbGSQl6/U6++lRTTUWp9+Jl/RS7mN8fHNjaN9JFnGrUTPWt2koQ
        w6LJ1MEhTTUfo2b6B
X-Received: by 2002:a0c:c244:: with SMTP id w4mr13815578qvh.104.1583741311602;
        Mon, 09 Mar 2020 01:08:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsDCYFx3tgEt/18zqy2Hj0onYaUrEMtYoBKu3yJ+l1tw+IzBr80xlV0fKvKv/QcwEaRhnxGPw==
X-Received: by 2002:a0c:c244:: with SMTP id w4mr13815565qvh.104.1583741311386;
        Mon, 09 Mar 2020 01:08:31 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id k11sm21885175qti.68.2020.03.09.01.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 01:08:30 -0700 (PDT)
Date:   Mon, 9 Mar 2020 04:08:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jasowang@redhat.com, mst@redhat.com,
        natechancellor@gmail.com, pasic@linux.ibm.com, s-anna@ti.com
Subject: [GIT PULL] virtio: fixes
Message-ID: <20200309040825-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 98d54f81e36ba3bf92172791eba5ca5bd813989b:

  Linux 5.6-rc4 (2020-03-01 16:38:46 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 6ae4edab2fbf86ec92fbf0a8f0c60b857d90d50f:

  virtio_balloon: Adjust label in virtballoon_probe (2020-03-08 05:35:24 -0400)

----------------------------------------------------------------
virtio: fixes

Some bug fixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Halil Pasic (2):
      virtio-blk: fix hw_queue stopped on arbitrary error
      virtio-blk: improve virtqueue error to BLK_STS

Nathan Chancellor (1):
      virtio_balloon: Adjust label in virtballoon_probe

Suman Anna (1):
      virtio_ring: Fix mem leak with vring_new_virtqueue()

 drivers/block/virtio_blk.c      | 17 ++++++++++++-----
 drivers/virtio/virtio_balloon.c |  2 +-
 drivers/virtio/virtio_ring.c    |  4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

