Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E78E61E5ED
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 21:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKFUeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 15:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiKFUeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 15:34:24 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D65411444
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 12:34:23 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id h10so6913400qvq.7
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 12:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LXUtH61+Ok9k33LknZ3ypxh7adyW5XtckDTU5zv1JcI=;
        b=dOPytgJKbii8w4JMSDaVwdk911ucTiuwsw3RLsAMyQydEEa4wBmtwM2PTYh1CbdL4o
         zRCD8g16zEp+VgeFOK0nQx0qxOM3U4DqwMq6Lq/YJWhKL38vq+ylYlXYQ7+N6blcYhHp
         tX3JShxdhdS+HmwP7JIMnMOWkKF/s3koCQZs5xfgcktXd5OumeqCnpVbv1As69MzCVOO
         0AEGk9XV7+rY0mMSwj48Vwtbull6a9rmqquQM2ZuRNHq+L3njhg0iPGt3BGVwQW1ba5+
         nBXL66mvoHoN2behbUnWEBDen4xuVIc7etc7iUZzzSW4cV770vaopqRtGmVWgnMDdUJ9
         MJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LXUtH61+Ok9k33LknZ3ypxh7adyW5XtckDTU5zv1JcI=;
        b=lBFZF5QhDstK/lIYRWCF1yvxZZ2z1pYl8f5ucSuKotCL9WUFU9dbU6U/XIsFmPxG//
         sGtvG+VHn9mwHVC55KSnqJAtf50B1WKzPjB9reGwUMkrsNytGY51ZR/xp3560hyrXHpb
         LGwDYGLykhCMuAec4eIoCzbfyx6lhDelRZlVJlM88O8KOSyCykMSZpRJ2lCZATi6B0oG
         hajbUx+FyxYmaNQU+xtqIMwQsaRb8bpOfyh/kyune6jdwyfSa80IJSNXGOQ2G1vsrP6G
         CiRDqUu/OCaPEB4Nf83aVZyIQ4hnG8jVtg2FBO7WznrfCyE5B8PGmiLVTbqOEXsoKtnX
         yfOQ==
X-Gm-Message-State: ACrzQf0Yg0sZD3KK1+jmdf62/EBNbciFMJZQ9m6onV8Cd26PNv/FjMx4
        68I1xaNo2aUdN8D+rqmR44IffmIMHeGpiQ==
X-Google-Smtp-Source: AMsMyM7/ex1RIYHRZKc368BhSYS5rUQp1qBJ0zepwqRGto1X2UuNkfisITl02a6Wu5lU4xiQEVDtoQ==
X-Received: by 2002:a05:6214:2a84:b0:4bc:e81:39e1 with SMTP id jr4-20020a0562142a8400b004bc0e8139e1mr29932366qvb.115.1667766862281;
        Sun, 06 Nov 2022 12:34:22 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t31-20020a05622a181f00b003a540320070sm4703551qtc.6.2022.11.06.12.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 12:34:21 -0800 (PST)
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
Subject: [PATCHv4 net-next 0/4] net: add helper support in tc act_ct for ovs offloading
Date:   Sun,  6 Nov 2022 15:34:13 -0500
Message-Id: <cover.1667766782.git.lucien.xin@gmail.com>
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
  - add the 2nd patch to extract nf_ct_add_helper from openvswitch for
    tc act_ct use.
  - go to drop instead of return -EINVAL when fails to add SEQADJ ext in
    tcf_ct_act() as Paolo noticed in the 4th patch.
  - add ct exts only when the ct is not confirmed as Pablo noticed in the
    4th patch.

v2->v3:
  - fix a warning of unused variable 'err' when CONFIG_NF_NAT is disabled
    in 2nd patch.

v3->v4:
  - have the nf_conn and ip_conntrack_info passed into nf_ct_helper() as
    Aaron suggested in the 1st patch.
  - no need to pass the 'force' into tcf_ct_skb_nfct_cached() as Marcelo
    noticed, and remove the unnecessary variable 'force' in tcf_ct_act()
    in the 4th patch.
  - fix a typo err in the cover letter as Marcelo noticed.

Xin Long (4):
  net: move the ct helper function to nf_conntrack_helper for ovs and tc
  net: move add ct helper function to nf_conntrack_helper for ovs and tc
  net: sched: call tcf_ct_params_free to free params in tcf_ct_init
  net: sched: add helper support in act_ct

 include/net/netfilter/nf_conntrack_helper.h |   5 +
 include/net/tc_act/tc_ct.h                  |   1 +
 include/uapi/linux/tc_act/tc_ct.h           |   3 +
 net/netfilter/nf_conntrack_helper.c         | 100 ++++++++++++++++
 net/openvswitch/conntrack.c                 | 105 +----------------
 net/sched/act_ct.c                          | 124 ++++++++++++++++----
 6 files changed, 214 insertions(+), 124 deletions(-)

-- 
2.31.1

