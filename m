Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8A7454CC4
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbhKQSIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhKQSIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 13:08:35 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC736C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 10:05:36 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b1so12351146lfs.13
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 10:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1TNUeRSV28C4546JYqZZ3+s3ZlrbLQ+V2ngZt7JKxQk=;
        b=O0zgZshvrHpDawWrliHpXw1mtgSXydiIirTcrMlAj/41RKtKb8kxkogHmZe5nIyT1Y
         277ykJFF/bF/rCu1FnONX2t5mZSeyRVSlPak7UB2969eB8/yhykyyxU78V5A7j+0q35Z
         CbEkAPtLBwsykYB30UcYo3VlHkJmJvTa0egTN7k3Y7kBNdooZCbwh55ogHY1qmUcMjuw
         rZ1yvgx2EmMhygdjaaP1gzKixky8LeNvj/y1Z8wtLfkTR4ssY6c/QSnKWwDS4FzhAgej
         uKpkRwRk5Itzdklp7CKZKMV2HjHlNhRLaHD81avzJFgLUx7f3NnilfbpamtzCEr7mWQh
         IJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1TNUeRSV28C4546JYqZZ3+s3ZlrbLQ+V2ngZt7JKxQk=;
        b=Q98CNyxDHghPbucAv1TJ9QW5WhDfHFxCSU44KVrYtooO8UgTnU2o02AzHg6bu0WxD1
         m5PKbab8hDJDwG6Wj+VMCuH/nYCu01n73sOfcfKwv0aJazeDpTlph4WgkCdffnywhac+
         cJfhhOO3YNLfJfkh/7nDgQSNe/lKDhD92cUtSOhCCxNqe8pNoc0sMvbWtAaIL54Gb1uU
         2LZJYdN1gd/3skRkdcNZ5pdhwCUS4iWHKxs/WaJ3E5DReQWypEoiXl8ssqhPmTgzrOt/
         J0hMBn3iz3cOrV6P0ItQHLGp/S2fp1wB/h97U+cbooSYM1CSdoNlb+tWDLUMLQf0rYGX
         zlbA==
X-Gm-Message-State: AOAM531Bg7NXW5qLUyzWbsyuO05IJFvTMXSFXf+XegAFmDugkS76HiCB
        zfnPZMYoTtyyDyGy9qwzLvg=
X-Google-Smtp-Source: ABdhPJxjNcbj5NyaK5qr8qmAqPkal47A2fIMnk/Nn4PHInbTbfTOUu+TgBvdbcNXf5gAkhpWytoa8A==
X-Received: by 2002:a2e:b0c8:: with SMTP id g8mr9614291ljl.509.1637172334577;
        Wed, 17 Nov 2021 10:05:34 -0800 (PST)
Received: from [192.168.88.200] ([178.71.193.198])
        by smtp.gmail.com with ESMTPSA id d4sm46599lfa.294.2021.11.17.10.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 10:05:34 -0800 (PST)
To:     netdev@vger.kernel.org
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Subject: [PATCH iproute2] tc/m_vlan: fix print_vlan() conditional on
 TCA_VLAN_ACT_PUSH_ETH
Cc:     mmrmaximuzz@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>
Message-ID: <091bdc88-9386-288e-25ba-7d369ad9a6b5@gmail.com>
Date:   Wed, 17 Nov 2021 21:05:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the wild bracket in the if clause leading to the error in the condition.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
 tc/m_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 221083df..1b2b1d51 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -279,8 +279,8 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 				    ETH_ALEN, 0, b1, sizeof(b1));
 			print_string(PRINT_ANY, "dst_mac", " dst_mac %s", b1);
 		}
-		if (tb[TCA_VLAN_PUSH_ETH_SRC &&
-		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN]) {
+		if (tb[TCA_VLAN_PUSH_ETH_SRC] &&
+		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN) {
 			ll_addr_n2a(RTA_DATA(tb[TCA_VLAN_PUSH_ETH_SRC]),
 				    ETH_ALEN, 0, b1, sizeof(b1));
 			print_string(PRINT_ANY, "src_mac", " src_mac %s", b1);
-- 
2.25.1
