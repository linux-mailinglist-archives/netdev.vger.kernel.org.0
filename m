Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7978F233E96
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbgGaE7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgGaE7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 00:59:22 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11113C061574;
        Thu, 30 Jul 2020 21:59:22 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id 6so22160272qtt.0;
        Thu, 30 Jul 2020 21:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=wMzcDNzPNQFVBnT9vBrYiAAkQh9MpynCIj9JP/G7Esk=;
        b=PgT2vspg0VN/b9KGbRTAo+Lvfig+smQY2toKv4A9vnRBTQT/X/M2KskqwHmFp/eNeU
         g4+ieBHcP8z7oruqGAEW6evM65BD7CUSwY1arwjo0wwBlIvJGeHg5TWO97JUU0Hli+r1
         BdGyzPDdlhfYpqD9y6LjScUxu9C2970/S6rcJJ7sJeBz+1CapmYJgxHVR9XaaCbS7W/6
         KUxT1EMxtnfKu9vf0yWn0433cXbaSHAGeIagkNS1zQf7aiYF0Yv3Enm9nElfGpj2c32m
         8bwbUN/VgJ4S3MTiacehSLic9UrFDDH1Np19UIVdBmqSBoi0z5NYc0uLpXQYBDMDza1/
         cE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=wMzcDNzPNQFVBnT9vBrYiAAkQh9MpynCIj9JP/G7Esk=;
        b=WmwXsjQOQDmfesHywQ9BXSCkVf92e7iVm12g5Q0Z4dPpCDq7zLGxcxZYFi69NAZsvt
         hKy907BcoB18HOkZP3WTE2Y39ePQLbGcTzWPSeiI9ucqwAWGzjUCUkArfKZNBBzZl+E+
         KP3qX3n5AC7Tz2NBzdpYdqmDl29b42tsMS26shLCDoNxYgXci91s21u2ypq6zL4Uhktp
         YR1BfOCYj/vQQOyad9YAnbfsBtc/G98RIVHfMigyPFfmnv0uP/XscPV1aBVp3M18WJoQ
         ZYHIz2cFezaCbmNaz8aiBTOKs5LDlfDoyECEhNChZ1Di5rvgb4Ry5JcctPIZ068fUf6B
         X0VQ==
X-Gm-Message-State: AOAM533UPGI9YpGgIvyBYfvdvEaKjITa055UWilJrSAhxZhVDs119zK3
        qnD1MkPqBnO/RlaI6/8yc1o=
X-Google-Smtp-Source: ABdhPJxU0i8aiB0tt/jF69mofMSXtBERepvQqrwyj7VT5pp4MpA0d3Fg8SQxV5nEmeHlBm7T1ecE6A==
X-Received: by 2002:ac8:428f:: with SMTP id o15mr1838167qtl.213.1596171561346;
        Thu, 30 Jul 2020 21:59:21 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:104e:9490:d5b7:450d])
        by smtp.googlemail.com with ESMTPSA id z197sm6950725qkb.66.2020.07.30.21.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 21:59:20 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        YueHaibing <yuehaibing@huawei.com>,
        Aya Levin <ayal@mellanox.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ethtool] ethnl_set_linkmodes: remove redundant null check
Date:   Fri, 31 Jul 2020 00:58:44 -0400
Message-Id: <20200731045908.32466-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

info cannot be NULL here since its being accessed earlier
in the function: nlmsg_parse(info->nlhdr...). Remove this
redundant NULL check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ethtool/linkmodes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index fd4f3e58c6f6..b595d87fa880 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -406,8 +406,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 
 	ret = __ethtool_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
-		if (info)
-			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		goto out_ops;
 	}
 
-- 
2.17.1

