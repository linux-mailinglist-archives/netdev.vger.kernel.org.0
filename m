Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73D57F773
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiGXWvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiGXWvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:07 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319496169;
        Sun, 24 Jul 2022 15:51:06 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id sz17so17530565ejc.9;
        Sun, 24 Jul 2022 15:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iC8ZFOlLhnkf1prx6yWwk+CQsLZ6WJZa0KwwPQLezfU=;
        b=YM882+zsJMrMfmw70eDSAawArjCbzvZENlE6m8ovXAoUpp/3LqMx6N1oSy1tBhaacT
         JRrO4j8fW8QXDpA/VqYyZfr9YwKqsGgTqZxOY/wmQ5PKGwhrFI++z/MXxV6Dye0wKrji
         1sRMIN5CBje9R9/Kl0f5Q497519MKu+1OWkSnhR1oUR4bXWMw0HU2KfYVNJ1/srrbDu9
         qDZR7ocRlFb7z9QknxQy03VwFvSYdt6uxXar/iKcWhgh8tcYtIHy/V9/sEWfWm2RKkM3
         VlB9wusgyJbrYZI2SwOYAFGzWFK6ODnb5gsNIA3wgK7Z86h5UbA30vCZsKz3xRJW01O3
         wYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iC8ZFOlLhnkf1prx6yWwk+CQsLZ6WJZa0KwwPQLezfU=;
        b=5/xX+xB7lTMtbxfzCVQc6GpngtorpYh2m2lFkpmCeYJF2d66uxLJQFkMkCclfm4teQ
         kAtwGBbXMoBY6X+SJxzosa104x4kMNWlCzI2R4G4m3pJeW8InHxQNHnLuJ/496tqsqZg
         SOTaNnoKQw09yc2/SUCrG5eKlv6ttNZaYakkuIZ0kfRSw0UB3JOxNE3Sh9RkSByYYryB
         8UdJJKcTIu0uyXHyiHcKrX7KKq+wYvzWOk4GVZRC0dgPz2ZxBJQIpCMywb7lNtSstX91
         e/kAoHvxn7PGnfs7CP6MYcsPsB75KERxqfTEAxPYwPG9AE2qrGyiCoXmI3AdRkeDI79h
         WjoQ==
X-Gm-Message-State: AJIora+v0LNAaU6HR6gKbdzM6MT8dUto2USHd22ixh+qET00pPb2GSQC
        ZOGNobnkNPcgHky7D5Iin2A=
X-Google-Smtp-Source: AGRyM1utUH37ezGomhHFXQ/NjekIezTizPa0ydfHEcsaZugnjHb0ju5RaVEbFmWplZ8co3tVh3FYjA==
X-Received: by 2002:a17:907:94cf:b0:72f:1c2a:d475 with SMTP id dn15-20020a17090794cf00b0072f1c2ad475mr7921257ejc.237.1658703064567;
        Sun, 24 Jul 2022 15:51:04 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:04 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [net-next PATCH v4 00/14] net: dsa: qca8k: code split for qca8k
Date:   Sun, 24 Jul 2022 22:19:24 +0200
Message-Id: <20220724201938.17387-1-ansuelsmth@gmail.com>
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

v4:
- Fix compilation error with clang compiler reported by kernel
  test bot
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

