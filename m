Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EDE11B420
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388731AbfLKPqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:46:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43820 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732275AbfLKPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:46:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Dec 2019 17:46:07 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xBBFk7xY022467;
        Wed, 11 Dec 2019 17:46:07 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        jiri@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 0/3] Devlink health reporter's issues
Date:   Wed, 11 Dec 2019 17:45:33 +0200
Message-Id: <20191211154536.5701-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset by Aya fixes two issues: wrong time-stamp on a dump in
devlink health reporter and messy display of non JSON output in devlink
health diagnostics and dump.

1) Wrong time-stamp on a dump in devlink health reporter: 
This bug fix consist of 2 patches. First patch refactors the current
implementation of helper function which displays the reporter's dump
time-stamp and add the actual print to the function's body.
The second patch introduces a new attribute which is the time-stamp in
current time in nsec instead of jiffies. When the new attribute is
present try and translate the time-stamp according to 'current time'.

2) Messy display of non-JSON output in devlink health diagnostics and dump:
This patch mainly deals with dynamic object and array opening. The
label is stored and only when the proceeding value arrives the name is
printed with regards to the context. 

Series generated against the shared master/net-next head:
24bee3bf9752 tipc: add new commands to set TIPC AEAD key

Regards,
Tariq

Aya Levin (3):
  devlink: Print health reporter's dump time-stamp in a helper function
  devlink: Add a new time-stamp format for health reporter's dump
  devlink: Fix fmsg nesting in non JSON output

 devlink/devlink.c | 153 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 119 insertions(+), 34 deletions(-)

-- 
2.21.0

