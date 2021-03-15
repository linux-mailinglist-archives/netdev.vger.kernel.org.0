Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB133BCB3
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhCOO2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbhCOO1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:27:40 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE324C06174A;
        Mon, 15 Mar 2021 07:27:39 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r15-20020a05600c35cfb029010e639ca09eso20402040wmq.1;
        Mon, 15 Mar 2021 07:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mlfp93R+LTFr5whu6mUjP7eVBTAmRAZ6RgRrG6Cpi3I=;
        b=Rg5GWxX/pQM+gT1k2dNm+JQgf12GRSv+z5b7DPv3wv99/rztUrujNVVH26FOKdBy7f
         PmjnhbFjSvG2tkfz4WGeNaImBbvkaKb/PyLAVsvQjLxH2m5NE7m+w84Yq2RMKUbPxtQJ
         FxQC69JwPEYL6PzYn3WGX+bYq1fhttHf1H5k+yB2Oi9BrQFuECVsVpY1ma/CQDziAmV6
         GOHNsAR5YiG+PRciRjDe6wNWUP+aNKdBayjKjhyaEtpdTZeWMv/laqHWbAKTA6yK8qpj
         XwzD+/aGaRIJMDncYQ4O/QsHCd8CcZrCl9MwEt9oOBP6jxIRPuTDQV1BdEMMED7G5k3q
         SsQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mlfp93R+LTFr5whu6mUjP7eVBTAmRAZ6RgRrG6Cpi3I=;
        b=RZIlIxp/ndP0JNXF5+m0Nnic8hG5pMB4RnZc6lacE54TEokvVb+cXjdjLjxpOplZCh
         0FqKA4gH3bkpwditIN4e8ApeCrf6Ex9Ger9fGkQmCDJKAs7/yQg65XFFSJPInMpyo8PT
         SDGOp2tX4lkcAPpfIkm6Xj8yzbdegsbxc5BVRup7Z99453Vw4KFu5V6LzAlm06CTfcA0
         NEpxGHbS6AJ6r+jNlBS3fw9+HRz5w465jF523HZl0Gzm6J0eVqyF0QiBiVTrszxWVlbK
         AgiGI5XRY7XtVwKquTGfgirjyNaQhxY3KEG+DVkSAy6ObsZRlNmi6PiG0ggYqJj6Z9of
         oYHA==
X-Gm-Message-State: AOAM530MG4ucuSeuckGTs20b0FcuwhZpaSxmpyVtvJMH3gD5Z/DpPAMZ
        yn1wWWT9EljFo5ABcM9TxHg=
X-Google-Smtp-Source: ABdhPJxBgSmTfegXMVIuQ0XvaM/6bCGnNQSySVosSqP1AWb/WN32FtXfmFXQN++1NORshwuFTT2EIw==
X-Received: by 2002:a7b:c18e:: with SMTP id y14mr1116618wmi.1.1615818458411;
        Mon, 15 Mar 2021 07:27:38 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id 21sm12856606wme.6.2021.03.15.07.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:27:37 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH net-next 0/2] net: dsa: b53: support legacy tags
Date:   Mon, 15 Mar 2021 15:27:34 +0100
Message-Id: <20210315142736.7232-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Legacy Broadcom tags are needed for older switches.

Álvaro Fernández Rojas (2):
  net: dsa: tag_brcm: add support for legacy tags
  net: dsa: b53: support legacy tags

 drivers/net/dsa/b53/Kconfig      |  1 +
 drivers/net/dsa/b53/b53_common.c |  9 ++-
 include/net/dsa.h                |  2 +
 net/dsa/Kconfig                  |  7 +++
 net/dsa/tag_brcm.c               | 96 ++++++++++++++++++++++++++++++++
 5 files changed, 113 insertions(+), 2 deletions(-)

-- 
2.20.1

