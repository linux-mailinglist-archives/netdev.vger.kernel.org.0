Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D698E53EBEC
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbiFFP1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 11:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240618AbiFFP1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 11:27:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90FAF218
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 08:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654529227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HOVlxKmkvQU45HEfKJfQhbyTwCjsI8mky9EMcmojfQA=;
        b=Dt5HI9nx1HJqizd+98Hgokp95xgPZONpiVPEgVkfhv/ZpFlFzPHPs9xJfFH/i3dtU6QC9R
        /pzFM1C3SfISBsSypiv3SukceOrTvbbLK8YdSl8tfU5xUa36HS4ce3uwieXz9rwH6QzYwc
        +jKFV6e4Ytai27+haVlj7PBW/6hSW5Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-zk2rfUW4P5eHJo35j2JXeQ-1; Mon, 06 Jun 2022 11:27:06 -0400
X-MC-Unique: zk2rfUW4P5eHJo35j2JXeQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD8501C1CB84
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 15:27:05 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB47A9D7F;
        Mon,  6 Jun 2022 15:27:05 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com
Subject: [net-next 0/2] bonding: netlink errors and cleanup
Date:   Mon,  6 Jun 2022 11:26:51 -0400
Message-Id: <cover.1654528729.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch attempts to set helpful error messages when
configuring bonds via netlink. The second patch removes redundant
init code for RLB mode which is already done in bond_open.

Jonathan Toppins (2):
  bonding: netlink error message support for options
  bonding: cleanup bond_create

 drivers/net/bonding/bond_main.c    |  24 ++-----
 drivers/net/bonding/bond_netlink.c | 101 +++++++++++++++++++----------
 drivers/net/bonding/bond_options.c |  29 +++++++--
 include/net/bond_options.h         |   3 +-
 4 files changed, 98 insertions(+), 59 deletions(-)

-- 
2.27.0

