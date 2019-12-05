Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7942F1149A1
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 00:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfLEXDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 18:03:49 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:41532 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfLEXDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 18:03:49 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 47TWVX4dRHz9vBr7
        for <netdev@vger.kernel.org>; Thu,  5 Dec 2019 23:03:48 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9aaAV6OUjBOL for <netdev@vger.kernel.org>;
        Thu,  5 Dec 2019 17:03:48 -0600 (CST)
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com [209.85.161.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 47TWVX3fYXz9vDw5
        for <netdev@vger.kernel.org>; Thu,  5 Dec 2019 17:03:48 -0600 (CST)
Received: by mail-yw1-f69.google.com with SMTP id 16so3800353ywz.5
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 15:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=MO10ke4bfA3Py2gapxPNJKqGZHjnWV9jw2bft4Kl1Hw=;
        b=o8kq/FV8cXLWxcKrmWwqxkUDv66DAT2G+5F8dgPlPsK2l/4v0bLFuw/zZ4WkoJUOra
         j7d1rGmVPr1XObXlyoBCxoAbInrvrXSEM+7T9Q6Q4wgxzS7JLdnQIFeulqvLZr2ONMBT
         TQ2P7rIP4szjGmrDnCCMZetziNAYCEtGnPREfJkkooWoZHwtYH+3xSHusomUuPG9t9b0
         WbcwXT+JPAdQ6v9lbTR4jO0+1jSajHx1OrXCBdBxb89fUIU4Ur+cp8tZj2C0IaJCyjof
         T4l7YuRus+ot8Yy0JmZ2SL6gXNSwFPkD4g02BZEI4gWsjd1C4KNwlHVfdqQ5q4n35Xr2
         RuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MO10ke4bfA3Py2gapxPNJKqGZHjnWV9jw2bft4Kl1Hw=;
        b=EyCwronPmif5GAV3PzjzRyY3ZxwrfhhlrES8yfoE/xu24GAr2Ok9UWrMJk8Urqiamp
         7VB8nKkQK6c/t4ChVjSY0uw7r9OGNGtw1t3CRBD6iT7ZYtGqi+PYRGEKoCUVpFpE6Irp
         qzx/lWBNNIzD+Lm02x3bjWQYY6ZVOiNZnh15tIjca21QkGu0DitTlzRxTTIj9XUOw8e3
         wJoivT9Kj1vIxHTWQqq6/ivyVkP0ejxDsV93bZMwRq77jqj4yfVPN62C+CWeTiaIEb1r
         3gXnDd2P0Cmi+Lz10wDtQSbzmN61yNn2QyOATpwb49VKhNjWhkcPQVluhvuCseTwfv1C
         /tWQ==
X-Gm-Message-State: APjAAAW/d71QdGnD6RhFGqXOejqEwZF4ibKQAzwk/ESEbGe6Fy/qdzof
        JoVE8Bw0PWUfxshTbivZhXKOrTzg/XhTbAtFar6chSqy5ce6aCRvm0XthvnRMZE85y53oNoEfmv
        KaZ+XrRS8YjXJwBkUOlcY
X-Received: by 2002:a25:d14f:: with SMTP id i76mr7709787ybg.247.1575587027810;
        Thu, 05 Dec 2019 15:03:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqwkEHr8jIGy9mRSBGOgEGBohtY9oZQx2HZqcHGHp7PRlziWpgnmiW+FCdEbCYBPqiawfQdx7A==
X-Received: by 2002:a25:d14f:: with SMTP id i76mr7709757ybg.247.1575587027551;
        Thu, 05 Dec 2019 15:03:47 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id y17sm5373245ywd.23.2019.12.05.15.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 15:03:47 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     klju@umn.edu, Michal Ostrowski <mostrows@earthlink.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pppoe: remove redundant BUG_ON() check in pppoe_pernet
Date:   Thu,  5 Dec 2019 17:03:42 -0600
Message-Id: <20191205230342.8548-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing NULL to pppoe_pernet causes a crash via BUG_ON.
Dereferencing net in net_generici() also has the same effect. This patch
removes the redundant BUG_ON check on the same parameter.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/ppp/pppoe.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index a44dd3c8af63..d760a36db28c 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -119,8 +119,6 @@ static inline bool stage_session(__be16 sid)
 
 static inline struct pppoe_net *pppoe_pernet(struct net *net)
 {
-	BUG_ON(!net);
-
 	return net_generic(net, pppoe_net_id);
 }
 
-- 
2.17.1

