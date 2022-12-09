Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BAA6484EF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiLIPWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiLIPVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:21:45 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3288BD3C
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:21:43 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id 6so2290449vkz.0
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 07:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sC0ZtMiMbtKeMaZXp1BcFA1ql6PFq3CYZ8wn7XEScCM=;
        b=Kzregmxj8xVtc7eFqlmNbEMakgHw4wV4Br5Ov5y3zQQBo5k8hhBSfNmXVzDc8ggr6k
         Tl2fYpo+lbevU3rg+WJrds0vgGxEXGGOaMlHnwCNO3us/YYTb92+A96bYucnfU/wYuFi
         Cf6S9IUjN5KgxUDb0JKH11MaCzJIvsjB8rqawhp5Q3Q6K8NUjmg0fzW6SzU89z8mrQFZ
         UZWRbmm67XBuoCcRQEayF/UgMmYjupRQIGwIvHQfvx1QPy1wCw8Mb6zR2xYsLTgrFhik
         BQXQu5oIEdxyigqhPYNcInhaToc+RLJa2ioGlrJOMGO3eEEK6rfMHjervYSa8uUu3gmd
         OrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sC0ZtMiMbtKeMaZXp1BcFA1ql6PFq3CYZ8wn7XEScCM=;
        b=Ucw6Ju/joup0nCe/7msoQbtu3DYot8N3MqJao4nx2b9i5Nnn8mPgv6UV20oLfyF3RL
         PrHuJoNkGaWjuCP2ztxLPvUe2vkp98USyNNjZdSDQXU9PeMb9f1W3URcz0kcNwAIopFo
         c533Adcl6z/OtVrOK6LD1dMDnWwdp4ibaGphFqBBRNiT9T3q9DatpZJ5afs0/RuSAjmS
         DYNtEqL1TgFOmarvQXVOEJux2pCkm/7L7rhs7SSc+09BrIlc1C6o5cHuo2hJmMqgjMqh
         0kSBdgXepwBcBMX5HeQ7gorsGNYer9Kjr4Y44P+Ex565lm6LxveMzfNDEqmWGoNMy7TG
         DXgw==
X-Gm-Message-State: ANoB5pkhOYDCspzEEYfjDExXzJ+kj7KPTQmaqe8nzolFTXNF1/RAXFcj
        V9lipfmZbUK+Xik3M22051QY2woxJQpBxA==
X-Google-Smtp-Source: AA0mqf5i6Aupiit4OKLBOFiWM+5RbAH0QVoNz8iAYkz372hwr2oPkb2EjQgTN7VnWkeCK+XA3IzvIQ==
X-Received: by 2002:a05:6122:2019:b0:3bd:c897:fa23 with SMTP id l25-20020a056122201900b003bdc897fa23mr3703076vkd.4.1670599302343;
        Fri, 09 Dec 2022 07:21:42 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i26-20020a05620a0a1a00b006fbae4a5f59sm39699qka.41.2022.12.09.07.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:21:41 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        LiLiang <liali@redhat.com>
Subject: [PATCH net-next 0/3] net: add IFF_NO_ADDRCONF to prevent ipv6 addrconf
Date:   Fri,  9 Dec 2022 10:21:37 -0500
Message-Id: <cover.1670599241.git.lucien.xin@gmail.com>
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

This patchset adds IFF_NO_ADDRCONF flag for dev->priv_flags
to prevent ipv6 addrconf, as Jiri Pirko's suggestion.

For Bonding it changes to use this flag instead of IFF_SLAVE
flag in Patch 1, and for Teaming and Net Failover it sets
this flag before calling dev_open() in Patch 2 and 3.

Xin Long (3):
  net: add IFF_NO_ADDRCONF and use it in bonding to prevent ipv6
    addrconf
  net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf
  net: failover: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf

 drivers/net/bonding/bond_main.c | 18 +++++++++++++-----
 drivers/net/team/team.c         |  2 ++
 include/linux/netdevice.h       |  3 ++-
 net/core/failover.c             |  6 +++---
 net/ipv6/addrconf.c             |  4 ++--
 5 files changed, 22 insertions(+), 11 deletions(-)

-- 
2.31.1

