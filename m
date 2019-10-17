Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9915CDB5DE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441333AbfJQSWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:03 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40613 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441327AbfJQSWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so1517287pll.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m6uzD5ZcLGKi6uO8i2/yJHgC+NtEJHek84f2VEOwr9Y=;
        b=uhtN7deMFfWwfIznjZ8FFJuUAK0KNPS7dcImPrQddV7IWDqu0CCAROz8FAOYETgngf
         657u6WkBxruBSEvOU9sbYcfMuRgZd1FjGlPIDVaKiADIil7IsuRcv6jhgQzQ35jPlgM+
         lXHJ6WiV0mpWQ/K8NdptgrLYiYlJt9Fy7kLZBhrHVokatRInjFOP/ifFubvtBc384brB
         1pTPUcIId2VRyEB1A4+XDTFuvCzUe9fr6xoXdYs12dPvodwjxlKi9a1B8bU9Z0P6C+qO
         H6fE3mT+rhEVyHnLahOzxHba2tFC0OMFXSFy0w65YqpnzKO3BkgaBblGJ8J9Uotps0yI
         3vNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m6uzD5ZcLGKi6uO8i2/yJHgC+NtEJHek84f2VEOwr9Y=;
        b=q7dEKEOHTLPC68/fNDjQ0AODLuPguSdZDT1QlF2ylSJdQuFbq6sVleNPGj+GImbDWt
         BSqSzo1JFzoAS/JgyL7WuhxBM/O3uoJgwqEh6LL6c3iiLgXndxkT5Yia9KFCAoES8Jyu
         Qw+jO1g3ZYMiunUnExaiP9/CeVoLzZBzOo1VH0lvYw+Cjr/99ryqlTHIbynsBywBkVmE
         CO1cfGJLiD2cFqyZnTjVcLuO9q+s3muNdFBaiYhc/UKrNDKoc/BXvzzsZlf2oGE4QitV
         Cnq/BiRlwqWRg+u0nBUph4I/ETglqQEpebFeiq1pdxw+PmhTClt9HviVrCrZhhnHHw7P
         1Cjg==
X-Gm-Message-State: APjAAAXqtmb6gOXDmsQZSgFjHKC41CB2CcItZfQC8NqVVETZvoDbLbj3
        i1g1WY87ASKrKX0PsihM9ow=
X-Google-Smtp-Source: APXvYqysCsEaqmFXa38sqAVLFK2wLgj+C12SJR9ACnXhyLrANAOnmhWwtS/aghJQ0f0XNoZmeGZmBw==
X-Received: by 2002:a17:902:8bc7:: with SMTP id r7mr5506147plo.333.1571336518125;
        Thu, 17 Oct 2019 11:21:58 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:57 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 16/33] fix unused parameter warning in st_{mac100,gmac}_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:04 -0700
Message-Id: <20191017182121.103569-16-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/stmmac.c:21:49: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int st_mac100_dump_regs(struct ethtool_drvinfo *info,

  external/ethtool/stmmac.c:54:47: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int st_gmac_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Ie72738aea1d903df4aec417cbead9e6109ee108f
---
 stmmac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/stmmac.c b/stmmac.c
index 79ef151..98d9058 100644
--- a/stmmac.c
+++ b/stmmac.c
@@ -18,7 +18,7 @@
 #define GMAC_REG_NUM		55
 #define GMAC_DMA_REG_NUM	23
 
-int st_mac100_dump_regs(struct ethtool_drvinfo *info,
+int st_mac100_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 			struct ethtool_regs *regs)
 {
 	int i;
@@ -51,7 +51,8 @@ int st_mac100_dump_regs(struct ethtool_drvinfo *info,
 	return 0;
 }
 
-int st_gmac_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int st_gmac_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		      struct ethtool_regs *regs)
 {
 	int i;
 	unsigned int *stmmac_reg = (unsigned int *)regs->data;
-- 
2.23.0.866.gb869b98d4c-goog

