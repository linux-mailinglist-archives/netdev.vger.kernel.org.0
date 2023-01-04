Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756F165D50E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbjADOI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbjADOI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:08:27 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5271E19C19;
        Wed,  4 Jan 2023 06:08:25 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jo4so82870606ejb.7;
        Wed, 04 Jan 2023 06:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQ2fFX+jd5hgr44et+KbsoEGFllq9yocAUoxQHQtXKI=;
        b=E2+uN39UkM5pWjQKMcIiEBanAg8RKYOtDbEyNxYgaxwyESVoYgiQazF9Dy0psSXf9Y
         o0RmCUe2FljyoGFQKVV6Ao3Qz7TGGTxHGXB1KI1/oJkGaZh9KLigCILMsGjZ7IN8gv2t
         AZEk70xMOysymm964b6LHCg4gL2JvQBjp1kaViDrbglxXWBaB7dMAEL/Yze5dwWRhPRw
         l5D8WN5MOEHH2dXBI9c+9QYUKkhOOa53/uUSOYkIBGr61uu6tZIWlEbSDhY3nCT2GnRX
         4YEYbzX6bqy0rjtg4/wbECnsOZ8JIEgu0m+5i6GWqhCGULCGkw2FgOMcUaQkWxkgdJSk
         uH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQ2fFX+jd5hgr44et+KbsoEGFllq9yocAUoxQHQtXKI=;
        b=a+7TS7jh0Q/DBLAcy1bzaUplEtBQTxtg0FsUQK2QiEMffPO3HR2IZONPm2N8diOnb5
         91Sc2aGqMavXfOhCBlR1/lo06WkAmVzaDDWdYVS1+hiW/koguivqnxtkg6mAWQZyTtOy
         NOWg97JjTe5n1swcDpKZpq2mQEBdfo66gar3b/VX1NLHh7SZ3armvtcsudVZiKVHhQcI
         j2PcgaKpjZ2GHFRSYoZ+6jJYzgOUUNHHqxousrjEicd1ApyvyNMd2f/pytF87zPnA+JQ
         6lJSk8hbFPNwA01iOQVnFlTlXCG5A0Xrto36BQkTuFIByz1yRsnWeOpxm3jQ6JxvBq/X
         bUoQ==
X-Gm-Message-State: AFqh2kpOah2a//AFa8lrvpFuuqqpeBNwSgMfHjBgtcKQbsxvDKen+P4G
        6LTEIaLDDzpn2UlJZ7nzAn4=
X-Google-Smtp-Source: AMrXdXuYMZ3u92smjQOj3cSirxMS1EEMGLqr8sXU95yI0SMSWQDH2k8R6HrIrWrM6P9y7jULm3HpvQ==
X-Received: by 2002:a17:907:8c82:b0:7c0:f7b2:b19a with SMTP id td2-20020a1709078c8200b007c0f7b2b19amr44385504ejc.27.1672841303904;
        Wed, 04 Jan 2023 06:08:23 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709063ca200b007bd1ef2cccasm15138061ejh.48.2023.01.04.06.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:08:23 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:08:31 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH ethtool-next 0/2] add support for PLCA RS
Message-ID: <cover.1672840949.git.piergiorgio.beruto@gmail.com>
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

