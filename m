Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E474AD183D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbfJITL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:11:29 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:56199 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731824AbfJITL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:27 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N8oOk-1i3afR3chC-015pLd; Wed, 09 Oct 2019 21:11:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v6 34/43] compat_ioctl: handle SIOCOUTQNSD
Date:   Wed,  9 Oct 2019 21:10:35 +0200
Message-Id: <20191009191044.308087-35-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:uemQDqA8yQ6MG7MO2w2hB7mLVVCYHFMtePKjKuwvfP+fKw479wi
 +3XH2jpG2j8lBDQxUHlpmJugPSEVHS4OBNcQQA0NBvEAx6hzxafXBAI2rIJOiSHd0Arteyp
 h8w7y6xun7yngr4VavE/jm0+bod5rapG7AgX0+V0MVAbkqWohYWJZroUHvaveum+3A13lwE
 P3MRbIbyNK22sOumQLM8Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jCWR5TpYalo=:JEiqSw2ynBAY/yIo966rNk
 okajkQuPa+YtaOW3JvOQHr+J6t8i2U/E4DRyD7qU9Ft7WHk+5KHDWKi9OdMFrr5DNtmbNju8D
 6H0QHl4hlMfud+pWBSsw9QVG5J5Ri4meSjWM3ZwSZpsgXizmK6bS7m+FTQxmPWgLml8oyxO3N
 9V+iyQjFE7BvalkRhehCpZqW3nNDJ/0I0/K1KDXVTCRi5AGqLCbDV0p15Vre6MgNgkIVEE1EH
 p5cpk/NEyWW7OdKW2VrazYGL8xfVB7cy7zTrvynJQGjUIUOMNnJP1BNg/+OZccrThMqnA8uCV
 sdGpN2tJxi39qlX+cqcgRqtkzTXxRrEaGAaL19qWhfnLJRUovmlrtiNyEHdMisOtodXqIcBcT
 xQpN1lTgYPOGorSDbBasrYiwhCEmiLOhxMEXiRzerRza0j+43fYSp86LEtJXdFI50q51Gz7km
 iCe+h8m8pMU+xDFOm24REu5YOnyVUeqUZluBytLM6HZCeoop0nMMMz9BlDAJEc4wh+fD1ostO
 nGlel+ejpQxWbR1V69v8cZIPTG4LVMtI3iERXe9SDeVyyL6YJyAtDCfKJYrslnC5lfqq2eEwL
 7ADmRETHmHk3FEubMm/ESuUxcC7H7vRpxbTRD74H4fQufRgTlmagVPaqZ/u4SfbE6XJY91cw1
 O5jVvINrL+juEKnOMyYYQOgI1tiDx273l5T+B5gVZX5jPMjUpChv+6KqqnnSxmHdedN7nT2K5
 HbfNwN6FIlcvrqnbAw2gYkDwTwSmzsDiUlvrrlvynVt4uy7E9/czPv8DIL76UJQgQYuB4S33J
 9KvWA4DH/RO8FAbFVMoqgC8sNNmMyqOeIJ9FW0v17DZoX5xEU7WbvVbexDdpLX/cp6tvl+N3s
 3Y7W252bI8BKRpjTbgXQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike the normal SIOCOUTQ, SIOCOUTQNSD was never handled in compat
mode. Add it to the common socket compat handler along with similar
ones.

Fixes: 2f4e1b397097 ("tcp: ioctl type SIOCOUTQNSD returns amount of data not sent")
Cc: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index 6a9ab7a8b1d2..a60f48ab2130 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3452,6 +3452,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
+	case SIOCOUTQNSD:
 	case SIOCATMARK:
 		return sock_do_ioctl(net, sock, cmd, arg);
 	}
-- 
2.20.0

