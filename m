Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD759314B
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiHOPIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiHOPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:08:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 681EA1402D
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660576124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nAgtT0Syw9r2IhDE8LiMcKruJXGXHfwKR2v/ZTv3Guc=;
        b=ixVpHmmj5AVDNYpjt6RpBs3qyCB5QzoQul1+K4DbjGmBvzt4SKDSUeBdxXRtEuyNrTEwWY
        quMpBL9VtnhXluYxZO9bwgoEwxh23QIeQrGNWY2aAofAlogUD9L2fqUcpSBO4BXKf+outJ
        1Biuzfr43w9rrq0ZLZvUeRmiEGkdDGs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-h8GHc1GPOxSUlKhkB9ceiA-1; Mon, 15 Aug 2022 11:08:41 -0400
X-MC-Unique: h8GHc1GPOxSUlKhkB9ceiA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A567101A586;
        Mon, 15 Aug 2022 15:08:41 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDAA6492C3B;
        Mon, 15 Aug 2022 15:08:40 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     liuhangbin@gmail.com
Subject: [PATCH net v3 0/2] bonding: 802.3ad: fix no transmission of LACPDUs
Date:   Mon, 15 Aug 2022 11:08:33 -0400
Message-Id: <cover.1660572700.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds some kselftest infrastructure and the reproducer
that demonstrates the problem. The second patch fixes the issue.

v3:
 * rebased to latest net/master
 * addressed comment from Hangbin

Jonathan Toppins (2):
  selftests: include bonding tests into the kselftest infra
  bonding: 802.3ad: fix no transmission of LACPDUs

 MAINTAINERS                                   |  1 +
 drivers/net/bonding/bond_3ad.c                |  3 +-
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  6 ++
 .../net/bonding/bond-break-lacpdu-tx.sh       | 81 +++++++++++++++++++
 .../selftests/drivers/net/bonding/config      |  1 +
 .../selftests/drivers/net/bonding/settings    |  1 +
 7 files changed, 93 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/drivers/net/bonding/Makefile
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/config
 create mode 100644 tools/testing/selftests/drivers/net/bonding/settings

-- 
2.31.1

