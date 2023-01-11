Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F1A666235
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbjAKRmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239217AbjAKRiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:38:22 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115FF242;
        Wed, 11 Jan 2023 09:37:36 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p3-20020a05600c1d8300b003d9ee5f125bso8450025wms.4;
        Wed, 11 Jan 2023 09:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WPvFuSCJO0sCn8AYzxJGQmFGILt+VmPrlCSo5hCQpjk=;
        b=aKAhPgxBPDVLLmXAOd6urG62qZN4kEA/0HglYJSoSjLSR1EzWoWYb0Sp75xgLWBvmN
         hk/8eIqorpI1Vq2eFruoSH6AlwJxXso9rPAbWPL9nsX9ikVsh7arDFV1c4XeOM47MGUw
         5hgxCVTimFsKDWQM8StM0Y+rygdylZS50ZeIW7cd3CTzk40SRCJ3FuCpb37B6OtQGrl+
         6jDzQPVyzLzqNfgM7CcLmTEk3V8qWtDmjrQE+rbxiVNQp21v1tLTGcYFWJqDph8W4IfT
         3R9lJihQMFeM80PHmIQoyXWpQj3lGqxefHMdcinfy2aViqa0l6oKJuAgrlWu5A44juaz
         PmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPvFuSCJO0sCn8AYzxJGQmFGILt+VmPrlCSo5hCQpjk=;
        b=Xr2n7VlbSQ/uXgVLWQaypdOo0n5eeMwqLEOC0/EtiMfillvm5Xujp6WszOPbOjA+JC
         5rXj4839ZpVhaetLc2qbPUYs799DmDTudJDjYSV8hBwO2gRXI7avzWDGr7e9CyObM5w2
         CFYInXV+dekG4qMTK0sWsSX8SL+BAZ0P3UNV93gV6ueQKFdAEgT+U7Rm79WqO910uU11
         VJTi1x8QIiYikkKkjWTXy+53lLM2HWOlP0EbKeVJz+lD1i2APqwkdMjR4lwayQFo0Sv6
         XYitxDNNpQjpeyAtIZz8TvHZiFtSnssAuF76pr77+ff8zRcg3djSRDhrYu0DbWrE2FcH
         Xz7g==
X-Gm-Message-State: AFqh2kp/yX5XXn/rXhpEjDC1tZH1QzgO0Xh8jB0h9XjWaBqgHRmmNEeQ
        dFN7doouWCkDbaoqs7SbZ+c=
X-Google-Smtp-Source: AMrXdXsgSKhsz6NXqmGHaqsXjJ50dGiogW5sAt2jnNIJf2cCR3W869QaTIq+VAWrozMp7IZbhiGEGw==
X-Received: by 2002:a05:600c:1d8a:b0:3d9:ebab:ccff with SMTP id p10-20020a05600c1d8a00b003d9ebabccffmr11118361wms.33.1673458654667;
        Wed, 11 Jan 2023 09:37:34 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c350800b003d990372dd5sm26404485wmq.20.2023.01.11.09.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:37:34 -0800 (PST)
Date:   Wed, 11 Jan 2023 18:37:34 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v2 ethtool-next 0/2] add support for PLCA RS
Message-ID: <cover.1673458497.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the IEEE802.3cg-2019 Clause 148 PLCA
Reconciliation Sublayer. It adds get/set configuration and get status
functions. Additionally, shows PLCA capabilities and status when invoked
without arguments.

Piergiorgio Beruto (2):
  update UAPI header copies
  add support for IEEE 802.3cg-2019 Clause 148

 Makefile.am                  |   1 +
 ethtool.c                    |  21 +++
 netlink/extapi.h             |   6 +
 netlink/plca.c               | 296 +++++++++++++++++++++++++++++++++++
 netlink/settings.c           |  86 +++++++++-
 uapi/linux/ethtool.h         |   5 +-
 uapi/linux/ethtool_netlink.h |  25 +++
 7 files changed, 437 insertions(+), 3 deletions(-)
 create mode 100644 netlink/plca.c

-- 
2.37.4

