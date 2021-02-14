Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C975831B325
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBNXFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:05:53 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45536 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229793AbhBNXFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:05:52 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id F296EE9;
        Sun, 14 Feb 2021 15:05:01 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com F296EE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343902;
        bh=wigpHtPUsBa0CqXE0MPEwwOdJmHr5J5fPdTQ123Zkmo=;
        h=From:To:Cc:Subject:Date:From;
        b=bxoSR8CW1CbvMmlRKs7D6N3GcAKP1jqIyZS2ARv+BBGAJ1yWddL7dfhD8IGDRUub/
         vZQPEOgn7VpqCRzY8CrTbWYfLs9mS2OQ0LzpVNBKOSGIBcCxW08w2oM6zm2defHULT
         i290HM6mYcP4UWHO5pWz7TXl5zGYbWcQbASmgPHY=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 0/7] bnxt_en: Error recovery optimizations.
Date:   Sun, 14 Feb 2021 18:04:54 -0500
Message-Id: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements some optimizations to error recovery.  One
patch adds an echo/reply mechanism with firmware to enhance error
detection.  The other patches speed up the recovery process by
polling config space earlier and to selectively initialize
context memory during re-initialization.

Edwin Peer (1):
  bnxt_en: selectively allocate context memories

Michael Chan (6):
  bnxt_en: Update firmware interface spec to 1.10.2.16.
  bnxt_en: Implement faster recovery for firmware fatal error.
  bnxt_en: Add context memory initialization infrastructure.
  bnxt_en: Initialize "context kind" field for context memory blocks.
  bnxt_en: Reply to firmware's echo request async message.
  bnxt_en: Improve logging of error recovery settings information.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 222 ++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  24 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 105 ++++++++-
 3 files changed, 290 insertions(+), 61 deletions(-)

-- 
2.18.1

