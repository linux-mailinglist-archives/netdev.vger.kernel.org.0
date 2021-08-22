Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399BF3F40AB
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhHVRVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 13:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhHVRVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 13:21:34 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C61C061575
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 10:20:52 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u1so9070509wmm.0
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 10:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ySFyNOmXc2vwcHT1cuuUNM1YuCJ0oO/SVz0VBVYIjCM=;
        b=nz1BOsGVtC7DYy0XvDk5d2sUFU88Z0041FSfOA7DFqipwF510cv0bfcd6FPn4zM+oM
         Z4Vlpm7lP9ClsNcTvhznA6bFI2zo4h90zTYazsEKUOX9UiEqmFS5Vh+M3xc8JrC6M+aX
         iihyOnZSzsHZIviCLulY+K4V6myb5L3z7dgFQT8/AQAzV3IE6Yd3/usl0Cps0w4ZWQhL
         /1CibVUEkcPeU4aiYxYz6olLHFpDSBG/ZupRlQm2W5ULwEzYvSQMvuQXY5By+Z2dcS8Y
         zIgVwfJQZZZuHH2dcDC9wULg0UZ5bocLBRBhd80INu8AFqLDcGdWcusu3maCDiEekWnI
         jG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ySFyNOmXc2vwcHT1cuuUNM1YuCJ0oO/SVz0VBVYIjCM=;
        b=GUi/zUANg65IDKGRo2VHnyzcXy36dyqpgo4qNA153Q8XWbXIVYAR+3qT45d+hgoopG
         zhCsomU2ZY68ME4xDQcppG6DSRAYBfHKHZp+0TziSQeJ05F4a3dNRQXTUCLm789oqbUH
         pO9LYB4FGo1mcjm+Mcy/U5A4/vq3XhyQlbgznKsV4JTMy7M6qQ8A5akfCv9ibbV4P3Z/
         NKCQezFhMclDgrWSlrWRGC83a2FOZFkVoqGO9laPH9gaiOou7OfDepSf2wh8hj78WjEY
         D8e4P6xrnd3I4LKQ3xnG9Lmw9WLSv0CDQGVmZ2+YALjAeLxKgtOSakx19rFHZXLT62hu
         i8rA==
X-Gm-Message-State: AOAM530QAoCBd3xf+yJhLC+lUs620Kq61K7R2jQPj+tYQt6iX2GFILMO
        6givM5HWkFPHfWRdLKUJsmiM9Qh+ZSxN2Q==
X-Google-Smtp-Source: ABdhPJyMiZ4y9p79girexzL77veTxVn5cYkaAuRO96rbzqIUn0LX/003BwHPlOMcaJOOkH9Q90GbjQ==
X-Received: by 2002:a05:600c:4fcc:: with SMTP id o12mr13063689wmq.0.1629652851208;
        Sun, 22 Aug 2021 10:20:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id q10sm10607993wmq.12.2021.08.22.10.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 10:20:50 -0700 (PDT)
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] cxgb4: improve printing NIC information
Message-ID: <8b4286fe-b16b-d29e-4e26-f7f225b83840@gmail.com>
Date:   Sun, 22 Aug 2021 19:20:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the interface name and PCI address are printed twice, because
netdev_info() is printing this information implicitly already. This results
in messages like the following. remove the duplicated information.

cxgb4 0000:81:00.4 eth3: eth3: Chelsio T6225-OCP-SO (0000:81:00.4) 1G/10G/25GBASE-SFP28

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index aa8573202..f85d02757 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6162,8 +6162,7 @@ static void print_port_info(const struct net_device *dev)
 		--bufp;
 	sprintf(bufp, "BASE-%s", t4_get_port_type_description(pi->port_type));
 
-	netdev_info(dev, "%s: Chelsio %s (%s) %s\n",
-		    dev->name, adap->params.vpd.id, adap->name, buf);
+	netdev_info(dev, "Chelsio %s %s\n", adap->params.vpd.id, buf);
 }
 
 /*
-- 
2.33.0

