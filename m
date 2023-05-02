Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E206F3CBC
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjEBEb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEBEby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:31:54 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D17273A
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:31:54 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-763c34315c1so281634139f.3
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683001913; x=1685593913;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BGjIikjpohEyy1ETXcWSntMlWV5iKFN+fziqfGclfYA=;
        b=X6U4uJTdtM54r35yrVMlrsFKMj4WVFxgfgezy4jsd2zv50k8hur2NE4kbZrHw201Fs
         Mdaa7JoMUrhC3p7Q2+PA/ejaahj1apSPzFVfBnL/RISK11Dwa7/A17iSU+UP2zmhFwCm
         UDfAXb74DXuQbr1nou8UHL25KJK42hoeuPiiwb0lqskmS22FWuIfIt5kfCi+0szms06Y
         hO4cDGfdD5mp/v/H0t1EAsmQqx8TeagSwHZ06VBszfQ9Uuoqb3eNPexRyfYQPm/ndq9r
         xLSrgx/HcWZockb+fGQK9BBpe8zJXmdV86/kJROCgTf8CCw2hA4i+lYvp0rxufB9zwsD
         heng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683001913; x=1685593913;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BGjIikjpohEyy1ETXcWSntMlWV5iKFN+fziqfGclfYA=;
        b=lTDZrpndjKGpPQFRREw6Ul/g5DFLVUvDAPzPqfPhleNgAnyox0TphEarEinnnxCX/u
         Iwwt9YPk8hZWzJU17tO37XDKXZxEfE2mFmjLQYs6H37qzit+tl6iN8JX2l6WCLjJnrEn
         EYHojJvTbbNWg9x9y0csVo7uPsQPokhv10K9U75axXbsDwPZJAFgjuRAvpx+91Nl9SRz
         NlQrd890jKsKJ+mOctCO92AbObTxrqY3Vwap+D+F+BEEHoWOd+xnk5BvaF75b0cMcBSE
         XWwOw71woqj7oXtaMRnyIUlaG6ra6pTN3Jy576UK+vUpIDEZmgCyOENbgkd0Q5RjOcC1
         VhhQ==
X-Gm-Message-State: AC+VfDw5JFQ8z6kuRRIgt3lksh961eSd2KWYfRTrx9NUfxxQfu10chN3
        llx+UbgU3V82K5++wERdtG8=
X-Google-Smtp-Source: ACHHUZ7HCAhm2XotyF2VPfNOsKFJGeNisbYK/N+j54dq45v4luDamnHxcWCcP398h7Bv2jbWB7xXag==
X-Received: by 2002:a5d:9bc1:0:b0:753:42d:25ec with SMTP id d1-20020a5d9bc1000000b00753042d25ecmr12192534ion.20.1683001913263;
        Mon, 01 May 2023 21:31:53 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d980a000000b0076373f90e46sm8239781iol.33.2023.05.01.21.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 21:31:52 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: [RFC PATCH net-next v6 0/5] New NDO methods ndo_hwtstamp_get/set
Date:   Mon,  1 May 2023 22:31:45 -0600
Message-Id: <20230502043150.17097-1-glipus@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This stack of patches introduces a couple of new NDO methods,
ndo_hwtstamp_get and ndo_hwtstamp_set. These new methods can be
implemented by NIC drivers to allow setting and querying HW
timestamp settings. Drivers implementing these methods will
not need to handle SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
The new NDO methods will handle copying request parameters
between user address space and kernel space.

Maxim Georgiev (5):
  net: Add NDOs for hardware timestamp get/set
  net: Add ifreq pointer field to kernel_hwtstamp_config structure
  vlan/macvlan: Add ndo_hwtstamp_get/set support to vlan/macvlan code
    path
  bond: Add ndo_hwtstamp_get/set support to bond driver
  netdevsim: Implement ndo_hwtstamp_get/set methods in netdevsim driver

 drivers/net/bonding/bond_main.c   | 106 +++++++++++++++++-----------
 drivers/net/macvlan.c             |  35 ++++------
 drivers/net/netdevsim/ethtool.c   |  11 +++
 drivers/net/netdevsim/netdev.c    |  24 +++++++
 drivers/net/netdevsim/netdevsim.h |   1 +
 include/linux/net_tstamp.h        |  17 +++++
 include/linux/netdevice.h         |  22 ++++++
 net/8021q/vlan_dev.c              |  28 ++++++--
 net/core/dev_ioctl.c              | 110 +++++++++++++++++++++++++++++-
 9 files changed, 286 insertions(+), 68 deletions(-)

-- 
2.40.1

