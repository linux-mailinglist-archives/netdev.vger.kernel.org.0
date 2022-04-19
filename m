Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44945070BE
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350199AbiDSOkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353496AbiDSOkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:40:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B736921273
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:37:29 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m14so22725238wrb.6
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAoCs5pjIvVq0WUVbkPFNkpe/cBJpZ+m8wLESWjQmHM=;
        b=Fw/TC1aAKoiFBFqe9HfnKnvddvU5kKXLOLwA0ePOD7fNxZ9+gYhAOphknG38vrxGgw
         IxLTjWgSTfv34tgvywZ7Q89+LqcGOjutmrqAPcQOvOrVxkxeSwk7GqTtjJPiFN8ZYA1a
         b3X+AIdGZARg+/ggcR3d21ddTopl4CVBLfU9aYTSBbOipxGYW8fvOdrMi920X6JfXcRF
         JEr0Um+ALTBEdpAB0C0gQs01zBAJ7yETVZMnhFKr0qvSol5yYMWfs4OC9COl7xqh7JH/
         Xl7G1rFt0o6qljvZEJWm2GdBQK2P9XkTF67izdvnAA6t6LYPDTD4l6G/9ThIURIiETBm
         0OCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAoCs5pjIvVq0WUVbkPFNkpe/cBJpZ+m8wLESWjQmHM=;
        b=Z1OvQiJQpb4LUCti7scdgCJpou/XBu2JBTrWy2fZ+He0ZvQIA102wV6+7nJbg7qOHN
         NiXSMWf0ujr7/LOs/E3UfHbCYfClC2Q9CzrqD4/IK/5l5Wav/7qHBh/QMdeSRw9mJfF5
         UPUrBwmUi8Y4h88DXkHTha8n5xDMsRnPJ+19MMJKbzVtLiRduKTDLhYT300y94nk+zBP
         xu4bo8PAjdgPUxYo6ySYmUJHlHJ/RINnDj/bUkSRDiMVRZta8EZa7hp73oOJ6t9ERSoV
         Vx3Vel9Wmg5aR/AnY0m4EovuFPF7+K/ZBX4FccjlDNiUShKkvquo/iTeT8YukiJAWZrH
         S0Dw==
X-Gm-Message-State: AOAM533E2oLQhf3UpwDuRNtJ/48SKM4zz6WYdu1El16AEl+ayOsXpQz/
        byIYPVCD2K9oALNLkYIKtbE=
X-Google-Smtp-Source: ABdhPJzt3C+DhPNcElXoPQEFk8KB8lS5/Zk0RibUrk6gs+yw34wRbDlgwnGxoMfnTPFSZ2lB6N9MDA==
X-Received: by 2002:a5d:5544:0:b0:20a:819d:5249 with SMTP id g4-20020a5d5544000000b0020a819d5249mr11878383wrw.461.1650379048185;
        Tue, 19 Apr 2022 07:37:28 -0700 (PDT)
Received: from alaa-emad ([102.41.109.205])
        by smtp.gmail.com with ESMTPSA id m20-20020a05600c3b1400b0038ebbbb2ad2sm19165526wms.44.2022.04.19.07.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 07:37:27 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com,
        roopa.prabhu@gmail.com, jdenham@redhat.com, sbrivio@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next 0/2]  Propagate extack to vxlan_fdb_delet
Date:   Tue, 19 Apr 2022 16:37:16 +0200
Message-Id: <cover.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.35.2
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

In order to propagate extack to vxlan_fdb_delet and vxlan_fdb_parse,
add extack to .ndo_fdb_del and edit all fdb del handelers


Alaa Mohamed (2):
  rtnetlink: add extack support in fdb del handlers
  net: vxlan: vxlan_core.c: Add extack support to vxlan_fdb_delet

 drivers/net/ethernet/intel/ice/ice_main.c        |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c           |  4 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |  2 +-
 drivers/net/macvlan.c                            |  2 +-
 drivers/net/vxlan/vxlan_core.c                   | 15 +++++++++++----
 include/linux/netdevice.h                        |  2 +-
 net/bridge/br_fdb.c                              |  2 +-
 net/bridge/br_private.h                          |  2 +-
 net/core/rtnetlink.c                             |  4 ++--
 9 files changed, 21 insertions(+), 14 deletions(-)

--
2.35.2

