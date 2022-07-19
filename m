Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34C9578FA1
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbiGSBPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiGSBPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:11 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DC41151;
        Mon, 18 Jul 2022 18:15:08 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j1so14988617wrs.4;
        Mon, 18 Jul 2022 18:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAeLXD8VyEWafqISJzPS/it2qKgdCqehM3aPRt8QmDw=;
        b=n6pJ76xUkuRQ7cMpy8CvlpLyRNP6qs2Yk7R8d5kOqvsUgQKpsdBte2UjBBaZDSEpHF
         oMGgqY5gJrfviYLFZRUbVX3uRAlrdiwC+Ww95JaJSLnObss5INyuhXqGe8/0fL8q+QqX
         G6vphQSZ2ODnW7OyZ9bK9HAj6gZAswJNvYxiAlY7XeKiEBfyrd6aZkywcCxJvu2bpuKF
         nLzz42jRPy8pP7iX8RgveVYfmOs9RJKKt4v7uau7UlVtZxuMkZ23krcn3Mf3f9E/0K8f
         I9gA4KXfMJiTZup+IZ6nos1nsNt5stXXTl5VDLoGlWAe5p/gSoq/WH4djZWgtWsbuBEX
         cplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAeLXD8VyEWafqISJzPS/it2qKgdCqehM3aPRt8QmDw=;
        b=anFnUlte5G0dxWOSwx9PxaP6DsBII42RF4/LkWsw43rj3AEgvT/T4KQZofXYJZQEZx
         7P5tekRk6Mly4rbEd1YJqN0+FCNKJdMKg1kFE+vu/0q7oc1EFlL9StcljN0+WGliTvuZ
         mBQAsXomtKm6KP3ug3T3EYAYmDq14C83iONpdmUBuO1AhGQ2YAGVzruYsaTKgY/wswuB
         +L3w7ZhvgOe7Mij+7ve2qRir6LwqvwR4xhvulI50rbW8BdAeFNZWZyExF+RW8jiIRghg
         EmbuQjcow+oq8WUkPl9u3CVo5K7GmZie0sq6ZAtP5Ha3TySOOa5Ec5bGig0oCOLsHGiS
         v1fA==
X-Gm-Message-State: AJIora+qIFsaOJYY9kUW+9I41BFvQGBLlh9Qnp31Mu+07tz8mOfd1iqf
        PyaGc53SjotPQ6lJuA7CO9g=
X-Google-Smtp-Source: AGRyM1sBAXitfC2QrXQ5Mg8ZUbCWb+iEn98n6EHMnyL2R0olZrqmFn6t1jO3T5631U09a3Z3EFuTxw==
X-Received: by 2002:a05:6000:98d:b0:21e:3b5d:335 with SMTP id by13-20020a056000098d00b0021e3b5d0335mr333035wrb.148.1658193307307;
        Mon, 18 Jul 2022 18:15:07 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:06 -0700 (PDT)
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
Subject: [net-next PATCH v2 00/15] net: dsa: qca8k: code split for qca8k
Date:   Tue, 19 Jul 2022 02:57:10 +0200
Message-Id: <20220719005726.8739-1-ansuelsmth@gmail.com>
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

v2:
- Rework patch to drop dependency with bulk regmap (will be
  converted later)
- Split the split patch to additional patch
- Rework autocast_mib function and move it to match data

Christian Marangi (15):
  net: dsa: qca8k: make mib autocast feature optional
  net: dsa: qca8k: move mib struct to common code
  net: dsa: qca8k: move qca8k read/write/rmw and reg table to common
    code
  net: dsa: qca8k: move qca8k bulk read/write helper to common code
  net: dsa: qca8k: move fdb/vlan/mib init functions to common code
  net: dsa: qca8k: move port set status/eee/ethtool stats function to
    common code
  net: dsa: qca8k: move bridge functions to common code
  net: dsa: qca8k: move fast age/MTU/port enable/disable functions to
    common code
  net: dsa: qca8k: move port FDB function to common code
  net: dsa: qca8k: move port MDB functions to common code
  net: dsa: qca8k: move port mirror functions to common code
  net: dsa: qca8k: move port VLAN functions to common code
  net: dsa: qca8k: move port LAG functions to common code
  net: dsa: qca8k: move read_switch_id function to common code
  net: dsa: qca8k: drop unnecessary exposed function and make them
    static

 drivers/net/dsa/qca/Makefile                  |    1 +
 drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1505 ++---------------
 drivers/net/dsa/qca/qca8k-common.c            | 1256 ++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |   95 ++
 4 files changed, 1489 insertions(+), 1368 deletions(-)
 rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (63%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c

-- 
2.36.1

