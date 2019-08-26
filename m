Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618A99CB8A
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbfHZIab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:30:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44459 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729328AbfHZIaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:30:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id c81so11311906pfc.11;
        Mon, 26 Aug 2019 01:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qTa8eNrO49tqgyJ9XtxBA5XR2KSXB+uun87G3Dibzuc=;
        b=SvLElDuOEzf2H4hE18Dq2ZW9n9PngHAQM0/yByazQqRPV9EvsJtdW6awdg3k82BXyj
         LFDdqQw9CYJNFhTJZTFq9hZdZc243ioeHiaI+4l+aUrLLf9X1gt4JGpD/aYgXUm27eEA
         RrlmW32SO7mhQhNYMY7FwrOtZyf4eoXh0xndR+NvR1WAAMDcoO0pyoexbGGyibr2tjRG
         kjybjXi81oEgtkCFGknboog2LhFNs5S9fmtT3x81YSG/NOlBAt7g0vtfh02IJqnUXOU+
         iCrBgvC1ENvR8XNLXRyJNzKP8d689P96h4u9ys/Wens/60u2LSaSeXDfrZjCSxENbAxO
         G6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qTa8eNrO49tqgyJ9XtxBA5XR2KSXB+uun87G3Dibzuc=;
        b=iU6YHtnWqeoTXdsRhOVHYUlsCTy1V0tqkwvVG2xp9V5H5Enr3f73/69jhQMvCnk81b
         +qkTkq9+McYJn1ILYqyS8TCBb//WeqtTwl1/fe98Rr1esSSiRBQca5OTpuuv/rg8M6Mc
         GfFg/O/zM5QWV7/3JuXsBcOP3+j4tR0kZ7/ny8c6KT9xZ4OkN2xGRiR7SZDDpPAd3wXH
         RwpvxClz+6F/gtndXfLk3PlJy5VSAByiv1xFy/S+/sLm/W/olgX0et8mQ2/J4LVkA5PY
         Wvro2cxIMPx+5JYwLs7fOqd3xnrn3jMiXj1S5pKjQdFtu57fibBHIDvX7cJGVGEMqzaa
         vrEQ==
X-Gm-Message-State: APjAAAXzRgV//MUDDAsihIXnn820a2Xju2jcse43P+s0YzY6vh7175iB
        /V9F/oExhKQQdY2a052eIqVT31eF0+M=
X-Google-Smtp-Source: APXvYqyZ+7Gl0LOgLJCkLPFaUqhhlYy+b+GknpYQoxBXecYZKATS+f0r0ZViMRzQGwC7b9EoLeY0jQ==
X-Received: by 2002:a63:1f1b:: with SMTP id f27mr15154325pgf.233.1566808229567;
        Mon, 26 Aug 2019 01:30:29 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k25sm13278900pgt.53.2019.08.26.01.30.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:30:28 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 2/3] sctp: allow users to set netns ecn flag with sysctl
Date:   Mon, 26 Aug 2019 16:30:03 +0800
Message-Id: <fdbf487b2e1b255b1bbf457b3112979c33b53066.1566807985.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
References: <cover.1566807985.git.lucien.xin@gmail.com>
 <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566807985.git.lucien.xin@gmail.com>
References: <cover.1566807985.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysctl net.sctp.ecn_enable is added in this patch. It will allow
users to change the default sctp ecn flag, net.sctp.ecn_enable.

This feature was also required on this thread:

  http://lkml.iu.edu/hypermail/linux/kernel/0812.1/01858.html

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sysctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 1250751..238cf17 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -278,6 +278,13 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "ecn_enable",
+		.data		= &init_net.sctp.ecn_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "addr_scope_policy",
 		.data		= &init_net.sctp.scope_policy,
 		.maxlen		= sizeof(int),
-- 
2.1.0

