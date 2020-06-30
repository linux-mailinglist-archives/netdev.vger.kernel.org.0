Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3165420ECC5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgF3EnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgF3EnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:43:21 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A52CC061755;
        Mon, 29 Jun 2020 21:43:21 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ga4so19057590ejb.11;
        Mon, 29 Jun 2020 21:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=25jr/pq8Q/4It7VKvPFDQOtmy/IUpmBGgg+WVzfzupw=;
        b=mFBt8det5LsB+XoucUPEEjyz2LE0viT8OZzR7UCXhJEpe7wjoMLrQHPmwW3RS7P/Mh
         H8VxIE9whbPwU+JbkYgRgprqi2qBD7I9vpM5EVLTrM//Rp2ASIFl6zF3A5/Ad0B+Twh1
         dOWxVEV6xJH8xHW84rzW4P3gnDD5WAU3nvq0J+Z97B56LWZlhuxPI9OAHeIaDKpLfJUK
         h6Nj0vHzdk2vh7+v4ZoM8LmPbCfbDDE8tECSUVcrPmZykm/4NTnzCh6X+/dwv3wzvUPk
         SQlOmZqZZ9tTd5gz52S3DdkCyYybzVxpkey3ibLYd3VMTmuzKGzOjxdl/MOnF6wLKS9u
         Vzcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=25jr/pq8Q/4It7VKvPFDQOtmy/IUpmBGgg+WVzfzupw=;
        b=HxuMLi3ICOR9l79nbpHeBBzumUU01AekO08wP8h1/xLIpWzWEGDGJHUN5Cz5bfdvQH
         DQNXNNnnhBhGwsyaOPBuHXNwUbtOnE7hZW/C2SpGlUC6G3CY3o519XvPGOn9cSzFaFpM
         Ajjp2MVLFjqGLLnJG76ecM2pVcZ4rX1MgI/flzfEt6gpSR57Vm5Y1BpoMTAmdwGoI5lX
         Db3Y2rZN+c/6nENj30y2my6zo6WyWw9wpgkg9MjoZepJOMWYgl3jgtojE2VofGBtcJIz
         pOFK+KR0yjdJWig/XljlEY7ktP5whemdvuUoSGHdjdB6WB/zJ2CQFRfIW8OjfnUWsHgr
         RTGw==
X-Gm-Message-State: AOAM531RVqttAUmzgcRWarfBoruE0eBFWDUXkde9yTC3cbx5UDNElooJ
        usGTQaubtqbngrPzFkooLFHAuCif
X-Google-Smtp-Source: ABdhPJzBzb5auEquLylqvZdcCyp9+UKtgzotOzkx2p+I3wofS59T3LR2eQt9iNLUw3i3txCIBabtNQ==
X-Received: by 2002:a17:906:33ca:: with SMTP id w10mr9041519eja.171.1593492199701;
        Mon, 29 Jun 2020 21:43:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u19sm1681673edd.62.2020.06.29.21.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 21:43:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Improve subordinate PHY error message
Date:   Mon, 29 Jun 2020 21:43:13 -0700
Message-Id: <20200630044313.26698-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not very informative to know the DSA master device when a
subordinate network device fails to get its PHY setup. Provide the
device name and capitalize PHY while we are it.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/slave.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4c7f086a047b..e147e10b411c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1795,7 +1795,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	ret = dsa_slave_phy_setup(slave_dev);
 	if (ret) {
-		netdev_err(master, "error %d setting up slave phy\n", ret);
+		netdev_err(master, "error %d setting up slave PHY for %s\n",
+			   ret, slave_dev->name);
 		goto out_gcells;
 	}
 
-- 
2.17.1

