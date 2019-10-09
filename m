Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07BED1810
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfJITLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:11:32 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:44457 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732017AbfJITL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:28 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M9FSx-1iCUjn0qkZ-006OvI; Wed, 09 Oct 2019 21:11:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v6 35/43] compat_ioctl: move SIOCOUTQ out of compat_ioctl.c
Date:   Wed,  9 Oct 2019 21:10:36 +0200
Message-Id: <20191009191044.308087-36-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Gs7WDz3cO6L34SuxnoUE0cPkG0RD46UJTcOdAtxxQ1wu2AcocIH
 MLlyJRAJ8Q6F2FRZDhUczb7xeo7VKSoS7S+r2JbhUK30znZWrAwlwhfU4RweQnK7sx89S/8
 s9RgheEsez9Uomff7IBT9Sltreuq64VyHWryfBMeRfUyAETmwTP08msug+UQKLwvT+1trrR
 Sv2dxjAVq0UUbeHAemB7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HtEfBJfsbxY=:E7oDDRVKYPFRpr3roXuDJ9
 2a2dn8t9obGYSTPEUnz0t2K7GmIT/1+xA4ovsqk8Kur9QPB3c2IahhiyJmSHQFl4cZeSQryh1
 AqIQTSi1rtujSBNrlmRp25g3/c5MpZn/qJd/Qonjsru6QuxeC1LLH0STtADZWKJZZ1Q9bAE95
 RyKLn27ZRIaGPKzydfxflDf7+3EsMKNPB3UhsQn6vFpePJRnECESmuJa+f9xYFNHFpU9uwYZi
 8k3POEKOCWbpWR7zINsvobTBZyqqKLDMpzlwVMPvftpTSw4BSRgCuATpj91oot5bPoKx0dVlI
 sOi67TGH6EqbrjBpIdl1HouxucUq9EuTT/5Hg6ohtbixGME8ADJR/Csf1eotQ2+xegqcY0MtE
 yOGlP3sSO+h/kSukU4ciwdDF6FEHJaFfp8i+ZWFhL824kNU52oi3hdvGjfAF1WWmSsPVA88Xc
 C/tJxGlyCGVHHbNeSzlVCR5xR8QLmke8AJOl9ahbVfSzjO1uFyjkCPngHAolmpzo/f36GFNpq
 859XoS3QmUTOTZelYbFxGHLIsWA9bv/VNdg0cPP9wMW2Mg/hciK9h/86S9IaNBMOtyoR5g5yT
 PiCQwLHwcO/BycittMlz18e/6U1WgGzo6/SC542+TCVdLdXDv3G/9zXq/8p5fZ/ITYV1mWWZn
 Ct1DOaLHindVluRUugzQATVjV+lZGY+SGzzTFJaKmIRwtxzHu1kQKPXWuE/FjTSkzj0hcNhFk
 DE/WbvWIp6lSX+XlJ72O7pZFCjLwn2fZJQuayRTVm4Ijs/pEb6NqkyK2XbPfJZV29hXL/m9cx
 iOt3ysUxL08uOJqtj170VNDhNlkArXK02ON+8NeK+ohY/C7n7W2zmowIUXxtdUmuAZWU7vLC5
 2dE4A/lwcI0iwAAG5Ssg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All users of this call are in socket or tty code, so handling
it there means we can avoid the table entry in fs/compat_ioctl.c.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/tty/tty_io.c | 1 +
 fs/compat_ioctl.c    | 2 --
 net/socket.c         | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 802c1210558f..c09691b20a25 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2755,6 +2755,7 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 	int retval = -ENOIOCTLCMD;
 
 	switch (cmd) {
+	case TIOCOUTQ:
 	case TIOCSTI:
 	case TIOCGWINSZ:
 	case TIOCSWINSZ:
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f279e77df256..d537888f3660 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -198,8 +198,6 @@ static int ppp_scompress(struct file *file, unsigned int cmd,
 
 #define COMPATIBLE_IOCTL(cmd) XFORM((u32)cmd),
 static unsigned int ioctl_pointer[] = {
-/* Little t */
-COMPATIBLE_IOCTL(TIOCOUTQ)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
diff --git a/net/socket.c b/net/socket.c
index a60f48ab2130..371999a024fa 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -100,6 +100,7 @@
 #include <linux/if_tun.h>
 #include <linux/ipv6_route.h>
 #include <linux/route.h>
+#include <linux/termios.h>
 #include <linux/sockios.h>
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
@@ -3452,6 +3453,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
+	case SIOCOUTQ:
 	case SIOCOUTQNSD:
 	case SIOCATMARK:
 		return sock_do_ioctl(net, sock, cmd, arg);
-- 
2.20.0

