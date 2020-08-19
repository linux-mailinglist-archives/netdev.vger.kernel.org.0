Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19418249422
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgHSEc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgHSEcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:32:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33277C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:32:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mw10so528110pjb.2
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9kaV4wp2TQpcIemG9ojAw5AabFH8rPZrM13pkbLoeQ=;
        b=YQd/Ka+y2t6IaFNBOpzkKC3JxdPWcr2l1HcMOzPSFpnVCsCVdU14wkiyEbyFEoRJAv
         WSesWoeopTLRuzA3gjt+gsSIboz+JBePwUylDcUtqST80q44Q7UVlwQLKQTckAfk7eSf
         Z7F07ZmCamovf4gBt1tsCdVm3z3OposYIjlxPqfT8Bp0tZVa4+nEagnnlPcBXn7y99I2
         ffw4sP2RClbZy5Vur39xWYX+b/quuavQ+NW6MTpZxoErYBraiJImR4K/dlrszU4nzUi+
         kCRRLWiGnKm5q807Ra8L6U68vxwi4ZXyKX2nbaIyiWnBuvUb7tc8McN8gD17p5hvYrfu
         LlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9kaV4wp2TQpcIemG9ojAw5AabFH8rPZrM13pkbLoeQ=;
        b=YCGmQI3Tfd/TplIM3vFdp/g874eKuIA8sBCdnT9PVMe2YKbStkfln6kHaNMh+KHdEp
         BJS22Bn3kZ2SR7AzqRzyZKjHPMcvhk6IeXSPBaiJ+Eqv/ZhDP/t5UhSK+0Jp+lrJT98t
         1SQ+mrWRyBBgagJaXOQNu0EXDoRsShKcaKYM+FPZvtUv9J/vRk8QQ7qHpVahPt2mhaFa
         1X5DmNEJrR6H6aRst+gcAyYiAOMnzeUqJX6j9nnamL9uM0T1VYLzavwDQSCWi2RAP9Y9
         KUZCuUKdZwflZ8WZcRAYP+VEsMfwrKOtweIpOOkrA4hK+Y+gHe/ajA+NRcMUkj8wgYwC
         eTbw==
X-Gm-Message-State: AOAM531IsTGSVdFM2nI97UIvYMoKs7Xoo8v/HxvdKWasaoJo75Bf5luW
        5GJEmqmvkswYcX/N2AIYgpmw0YN5WIw=
X-Google-Smtp-Source: ABdhPJzgNfJw795noYhVKuB881UzPe9spS9zwxmSzOCBc9lOaMmzfn3Hi97OQ1bOZPZx1/Bg6UEOkg==
X-Received: by 2002:a17:90b:3011:: with SMTP id hg17mr986373pjb.190.1597811544208;
        Tue, 18 Aug 2020 21:32:24 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y65sm25942468pfb.155.2020.08.18.21.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 21:32:23 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/2] net: dsa: loop: Expose VLAN table through devlink
Date:   Tue, 18 Aug 2020 21:32:16 -0700
Message-Id: <20200819043218.19285-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:

- set the DSA configure_vlan_while_not_filtering boolean
- return the actual occupancy

Florian Fainelli (2):
  net: dsa: loop: Configure VLANs while not filtering
  net: dsa: loop: Return VLAN table size through devlink

 drivers/net/dsa/dsa_loop.c | 56 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

-- 
2.25.1

