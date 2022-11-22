Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8925634280
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbiKVRc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbiKVRc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:32:26 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A7479904
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:24 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id a27so9711058qtw.10
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=45UKwpaZ0ojp//xrAt6TOaP2n3Evj393Rr+zK5eFo7w=;
        b=G/t9TZhqBdaLrYcuYmpcU+t5aimCptlsFE3RuxBUmhSEQvPVMWon137+tNnUQ0DYmN
         z4Ndt+u8tMnFbp/T96sGE/+e93740B8VDJ4fWDnyg4O3eKwDjg3gfRxYyYB61kocw7bC
         i00q0bIQZcCY3m6UjDG4E24wzz2tZAABT6QhSuzoe6vIED9RtsWxdwI4SF+czR6uq/q7
         TsQoqBNVFAv+ad0NFohiPIVRE3LlsFlEBYCFx+ZyGT+id+yyPZQmutXWIP8f5pgHoXK1
         SVRbPCqrMfOlLp4O8dz7VV7cJT7uYOw2kIbDBo0Mt8Pvsu7eZxp5ej+PQANSx0nbxEq0
         7KQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45UKwpaZ0ojp//xrAt6TOaP2n3Evj393Rr+zK5eFo7w=;
        b=0BMxeGYlquRvAJH2f+XU98I5XaxrXKpwP6Lu752ab3c85PWo2zfPa2FtwR1UU8VSTD
         hMCgTnRdgAKI2IcOPVonpkpAkev07ZES38XkVdyIzhDdjbu+EIoq0CGqikBCA+ul2U5I
         1prt+gDTCraxYb4SQeUDeuWLqzoEIS3ilyzoufalB+le2/50zfhKsL0YsAR3quN1IvLz
         hF5fU+41gw4j8QmKnFIYRLHJi9AngQKyN5JGqq8jaFb+ZnxQE1ggJCSGSWd8baoqVtl0
         ZJu6IOLD5HyAqK5QZwGwjh/WGLpJ/fPlNGysAQOzafAtNBGyOgg8c+9yG4f0bBa0mvSM
         qdDQ==
X-Gm-Message-State: ANoB5pmDKpMDu/kQgeiEzIfaDJtnVI/EpgYLiQM/GtctM9EIFiCJvgI3
        z7ToXnxttOBttYOOVYl0N2LTskI+B4U=
X-Google-Smtp-Source: AA0mqf4sObt95jxPsEnbzvnMU2XdHUSCgxjCoRIO6jpnuJMqeIGzlFadrOgqQ0bsyyFlLt50SE/hbg==
X-Received: by 2002:ac8:5506:0:b0:3a2:9e2f:2ead with SMTP id j6-20020ac85506000000b003a29e2f2eadmr5805317qtq.555.1669138343488;
        Tue, 22 Nov 2022 09:32:23 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a410c00b006eef13ef4c8sm10865040qko.94.2022.11.22.09.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:32:22 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
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
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 0/5] net: eliminate the duplicate code in the ct nat functions of ovs and tc
Date:   Tue, 22 Nov 2022 12:32:16 -0500
Message-Id: <cover.1669138256.git.lucien.xin@gmail.com>
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

Xin Long (5):
  openvswitch: delete the unncessary skb_pull_rcsum call in
    ovs_ct_nat_execute
  openvswitch: return NF_ACCEPT when OVS_CT_NAT is net set in info nat
  net: sched: return NF_ACCEPT when fails to add nat ext in
    tcf_ct_act_nat
  net: sched: update the nat flag for icmp error packets in
    ct_nat_execute
  net: move the nat function to nf_nat_ovs for ovs and tc

 include/net/netfilter/nf_nat.h |   4 +
 net/netfilter/Makefile         |   2 +-
 net/netfilter/nf_nat_ovs.c     | 135 ++++++++++++++++++++++++++++++
 net/openvswitch/conntrack.c    | 146 +++------------------------------
 net/sched/act_ct.c             | 136 +++---------------------------
 5 files changed, 164 insertions(+), 259 deletions(-)
 create mode 100644 net/netfilter/nf_nat_ovs.c

-- 
2.31.1

