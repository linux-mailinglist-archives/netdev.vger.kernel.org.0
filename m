Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D24117895E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgCDEGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:06:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55979 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727205AbgCDEGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:06:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Mar 2020 06:06:37 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02446XJS014213;
        Wed, 4 Mar 2020 06:06:36 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com,
        parav@mellanox.com
Subject: [PATCH net-next iproute2 2/2] devlink: Introduce devlink port flavour virtual
Date:   Tue,  3 Mar 2020 22:06:26 -0600
Message-Id: <20200304040626.26320-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200304040626.26320-1-parav@mellanox.com>
References: <20200304040626.26320-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently PCI PF and VF devlink devices register their ports as
physical port in non-representors mode.

Introduce a new port flavour as virtual so that virtual devices can
register 'virtual' flavour to make it more clear to users.

An example of one PCI PF and 2 PCI virtual functions, each having
one devlink port.

$ devlink port show
pci/0000:06:00.0/1: type eth netdev ens2f0 flavour physical port 0
pci/0000:06:00.2/1: type eth netdev ens2f2 flavour virtual port 0
pci/0000:06:00.3/1: type eth netdev ens2f3 flavour virtual port 0

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 devlink/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 6e2115b6..ea9f54c9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3150,6 +3150,8 @@ static const char *port_flavour_name(uint16_t flavour)
 		return "pcipf";
 	case DEVLINK_PORT_FLAVOUR_PCI_VF:
 		return "pcivf";
+	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
+		return "virtual";
 	default:
 		return "<unknown flavour>";
 	}
-- 
2.19.2

