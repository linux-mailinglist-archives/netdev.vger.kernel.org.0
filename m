Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6657C0EC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiGTXgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiGTXgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:36:09 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5BA3F335
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:36:09 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 7-20020a17090a08c700b001f225490835so923603pjn.7
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aQrGPJR17lmJnXe4JQSkdLd3fsLqXa+0sk3zvKl8a9Q=;
        b=sGTXT1xAwxj8cmzJ9miCE24XB9YINb+O+i1wBcZcZ7m4agLhd1W6nUVTe2SiNt3uT4
         r4Py3ionEdmB4NiBBqSmNHh3m7Zu3fRyGAx1Qp2gdBb9d2XytZCYpX15rGG4dANve3kC
         t4iUs15VJJ4aJmd2iQBSmSpLanUIKYrbhVsAu4BFX5bRz8wmdjOZ67NLamN1MN/llKXz
         BtHptIrE6krUH+rftVbBGztURvWMXtvVZ9zRszVjvQp/7pLWwe0VEi3BnpDpMNQcbKWc
         ha0DKeqxtvA8cIxqcrXwafCSxF3cbby2vBxnZMNospvN1TlJnJusIEWdQQMmFeJqa6xl
         VJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aQrGPJR17lmJnXe4JQSkdLd3fsLqXa+0sk3zvKl8a9Q=;
        b=8BCzyt9XcjWTfAfvx7oPsA++NCsk3f1I23ZmYtPSJOQvbgX2/cLAJnY2PjX1iE49aJ
         Q0oO/sUokZzdXZ56RQAVa7jtO44sJ2iLv2w7WizT+RhSB0RY4zHldB9YK4IsgT/zhABS
         1tVgQ6zRSryueCNOEHYeCA381hKaggjEJqfuP6fIUHEC/rV9PfNJsRt8eNqV7kgm4ZaN
         QO0yHe9hhOHGUQ9T79Lep7upHztYWKyGYlN7T4fghXWd1c2spFG4Pu9qYCtG1q+09n3N
         sdfus7HZxPcg9qtdZNZ2aItP8QYgrO7j5+J3p0QXjC6XAV6+fLgorUNWuWFIjeZFMA/h
         OPPA==
X-Gm-Message-State: AJIora95c5w4dHGEswIpRv7Is0TAbzGwMrfBFUQ7yg4ialgkFTT2HxXv
        3GLUdDhmriISn7x+9gF8SPS5HI9XjGuS
X-Google-Smtp-Source: AGRyM1t5aOID38OPghaC4aS98F2ngwbOeYnycrlhpNISQR5l3WI228w37Y/URSoaeqTanAErfusjf2tR7KGg
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a05:6a00:b92:b0:52a:e60d:dfbb with SMTP id
 g18-20020a056a000b9200b0052ae60ddfbbmr41195872pfj.72.1658360168868; Wed, 20
 Jul 2022 16:36:08 -0700 (PDT)
Date:   Wed, 20 Jul 2022 16:36:00 -0700
Message-Id: <20220720233601.3648471-1-jiangzp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kernel PATCH v1 0/1] Fix get clock info
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Similar to get conn info function, the function to get clock info also
need to set connection data.

Fixes: 5a75013746640 ("Bluetooth: hci_sync: Convert MGMT_OP_GET_CLOCK_INFO")

Changes in v1:
- Fix input connection data

Zhengping Jiang (1):
  Bluetooth: Fix get clock info

 net/bluetooth/mgmt.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog

