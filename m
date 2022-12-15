Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C855664D525
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiLOCBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLOCBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:01:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50412E9F4
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:01:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A36B81A26
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7280BC433D2;
        Thu, 15 Dec 2022 02:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069667;
        bh=zOlTk/6pHnM0CetwqbWzkgIL5X9+6zuAbu5KftCen4U=;
        h=From:To:Cc:Subject:Date:From;
        b=krlwwpU3JiLF0DxTASXIaUBZ7XQaBB95u4wYlUh5UwH+s9iFWosCHqc6tUdJ7/2Ms
         xl9j+u/MXuVmR2UNZ2o7kppFeIDgI02EPaiw0xvsIWiuuWsIOu35d8F6hEkoHG3JPt
         0sQ0UMazdVBg0og6FdqfKze2NOKBhyfXasDEYWi7OFGpOpMIDsJU32kidheU0lYqDx
         bbISTn+pSAH6lPOwhUUBrvntG1HlB0H+AU6VbmK1hX5uFYlaug6kwiW7zcidYZIexZ
         OoZmOe7RU0ZA8RyoBeZxsjzUBTRagrEoTgTJvD0eFlPacoZs46SzBfVx0L441LDlXN
         cEL4gSOd86k5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] devlink: region snapshot locking fix and selftest adjustments
Date:   Wed, 14 Dec 2022 18:00:59 -0800
Message-Id: <20221215020102.1619685-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor fix for region snapshot locking and adjustments to selftests.

Jakub Kicinski (3):
  devlink: hold region lock when flushing snapshots
  selftests: devlink: fix the fd redirect in dummy_reporter_test
  selftests: devlink: add a warning for interfaces coming up

 net/core/devlink.c                                  |  2 ++
 .../selftests/drivers/net/netdevsim/devlink.sh      |  4 ++--
 .../selftests/drivers/net/netdevsim/devlink_trap.sh | 13 +++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.38.1

