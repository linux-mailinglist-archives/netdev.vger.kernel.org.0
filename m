Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D661F8A935
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfHLVVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:21:06 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43925 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHLVVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:21:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so31254566wru.10
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cnqQqb0SGfd+5GT4XvbWg9UZKsF/93tGyjUunsE8Hnw=;
        b=pnrC7WE2lqCpKfbk9nQC45vn3lrjLlywsGMUyESlJrl4gkZbKMrCsNut7ZnHO2e3VL
         yvjRWAciqHMovOZst0iBoCYeJa1HpGE0Ewe5QQPByQCOIqc4utq2t0PF4o0hFzKQmBWq
         irkKkFW/ATCraxQN7LYbl5df52ix52nqDkltQI+eP/ey7U8lGt55jbx144z7MS6HXcBz
         6k0+340aNZplRmtlvblTLdqfLDQL9M0qe1trNPdPa5OCoHRSa2uDZ72XgzXrZi97CRKr
         j4ARU5bx8Fk3m/AnoHdWgpUcTBERs9aQg9NtKljUqqBMHblBttKoz7Qhu290j7IIKwd7
         fUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cnqQqb0SGfd+5GT4XvbWg9UZKsF/93tGyjUunsE8Hnw=;
        b=A3FW2ixVqQRJqX+zsc0NG9IjAN8RpdZVkD9wKriOYYuOJybp1IS/0v6TsaAcQ0y3QW
         XMioNKT0YQj1s7+kHS1ONmH9XV0joBT6nM4aXyCLKwonVdLgZuzo+KxUAaCgvrVChy2w
         ankNvJCOvo3UL435YbRf8mXJh34CkCuByRN//zYOHEAjayMPtxoymW++1gLuSRbrGMI3
         9uL0BaO9bZucfu4hC/lmNhYHdwn4IHNRYqnKH+bLILJ2QzqozpG/h8I70H0DbvvIT9wC
         00ewxexHIYmDU13rtAF0VEEMUKCA0FaGrnLroe4TxJKofSdMfg2R2xIROeU1dQPF65ca
         og7w==
X-Gm-Message-State: APjAAAWlrvIxGoQ6BcZWq7FSBUpAy2MJ9MwaV4RyzXLYwCqWCBFtEPDm
        1if6E9YhZQR7eN2WSDiO5zvvPjnt
X-Google-Smtp-Source: APXvYqz/v9n1Wfe4mhCORkBZy4Cf/iTcJg2oPAwpnEZw3DasnsPLW08IVpmFYQz/GgKseKPNpu4GhA==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr26773930wro.31.1565644864117;
        Mon, 12 Aug 2019 14:21:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id o16sm23354539wrp.23.2019.08.12.14.21.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:21:03 -0700 (PDT)
Subject: [PATCH net-next 1/3] net: phy: add __set_linkmode_max_speed
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
Message-ID: <5067e168-7b49-7ba9-1f17-89d17509d423@gmail.com>
Date:   Mon, 12 Aug 2019 23:19:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will need the functionality of __set_linkmode_max_speed also for
linkmode bitmaps other than phydev->supported. Therefore split it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 9ae3abb2d..de085f255 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -207,14 +207,15 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
 	return count;
 }
 
-static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
+static int __set_linkmode_max_speed(struct phy_device *phydev, u32 max_speed,
+				    unsigned long *addr)
 {
 	const struct phy_setting *p;
 	int i;
 
 	for (i = 0, p = settings; i < ARRAY_SIZE(settings); i++, p++) {
 		if (p->speed > max_speed)
-			linkmode_clear_bit(p->bit, phydev->supported);
+			linkmode_clear_bit(p->bit, addr);
 		else
 			break;
 	}
@@ -222,6 +223,11 @@ static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
 	return 0;
 }
 
+static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
+{
+	return __set_linkmode_max_speed(phydev, max_speed, phydev->supported);
+}
+
 int phy_set_max_speed(struct phy_device *phydev, u32 max_speed)
 {
 	int err;
-- 
2.22.0


