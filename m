Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB59B1467CC
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 13:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 07:20:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38253 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgAWMUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 07:20:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so2842966wrh.5
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 04:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lejqf24rosAsJKxrkKfL3dppqbpQPGWnzYp9MFYaWW0=;
        b=P+vxxUhlNsWfHCUEGguW11Qe/Pmp+uGaCdkiNx23Kzvqzd02brVaVlzoMesBhx6c3D
         Rz3LhmNbb+bVmlqoH6tbLxc5My6WMdeo0Q0zUpioYANkmo6pJ8HBEDBbB/TqwTC4KFZT
         Z+wx6yrk/prwq63YyVrNTKTgDDrxwki4pOyaZHRa71N/KNxtpdGlhtEXbYtB1mev23j4
         FRUCaCW0GNZmciO+di8giYn+VRD0ov5RGaG9OyXlDNTQB5qpVqtOxrQ/fWYX2wUkcNjl
         /jVeEBRVdZ2ZFmn7ZvL/wjc9ImPTWbbGxJe39zwhe9K/UTFtFtF/Rid+vb36W6YhEOhw
         TB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lejqf24rosAsJKxrkKfL3dppqbpQPGWnzYp9MFYaWW0=;
        b=MvbaY+lERXWtQoq0UFQjkIVMAEx5Y5132Azkh7lGKwGKyW7jeSKRVihbU9q64SyQv8
         xw95GzOA5W70DRFDTZqo/VKzXcAvPvbXTAkPdQtzGzSeMziTvv4+bskrJ9RFAWK92xKY
         CS8i7+3laoDzzsQoGOL8Zpsqy+WEYNIhqQRG1vyGf08tfhTwjS/nLydOlfu2PMJQXt2c
         xuObe9BgFF6bp4e9fsupZc/neoWB6utZoe5j5u8HQxzKnU0mpVWbRoFuG1d5kn0EFMW9
         HZwD8Wh6HVyb9NlXEXj+mx/do2ENirUkyYEVhKWAb4wfKwm90CfPRw6c20FHgGvthLjf
         RMGg==
X-Gm-Message-State: APjAAAWfy1k8yy/UXKfN3ng2CMVHUYc8sJFq7JXK9Suh5uzweEMXYI+f
        81aS7x7YlVURr25VRSYJivdie1PU
X-Google-Smtp-Source: APXvYqxr8vE9E7Dbn5Ep+XsdyqnSmZ/Fqh+F8zCAgCSilhqVY3IxXt6nY4IBM3t07AEo0khoypskxQ==
X-Received: by 2002:a5d:6441:: with SMTP id d1mr16829295wrw.93.1579782020711;
        Thu, 23 Jan 2020 04:20:20 -0800 (PST)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id q6sm2992320wrx.72.2020.01.23.04.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 04:20:20 -0800 (PST)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netdev@vger.kernel.org, dvyukov@google.com
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH net] fou: Fix IPv6 netlink policy
Date:   Thu, 23 Jan 2020 13:20:18 +0100
Message-Id: <20200123122018.27805-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When submitting v2 of "fou: Support binding FoU socket" (1713cb37bf67),
I accidentally sent the wrong version of the patch and one fix was
missing. In the initial version of the patch, as well as the version 2
that I submitted, I incorrectly used ".type" for the two V6-attributes.
The correct is to use ".len".

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: 1713cb37bf67 ("fou: Support binding FoU socket")
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 net/ipv4/fou.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 30fa771d382a..dcc79ff54b41 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -662,8 +662,8 @@ static const struct nla_policy fou_nl_policy[FOU_ATTR_MAX + 1] = {
 	[FOU_ATTR_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG, },
 	[FOU_ATTR_LOCAL_V4]		= { .type = NLA_U32, },
 	[FOU_ATTR_PEER_V4]		= { .type = NLA_U32, },
-	[FOU_ATTR_LOCAL_V6]		= { .type = sizeof(struct in6_addr), },
-	[FOU_ATTR_PEER_V6]		= { .type = sizeof(struct in6_addr), },
+	[FOU_ATTR_LOCAL_V6]		= { .len = sizeof(struct in6_addr), },
+	[FOU_ATTR_PEER_V6]		= { .len = sizeof(struct in6_addr), },
 	[FOU_ATTR_PEER_PORT]		= { .type = NLA_U16, },
 	[FOU_ATTR_IFINDEX]		= { .type = NLA_S32, },
 };
-- 
2.20.1

