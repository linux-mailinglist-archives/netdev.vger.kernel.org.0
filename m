Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1098B5CFEF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGBNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:00:45 -0400
Received: from forward101o.mail.yandex.net ([37.140.190.181]:40011 "EHLO
        forward101o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbfGBNAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 09:00:45 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2019 09:00:44 EDT
Received: from mxback2o.mail.yandex.net (mxback2o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::1c])
        by forward101o.mail.yandex.net (Yandex) with ESMTP id 3ED3E3C003CD
        for <netdev@vger.kernel.org>; Tue,  2 Jul 2019 15:55:20 +0300 (MSK)
Received: from smtp4o.mail.yandex.net (smtp4o.mail.yandex.net [2a02:6b8:0:1a2d::28])
        by mxback2o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id rmrFR1Rjr7-tKue70Qb;
        Tue, 02 Jul 2019 15:55:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1562072120;
        bh=yQXUyy0AsGu3g/kNCiWJzkpPEUubO8yGCeXG5OLp1uo=;
        h=In-Reply-To:From:To:Date:References:Subject:Message-ID;
        b=BRsgqzFA34M92V5SGGuNSJQBXCReJ2HAORcF28JfI0VBujsn2kcoOYYJQgRwJnuBR
         F0r8XeVyCK/Wfs00zXMAhHWilnUl8t4R1pKQ8VUYS7R5LVdtfRb4bGOf5L32PKHpVZ
         g07G7QNMXQgVv+0ETEbg66ihEUTriWpiot7MInVE=
Authentication-Results: mxback2o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by smtp4o.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id a9JB0mSfq3-tJ94otW6;
        Tue, 02 Jul 2019 15:55:19 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH] User mode linux bump maximum MTU tuntap interface [RESAND]
References: <54cee375-f1c3-a2b3-ea89-919b0af60433@yandex.ru>
To:     netdev@vger.kernel.org
From:   =?UTF-8?B?0JDQu9C10LrRgdC10Lk=?= <ne-vlezay80@yandex.ru>
X-Forwarded-Message-Id: <54cee375-f1c3-a2b3-ea89-919b0af60433@yandex.ru>
Message-ID: <fc526c78-2d3f-90ca-8317-a89eb653cbf9@yandex.ru>
Date:   Tue, 2 Jul 2019 15:55:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <54cee375-f1c3-a2b3-ea89-919b0af60433@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, the parameter  ETH_MAX_PACKET limited to 1500 bytes is the not
support jumbo frames.

This patch change ETH_MAX_PACKET the 65535 bytes to jumbo frame support
with user mode linux tuntap driver.


PATCH:

-------------------


diff -ruNP ../linux_orig/linux-5.1/arch/um/include/shared/net_user.h
./arch/um/include/shared/net_user.h
--- a/arch/um/include/shared/net_user.h    2019-05-06 00:42:58.000000000
+0000
+++ b/arch/um/include/shared/net_user.h    2019-07-02 07:14:13.593333356
+0000
@@ -9,7 +9,7 @@
 #define ETH_ADDR_LEN (6)
 #define ETH_HEADER_ETHERTAP (16)
 #define ETH_HEADER_OTHER (26) /* 14 for ethernet + VLAN + MPLS for
crazy people */
-#define ETH_MAX_PACKET (1500)
+#define ETH_MAX_PACKET (65535)
 
 #define UML_NET_VERSION (4)
 
-------------------
 

