Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006D06C4EF
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 04:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732948AbfGRCVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 22:21:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40590 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfGRCVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 22:21:17 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so12988539pla.7;
        Wed, 17 Jul 2019 19:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=p+LjhuKBh7nce7Y+lpAKDWjlvBnJG3DCGoCsO8czRPA=;
        b=V9oXHnjNRMBPoc/XZ7mKAQDwsYqQUg+QzF44fwuMzKNaE/56hg24mSLhmd664iXS9I
         neugAspe7T7CagYX5h6Ixx3fe1uNSe3YrHuB0qX3WFpMsFA2UISxh6CAP9x8dvMXDojZ
         t0oSgQByNbYb75yFM3KQX8k14t4whJDqU345lKoxnTVLWFOWBjKkCGSndn0xClnFq6aL
         jitefDyI/BkvVvS/W/2S1BJI/JIvov1c+1HpIIx0wwlqqe1HkREbWDVBmlCFswOqhAG4
         bsSAYAit3ogE8QbRKSx1J9K+jIC7elr4KpX9LEw7nWrd1WHl1FmuXAGyBj2YH+WUvKD/
         aQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=p+LjhuKBh7nce7Y+lpAKDWjlvBnJG3DCGoCsO8czRPA=;
        b=UzXmQJxIlroKhhHlznebwDWbPR1HdowpNL59hilcXcF8DUJqysDo4A6iuNyXkolwiL
         zL6R1IjDqDyz6JTp+CaDyYaLxOR5tyaTXaQzz2eNMI1sFtE4N7VbjR2CdjlfRFvcFAYf
         +KuMkX/rRgNEVNuxZaGOaZajx0wzmmNm0UUlZgvk1z6eVJYBW+mYBs4C+Neia6lehb9R
         ow6Vkcjqkj+k8T3u0oN1W2eJu43b5i1webd992efWl2EIu3O09ANouRRpaP/qtqwQW7+
         Xru8EzK5Z00DDkjrPdng2H2D8OsQ88tfw+cDQxQZ1/ETdPPSdo8jnWS0cB9SQThRqQoz
         Z6Sw==
X-Gm-Message-State: APjAAAXagb5GxGU33KsVUxz34K88wVFXTtdH/BTxPS7pw7R3TLmTRDJ2
        UjyOfN6e4XWdb1xnFw/nV+8=
X-Google-Smtp-Source: APXvYqzhp9UNPhJLbPgEiS9emIzKfx6Lb59KI+5aqhHAwWjsr4RjI3qsDA6KHINu5FC8UZj2ZDrZUw==
X-Received: by 2002:a17:902:59c3:: with SMTP id d3mr45913396plj.22.1563416476874;
        Wed, 17 Jul 2019 19:21:16 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.86.126])
        by smtp.gmail.com with ESMTPSA id q69sm39143218pjb.0.2019.07.17.19.21.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 19:21:16 -0700 (PDT)
Date:   Thu, 18 Jul 2019 07:51:10 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: sja1105: Release lock in error case
Message-ID: <20190718022110.GA19222@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds release of unlock in fail case.

Issue identified by coccicheck

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 net/dsa/tag_sja1105.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 1d96c9d..26363d7 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -216,6 +216,7 @@ static struct sk_buff
 		if (!skb) {
 			dev_err_ratelimited(dp->ds->dev,
 					    "Failed to copy stampable skb\n");
+			spin_unlock(&sp->data->meta_lock);
 			return NULL;
 		}
 		sja1105_transfer_meta(skb, meta);
-- 
2.7.4

