Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B8512FA3B
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgACQW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:22:26 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:34865 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgACQW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 11:22:26 -0500
Received: by mail-wr1-f48.google.com with SMTP id g17so42919136wro.2
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 08:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oF6knoEIXIh5/2ho9eTkMDQ7i4T1em2sODYcYmaIN5c=;
        b=DtYrm5MUavfkQB19MOkx+e5+C6/cUcDApFUtzA9WpER0cVl9741KQrWYWRUtX6n6Gs
         fFoxSyYEmQBKM1VecUnS5KUvtYBX/TeLISjUuwRuPFf/PC3MCNpPylQ0tY4D8EmDQbil
         GGP1ypD3cqATXzVXaH5cgIExNEKkc3p903rtk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oF6knoEIXIh5/2ho9eTkMDQ7i4T1em2sODYcYmaIN5c=;
        b=jjEboXW88k0qG4bruYkxRHjM4zQB9oWP0DuZJGVQw4u+rmAmuQNhFYx+b1//Q3TRz+
         MSb+ZFaBpp92mUDtDTt6aVKsqQKcK06py3bNUMurWxa0/0PpfEVkRc4bvI4lJfwHHhti
         /jFQVczZE0e4+9AlfgiZdnp5xlH4YoWkMgrTbX88SxkSOnkQ8krNIp9PZ5i+QjEtmDV1
         MvncTants/XZ047JRra5HTceHcvsH6g4Yq7kWLICy4Vy3olNL4Fxy2RDJ/TI4o0i+4PE
         pGtoEDgLJYN8S3MwJ4VEuI6DMaqX86sLSNkStrn1FzcZVgC6Z4A9v7STifhqlgoUSHZP
         AkZw==
X-Gm-Message-State: APjAAAWgy3Y/nYw0SpanSFsfgg6PCaL3cC4qt/p5HZco/D0SZsfhK/wM
        mC6F9QldYsGOlMdIbdj9E5Hrwg==
X-Google-Smtp-Source: APXvYqxvBE16IVnnlgPkedV5XAxfpmeejqjdDd74lI7Zi2q0EV/30uX7B9ylxWLNiSGHHHvtMdqAog==
X-Received: by 2002:a5d:6048:: with SMTP id j8mr88887949wrt.41.1578068544506;
        Fri, 03 Jan 2020 08:22:24 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id n8sm61348706wrx.42.2020.01.03.08.22.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Jan 2020 08:22:24 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>
Cc:     vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH INTERNAL v2] firmware: tee_bnxt: Reduce shm mem size to 4K
Date:   Fri,  3 Jan 2020 21:50:04 +0530
Message-Id: <1578068404-26195-2-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1578068404-26195-1-git-send-email-vikas.gupta@broadcom.com>
References: <1578068404-26195-1-git-send-email-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce shm memory size as maximum size supported by optee_shm_register
API is 4K.

Fixes: 246880958ac9 (“firmware: broadcom: add OP-TEE based BNXT f/w manager”)
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/firmware/broadcom/tee_bnxt_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
index 5b7ef89..8f0c61c6 100644
--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -12,7 +12,7 @@
 
 #include <linux/firmware/broadcom/tee_bnxt_fw.h>
 
-#define MAX_SHM_MEM_SZ	SZ_4M
+#define MAX_SHM_MEM_SZ	SZ_4K
 
 #define MAX_TEE_PARAM_ARRY_MEMB		4
 
-- 
2.7.4

