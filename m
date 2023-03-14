Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474326B9158
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjCNLQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjCNLQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:16:12 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C07A14EBA
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:36 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so2971901wmb.2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678792534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X+7l+PKInl850bETQx5C0f3hzcmbGkE9Nyy5sjYPUlI=;
        b=TiHy2Cf95RkdQtKyD8stBWy7CvuSlnM+vei/tY70woH4BTryB3UwqBb+j+7yaMwO2x
         yvSgChtE5XYugBcnODJZnjyicSPoKc24oHgOdFzmq6eePyxuluKGTYGwgIOGn4iVL7Ms
         oSaUsooNdHesj7rkroIGrAYQMxT656f3oi/Y+f0WAPeyLd9z44HQ4Sc9k2VN1eTsZKla
         rI60tuoD7ZxxTxftlBFIAQaXzIj1oawa9FkVeS+biVeEWgAJUUc+sOeSzibd3iKql5ec
         eur9BRcNBQlQ8dox4zI986YJH1HzGn6aaWjs5tI//HDo/hoSK4N87vjjK8T968kdCcLP
         s2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678792534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X+7l+PKInl850bETQx5C0f3hzcmbGkE9Nyy5sjYPUlI=;
        b=tNJ1Tr7jDox3d/Ly52G0EqW8uzdRLpkf/quFWMli94kiolPKDlVTuJZ9ExNK40ObcZ
         yZr8xRSpfGdC5R8ZgyP1eMs9cjpml2y3FDbWRWOsjXKwlxUIUV7/zYegwYfhEyhdrLgv
         DU7DbMXw3X48H2zytTtgvhacj9Dw4Hf0yIaDNPyG+oBqFa93PFEa+8UXTRXSjGipbq6K
         nPgqz7y7vZkxFzWMziyD9S7CVotoDffRtiBAcvdV+nKjCfa75DLjCEi4rainyyRYwwQG
         gAk0QCaweQw+UKgKKqFK8xLtmREsRHRipYJBSe4E/yjlpw+ujCiJuXxRMdnByYGK+Gqr
         HwLQ==
X-Gm-Message-State: AO0yUKW4zzgxzWbdpjHAB4T5dhAccTSH8m0V2WFOSQHX+bMXehiU8v0X
        mxpSjD2OmvmYDBp/OYJU0H6BW+LwHA3suSZPTxg=
X-Google-Smtp-Source: AK7set9tleTWgclYqdlCeprR6Yq4LcBSGE1MvZvk7/h9LnHp2cO2s3z6007PClH36YH+folzEj1QWQ==
X-Received: by 2002:a05:600c:1d24:b0:3da:1f6a:7b36 with SMTP id l36-20020a05600c1d2400b003da1f6a7b36mr13506603wms.0.1678792534125;
        Tue, 14 Mar 2023 04:15:34 -0700 (PDT)
Received: from debil.. (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c2f8f00b003e1fee8baacsm2442323wmn.25.2023.03.14.04.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 04:15:33 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v2 0/4] bonding: properly restore flags when bond changes ether type
Date:   Tue, 14 Mar 2023 13:14:22 +0200
Message-Id: <20230314111426.1254998-1-razor@blackwall.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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

Patch 01 adds the new bond_ether_setup helper that is used in the
following patches to fix the bond dev flag issues. Patch 02 fixes the
issues when a bond device changes its ether type due to successful
enslave. Patch 03 fixes the issues when it changes its ether type due to
an unsuccessful enslave. Note we need two patches because the bugs were
introduced by different commits. Patch 04 adds the new selftests.

v2: new set, all patches are new due to new approach of fixing these bugs

Thanks,
 Nik

[1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef

Nikolay Aleksandrov (4):
  bonding: add bond_ether_setup helper
  bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type
    change
  bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails
  selftests: bonding: add tests for ether type changes

 drivers/net/bonding/bond_main.c               | 22 +++--
 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
 3 files changed, 102 insertions(+), 8 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh

-- 
2.39.2

