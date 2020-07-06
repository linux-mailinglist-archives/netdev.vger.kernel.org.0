Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A03121600A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgGFURi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgGFURc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:17:32 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FEFC08C5EE
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:17:31 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc9so10767374pjb.2
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0YvuOzcxzi1qx3Yg3gRUHTduA+Ml0/K1N0wS3w5e3M0=;
        b=IvslQ3GMETRVSlyR7uc2XGWdBRUDaHp8nLhukngoHUIUAlk+nolLb0psQdSMbbROgq
         nKWfK2kmOhnxZdKEiK6gu1Dt47URHz8L0MbxvTOaHrQljhqxSVKxn/Vw6P0YWh6AlO9B
         p31Jpeqxl9GTTzWyqJiyHW6Wuv5CjPr9a6uQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0YvuOzcxzi1qx3Yg3gRUHTduA+Ml0/K1N0wS3w5e3M0=;
        b=Fknj+t7GfYrmODW7T16gBqzv3dbxIpr7pK77HktyfNdsKGUGOWB4tZsWepRrA7ylO0
         YYDqv+KPHHaOPkcOcRyceqdCpODeGf8Pr+0JDz7FP+X+AIZ5jShjREov9sYGPQoibrhF
         LxK+gcSeRqGqH9YpYcQFdeZG/K6BLaLQgMhwLRvHolToMal667ca9JBlcTdM8xcbnpQH
         VT5E5DSQoVYUdCJTnwC257CTSlwH5zivGMJX/yEPS1Q4o88MUuaHPHgEcFLLq4Vpk5WO
         f+dwJZBfVOHrW6fPpxo9K+8GZGGz5+FSYfXyXzLQiBbtWyefrd1kWAHiMydRfH88LUC2
         eNZw==
X-Gm-Message-State: AOAM532GZf7ltacoutTlsb0eaFMHkISJAjb3Lcmgn9fk1SqnIcNmDtYP
        8avyZ3CR7giTm9VcnD4zFB0jAA==
X-Google-Smtp-Source: ABdhPJxcSeJ1fTMDQCDnUvgThUlNKIXnFBIxsUbi4LO/x7QgRdeVuEatuUoL/8p2qQmbyllSb6Lydw==
X-Received: by 2002:a17:90b:3612:: with SMTP id ml18mr801484pjb.193.1594066651340;
        Mon, 06 Jul 2020 13:17:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i21sm4498542pfa.18.2020.07.06.13.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:17:27 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v6 4/7] pidfd: Replace open-coded partial receive_fd()
Date:   Mon,  6 Jul 2020 13:17:17 -0700
Message-Id: <20200706201720.3482959-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706201720.3482959-1-keescook@chromium.org>
References: <20200706201720.3482959-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sock counting (sock_update_netprioidx() and sock_update_classid()) was
missing from pidfd's implementation of received fd installation. Replace
the open-coded version with a call to the new receive_fd()
helper.

Thanks to Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com> for
catching a missed fput() in an earlier version of this patch.

Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
Reviewed-by: Sargun Dhillon <sargun@sargun.me>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/pid.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index f1496b757162..a31c102f4c87 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -635,17 +635,8 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ret = security_file_receive(file);
-	if (ret) {
-		fput(file);
-		return ret;
-	}
-
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		fput(file);
-	else
-		fd_install(ret, file);
+	ret = receive_fd(file, O_CLOEXEC);
+	fput(file);
 
 	return ret;
 }
-- 
2.25.1

