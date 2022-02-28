Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B94C6E56
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiB1Nhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiB1Nho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:37:44 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F8D7A9BC;
        Mon, 28 Feb 2022 05:37:06 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id m14so21399520lfu.4;
        Mon, 28 Feb 2022 05:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=ybYQe3xQ9S5Kw+QobqlTw6DrtwPzxToutzfXG54v3Ws=;
        b=Ktwvg8Yzec6SCgspCgAtCNeyZaMmjOQ46tGIrmha3/VYC41lz8DPB4mivi3vUqSsEw
         oeEUmmQpYXJqFVv9r42hKGR2oCuvn4AXFPpcl71mOt8itQY97F3SAhs7DbJib8U9BZ94
         r6wGFLakuFTgA2mg29yyuB4hI2tklxskJncfskyOzNDqAwJTVXDC6NIxHI8d9u5CNxWi
         syjwnzPaH3EDKhelG4ZXJYXwkdBg098WWsuTCcdKF5QBDLXyqKBh7WVVf29lluRWlBBc
         42yWmHwP8KudzEkO2M99lXH6x+uukDnCa9MYNYIg5+fnL2jFwXeKyAUbNLWJRJP+mhtb
         M4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=ybYQe3xQ9S5Kw+QobqlTw6DrtwPzxToutzfXG54v3Ws=;
        b=x2o94rp0YbkIx9IX/GUIP1DZYZps7Z2EYyCRGSqHLFSovJ51y5whcs2MS3RdC3ZIKU
         AlRxg4G7XOjB+jfo/PI13ngpgWM+TI9z9zziFAzg6tNA/0rykqOf9DqMKpZmk5fAsGkI
         +sY4l9v9W1MDAw68Eg994UB0D39e/nU7rpKx4C2VQngGRCkOs62kzYwSs49E9M9s2uiA
         EryfPpAH6EH4Pv+JvIq7AMioGfVfp+FIje8gDTRd+U2qZdpk+nYuqgc9+kfkF8J8AN7w
         H0J+nzLMmUNIojRKWawy/Ac1fvZJ/b3MPycA0ucs5bga7C6oTzrIFRiTn7SAf7/W3IFL
         lOjA==
X-Gm-Message-State: AOAM53319irHWCA2z37DQuvI6F/c3XLMYViyBPjauv7vGivPUgJOrqRF
        c+Ag/AHaYy7gNtr3RWDMhQzUcXvcH+eK0Gpl
X-Google-Smtp-Source: ABdhPJzxuNQT3KR9Xiwm1kYNxgPWclTDtSHQ9GVjCcpk/N+zn55E2612m5c9F+PMD0JWC1l9DWlfJA==
X-Received: by 2002:a19:e302:0:b0:445:8acb:10db with SMTP id a2-20020a19e302000000b004458acb10dbmr7369063lfh.513.1646055424258;
        Mon, 28 Feb 2022 05:37:04 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i16-20020a2e5410000000b0024647722a4asm1326640ljb.29.2022.02.28.05.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 05:37:03 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH iproute2-next V2 0/4] Add support for locked bridge ports (for 802.1X)
Date:   Mon, 28 Feb 2022 14:36:46 +0100
Message-Id: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

This patch set is to complement the kernel locked port patches, such
that iproute2 can be used to lock/unlock a port and check if a port
is locked or not. To lock or unlock a port use the command:

bridge link set dev DEV locked {on | off}


To show the detailed setting of a port, including if the locked flag is
enabled for the port(s), use the command:

bridge -d link show [dev DEV]


Hans Schultz (4):
  bridge: link: add command to set port in locked mode
  ip: iplink_bridge_slave: add locked port flag support
  man8/bridge.8: add locked port feature description and cmd syntax
  man8/ip-link.8: add locked port feature description and cmd syntax

 bridge/link.c                | 13 +++++++++++++
 include/uapi/linux/if_link.h |  1 +
 ip/iplink_bridge_slave.c     |  9 +++++++++
 man/man8/bridge.8            | 11 +++++++++++
 man/man8/ip-link.8.in        |  6 ++++++
 5 files changed, 40 insertions(+)

-- 
2.30.2

