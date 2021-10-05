Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C44E4230F7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhJETvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbhJETvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:51:00 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059FEC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 12:49:08 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id r19so512562lfe.10
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 12:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGzFJSD4wITBPw4xkJwRmpTwSKdUaHi5mhd0mZ/upzg=;
        b=DlLE1dS0RUtU+ikygQbKAwe4hxDRMdUMNAX24eZnx+3SHw1Mzd2gPJBixc8UBi2dee
         ZXVGQg29TDRXPgKvX802aXuoH1IY9btaKJTayCr5WYH09uGwPT7W0mTKbjdPz3q2G5kD
         HfVDhMu1eGIVUN9gsSLkD6iG0EHbg152EgHB/eK3KQQ7BB4EH+e6+FzaxjJ5vhYC3997
         sWkD/DXplWez+jEobI9WtcWjlnroO1K0mr9/5tiNX7dCzic6xzHKnqJk+PvdkfWT3DlC
         LSN4Cyc15RNBGNSGsdWE246P1uxOUxWGNMYvqPnRif3egf5kZ28lKD4iTzg0vHvAvj84
         1TMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGzFJSD4wITBPw4xkJwRmpTwSKdUaHi5mhd0mZ/upzg=;
        b=WmaLqFa7uq5uXTIS394e95Zwp7QqVYjoDtKsqER86lfLM7LndFQ2F95NT3Ua8qoBDY
         C7JzgYxT/TfCKNd41N6mXWuzPR4U1v5zVB7/IJKnrySUH+3LQqoZvWa7xFEzvhrFVzT9
         LP/M+UF7W+Drs27OMLqeU9xb3sjHkj3la97MZTxYLZOqcR63fKJf6tVCcfvHKX2tvYKi
         5DzbttwBj9yKS0C85utS51cRqmCzsaWKZ7XWFhDgQmjf70dg5IS+i5t7ldEDG6SqXpKr
         Pym7vEd8pa91ddFiqIZFlnYov2I2jojPq+sfcaJyybCQZmlfwV39VhRHjEBRUMGGQ9X3
         Adsg==
X-Gm-Message-State: AOAM531pqFsq51kMeIku9ZovQ0lHZy/AEBuDlybouh5mwePyWi3OKN7q
        VSCzEd9/3LoieV75TLha27tlCQ==
X-Google-Smtp-Source: ABdhPJye7cyoWuSfh64Wkw363zIlPw3UWiNgoSQ8ar93rRfGB7SiqM2ju+5qQR9Gs5loNJrOeIfc9A==
X-Received: by 2002:a05:6512:684:: with SMTP id t4mr5461049lfe.325.1633463347292;
        Tue, 05 Oct 2021 12:49:07 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k28sm2083577ljn.57.2021.10.05.12.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 12:49:06 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/3 v5] RTL8366RB enhancements
Date:   Tue,  5 Oct 2021 21:47:01 +0200
Message-Id: <20211005194704.342329-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is a set of reasonably mature improvements
for the RTL8366RB switch, implemented after Vladimir
challenged me to dig deeper into the switch functions.

ChangeLog v4->v5:
- Drop dubious flood control patch: these registers probably
  only deal with rate limiting, we will deal with this
  another time if we can figure it out.

ChangeLog -> v4:
- Rebase earlier circulated patches on the now merged
  VLAN set-up cleanups.

Linus Walleij (3):
  net: dsa: rtl8366rb: Support disabling learning
  net: dsa: rtl8366rb: Support fast aging
  net: dsa: rtl8366rb: Support setting STP state

 drivers/net/dsa/rtl8366rb.c | 112 ++++++++++++++++++++++++++++++++++--
 1 file changed, 106 insertions(+), 6 deletions(-)

-- 
2.31.1

