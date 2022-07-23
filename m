Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2237657EF71
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbiGWOTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbiGWOTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8103183BC;
        Sat, 23 Jul 2022 07:19:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v13so2219314wru.12;
        Sat, 23 Jul 2022 07:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aYMXugLjT0vmNOXEeLojAK5w6cmZ7Tah5JaZ/yMlBCI=;
        b=j0qBVYVwvRXkHMCXLVlTTYZsQUz8XfCvkJ3uIs2rJ2rr8NCyDc2lvBRJcZ/GAwwANq
         M7Sj5V+5zLTF5TlUwAeOrkBrQ35Js3gUK2vXBhjgSMzF0hZwnDAXVb6gWBj3UmFml7OG
         dclEJgoP1FXgQHeqpxYG0DdvT+D+BbVOyb6fQHjmokxeSoOMXaahTh9l62fZc1MEDYAJ
         TPyvFwA0OrIuGbZ3/I1TlVtf3dEPk8mzJdlDm428Nc2ew7Tgng/ekgMdzEbFdRUvGk0H
         5O3t4V+Qr4IuHQotyeCkgh9Yi+tUvMan2+N4KJbr2+jTES6Kefb/YPY12pF4N8QnkMS6
         m50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aYMXugLjT0vmNOXEeLojAK5w6cmZ7Tah5JaZ/yMlBCI=;
        b=Yxlkzk9nm9YQdqreVmWBWRM044bP9OJLEcHno/IDlMjKYKJ17boToVDWiIbniewd+P
         GAFTSF3sV/iM/RYQLBIchaWqt5EGmAnDT0NA1Uu6lzY1+BIpJKLJ74h0MJdQ950BOigs
         rlckla7cd4DTgFh9fcn2GyaovLxuNAeWYTabAsbO+Mp5B0XQ9wiql+/c5jDjTSFTCkrr
         TzoOdYELMe6KUN2tfDxdIvuuDY5U8B1hjTffEI4NVl8jLxsg94JZYchZ9pBce/iMcye0
         1qu5At0VVxPKMPPncU8dD0mIIOQUQgafkKrpHBvgZjtCKPoUBYwGaJIWFK/IA1se1jxT
         RM9Q==
X-Gm-Message-State: AJIora/DUauyaZ8Xglnr4C53I48RRwIr3fCt3nV+QbkLHEUkcZ+D+BqZ
        QzPk4gmJTmwhvPeddxevW54=
X-Google-Smtp-Source: AGRyM1tafSBERDDiC7xk72RGPmBW1LaiMW5F+J5OLFIGabVLT7Ud7KMl0dnp+hX6v8XpDdJPEQ+QvQ==
X-Received: by 2002:a05:6000:1548:b0:21d:acfc:29f5 with SMTP id 8-20020a056000154800b0021dacfc29f5mr2817360wry.520.1658585959679;
        Sat, 23 Jul 2022 07:19:19 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:19 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v3 00/14] net: dsa: qca8k: code split for qca8k
Date:   Sat, 23 Jul 2022 16:18:31 +0200
Message-Id: <20220723141845.10570-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
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

This is needed ad ipq4019 SoC have an internal switch that is
based on qca8k with very minor changes. The general function is equal.

Because of this we split the driver to common and specific code.

As the common function needs to be moved to a different file to be
reused, we had to convert every remaining user of qca8k_read/write/rmw
to regmap variant.
We had also to generilized the special handling for the ethtool_stats
function that makes use of the autocast mib. (ipq4019 will have a
different tagger and use mmio so it could be quicker to use mmio instead
of automib feature)
And we had to convert the regmap read/write to bulk implementation to
drop the special function that makes use of it. This will be compatible
with ipq4019 and at the same time permits normal switch to use the eth
mgmt way to send the entire ATU table read/write in one go.

v3:
- Squash more patch to skip even more "migration patch"
- Add new patch to cache match data in priv struct
- Fix extra space
- Drop unnecessary cast to qca8k_priv from void pointers
v2:
- Rework patch to drop dependency with bulk regmap (will be
  converted later)
- Split the split patch to additional patch
- Rework autocast_mib function and move it to match data

Christian Marangi (14):
  net: dsa: qca8k: cache match data to speed up access
  net: dsa: qca8k: make mib autocast feature optional
  net: dsa: qca8k: move mib struct to common code
  net: dsa: qca8k: move qca8k read/write/rmw and reg table to common
    code
  net: dsa: qca8k: move qca8k bulk read/write helper to common code
  net: dsa: qca8k: move mib init function to common code
  net: dsa: qca8k: move port set status/eee/ethtool stats function to
    common code
  net: dsa: qca8k: move bridge functions to common code
  net: dsa: qca8k: move set age/MTU/port enable/disable functions to
    common code
  net: dsa: qca8k: move port FDB/MDB function to common code
  net: dsa: qca8k: move port mirror functions to common code
  net: dsa: qca8k: move port VLAN functions to common code
  net: dsa: qca8k: move port LAG functions to common code
  net: dsa: qca8k: move read_switch_id function to common code

 drivers/net/dsa/qca/Makefile                  |    1 +
 drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1716 +++--------------
 drivers/net/dsa/qca/qca8k-common.c            | 1240 ++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  100 +
 4 files changed, 1584 insertions(+), 1473 deletions(-)
 rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (63%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c

-- 
2.36.1

