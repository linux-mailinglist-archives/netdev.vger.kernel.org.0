Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F3B6AF7AA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCGVbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCGVbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:31:36 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23119193FA;
        Tue,  7 Mar 2023 13:31:35 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id bo10so9855150qvb.12;
        Tue, 07 Mar 2023 13:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yff8KdMSGC1/YkFySy35NRQTKZ1OPFf9I0TG1c87sSE=;
        b=HU3FaK2P7bRH7wZ7OywsU/y5xZJSV2dYN6+VOAN3B20pi1Tsk5p8QiI/26+0g5ve1V
         0Gr95u5b4rUPw5iksmbAdUO6VbVEJCCfEO18I2RKMRGteFTN6cBwVJnbumb6qOdZIhQ7
         QO38xUNh0v0hShg02qzNx3+W1281g9jI3lI4jR9OUJ/s2dbBqpNsqJ3IACIaRxbzivH9
         szkQnsib1RnK1UmUgxo97kozt42kkyB1aUVu2uRGNyCxWNw7GRGVWAHCIiHsan+FEmQh
         fqkqwp96FCLAcNCW+bDqiLGcmXBRy84pXSs0uWjF8wH7vahQFm3t5wJsOBpWXSP0HHT1
         bomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yff8KdMSGC1/YkFySy35NRQTKZ1OPFf9I0TG1c87sSE=;
        b=fcjzmBAFAfv4FU5zasA24SjwONR5OX5g2V489BBN7CGgOAV3z1XEeMSX9OWcGmdKeO
         rgJ7re8J8M8SvKpvmUaQ1zKJIZoHGZKCma5fRjILc4RRJtdXn0ClpWTLbsTtW4E9u67C
         a4KmKiPlu8pIk6i3oPKDJlq+H60o5UVSx7fiU552zialHmSWWzwpw/zYs3qmbVmjCAyn
         Crpgn9+/5ij/K0VsIELK7GoNCGnLRaDVe+Wzh+YlJr0YhH7AHMSLEI+Pt98kZ4RbjqjY
         KPYe1eeokCSZ2T/Ge10FVwmzoEqAFuIYE2cHJmvMHTYE7VIVRMRTLAxdxIK0yZdrP9eZ
         2GZQ==
X-Gm-Message-State: AO0yUKWs9W0ejyhnwLADUhyOApQpGonZFlnLjwksSBZO4E5xaNq6p3eu
        bD/b2seY/5jufGrZFts4fBaA37EIZtxiqw==
X-Google-Smtp-Source: AK7set+TK8LOQqN9O1w7gkWBGBBNWkYcM9GXfigbB9bjt6IOky/gWL/XtAIGowQqrEHFhSYTcYQzcQ==
X-Received: by 2002:a05:6214:1c4c:b0:56b:ec30:67eb with SMTP id if12-20020a0562141c4c00b0056bec3067ebmr28980617qvb.39.1678224694019;
        Tue, 07 Mar 2023 13:31:34 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r125-20020a374483000000b006fcb77f3bd6sm10269329qka.98.2023.03.07.13.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:31:33 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCHv2 nf-next 0/6] netfilter: handle ipv6 jumbo packets properly for bridge ovs and tc
Date:   Tue,  7 Mar 2023 16:31:26 -0500
Message-Id: <cover.1678224658.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Currently pskb_trim_rcsum() is always done on the RX path. However, IPv6
jumbo packets hide the real packet len in the Hop-by-hop option header,
which should be parsed before doing the trim.

In ip6_rcv_core() it calls ipv6_parse_hopopts() to handle the Hop-by-hop
option header then do pskb_trim_rcsum(). The similar process should also
be done properly before pskb_trim_rcsum() on the RX path of bridge and
openvswitch and tc.

This patchset improves the function handling the Hop-by-hop option header
in bridge, and moves this function into netfilter utils, and then uses it
in nf_conntrack_ovs for openvswitch and and tc.

Note that this patch is especially needed after the IPv6 BIG TCP was
supported in kernel, which is using IPv6 Jumbo packets, and the last
patch adds a big tcp selftest, which also covers it.

v1->v2:
  - use the proper cast type in Patch 1, as Simon suggested.
  - simplify the return path in Patch 2, as Simon suggested.
  - move pkt_len definition into a smaller scope in Patch 3,
    as Simon suggested.
  - move err definition into a smaller scope in Patch 5, as
    Simon suggested.

Xin Long (6):
  netfilter: bridge: call pskb_may_pull in br_nf_check_hbh_len
  netfilter: bridge: check len before accessing more nh data
  netfilter: bridge: move pskb_trim_rcsum out of br_nf_check_hbh_len
  netfilter: move br_nf_check_hbh_len to utils
  netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
  selftests: add a selftest for big tcp

 include/linux/netfilter_ipv6.h         |   2 +
 net/bridge/br_netfilter_ipv6.c         |  79 ++---------
 net/netfilter/nf_conntrack_ovs.c       |  11 +-
 net/netfilter/utils.c                  |  52 +++++++
 tools/testing/selftests/net/Makefile   |   1 +
 tools/testing/selftests/net/big_tcp.sh | 180 +++++++++++++++++++++++++
 6 files changed, 254 insertions(+), 71 deletions(-)
 create mode 100755 tools/testing/selftests/net/big_tcp.sh

-- 
2.39.1

