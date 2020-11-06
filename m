Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3940C2A8F90
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKFGnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKFGnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 01:43:09 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE03C0613CF;
        Thu,  5 Nov 2020 22:43:09 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 72so409231pfv.7;
        Thu, 05 Nov 2020 22:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WEUskz3+ddkGjSG8zEKiGF0Dv4WaYSSaocOmoLWqKR0=;
        b=Pu47x/qiOQ3KF1skNy1NuZj5uuuuUQQPNFTFCDxsR5H7YlGuoZzRIMCieIStZBnEOs
         GBbi1oZhWub0ya+jW+IhkeNi7u8f50Ni2W26EQuqtd48SqmxdKxMZz6u3AYyFjtg0xS2
         HXNRpiIDwHXfNfntkmc5lfv+fHM6iXYgrw5uhuDSM+JrZISwb0ZNn+qN8HYXs2gCD3J8
         GYb01fdYaE1BdmUSi7uFTVhEYYVaRnZ/qBtHlMqA3CC1Q0YHK7ngA5yMTGTpytMTg9Ab
         QDgy5HIn17qO2MSXI4nYqESnCD9JgnIp4DYc3Al/gOTn5xrr45cVYnnm86UK0Va0f+tB
         ztrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WEUskz3+ddkGjSG8zEKiGF0Dv4WaYSSaocOmoLWqKR0=;
        b=rShaoM5z0WA68x/gFTlvAcrGGmv2S/SB/mIEqxEn1LHtKqmq/8V44eYID6ALA6YUXN
         dsa/nmU/iUh/d8VEtA08iqhgPO3w6CH/hllbV54LTJkhWQOsVt+/85bzTWWthPvIzpkz
         OF3VvJaeaXbQljlInstwnSCLr9VnYgy+g2BNZjWsKA0dKzqg+zZkTpPB/qFLnzAl0APf
         vSPbUre7SV9oe1nIF4+SVSW6TQlo0T8tGxdZ2qh/jBREyB5SC32IjhNMWABUq/m6tfoi
         z/XHNGaoIjhog2NQVjXRY8Yw4bgb+NxGPKlgmVss1wpXiKCZbfq8/pT16OvlruzfYARK
         FHvw==
X-Gm-Message-State: AOAM532rU45bL29QQFvyhCacrTC9+FthRvEbnsn8st5F0xkp7RbKgNvg
        Pc0RQTLJCCh63dpfFzu1cfs=
X-Google-Smtp-Source: ABdhPJxPqnAjT/NtUlZO8UO5KvmpG+ig0Yg058pc0M1Hiv8iggVcqr2vh7JnZUQvosFqv6YcVKLf7A==
X-Received: by 2002:a17:90a:4dc3:: with SMTP id r3mr861144pjl.155.1604644988973;
        Thu, 05 Nov 2020 22:43:08 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id g1sm837820pjt.40.2020.11.05.22.43.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 22:43:08 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: ipv4: remove redundant initialization in inet_rtm_deladdr
Date:   Fri,  6 Nov 2020 01:42:37 -0500
Message-Id: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The initialization for 'err' with '-EINVAL' is redundant and
can be removed, as it is updated soon.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv4/devinet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 123a6d3..847cb18 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -651,7 +651,7 @@ static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ifaddrmsg *ifm;
 	struct in_ifaddr *ifa;
 
-	int err = -EINVAL;
+	int err;
 
 	ASSERT_RTNL();
 
-- 
2.7.4

