Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236A257C6D8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiGUIwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiGUIwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:52:42 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB547F508;
        Thu, 21 Jul 2022 01:52:41 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 49AF11008B38A;
        Thu, 21 Jul 2022 16:43:54 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 308B92008B6BB;
        Thu, 21 Jul 2022 16:43:54 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3mHLLvL0qIkv; Thu, 21 Jul 2022 16:43:54 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id CDB8120089230;
        Thu, 21 Jul 2022 16:43:41 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC 0/5] In virtio-spec 1.1, new feature bit VIRTIO_F_IN_ORDER was introduced.
Date:   Thu, 21 Jul 2022 16:43:36 +0800
Message-Id: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When this feature has been negotiated, virtio driver will use
descriptors in ring order: starting from offset 0 in the table, and
wrapping around at the end of the table. Vhost devices will always use
descriptors in the same order in which they have been made available.
This can reduce virtio accesses to used ring.

Based on updated virtio-spec, this series realized IN_ORDER prototype
in virtio driver and vhost.

Guo Zhi (5):
  vhost: reorder used descriptors in a batch
  vhost: announce VIRTIO_F_IN_ORDER support
  vhost_test: batch used buffer
  virtio: get desc id in order
  virtio: annouce VIRTIO_F_IN_ORDER support

 drivers/vhost/test.c         | 15 +++++++++++-
 drivers/vhost/vhost.c        | 44 ++++++++++++++++++++++++++++++++++--
 drivers/vhost/vhost.h        |  4 ++++
 drivers/virtio/virtio_ring.c | 39 +++++++++++++++++++++++++-------
 4 files changed, 91 insertions(+), 11 deletions(-)

-- 
2.17.1

