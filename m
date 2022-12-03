Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636B0641976
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiLCWYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLCWYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:24:35 -0500
Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C785015A1C;
        Sat,  3 Dec 2022 14:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RbdhlXXoe5aVhZ+1+W4Zdbyv2o4f8zympuEgxFctAV8=; b=QMxghBxPYh2tkjQEQmY/oPbR97
        fnBYMqmkxvBE6WoLyp2RtTmVu1cZluJ0RtdxKUZ1jpSOk1hdDg7OHwlmyOIycs+fSPWc5O0/I7RtT
        Xw0JGCH4pq0oCO5wNdO+n0llE5bZCPSQOYu5gL7TSPp2vk+TiSvDxoUVI3U4ZWO1FTVA=;
Received: from [88.117.56.227] (helo=hornet.engleder.at)
        by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p1aSr-0003Ir-6Q; Sat, 03 Dec 2022 22:54:29 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/6] tsnep: XDP support
Date:   Sat,  3 Dec 2022 22:54:10 +0100
Message-Id: <20221203215416.13465-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP support for tsnep driver. I tried to follow existing
drivers like igb/igc as far as possible. Some prework was already done
in previous patch series, so in this series only actual XDP stuff is
included.

Thanks for the NetDev 0x14 slides "Add XDP support on a NIC driver".

Gerhard Engleder (6):
  tsnep: Add adapter down state
  tsnep: Add XDP TX support
  tsnep: Support XDP BPF program setup
  tsnep: Prepare RX buffer for XDP support
  tsnep: Add RX queue info for XDP support
  tsnep: Add XDP RX support

 drivers/net/ethernet/engleder/Makefile     |   2 +-
 drivers/net/ethernet/engleder/tsnep.h      |  31 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 424 +++++++++++++++++++--
 drivers/net/ethernet/engleder/tsnep_xdp.c  |  27 ++
 4 files changed, 454 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c

-- 
2.30.2

