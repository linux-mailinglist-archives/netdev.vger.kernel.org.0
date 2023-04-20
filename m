Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BBC6E8C9C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbjDTIWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbjDTIWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:22:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36C949FF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a6715ee82fso9344565ad.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681978958; x=1684570958;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RTLl1gibxMFESd2oMZP40Ez/69aWp+mg2khOBy3moc8=;
        b=JFEsnwOp+XITySHnu76RXCZgmKJGPnnkYTwHnNmfFIxGOVLYSp7UcTMnbKPj8TErRf
         jxfRcnMjieldktVxaCxe9N3OqiNo5auMvhc08XuleN5oWqSS20Fuq/JHhavFQxFKaZx6
         Dr6C4st8bu5myJcQjfIc9AHU6/Hno0U6y83+RtqrWDwxei5XZjbD7oE4D0KdPE+wmY6P
         XiGQiqPM+IuT9mlHNeYBewTZ+Uy5OEFmqjDVwbvO1WDTocFLCUt00I9Zl7sfubInXeBc
         QoBww2bAX3lovtJpBbiquCoQS12juFjfyqcTwLwbHYrL+bXdWpCZfclRa6zMqnBJzI3A
         m/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681978958; x=1684570958;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RTLl1gibxMFESd2oMZP40Ez/69aWp+mg2khOBy3moc8=;
        b=T9g+IYIn9VWWDL3o8EoKNAQ7Vd/SK9voXXqFwIP722FeLGAXPjgLOfncUOqyuMF9Fb
         eGIMsCbeOYTVGG6mkrfCb5vtFw64fEdxwKc66RZXscBxxPtYOw9PeAzR47Kbkf4cNB0p
         /cJr/JYyawqfmlRjiBDCHG2lVEae4o3BsgkH+Wfk8JBjmT3+eUulgbY0pjzR3MblZuAp
         xWKSGxqRMAXToEGMT4rNbwuVo0UCadGC9YraIu5XD4hGCFAQVoiVYzi/7FrJrcjcjtaM
         A0HzaJTtxa4jJfrX2eYwtWGO8Y4lgs/NinLZWVmf5LjFd3KearM7uq4oistx+Vdxy3Ko
         7M6Q==
X-Gm-Message-State: AAQBX9fvHxIOn2vd5ypCEL/GU6Zd4H21yEGSfh55iOOhLgrrnsaExst5
        xM/JYRd8SadPOv4ptpMZCFo7Fo4ef0hEL6CE5O4=
X-Google-Smtp-Source: AKy350aLAMyDcXLalfXYYnaUeVYHYZUN+74tex+BlPFti7Eqgu2PknpXjunMDIMMp7j8pUhDWvL99A==
X-Received: by 2002:a17:902:e403:b0:1a6:91f0:f7fd with SMTP id m3-20020a170902e40300b001a691f0f7fdmr515939ple.60.1681978958573;
        Thu, 20 Apr 2023 01:22:38 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902d34b00b001a1ed2fce9asm662175plk.235.2023.04.20.01.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:22:37 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/4] bonding: fix send_peer_notif overflow
Date:   Thu, 20 Apr 2023 16:22:26 +0800
Message-Id: <20230420082230.2968883-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonding send_peer_notif was defined as u8. But the value is
num_peer_notif multiplied by peer_notif_delay, which is u8 * u32.
This would cause the send_peer_notif overflow.

Before the fix:
TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
4 garp packets sent on active slave eth1
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [FAIL]
24 garp packets sent on active slave eth1
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [FAIL]

After the fix:
TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [ OK ]

Hangbin Liu (4):
  bonding: fix send_peer_notif overflow
  Documentation: bonding: fix the doc of peer_notif_delay
  selftests: forwarding: lib: add netns support for tc rule handle stats
    get
  kselftest: bonding: add num_grat_arp test

 Documentation/networking/bonding.rst          |  7 ++-
 include/net/bonding.h                         |  2 +-
 .../drivers/net/bonding/bond_options.sh       | 50 +++++++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh     |  2 +
 tools/testing/selftests/net/forwarding/lib.sh |  3 +-
 5 files changed, 58 insertions(+), 6 deletions(-)

-- 
2.38.1

