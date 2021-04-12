Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A527135B7B6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbhDLASe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:18:34 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:60266 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235229AbhDLASd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:18:33 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id E5FF0E9;
        Sun, 11 Apr 2021 17:18:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com E5FF0E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618186696;
        bh=Wl6nThl4cAl2Ut/o/0DQKhTyLLTbqv72Ran1PHsf+oQ=;
        h=From:To:Cc:Subject:Date:From;
        b=I0JTUFn4LfcrMVUjbH14TViYWI4YXVnQGZv92U4QYrIkjt2DWCZ59QxQq7NbbNDT0
         2VNhVx332lVygoGTyNgCSgRmF+utszhP0+l6BVsBN0f3ToRDBi96C0AsuleWlutDlz
         /jrQd1WEjg8lg9rH7pyFcc0Yt6YtBARh6L+iIdf4=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 0/5] bnxt_en: Error recovery fixes.
Date:   Sun, 11 Apr 2021 20:18:10 -0400
Message-Id: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes and enhancements to the error recovery
logic.  The health register logic is improved and we also add missing
code to free and re-create VF representors in the firmware after
error recovery.

Michael Chan (2):
  bnxt_en: Treat health register value 0 as valid in
    bnxt_try_reover_fw().
  bnxt_en: Refactor __bnxt_vf_reps_destroy().

Sriharsha Basavapatna (2):
  bnxt_en: Refactor bnxt_vf_reps_create().
  bnxt_en: Free and allocate VF-Reps during error recovery.

Vasundhara Volam (1):
  bnxt_en: Invalidate health register mapping at the end of probe.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 122 ++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h |  12 ++
 3 files changed, 115 insertions(+), 27 deletions(-)

-- 
2.18.1

