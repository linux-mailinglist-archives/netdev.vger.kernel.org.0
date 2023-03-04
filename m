Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4D76AA61D
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCDAMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCDAMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:12:46 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B363721283;
        Fri,  3 Mar 2023 16:12:45 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id nf5so2909546qvb.5;
        Fri, 03 Mar 2023 16:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677888764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WzK6eFE5ziYvB/Q6lz47iCEBLCPVXXXPkxWxsawXNwI=;
        b=gSlWyJFdJDlzo1pekas36Gg5Jaa7dlc0ipgNITWftRP4z6wefBW28x8d2h78Cc01+5
         Dwb2DvKwkg02Bp9ucip1nRXD5IhKbLLZqVVwvV5W4nNO6MXa9RPUc9spxG+wlW2jCTFO
         sOfPaY6SFkBoHC9KgWjXMI2OFEtY2MOjdPF7wwX2rmgN2LB5vHrmLlW9dFxS2RA1N2jq
         KpMFKv7J9VMr0e6dVh4Jp7CMmppwdfOSSiRSqJxJoGkoxz4NqLEWHou5Vcx3Hm+OZHDf
         yxX/HzzrWw5fNynC+He+iGmymTq118gUtDGWbxs9retf90Xel2SeUz48A1veUdm2KTBQ
         3OWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677888764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WzK6eFE5ziYvB/Q6lz47iCEBLCPVXXXPkxWxsawXNwI=;
        b=ca/N2Tc+cAGHg7I744OjNm7brgJstP2CuVhcEiMzFLzCZhj9e9z35I2fR2dFOzy/8y
         m/Pyvkthhts9oE533vFHmEXrs67uWeZ1KC9T/35MtdjHqQELzir/pB4vFT7Goo8CgKN/
         QAz3xAZn8Pak9uJ8gRIz+6Ref+bb404gTQyJQqG8IETQ38QdUcMOEZDr+PwAwIT/SSAr
         eRdkl+kWlMi4gR8A0V3TQwujiJ6u9PKTflwbkuQUWPPXBHJ7KdXrAZng8OA+STEXU9zu
         TbXvIS080c3UZR+z4YW2tZGMtegpCZ10/4lMonzevtH4cxEXQmdc+FRdptwuWEfdGWLL
         5yEA==
X-Gm-Message-State: AO0yUKV7Qtq4cPqrcr2ZzMTIxvZKw0gx02/QQnxZLxFa4GW1N/PbFcNc
        w99ZhicxU5DZeesKvEcNHF5DNB5hUtCTww==
X-Google-Smtp-Source: AK7set9m+Imlshp78aSkn5FbZqt1tCvAEZHdBaULkCFznPaFABFvxuNOJRl8bvTyG5Novm0sF9xcgw==
X-Received: by 2002:a05:6214:2021:b0:53b:aa54:4eea with SMTP id 1-20020a056214202100b0053baa544eeamr6814427qvf.20.1677888764623;
        Fri, 03 Mar 2023 16:12:44 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d79-20020ae9ef52000000b007296805f607sm2749242qkg.17.2023.03.03.16.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:12:44 -0800 (PST)
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
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next 0/6] netfilter: handle ipv6 jumbo packets properly for bridge ovs and tc
Date:   Fri,  3 Mar 2023 19:12:36 -0500
Message-Id: <cover.1677888566.git.lucien.xin@gmail.com>
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
in nf_conntrack_ovs for openvswitch and tc conntrack.

Note that this patch is especially needed after the IPv6 BIG TCP was
supported in kernel, which is using IPv6 Jumbo packets, and the last
patch adds a big tcp selftest, which also covers it.

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
 net/netfilter/utils.c                  |  54 ++++++++
 tools/testing/selftests/net/Makefile   |   1 +
 tools/testing/selftests/net/big_tcp.sh | 180 +++++++++++++++++++++++++
 6 files changed, 256 insertions(+), 71 deletions(-)
 create mode 100755 tools/testing/selftests/net/big_tcp.sh

-- 
2.39.1

