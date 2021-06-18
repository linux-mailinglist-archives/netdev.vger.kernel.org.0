Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE023AC688
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhFRIzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:55:48 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:47269 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhFRIzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:55:47 -0400
Received: from localhost.localdomain ([114.149.34.46])
        by mwinf5d28 with ME
        id JYtR2500E0zjR6y03Ytabz; Fri, 18 Jun 2021 10:53:37 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 18 Jun 2021 10:53:37 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 0/4] iplink_can: cleaning, fixes and adding TDC support.
Date:   Fri, 18 Jun 2021 17:53:18 +0900
Message-Id: <20210618085322.147462-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose is to add commandline support for Transmitter Delay
Compensation (TDC) in iproute. Other issues found during the
development of this feature also get addressed.

This patch series contains four patches which respectively:
  1. Correct the bittiming ranges in the print_usage function.
  2. factorize the many print_*(PRINT_JSON, ...) and fprintf
  occurrences in a single print_*(PRINT_ANY, ...) call and fix the
  signedness while doing that.
  3. report the value of the bitrate prescalers (brp and dbrp).
  4. adds command line support for the TDC in iproute and goes together
  with below series in the kernel:
  https://lore.kernel.org/r/20210603151550.140727-3-mailhol.vincent@wanadoo.fr


** Changelog **

From RFC v1 to RFC v2:
  * Add an additional patch to the series to fix the issues reported
    by Stephen Hemminger
    Ref: https://lore.kernel.org/linux-can/20210506112007.1666738-1-mailhol.vincent@wanadoo.fr/T/#t

From RFC v2 to v3:
  * Dropped the RFC tag. Now that the kernel patch reach the testing
    branch, I am finaly ready.
  * Regression fix: configuring a link with only nominal bittiming
    returned -EOPNOTSUPP
  * Added two more patches to the series:
      - iplink_can: fix configuration ranges in print_usage()
      - iplink_can: print brp and dbrp bittiming variables
  * Other small fixes on formatting.

Vincent Mailhol (4):
  iplink_can: fix configuration ranges in print_usage()
  iplink_can: use PRINT_ANY to factorize code and fix signedness
  iplink_can: print brp and dbrp bittiming variables
  iplink_can: add new CAN FD bittiming parameters: Transmitter Delay
    Compensation (TDC)

 include/uapi/linux/can/netlink.h |  25 +-
 ip/iplink_can.c                  | 430 ++++++++++++++++---------------
 2 files changed, 247 insertions(+), 208 deletions(-)

-- 
2.31.1

