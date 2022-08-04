Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4212589FFC
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiHDRnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiHDRnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:43:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110B2316D
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:43:11 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso453555pjl.4
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 10:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=0kejN7hxIsGjGLJlCVlTnzGiEfdGQ6D3BY1omi69xfE=;
        b=DKjRz4stl0Rd25jEd6FHyRc3jmPvcXXxKnSvTX7+ACvkx/ahgWjmNe6FP3DMdU+mN0
         5MP09tEUwVe19SHkUokep71BHxIO69zgudRHFXcvisA7Yfdz/UkIYRH94d+Y/RgGwwzO
         sPfaABdgWLEFKvOYv6SxjYacuerkKoyOH9s0yBMne0Ag7phTAOs1BmjHTMYDrQIAYxAR
         T6J3tzmAnyugrvW+ksAhfPMBmfiSb/SAT+zDrjEEluJfjJ4wvdIxIoprFPBXyBX5hvks
         Dv+WVK1FyTOnCraqJOS4hSatnAP6J4p/J8WsCWORTxEXGb3HgK2wXZ5hqZSwZC/4sCfi
         55Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=0kejN7hxIsGjGLJlCVlTnzGiEfdGQ6D3BY1omi69xfE=;
        b=J0T8G9THXEVUqVtk2OWjlzwLk8VETId632Hb38TVryukrf8209rmpTjpAiR/83q+ep
         tYkFxhBdsLScI7hsjW47Ry+9NrWjyScDjIrNixKEBhG6djeCKOjwnmBcUruUtqS6m5D/
         Oj3kcFitoMLSTc0f4S6xvBD3HGgOHiUSclz1vyx0InHxzY1Xu//4pnRqdQceVqJrhLnS
         TG3pDwqUU7JZU+/pL9tFoY+PskqRAeNE4P4qX7UmjikC0Qattd8j4DnTYLKu+Ry+8fFX
         ltzq2ZIz4ac6meNYzmNQgMeiTwttoh1DN17uv/omI85SfzlGCapjLuBdCkpnuNwFKvxI
         Ryng==
X-Gm-Message-State: ACgBeo0JgN3uM44588wj1TulGLD3L2ClDSrsoRm6ZTkOBiYCo7TBvAXQ
        cNs/LnRVgxr+5q1+v+SkrssDlqJEQ+s=
X-Google-Smtp-Source: AA6agR4/NOS5Ucdgh4KO/TmIV1iDYhgczTBxxrF5KQ5E4Jyl7aF/AU0IA5QOcHAPVo6qIIe1IuaL/Q==
X-Received: by 2002:a17:903:228c:b0:16e:df74:34e5 with SMTP id b12-20020a170903228c00b0016edf7434e5mr2866451plh.49.1659634990898;
        Thu, 04 Aug 2022 10:43:10 -0700 (PDT)
Received: from jprestwo-xps.none ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id v3-20020a654603000000b0041a6c2436c7sm142603pgq.82.2022.08.04.10.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:43:10 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>
Subject: [RFC 0/1] Move IFF_LIVE_ADDR_CHANGE to public flag
Date:   Thu,  4 Aug 2022 10:43:06 -0700
Message-Id: <20220804174307.448527-1-prestwoj@gmail.com>
X-Mailer: git-send-email 2.34.3
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

Most of the motivation behind this is in the commit description, but
I'm sending this as an RFC since I'm not fully sure messing with these
flags is ok in terms of backwards compatibility. There is also a bit
more info thats out of scope of a commit description.

Originally I tried to achieve this same behavior but only touching
the wireless subsystem. This was easy enough but the critical piece
was exposing some userspace flag. Without this there isn't much
point in allowing a live address change from userspace since there
is no way of knowing if its possible ahead of time. The original
motivation was also time savings, not related to address randomization.

The wireless maintainers weren't keen on adding a flag in nl80211
since this functionality isn't wireless specific.

Now with the addition of 6GHz we ran into this issue with address
randomization and I'm now reviving the old patches, but taking
the comments from the wireless maintainers and putting this
userspace flag into RTNL rather than nl80211.

Here are the archives to the original thread:
https://lore.kernel.org/linux-wireless/20190913195908.7871-1-prestwoj@gmail.com/

Before I CC a ton of maintainers (since I'm touching so many drivers)
I wanted to get a general answer to whether or not this patch would
be accepted, or if we need to go another route like push back on
wireless or maybe another suggestion.

James Prestwood (1):
  net: move IFF_LIVE_ADDR_CHANGE to public flag

 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  2 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_netdev.c |  2 +-
 drivers/net/dummy.c                           |  4 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 +-
 drivers/net/ethernet/freescale/gianfar.c      |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  5 +--
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/geneve.c                          |  3 +-
 drivers/net/loopback.c                        |  4 +--
 drivers/net/netdevsim/netdev.c                |  5 ++-
 drivers/net/ntb_netdev.c                      |  2 +-
 drivers/net/team/team.c                       |  3 +-
 drivers/net/tun.c                             |  2 +-
 drivers/net/veth.c                            |  2 +-
 drivers/net/virtio_net.c                      |  4 +--
 drivers/net/vrf.c                             |  2 +-
 drivers/net/vxlan/vxlan_core.c                |  2 +-
 include/linux/netdevice.h                     | 36 +++++++++----------
 include/uapi/linux/if.h                       |  7 +++-
 net/ethernet/eth.c                            |  2 +-
 net/ipv4/ip_gre.c                             |  8 ++---
 net/ipv6/ip6_gre.c                            |  8 ++---
 net/ncsi/ncsi-rsp.c                           |  6 ++--
 net/openvswitch/vport-internal_dev.c          |  4 +--
 29 files changed, 67 insertions(+), 63 deletions(-)

-- 
2.34.3

