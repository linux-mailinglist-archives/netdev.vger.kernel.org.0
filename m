Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6223B552C59
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347573AbiFUHte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347926AbiFUHtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:49:32 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A80F23BE4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:49:31 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so12538923pjz.1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aaK7RUDb+MNIHPH71+3s7TMT4RD7fK5Gn4ITZtL6OY8=;
        b=OjuNvsJTGeEddC3nLKFN7UoRMc1BgiTq56gK+9cO4NNZ5a/YZiwm+jRUtix9Gpo3Mb
         3rO7WA3GOE3iclDBPqe5IUNoNwhPt6MVcSe6pbx7MtENr9LSgMf3nuEbmf8lhEVHxQrD
         S/EfJQgeyhzR7dFDmADB+rioatdCSjxHzxI2saBnn7mRgfX/ZVi2e1pMgZVf2GQf59Xz
         YVP7W7hICod0kIS5qmPXO1SOZSALiCtHXZJrDmMoX7bhjuZTRD5bLw7BOKxIECGC3daY
         fbmuhYZB3ikvtE6g7DJhkNvhUu+O/xZ2SB0i8WygtuIfuXrUxvw7U8+eguybXRBtm51q
         UxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aaK7RUDb+MNIHPH71+3s7TMT4RD7fK5Gn4ITZtL6OY8=;
        b=6XtezP/6ovXaAIC5DhuZUXdnDDmFwbK3rcfQTZjW+QHVYyhxwdNbZmZcf/oDHX9gvm
         dpGdiZhcRNUXCfEwPmER3f9S72x22DvhZlS+CSmZVDonzhuzejYiYVHg18sVTnrQEDyx
         J3vt0yVSdJoaZBVFUD4ywW6Kq9IGUPs2gUiLRw6D6sqcnij9lzii8feZPi+NeISK9V5N
         hbQA3qYHEuoK70z0AwybicyKHyBPTWsAwytlMpKPY1yU1Z76LCwspaJdFEsY1Gu0+AUs
         Tr6P3pjeQqk3+0zBFhdt192bThoI36hdv/6INo6zVMdpUO2Oanut3OMLDHHahMSBlWbJ
         9/Ww==
X-Gm-Message-State: AJIora93/CruOgZ1ILYNuWKlAAD1HTgQjsWx4FP0eLB6FmP7GuiNKfU6
        SdzDQAcDO4R+pmeZT6iJDCs1X3dRkx4=
X-Google-Smtp-Source: AGRyM1tmMrwBpg9iOneE6MZV/xqRvCgJ+Pj1nwxMJpZEjMOMoBSpZPthLw9Qac0VW6QGBhJrqmN2ZQ==
X-Received: by 2002:a17:90b:1bc8:b0:1ec:881d:86ad with SMTP id oa8-20020a17090b1bc800b001ec881d86admr19133768pjb.4.1655797770198;
        Tue, 21 Jun 2022 00:49:30 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mm5-20020a17090b358500b001ecd3034b66sm8119pjb.54.2022.06.21.00.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 00:49:29 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net-next 0/2] Bonding: add per-port priority support
Date:   Tue, 21 Jun 2022 15:49:17 +0800
Message-Id: <20220621074919.2636622-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

This patch set add per-port priority for bonding failover re-selection.

The first patch add a new filed for bond_opt_value so we can set slave
value easier. I will update the bond_option_queue_id_set() setting
in later patch.

The second patch add the per-port priority for bonding. I defined
it as s32 to compatible with team prio option, which also use a s32
value.

v3: store slave_dev in bond_opt_value directly to simplify setting
    values for slave.

v2: using the extant bonding options management stuff instead setting
    slave prio in bond_slave_changelink() directly.

Hangbin Liu (2):
  bonding: add slave_dev field for bond_opt_value
  Bonding: add per-port priority for failover re-selection

 Documentation/networking/bonding.rst | 11 ++++++++++
 drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++
 drivers/net/bonding/bond_netlink.c   | 15 +++++++++++++
 drivers/net/bonding/bond_options.c   | 33 ++++++++++++++++++++++++++++
 include/net/bond_options.h           | 11 ++++++++--
 include/net/bonding.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 tools/include/uapi/linux/if_link.h   |  1 +
 8 files changed, 98 insertions(+), 2 deletions(-)

-- 
2.35.1

