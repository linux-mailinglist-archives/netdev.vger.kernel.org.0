Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3751A27A42D
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 23:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgI0VKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 17:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgI0VKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 17:10:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61658C0613CE;
        Sun, 27 Sep 2020 14:10:53 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id c2so6658222ljj.12;
        Sun, 27 Sep 2020 14:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2KuV6+XVYpgAyH97z5t3iyYS7njb1gUmo+HUV52dlV4=;
        b=Q0VZh6MUNvFBVRSw56b5D2uueQpGTJw+Yc6Y4GMcg08gX71/xssuhTvc/D9JdlNgSF
         2T5wlFaFNENLNZiEa47OIdGIgBRq1RwWDCfcpL0V8pBP/RCozHSY+l5pvqxjtb4pyU9D
         jx3nqYel6DQ/FNBG5BYXyXS4W5ffQ9HUfe+xOw/YE5nSvtZsrkGLCaj5PAsaFqTtpH+X
         4A655JCroC2F/bDgCNhDtv/k6Rzxuyo8PHedaMa/L6Wgnr0NSAk21E3WO2I88fHRGuos
         cp5Xp5Ptqq65ECErRJX47jOImQ+su6IEPXZmi20Q7c6wgf7k0G0P/6w2/5NY0UyC1u+x
         wfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2KuV6+XVYpgAyH97z5t3iyYS7njb1gUmo+HUV52dlV4=;
        b=XbjHyClEbjDbWEnY1fzBQCPg4x2nsQ4H0WlLiC3PGmvke6jmRvYyTRUyY4vBSWzzvB
         Oo7E0RmRl3sxEVSp0H/i7KEGn5wwC2b/zBVsijAHpBxiagONIL1WfXMLJC5bSS3zk0bK
         TGWQ+1La6G26ZnEVcZ6Rv4F8DlRN0Cla4ac17myJZKc63y1+R0Z8UvFRk5FK/mkoWZEw
         n2HXkowLd/JEiPF0CTzZKqD56onKrzBU+TYLlN5qqzFtoUvLh3qkDyFXeAjndcRj8TH0
         Bi3blJDsa3d+u7uwkAJdjjRs34BEGhaOwnA7+tRKA4TMZd1QoH5wwCZ6lEWxfK4Msx1u
         ka+Q==
X-Gm-Message-State: AOAM5311biapl9R83Db2s73BSGgHArKENQXEbF+Rqdy3Fo7ICwzE7p4z
        OVy8YRNPMtvgGP4SYeUlZj8=
X-Google-Smtp-Source: ABdhPJwl/KfXdHKldPPWUm7BzjXMchIS8Wjeh1d/pWK2TbFgxiOBb/VrGqXOh251ks69wNstiDeW6w==
X-Received: by 2002:a05:651c:1203:: with SMTP id i3mr3928370lja.382.1601241051726;
        Sun, 27 Sep 2020 14:10:51 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id b137sm2546889lfd.105.2020.09.27.14.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 14:10:51 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Chas Williams <3chas3@gmail.com>
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH] atm: atmtcp: Constify atmtcp_v_dev_ops
Date:   Sun, 27 Sep 2020 23:10:42 +0200
Message-Id: <20200927211042.41875-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of atmtcp_v_dev_ops is to pass its address to
atm_dev_register() which takes a pointer to const, and comparing its
address to another address, which does not modify it. Make it const to
allow the compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/atm/atmtcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index 7f814da3c2d0..96bea1ab1ecc 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -327,7 +327,7 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
  */
 
 
-static struct atmdev_ops atmtcp_v_dev_ops = {
+static const struct atmdev_ops atmtcp_v_dev_ops = {
 	.dev_close	= atmtcp_v_dev_close,
 	.open		= atmtcp_v_open,
 	.close		= atmtcp_v_close,
-- 
2.28.0

