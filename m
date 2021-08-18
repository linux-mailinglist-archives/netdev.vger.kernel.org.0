Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF23EFBBE
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbhHRGPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbhHRGPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:15:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04B7C0617AD
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso4602054pjb.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qcRMFUHVF6QqGnr97K+ATth5rLyNBKP5psUqyaewiPQ=;
        b=a6bTyF6xsvXmJVaSI8AKs77+P0oFTI1gTPlsYa6mh59pACM92P1VFzFqvqU9+X+jNr
         vTM9CS3vOAuRCBsVzn6N7KgVHI6W6ooLD8DmaYQuGxrolCI4Xru2kAG7C7jmtZ5uZ8PR
         VDy1iToF9Tpap2g7DTRp0rqJ6lJwmpqW0wJjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qcRMFUHVF6QqGnr97K+ATth5rLyNBKP5psUqyaewiPQ=;
        b=Jlb7XQVY7820H1zJXLbOc8TGq4PEcA+DHKF5GPMGTq00Kwzdr24Lirym9X3cgJ1Ijv
         UyOIbO3V+8h8KkqwnNTBMq1MLTDUYx7ifyPQifKbHf1Tf3hEC7CIzXC3fe0+ej/vdiVf
         28pbpPefZrw4V5nt2xoYkSmIWuijQxcYovX5p0ollC9N8YpRoFdLI83vQo+OtjE/KTAz
         0+U+bEHGWAsIGJPVnianNTBSpO7fhRzlcAaHRNrY0facySUu4/XgT2nwz0ufnqpbl022
         e9uhW4gAXuNRiRLT0gIpOUBzjwrCHN5vOSuInbUBO9MCfXXe1SkBYl8I+gTWUFop40dd
         rS2w==
X-Gm-Message-State: AOAM530mbaD66flB4Dvls8YQ48fmsN6lj7NvgAji57WInToffBZ23YFM
        pOIk6b0hawI/OULOzIJeyt8Big==
X-Google-Smtp-Source: ABdhPJxYy9uajyke8AmxVdXcCpVPxEVIqn6teRhyhxiibQmTAmVANSe3Um2YhA94u6j4OQrmXZTUYg==
X-Received: by 2002:a17:902:e9c6:b029:12d:4cb3:3985 with SMTP id 6-20020a170902e9c6b029012d4cb33985mr5959378plk.56.1629267253269;
        Tue, 17 Aug 2021 23:14:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l12sm5631661pgc.41.2021.08.17.23.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:12 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 61/63] powerpc: Split memset() to avoid multi-field overflow
Date:   Tue, 17 Aug 2021 23:05:31 -0700
Message-Id: <20210818060533.3569517-62-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1360; h=from:subject; bh=JCECg/Hewr4d9JO4WQR5kDd0IjByC1o9V4GNPJaYPKM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMrEHk87hiQVCzgI18EL/HOEsDc4MJhIkHkaVTZ DZKWkUOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKwAKCRCJcvTf3G3AJjKnD/ 9vO5rK1NcyiJFD1V1xX5Q3QwJPN1EMRWYcJsr5dTRrhYDef2VBoAd3vGVJhv5tPWCziVR95zI+LgIL d02IU4Ow0Hf/RnPFBOD9Lk1pR4bdZqy2udFH1tE06S0wBxz6HBgDxKiHg0hd49XAZs+xsJCSVXM+ks ZJe+gXBJkwU0QQlyx97a3srOeF6TBCIwRbfsc1ny8kqeq7rHXhuez2Nl/jEpDrSY7P6MGZ0RS9pwGp BG8XE5jwyatTqBbwztRYJO6EDxF1oljeN+vw6wXSMzHTs0P0jZF+xhBsDePue4SrU1uYVK4eI314VF ytJTqzumiq1LoMoetRo7XbnZL9HC+8KQkD7iex+cbwbl0vBuTQNERQCXbWiuHcR7WbrVndhdzqr/qr 7kpYWqqHhGYN42VOTCoEV+CxxyGt6O1oEwupEs9JwlhAHT0ET/3m5v95ln9sj4q/idsJQyugW9w9wS B+pdNyiwZvnrIR6r8PjnSHwflJuJYyRkP28Ci+HZxNLOE9WlE6UmnuDmdrcVKpWz+nctnlPQ9JHhAq vpfGhXMnm0qF1zx5IYh+d69+ZRtUQbUKz2k4hFKSxvSse3CvWfi63pBT3m1O556umLnQD6zZbq4vQZ p0vLhJOR+anh57gwE1CG5ilwh9jU07xLpPrNzUQkHrIgJsiMsfqPJrC73E9g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Instead of writing across a field boundary with memset(), move the call
to just the array, and an explicit zeroing of the prior field.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Qinglang Miao <miaoqinglang@huawei.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Wang Wensheng <wangwensheng4@huawei.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/lkml/87czqsnmw9.fsf@mpe.ellerman.id.au
---
 drivers/macintosh/smu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index 94fb63a7b357..59ce431da7ef 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -848,7 +848,8 @@ int smu_queue_i2c(struct smu_i2c_cmd *cmd)
 	cmd->read = cmd->info.devaddr & 0x01;
 	switch(cmd->info.type) {
 	case SMU_I2C_TRANSFER_SIMPLE:
-		memset(&cmd->info.sublen, 0, 4);
+		cmd->info.sublen = 0;
+		memset(&cmd->info.subaddr, 0, 3);
 		break;
 	case SMU_I2C_TRANSFER_COMBINED:
 		cmd->info.devaddr &= 0xfe;
-- 
2.30.2

