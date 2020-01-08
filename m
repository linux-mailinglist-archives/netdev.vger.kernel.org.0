Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A14134DCC
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgAHUmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:42:46 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46548 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgAHUmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:42:46 -0500
Received: by mail-lf1-f66.google.com with SMTP id f15so3450948lfl.13
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 12:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:organization:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2IiY4N4pReCFQeec/jXgRHTFsEHZAk7Hj3asNpqdl5I=;
        b=Ae+RtYeIdvcQS40lGc2auBeQbqMIubDNKl0YFadIU/8XDb9xdYaHUtlUU55JpPVLhR
         xwhbv9wpUneqT6+ENruV+qj6EvTiPLrH/Gel487bucNsLyXkBzJvK7icIDeVM/fSGeOl
         Prxph3JGTPxTwOOq9LVj79jD1CBKndrdWVJvQd1kE/bIeY5iFy261xRS/FRc/1JdorOM
         tkJEeOuTWKVn8m3bfoc9s/9zDVnqaTU2ZD5Boze7seoDtYtJ8IOdpHeLqC6vnToJ6LhL
         TOt10ftHYKBYe0HJ+Bw3GUVJd5IfUEWQ1IX+ntFeUurTAHtq5yQBvOUM7+JPV9WvqsPn
         EpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:organization:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=2IiY4N4pReCFQeec/jXgRHTFsEHZAk7Hj3asNpqdl5I=;
        b=IqPTPxIFh+xGkm8TBviCDEMgu98gFD7CKrCf62D4ulNn0KMwxLoe3SCJks5lLxkOfX
         uZVQlCxFqwsOKwWG+PXIi1v04ye0MsRuoG8cK0a5SM8nTYu8aFxYxVyXwkatgUrFTrp6
         m2eQ8DCcs6jKYMFse1zY5isFiY9RqwUQ8e4+BURhb1++z5b0Ul2BdYEwg8fCTeG29OAo
         jRy4WBfNxIP2Mh4D3jbNLH+kt/k3UPFHapoATy1g7uUL40YoDYoOJlS0eqxT2Aovjtz7
         aLBPC9g0NbRnko7NLtB0Og8tdzlzC4vgda9g63EiDls5L9MeQGreRma9DetX0ZQrRdC5
         /iNQ==
X-Gm-Message-State: APjAAAU2+Zjtd1Ynh41fFm2T5KgQgkFJWjwAbfSGTeooy3zOu4NTgUnS
        500fEeFyUzDcVDnrSRFUWHH/3w==
X-Google-Smtp-Source: APXvYqwRpRKPPx7IoeRjM4DhG4s8+U9E0kHHUO0hCavt0O2SVsCEl5tEaCxP5YwCqb/yJ0gBCDz8uw==
X-Received: by 2002:a05:6512:25c:: with SMTP id b28mr4077708lfo.184.1578516164782;
        Wed, 08 Jan 2020 12:42:44 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:825:468a:fc63:5f3d:481e:e931])
        by smtp.gmail.com with ESMTPSA id s3sm1954623lfo.77.2020.01.08.12.42.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 12:42:44 -0800 (PST)
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH net] sh_eth: check sh_eth_cpu_data::dual_port when dumping
 registers
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     linux-renesas-soc@vger.kernel.org, linux-sh@vger.kernel.org
Organization: Cogent Embedded
Message-ID: <5f03e777-6838-f70d-31bc-2046d253c11a@cogentembedded.com>
Date:   Wed, 8 Jan 2020 23:42:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding the sh_eth_cpu_data::dual_port flag I forgot to add the flag
checks to __sh_eth_get_regs(), causing the non-existing TSU registers to
be dumped by 'ethtool' on the single port Ether controllers having TSU...

Fixes: a94cf2a614f8 ("sh_eth: fix TSU init on SH7734/R8A7740")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against DaveM's 'net.git' repo.

There are 3 more alike patches that check the same kind of omissions but they
seem to be subject to the latter register offset sanity checking, so shouldn't
affect the register dumping...

 drivers/net/ethernet/renesas/sh_eth.c |   38 ++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

Index: net/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net/drivers/net/ethernet/renesas/sh_eth.c
@@ -2204,24 +2204,28 @@ static size_t __sh_eth_get_regs(struct n
 	if (cd->tsu) {
 		add_tsu_reg(ARSTR);
 		add_tsu_reg(TSU_CTRST);
-		add_tsu_reg(TSU_FWEN0);
-		add_tsu_reg(TSU_FWEN1);
-		add_tsu_reg(TSU_FCM);
-		add_tsu_reg(TSU_BSYSL0);
-		add_tsu_reg(TSU_BSYSL1);
-		add_tsu_reg(TSU_PRISL0);
-		add_tsu_reg(TSU_PRISL1);
-		add_tsu_reg(TSU_FWSL0);
-		add_tsu_reg(TSU_FWSL1);
+		if (cd->dual_port) {
+			add_tsu_reg(TSU_FWEN0);
+			add_tsu_reg(TSU_FWEN1);
+			add_tsu_reg(TSU_FCM);
+			add_tsu_reg(TSU_BSYSL0);
+			add_tsu_reg(TSU_BSYSL1);
+			add_tsu_reg(TSU_PRISL0);
+			add_tsu_reg(TSU_PRISL1);
+			add_tsu_reg(TSU_FWSL0);
+			add_tsu_reg(TSU_FWSL1);
+		}
 		add_tsu_reg(TSU_FWSLC);
-		add_tsu_reg(TSU_QTAGM0);
-		add_tsu_reg(TSU_QTAGM1);
-		add_tsu_reg(TSU_FWSR);
-		add_tsu_reg(TSU_FWINMK);
-		add_tsu_reg(TSU_ADQT0);
-		add_tsu_reg(TSU_ADQT1);
-		add_tsu_reg(TSU_VTAG0);
-		add_tsu_reg(TSU_VTAG1);
+		if (cd->dual_port) {
+			add_tsu_reg(TSU_QTAGM0);
+			add_tsu_reg(TSU_QTAGM1);
+			add_tsu_reg(TSU_FWSR);
+			add_tsu_reg(TSU_FWINMK);
+			add_tsu_reg(TSU_ADQT0);
+			add_tsu_reg(TSU_ADQT1);
+			add_tsu_reg(TSU_VTAG0);
+			add_tsu_reg(TSU_VTAG1);
+		}
 		add_tsu_reg(TSU_ADSBSY);
 		add_tsu_reg(TSU_TEN);
 		add_tsu_reg(TSU_POST1);
