Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746BE613A28
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiJaPgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiJaPgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:36:15 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A658DF11
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:13 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id i9so5015765qki.10
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=alCnd3U2thrl53d6NgicCkR/gub3iW2ufyxIOyssvJw=;
        b=PJqMySA4WD52WbrLsszCvCOpVGE3vPxXr4CKrDzdGKvjJ+Lfs4iQM8xgYd4cXYZn4S
         8d42wvPZ3DTYMlfmqJcG8M6RmEYZNBv7TRq7GhwN4R+GLOY0dmD1sTlxMHCliVkOE6bi
         wL1AAdgskhvwqh9WkzY+t6cTM+cycCmO9+4WWHNf56yTtOMdNiiAzH2/z8yHqJKKDQeN
         EClSvNlrcRSPybu+QU07VcE8Qaq1KxHvUHdQVDj1HBaxXxd6NG522Rfa2HkQmgwLMqQr
         +x/MbVlG2fgR9tyaQ/IefThUyfslkxCM2g5+Z9mJS+TZTScEmqSNXhhtdE6vCh+zyFoP
         aR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=alCnd3U2thrl53d6NgicCkR/gub3iW2ufyxIOyssvJw=;
        b=1QVbFboHVbGcUqA0gJ6/oCirncno6rtxdVXlHzlvsxwLbr38E/+T2AouqrL3mbPoN7
         PAmtNzWf7JnJc3++tMnwGjttRdqId7HujrRe9y0FSzzjpsOi76RPdMVPhQyObPdPYfje
         eii0NL2PSZfe3FbHlgaOZ7I0fzLYzF5rJB1Q1tRJCrAxzCH12f60MRxefVRMDw/ESE0W
         oouIqzuYkbEPjBw4uCN49nIQ+TEGBl2T+JzDngR8ZBk+jOZkNpExUUJtkhrjhP+pCrii
         XrEEpY4seJC1txdiJBGh9HYeGKMF7MqTkOJB+kId4wHdyiUnu52CYcEo8Y3n4Au+glhx
         WH/A==
X-Gm-Message-State: ACrzQf2/WpZNa/F7tvSh17inibASUr3DuCkq6G/jZblNSH2Hp+hsf8B+
        I6t9bxOziYQIattACtDHw/G23s7fptqGCA==
X-Google-Smtp-Source: AMsMyM4cl1GwWAo7gCaSfRth5RogYIQokXD2WK7zCPGEP8VDfT9KHnwrIUr7Az1AA8s+y3otW0ktBQ==
X-Received: by 2002:a05:620a:1597:b0:6fa:311a:933c with SMTP id d23-20020a05620a159700b006fa311a933cmr2846332qkk.741.1667230572397;
        Mon, 31 Oct 2022 08:36:12 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi29-20020a05620a319d00b006f956766f76sm4957924qkb.1.2022.10.31.08.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 08:36:11 -0700 (PDT)
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
Subject: [PATCHv3 net-next 0/4] net: add helper support in tc act_ct for ovs offloading
Date:   Mon, 31 Oct 2022 11:36:06 -0400
Message-Id: <cover.1667230381.git.lucien.xin@gmail.com>
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

lya reported an issue that FTP traffic would be broken when the OVS flow
with ct(commit,alg=ftp) installed in the OVS kernel module, and it was
caused by that TC didn't support the ftp helper offloaded from OVS.

This patchset is to add the helper support in act_ct for OVS offloading
in kernel net/sched.

The 1st and 2nd patches move some common code into nf_conntrack_helper from
openvswitch so that they could be used by net/sched in the 4th patch (Note
there are still some other common code used in both OVS and TC, and I will
extract it in other patches). The 3rd patch extracts another function in
net/sched to make the 4th patch easier to write. The 4th patch adds this
feature in net/sched.

The user space part will be added in another patch, and with it these OVS
flows (FTP over SNAT) can be used to test this feature:

  table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk \
    actions=ct(table=1, nat), normal
  table=0, in_port=veth2,tcp,ct_state=-trk actions=ct(table=1, nat)
  table=0, in_port=veth1,tcp,ct_state=-trk actions=ct(table=0, nat)
  table=0, in_port=veth1,tcp,ct_state=+trk+rel actions=ct(commit, nat),normal
  table=0, in_port=veth1,tcp,ct_state=+trk+est actions=veth2"

  table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new \
    actions=ct(commit, nat(src=7.7.16.1), alg=ftp),normal"
  table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+est actions=veth2"
  table=1, in_port=veth2,tcp,ct_state=+trk+est actions=veth1"

v1->v2:
  - go to drop instead of return -EINVAL when fails to add SEQADJ ext in
    tcf_ct_act() as Paolo noticed.
  - add the 2nd patch to extract nf_ct_add_helper from openvswitch for
    tc act_ct use.
  - add ct exts only when the ct is not confirmed as Pablo noticed.

v2->v3:
  - fix a warning of unused variable 'err' when CONFIG_NF_NAT is disabled.

Xin Long (4):
  net: move the ct helper function to nf_conntrack_helper for ovs and tc
  net: move add ct helper function to nf_conntrack_helper for ovs and tc
  net: sched: call tcf_ct_params_free to free params in tcf_ct_init
  net: sched: add helper support in act_ct

 include/net/netfilter/nf_conntrack_helper.h |   4 +
 include/net/tc_act/tc_ct.h                  |   1 +
 include/uapi/linux/tc_act/tc_ct.h           |   3 +
 net/netfilter/nf_conntrack_helper.c         | 102 +++++++++++++++++
 net/openvswitch/conntrack.c                 | 105 +----------------
 net/sched/act_ct.c                          | 118 ++++++++++++++++----
 6 files changed, 212 insertions(+), 121 deletions(-)

-- 
2.31.1

