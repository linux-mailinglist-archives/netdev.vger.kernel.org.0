Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF5A356439
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 08:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349001AbhDGGmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 02:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhDGGmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 02:42:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45F9C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 23:42:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so774957pjv.1
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 23:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a52QycfeDfp+y7kVMROgePX6ilC1GDQEUPOD9zzL9NE=;
        b=VxPWKgIYw14VxNeKuxLuQUcpLiObunLFFBSZsvsR8gxaaJCfWWe6ZNdbI8npJwJ+3Y
         Tz6dPJ6efS9KOmN+Wo0K4fLerQdy64+7CBT7ppf7gvH3lXC+CT2JxbHl7FHgO6nvN3l9
         lkfqCiUD11XPlNZJ3cnGmmAWzPORkVs4CUTukWplmNLKBwIZycpfhov/ncfTbedOEhiK
         0pDQoAv5RaQ7koGi3qCko/8PiEq/qGzsL/W/WMW4VUYyqB1UfxiBIeXPayGgoo4dEopF
         C50LcC4l1BcKJyzv8NHKGM8JUSjlhkic3THiK7408E2dzVWpdlGrqZQ8HCCffsM3qg9B
         KsBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a52QycfeDfp+y7kVMROgePX6ilC1GDQEUPOD9zzL9NE=;
        b=H88XGompa2ecr6Ickcc5IJz09NCpK2ZScfUfKNPP9hf2xp6icoH+Ah4jWlNVRpaWKo
         tiC4MeV+Fq+8B3JM6o7t8uWPDpKLWLCoB/01j3yYaaiw01eyqcOrNJlWGZR/F/rx8vkg
         yw6kpB4Ea+KDW/rCd1mmdPmVfr9t/DP3ZL/adFTALLHn519OqSFQ7eAgzc6AcLecTKoF
         SXlcxpFAicONG0VjnRudlTr/Cgp0+Txhaw0AMNr7PW1tSqbJF7ws5ZU+Hc10xD8D/eYM
         VgijUMf+ETPCD6xj5kXd/8FVRgb4bte9iYUgS41EPhic+10lIDrHncAphtceSdcDdwuL
         GiEQ==
X-Gm-Message-State: AOAM531ib+2nWZKmwj+QEFN2wIKcFAXS/GK9dzpMxRhOGDfLJYJB0P1N
        jlgBcbEStz56IsOhOG3LuIs=
X-Google-Smtp-Source: ABdhPJx1Vp0R81CCpdAC2+i5oG12qOcT717ot8X6GcpKfiuAAE5zhz9fEfmC1pagbOWu3I9oJGF5Jg==
X-Received: by 2002:a17:902:8303:b029:e6:4ef3:4f17 with SMTP id bd3-20020a1709028303b02900e64ef34f17mr1774264plb.22.1617777753027;
        Tue, 06 Apr 2021 23:42:33 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id x18sm3803108pfi.105.2021.04.06.23.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 23:42:32 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrei Vagin <avagin@gmail.com>
Subject: [PATCH net-next] net: introduce nla_policy for IFLA_NEW_IFINDEX
Date:   Tue,  6 Apr 2021 23:40:03 -0700
Message-Id: <20210407064003.248047-1-avagin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this case, we don't need to check that new_ifindex is positive in
validate_linkmsg.

Fixes: eeb85a14ee34 ("net: Allow to specify ifindex when device is moved to another namespace")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---
 net/core/rtnetlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d51252afde0a..9108a7e6c0c0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1877,6 +1877,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 				    .len = ALTIFNAMSIZ - 1 },
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
+	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2266,9 +2267,6 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
 			return -EINVAL;
 	}
 
-	if (tb[IFLA_NEW_IFINDEX] && nla_get_s32(tb[IFLA_NEW_IFINDEX]) <= 0)
-		return -EINVAL;
-
 	if (tb[IFLA_AF_SPEC]) {
 		struct nlattr *af;
 		int rem, err;
-- 
2.29.2

