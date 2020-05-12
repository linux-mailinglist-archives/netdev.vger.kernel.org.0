Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF71CE9E9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgELA7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbgELA7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14643C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:54 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k19so4648773pll.9
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dH6G6XmuGFTs+Iu6YJv+GremoIxkMUdd5NMIhh1RIMY=;
        b=zIb3eB6pz5ph/9dFamE+AeSslQrOUB4RDxB+n+OIl6NqwfvlDwljZm181sASUgrl3A
         ttnVnZjZEaIgcTNk4TZpscv8r8EjQ1sTVbtIi1KFBFlAAaS37hjcsO7DlCNgCXnsoatA
         OPsUFSAdA84zlWwW5OuKV1ziymdJgtKuH3YSTRRVkLLuqbKUiuBmhkWw6Yt6DRvFe469
         Nmbs5p50wfP7kJer5q+HR3Gbuh4L/Hol7U3g8LkNoXaG6MthQPJDTlVX6UNrN8nmRt9B
         onoCxIZpIi1dubXcdwv7TIsCOsT2uxDgnFeSgdKl34Sdw6XfDXIOfITavDHO8COegllK
         6o1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dH6G6XmuGFTs+Iu6YJv+GremoIxkMUdd5NMIhh1RIMY=;
        b=chgyKjb0fFvSw5ssJ4CREFIxyQ13iT/Hbhjvqkrnwvdw1yH33zqOO89t1xJ8WmZvPe
         BZCTewybheo2+rnYXsHJDQ8q7WjKY0WE9C4ZnCOLQlbAMWs26TrJ3Tuozu/0kV3JBy6y
         k6oidJta3LPlSFoWcbduN6X5HcdH2T4DtudlYtR3w4iO2lX1AR6GEzBgTscn4Cz25lg7
         /CZ+4u+Ay9PZVdKoUrWSL3+RaozMn0jzkaCXz9sHYOPcOGVXyfVJjUnqu//8Ckn49G/X
         wMlXMBFjAQln5se6mp2BLg7mQb9tcPJcTQpBBNpElLv3G5P3IzkvFc1uw+Yu9TwwSitq
         u2Xg==
X-Gm-Message-State: AGi0Pua4FLqMd0GdT5mG51AJVgW/f95XDbLnBcy9ibi/YcPSOEGcpyu9
        y+oR2EvCrgRWmovgyb4T2sFbA6mH5FA=
X-Google-Smtp-Source: APiQypK3tUtor4KTzaCeo1YYMVklKqk+ybRXdDe3gVceS+2eDy5QY4FUTpD9JwUnrkWyJsr3u7AqQA==
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr23592913pjq.26.1589245193350;
        Mon, 11 May 2020 17:59:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 04/10] ionic: add support for more xcvr types
Date:   Mon, 11 May 2020 17:59:30 -0700
Message-Id: <20200512005936.14490-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple more SFP and QSFP transceiver types to our
ethtool get link ksettings.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 3f9a73aaef61..170e72f31197 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -159,6 +159,8 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseSR4_Full);
 		break;
+	case IONIC_XCVR_PID_QSFP_100G_CWDM4:
+	case IONIC_XCVR_PID_QSFP_100G_PSM4:
 	case IONIC_XCVR_PID_QSFP_100G_LR4:
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseLR4_ER4_Full);
@@ -178,6 +180,7 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
 		break;
 	case IONIC_XCVR_PID_SFP_25GBASE_SR:
 	case IONIC_XCVR_PID_SFP_25GBASE_AOC:
+	case IONIC_XCVR_PID_SFP_25GBASE_ACC:
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseSR_Full);
 		break;
-- 
2.17.1

