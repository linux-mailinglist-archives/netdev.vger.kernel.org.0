Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795293EED73
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbhHQN3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240017AbhHQN3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36663C061764;
        Tue, 17 Aug 2021 06:28:49 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e15so24854085plh.8;
        Tue, 17 Aug 2021 06:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AT62RXHqJfKbcR6X3TeYMegXESMAuTVW1E7jSVe5RPc=;
        b=M0F4EnGaCWxzEipOM7PvsbKgNcLsxd5xsxwy4td6PJIBoNrztJBj6Q1MCtafYVUvPa
         VpYyyOWsFNU5g/DZdyEB6IssLuzIgbrKoqGbuTiVK2EETR//7JGs7YFAD4/yOJ9gh6dm
         JSRmeo0FnoP6n3HlHWq8+hSaSVlwC05JI28bjrRCBZjJjQRXavTyUL89ZUWI0JDGoA9g
         CR7JgwqVeQBPN4yJ1MK3vS6kmdwjxlnUKAwJyhSvO37jvpk3UFaN6bHOAweCHNswtfQm
         XTy7UtfFSmm21xs0SfE0Qe4LG4M9ru/nZTmJFyrNBVZ3O4oVpTdZlVtxR9ZY3NhI778B
         97Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AT62RXHqJfKbcR6X3TeYMegXESMAuTVW1E7jSVe5RPc=;
        b=A+E9DKudd3UwRbzYlaivG5xj5FxbfLeVt+yLmmrrgiXtt7ZwRl/ne2joDO6xm9PvKZ
         QsQjuDmJs4hGqSXS+/t0/cw7pAnba/gx7Xb7MAdozy5hjwaFuSBihyab9y/aflC0MM2b
         ngSR9ccy63asIHZzpIYdMeWAuhCIz1SipEH780ITSh1Q/3QdhyhyUCSGnQuqSnKRC1s8
         v9BzysD2Wy9ab6jhxOsAJFydU8lZ/Ih+JqE/QKgRkpUvKs3dUJgzo6HaGt97OUFxor1R
         L6r+GR2ER2sMkC3AuvWPObsyicManpTBeeVuLHAco2WctCoDiAMqaqVhpXRwTCmebSyN
         6S2w==
X-Gm-Message-State: AOAM533jhro6wPcReRUofJ7lyLzaUe2Thn13UjYfzwI7sadoe0y2byDP
        oPblmAZilxXHojEu/0xrDDw=
X-Google-Smtp-Source: ABdhPJxPCbvC1yl1vWldfcDvuPZmdNEkGKZNQ2wxGEqc0KqwMjzx01N0FXE00uemKimYyFzz5dwOZw==
X-Received: by 2002:a05:6a00:248a:b029:3e0:9be4:963f with SMTP id c10-20020a056a00248ab02903e09be4963fmr3738393pfv.29.1629206928812;
        Tue, 17 Aug 2021 06:28:48 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:48 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 5/8] selftests: nci: Fix the wrong condition
Date:   Tue, 17 Aug 2021 06:28:15 -0700
Message-Id: <20210817132818.8275-6-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

memcpy should be executed only in case nla_len's value is greater than 0.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index cf47505a6b35..a1786cef73bc 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -110,7 +110,7 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 		na->nla_type = nla_type[cnt];
 		na->nla_len = nla_len[cnt] + NLA_HDRLEN;
 
-		if (nla_len > 0)
+		if (nla_len[cnt] > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
 		prv_len = NLA_ALIGN(nla_len[cnt]) + NLA_HDRLEN;
-- 
2.32.0

