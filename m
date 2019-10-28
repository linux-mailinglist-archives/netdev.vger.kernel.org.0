Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BE2E7974
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbfJ1Tyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:54:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38247 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ1Tyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:54:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id 22so207774wms.3
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7/y3Y/L1N6qWXLjdzpU5mudcFlynxj9+Zb1kMET6v+M=;
        b=OXK4HOuR0yafmw0qppoFRz7f9cEP/svqPOrE6OyaPg6Y/fJ6g/c0h11gWKQn/+z2rp
         alJ9NxKbIVAQ5moRkiYVHUCmaqdBOpuKn6454pU3odBcJbsrQXjiiHLOF4+r0sbUUh/U
         giQ6jx9UyXGAinL2Wt0bhIbQ+NXGWvId1xdDwufmQESXS4RV+qftborzLaorHzD1qMl9
         NudYMXjo6NBvgpG98Pv/N5fp/DEvsVu0vPbKmoat1DdFe0eHFHYSg8dMc3pngnAbbmfq
         xw+m4h2kgGpUUfqoCdkVYVihsABXS0iWNnmha0wM4iidz2btKG1WPW/tX33foYTkd5Ov
         GLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7/y3Y/L1N6qWXLjdzpU5mudcFlynxj9+Zb1kMET6v+M=;
        b=Z6s1RdEbwvnT+ynYBlGUV82YnZ0uaMxRfCKmm3EftuRBC3u1aMbxVk4ljgx8LXOHv/
         5K/4kf5pbDhbOgigtwqoN9Z6mIth6cIDzRavb/5oR4Sg9X4J4c5X8HS676enkjROuBP/
         XR8jS+lHfHh1H3iNRnKiTB64pGcrCcaNAoHSrqYDSx3/fK2FJXZ7CL21dk5QJKeSZjZS
         5hj+I40ffmH4wbW/1iwKh2A5SQqoOimq6bt5oRIgQSY5gBJ6tqYin0BkfMQjjIUMpIFH
         J0Z9UYxudrzyywke2uKxje+U2O4AWSV9BrkGAP8t5cwVob/dn0eSo4IaPKZRum59k2z0
         s2jg==
X-Gm-Message-State: APjAAAUy+hT9aWoEcZ7Hq+CzefrKDdhj1DZ1ohrEgogtonj6ig87yT/d
        /dPNPjJaJ1tflru9qVZNx58wiHuX
X-Google-Smtp-Source: APXvYqwgOi0NKMGytE0RPLbbPCI8VLFrLKGA4Y17Jq17pO8ygN2fnDRLfo3r1f/+V0RlubjS4fdRHw==
X-Received: by 2002:a1c:41c1:: with SMTP id o184mr900243wma.81.1572292474673;
        Mon, 28 Oct 2019 12:54:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8? (p200300EA8F176E00957829B82CD48CD8.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8])
        by smtp.googlemail.com with ESMTPSA id r3sm19151011wre.29.2019.10.28.12.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 12:54:34 -0700 (PDT)
Subject: [PATCH net-next 4/4] net: phy: marvell: add PHY tunable support for
 more PHY versions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Message-ID: <e74bb89c-f510-61f7-f2fc-41fe0114c282@gmail.com>
Date:   Mon, 28 Oct 2019 20:54:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More PHY versions are compatible with the existing downshift
implementation, so let's add downshift support for them.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/marvell.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index aa4864c67..cb6570ac6 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2287,6 +2287,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1011_get_tunable,
+		.set_tunable = m88e1011_set_tunable,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1111,
@@ -2444,6 +2447,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1011_get_tunable,
+		.set_tunable = m88e1011_set_tunable,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1510,
@@ -2467,6 +2473,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
 		.set_loopback = genphy_loopback,
+		.get_tunable = m88e1011_get_tunable,
+		.set_tunable = m88e1011_set_tunable,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -2510,6 +2519,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1540_get_tunable,
+		.set_tunable = m88e1540_set_tunable,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
-- 
2.23.0


