Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A241C3E1D1C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbhHET74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:56 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:49283 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243005AbhHET7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:50 -0400
Received: (qmail 83218 invoked by uid 89); 5 Aug 2021 19:52:55 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 5 Aug 2021 19:52:55 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 5/6] ptp: ocp: Rename version string shown by devlink.
Date:   Thu,  5 Aug 2021 12:52:47 -0700
Message-Id: <20210805195248.35665-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805195248.35665-1-jonathan.lemon@gmail.com>
References: <20210805195248.35665-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TimeCard has two FPGA images in the flash: the actual firmware,
and a manufacturing fallback version which is intended to act as a
loader in case the flash update failed.

Name these "fw" and "loader", which are reflected in devlink:

    [root@timecard drv]# devlink dev info
    pci/0000:04:00.0:
      driver ptp_ocp
      serial_number fc:c2:3d:2e:d7:c0
      versions:
          running:
            fw 5

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index f744bb42f48f..1412015fd261 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -867,12 +867,12 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 		if (ver & 0xffff) {
 			sprintf(buf, "%d", ver);
 			err = devlink_info_version_running_put(req,
-							       "timecard",
+							       "fw",
 							       buf);
 		} else {
 			sprintf(buf, "%d", ver >> 16);
 			err = devlink_info_version_running_put(req,
-							       "golden flash",
+							       "loader",
 							       buf);
 		}
 		if (err)
-- 
2.31.1

