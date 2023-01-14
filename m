Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21B866ADFC
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 21:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjANU7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 15:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjANU7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 15:59:12 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57287EEB;
        Sat, 14 Jan 2023 12:59:11 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4665540D4004;
        Sat, 14 Jan 2023 20:59:08 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4665540D4004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1673729948;
        bh=3Oq00IfqOtOdi3g6M1vZR76lNmzfl7MBMJEOs/QgFuA=;
        h=From:To:Cc:Subject:Date:From;
        b=FthlVSAdNArH6cL6VX1pb5Yu5mwSpDBQc216fUToPnI18P1R78KVZx207QDARX8gl
         +LHbR9uDqXLB23AiRMdZ/y3wLSFgYTqRVxtlXa1zcEucrGDLEURYL63vF33P+Grw6x
         OAKLfBmLusgXQt//Q6mVrSmk6T/N6mMu3qb+EFHY=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] xfrm: fix rcu lock in xfrm_notify_userpolicy()
Date:   Sat, 14 Jan 2023 23:58:48 +0300
Message-Id: <20230114205850.176370-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
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

Syzkaller reports suspicious RCU usage in xfrm_set_default in 5.10 stable
releases. The problem has been fixed by the following patch which can be
cleanly applied to 5.10 branch.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
