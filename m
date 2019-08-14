Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B248DF67
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfHNUzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:55:04 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:47591 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfHNUzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:55:03 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N7gfa-1iKZYU3lUA-014jrh; Wed, 14 Aug 2019 22:54:45 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Mario Schuknecht <m.schuknecht@dresearch.de>,
        Steffen Sledz <sledz@dresearch.de>,
        Willem de Bruijn <willemb@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH v5 09/18] compat_ioctl: handle SIOCOUTQNSD
Date:   Wed, 14 Aug 2019 22:49:21 +0200
Message-Id: <20190814205245.121691-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:PR2kN+3b7Ibxtnk41q7Nxz/FfJzjWkTqKtlwh7QP5DaHQ4nbRYc
 NiBXcxAA5hJaBn1P+Fpve4A5y3aKag9gv5v2r7+a/cpLhPgwYCDqwREb86JtUgNOePqKqwO
 9PFoe0Dmlm8ahvvWkFp4laELhzMZjpcMcXd+WxVvuyWNmbvw5Mmsj2C7vmluBXGG9G9Xb6L
 o1ewHcZ3o87tDYhM10iqw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:U+fzLfynvBw=:1jD0thGH+ZMq+c9jiboTLb
 BlplpqEkAj9npkOADezy/rfKW9RRddQR26ODkc5xHQZIs+Fy0kZq/ZLe432CGs3a0VwRwnjx0
 VqDkkvkoEfFlpRC01EB5r/i9jDrEx9sixAHF6qNWlJh6EiYP9fUhr0F9RPRlDma5rD4DtKIE/
 zPwg9l0mNNBuBAy+Q9qQ8AjM94seaols/Y18YZg8U3H2zUdxYQqv6NJ+4S34APo/xl2l4KYTU
 5NjF2m4BbUz4WuY4WqrjJGsRc7Tu/Hzozj+8ggRZT5Fsy6cZZDd7l9hPYC2yltVnLFvfrcmuy
 fsU4VHZree9L45yKMAcpb3ij45dL0r1b9Ue24Z7F1wvJI4BrgJp9ENvacPx1nUmqg59tQCQ9s
 caHyYBeDSE0S3u4xboxsO3AkS3QomjAMQlKGMRL//NGUbIK51oqEqa8VT/259Qi1QjeqVmRHn
 UWRFw4Sp0v5tDl5CQhLG7/fVT2oOR6/ydrhssMiE02yfoUHC+PPGXVoBEK3dDKJ2T4jOOcv36
 FtQzODhYoF073qsHUsHjrxo5L58edg/7a38nDUNPJqnuRlN9Suu40Rg4GvjaI/ESf7bx3vbPn
 ht3BaBZYhM3ojviYfFnuYvIVLEv/UPJBQfZ+gopabMNu30gaxLDURPasEZVGqA0YaxbBU880j
 vShZr4VPbPVQiHAGupjPf/3hXFS9ObrabfhHuLICA954HFV3rj5R8i0WLntB+FAhW+GBiDuM7
 GHEUzvsNfRmYXh5/TzEkUp2uWojN4dFfly316Y5bcuOxOLAKUH4miD+ftlu/PGboQVXU4WsV7
 uIQbo6ccew25RiZi9c12pCLbuULQg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike the normal SIOCOUTQ, SIOCOUTQNSD was never handled in compat
mode. Add it to the common socket compat handler along with similar
ones.

Fixes: 2f4e1b397097 ("tcp: ioctl type SIOCOUTQNSD returns amount of data not sent")
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

