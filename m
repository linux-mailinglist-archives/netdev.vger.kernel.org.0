Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE306638EAB
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 17:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiKYQ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 11:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiKYQ4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 11:56:17 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF522B24E
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 08:56:15 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669395374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=y6Y6xRPTJ8X9Sc7RnuXPiOzTppXiFO1cpkcepue18L8=;
        b=ouDaVcUZu3nh0YdDDYhEWMTGP+rq5/wAmumsk037SEvsNXr4L6mVAJf8llTPQr+G5+Vis+
        KHJ3rIxo1ERGxvAd6mNof56GDwaRoGCY097X+dj3ihhpv6JlPuG7p8BbvhYOzj0+GmkaC0
        WavgHFrCzGVGSox/7G5yerOv4w4qSW1DhHPWE1MySD5S5Wbjeg1NaBMcaCq+sAKjvNP+ew
        15YGGI0COJI3zBKanYiOCtfdDu6U9vcaiyV9Qamewq/Qh23bzDrkG2J+0HNqcTij0J62+R
        Zct1qARK+VRWnb2nNa647hUO8rKcw3Ic9Ip6c9YHPzW3t24PpQcetlmmuE912A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669395374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=y6Y6xRPTJ8X9Sc7RnuXPiOzTppXiFO1cpkcepue18L8=;
        b=8zmKB81becsT4VoT7+JWIp+RdH57rQenGuIzZxIcrR5E/1IrHTRDQ3BEhVoIKYpoKv85fv
        5PA+n+DVwGw/cgAw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v4 net-next 0/8]: hsr: HSR send/recv fixes
Date:   Fri, 25 Nov 2022 17:56:02 +0100
Message-Id: <20221125165610.3802446-1-bigeasy@linutronix.de>
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


