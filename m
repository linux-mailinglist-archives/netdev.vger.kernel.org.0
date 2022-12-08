Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FEF6474BB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiLHQ4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiLHQ4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:56:17 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E4070BA8
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:56:16 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c15so1500704qtw.8
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=II3ttIizWuH7E1+OJmdAzRbHL4/p74C7Q3n9+fOu4Q0=;
        b=P1lhu3XBXWbmf5SlM5ITk0qAtAyB7ewlOwY/NXBh5vczsix34Zvl/h3+FAHbOpr2o4
         oYamljSicwVFgtptSobDmS+j20XYHpdoCk9mt7g5Py2srTN0VEaT+CbV8tBAYPwAmXoa
         C7MU7KooNoQV5aX2VhtLvfUpbttYrfx03mMkvAS3SwGOZdF62LtpkyVFNd59nOedJkNK
         BN4jKEGZtXnqGxhlklCk3vGHK/2ggbwpztRDhU8b9t/6PyHNVlmL2iA6l5NldZsjTagh
         dOY8QdhPdNCaMB8LlUeGQnILvQq9+nCZFndJsHzQ05eZiN5gZ5xjpHQ1wYsyir6qW+OQ
         PIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=II3ttIizWuH7E1+OJmdAzRbHL4/p74C7Q3n9+fOu4Q0=;
        b=bpVyBiRJr3X6NH/cMJOPZpk8I5HhCcTRrM9UcpX8z79oKmLI/0SdmUBwMW0UMVppsm
         8dVPqsYLAfsuMJZKMuLdBGp6PDPhuIRnv1fEbYJ+H7IYxy2N/xcKCh5NwbFDBegmA9np
         UFrlHnAedReQkpS0HAITTqhfDP67WQRv5OYlgT428nHLuyWg5dzlx0Hb5nIdOzpR5uZY
         7E5vWPOh+BFEnJ31QNuC3VbS/9R2D+XF+m1PsAGCufIQvdRHMJdA0/hgnwGl9shrn6Xy
         eV2778z9viXYgLdXE+a8Ot3fuCjZ2x9ec+Z1sODQejKiDdJe6x8SM+J8vY7cDY7Xq8Fa
         9r1Q==
X-Gm-Message-State: ANoB5pldhCh3cETDGZ5sxbI05p5EM4A+dBya8obJjEr9AXtpqWdrx3h3
        Xq34TS9HFVXNCBEDUTOgH8dcCaqiAmOCAA==
X-Google-Smtp-Source: AA0mqf5zxkTMKip3XuOxRzM3ZIeeQplcTtDL+fqjzMthQpNZDtTgqy4UTUMhlbOZl/3px0XyGUxtUw==
X-Received: by 2002:ac8:5a8c:0:b0:3a5:460f:9650 with SMTP id c12-20020ac85a8c000000b003a5460f9650mr5742102qtc.46.1670518575101;
        Thu, 08 Dec 2022 08:56:15 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j13-20020a05620a288d00b006fbbdc6c68fsm20091298qkp.68.2022.12.08.08.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:56:14 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCHv4 net-next 0/5] net: eliminate the duplicate code in the ct nat functions of ovs and tc
Date:   Thu,  8 Dec 2022 11:56:07 -0500
Message-Id: <cover.1670518439.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

The changes in the patchset:

  "net: add helper support in tc act_ct for ovs offloading"

had moved some common ct code used by both OVS and TC into netfilter.

There are still some big functions pretty similar defined and used in
each of OVS and TC. It is not good to maintain such big function in 2
places. This patchset is to extract the functions for NAT processing
from OVS and TC to netfilter.

To make this change clear and safe, this patchset gets the common code
out of OVS and TC step by step: The patch 1-4 make some minor changes
in OVS and TC to make the NAT code of them completely the same, then
the patch 5 moves the common code to the netfilter and exports one
function called by each of OVS and TC.

v1->v2:
  - Create nf_nat_ovs.c to include the nat functions, as Pablo suggested.
v2->v3:
  - fix a typo in subject of patch 2/5, as Marcelo noticed.
  - fix in openvswitch to keep OVS ct nat and TC ct nat consistent in
    patch 3/5 instead of in tc, as Marcelo noticed.
  - use BIT(var) macro instead of (1 << var) in patch 5/5, as Marcelo
    suggested.
  - use ifdef in netfilter/Makefile to build nf_nat_ovs only when OVS
    or TC ct action is enabled in patch 5/5, as Marcelo suggested.
v3->v4:
  - add NF_NAT_OVS in netfilter/Kconfig and add select NF_NAT_OVS in
    OVS and TC Kconfig instead of using ifdef in netfilter/Makefile,
    as Pablo suggested.

Xin Long (5):
  openvswitch: delete the unncessary skb_pull_rcsum call in
    ovs_ct_nat_execute
  openvswitch: return NF_ACCEPT when OVS_CT_NAT is not set in info nat
  openvswitch: return NF_DROP when fails to add nat ext in ovs_ct_nat
  net: sched: update the nat flag for icmp error packets in
    ct_nat_execute
  net: move the nat function to nf_nat_ovs for ovs and tc

 include/net/netfilter/nf_nat.h |   4 +
 net/netfilter/Kconfig          |   3 +
 net/netfilter/Makefile         |   1 +
 net/netfilter/nf_nat_ovs.c     | 135 ++++++++++++++++++++++++++++++
 net/openvswitch/Kconfig        |   1 +
 net/openvswitch/conntrack.c    | 146 +++------------------------------
 net/sched/Kconfig              |   1 +
 net/sched/act_ct.c             | 136 +++---------------------------
 8 files changed, 169 insertions(+), 258 deletions(-)
 create mode 100644 net/netfilter/nf_nat_ovs.c

-- 
2.31.1

