Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1939F658F29
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbiL2QoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiL2Qnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:43:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880EAA199;
        Thu, 29 Dec 2022 08:43:48 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id z10so17839087wrh.10;
        Thu, 29 Dec 2022 08:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=F8njVNAgOhSXYIRyZFVfJpPUQqLhmujT5kFtAPYh2+Y=;
        b=FIHPgz4myL4e1XfkPMOuK6vFd3OM0xm7MtLpGbqSFQwPWdeDxHcJqAuba6kGYsQvhC
         2s/zwmPHEQur7c7QhHBviMxv3JuTE2RO4rAUUIwMu0YAdSLuMVHEqUY7oe01uvWhH3fp
         +74qtkxM/kltKR20ere1bDmXdeSJgDRu5/OoThf9fd9w/1t1ypPNkgY/sWgFs2Y6jOAT
         jyMv7Qi80p+xD+2jcQsQ7N5ChkJdz6jVZCKRbl8icCPXWsTyhmE/NLAWllw+gF1ubXsU
         TVodx/VUjkip0vAfEncfZ9kKe92ewKoMyL+22u8/5ZJ5+VKKJ63OTWJ2xsSawGyUFSti
         ECuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F8njVNAgOhSXYIRyZFVfJpPUQqLhmujT5kFtAPYh2+Y=;
        b=HctjNaCCn7/Sk3K/OOZJ6T+qqmpAVqo+uvB1aXk2Kwc6+51t+HpnWVGNXM9Tq3HnTs
         1u4WUXGNQfDDtwWZEoeeogwETnsRvl+8zN7J1sn0sRUAb/4H4CyT3tavIcDXzf1lQT0I
         QiO9Lt38+wrW+r2oHjyD5Lu9e1oOBbRhBTPGzncQ3M35tWBZ6EUjRV5SCR7tsnJal6R8
         3CJ6zsJbh3/pQhuXviRSKVrxnJ5435e+F4DDyDsUHXJ+4Qsz/r9RGg54KxiVQLg6hfB8
         yYetwDKs3S0fWVsWYoCQqUwDgIyw3n8VhJFgrtL8BWO3rl1chnBbAhbZy2aMPPzuC5j+
         4xcg==
X-Gm-Message-State: AFqh2kr8rXX1LijOv1MKlyetRSbvmqIRHbtugWIa35kRS1arwI9/hT38
        LUkmGtkPb+Zp+LYdU2yoi78=
X-Google-Smtp-Source: AMrXdXv/EgEEjOkQwFFOy9Lf/vl/HRywMt6AfoGrjIFv4QcorxBSq4oCaTEfiavPYGWvMppH8SCFxA==
X-Received: by 2002:a5d:6e07:0:b0:242:285:6b39 with SMTP id h7-20020a5d6e07000000b0024202856b39mr18161504wrz.50.1672332226830;
        Thu, 29 Dec 2022 08:43:46 -0800 (PST)
Received: from localhost.localdomain (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.googlemail.com with ESMTPSA id t18-20020a5d42d2000000b00288a3fd9248sm4326586wrr.91.2022.12.29.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 08:43:46 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net PATCH v2 0/5] net: dsa: qca8k: multiple fix on mdio read/write
Date:   Thu, 29 Dec 2022 17:33:31 +0100
Message-Id: <20221229163336.2487-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to some problems in reading the Documentation and elaborating it
some wrong assumption were done. The error was reported and notice only
now due to how things are setup in the code flow.

First 2 patch fix mgmt eth where the lenght calculation is very
confusing and in step of word size. (the related commit description have
an extensive description about how this mess works)

Last 3 patch revert the broken mdio cache and apply a correct version
that should still save some extra mdio in phy poll secnario.

These 5 patch fix each related problem and apply what the Documentation
actually say.

Changes v2:
- Add cover letter
- Fix typo in revert patch

Christian Marangi (5):
  net: dsa: qca8k: fix wrong length value for mgmt eth packet
  net: dsa: tag_qca: fix wrong MGMT_DATA2 size
  Revert "net: dsa: qca8k: cache lo and hi for mdio write"
  net: dsa: qca8k: introduce single mii read/write lo/hi
  net: dsa: qca8k: improve mdio master read/write by using single lo/hi

 drivers/net/dsa/qca/qca8k-8xxx.c | 164 ++++++++++++++++++++-----------
 drivers/net/dsa/qca/qca8k.h      |   5 -
 include/linux/dsa/tag_qca.h      |   4 +-
 3 files changed, 109 insertions(+), 64 deletions(-)

-- 
2.37.2

