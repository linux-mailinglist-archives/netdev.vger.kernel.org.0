Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36A06017AE
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiJQTbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiJQTa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:30:56 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA2C792DD
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:06 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id m6so7320275qkm.4
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0EQeJLAe2BW5Fo0EJooGVQ92hGY26S0wozQBX1tU25Y=;
        b=CSV5+xuC5yp596P13XmEQuA2tC6iH894Me3QwN37QluxNqrOBH/nsweLcHjE4M2Pbo
         vICN9hXF8V2Ibg8NzqGhBPx3iLwSZDLbHa4zN5buGRRrlNEs97eki6s0xEbri1OCjJ7i
         A9JRPZRRqa43iEQ11V7ODeAxL1tDPPjSPVjkWHlk9WtRTlN1FoclSWE4W/bXfu/QBEZC
         ClNgwzqcltXRAVLJI5wzNQ+lAoX+vehLULGth18q9TqVQrMgrKOD06+E/PyIMzn5rdPq
         5SEZlza8TkUJz6Rz55VTW3B4PC/2AF735xAr6RJqIxvRj1TagJ48LNyWPunL0p+ckE6g
         y6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0EQeJLAe2BW5Fo0EJooGVQ92hGY26S0wozQBX1tU25Y=;
        b=j5kEDfF4HVzrYsv5An5/0+Oiu6PTgsroxBl+4kDg5bGtTxQuJt2sbcsywukvz6V9Ac
         dspaqKnlrS2xK5hEhOfN4Uq5XwdWtWo9tF75xw+x9n1oycRi46oJ5AeU9Ahm0NOiOGHu
         Aru92cx4QIkHJl9KzVePFAreVqSnAct5WlN3ANRkg3PyVoZm4MuId1cSWNO88mkrk/Bg
         xXZ0spddvVqQKFZ6prC249UsudXXBD1ubwAmY92sMJ32GMUu72IXVBFCmSumI+2axUVt
         NKpxCBaQQ+9aPXsPu2+IkxsiP1Mm9CttUlMASBJqoYJ2CabXuSYTSUwr3RXwZQ5i/dxx
         j+oQ==
X-Gm-Message-State: ACrzQf0nWRIB4LSXo1Vd1c+FLnLlU3zx2Kv0kKc1mxfJ6cxoTFInm2Sg
        eyb1UDon00hTwWT8qQUh4M0a0gdG07IFjA==
X-Google-Smtp-Source: AMsMyM5G8H1SN4v3lX+OyxM7lVBxpIOKXQgheXiGoSoQYWYRuBcWgjTKRc+Dgu3z21sPJRejRLrtNw==
X-Received: by 2002:a05:620a:1373:b0:6ee:b177:2b7b with SMTP id d19-20020a05620a137300b006eeb1772b7bmr9032442qkl.618.1666034971397;
        Mon, 17 Oct 2022 12:29:31 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b0035ba48c032asm423831qts.25.2022.10.17.12.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:29:30 -0700 (PDT)
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
Subject: [PATCH net-next 0/4] net: add helper support in tc act_ct for ovs offloading
Date:   Mon, 17 Oct 2022 15:29:24 -0400
Message-Id: <cover.1666034595.git.lucien.xin@gmail.com>
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

Ilya reported an issue that FTP traffic would be broken when the OVS flow
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

