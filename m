Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09A1287851
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbgJHPxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730397AbgJHPxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A76C0613D3;
        Thu,  8 Oct 2020 08:53:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y14so4625770pgf.12;
        Thu, 08 Oct 2020 08:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nizx9awJc0GxmiEBN3pjjPgXJluDxmsFWKBl+4zUxKs=;
        b=WY+vXONkEL0vJJAYDkKo4xVi1cdhMlVVMh0xIE77/EcCLsu+gGi++h6z7NtsqOPpkq
         dLLCDmvXVKBQMKaqxerKL1ql5s5WHABr59Nd66K5H5y3GbcISW/++zCNO6p0nFpRJOza
         Hi/phhr0buSgmJFvFjFitLFyVFjqSp0XdL6wXhsV117MUsd3B99UMLvNzBzG3oYdivMX
         QpAQt28RosXTP/oTm9juROmtgakaSdrHgZpuiWAcfLWkRLaeV7MDPlUNZBjKukEc2ApP
         znOM5Qod/tYl1gQb0A/FDEY6XXzxi/f/Rd+2gZI8efx7BvXlgp7Akvh3oIMH5f+bG5aA
         GG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Nizx9awJc0GxmiEBN3pjjPgXJluDxmsFWKBl+4zUxKs=;
        b=L/1+uGSFMIsRq7jAvp9EI/gErn+x0JUoAGoI1babAlUc278nHbwCt3bB6KgBM+k4bp
         FHqwBbFTpAt6aLjMKFNoIh4hUFYOk+M1tzrBuFVrzFfY6WQ4ykwXOKMVTaUaRBeGXRie
         sngP41ExboW/mkPdnBjNpku1ztKXztNzHY4uMrOX9bntOZ/bBslqV+x/u+u/qFhWYj/b
         0GeklmcEUJaD1CKORTuvD3KcyBHM17bvrpOrRKj7W/I72s/aGcD8sVIRbiKhEu5VW9iG
         0dpAfM8kQ0vlbjcp99TDY1lPVtCNcI2I6/eABXGxDotmXweQM4QMdZhhqlOmggUhXTxq
         vZOg==
X-Gm-Message-State: AOAM5307hS0L/XjNyynr+vRQ0C9xOYsIEFvXlQLzCiPkrukO1qpxCxJE
        NQv1U5JcwJloNctyDqZgLX+hDUNNhBA=
X-Google-Smtp-Source: ABdhPJx5Dxv6ApPs/7jnOjka/Jf0vEh2yTgWBHtZBBnFAl/lRPLw82MjRX+nNhJiWZfoduHgGBrZyQ==
X-Received: by 2002:a65:5b48:: with SMTP id y8mr7694395pgr.67.1602172403731;
        Thu, 08 Oct 2020 08:53:23 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:22 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 020/117] batman-adv: set batadv_log_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:32 +0000
Message-Id: <20201008155209.18025-20-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 9e466250ede3 ("batman-adv: Prefix bat_debugfs local static functions with batadv_")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/batman-adv/log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/log.c b/net/batman-adv/log.c
index a67b2b091447..5f887bca2549 100644
--- a/net/batman-adv/log.c
+++ b/net/batman-adv/log.c
@@ -180,6 +180,7 @@ static const struct file_operations batadv_log_fops = {
 	.read           = batadv_log_read,
 	.poll           = batadv_log_poll,
 	.llseek         = no_llseek,
+	.owner		= THIS_MODULE,
 };
 
 /**
-- 
2.17.1

