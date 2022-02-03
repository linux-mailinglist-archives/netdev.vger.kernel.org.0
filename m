Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BDC4A836F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350358AbiBCMAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiBCMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:00:19 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82687C061714;
        Thu,  3 Feb 2022 04:00:19 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id j10so2094777pgc.6;
        Thu, 03 Feb 2022 04:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JnJnF7I1vOkT/T0VywoHxB+TaCMJwCPbgwooI5xDV98=;
        b=loqCnqMqiYaPpdswhmcBPJAWFnNAOPKQKbeDFehraDVSFS9arV6C+yF9oFUdA7txvJ
         zcrAVtVyJEC7ziXiEM+mxlE9CfnDdXCWSdkIseg6A0JC/1zPNKXVXETTLz0PZfB4sSr4
         WFjLuxmY0Wpb1vi99RUw5QrsFw7sRQSnZc6ucp+LCG6gYHNPyEY5jCejPFp3fgqfVIik
         wDcx9QzJ0UflGduqriuRHLzqZ2HzC3a1yePrHV2R/FspVLp1T2f7q9y/r6uOWlo61jVZ
         Uelerk0QBGuJ3VabbS78VRAiVC/VJqtqL5nIrUB+GW14/RI5m5cYpslK/L1gjMSkKWpu
         Dhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JnJnF7I1vOkT/T0VywoHxB+TaCMJwCPbgwooI5xDV98=;
        b=JK7RJ1M/DXnfPdS5/azxvXM181tbL8GTgXZ/tMXeTLli4cNmb4jxH+VOLFT2xW4Zrs
         cgogE6qrZuDJ/h3Z1E+F+pUFQKa6u9YKCsTJTTjLpueP5ctcueabXJfp4/XqpQUAyq37
         0b+ndBBMNt4qNlawKkqoH6HS0ioXEsGT6NMWsuVW/cfC6Gnr3rjH2W3K5IeBXQk+i5XH
         cC/MlRmE3/TFPRa8DqLkCsOzhSJeQWJQq6jsI7zWWZr/IxgybjDaCyC88wymMFa4aARd
         aluD6JEN406zBQDWh4Rg1V8ETLpWYvvcvaRBKdyISiiU3jGeRY5YlmcD7L6ogG5cXqa2
         kGAA==
X-Gm-Message-State: AOAM531vAV0Sgu5DExWhYEKRFVF17/E2Y4tEqHMTlR7AAqvo2VzDfaRh
        HVrrxn6rKtxmliMWxnBrRuc=
X-Google-Smtp-Source: ABdhPJwDVhmYNwbuKIOPxnjpxGVd1TyzQ6etToNCUx2Q2W02tBWbgZ9jPJtAmSm5J6dUjjHS4LgT5g==
X-Received: by 2002:a63:8842:: with SMTP id l63mr26391780pgd.421.1643889619054;
        Thu, 03 Feb 2022 04:00:19 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id f12sm16506697pfc.70.2022.02.03.04.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 04:00:17 -0800 (PST)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Paul Blakey <paulb@nvidia.com>
Subject: [PATCH net-next 0/3] Conntrack GRE offload
Date:   Thu,  3 Feb 2022 20:59:38 +0900
Message-Id: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conntrack offload currently only supports TCP and UDP.
Thus TC/nftables/OVS cannot offload GRE packets.

However, GRE is widely used so some users create gre devices in VMs,
and in that case host OVS forwards GRE packets from/to VMs.

In order to offload GRE packets in OVS with stateful firewall support,
we need act_ct GRE offload support.

This patch set adds GRE offload support for act_ct and mlx5 conntrack.
Currently only GREv0 and no NAT support.

- Patch 1: flow_offload/flowtable GRE support.
- Patch 2: act_ct GRE offload support.
- Patch 3: mlx5 conntrack GRE offload support.

Tested with ConnectX-6 Dx 100G NIC and netperf TCP_STREAM.

                      +------------------------------------+
                      |                        +-----------+
                      |                        |(namespace)|
  +---------+         |                        | netserver |
  |         |  wire   +----+  tc   +--------+  +-------+   |
  | netperf |-------->|mlx5|------>|mlx5 rep|--|mlx5 vf|   |
  |         |         +----+       +--------+  +-------+---+
  +---------+         +------------------------------------+

- No offload (TC skip_hw): 8.5 Gbps
- Offload    (act_ct)    : 22 Gbps

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (3):
  netfilter: flowtable: Support GRE
  act_ct: Support GRE offload
  net/mlx5: Support GRE conntrack offload

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  21 +++--
 net/netfilter/nf_flow_table_core.c                 |  10 +-
 net/netfilter/nf_flow_table_ip.c                   |  54 +++++++++--
 net/netfilter/nf_flow_table_offload.c              |  19 ++--
 net/netfilter/nft_flow_offload.c                   |  13 +++
 net/sched/act_ct.c                                 | 101 ++++++++++++++++-----
 6 files changed, 171 insertions(+), 47 deletions(-)

-- 
1.8.3.1

