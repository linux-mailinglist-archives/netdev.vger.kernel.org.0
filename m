Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7858C6BAF10
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjCOLUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjCOLUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:20:22 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C662194E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:19:55 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a32so19034250ljr.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678879191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mayWXEFCGtctFGj66s8NV1487XfOB+mavuH2lYnfXow=;
        b=T4I2Y4UHNkVxsR14bpYvY9Q7BeuM/vpHnsEGlsCUFQVa5kvLQApZIQXs6AJI02VZ4e
         blio2VuYs0/MNQpzzBw37NaTjPLt3r/zE3bcEHTiXr80ELa7Q5eS6NqKp/cdtyJYtMsw
         4dYnkLMKU2gAL7YQqEuuOKdtfLdtgQgUFRD/mEIqeFB/5c5Bx2twRydB8MI8Qvz/hZAP
         zO5Lv8XIa4KkuUnseivryVr++KcgMgvKXQesv494ac0gfHc+3K6CIz+ROSf8EwnlZyxK
         9yoDcxkywTxh9CbwwWTL7nZY/dc+MxD3NplIN//JQKBxSCEsyOfkX6LsDT65kxWcQAss
         O9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678879191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mayWXEFCGtctFGj66s8NV1487XfOB+mavuH2lYnfXow=;
        b=uHLHcwM9hJoHDjLqZGgokzxZezeDTX2etUh+qpTeu3qqCrF/HGjfoh4eMNZGr5V1F0
         zXbM1GXEi4DUbcVACWEEcr3pMCF2ZJUzLkk8fwe6CVebZhcVYuH9pFmAygRiDaphe4Sv
         dZsDcWStWZX5bVYbWXvQLQxlawbCvcmZ763LfsIYHFqQHwECHgnhXgcVabwAyNveIS9V
         4DEgFkuI5D9mBu6Czm05OJMh4KxtM2yJQnub+Ds6eaoMqetwlzMtlXwNLpMyQwbZho/J
         JM1EEhoa4BqA1cwhGJpV0qO1ByRXCy1YiRYoaLfmQ8EJe77PmG1jYulkq4+UycXs9gYh
         Q5PQ==
X-Gm-Message-State: AO0yUKUFKR64csym/3PH7LiO23zVp/4Y9IJaQ5PzyU6hLEh7knrY382k
        1DK7jusyXuYvlEKR7g8DJT5J6o87VpSigdQuUaRTYw==
X-Google-Smtp-Source: AK7set/XPcOnh5icVQb5O1HaSh66opubcvxzrUhKZ/aYakdjSGbWCHeQxGd3ZaDldbGEdholW2scCw==
X-Received: by 2002:a05:651c:198d:b0:295:8f08:118b with SMTP id bx13-20020a05651c198d00b002958f08118bmr1034912ljb.18.1678879191316;
        Wed, 15 Mar 2023 04:19:51 -0700 (PDT)
Received: from kofa.. ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id 20-20020a2e1654000000b00295a8d1ecc7sm829218ljw.18.2023.03.15.04.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:19:51 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        michal.kubiak@intel.com, jtoppins@redhat.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v3 0/3] bonding: properly restore flags when bond changes ether type
Date:   Wed, 15 Mar 2023 13:18:39 +0200
Message-Id: <20230315111842.1589296-1-razor@blackwall.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
A bug was reported by syzbot[1] that causes a warning and a myriad of
other potential issues if a bond, that is also a slave, fails to enslave a
non-eth device. While fixing that bug I found that we have the same
issues when such enslave passes and after that the bond changes back to
ARPHRD_ETHER (again due to ether_setup). This set fixes all issues by
extracting the ether_setup() sequence in a helper which does the right
thing about bond flags when it needs to change back to ARPHRD_ETHER. It
also adds selftests for these cases.

Patch 01 adds the new bond_ether_setup helper and fixes the issues when a
bond device changes its ether type due to successful enslave. Patch 02
fixes the issues when it changes its ether type due to an unsuccessful
enslave. Note we need two patches because the bugs were introduced by
different commits. Patch 03 adds the new selftests.

Due to the comment adjustment and squash, could you please review
patch 01 again? I've kept the other acks since there were no code
changes.

v3: squash the helper patch and the first fix, adjust the comment above
    it to be explicit about the bond device, no code changes
v2: new set, all patches are new due to new approach of fixing these bugs

Thanks,
 Nik

[1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef

Nikolay Aleksandrov (3):
  bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type
    change
  bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails
  selftests: bonding: add tests for ether type changes

 drivers/net/bonding/bond_main.c               | 23 +++--
 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
 3 files changed, 103 insertions(+), 8 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh

-- 
2.39.1

