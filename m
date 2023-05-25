Return-Path: <netdev+bounces-5397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA2C71117C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61B791C20F1D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C1E19532;
	Thu, 25 May 2023 16:59:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989983D7C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:59:27 +0000 (UTC)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB58197
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:59:25 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5343c3daff0so1323144a12.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685033965; x=1687625965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E4HwbWVSwZYHAz8V2xubbDDkUlRRamOtQxQnCL0RkJ0=;
        b=KQHHNabeDpuoSxyeVFJ17o2zaqR8zFgF16dloshGB7cxfG5EoxLPS/jmJ8XzfEfZ1u
         /sDedCeBabKAM1iS/4sLRF+m5NyUF3iI/agqj4TbtUQvCcL8DEpaaB+FFAZovdJRf/7i
         x3i/KwxI5AEPzCWOoXPIem+bhyBYolytAFmT4MX2uQovxSMR9l50CPGd362VM+H1xwqh
         QEHrrvmfPdkkhoFOvKD8Dhp7eVqQ4cMOmuqlFWFZRQIa4sKrU340QZPrNz5LHHiYiHaC
         rNrZ7Edk3rQMfKQJtDzCfEkKSSHumrM3k8YTLrbFkvqqi0PbWmc0UyzgpTTA3qzskDdB
         Vhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685033965; x=1687625965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E4HwbWVSwZYHAz8V2xubbDDkUlRRamOtQxQnCL0RkJ0=;
        b=WGAPsozOQjV6Fu1PCenkYhs9R5r3qf2qoGKcHTg99DXyXbeDSfW5NomMhcTEWn2qI1
         cLtl4QVh4IYZdGLj41I7gG82DB7V9jz93UCB1tABQ0rXcEXfpB1KTyYFf4n71mGPSUW5
         zwOTOvglErf578hKGdMETMHonhkAdcmD9bYb4CzGr+mzc5wbYgLwdwXMAzRZP0rdEvIh
         5iGr4PLNpmc+NdfU7DUOOQjjNpCjd5EG8WiKXF770vv2FsvI3gJcyd9yqXYp/5w0Gju1
         P5Rf3AAlySyY7xT7QD27BkgakaZIqo80hZd4/xAucSMJ+7qOAraVeo3J8Hw/1aJvQLSq
         /Z3A==
X-Gm-Message-State: AC+VfDwnIAXca4kdn7yWFmxZ7aKclJ525vMJDNc4qUxCjVhgPWcSmjjK
	KU4ZBwPjEZlQ0wddd61dc4S7ckusQonoQ5awgf2KzQ==
X-Google-Smtp-Source: ACHHUZ6DFyKY70rHcAuwe4spJ7UkispTooSjosCI8GjJjrkIJqby/Ph9WiQDEb7OrH9YX1qo9Ou5eA==
X-Received: by 2002:a17:902:c1c4:b0:1ae:56ff:74a with SMTP id c4-20020a170902c1c400b001ae56ff074amr2160840plc.58.1685033965051;
        Thu, 25 May 2023 09:59:25 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902e88300b00194d14d8e54sm1662111plg.96.2023.05.25.09.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 09:59:24 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v3 0/2] vxlan: option printing
Date: Thu, 25 May 2023 09:59:20 -0700
Message-Id: <20230525165922.9711-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset makes printing of vxlan details more consistent.
It also adds extra verbose output.

Before:
$ ip -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536 

After:
$ ip -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536

To get all settings, use multiple detail flags
$ ip -d -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan noexternal id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 learning noproxy norsc nol2miss nol3miss ttl auto ageing 300 udp_csum noudp_zero_csum6_tx noudp_zero_csum6_rx noremcsum_tx noremcsum_rx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536

Stephen Hemminger (2):
  vxlan: use print_nll for gbp and gpe
  vxlan: make option printing more consistent

 include/json_print.h |  9 +++++
 ip/iplink_vxlan.c    | 95 ++++++++++----------------------------------
 lib/json_print.c     | 19 +++++++++
 3 files changed, 48 insertions(+), 75 deletions(-)

-- 
2.39.2


