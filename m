Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6954A139396
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgAMOVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:21:20 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40305 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMOVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:21:20 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so9831582wmi.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 06:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rgs1wvu0dvAAXenulUF42LX7/39Ayw5T9UFC7dlca+0=;
        b=ocJBmDeUrYexQ0ggtajB/RlpdQ/SCWvbdcJSj1dPm0Ybfx5NrJ1lQ4Gi8LCCX039IX
         z+b4wqXUiI8qP4J40f0SiJv06qBT0rsGOlXCVHhP21AjDof5SFEicYG5j8OOGTuUwruZ
         bBHsitAdp3v4QWloOcQWE+yr66CN+zhZjpxs25WkOnMm07KiNqyxALbsLbRVq1XPf7me
         UrRqBR+YJI/D2IrLbsUHLdQmAAwaRk+eIPVP0mwzxRU0gYFMxhGr8hpJ/MdN1sUkuPno
         2griP1/82nNwzGPUUKokoewj5Wk2mTUeYAdldou6r+rv4RyCuC9zQlzA58YrrYBGw9hI
         gJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rgs1wvu0dvAAXenulUF42LX7/39Ayw5T9UFC7dlca+0=;
        b=GNFFSfjNog70USu6egNNYtUmVpaw6/dWYo13M4EnqDzYsaWaKLDm+MFnVGb93bxjxA
         qgSyPlXoNW7iGv02g79SOWH4Sn/Vk0agaoYC7O72M5Nl3HXlP2qZ98CT3lpMtOzsqWLQ
         7rm7Qpzetyg5D9A/klwdRo3BiAK9g386OKWYyhR0HTp/YfJnr/6eSnEc/1KRArdeD5MA
         S1yuJu4FeibmKJay2ygfjaV6AQo37Inst3GD3zdMEdnmhbw/uc1lXTGaPN4CZMm5b142
         mtPIzpUdkzxwZNDWz3B53xtEW2Q0S8HQQO7Tz9/y9WRHhMK5saoGo/heNAyrnVuZh9N8
         qbYA==
X-Gm-Message-State: APjAAAXs1AOtqwO2/9kia5aH4qW/INtmxJKaD3CjmgRtV5hW8/BIOOie
        scvVVoLpl7l5eDhGZOGb8rupGk55EXo=
X-Google-Smtp-Source: APXvYqyeEvrK3C6kwxPYRRbEqKS637H54Web0dNSSiQeJ2p0S6MZbvWsUfEQ0goTqNnFDDDcCCRyhw==
X-Received: by 2002:a7b:c765:: with SMTP id x5mr20086970wmk.129.1578925278318;
        Mon, 13 Jan 2020 06:21:18 -0800 (PST)
Received: from localhost.localdomain (ip-213-220-234-169.net.upcbroadband.cz. [213.220.234.169])
        by smtp.gmail.com with ESMTPSA id g9sm15243476wro.67.2020.01.13.06.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 06:21:17 -0800 (PST)
From:   Petr Machata <pmachata@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <pmachata@gmail.com>, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH iproute2-next 1/2] libnetlink: parse_rtattr_nested should allow NLA_F_NESTED flag
Date:   Mon, 13 Jan 2020 15:16:28 +0100
Message-Id: <e7fd69716c2df1670ac6958ba63dbda696503acb.1578924154.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1578924154.git.petrm@mellanox.com>
References: <cover.1578924154.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In kernel commit 8cb081746c03 ("netlink: make validation more configurable
for future strictness"), Linux started implicitly flagging nests with
NLA_F_NESTED, unless the nest is created with nla_nest_start_noflag().

The ETS code uses nla_nest_start() where possible, so it does not work with
the current iproute2 code. Have libnetlink catch up by admitting the flag
in the attribute.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/libnetlink.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 8ebdc6d3..e27516f7 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -173,7 +173,8 @@ int rta_nest_end(struct rtattr *rta, struct rtattr *nest);
 				    RTA_ALIGN((rta)->rta_len)))
 
 #define parse_rtattr_nested(tb, max, rta) \
-	(parse_rtattr((tb), (max), RTA_DATA(rta), RTA_PAYLOAD(rta)))
+	(parse_rtattr_flags((tb), (max), RTA_DATA(rta), RTA_PAYLOAD(rta), \
+			    NLA_F_NESTED))
 
 #define parse_rtattr_one_nested(type, rta) \
 	(parse_rtattr_one(type, RTA_DATA(rta), RTA_PAYLOAD(rta)))
-- 
2.20.1

