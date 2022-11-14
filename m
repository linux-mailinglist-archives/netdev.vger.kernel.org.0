Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519306282CD
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiKNOik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbiKNOif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:38:35 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860436259
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:38:33 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h14so10486839pjv.4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+I2l2dQU/SlRpqjpUUygnad2p+C8/OjAHy4EbbukZok=;
        b=nK6x6IOyQ4NFKAnoYusaMucbzjZLOu3fj2PbTbcq7OR1JS2J60ezaVjpqMnmfA3y8U
         Mf7JxIw9V/FWM0v9llOwKK81bvMKoYLFU7Z2k9/5ag9VDAQe4Y1qrsF679b7Hmz0ouai
         7VMtMiQIXdTlBoK8GWDcLOa7RCKEo/JjS7g8ciZqtyAzzx8olF/MTN5WB+H9kPIVEdqr
         6FIeMbOtNgraBfqxIMBjEVVPBCOiJlj8WU1dy/scu1eY2MgAjN4sGe/TX3X1RMfelsf7
         xUvxjknCxzg24qfQl1cunTcVfmOT+pj46csoVojif5J6j5YkJJ6fZdjcbBn7zR9LCqbC
         kUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+I2l2dQU/SlRpqjpUUygnad2p+C8/OjAHy4EbbukZok=;
        b=3V/O8ph9Exf+B3Gw740XZvTTPvUziYwPXwMNnPGBgJ5kmkFU8lTUYrNf0chV+H704W
         HOebIKNQKWqp7DO7R7kBeZ5gjWtN9OLY8DM5gmJfnWEbqKQ7x8NM9igtBa8T//3m/sjA
         o7xXj9wzMrSQBKfRub9mcJIOO0ZGv1gh9jRTU1O951n2r7Jn5g7kz6e+dQM+hvsTZAWA
         R8l1aFCTrdLhyhYUoGzJB5EAaRtyyCQhobyBriXv299YrQ9pOAkPYCOpAz3YidHXVln9
         Wj2PQNw/aFnDclDcvL6Jx+n0ionu28swVyc5JbfcMAq9MX0FQHnkZtXz13HNRHJ6wtiD
         YSfA==
X-Gm-Message-State: ANoB5pnm3sEAjDKLaUIsyJLZknm31aLuqe2haiMu3pvLuFsXsDvw+QgL
        k2XAgL5ZIkvSfBsixFCzYJccug==
X-Google-Smtp-Source: AA0mqf7FAKNVJYgUMSb+z9Jz05Rx32S4RohRMcU+NLPX3jkasl/v7mTbc0RHPptGINr1Cs4ABfISKg==
X-Received: by 2002:a17:90b:1bd1:b0:214:1aeb:1ccd with SMTP id oa17-20020a17090b1bd100b002141aeb1ccdmr13808701pjb.127.1668436712986;
        Mon, 14 Nov 2022 06:38:32 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00000c00b0056bc742d21esm6977381pfk.176.2022.11.14.06.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:38:32 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v3 RESEND net-next 0/3] net: axienet: Use a DT property to configure frequency of the MDIO bus
Date:   Mon, 14 Nov 2022 22:37:52 +0800
Message-Id: <20221114143755.1241466-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some FPGA platforms have to set frequency of the MDIO bus lower than 2.5
MHz. Thus, we use a DT property, which is "clock-frequency", to work
with it at boot time. The default 2.5 MHz would be set if the property
is not pressent. Also, factor out mdio enable/disable functions due to
the api change since 253761a0e61b7.

Changelog:
--- v3 RESEND ---
1. Repost the exact same patch again
--- v3 ---
1. Fix coding style, and make probing of the driver fail if MDC overflow
--- v2 ---
1. Use clock-frequency, as defined in mdio.yaml, to configure MDIO
   clock.
2. Only print out frequency if it is set to a non-standard value.
3. Reduce the scope of axienet_mdio_enable and remove
   axienet_mdio_disable because no one really uses it anymore.

Andy Chiu (3):
  net: axienet: Unexport and remove unused mdio functions
  net: axienet: set mdio clock according to bus-frequency
  dt-bindings: describe the support of "clock-frequency" in mdio

 .../bindings/net/xilinx_axienet.txt           |  2 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  2 -
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 57 +++++++++++--------
 3 files changed, 34 insertions(+), 27 deletions(-)

-- 
2.36.0

