Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388E53FD7C7
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbhIAKjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhIAKjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:39:17 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B3EC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 03:38:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id t19so5563646ejr.8
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XU8QHyCx1gJwIooZpZIXz4vbp0ymhm6rrxrvy4A0ptY=;
        b=OMQXLArJ6p7uM4sTS6RPN8SGLPgVN0oE2AWGWC+7lF9k37yk92Vur+0XXYzJ7ohFNy
         CfHDookIhuoB1e51duok/pXGdeMWoDTJgGDXGAHxo3YF5bF0mzycIRDrczY2FLBU4Ovg
         SwnWGt/fULDcpdO9CX2G8Pi+Pbpe/DbHP4ATKY84SwyU5uB+GAJc1SFo2tfsIFJ3mXT7
         w8J+RslidDsMTtOUpq+QENVG/lWYVDBhAkboPoyYSQ0O+yj1zlCLUzQs07w/4wUyLNC7
         HQXnVofdCijhq5Ho6QjO2f4Phw5D49leePl7U9f+0UG9THS4d/nWKX7Fmx2u2BknNuve
         CCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XU8QHyCx1gJwIooZpZIXz4vbp0ymhm6rrxrvy4A0ptY=;
        b=T00tWYTq0XQgTQ6lhMDCnJtUb9JBUPKZJ2zrq63IQKrRSGJyOHE0PAsjxsInNA8kP2
         aBfbq6+AfqIR339yKmQs0+p1pktI+bf3x9Ngb1KagKpBuclqkFsur8rLFHJyQ+h8na8H
         A9qMzUaE1+HVo1oXQN7wuWg1mtRt8tPiATYDvG4La3CEMLpZA5ac3RABRwPKYB1zxybK
         nc4BTRV3fO6reMwivuYKuEfWy5JCztThUZMWdJ9LKWXC8J4eqve/l8bwom6sR90ji5Zk
         xmkNbR+jrJjQ22NW2EO5d/66e0+cmxQP1VT3k1sWbuFYLZ+PEMFGNPKQklBKX6tqnRGA
         o55w==
X-Gm-Message-State: AOAM532tu/zOyQjkjVTuuHpZvRN7TD3Ls5a5BbcR5qsdWFl2kCNQM+ml
        tO4A3v/plYId40h1NDQpaJ2vXEcRt9LVufST
X-Google-Smtp-Source: ABdhPJw6s0hYomRBykttTMJpMK32m0HWzhdw3+w+/LWfEkASflg7SpSBA4kKFalAAHJvU+Xs+3ADcw==
X-Received: by 2002:a17:906:6dcb:: with SMTP id j11mr36315287ejt.202.1630492699517;
        Wed, 01 Sep 2021 03:38:19 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y23sm9580527ejp.115.2021.09.01.03.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:38:19 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 0/2] bridge: vlan: add support for mcast_router option
Date:   Wed,  1 Sep 2021 13:38:14 +0300
Message-Id: <20210901103816.1163765-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set adds support for vlan port/bridge multicast router option. It is
similar to the already existing bridge-wide mcast_router control. Patch 01
moves attribute adding and parsing together for vlan option setting,
similar to global vlan option setting. It simplifies adding new options
because we can avoid reserved values and additional checks. Patch 02
adds the new mcast_router option and updates the related man page.

Example:
 # mark port ens16 as a permanent mcast router for vlan 100
 $ bridge vlan set dev ens16 vid 100 mcast_router 2
 # disable mcast router for port ens16 and vlan 200
 $ bridge vlan set dev ens16 vid 200 mcast_router 0
 $ bridge -d vlan show
 port              vlan-id
 ens16             1 PVID Egress Untagged
                     state forwarding mcast_router 1
                   100
                     state forwarding mcast_router 2
                   200
                     state forwarding mcast_router 0

Note that this set depends on the latest kernel uapi headers.

Thanks,
 Nik


Nikolay Aleksandrov (2):
  bridge: vlan: set vlan option attributes while parsing
  bridge: vlan: add support for mcast_router option

 bridge/vlan.c     | 70 +++++++++++++++++++++++++++++------------------
 man/man8/bridge.8 | 29 +++++++++++++++++++-
 2 files changed, 71 insertions(+), 28 deletions(-)

-- 
2.31.1

