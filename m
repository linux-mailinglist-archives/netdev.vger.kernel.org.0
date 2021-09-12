Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A59C407E5B
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhILQDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbhILQDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:03:21 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67375C061767;
        Sun, 12 Sep 2021 09:02:01 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso9863720otp.1;
        Sun, 12 Sep 2021 09:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1/KmRngdTFmzo/UZtKn8rZGj6ovhn9EKtKsKEFMmxn8=;
        b=amNjEwmKkK+EAJ9qU3oqx/lS59tXH0W5/YF8YlPF3GV2qc12vsrXWzh7XtqybrGlAs
         o6pIua5w6eKY4OoNzk01slxP4ZKoUpwEix20mxfLDymqeV6qI2QXBDtCpG/j/Axk/5Hn
         SL/Y6srbyHVRRcSQMUrQJX1adW0ddv0klYEXAcmoYLpDRJ0YEwI7heQhBx5g0pmX2EI9
         a81hkcyl2X4pwumIopWL6c0I0MnYiRhIcqNy+fzEBpMbEWKPQmI90TT9YmHFZavmyr9s
         dNxNgJxkpemPqlCLDg+7wlA8W6T1DHqssu6DB6v754xvJKFfmGv/rH/iU1X1Jihdtho4
         kwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=1/KmRngdTFmzo/UZtKn8rZGj6ovhn9EKtKsKEFMmxn8=;
        b=D6q+IqESzyMygrR/qu31acOgBFOqoLxI6r3hK9kfhaHSPKgdw2TU7TN4rrahLwbjXc
         d4XpX940c/3LZfunW4RfDut8Ezewnn88FpkD1+suAKYfLS7nBparuyQMpfaMI3horVVS
         pPGgIc0iI9yzleIzKCgRHAuwv1b9G5W5CRXK4mI3S//ZSmDGHzPF0xcuxNUIvjy5DKWb
         uY7llCXUWxci4GtmABIurI6ZBO3B30+nC+gJBN4GW/kuRx3h10aYesG9XvdFYkREolR0
         dkAnT54A+iIIPpsrpAvpxjpmXcA5UDa9qeyk62h1JNdtX5ied4tlOgmWJCvII9fEg4Xh
         st3g==
X-Gm-Message-State: AOAM53020z7QC+bK5j/SgKOIfmYv7WWby4HOOaGQ7H9E3c0o+H+slTYs
        QrUgjD1sThUkEc/RCFp9Fsg=
X-Google-Smtp-Source: ABdhPJyHZowChSylgmGOCRZlO/Fx09vA0coF7aqUN5xcR70/VpKTCHElmrsr5xSOKIOtgEY5NKK4Ng==
X-Received: by 2002:a9d:7a4e:: with SMTP id z14mr6569712otm.366.1631462520789;
        Sun, 12 Sep 2021 09:02:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24sm1200792otp.37.2021.09.12.09.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 09:02:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-alpha@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, linux-sparse@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/4] parisc: Use absolute_pointer for memcmp on fixed memory location
Date:   Sun, 12 Sep 2021 09:01:48 -0700
Message-Id: <20210912160149.2227137-4-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210912160149.2227137-1-linux@roeck-us.net>
References: <20210912160149.2227137-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parisc:allmodconfig fails to build with the following error
when using gcc 11.x.

arch/parisc/kernel/setup.c: In function 'start_parisc':
arch/parisc/kernel/setup.c:389:28: error:
	'__builtin_memcmp_eq' specified bound 8 exceeds source size 0

Avoid the problem by using absolute_pointer() when providing a memory
address to memcmp().

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/parisc/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index cceb09855e03..4e13345b6581 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -384,7 +384,7 @@ void __init start_parisc(void)
 	struct pdc_coproc_cfg coproc_cfg;
 
 	/* check QEMU/SeaBIOS marker in PAGE0 */
-	running_on_qemu = (memcmp(&PAGE0->pad0, "SeaBIOS", 8) == 0);
+	running_on_qemu = (memcmp(absolute_pointer(&PAGE0->pad0), "SeaBIOS", 8) == 0);
 
 	cpunum = smp_processor_id();
 
-- 
2.33.0

