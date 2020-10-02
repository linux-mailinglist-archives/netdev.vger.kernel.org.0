Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77F2281E95
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJBWoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:44:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJBWoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601678671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=KX85JrH7cu5r2zy6VsqSHBNHlS+PP+pE31VVHICC7Hg=;
        b=PjxYTkVnvc+bann69TzPaukhePZnQPa4ToSPR24YN2JXw7qZQFLmUskX1H2ZyL1WhCB8sH
        7D3z8ZQ+pGR1BjNUgGyuatnkyfI/3o6VfSakh8/QrtR14VEIFZCBnhml69LTX+MhL7PHMF
        nQ8iGO4W9OnBWi3iNYcedZdcprvyT9E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-EcNg9aEdPsyrEUyYH8PbMg-1; Fri, 02 Oct 2020 18:44:29 -0400
X-MC-Unique: EcNg9aEdPsyrEUyYH8PbMg-1
Received: by mail-wr1-f71.google.com with SMTP id v12so1096067wrm.9
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=KX85JrH7cu5r2zy6VsqSHBNHlS+PP+pE31VVHICC7Hg=;
        b=Z6uO5KhtASOprQb3GB+lqZu2R32j5LAjHdO8paTq3a+pceWWQymSLhT5ATmAiqA4tF
         uBEhjuyw9E4RnIlxfq2OvmXQ1nNGs59e8mnBWsjqiI0mw8oeg3LDFmq08qj77AW77epp
         LQluovzqQ9nCSmrfkSdv3yZruJQBZPfHjfNEmP5DEAxEiTzkavqqs50MBec5GFNk51ar
         CC9Vwxfp/72+awDf8MTNfH430VEODrWXEEOFP5LVc7UkW5UwTZ8iiMw3PLxVb7n7LRHW
         KiTswjeMSKX/IAwMtskHgOGhEfe0TEXMNPAIu6LSYi2vvX/DZvQsk6Q5vfyHavVe+viH
         esfA==
X-Gm-Message-State: AOAM532c3Yf7UE3f6apYMbTJDoN3r8HEVzj+XdFAKYZ0KCzgDkTSX4tb
        NCglEuLEPE94H6fGcPPrB/cf0ifgNqd7JPAFAsQtUmwCXzxt3pTT9QiUX28hHm79pWd4/1ovmZJ
        5OovKygd09aLTk4rB
X-Received: by 2002:adf:80e4:: with SMTP id 91mr5256449wrl.223.1601678668097;
        Fri, 02 Oct 2020 15:44:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjO2KSSh6X6/HINRnHlL9vpt1H99BCQJ/AFQuIPWfHvQrtsvhDI2MayCLKXNm+NgKA08e14A==
X-Received: by 2002:adf:80e4:: with SMTP id 91mr5256437wrl.223.1601678667892;
        Fri, 02 Oct 2020 15:44:27 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id c14sm3227763wrm.64.2020.10.02.15.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 15:44:27 -0700 (PDT)
Date:   Sat, 3 Oct 2020 00:44:25 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Benc <jbenc@redhat.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 0/2] net/sched: Add actions for MPLS L2 VPNs
Message-ID: <cover.1601673174.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds the necessary TC actions for supporting layer 2
MPLS VPNs (VPLS).

The objective is to give the possibility to add an MPLS header right
before an skb's mac header, then to prepend this MPLS packet with a
new Ethernet header with the MAC address of the next hop.

Patch 1 implements the actions for adding and removing the external
Ethernet header.
Patch 2 adds the possibility to push an MPLS header before the mac
header.

Most of the code already exists as these operations were first
implemented in openvswitch.

Practical example, with encap on Host-A and decap on Host-B:

 Host-A# tc filter add dev ethAx ingress matchall         \
           action mpls mac_push label 20                  \
           action vlan push_eth dst_mac 02:00:00:00:00:02 \
                                src_mac 02:00:00:00:00:01 \
           action mirred egress redirect dev ethAy

 Host-B# tc filter add dev ethBx ingress protocol mpls_uc \
           flower mpls_label 20 mpls_bos 1                \
           action vlan pop_eth                            \
           action mpls pop proto teb                      \
           action mirred egress redirect dev ethBy

Guillaume Nault (2):
  net/sched: act_vlan: Add {POP,PUSH}_ETH actions
  net/sched: act_mpls: Add action to push MPLS LSE before Ethernet
    header

 include/linux/skbuff.h              |  3 ++
 include/net/tc_act/tc_vlan.h        |  2 +
 include/uapi/linux/tc_act/tc_mpls.h |  1 +
 include/uapi/linux/tc_act/tc_vlan.h |  4 ++
 net/core/skbuff.c                   | 67 +++++++++++++++++++++++++++++
 net/openvswitch/actions.c           | 28 +++++-------
 net/sched/act_mpls.c                | 18 ++++++++
 net/sched/act_vlan.c                | 40 +++++++++++++++++
 8 files changed, 145 insertions(+), 18 deletions(-)

-- 
2.21.3

