Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118CA4F9DFF
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiDHUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiDHUKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:10:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5DC713CC6
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649448519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nciniqUYojZOkaF6g1TJfxxFVnHDkY2wNHW5IHzC0s8=;
        b=PP+izmswDbvAb2aPBDPTl0k5A8qTYddBq7iYAadF7qRltS4asB/xj2PvJwajTW4aWzoPsf
        kZzacYXSpVsHzEBXm/l4s6oxD7dNrcxzcnP8zS50x/eclJp97DIs4xF1VCWtfYeBa6qLTd
        2rNws2PQmEROGRDEc6O/8hJyOmY5hg0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-1AVgmaMPOE2hnzTJIkbMow-1; Fri, 08 Apr 2022 16:08:38 -0400
X-MC-Unique: 1AVgmaMPOE2hnzTJIkbMow-1
Received: by mail-wm1-f69.google.com with SMTP id c19-20020a05600c4a1300b0038e6b4a104cso6410922wmp.9
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=nciniqUYojZOkaF6g1TJfxxFVnHDkY2wNHW5IHzC0s8=;
        b=P+PjQYQriLPh67HK4ZzbTywxrBZqUj4tJV9NFCaKE1c1uJp65pOVSRbTf7FyNcNXUo
         navQ3+FSh+Yba67o0ZYAhbJNzsDxBWQZXVQn5NSQL2cuW2HeFAHukJ0fi5npOpw3UVFQ
         of50lWs9qIbOvEz1T1HDIDhnnnZkHqKHyHHeom1fComfHn9PGukR0t6rIy4usJkSkiqZ
         c01elnwTp66yk1UR5zBRwLbQj1jaGRtXwqFJ2ng3y0DrulqYQpzBx+ToYt/d3/Y4Avhg
         gOoheJXGU4u1D2koCNjNQ/x1wFjJoDJ6CPW3nTOe88OgidT+FkR7UUvCW3mNq2nhuPPj
         VufA==
X-Gm-Message-State: AOAM531CQsNYA3t4EG2y2MG17vTl8vTjhD3gjAiKENBHbpjOpuUr+/Vy
        GTAxFGvtqG1Icvp3Rr0F2ThP/cJlRsui8r6LOfZ7LNyZechalUnr2YDDw5lAE1co/AwtYrUt2Zm
        U0b+SEKmLPD2Pr0YS
X-Received: by 2002:a7b:c2aa:0:b0:389:891f:1fd1 with SMTP id c10-20020a7bc2aa000000b00389891f1fd1mr18291729wmk.138.1649448517046;
        Fri, 08 Apr 2022 13:08:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJzo45O1p284Y/h4OZmWV0DSZ0a134Bl4grk3bUAPHlP7MhAiZR1qC4tnYYVQT66tQ9jBx8Q==
X-Received: by 2002:a7b:c2aa:0:b0:389:891f:1fd1 with SMTP id c10-20020a7bc2aa000000b00389891f1fd1mr18291715wmk.138.1649448516802;
        Fri, 08 Apr 2022 13:08:36 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id u7-20020a05600c19c700b0038cc9aac1a3sm12499136wmq.23.2022.04.08.13.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 13:08:36 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:08:34 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 0/5] ipv4: Convert several tos fields to dscp_t
Message-ID: <cover.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continue the work started with commit a410a0cf9885 ("ipv6: Define
dscp_t and stop taking ECN bits into account in fib6-rules") and
convert more structure fields and variables to dscp_t. This series
focuses on struct fib_rt_info, struct fib_entry_notifier_info and their
users (networking drivers).

The purpose of dscp_t is to ensure that ECN bits don't influence IP
route lookups. It does so by ensuring that dscp_t variables have the
ECN bits cleared.

Notes:
  * This series is entirely about type annotation and isn't supposed
to have any user visible effect.

  * The first two patches have to introduce a few dsfield <-> dscp
conversions in the affected drivers, but those are then removed when
converting the internal driver structures (patches 3-5). In the end,
drivers don't have to handle any conversion.

Guillaume Nault (5):
  ipv4: Use dscp_t in struct fib_rt_info
  ipv4: Use dscp_t in struct fib_entry_notifier_info
  netdevsim: Use dscp_t in struct nsim_fib4_rt
  mlxsw: Use dscp_t in struct mlxsw_sp_fib4_entry
  net: marvell: prestera: Use dscp_t in struct prestera_kern_fib_cache

 .../ethernet/marvell/prestera/prestera_router.c   | 11 ++++++-----
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c | 15 ++++++++-------
 drivers/net/netdevsim/fib.c                       |  9 +++++----
 include/net/ip_fib.h                              |  4 ++--
 net/ipv4/fib_semantics.c                          |  4 ++--
 net/ipv4/fib_trie.c                               | 10 +++++-----
 net/ipv4/route.c                                  |  4 ++--
 7 files changed, 30 insertions(+), 27 deletions(-)

-- 
2.21.3

