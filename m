Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54F7401E00
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243777AbhIFQEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:04:44 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:40478 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239615AbhIFQEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 12:04:43 -0400
Received: from localhost.localdomain ([114.149.34.46])
        by mwinf5d79 with ME
        id qg3U2500Z0zjR6y03g3b31; Mon, 06 Sep 2021 18:03:37 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Mon, 06 Sep 2021 18:03:37 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 0/2] prevent incoherent can configuration in case of early return in the CAN netlink interface
Date:   Tue,  7 Sep 2021 01:03:08 +0900
Message-Id: <20210906160310.54831-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of two patch prevents, once for all, can_priv to be in an
inconsistent state in case of an early return in can_changelink() due
to invalid parameters.

* Changelog *

v2 -> v3:
  - Allocate the temporary struct can_priv on the heap instead of
    declaring it as static.
  - Split the patch into two to make it easier to backport to LTS
    kernels and add the "Fixes" tag.

v1 -> v2:
  - Change the prototype of can_calc_tdco() so that the changes are
    applied to the temporary priv instead of netdev_priv(dev).

Vincent Mailhol (2):
  can: netlink: prevent incoherent can configuration in case of early
    return
  can: bittiming: change can_calc_tdco()'s prototype to not directly
    modify priv

 drivers/net/can/dev/bittiming.c |  8 ++------
 drivers/net/can/dev/netlink.c   | 34 ++++++++++++++++++---------------
 include/linux/can/bittiming.h   |  7 +++++--
 3 files changed, 26 insertions(+), 23 deletions(-)

-- 
2.32.0

