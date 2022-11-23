Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2369363590B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiKWKHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbiKWKGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:06:17 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1357D60EB
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 01:56:45 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669197404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UFgWsQqvLZQQEvES6h3v8w2UaPnwvvFy543nm+hVHzw=;
        b=EZqzRJVr6+3JfIsJIZxnperpKniT2aThk3jOiQcA8afvGyLFzpHN2saDkckDfJb/8Yiq3Z
        qVqb1iMansruMYAMlM6pJ42+aS6C3zl3wbtzZm62Dl/llf/JM8FJeu7EtN7gMFHVIMthVV
        /++tRAVayNr2hTA/1KE9O2uw7QRdfzJcJCG37FoxYfyxbQcp4l/h7LZSXxcBhcHFcJgl66
        Y1mfooIIiR7ERn/CY+KqZLRT0sH+wj17DYr9w2hIPVDJGT1Iv0114jboHY2895hLy+vJPy
        KRYJ8/C/KLazy1Qu7StXPLPFj9smjbljPSWhFd4H1hAHp0JDkYMRwLY3Mn1gag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669197404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UFgWsQqvLZQQEvES6h3v8w2UaPnwvvFy543nm+hVHzw=;
        b=GbYXott7VNnQrF9PC24nmD7q46gNKM0UFh5Z/e/b6bcJlY6iqlL+9YvxPd2XX5npukeS35
        G+mfYkWeO25BsoBg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net 0/6] hsr: HSR send/recv fixes
Date:   Wed, 23 Nov 2022 10:56:32 +0100
Message-Id: <20221123095638.2838922-1-bigeasy@linutronix.de>
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

v2=E2=80=A6v3:
- dropped patch #7 was an optimisation.

v1=E2=80=A6v2:
- Replaced cmpxchg() from patch #6 with lock because RiscV does not provide
  cmpxchg() for 16bit.
- Added patch #3 which fixes the random crashes I observed on latest rc5 wh=
ile
  testing.

Sebastian

