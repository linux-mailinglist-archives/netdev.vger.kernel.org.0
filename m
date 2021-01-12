Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296652F2C05
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389718AbhALJ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:57:14 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:51046 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389319AbhALJ5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:57:14 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d28 with ME
        id Flv22400R3PnFJp03lvPlH; Tue, 12 Jan 2021 10:55:30 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Tue, 12 Jan 2021 10:55:30 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 0/1] Add software TX timestamps to the CAN devices
Date:   Tue, 12 Jan 2021 18:54:36 +0900
Message-Id: <20210112095437.6488-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the ongoing work to add BQL to Socket CAN, I figured out that it
would be nice to have an easy way to mesure the latency.

And one easy way to do so it to check the round trip time of the
packet by doing the difference between the software rx timestamp and
the software tx timestamp.

rx timestamps are already available. This patch gives the missing
piece: add a tx software timestamp feature to the CAN devices.

Of course, the tx software timestamp might also be used for other
purposes such as performance measurements of the different queuing
disciplines (e.g. by checking the difference between the kernel tx
software timestamp and the userland tx software timestamp).

v2 was a mistake, please ignore it (fogot to do git add, changes were
not reflected...)

v3 reflects the comments that Jeroen made in
https://lkml.org/lkml/2021/1/10/54

v4 rebases the patch on linux-can-next/testing and suppress the
comment related to SOF_TIMESTAMPING_TX_HARDWARE.
Reference: https://lore.kernel.org/linux-can/20210111171152.GB11715@hoboy.vegasvil.org/

Vincent Mailhol (1):
  can: dev: add software tx timestamps

 drivers/net/can/dev/skb.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.26.2

