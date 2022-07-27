Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9D458259A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiG0Lfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiG0Lfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:35:41 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C675922BF6;
        Wed, 27 Jul 2022 04:35:40 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l23so31000022ejr.5;
        Wed, 27 Jul 2022 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UV/mMyTMs0eKuU5zSJfJOR5cXJNS19F5GWColL/C+9o=;
        b=gbMyepVIxYkgJ6C4UkAOdEEtHLTBRzIPPmGouJ8T8x1U9KfoFU0G1V/3SNvlShjWuq
         iGFfLmQAMFaUmrhZ3Ufg7SH0dyy/Xq5CL9VKQnLKraKN+6QGqaFyyah6jC/wWMKjgcYT
         UnLnRqUyJnjBfU+g+lwDHg7ffT3rjoFPKBWPuGYLRTjjCPUsiL1bjLOsxM6w1vyat43R
         c6mDDXe/ql/JqwDk2cBZkVT049VW/dLBG3sMChsek785R7DYOMuQRX89+T+wJjtFGJP6
         ISrTMAoZ6wSjOuEZqS0iLewdkrmuo13XhC4G5kxrQ/XWffuPzsZM8ICMx+uhYJL9HQZt
         yjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UV/mMyTMs0eKuU5zSJfJOR5cXJNS19F5GWColL/C+9o=;
        b=1jhF5ONMmF3Jsl5bAY5Lxls/bT0pqnAqQJlxMFNwMwb7Ozv0vuUODyXYrxVdH+UbgM
         GNOEysvmE8K5sIecqbGklPnxHRPiDmIwegNIngRXzothZlwNOmZbAyKdPBFND30Ou73/
         +ATTc8+sfpne6iNH72I+7Pk9ehtkvQRukwAllM5COAJM8iXQtHqCpmzxcRRqIL1tIchO
         IR4RbmPS2sz6qJWLZGB3DDbLjlpAcGbf6RR+TKFLkdfpUEcLyvF98zVbk4gbJQoLJty4
         9124K/bSvTe+L90IT2oFNt4h9Sbub7X8uNEMZ0Bd1VHiUUwhOFp86M5B4vmzKt/Q8QqO
         w87w==
X-Gm-Message-State: AJIora/SLRQ88QRVPAyqCOMta0heVYuLdJqEHi+j/R80Id+hROwBLi/y
        8p/x2Y/o5SOrXg6RjZVgVYQ=
X-Google-Smtp-Source: AGRyM1skdVt9k7L0FeivBtuBGMtWwmFlYQTx/jfTpqCOcfXcp1YUv+dYPqTXd2t6WKiXFf3hJym6NQ==
X-Received: by 2002:a17:907:7da6:b0:72f:136d:dba4 with SMTP id oz38-20020a1709077da600b0072f136ddba4mr17325350ejc.472.1658921738962;
        Wed, 27 Jul 2022 04:35:38 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:38 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v5 00/14] net: dsa: qca8k: code split for qca8k
Date:   Wed, 27 Jul 2022 13:35:09 +0200
Message-Id: <20220727113523.19742-1-ansuelsmth@gmail.com>
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

v5:
- Wrap function to single line/80 char
- Cache match data even for read_switch function
- Add additional review tag
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
 drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1711 +++--------------
 drivers/net/dsa/qca/qca8k-common.c            | 1210 ++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  100 +
 4 files changed, 1549 insertions(+), 1473 deletions(-)
 rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (63%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c

-- 
2.36.1

