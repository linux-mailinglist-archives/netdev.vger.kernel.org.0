Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDE4164E7
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbhIWSOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242753AbhIWSOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F42560F43;
        Thu, 23 Sep 2021 18:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632420786;
        bh=phlvYwzg+z96wp12+/KCpD7kPCOOA7sQ3Vr1eIwh1oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVixVQifNuQ+a1vwDe8CUju46ubqxFK9G/N3i038TJuLbTFXwfkWZU9MzYSc1UXfW
         UUGyUl9Fz33m9ndbOhB3cWY/Um0S++D5G0hqvNapVd7RrB4ul0zwC6qF8YjBu9EXrE
         a4fZq8PrL+GaTILBAGIwhIIqMVjZqAmpOmxHrKwxZsxJQNS/UKABewn/yAOR63WoHW
         8eocJUMMBzjQlY68HiQJ0L2IUHaFJTqXyerV+kJwCxlv4Z/N0+2ezMLuRYFGkNaU6O
         UDqe6y2vM9HVtvVY5ibNOMzozUxplH8IJLkkuOWvWCXjIk5aPuK9BBiBcbkjrClxDr
         3HgUmQlDH44JA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 3/6] devlink: Delete not used port parameters APIs
Date:   Thu, 23 Sep 2021 21:12:50 +0300
Message-Id: <b4350cf5e246da8587a636857724fababa820dea.1632420431.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
References: <cover.1632420430.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no in-kernel users for the devlink port parameters API,
so let's remove it.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  6 ------
 net/core/devlink.c    | 42 ------------------------------------------
 2 files changed, 48 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index c902e8e5f012..a7852a257bf6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1653,12 +1653,6 @@ void devlink_param_unregister(struct devlink *devlink,
 			      const struct devlink_param *param);
 void devlink_params_publish(struct devlink *devlink);
 void devlink_params_unpublish(struct devlink *devlink);
-int devlink_port_params_register(struct devlink_port *devlink_port,
-				 const struct devlink_param *params,
-				 size_t params_count);
-void devlink_port_params_unregister(struct devlink_port *devlink_port,
-				    const struct devlink_param *params,
-				    size_t params_count);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7d975057c2a9..9c071f4e609f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10117,48 +10117,6 @@ void devlink_params_unpublish(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_params_unpublish);
 
-/**
- *	devlink_port_params_register - register port configuration parameters
- *
- *	@devlink_port: devlink port
- *	@params: configuration parameters array
- *	@params_count: number of parameters provided
- *
- *	Register the configuration parameters supported by the port.
- */
-int devlink_port_params_register(struct devlink_port *devlink_port,
-				 const struct devlink_param *params,
-				 size_t params_count)
-{
-	return __devlink_params_register(devlink_port->devlink,
-					 devlink_port->index,
-					 &devlink_port->param_list, params,
-					 params_count,
-					 DEVLINK_CMD_PORT_PARAM_NEW,
-					 DEVLINK_CMD_PORT_PARAM_DEL);
-}
-EXPORT_SYMBOL_GPL(devlink_port_params_register);
-
-/**
- *	devlink_port_params_unregister - unregister port configuration
- *	parameters
- *
- *	@devlink_port: devlink port
- *	@params: configuration parameters array
- *	@params_count: number of parameters provided
- */
-void devlink_port_params_unregister(struct devlink_port *devlink_port,
-				    const struct devlink_param *params,
-				    size_t params_count)
-{
-	return __devlink_params_unregister(devlink_port->devlink,
-					   devlink_port->index,
-					   &devlink_port->param_list,
-					   params, params_count,
-					   DEVLINK_CMD_PORT_PARAM_DEL);
-}
-EXPORT_SYMBOL_GPL(devlink_port_params_unregister);
-
 static int
 __devlink_param_driverinit_value_get(struct list_head *param_list, u32 param_id,
 				     union devlink_param_value *init_val)
-- 
2.31.1

