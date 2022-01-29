Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633244A316C
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 19:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352996AbiA2Spx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 13:45:53 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:55492 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346259AbiA2Spt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 13:45:49 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru F3E81209A0E8
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH net-next] sh_eth: kill useless initializers in
 sh_eth_{suspend|resume}()
Organization: Open Mobile Platform
Message-ID: <f09d7c64-4a2b-6973-09a4-10d759ed0df4@omp.ru>
Date:   Sat, 29 Jan 2022 21:45:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sh_eth_{suspend|resume}() initialize their local variable 'ret' to 0 but
this value is never really used, thus we can kill those intializers...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
This patch is against DaveM's 'net-next.git' repo.

 drivers/net/ethernet/renesas/sh_eth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net-next/drivers/net/ethernet/renesas/sh_eth.c
@@ -3464,7 +3464,7 @@ static int sh_eth_suspend(struct device
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct sh_eth_private *mdp = netdev_priv(ndev);
-	int ret = 0;
+	int ret;
 
 	if (!netif_running(ndev))
 		return 0;
@@ -3483,7 +3483,7 @@ static int sh_eth_resume(struct device *
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct sh_eth_private *mdp = netdev_priv(ndev);
-	int ret = 0;
+	int ret;
 
 	if (!netif_running(ndev))
 		return 0;
