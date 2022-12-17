Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856C064F68E
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiLQAvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiLQAuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:50:50 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E44F643;
        Fri, 16 Dec 2022 16:50:11 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id i15so5893845edf.2;
        Fri, 16 Dec 2022 16:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQ2fFX+jd5hgr44et+KbsoEGFllq9yocAUoxQHQtXKI=;
        b=E3T1DSIn6jVaKbs3I0nn0s3bO9dEgnkjJhqRFQyUcyxI0wMOI8aM9AESQDhfoRyL5p
         8BrzlrGYOl11qwAukn3r24XhC/rKb9JccAQlaBunwr89urSDByP1f2u/4TiwLMoospQe
         r860qqaFmYK9jSsqzZncbQwex15KEVOaih/QEVdfaqcljSSo/4C9eqlJj3GQXTyaOl0N
         A2f5iwu98isrrlGxe+DTrnNv4Reu9SNGt1YhhKXjCWuAJz5Y7d5H3E+QEbc89/suHL/i
         k/dYKmYERPBU6rghO+jPhxIFe5GeDMyI2Nf1h53DrNHXvn37LNzi4B4v+I5zxQagg10i
         G5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQ2fFX+jd5hgr44et+KbsoEGFllq9yocAUoxQHQtXKI=;
        b=R4Hwipn8z4Q8G/0B760h6TydhLUz7PbbT7xOynJYn6b4aDFK0E5te8pmORT/7tb3rX
         k3opM03Y0kjoVtNFlIE47kpOTXLz2YoPwewqdCPjj1O8AJbIea0lzEtvZs6EL2waG+Xa
         nQupDM9Fq4OAdauVEqQQvtdNGFhnrp4R+02XQSLkJmD9+s0AViqa7Vn5/7UKyyXKhAAw
         0EZiUq9f91Kvz/Z/3ioSCzeXIBtz6pmzCo9IGeZHJs5H40ZD7nymtD0ynZ0w9WKdUaTF
         bDK9Zy0ys4eVH7bVhAlJtbizdPES9zQP0N40bM2z3FQq8ltmNNR/UlOfO8f9cuU6jFyR
         aWVg==
X-Gm-Message-State: AFqh2krrYN3wzGoD5Met5UJhV0lClmgtrS+3QkbFw5RlGoJ4iaDzSx8D
        xJ+yterz5FXJyWXLlNdLi1A=
X-Google-Smtp-Source: AMrXdXurDh3L1c5qavTkgtwmKvwYxOhV+71revRU6hZt/WYPAJa1XzfAoaY+abD5vchuzicPYelaMA==
X-Received: by 2002:a05:6402:4502:b0:463:de93:d162 with SMTP id ez2-20020a056402450200b00463de93d162mr7801248edb.23.1671238210330;
        Fri, 16 Dec 2022 16:50:10 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id da6-20020a056402176600b0046c7c3755a7sm1422611edb.17.2022.12.16.16.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 16:50:09 -0800 (PST)
Date:   Sat, 17 Dec 2022 01:50:08 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v4 ethtool-next 0/2] add support for PLCA RS
Message-ID: <cover.1671236215.git.piergiorgio.beruto@gmail.com>
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
  add support for IEEE 802.3cg-2019 Clause 148 - PLCA RS

 Makefile.am                  |   1 +
 ethtool.c                    |  21 +++
 netlink/extapi.h             |   6 +
 netlink/plca.c               | 295 +++++++++++++++++++++++++++++++++++
 netlink/settings.c           |  86 +++++++++-
 uapi/linux/ethtool.h         |   3 +
 uapi/linux/ethtool_netlink.h |  39 +++++
 uapi/linux/net_tstamp.h      |   3 +-
 8 files changed, 451 insertions(+), 3 deletions(-)
 create mode 100644 netlink/plca.c

-- 
2.37.4

