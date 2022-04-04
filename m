Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F514F132C
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357945AbiDDKdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358294AbiDDKdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:33:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39C263CFEC
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 03:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649068295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ZAR73l9+1WOyYLU1N4aBZq/AhW2TiRjp9zjhr1hdpGk=;
        b=PvHUQPBsl7DhbZrokCtS9UwpsJaogg23HPotYB/k2c9KO7xqsEq/XhqlDHW9uZS5H2DMXE
        VX7D3P9JJb+21R1Zd+Ii+eo8eArdhuWqwmfNlabiRKRUMRYAxyEAgyWBjEeg3U4fUf7G3H
        l/L/NVd2PrKYlqp2Te9pu9risDM8yms=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-l96lvWBAPqW3acp2-VrnLg-1; Mon, 04 Apr 2022 06:31:34 -0400
X-MC-Unique: l96lvWBAPqW3acp2-VrnLg-1
Received: by mail-wm1-f71.google.com with SMTP id c62-20020a1c3541000000b003815245c642so6744678wma.6
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 03:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ZAR73l9+1WOyYLU1N4aBZq/AhW2TiRjp9zjhr1hdpGk=;
        b=iHXyr4Z/2aHBdHalnLsUs52NqW9/lWmX7100zsctpGiM2TxN7ywZTlD+6pgNRQ+qYJ
         TFo7Nfi1JZeu7QIvC33r0hQ6NBq/A06bHrME8SsfEMuIKt6uZsvKBftZOc1DU++PYwzt
         6dNdyDKoJV08dsK3O2j4CEDV90s3bnIbNClJu30XP/3XdzinXBGbpvOppdeEQucBq5r4
         cqD/0dqcXxGB8ohR02zncFk/1ubogLr3G1vzApwG5DuzMNN9k4+byT7dBmF+zOSeOglj
         Hv306ZOUCUbbmMajT+aVvgg3HPLRKm40YtmGbQItyHew/cXSm5CqoUefQ0U8Wmw+54uy
         5mZw==
X-Gm-Message-State: AOAM532SIAtzsjE1WMOaj746/jXLaoObgfIFJROZSZSh0O9SKEa+8owo
        eXNccdqM53olTBWiJFTY+0eOQiQBiC/kyksXsi6V3SXVx8NN94D/q3zpIEOgUq8afu3O4TQWAR7
        22qTIetswFXWbEcGd
X-Received: by 2002:a5d:6944:0:b0:203:e024:7cdd with SMTP id r4-20020a5d6944000000b00203e0247cddmr16372272wrw.503.1649068293061;
        Mon, 04 Apr 2022 03:31:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhH6jXXCNsS0CDc1GvA4tUCvtOnZ01cqJiOcI9JEogzYD5ay3XT2i7n/tCqJgUrwWPwTT6jQ==
X-Received: by 2002:a5d:6944:0:b0:203:e024:7cdd with SMTP id r4-20020a5d6944000000b00203e0247cddmr16372254wrw.503.1649068292813;
        Mon, 04 Apr 2022 03:31:32 -0700 (PDT)
Received: from redhat.com ([2.54.40.213])
        by smtp.gmail.com with ESMTPSA id p14-20020a05600c1d8e00b0038dbb5ecc8asm9289654wms.2.2022.04.04.03.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 03:31:32 -0700 (PDT)
Date:   Mon, 4 Apr 2022 06:31:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com
Subject: [GIT PULL] virtio: fixes, cleanups
Message-ID: <20220404063128-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit ad6dc1daaf29f97f23cc810d60ee01c0e83f4c6b:

  vdpa/mlx5: Avoid processing works if workqueue was destroyed (2022-03-28 16:54:30 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 1c80cf031e0204fde471558ee40183695773ce13:

  vdpa: mlx5: synchronize driver status with CVQ (2022-03-30 04:18:14 -0400)

----------------------------------------------------------------
virtio: fixes, cleanups

A couple of mlx5 fixes related to cvq
A couple of reverts dropping useless code (code that used it got reverted
earlier)

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (2):
      vdpa: mlx5: prevent cvq work from hogging CPU
      vdpa: mlx5: synchronize driver status with CVQ

Michael S. Tsirkin (2):
      Revert "virtio: use virtio_device_ready() in virtio_device_restore()"
      Revert "virtio_config: introduce a new .enable_cbs method"

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 62 ++++++++++++++++++++++++++-------------
 drivers/virtio/virtio.c           |  5 ++--
 include/linux/virtio_config.h     |  6 ----
 3 files changed, 43 insertions(+), 30 deletions(-)

