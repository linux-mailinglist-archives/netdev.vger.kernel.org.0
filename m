Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598B762E025
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiKQPky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbiKQPki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:40:38 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3702464EB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:38 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q9so2131825pfg.5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pfRqtRKd8SqE53Bj4VHMwwcbF9sjiMvyrIbl19n+WS8=;
        b=OWhqxymbjYJcH3uaYprhaap3P+2ad7c1PNYCs86hkhofwJT8At5HiplT7dXLTLWxv9
         SpIsZK0gglEJMD3eLzaWpz8J75ismL3VcZTdc8JgQbvs6A70sZBI6pbZ6/2gsiKyNTMB
         pYMMIshXwjt/wtrS+K4us6bU5eIB0gkSWCKFYK8hEA7C+DJOywOP/tLPsWLsDsPM+gYq
         MNgCVDvHUZqymlsKFlOgif1G17fbLbTAKCg2DQuidep4JqBIJsAj5UEbVsGKLjQhCbrF
         GmBPK/zqsa/Q//tFcc9d3d98udFwGMVKiPGM9N/dKy8ZkopLxFuNeeWSimE9J6UgdS2L
         eVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfRqtRKd8SqE53Bj4VHMwwcbF9sjiMvyrIbl19n+WS8=;
        b=ptgko4VWwLuAcoQWJU79UNu2/NvzD09AJ/rZO9i6K+HVXUU8YI6cxz3EtGNB3fKfZU
         BL6tfaVdw6D11Y/UnqFl2nrL9ud1D4/GpNnLrhSHBqzlQtSUsmtwBwYqWAgIcbptuNu1
         e51AsrmJvMkF+YuyMpGSMgTTFsVVJGdJYMxiCIRPRA50BGwro/BRUvOLyqON/Cjvz4zP
         AUq3AONAAN5VDXssfFBkLhbewMX76u8P9UlUGhqoyisZVG8WfmxO7Ys+Lg28RQPqrPoz
         pSxpQx2lEa7/r+qQcGlkALzpW869GJJ1vfiz99weDd/zxCQ0OgGm21lJtn67dQ92AUaP
         NnZA==
X-Gm-Message-State: ANoB5plJ2xmzPHuxTE7O+v+w4acyMpZwT9NKeoIn+zb0VwMd3LBWgKRv
        qaW+rxTwWkj6R3wMMUJHUJ38kg==
X-Google-Smtp-Source: AA0mqf6QLQLorHXpp0fOgY/kytwiTqbSgHX1EdM3E1RcZ7RugFQ+bFwkB/NZumxcuJuuF025YMVuPA==
X-Received: by 2002:a05:6a00:2396:b0:572:698b:5fa9 with SMTP id f22-20020a056a00239600b00572698b5fa9mr3474821pfc.28.1668699637684;
        Thu, 17 Nov 2022 07:40:37 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b7-20020aa79507000000b0056bcfe015c9sm1252363pfp.204.2022.11.17.07.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:40:37 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v5 net-next 0/3] net: axienet: Use a DT property to configure frequency of the MDIO bus
Date:   Thu, 17 Nov 2022 23:40:11 +0800
Message-Id: <20221117154014.1418834-1-andy.chiu@sifive.com>
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
--- v5 ---
1. Make dt-binding patch prior to the implementation patch.
2. Disable mdio bus in error path.
3. Update description of some functions.
--- v4 ---
1. change MAX_MDIO_FREQ to DEFAULT_MDIO_FREQ as suggested by Andrew.
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
  dt-bindings: describe the support of "clock-frequency" in mdio
  net: axienet: set mdio clock according to bus-frequency

 .../bindings/net/xilinx_axienet.txt           |  2 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  2 -
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 79 +++++++++++--------
 3 files changed, 50 insertions(+), 33 deletions(-)

-- 
2.36.0

