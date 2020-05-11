Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44211CE94F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgEKXrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKXrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:47:21 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4FBC061A0C;
        Mon, 11 May 2020 16:47:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 18so5474776pfx.6;
        Mon, 11 May 2020 16:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L6AglJXCa+EJEHahDbV4YE95BEBUMI16CtBRayEme+o=;
        b=r6fZnmIauZZ/IYawlQTWe2DEKcrw3IZUcO3CwzUbBIq+sGXUYNnlwegTj4sOMm/G/n
         147ZVuIT/5JltcIDDJaG8HpFBDKxuP6OiF2s7YnyNgL55KyYUsL06iki5O7caDUHwXxa
         UaVpVMT6wZTNhG3wW8XuSM+YhejfRzoZtRfvrog6kg8mcIpUAjL53w4MUAmn9zEjksla
         Tg/Fy0ZugW8Gw8/HMYA3t+qXTDuj1LDjo9KrnoMxSIJSeSQuKv7zDTDb4OWCV7JrAJQ1
         f4jzrpZyNw83pBonz0BWf24XhW8UYh2YzVJbq8Sh/6rGfFYJMrGRK0wyaAyHufTzJlAZ
         272Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L6AglJXCa+EJEHahDbV4YE95BEBUMI16CtBRayEme+o=;
        b=mhW2NjN9y7LzVGktpU6dfUipfBlay2PEI+RSgak4q3ROPF4QWqvfsLyoYEUWS1idIm
         MBZMnocRyo06ceWE+xdTHYRDeJYYMVuKVYUOnLGn2bM+4Z4ZJaVzrEFRrEmGEt/io+dw
         Bk7EpMqGyZqYApnGJ9C0dM40mQ/obwtlPBIEdkCDaSgi6WTFTtP0yb0NNFQz6wWU3kDW
         r9j6zq7YYnRZKCfUEeoZmqOXYYqoYFzimrqvUBTIJ61vKb31WaBZcMDK39ra0eZD0Gay
         j6Y7GhePX2bgXTqG/sLMNjL4fNDAYXngOg1jjuaC6pPC0Di5Gf/ZmylgkqbZXBmsZXzL
         n3vQ==
X-Gm-Message-State: AGi0PuYvptZyFoPUa9kO8WRTihjD9AN/rQWiDAYshUoFnyiMkARB+vXu
        nuZlo2FLgIjrINQRrMUk92DbAQq2
X-Google-Smtp-Source: APiQypJxJqV1PMuLyo3VOEIat3+8TE7/PT6bqvnfvVEdvScRA13or5TkjU6aSxePYezQYJS510odMg==
X-Received: by 2002:aa7:9689:: with SMTP id f9mr18232016pfk.24.1589240839912;
        Mon, 11 May 2020 16:47:19 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e21sm3455317pga.71.2020.05.11.16.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 16:47:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/2] net: dsa: Constify two tagger ops
Date:   Mon, 11 May 2020 16:47:13 -0700
Message-Id: <20200511234715.23566-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series constifies the dsa_device_ops for ocelot and sja1105

Florian Fainelli (2):
  net: dsa: ocelot: Constify dsa_device_ops
  net: dsa: tag_sja1105: Constify dsa_device_ops

 net/dsa/tag_ocelot.c  | 2 +-
 net/dsa/tag_sja1105.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.17.1

