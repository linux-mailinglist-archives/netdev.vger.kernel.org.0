Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B67A4810D8
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbhL2IJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 03:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbhL2IJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 03:09:58 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BD6C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:09:58 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so2299988pjd.1
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0JrwVv9QeLCl2D+3Fsm9kJiQZlNCs8/T+NyEIH727dY=;
        b=CZCW+9Rv5tEtH7If4+bKtzitK4Wi82FXxPxPdlO0i+X0QFDuHuHVAyBvoBO7kGrnC/
         M4O3cskPfpiI0qnUXJhb2ffSdhmdeHpE41E8zAiz617cr3asyhq3/bf1uJPUbgOndCXA
         U3/qiYb9aNUQH4Cu4redyuQDo0wjdd9Oq6pJGs5JojBidi6G9lyunGgMNWc2AyC8z/sV
         RaCetBrhJs3vAzgkKRlQnk31spiS4d+zNxqqs5MQpWclap7s3VI92KGAnmj0h0fVBL6X
         Y8z0Trw6IWEhq27tzBSIEq0DRQ+Dc8E0rNbWo8cwMg6GjfU8211C6xoC9LyohCZt2ehJ
         8veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0JrwVv9QeLCl2D+3Fsm9kJiQZlNCs8/T+NyEIH727dY=;
        b=tAO7RoJGziCwyfvvW1v2KvKWka2dxbBZPvnqzUa9dd6kN1R4PQf2qbppCNf4c3XjNm
         nOBzo5cQGTWbmZg7E6VGenEqErddB6XDBp3VVFxqLfp+PHPPeuw49cGdEYFNg+HR6UcB
         ApajCqUIaThf0jycmjIF35CUSREZvhUvP4ENydo7+uQzyTQ3h0TIpsxR3CVBMR2+kTGY
         AIbvP/ySf6Szums6EnB94FvvpNsePxbXsTUWAeaIbnyY9xzm6diCncq8J7gq8SF/FjnJ
         z706G67EuRvouKuwwSSe6BQfG0R7fkjjQ2MfoZDnUCtDMAENmZWmbqlisxd5E8FnbrWz
         9ZdQ==
X-Gm-Message-State: AOAM531jqdxRrYhMQj+ydfOzCFid2Thikru3B7NBJU4J8ohO2IEN92l1
        SVg2dczEc7R6kQyEhr32AYH0o0sLEOo=
X-Google-Smtp-Source: ABdhPJwqhTMxl+8jnnw+EwmI3Oo8o5beecior426EeIi3QgGaF0nUFm22iu7BNg7xE6QIeK50/Mzag==
X-Received: by 2002:a17:902:e805:b0:148:efe6:ec4a with SMTP id u5-20020a170902e80500b00148efe6ec4amr25547000plg.160.1640765397946;
        Wed, 29 Dec 2021 00:09:57 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z2sm23996709pfe.93.2021.12.29.00.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 00:09:57 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 1/2] net_tstamp: define new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
Date:   Wed, 29 Dec 2021 16:09:37 +0800
Message-Id: <20211229080938.231324-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211229080938.231324-1-liuhangbin@gmail.com>
References: <20211229080938.231324-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we defined the new hwtstamp_config flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
as enum, it's not easy for userspace program to check if the flag is
supported when build.

Let's define the new flag so user space could build it on old kernel with
ifdef check.

Fixes: 9c9211a3fc7a ("net_tstamp: add new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/net_tstamp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index e258e52cfd1f..55501e5e7ac8 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -87,6 +87,7 @@ enum hwtstamp_flags {
 	 * will be the PHC index.
 	 */
 	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
+#define HWTSTAMP_FLAG_BONDED_PHC_INDEX	HWTSTAMP_FLAG_BONDED_PHC_INDEX
 
 	HWTSTAMP_FLAG_LAST = HWTSTAMP_FLAG_BONDED_PHC_INDEX,
 	HWTSTAMP_FLAG_MASK = (HWTSTAMP_FLAG_LAST - 1) | HWTSTAMP_FLAG_LAST
-- 
2.31.1

