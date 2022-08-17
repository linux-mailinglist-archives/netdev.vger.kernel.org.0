Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A502596CEB
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiHQKiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiHQKiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F818286DB
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660732729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SGf4yDWBy0MoLiNZXRg5kkyZxBFtMy9Dt/eWAs4QNsU=;
        b=gozaqb0+CprWEZaQ1pAWDB6YvvlaVI61n56/US08SaWuXp8VVTDWaKVVAn7QMPinzeewhH
        KGXBtL8Ye69w/Hen0ACenUYIXkb9LSlsiLuGLwGOrWp+mFrRkv9H/QVnq5TRw5xQwcxWs0
        v/7UGskTvy2Sq6gg97YT+PoG2if5ISc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-35-YmoCzGpwO2q2T54ryqd-YA-1; Wed, 17 Aug 2022 06:38:48 -0400
X-MC-Unique: YmoCzGpwO2q2T54ryqd-YA-1
Received: by mail-wr1-f72.google.com with SMTP id w20-20020adf8bd4000000b002237e71d4e4so2320084wra.21
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=SGf4yDWBy0MoLiNZXRg5kkyZxBFtMy9Dt/eWAs4QNsU=;
        b=L7C6s8n7wudgXD+k2mTpIxao1jh+MpY94zyDEdFZf4BbzlX7i6iz46QIeOdPPEGnXl
         9n/dpvM5KC3REoW0ZGKEqkrfb+3zkA/Ibcq4faZFKSLXY9xVRa3pDCmJWP+om1ojUlC5
         Z38CTFbEPEA1QKUiTPAcF/CceQGQCC8sij71aICjN/rPVfN4FuYp6l0J5HyvR+QhO2nF
         4YmSB2cVqs0CYba9aKXjAKRXPG3OUKhpR3POUx+6Dzj62t7zecZBe7j6vpilFq2ZQ2L9
         vu46wgQEeLqhvFrAgOoTaGCyU/PNDljFLZJJQ/N3VLHGyivIOr61Jq/txh5WhpKjR4kq
         Qpew==
X-Gm-Message-State: ACgBeo2LJN741goyGyghSLXSMC1eDpAkf9spV1rG3mgcaoC/dZdTST6p
        726Spt8VuCwLvhcTZ+tyEf/BDKXO6hHmzcv/UqNcT2tER/EpkoOYi5BhkMHyXS3xt9W4G0mi5Rx
        +WHWelSSF79BfEZxi
X-Received: by 2002:a05:600c:4f51:b0:3a3:478f:6d1c with SMTP id m17-20020a05600c4f5100b003a3478f6d1cmr1672733wmq.143.1660732726628;
        Wed, 17 Aug 2022 03:38:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7dbhTPaz6ve0R5EtpfO+eiBgy3kuKD4ntpw1VnHcvDHghg9FaQouSYJkAbBGtbVE5hQUvDNQ==
X-Received: by 2002:a05:600c:4f51:b0:3a3:478f:6d1c with SMTP id m17-20020a05600c4f5100b003a3478f6d1cmr1672714wmq.143.1660732726372;
        Wed, 17 Aug 2022 03:38:46 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id b6-20020a05600c4e0600b003a601707174sm1772072wmq.33.2022.08.17.03.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 03:38:45 -0700 (PDT)
Date:   Wed, 17 Aug 2022 06:38:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de, jasowang@redhat.com, linux@roeck-us.net,
        mst@redhat.com, ricardo.canuelo@collabora.com,
        xuanzhuo@linux.alibaba.com
Subject: [GIT PULL] virtio: fixes
Message-ID: <20220817063842-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 5c669c4a4c6aa0489848093c93b8029f5c5c75ec:

  virtio: kerneldocs fixes and enhancements (2022-08-16 01:40:24 -0400)

----------------------------------------------------------------
virtio: fixes

Most notably this drops the commits that trip up google cloud
(turns out, it's any legacy device).
Plus a kerneldoc patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (6):
      virtio_net: Revert "virtio_net: set the default max ring size by find_vqs()"
      virtio: Revert "virtio: add helper virtio_find_vqs_ctx_size()"
      virtio-mmio: Revert "virtio_mmio: support the arg sizes of find_vqs()"
      virtio_pci: Revert "virtio_pci: support the arg sizes of find_vqs()"
      virtio_vdpa: Revert "virtio_vdpa: support the arg sizes of find_vqs()"
      virtio: Revert "virtio: find_vqs() add arg sizes"

Ricardo Cañuelo (1):
      virtio: kerneldocs fixes and enhancements

 arch/um/drivers/virtio_uml.c             |  2 +-
 drivers/net/virtio_net.c                 | 42 +++-----------------------------
 drivers/platform/mellanox/mlxbf-tmfifo.c |  1 -
 drivers/remoteproc/remoteproc_virtio.c   |  1 -
 drivers/s390/virtio/virtio_ccw.c         |  1 -
 drivers/virtio/virtio_mmio.c             |  9 ++-----
 drivers/virtio/virtio_pci_common.c       | 20 +++++++--------
 drivers/virtio/virtio_pci_common.h       |  3 +--
 drivers/virtio/virtio_pci_legacy.c       |  6 +----
 drivers/virtio/virtio_pci_modern.c       | 17 ++++---------
 drivers/virtio/virtio_ring.c             |  8 ++++++
 drivers/virtio/virtio_vdpa.c             | 16 +++++-------
 include/linux/virtio.h                   |  6 ++---
 include/linux/virtio_config.h            | 32 ++++++------------------
 include/uapi/linux/virtio_ring.h         | 16 ++++++++----
 15 files changed, 59 insertions(+), 121 deletions(-)

