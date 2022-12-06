Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6807D644F9E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiLFXbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLFXbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:31:20 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2E142F45
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:31:19 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id fz10so15061342qtb.3
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EQ22xCPp+0IvJx+qgjvPwxnaisUB/3g2Hwop58XpnMU=;
        b=cMPlWjwsrzmr+6tZkDhM8Frf1LegpIxQvFf7x6USnXS/qTfi5trTJA5NK6C3iHZOT+
         i8NcOWDeEbhtX43xymHwEdVjmc2bc324jizao4WtraT2tev2i+aMNKC23DI/kCWWG1S6
         tqAC2GIuM2aBQtyu7H3+jfFLg12TAxQn8M/D4noN+kkFhwM5mo4RS5eZHEyKsLhMWwkX
         sBR5b/6mnm9FJFe4acppVjBKY/cHbF43uRLRuQuxdbhbbzOGS4F7B+zibh9hjE/XMxI2
         /uWfjncd/nDPc6JYDwKQPh7P4nelb7mUuVDvTEwx4FZsd4xaal969iJK78cCS8SApBZb
         KnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EQ22xCPp+0IvJx+qgjvPwxnaisUB/3g2Hwop58XpnMU=;
        b=FzmCQEXe2aPo1SlwulZh4UpnFsHaF4zUUDqecUJJOJwXGuonxhCm3OzRPAgBnF2gm5
         sY2Q2OATdF8bzOFcD3qFJYFzpnqt/Q/ztTaSnrqjSFC+Ozu9tnLRZjlROi+Hd9wP8l8D
         8393/MT5OmpZ2rFDkxjBS3O5DxcngmQw+/cb4aS5VIVXAwTSkvvXLueCXomqj6DbfR1U
         U4HY9o+AXKLXkwxdfUQpgADz5FSZnSSCNiUktpeka2xZFPBTrJS5I2vbEIrblZAyvZ8X
         Dyo1b18pr8QisLA6gmd7lSF2fgEb1oW9B6xAw7N2LY82jk+iGZyZO6QJ75fIqlTgaW2O
         F28g==
X-Gm-Message-State: ANoB5plJ+5U3dVHp6HyXnInAOGBJfQ78mySBB1xXLpzMMbZoEpXzqa2l
        ZKYb/1fS8U6g3d89PLDBnVs4whkDMw4=
X-Google-Smtp-Source: AA0mqf46CvXaC/EolTygpOtN4AOboQnv1dlf6Ev9JNtEHprlp2WIBewONbRY9TTJlJBN8Nq9UWiy1g==
X-Received: by 2002:ac8:5e83:0:b0:39c:c7ba:4af4 with SMTP id r3-20020ac85e83000000b0039cc7ba4af4mr68188923qtx.99.1670369478375;
        Tue, 06 Dec 2022 15:31:18 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i21-20020a05620a405500b006f8665f483fsm16590231qko.85.2022.12.06.15.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:31:17 -0800 (PST)
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
Subject: [PATCHv3 net-next 0/5] net: eliminate the duplicate code in the ct nat functions of ovs and tc
Date:   Tue,  6 Dec 2022 18:31:11 -0500
Message-Id: <cover.1670369327.git.lucien.xin@gmail.com>
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
  - Fix a typo in subject of patch 2/5, as Marcelo noticed.
  - Fix in openvswitch to keep OVS ct nat and TC ct nat consistent in
    patch 3/5 instead of in tc, as Marcelo noticed.
  - Use BIT(var) macro instead of (1 << var) in patch 5/5, as Marcelo
    suggested.
  - Use ifdef in netfilter/Makefile to build nf_nat_ovs only when OVS
    or TC ct action is enabled in patch 5/5, as Marcelo suggested.

Xin Long (5):
  openvswitch: delete the unncessary skb_pull_rcsum call in
    ovs_ct_nat_execute
  openvswitch: return NF_ACCEPT when OVS_CT_NAT is not set in info nat
  openvswitch: return NF_DROP when fails to add nat ext in ovs_ct_nat
  net: sched: update the nat flag for icmp error packets in
    ct_nat_execute
  net: move the nat function to nf_nat_ovs for ovs and tc

 include/net/netfilter/nf_nat.h |   4 +
 net/netfilter/Makefile         |   6 ++
 net/netfilter/nf_nat_ovs.c     | 135 ++++++++++++++++++++++++++++++
 net/openvswitch/conntrack.c    | 146 +++------------------------------
 net/sched/act_ct.c             | 136 +++---------------------------
 5 files changed, 169 insertions(+), 258 deletions(-)
 create mode 100644 net/netfilter/nf_nat_ovs.c

-- 
2.31.1

