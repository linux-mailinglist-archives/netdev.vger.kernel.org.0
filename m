Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4E420019
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 07:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhJCFEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 01:04:32 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:52931 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhJCFEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 01:04:31 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id WtdMmhDZXsoWhWte5m9Qay; Sun, 03 Oct 2021 07:02:43 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 03 Oct 2021 07:02:43 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v1 0/3] iproute2-next: iplink_can: report the controller capabilities
Date:   Sun,  3 Oct 2021 14:01:44 +0900
Message-Id: <20211003050147.569044-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series serve one purpose: allow the user to check both the
supported and the static capabilities.

Currently, the CAN netlink interface provides no easy ways to check
the capabilities of a given controller. The only method from the
command line is to try each CAN_CTRLMODE_ individually to check
whether the netlink interface returns an -EOPNOTSUPP error or not
(alternatively, one may find it easier to directly check the source
code of the driver instead...)

Here, we introduce a way to directly report the supported features as
well as the statically enabled features.

The first patch of the series only does some clean up. The second
patch is the real thing. The last patch contains the needed
modification to the uapi headers and is only there for convenience.

Vincent Mailhol (3):
  iplink_can: code refactoring of print_ctrlmode()
  iplink_can: add ctrlmode_{supported,_static} to the "--details --json"
    output
  uapi: can: netlink: add new field to struct can_ctrlmode to report
    capabilities

 include/uapi/linux/can/netlink.h |  5 ++-
 ip/iplink_can.c                  | 54 +++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 23 deletions(-)

-- 
2.32.0

