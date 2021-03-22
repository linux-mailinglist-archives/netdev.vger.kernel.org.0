Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B133343A40
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhCVHJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:09:12 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:54898 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229870AbhCVHIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:08:47 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 178417DAE;
        Mon, 22 Mar 2021 00:08:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 178417DAE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1616396926;
        bh=+E8u7gT8j2N/spI0zlvfYgg0CIK5HyaXhyVlNHzizUc=;
        h=From:To:Cc:Subject:Date:From;
        b=ns0fDAKcsWd33KBi7+W4yWP5kSNJkPv50zkCcuwGJ1+fNv0DE4qrjkhS3r10BmtGq
         NGBCk/zAnORs1tOWD6Nk9Mj9tbHVL3hc3hoyYKu0qt0ejQyMBpkxviL/zB2/2CThW+
         gyi68D09gZG1dzzWXJJLCU39OjrfooA6euL920hk=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 0/7] bnxt_en: Error recovery improvements.
Date:   Mon, 22 Mar 2021 03:08:38 -0400
Message-Id: <1616396925-16596-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains some improvements for error recovery.  The main
changes are:

1. Keep better track of the health register mappings with the
"status_reliable" flag.

2. Don't wait for firmware responses if firmware is not healthy.

3. Better retry logic of the first firmware message.

4. Set the proper flag early to let the RDMA driver know that firmware
reset has been detected.

Edwin Peer (1):
  bnxt_en: don't fake firmware response success when PCI is disabled

Michael Chan (3):
  bnxt_en: Improve the status_reliable flag in bp->fw_health.
  bnxt_en: Set BNXT_STATE_FW_RESET_DET flag earlier for the RDMA driver.
  bnxt_en: Enhance retry of the first message to the firmware.

Pavan Chebbi (1):
  bnxt_en: Improve wait for firmware commands completion

Scott Branden (1):
  bnxt_en: check return value of bnxt_hwrm_func_resc_qcaps

Vasundhara Volam (1):
  bnxt_en: Remove the read of BNXT_FW_RESET_INPROG_REG after firmware
    reset.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 108 +++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |   9 ++
 2 files changed, 82 insertions(+), 35 deletions(-)

-- 
2.18.1

