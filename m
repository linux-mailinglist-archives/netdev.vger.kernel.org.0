Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6565357707B
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiGPRuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 13:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGPRub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 13:50:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4311B1D0C6;
        Sat, 16 Jul 2022 10:50:30 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so4882246wmb.3;
        Sat, 16 Jul 2022 10:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JkGbprDGn0r4E2Q8HDFykU8ExI/cfhG3gMbisI0kOjY=;
        b=XEQS6tgS+1QaeOt/pUBovv54zAhbF/+L2EkqnOz6qEpMVwRf1PtdmEZxlbPBdsSy61
         wLx6DTtTMzSQJDfDpEquezK0q3IwPlD6yuXjpbfozV5anLyDLc0XeqqZ3d5jvb1vvY9c
         +5Q2hv4BfMceT6QYXkiykLybNr91TTpMav5khEpc2uEac1lUtze1XAFYLv4kofUjLbeJ
         c8SSi28sbvOO8+PNgDGxRimoQSfhHJj2VnI8i2gUwrf4pBnSrjqbblZ0yQIUeZnG0Tu4
         M3J4eT278tPlAbqEYEZG+DyqgiJ0ydHNb8VuPkGSEZW4t0VRiGSQ5xsi6geowvHVe2Jm
         iV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JkGbprDGn0r4E2Q8HDFykU8ExI/cfhG3gMbisI0kOjY=;
        b=6xaJ8oVKcXEtIH/y62Wn39ivz+qR7niXYk+SBnQyQl0o2ZqY/DgE6HFpRvYOcqUmK/
         lgPAMtD+9EEN5xWiHmQEyRjXZHmyMKFjWsB9MzJvwNLIZyTpfpCCStwQ5cZY/ei5K8tW
         owaTWsaX+zEDBoJ0Dr02I/Pey8sxpUEsyBTXbIAjXF6Rqvl6ymNqi+vEwmwx8POkkj27
         XmfhIGKTMn2Zv5fq8ryigmY878jJMVbqALT1PuT3BztrF4HRlcPPN8nscj6CCpyXiTez
         fi7xzugo96bjMU3iPrJFTK/88iEryi9rJLTUJEweGUC5/nMdOCWK3TyDOftgIrxjnaFI
         ln+w==
X-Gm-Message-State: AJIora8MTOKxFHgoc7idrgVjupSOEeNRQ0edKXxYal9VyKj6G/Hu+Igt
        lhq4v/KKpzWMgLt8H7qLL/vuQa3FN5w=
X-Google-Smtp-Source: AGRyM1sl5IdsSTst7bF9RySC+KXS0iZc7KTU3D5sI6a5ZMduKo0Hc0N7SMuGAAv0OZ8saZ1JweGz+Q==
X-Received: by 2002:a05:600c:4f91:b0:3a2:c5f2:c62a with SMTP id n17-20020a05600c4f9100b003a2c5f2c62amr19139726wmq.17.1657993828632;
        Sat, 16 Jul 2022 10:50:28 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id s6-20020adfecc6000000b0021d74906683sm6836108wro.28.2022.07.16.10.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 10:50:28 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next RFC PATCH 0/4] net: dsa: qca8k: code split for qca8k
Date:   Sat, 16 Jul 2022 19:49:54 +0200
Message-Id: <20220716174958.22542-1-ansuelsmth@gmail.com>
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

This is posted as an RFC as it does contain changes that depends on a
regmap patch. The patch is here [1] hoping it will get approved.

If it will be NACKed, I will have to rework this and revert one of the
patch that makes use of the new regmap bulk implementation.

Anyway, this is needed ad ipq4019 SoC have an internal switch that is
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

(the bulk implementation could not be done when it was introduced as
regmap didn't support at times bulk read/write without a bus)

[1] https://lore.kernel.org/lkml/20220715201032.19507-1-ansuelsmth@gmail.com/

Christian Marangi (4):
  net: dsa: qca8k: drop qca8k_read/write/rmw for regmap variant
  net: dsa: qca8k: convert to regmap read/write API
  net: dsa: qca8k: rework mib autocast handling
  net: dsa: qca8k: split qca8k in common and 8xxx specific code

 drivers/net/dsa/qca/Makefile                  |    1 +
 drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1638 +++--------------
 drivers/net/dsa/qca/qca8k-common.c            | 1174 ++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |   61 +
 4 files changed, 1463 insertions(+), 1411 deletions(-)
 rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (60%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c

-- 
2.36.1

