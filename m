Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B01687851
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjBBJJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjBBJJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:09:43 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC92645BD1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:09:41 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id be8so1193036plb.7
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=10hCW48KPbvjfvXEjrjQ+Mgg8cpIPYTv4D/tTAJDTFA=;
        b=8EMNDhCqTbFttbka/+TAiSeV5HrHEpPPTDWCdd+pC75E+2UqrAgvMajQc0EkjbagyX
         9n/0ZfjnRY8rUa+nIoXcW7SqLt4UxhjTntX5RNDx0A4bTmCkZ1dUofksYyMCwUplG0ZK
         khdSJiOtcrutRo1WdLqkenS+9CMGQ52nG60Rw+43cN28AWgHp3X0vKj7xoOdW4Oij+p2
         PH1+Hqzp/LlbRe+bNIAeHcitIsnEfGKgqPxC1LNuG6nP3gu7h+TNyhPGv7CGuOaksqsB
         xEFUWl3qxYUaT3dz2n9sGR8Fx60EGP4Xk6Tcmx1lhpa+jY/tS/gNaQb+fyrgR2X0Xx7v
         KQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=10hCW48KPbvjfvXEjrjQ+Mgg8cpIPYTv4D/tTAJDTFA=;
        b=PY0IxWadYyZ4qjcSmdINSrfZ3H6boo/5NJiTn+GQJ/zn0ohouM/YrbZ2TqjX/rqnOB
         Y7Q2u6zHwAzho6Oq7OFHHC/Jj0DP9hB/h7Epjqatg1/28+3Uz+jGDNaehqSXL6/gYc/g
         vpnb9TQF1f90lLYU0T89o001OFwpcFpzIAHV+v9YXE9aRCphP5YeNtGScTDlVV902MBk
         kSGETuhlxldSBBsoWaB4uKlC9wrzeRXYaBTrVSwhEusIdpWaOJHxgDG9d2gmBf/p+Ggd
         tSl3DoxRv8ZOTsRNg5zXLBxWq3uPnIOiijpICHQfwVmGrR6yfqcA3CQXocMdTMcUq4+s
         i6zw==
X-Gm-Message-State: AO0yUKVNK72VxKa/KnnSuoDTWFUE2p03ZGWI07X6EFvDSj4tQav0MIib
        ktZvPCPj/76r26cVk5LEakedDA==
X-Google-Smtp-Source: AK7set8TRDrnyQM34c60qrfKukf3YMCoIk81aVwwaJ/9ofFNhvBNL5Xdej/Gen3KhJgGunl2ZBfRDA==
X-Received: by 2002:a05:6a20:6987:b0:bb:bb46:bb9e with SMTP id t7-20020a056a20698700b000bbbb46bb9emr6437176pzk.39.1675328981236;
        Thu, 02 Feb 2023 01:09:41 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id ik12-20020a170902ab0c00b001929827731esm13145968plb.201.2023.02.02.01.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:09:40 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH v2 0/7] Introduce a vringh accessor for IO memory
Date:   Thu,  2 Feb 2023 18:09:27 +0900
Message-Id: <20230202090934.549556-1-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vringh is a host-side implementation of virtio rings, and supports the
vring located on three kinds of memories, userspace, kernel space and a
space translated iotlb.

The goal of this patchset is to refactor vringh and introduce a new vringh
accessor for the vring located on the io memory region. The io memory
accessor (iomem) is used by a driver that is not published yet, but I'm
planning to publish it. Also changes of drivers affected by this patchset
are not included yet. e.g. caif_virtio and vdpa (sim_net,blk, net/mlx5)
drivers.

This patchset can separate into 4 parts:
1. Fix a typo in the vringh header[1/7]
2. Enable a retpoline on virtio/vringh_test [2/7]
2. Unify the vringh APIs and change related [3, 4, 5, 6/7]
3. Support IOMEM to vringh [7/7]

This first part is just for typo fixing. The second part changes build
options of virtio/vringh_test. The change bring the test close to linux
kernel in retpoline. In the third part, unify the vringh API for each
accessors that are user, kern and iotlb. The main point is struct
vringh_ops that fill the gap between all accessors. The final part
introduces an iomem support to vringh according to the unified API in the
second part.

Those changes are tested for the user accessor using vringh_test and kern
and iomem using a non published driver, but I think I can add a link to a
patchset for the driver in the next version of this patchset.

v2:
- Add a build options to enable the retpoline in vringh_test
- Add experimental results of the API unification

v1: https://lore.kernel.org/virtualization/20221227022528.609839-1-mie@igel.co.jp/
- Initial patchset

Shunsuke Mie (7):
  vringh: fix a typo in comments for vringh_kiov
  tools/virtio: enable to build with retpoline
  vringh: remove vringh_iov and unite to vringh_kiov
  tools/virtio: convert to new vringh user APIs
  vringh: unify the APIs for all accessors
  tools/virtio: convert to use new unified vringh APIs
  vringh: IOMEM support

 drivers/vhost/Kconfig      |   6 +
 drivers/vhost/vringh.c     | 721 ++++++++++++-------------------------
 include/linux/vringh.h     | 147 +++-----
 tools/virtio/Makefile      |   2 +-
 tools/virtio/vringh_test.c | 123 ++++---
 5 files changed, 357 insertions(+), 642 deletions(-)

-- 
2.25.1

