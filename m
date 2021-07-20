Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB353CF9DE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 14:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbhGTMHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:07:44 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:37622
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238360AbhGTMHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:07:38 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 665A4418F8;
        Tue, 20 Jul 2021 12:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626785295;
        bh=0ItI7io0GTWcShfB9OXndSkWcyxA3F74Ps+6kGgGN+g=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Wr7zJECXlIJa89fP1PUCdovg3nBJTNJJHJmTEzVJ/ds/vH+WmeGEOfTiwF2C9QSuH
         YDV3O+7+jpKKTVRxio39/vf0GQwXiyCjxXkQElA2myNiYpebcyvONf+1ug8MyKaKOB
         BNy5GejUy8gzYUJSwOwNA+Ap96VdNa/2us8cSlDMzTBn9xed4p4uwv9qT76SB9bZ8H
         kHE/QBgD/AQNcr9ZLHJHv9cHeOy5X3K29ufZ9v404NGPuIxXSTJA3uvMi3hCMlugr9
         2DzjWYliXm96SqiBZM4mnl8RhknXoX810ziFLKZ+7soNViKh2RX2fLfFlNoz93LDtl
         OdwHxza0lIdKw==
From:   Colin King <colin.king@canonical.com>
To:     Chas Williams <3chas3@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] atm: idt77252: clean up trigraph warning on ??) string
Date:   Tue, 20 Jul 2021 13:48:13 +0100
Message-Id: <20210720124813.59331-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The character sequence ??) is a trigraph and causes the following
clang warning:

drivers/atm/idt77252.c:3544:35: warning: trigraph ignored [-Wtrigraphs]

Clean this by replacing it with single ?.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/atm/idt77252.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 9e4bd751db79..81ce81a75fc6 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3536,7 +3536,7 @@ static int idt77252_preset(struct idt77252_dev *card)
 		return -1;
 	}
 	if (!(pci_command & PCI_COMMAND_IO)) {
-		printk("%s: PCI_COMMAND: %04x (???)\n",
+		printk("%s: PCI_COMMAND: %04x (?)\n",
 		       card->name, pci_command);
 		deinit_card(card);
 		return (-1);
-- 
2.31.1

