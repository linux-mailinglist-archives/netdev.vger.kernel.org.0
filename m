Return-Path: <netdev+bounces-2498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B27C6702423
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7E191C20909
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C019C5223;
	Mon, 15 May 2023 06:08:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09CA4C9B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:08:31 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861454212;
	Sun, 14 May 2023 23:08:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-643912bca6fso9626786b3a.0;
        Sun, 14 May 2023 23:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684130895; x=1686722895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JeFdDQPrLROSZ5WIsvj4avVuF11nhzCNhUc6QRBzVe8=;
        b=Lsib/yBgUrVMY5FLMsRXSpNC0H28c0xuEP5GBjSnsZenB6FMDRp7D2dPEm9GlbeDXc
         DdqUVzUKmQJbxaOBRCdzr3UCgk1wi0vfuGMqHX2BvbfE76PwfC9kwTnPi889uRey2V/Q
         IKZ6g+PdoWzE44/4xDt0bsyCqHHFhRkXs1zaggeq3oHfOzzmKkdIz+HWu3lpLMOo99Hb
         NUPVC05I+j72kgyT42Wx3ZKnxsYEEhl+IXxX3nF+SwsvUSz2YDrMfl/RF7naPnNP2WrY
         yhKg0ZA9O8/CL2xMJe1nBmXg3lCupuqTU7RlHTiBvVQ1TPwoXc5/GLjd91V7J0tRlySC
         TFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684130895; x=1686722895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JeFdDQPrLROSZ5WIsvj4avVuF11nhzCNhUc6QRBzVe8=;
        b=D5D3oswfsgs47+/KhaSMgQTVVKkXsGgUykt4FCtN8rwX/wLaqKPQSl8+08Ath2X68x
         BBGfA4xcgLUVXx0+dJeSD5/i/0yFI9DRtewddig4LKWSNHoRIrhs7oDiiwFle5w6edYC
         0j0T9uujxjQMqixkbW5xuxNq8E1HSiX3vDM5JGwfEUuXW6zXosYr1uC9RffU5k8K+l7K
         VEHx+dVAOf4NYofzVBpMG1zH2JJ91MVKigsjFwnIxdjktaDQrI2z1pF+D0XI4R5JChyV
         N95kBzHYQu/LFMMz+ndQfImeqOrkuTgePwUDjZpJrm3RmmQAVkIlAG9IpQ371PClrwIp
         ygbA==
X-Gm-Message-State: AC+VfDwubjt+Bu1DOSP+YQNIzBdY5ohMMWOgt9d5T471wu4ndBg0gApC
	c/+ezUvboZFwLhYPl5j7fgI=
X-Google-Smtp-Source: ACHHUZ6cbKEdxeChvRyvaMXsxsfLk4HIadCOKO3T8CQx1IeTJ6osdgXXqDjteiRcZeoiyyoE6vFqpQ==
X-Received: by 2002:a05:6a21:78a0:b0:100:5082:611d with SMTP id bf32-20020a056a2178a000b001005082611dmr33831184pzc.32.1684130894871;
        Sun, 14 May 2023 23:08:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id x22-20020aa79196000000b0063b7af71b61sm6205214pfa.212.2023.05.14.23.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 23:08:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 95CEC1069B5; Mon, 15 May 2023 13:08:06 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Networking <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Simon Horman <simon.horman@corigine.com>,
	Tom Rix <trix@redhat.com>,
	Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH net 0/5] SPDX conversion for bonding, 8390, and i825xx drivers
Date: Mon, 15 May 2023 13:07:10 +0700
Message-Id: <20230515060714.621952-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2125; i=bagasdotme@gmail.com; h=from:subject; bh=JYVO2TN3RmdkhfV4jG9ubU254wo1pvyUKpc8DFTdpok=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCmJZ1i5VJiF0zj6hRfMWZp61OG40IdQC83bNtvWfmc7c bdl2kO2jlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExEwZfhf+HWe8t3G//6Z902 fd5em3lSbtLazcKP4m6n7ePdnvt84kqGP3zP7xrdXffrS/cixXhFpWX7N3crb9SUNA3cU3LqR2f 6b3YA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series is SPDX conversion for bonding, 8390, and i825xx driver
subsystems. It is splitted from v2 of my SPDX conversion series in
response to Didi's GPL full name fixes [1] to make it easily
digestible.

The conversion in this series is divided by each subsystem and by
license type.

Happy reviewing!

[1]: https://lore.kernel.org/linux-spdx/20230512100620.36807-1-bagasdotme@gmail.com/

Bagas Sanjaya (5):
  net: bonding: Add SPDX identifier to remaining files
  net: ethernet: 8390: Convert unversioned GPL notice to SPDX license
    identifier
  net: ethernet: 8390: Replace GPL 2.0 boilerplate with SPDX identifier
  net: ethernet: i825xx: Replace unversioned GPL (GPL 1.0) notice with
    SPDX identifier
  net: ethernet: i825xx: sun3_8256: Add SPDX license identifier

 drivers/net/bonding/bond_main.c          | 3 ++-
 drivers/net/bonding/bonding_priv.h       | 4 +---
 drivers/net/ethernet/8390/8390.h         | 2 ++
 drivers/net/ethernet/8390/apne.c         | 7 +------
 drivers/net/ethernet/8390/axnet_cs.c     | 6 +++---
 drivers/net/ethernet/8390/hydra.c        | 6 ++----
 drivers/net/ethernet/8390/lib8390.c      | 5 ++---
 drivers/net/ethernet/8390/mac8390.c      | 6 ++----
 drivers/net/ethernet/8390/mcf8390.c      | 4 +---
 drivers/net/ethernet/8390/ne.c           | 4 +---
 drivers/net/ethernet/8390/ne2k-pci.c     | 1 +
 drivers/net/ethernet/8390/pcnet_cs.c     | 5 ++---
 drivers/net/ethernet/8390/smc-ultra.c    | 4 +---
 drivers/net/ethernet/8390/stnic.c        | 5 +----
 drivers/net/ethernet/8390/wd.c           | 4 +---
 drivers/net/ethernet/8390/zorro8390.c    | 7 +------
 drivers/net/ethernet/i825xx/82596.c      | 5 ++---
 drivers/net/ethernet/i825xx/lasi_82596.c | 5 ++---
 drivers/net/ethernet/i825xx/lib82596.c   | 5 ++---
 drivers/net/ethernet/i825xx/sun3_82586.c | 1 +
 drivers/net/ethernet/i825xx/sun3_82586.h | 1 +
 include/net/bonding.h                    | 4 +---
 22 files changed, 33 insertions(+), 61 deletions(-)


base-commit: b41caaded077aa8e7617c15e87d0503df8e7739e
-- 
An old man doll... just what I always wanted! - Clara


