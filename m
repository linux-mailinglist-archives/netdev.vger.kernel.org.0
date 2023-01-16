Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC70F66C41E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjAPPkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjAPPkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:40:02 -0500
X-Greylist: delayed 1018 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Jan 2023 07:39:58 PST
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C240210D7;
        Mon, 16 Jan 2023 07:39:58 -0800 (PST)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd1e:0:640:7470:3316])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 2C8965FD4B;
        Mon, 16 Jan 2023 18:21:13 +0300 (MSK)
Received: from davydov-max-nux.yandex.net (unknown [2a02:6b8:0:107:fa75:a4ff:fe7d:8480])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0LllA20WE0U1-6db0o4fg;
        Mon, 16 Jan 2023 18:21:12 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1673882472; bh=kbMoegRaw557RfV/yayA0mkFwYPRLDIoXY9PttPGE1U=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=d8pOh1CmzLZpHBWlyqwq7fczYLkJslYH7CHkclr4gG9KZEiK9V6IBywvF9JgUMBwY
         dZDL1elCWPwEyJ3P78vaMXBrRo9gsopSvukzX8gTWQItd81KNETD3EmqWQN9x85kE8
         MFvtdccx8gya9Bh6xOtFf23BTjwtUXXvV8DJRr10=
Authentication-Results: sas1-7470331623bb.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Maksim Davydov <davydov-max@yandex-team.ru>
To:     rajur@chelsio.com
Cc:     davydov-max@yandex-team.ru, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        anish@chelsio.com, hariprasad@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] cxgb4: fix memory vulnerabilities
Date:   Mon, 16 Jan 2023 18:20:58 +0300
Message-Id: <20230116152100.30094-1-davydov-max@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes potential vulnerabilities in cxgb4 via additional
checks to make sure that we don't corrupt memory.

Maksim Davydov (2):
  net/ethernet/chelsio: fix cxgb4_getpgtccfg wrong memory access
  net/ethernet/chelsio: t4_handle_fw_rpl fix NULL

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c | 5 ++++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c     | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.25.1

