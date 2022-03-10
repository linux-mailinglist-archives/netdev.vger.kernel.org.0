Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465D14D5090
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245048AbiCJReJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245307AbiCJRdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:33:21 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7C32F5402;
        Thu, 10 Mar 2022 09:32:19 -0800 (PST)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6700120B7178;
        Thu, 10 Mar 2022 09:32:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6700120B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646933539;
        bh=rjWLUtjXMCjyslyq0fVUUUtRbPRDKlGeSrBa50NCzQQ=;
        h=From:To:Subject:Date:From;
        b=eP6W5vx30W5GhN1RTeXX3w9pg/i2T2iICF2reDJFTpBbjVcKFVZ3eoqqKHzgqul5u
         lyWSFSnwFvhbHrFTEyPTOLLwKuDNQtT99irif3OvLWfOTf1nvHCWgATy5hZnH59ZMv
         yUQUOqMzOxedrSWCyj2SilN98cO5JPkSfD/ZLxpo=
From:   Saurabh Sengar <ssengar@linux.microsoft.com>
To:     ssengar@microsoft.com, haiyangz@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        davem@davemloft.net, kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: netvsc: remove break after return
Date:   Thu, 10 Mar 2022 09:32:14 -0800
Message-Id: <1646933534-29493-1-git-send-email-ssengar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function netvsc_process_raw_pkt for VM_PKT_DATA_USING_XFER_PAGES
case there is already a 'return' statement which results 'break'
as dead code

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index e675d10..9442f75 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1630,7 +1630,6 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 
 	case VM_PKT_DATA_USING_XFER_PAGES:
 		return netvsc_receive(ndev, net_device, nvchan, desc);
-		break;
 
 	case VM_PKT_DATA_INBAND:
 		netvsc_receive_inband(ndev, net_device, desc);
-- 
1.8.3.1

