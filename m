Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D3E633431
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiKVDup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiKVDuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:50:44 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3923C2AE36;
        Mon, 21 Nov 2022 19:50:42 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VVQNJuU_1669089038;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVQNJuU_1669089038)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 11:50:39 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        John Fastabend <john.fastabend@gmail.com>, toke@kernel.org
Subject: [PATCH 0/2] Revert "veth: Avoid drop packets when xdp_redirect performs" and its fix
Date:   Tue, 22 Nov 2022 11:50:13 +0800
Message-Id: <20221122035015.19296-1-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch 2e0de6366ac16 enables napi of the peer veth automatically when the
veth loads the xdp, but it breaks down as reported by Paolo and John. So reverting
it and its fix, we will rework the patch and make it more robust based on comments.

Heng Qi (2):
  Revert "bpf: veth driver panics when xdp prog attached before
    veth_open"
  Revert "veth: Avoid drop packets when xdp_redirect performs"

 drivers/net/veth.c | 88 +++++++---------------------------------------
 1 file changed, 12 insertions(+), 76 deletions(-)

-- 
Previous discussion in
https://lore.kernel.org/all/ce5fe56b-bf1b-71c0-1e96-cff6fde40ff3@linux.alibaba.com/

2.19.1.6.gb485710b

