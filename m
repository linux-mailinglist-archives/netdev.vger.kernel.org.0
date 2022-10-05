Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A105F4D52
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 03:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJEBUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 21:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJEBUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 21:20:04 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEF21B9CD
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 18:20:00 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id m81so16187107oia.1
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 18:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=vs2R3sdfHragw4m02Qde1ECtO+7VgByP/jLcSBjBgp0=;
        b=ero3bgotB7MnH6Z2EuYtj/e0lQi4B24ihjncvf2OxPMpM49hPqHY9cbjApLnf2mIBC
         U1Si13pgm85pwyeDCA0mt7eUNgWGfp3QG2R+ixyThcnF/+2jl3bWXaujUwezVfgoa6Yf
         reaKguSdNgeLMyOj/mywiPFgoP8k+/E+LDCbfKGjWOKNFbcMZq4nYOwBWiEk3mP3Byj3
         8XMYMs9yGY2WzzFE12ooUtbfOCphCL+IdU/OpsUaAkwMbxmwdH/NeQtJ6YUeW4Pd4C5q
         OL6lI9ty++cb95A2+uOLKdnELyoaYPk/FDJe/KQez2TtakSZnf+yPBBkaf91Rqo7nwqO
         kMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=vs2R3sdfHragw4m02Qde1ECtO+7VgByP/jLcSBjBgp0=;
        b=XP+8q9anwskcBBn9xrRa1HGpI79q7cGLR5ybbx9yNC/afZLTQCBWhFiclfg7kvMUsA
         0b2OsD9dtY8gLDHgO/G72kvLaTrOFjHuC1UjhxxnZ+XEV9nu4C0IZGs5DW+WHsZaEVY0
         qqQ9dkUkxnUqIQ0vRb9Vh5mxsT7Uv1b6M2xZaETC4e9DFTcnpgU1MMV8z/xnTjlWxGKI
         tiGqK3eSY4m2B4IDdbxKGU+I7OtSpRIc0q2gS7slxrD6Ik4YlTIFy5UjEFU1v/Ef4tj4
         3WRPwYCPdfHF0OcfuWS7ZAy/6xbYwla4zK/2QL7hfB4C2+7BImip/c8JpWb8jhaSHzck
         B0PA==
X-Gm-Message-State: ACrzQf2qlgnkUIEowk/I04oqzx7nyYRL78NQvAfoR7b3f8KFCVwbwEpF
        Ex1SHBpD6xn7/wz89NESf6jfjFh0FjZ2OQ==
X-Google-Smtp-Source: AMsMyM6aTpPg4l1MdwGUyClcBFgwNpAZg/en3pT6Hp84wizyx8t5zOULBZ709JnpleqeFxr0k7QAjA==
X-Received: by 2002:a05:6808:e8e:b0:353:eff5:f4a6 with SMTP id k14-20020a0568080e8e00b00353eff5f4a6mr1149721oil.98.1664932799040;
        Tue, 04 Oct 2022 18:19:59 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id ce4-20020a056830628400b00660a927e3bcsm1631787otb.25.2022.10.04.18.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 18:19:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: [PATCH net-next 0/3] net: add helper support in tc act_ct for ovs offloading
Date:   Tue,  4 Oct 2022 21:19:53 -0400
Message-Id: <cover.1664932669.git.lucien.xin@gmail.com>
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

This patchset is to add the helper support in act_ct for ovs offloading
in kernel net/sched.

The 1st patch moves some code from openvswitch into nf_conntrack_helper
so that it can be used by net/sched in the 3rd patch (Note there are
still some other common code used in both OVS and TC and I will extract
it in other patches). The 2nd patch extracts another function in net/
sched to make the 3rd patch easier to write.

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

Xin Long (3):
  net: move the helper function to nf_conntrack_helper for ovs and tc
  net: sched: call tcf_ct_params_free to free params in tcf_ct_init
  net: sched: add helper support in act_ct

 include/net/netfilter/nf_conntrack_helper.h |   2 +
 include/net/tc_act/tc_ct.h                  |   1 +
 include/uapi/linux/tc_act/tc_ct.h           |   3 +
 net/netfilter/nf_conntrack_helper.c         |  71 ++++++++++
 net/openvswitch/conntrack.c                 |  61 +-------
 net/sched/act_ct.c                          | 148 +++++++++++++++++---
 6 files changed, 204 insertions(+), 82 deletions(-)

-- 
2.31.1

