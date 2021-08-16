Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9213ED950
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhHPO54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhHPO5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:57:50 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A69C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:18 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hs10so32424134ejc.0
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6TDmKThXQnwJ9/lpiXTr7wPbuz+EjXXtj7u1wDzkO5M=;
        b=Y19/YiD3KnkC03qYx0indOUyDBvwrWKUVIY0ybeFfFx8Zf9BHT3Nuq/xciwsycA2vU
         iS2P3ROP/iZHE6b8+2TN8Kj2yAFnpdGKLufBA5UMLJkWMjhatQ0mdctRXDWg7mUgnhjx
         X1MuJzqShYg7y94MX/NnDa4qOqKF0bebVJtuxmDPc0VNNwdx7TYn/m4yb8GsTyabnyzn
         /dQOE8LU2jD9+mvheSmbs9+VY0cXrJmrHZq04NN2mzCxMADtxBxjxa/wPI/wfuTVTWuT
         F1g1JTst4uA1u6IKVlIlmJATYPyAopXuvvMZ9VG0bOJHfX5Svvq9OoMYyWPzA2Td8m0j
         BJ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6TDmKThXQnwJ9/lpiXTr7wPbuz+EjXXtj7u1wDzkO5M=;
        b=mgZQqetdYKJIFBtVqVC5slfU49ppFlSqw0X3wJfDtUxQiRNdB/WZzUaEmL0b3KvjWK
         HS6KkX8om9qHTL/5kfZUNv+KjM6LKofctmjTezauHPHTbgsgkZtrX5NiEMLCWVAhPlow
         MuRpTTRvpOi3ZMqaHZB6WhicMBSZuMtZl8EedhOCRrcwooAjCHCG0HcIpOZAWUlwJBF2
         TWVfCv2MkdzvdbMqZ9Ks55/Ho4u36UthAx8ebEFNJFiX//76KTiLCfChccJDeIxxpth/
         hIctkH3mSqJWQYWrSGk1/8B6lUiwgIm2jLMk1mZRF4rTHaKgLm53tpw/OHxfe8dDhrp2
         VWvw==
X-Gm-Message-State: AOAM530BAy0Ku6fwQ+LxM/ulv2NVJDrwtm5g6docc6UBo3M2HpvSCe+i
        uvqIan21IcYQoW/bYnYbmjaqZFQShJi/ygbC
X-Google-Smtp-Source: ABdhPJxMivDeVFaVS6IieUvs+gs1sFF0prLEDmZsjqz3F/AF9RNu/VyGdjga7LDRA81fwYXQRwfUSA==
X-Received: by 2002:a17:906:11c7:: with SMTP id o7mr14730162eja.480.1629125837098;
        Mon, 16 Aug 2021 07:57:17 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t25sm4946076edi.65.2021.08.16.07.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:57:16 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/4] net: bridge: vlan: fixes for vlan mcast contexts
Date:   Mon, 16 Aug 2021 17:57:03 +0300
Message-Id: <20210816145707.671901-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
These are four fixes for vlan multicast contexts. The first patch enables
mcast ctx snooping when adding already existing master vlans to be
consistent with the rest of the code. The second patch accounts for the
mcast ctx router ports when allocating skb for notification. The third
one fixes two suspicious rcu usages due to wrong vlan group helper, and
the fourth updates host vlan mcast state along with port mcast state.

Thanks,
 Nik


Nikolay Aleksandrov (4):
  net: bridge: vlan: enable mcast snooping for existing master vlans
  net: bridge: vlan: account for router port lists when notifying
  net: bridge: mcast: use the correct vlan group helper
  net: bridge: mcast: toggle also host vlan state in
    br_multicast_toggle_vlan

 net/bridge/br_mdb.c          | 30 ++++++++++++++++++++++++++++++
 net/bridge/br_multicast.c    | 10 +++++++---
 net/bridge/br_private.h      |  7 +------
 net/bridge/br_vlan.c         |  1 +
 net/bridge/br_vlan_options.c | 17 +++++++++--------
 5 files changed, 48 insertions(+), 17 deletions(-)

-- 
2.31.1

