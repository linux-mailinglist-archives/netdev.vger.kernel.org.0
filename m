Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68980CCBE4
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfJESE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54774 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbfJESEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so8705212wmp.4
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TZbt8V7XbqK46DYXQGK9NA1bOhHetznYLUFFGtGQyTU=;
        b=A6avTxam0LxYrMIAEy3Pyao6UiSlwxjXp7fViTx9EfEeKVlKS6CdGFGidxlRmP/o/8
         Yk2ewkrc4KBXvy6fGWPEuKOeEaxpOmaIzjjASFRpq3ldh8p9SGWzs2+Ns5dxtpPgiKWu
         o704KIHVPAGVRFxkCGiUdkJnpYGPtm93Dew0oQODvOzzPHBHV6JJg7xSPSyTEHwt5D3Q
         q6ypUJjD/ehNGgAvbd2LYbIYd7pZgw++2XhviFLM+OltikPJGz9Hs0DOkwYfygKfqpRU
         jJo0VtAVQ8jDocHJSALY6/irro86OR5aGKKM0WqaLmMubrUymBKNBv/b3fgKKLnW+DzA
         cAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TZbt8V7XbqK46DYXQGK9NA1bOhHetznYLUFFGtGQyTU=;
        b=QmOCUuCbi6t9f0mGY0x2jVQrimu+holkbse5nXScPzMFPSKWfW5YymlXc3wx+TMjxA
         qdJ1tu3yKZfR2PWYqqoRY4rRlwktSZRTLJSpBB7qyJFNwGbIC76YTmZkbmpqt2WhcC3l
         zTzqJ2vLxWmgyIyy8nQs4wU0zwQp0d/zHjO6+ILzIlGt3Qmz4zq4Y1m878qiL4FGm10w
         Nclb13kXKbD+fW2FtFbaPtwdplcDuJNotQqo3Fbi83FhToLJv1tWSCBf4MVpAKM1h0mI
         Q1xM9TUxVkfTdYjIR6zx4wDm0DJVgCDJY6E0yZG87DpkmhUvXc7T7+r66unxOsvriXto
         DxLQ==
X-Gm-Message-State: APjAAAW8G1eEU9Jzayehr82RiI59xVePlVED5VfkeD/JnUS+sFea/RiF
        FU4V3FQrNRSjUSCMIMS3oTnMzdPnkhs=
X-Google-Smtp-Source: APXvYqydWAa7n9N4FHMQKCpSxWTcOYlNTSvEyLSQgua7RtYwrh9eAhowNVm1+REmaRXJMjMyc2TD2Q==
X-Received: by 2002:a7b:c7c5:: with SMTP id z5mr13975669wmk.37.1570298692172;
        Sat, 05 Oct 2019 11:04:52 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b130sm6794086wmh.12.2019.10.05.11.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 09/10] net: genetlink: remove unused genl_family_attrbuf()
Date:   Sat,  5 Oct 2019 20:04:41 +0200
Message-Id: <20191005180442.11788-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005180442.11788-1-jiri@resnulli.us>
References: <20191005180442.11788-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

genl_family_attrbuf() function is no longer used by anyone, so remove it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/genetlink.h |  2 --
 net/netlink/genetlink.c | 19 -------------------
 2 files changed, 21 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 922dcc9348b1..74950663bb00 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -75,8 +75,6 @@ struct genl_family {
 	struct module		*module;
 };
 
-struct nlattr **genl_family_attrbuf(const struct genl_family *family);
-
 /**
  * struct genl_info - receiving information
  * @snd_seq: sending sequence number
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 8059118ee5a1..1b5046436765 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1164,25 +1164,6 @@ static int __init genl_init(void)
 
 subsys_initcall(genl_init);
 
-/**
- * genl_family_attrbuf - return family's attrbuf
- * @family: the family
- *
- * Return the family's attrbuf, while validating that it's
- * actually valid to access it.
- *
- * You cannot use this function with a family that has parallel_ops
- * and you can only use it within (pre/post) doit/dumpit callbacks.
- */
-struct nlattr **genl_family_attrbuf(const struct genl_family *family)
-{
-	if (!WARN_ON(family->parallel_ops))
-		lockdep_assert_held(&genl_mutex);
-
-	return family->attrbuf;
-}
-EXPORT_SYMBOL(genl_family_attrbuf);
-
 static int genlmsg_mcast(struct sk_buff *skb, u32 portid, unsigned long group,
 			 gfp_t flags)
 {
-- 
2.21.0

