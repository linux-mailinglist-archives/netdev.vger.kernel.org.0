Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C501DF811
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgEWPkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 11:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgEWPke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 11:40:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B75C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 08:40:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l11so13242383wru.0
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=oH8+MIJabNCGDrSLi/pBoIYe0aeOrCFf09t1tx2Q72g=;
        b=QKtMEO+s9K6nr4JDJC5jX7tkWEEkZMGSLuiFj/J/WBT9dV/N2vyWYvtjswlZ8O9DQx
         IuD3WDfGXhe7+ZeQZcreY3IVeUJpBUn3dtEUHytkBG/x5jgGGrnjF9kejBTrRPIcsdtD
         JA11lSwFwWAKmbnLXdY8OCX/vU4EvoRNDpleBPX51bS0ET1lswHvWGoMjiS2HiJMbUrf
         F/8aCIFK+JgsBup/QNCHLFts+g81PHLPgw3ZCDT9OpXHk6yl2nfAYXUV5w2oBcwRKrLW
         VTgE1tIgilW8q472YSMmo3utN3hRadRxoVivd6AiWHRPLd7QiKv2ToSqGuTcYu7am1fs
         ozJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oH8+MIJabNCGDrSLi/pBoIYe0aeOrCFf09t1tx2Q72g=;
        b=pznQAVjJqMWc0lzGLwf1lcNr8riak8iHGM/5w+b3QFVs4VZO4NYDDTT+6AQetFXfhf
         SYa32yoeHYL2kQzxVXVXymQupXU/eT5MFS3le+e3szGu63A+6sIOnm3IST/64qYa7asu
         1YCJTPwA6WULxIkXNSS7C3NzeGDmBO9UL9UrQG0TjOpXlOqHGmAdwJijB24aqqgSCZSG
         /nXjQuPw2xsB/IaimojSuxVD/xn7UYrKevx49YMMLw+0ViPtJtLCoYEzQRqzD0crjtif
         EoPK5aZ6oMSUTwerEDEFGgiZ4wKWpkpEW/0nsSFMqw9w7wWC8eREORNDPTWHupM4ZR7P
         Fkww==
X-Gm-Message-State: AOAM5323DBeQPZHUA0fuk0jdTy+g9VBchGRBf40fOtmryEZgK9PRP4ZQ
        BmqPR+5cZinKEK2d3ttuwk5BpDnd
X-Google-Smtp-Source: ABdhPJxURu67cjQISSX+f7/w8AC2qpaTnjD8/XxwlYseiRT2BQwsWf0d8ZvujDqWtLg3d7OTAlYVcQ==
X-Received: by 2002:adf:ed49:: with SMTP id u9mr6641431wro.414.1590248432820;
        Sat, 23 May 2020 08:40:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:69db:99aa:4dc0:a302? (p200300ea8f28520069db99aa4dc0a302.dip0.t-ipconnect.de. [2003:ea:8f28:5200:69db:99aa:4dc0:a302])
        by smtp.googlemail.com with ESMTPSA id c140sm13236541wmd.18.2020.05.23.08.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 08:40:32 -0700 (PDT)
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] ethtool: propagate get_coalesce return value
Message-ID: <1f4f887a-4339-1ece-b2aa-c9712e54bce3@gmail.com>
Date:   Sat, 23 May 2020 17:40:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_coalesce returns 0 or ERRNO, but the return value isn't checked.
The returned coalesce data may be invalid if an ERRNO is set,
therefore better check and propagate the return value.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethtool/ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index eeb1137a3..923e220ff 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1510,11 +1510,14 @@ static noinline_for_stack int ethtool_get_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
 	struct ethtool_coalesce coalesce = { .cmd = ETHTOOL_GCOALESCE };
+	int ret;
 
 	if (!dev->ethtool_ops->get_coalesce)
 		return -EOPNOTSUPP;
 
-	dev->ethtool_ops->get_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce);
+	if (ret)
+		return ret;
 
 	if (copy_to_user(useraddr, &coalesce, sizeof(coalesce)))
 		return -EFAULT;
-- 
2.26.2

