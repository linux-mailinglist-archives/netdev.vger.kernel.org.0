Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FB034A7D3
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhCZNKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhCZNKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 09:10:02 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1246C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:10:01 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id kt15so8287884ejb.12
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SXhqDQPCZEypry+Er08AOdGmNyz0WU0E2n3uSGKFTIU=;
        b=cYn2pqPiTxNodsnqmKjMTejdLi/ItVDR1qdjlUgVOwqCyOjbBODcaknjoLOIkGuIAO
         qRAptjqnbBXe64pu/CSyMXxT9IkQjBqADPXAOi1gW3OrvCPhMRhOjwhGqzON4ls13hxA
         SUaxZGx2GThmLeLq9KJU7rViApLHuc/nj/KjbOJOZtOCm8JULwRgyfhyjHvr0wi+OLkL
         M/1/yDpJjHoOep6gL0EKgexWqxbrHt8TAn96ioLqON6/L99k75AmO8tiTrHcpmWecVIM
         2lasw0o5+pbWpnUzGF/Uv0Wsgotpd4OUDUehXPfFpkd762Ex59kKBRJj5PmEls90JTSS
         fiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SXhqDQPCZEypry+Er08AOdGmNyz0WU0E2n3uSGKFTIU=;
        b=U/zd9Ajx9iJgpU5hhrH5unijy30fiwq1bDuXzHyJcbThdHJv9gXEQ0/XBoy5dOSqhQ
         SXEgWreHLPNd1Q7BoSmAYmOkYl4b/CbSfzLHBeaf7oCFZN14FhILuhcV7AIR8TIYY1Ro
         sAVr3Dqf9ib+3bTNusHn85g9+pMYGcg0+9pBk/C9qxL6hOfHFxgEGTQCtfdQVrxoDSQC
         MtCVuuPD/qQI5dYW+Jp0I/g1G6j+1M7r5K7xOYuRwHJwn7Qia9ScLcpRnAWGZPE55n67
         BYJnSeUhib44JpfjXyFNvq+ZqerZYJ2BsYaXA+ku5lI2eO1IuF+oChft4/R6o/UilBKX
         Ugeg==
X-Gm-Message-State: AOAM533Zch6XLMwI62fo120dyYSVImb1r9czqYFvwkdEBZuKs6pCDxtO
        g8Y8BgZpkjcVjCS3GVd9LgeKFg==
X-Google-Smtp-Source: ABdhPJxD5p+NE6uPd2symi2R8mbP5HxpbJW6DECQ8NHlflLqsm2b5RpiXCtoy2mIpfXX49jF0rcImQ==
X-Received: by 2002:a17:906:3385:: with SMTP id v5mr15337485eja.539.1616764200621;
        Fri, 26 Mar 2021 06:10:00 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id 90sm4202624edf.31.2021.03.26.06.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 06:10:00 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Ido Schimmel <idosch@idosch.org>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 0/2] selftest: add tests for packet per second
Date:   Fri, 26 Mar 2021 14:09:36 +0100
Message-Id: <20210326130938.15814-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add self tests for the recently added packet per second rate limiting
feature of the TC policer action[1].

The forwarding selftest (patch 2/2) depends on iproute2 support
for packet per second rate limiting, which has been posted separately[2]

[1] [PATCH v3 net-next 0/3] net/sched: act_police: add support for packet-per-second policing
    https://lore.kernel.org/netdev/20210312140831.23346-1-simon.horman@netronome.com/

[2] [PATCH iproute2-next] police: add support for packet-per-second rate limiting
    https://lore.kernel.org/netdev/20210326125018.32091-1-simon.horman@netronome.com/

Baowen Zheng (2):
  selftests: tc-testing: add action police selftest for packets per
    second
  selftests: forwarding: Add tc-police tests for packets per second

 tools/testing/selftests/net/forwarding/lib.sh |  9 +++
 .../selftests/net/forwarding/tc_police.sh     | 56 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/police.json   | 48 ++++++++++++++++
 3 files changed, 113 insertions(+)

-- 
2.20.1

