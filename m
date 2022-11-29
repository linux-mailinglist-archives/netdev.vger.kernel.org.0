Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8495E63C5C8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbiK2Q54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbiK2Q5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:57:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA50461770
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:51:42 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669740700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LHfs9Vmr928LRqp1AfSItw1SmfHZ7Z00IFuiSPwV1RE=;
        b=Vmj8Bs/Mmft4qqZZpgbegxWxQCqYHjYMVkmPi0nACsewAT5qMI+2vKC9Uf6B1WoEFlEsJt
        2iU/fAoAVxOwXtZn8+GWkOQeT+XbH6jRkVvE32Phh1WihQLtVHr/1YGMfi7AWrQT4BAnOx
        D67PuPvXw7L1OAx4yRoyVVMy7nrcVyxEuDijB6z94iOkzvOxppCWCaWWM8mhbOUZltk/mV
        0VVeldZILZuAD6WnGco4b01qRUG1tnybK4n6JDnu8PP4PZ2VX8j4bmssQjhR+LR3kcijBu
        V8HZDbHH9UdY+yOxmlSsVJEP8yZerjL2sOVN9/8aYdyDhbIkTZjxydFVeb0GGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669740700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LHfs9Vmr928LRqp1AfSItw1SmfHZ7Z00IFuiSPwV1RE=;
        b=hEKe1NKUb5K0rer9I2ed9HuIhXx0fhXeubGrBNFDYWTUL4AV7LccvJESMr24u4YcPEFSZ8
        8q6o7cmkw8XcPzCg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v5 net-next 0/8]
Date:   Tue, 29 Nov 2022 17:48:07 +0100
Message-Id: <20221129164815.128922-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I started playing with HSR and run into a problem. Tested latest
upstream -rc and noticed more problems. Now it appears to work.
For testing I have a small three node setup with iperf and ping. While
iperf doesn't complain ping reports missing packets and duplicates.

v4=E2=80=A6v5:
- Added __rcu annotation ub patch #7
- Spelling fixes in #2 and #6.

v3=E2=80=A6v4:
- Targeting net-next now.
- Added patch #7 back to basket. Kurt's review comments are addressed.
- Added a basic test for HSRv0.

v2=E2=80=A6v3:
- dropped patch #7 was an optimisation.

v1=E2=80=A6v2:
- Replaced cmpxchg() from patch #6 with lock because RiscV does not provide
  cmpxchg() for 16bit.
- Added patch #3 which fixes the random crashes I observed on latest rc5 wh=
ile
  testing.

Sebastian

