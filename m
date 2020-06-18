Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47C31FEFD6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 12:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgFRKoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 06:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgFRKoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 06:44:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8116C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 03:44:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y17so2272158plb.8
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 03:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VjtvW+j9qww+TrKx5c01GjE/qhlOn5+cmHcn8C2tFbg=;
        b=cNYODONqitcWijTAzqkWiT9kafBpFqG78LAeBWsv1nanOT/ZQq/mBCV0haPlYOHa7p
         6ksK+XC1G9sJblfNSkrWVGCIpSaasEgE4cBY6Dg2bCXhiUB9LSsre2npKFOr2+q0wT+i
         mTRbP26qkxOzfwgocsLE2yPfsOeyq4pUNzB6pbABKBTjHLh5yIKQczZIKVFLdCm6CBfE
         MivfXgrqwpIDzJWa4uGRTaG8YIFDYNA2yEAJov/mAgj7YXveKp6v3ldiijfGL5T5tkPp
         D1E4fcZQxwO+xufPTTe/X/JLzR2apX7Ua4GU/AL/UXd5gKVX1uq9nJ6x2BO8XV3n0ZtA
         wfLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VjtvW+j9qww+TrKx5c01GjE/qhlOn5+cmHcn8C2tFbg=;
        b=UfbWFisEWN/KtZPlzat0fUz4ex2ySKjUFF0wPgH9Fa2W/Ytza+aWjWzWKXdtIKGRrW
         vE6Ysvc4WSCmc9GDI7up0ikwEWMgZoDcb5PtpEpE9NL5nrKBo+sRN91GYrK+gKXO6b2s
         ML+larxqdZx/zSuZowzsdrw8iIroSLFjv8f1xDmSnS8jXZZAnVkth+JsT6DN6AY7HoCJ
         odglbrDgp0PPaIfFbXURCjDIZ/6v6ajQUavX06nQpi2xqXDvnqzM2cyQ2UZl3rR5yfo2
         YwpmcOfjayhdZUJcWDkEvGGsr2YU4vrzFkaBEEoEfgxbI0hl6nKoLGBwJ/HNgjE4wfuc
         psHg==
X-Gm-Message-State: AOAM5318lkJoGyOIglisHiXpeVbjX1J85hC6N66ModAvzZdGJf24t1OO
        bAv0c1VNvLA2Y3TtaIFTkdtnxAiWVGU=
X-Google-Smtp-Source: ABdhPJzBiW20OJKXjNodaZkXlIZKWnQUJJVFcUz4pbrF6+oxj5geYb05eAUTVpgzyoPaDM2tl8w+4Q==
X-Received: by 2002:a17:90a:2270:: with SMTP id c103mr3388580pje.184.1592477078174;
        Thu, 18 Jun 2020 03:44:38 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 125sm2479453pff.130.2020.06.18.03.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 03:44:37 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>, lucien.xin@gmail.com,
        Simon Horman <simon.horman@netronome.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2] tc: m_tunnel_key: fix geneve opt output
Date:   Thu, 18 Jun 2020 18:44:20 +0800
Message-Id: <20200618104420.499155-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f72c3ad00f3b changed the geneve option output from "geneve_opt"
to "geneve_opts", which may break the program compatibility. Reset
it back to geneve_opt.

Fixes: f72c3ad00f3b ("tc: m_tunnel_key: add options support for vxlan")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tc/m_tunnel_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index bfec9072..0074f744 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -534,7 +534,7 @@ static void tunnel_key_print_geneve_options(struct rtattr *attr)
 	struct rtattr *i = RTA_DATA(attr);
 	int ii, data_len = 0, offset = 0;
 	int rem = RTA_PAYLOAD(attr);
-	char *name = "geneve_opts";
+	char *name = "geneve_opt";
 	char strbuf[rem * 2 + 1];
 	char data[rem * 2 + 1];
 	uint8_t data_r[rem];
-- 
2.25.4

