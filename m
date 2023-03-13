Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47DF6B6F7F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCMGcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCMGcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:32:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5B84A1E0
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 23:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678689105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uP6OPkCE+3XV/LM8KCZyJuOxYGuLRyW9hCJ+ior5xWo=;
        b=cuhXfW1TvjgJ+Tp1kEqGeasMdbcT0EI+OSChNuTAO9mToMezh5y9dSxkNQ7CnZOfgyF8kM
        0ZPZn0zkwhZx54I440D4iPZEKv3cVdizjpEkcpTmgo6TykZwG7CEQKtMjd0jHrw+v99F1Q
        uNLCgPlBCY9CqahOmsrxYppaag33EQM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-nayTZWYKO_2Av-hSh2D06g-1; Mon, 13 Mar 2023 02:31:43 -0400
X-MC-Unique: nayTZWYKO_2Av-hSh2D06g-1
Received: by mail-wm1-f70.google.com with SMTP id z6-20020a7bc7c6000000b003e0107732f4so3764992wmk.1
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 23:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678689102;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uP6OPkCE+3XV/LM8KCZyJuOxYGuLRyW9hCJ+ior5xWo=;
        b=RnweKa5SxbgYwo8HQf2tiTvAx80XZX2h98OexegL25REytN4osvNlbpPOoeeDyiMb7
         X2GVqrehFXIB7FNncLfiu7u+K9Bg4lZvV5eAAFUMXR8ACRIS171OKkTq6+PmDxm1mcbM
         VPwIYxBZAsq5kMkLWt2D2plT8Z5PfKAgRYpQEQkpi3L85zFSdhXzfeJSVlkB5H4oJqQC
         L0hz610pND2Vos6aXGfKM9fmbFn/buFVHf1V8GlueXAzQ41H4+ByyAMIqo6q8+d7cb8f
         nX/d3n0sPq+NYpygk9jobMWdQxclZltKRXkyJrEvdfHPbrx2HHfHpvwEOiK/lTlAcOsT
         AV0g==
X-Gm-Message-State: AO0yUKVmsD+q/TeaZocS+ab2/sTDqQ1P354VsoKfMRmJLGaVFNRP7k7n
        m9h9BeAC967k99nKvlpV4cDe82tkyEalAMjUHNIPw2Q8/zacfAbY3t4vl8uPHYjXWFmzIBEjM75
        p2yMINTZ80+plDNga
X-Received: by 2002:a05:600c:a4c:b0:3e2:d3:b2b6 with SMTP id c12-20020a05600c0a4c00b003e200d3b2b6mr7122733wmq.14.1678689102693;
        Sun, 12 Mar 2023 23:31:42 -0700 (PDT)
X-Google-Smtp-Source: AK7set/m0d39bBRh2a53avY9wpGXBQ5w6WVRLPsP4dfir1NMRR7vQctreaympSD9w7L/W8ZMq9gTgQ==
X-Received: by 2002:a05:600c:a4c:b0:3e2:d3:b2b6 with SMTP id c12-20020a05600c0a4c00b003e200d3b2b6mr7122711wmq.14.1678689102415;
        Sun, 12 Mar 2023 23:31:42 -0700 (PDT)
Received: from redhat.com ([2.52.26.7])
        by smtp.gmail.com with ESMTPSA id f25-20020a7bc8d9000000b003ed24653333sm1899615wml.33.2023.03.12.23.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 23:31:41 -0700 (PDT)
Date:   Mon, 13 Mar 2023 02:31:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@amd.com,
        jasowang@redhat.com, leiyang@redhat.com, lulu@redhat.com,
        mst@redhat.com, rongtao@cestc.cn, si-wei.liu@oracle.com,
        stable@vger.kernel.org
Subject: [GIT PULL] virtio,vhost,vdpa: bugfixes
Message-ID: <20230313023139-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

  Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to ae43c20da2a77c508715a9c77845b4e87e6a1e25:

  tools/virtio: Ignore virtio-trace/trace-agent (2023-03-13 02:29:12 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: bugfixes

Some fixes accumulated so far.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Cindy Lu (1):
      vp_vdpa: fix the crash in hot unplug with vp_vdpa

Eugenio Pérez (1):
      vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready

Gautam Dawar (1):
      vhost-vdpa: free iommu domain after last use during cleanup

Rong Tao (1):
      tools/virtio: Ignore virtio-trace/trace-agent

Si-Wei Liu (1):
      vdpa/mlx5: should not activate virtq object when suspended

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  6 +++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c   | 11 +++++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c  |  2 +-
 drivers/vhost/vdpa.c               |  3 ++-
 tools/virtio/.gitignore            |  1 +
 6 files changed, 21 insertions(+), 3 deletions(-)

