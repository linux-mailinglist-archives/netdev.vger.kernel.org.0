Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEE34FAFBE
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 21:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbiDJTS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiDJTSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 15:18:24 -0400
X-Greylist: delayed 562 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 10 Apr 2022 12:16:10 PDT
Received: from mail.dr-lotz.de (mail.dr-lotz.de [IPv6:2a01:4f8:161:6ffe::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D0D3614A;
        Sun, 10 Apr 2022 12:16:09 -0700 (PDT)
Received: from linus-pc.. (ipbcc0dc80.dynamic.kabel-deutschland.de [188.192.220.128])
        by mail.dr-lotz.de (Postfix) with ESMTPSA id C24EC6CC2C;
        Sun, 10 Apr 2022 21:06:43 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=lotz.li; s=202112;
        t=1649617604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oHGVSKjxLfGZ9kXsGPLVJ4mzKISbI8GOmRKzSRzUt0s=;
        b=A/ZKGj0injh20M74Z3KxdU2m+7O07kre3ZLBw/sDtueWWUVQkzTycmU85sZa4UMfETcjJ6
        A/ngVay/QRPV4gDA==
From:   Linus Karl <linus@lotz.li>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: wireguard: add netlink mcast on endpoint change
Date:   Sun, 10 Apr 2022 21:06:34 +0200
Message-Id: <20220410190635.1171195-1-linus@lotz.li>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_20,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the possibility to retrieve notifications of peer
endpoint changes via netlink multicast messages. It has been a while
since I posted v2, the main difference is that I've added an extra
attribute to the netlink device attributes to allow enabling or
disabling of this feature. It is per default disabled.


