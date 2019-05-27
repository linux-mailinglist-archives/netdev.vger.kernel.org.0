Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213DD2AE6C
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfE0GQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:16:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39232 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfE0GQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:16:17 -0400
Received: by mail-lf1-f65.google.com with SMTP id f1so11139668lfl.6
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Lp4V+O6Puia45KKVqqti/GT7pDSEI7F2sM0ntCEYmxE=;
        b=Z4P+76AxUZIzqghxVw5LGCnuL86hUTLqS6T5EqZKg56FQZQZPiZRt3au2+oFvSy+Pr
         uBub45vppBNzgLinlNTO5nJzIx9Olqk/1niG4yKxuEEqNI1vtvRlMI4naL9zDIhwW8Od
         rhY5Aud8b22FVQQShamJTiOJqrmChPBBN2i7ff11+spDhr802sFOz9Vx3NBZNQXQucRg
         yKJ8ZIthz39y4O/VYNBFvc2CY7fN6eW780Q05nqQhotJsFk3n0pY3m+19jNEtSRzpADV
         bUiIOCvkIr9f6XphlMW/WjtfFu4To8McyKo1fxisOJghxA+s9PbMeyuvpAwG6Aqjf3ne
         /exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Lp4V+O6Puia45KKVqqti/GT7pDSEI7F2sM0ntCEYmxE=;
        b=aFSmNsPxedGzNg8A5GBd/8S4Kc7w8wkGpIYZtV9aZ5FdwtQl4C+ro/IcuUCzzhM7tX
         rgg+DcZsXepVjTh11v4S2YoKFyQJasrfuMy6+gHEKf3DjDxA2n3j7vqfDTNyWstqBR0r
         Km+eoklRE71wLiGiABNjI+ZZzk39xSI4moShoKn98miqmjyBHFRoGgPdQ7tqSGcSv3o6
         6gqQCV+1v6LqaShTkcEZAkZ4j1RE9vlFWLpK0GRcj7tgToNoLjB4BhJmo4EjR5PLu2Gb
         gpr6ZbPUD69ut6S+RkwjkimutzbwMCmhBfxk2s7qFtTu8RHh3DKaJSe4phtScqhea105
         cPVQ==
X-Gm-Message-State: APjAAAWI2pKVBN21nIgvrVqB90KknDBjjM4HBo07oERbKFZx5Xp6rHzT
        QH37OVbWygBPtl0+u7sl7M/9yaeKY6E=
X-Google-Smtp-Source: APXvYqwo5wYtoIdQJIE7ppLvXI923D6k3B3h1/a82sdJASCsoGNsrZxh4vKjd+YxmIITPF5hK7kbwA==
X-Received: by 2002:ac2:494f:: with SMTP id o15mr44965720lfi.22.1558937775007;
        Sun, 26 May 2019 23:16:15 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id a25sm2045454lfc.28.2019.05.26.23.16.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 23:16:14 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v2 0/4] net: phy: dp83867: add some fixes
Date:   Mon, 27 May 2019 09:16:03 +0300
Message-Id: <20190527061607.30030-1-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


v2: fix minor comments by Heiner Kallweit and Florian Fainelli.

Max Uvarov (4):
  net: phy: dp83867: fix speed 10 in sgmii mode
  net: phy: dp83867: increase SGMII autoneg timer duration
  net: phy: dp83867: do not call config_init twice
  net: phy: dp83867: Set up RGMII TX delay

 drivers/net/phy/dp83867.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

-- 
2.17.1

