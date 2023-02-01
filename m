Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD15686D2B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjBARgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjBARgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:36:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D747DBCA
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675272903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5X1LhIlH+FTe7KXfPlTsNNBHQmiO7Yhp41s5mysUZys=;
        b=bSqcju8ffPMoUygVHcuAKGhRKMHvhE7ZpKNsNLw+o8pDrH6RonCYALg558/Zkp4AUwwpM2
        HDBop7jrkGgpg0yXcQJ7j4FN4pEJ2g+RfXISuPhlsvQj8IGsRGw/s0m7o/SVYFn2M2+9Np
        o6QT+K5aWYEz2pBca2MJIV1jrKWtq/w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-VbRmtSLFOpW7LAw_BFKHYQ-1; Wed, 01 Feb 2023 12:31:48 -0500
X-MC-Unique: VbRmtSLFOpW7LAw_BFKHYQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F0F4857A94;
        Wed,  1 Feb 2023 17:31:47 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 996A0492B01;
        Wed,  1 Feb 2023 17:31:46 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3DD2D300005EE;
        Wed,  1 Feb 2023 18:31:45 +0100 (CET)
Subject: [PATCH bpf-next V2 0/4] selftests/bpf: xdp_hw_metadata fixes series
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Date:   Wed, 01 Feb 2023 18:31:45 +0100
Message-ID: <167527267453.937063.6000918625343592629.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a number of small fixes to the BPF selftest
xdp_hw_metadata that I've run into when using it for testing XDP
hardware hints on different NIC hardware.

Fixes: 297a3f124155 ("selftests/bpf: Simple program to dump XDP RX metadata")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

---

Jesper Dangaard Brouer (4):
      selftests/bpf: xdp_hw_metadata clear metadata when -EOPNOTSUPP
      selftests/bpf: xdp_hw_metadata cleanup cause segfault
      selftests/bpf: xdp_hw_metadata correct status value in error(3)
      selftests/bpf: xdp_hw_metadata use strncpy for ifname


 .../selftests/bpf/progs/xdp_hw_metadata.c     |  6 +++-
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 34 +++++++++----------
 2 files changed, 22 insertions(+), 18 deletions(-)

--

