Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71B227D8AE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgI2UgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:36:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49174 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgI2Ufz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:35:55 -0400
Message-Id: <20200929203500.675706419@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=DMPTCCaBsiS/4xahmtxtf/uVQ4ddpwEhLX/qD7/JBWU=;
        b=h2OUx/XlVZ4Z35Rj+pvIpshipqwoK40wQ89KyKxeF4ya9XeIMB0j3rZxunF237sg+8h2DN
        qS+BG1tGqWtCl6QG9X7XRXQ8jpIaW9pbBaZ9shAjht11QpoQIrf5gttLChLh2bUqxuXtQo
        hHiXrbqGbBcwFUGmMsSYU02ZU9+XBapeWcnKbCK5WgboaUgJfx2MI5ebOsIpxuciTGBstJ
        9xtdxiBP2ZCdZ4tD9sEenQJwri+Ygee6K7c57EcR9DuEr541RqodDbiXbPjdvbn8L9/bR/
        fZE6ArqG6pG/rl8E8Uz5qlR0AO96g7/2FV0n+fVHzkz60ORAns644ebeA7SKyQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=DMPTCCaBsiS/4xahmtxtf/uVQ4ddpwEhLX/qD7/JBWU=;
        b=Lwhz4b57yzj5XJOSuBaw/4kkL6sUSqxL5Ln27+2v/4Oj6s51o7T50veSK1FO3iJrapr/yw
        qTKgCLmwqmbZweAg==
Date:   Tue, 29 Sep 2020 22:25:21 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch V2 12/36] net: ionic: Remove WARN_ON(in_interrupt()).
References: <20200929202509.673358734@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

in_interrupt() is ill defined and does not provide what the name
suggests. The usage especially in driver code is deprecated and a tree wide
effort to clean up and consolidate the (ab)usage of in_interrupt() and
related checks is happening.

In this case the check covers only parts of the contexts in which these
functions cannot be called. It fails to detect preemption or interrupt
disabled invocations.

As the functions which are invoked from ionic_adminq_post() and
ionic_dev_cmd_wait() contain a broad variety of checks (always enabled or
debug option dependent) which cover all invalid conditions already, there
is no point in having inconsistent warnings in those drivers.

Just remove them.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Shannon Nelson <snelson@pensando.io>

---
 drivers/net/ethernet/pensando/ionic/ionic_main.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -255,8 +255,6 @@ static int ionic_adminq_post(struct ioni
 	struct ionic_queue *q;
 	int err = 0;
 
-	WARN_ON(in_interrupt());
-
 	if (!lif->adminqcq)
 		return -EIO;
 
@@ -328,8 +326,6 @@ int ionic_dev_cmd_wait(struct ionic *ion
 	int done;
 	int err;
 
-	WARN_ON(in_interrupt());
-
 	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
 	 * but don't wait any longer than max_seconds.
 	 */

