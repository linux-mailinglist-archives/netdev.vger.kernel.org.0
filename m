Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9088E59BB6
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfF1Mjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:39:37 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:58439 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfF1Mjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:39:36 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MSbp1-1i9oCT1Vaz-00Syc4; Fri, 28 Jun 2019 14:38:36 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 1/4] [v2] structleak: disable STRUCTLEAK_BYREF in combination with KASAN_STACK
Date:   Fri, 28 Jun 2019 14:37:46 +0200
Message-Id: <20190628123819.2785504-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Vyv7hDWAtsub/JNqLOHsg4FkzINNTOEYL230tDKN/RItqenQapP
 gyiBCpoLRRoTqs8Tv2p30vIpq0szU20cz8WHVZAjO+wDA1cj9+wZTfO8K4w5U23pnLNweti
 UywkJH8BUfN6F1OQXF9XsDDZcZtuJH4mRwHl7vS8Crfb6pptLcNlGI4ZF0Y6qEGx/xprLOw
 3JJuBgcheAN7frqGyD/ng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hCq8JItJh8A=:onuXm76BFuVcDFqRETOYkg
 MtmPnl8+G4vcDKCWOcOBqIwlOGi23HDTrEy1N2iM59a8glWED6at9+xN5y070TSqE0F74f5Bp
 SG6oYbbB8UDm3jlsYCu4oElgMn80THtjNnFdcKdCHyaBlaVtvkU7NCXkVh4O/2jppR3D8tSbB
 NhDDlCDWofUbrSnIF7sbuz/JZwrrOo30UDP6JD6l+8gLfCwjR9RBtMUh76ESFfy9vUGaqlpI2
 x5QNSlqT2uFQ8CtPKhaBorUssjMKG1C3Jzz1ivMBDLDCkEKN3/rJ16yRUjtNVoKzVJCFy9/vM
 Njg89iGc2HhaQR9EElUOXKdNypG2lkuoixugjYhI+FEsRi6J6jPqAgL/GsRD+wj5NYVan393T
 x/OJDB1MtoCErAkNCeQtN+S4UZlTsGP/neFdqAG/RcsdcjktiPUZhw9PWKzHHOZ17Erp1lF+K
 HHIuvo3LVNWSCKk2Db2RWCYWSroITpsS5zUZMvNj0yC/Cmurp81cwCXsVe6RzlNoBKUkqtnau
 t6uOPEhloDMMgxKksXBitbTPaG4vSVZnHSLStJRfV67Xk+LtyIHrrvU+5Koezdsypn457AiF4
 8GnQKZWviq2xLyRkSPaTL2o5G9ohCYKa6AwRDJpsMLVj30s09byWPoS+7O8pdcH4N2CbOLlag
 XOaT19Ih6zHEsveSXAncAy+o55MhMno3iNzFdCME5MQ9sQOSBSTXNdD9W9fUEzNCrw83/TIFK
 4Pu9RqEacN2PYZhmmiTscWmrBRdsNgqikx+SQA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The combination of KASAN_STACK and GCC_PLUGIN_STRUCTLEAK_BYREF
leads to much larger kernel stack usage, as seen from the warnings
about functions that now exceed the 2048 byte limit:

drivers/media/i2c/tvp5150.c:253:1: error: the frame size of 3936 bytes is larger than 2048 bytes
drivers/media/tuners/r820t.c:1327:1: error: the frame size of 2816 bytes is larger than 2048 bytes
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:16552:1: error: the frame size of 3144 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
fs/ocfs2/aops.c:1892:1: error: the frame size of 2088 bytes is larger than 2048 bytes
fs/ocfs2/dlm/dlmrecovery.c:737:1: error: the frame size of 2088 bytes is larger than 2048 bytes
fs/ocfs2/namei.c:1677:1: error: the frame size of 2584 bytes is larger than 2048 bytes
fs/ocfs2/super.c:1186:1: error: the frame size of 2640 bytes is larger than 2048 bytes
fs/ocfs2/xattr.c:3678:1: error: the frame size of 2176 bytes is larger than 2048 bytes
net/bluetooth/l2cap_core.c:7056:1: error: the frame size of 2144 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
net/bluetooth/l2cap_core.c: In function 'l2cap_recv_frame':
net/bridge/br_netlink.c:1505:1: error: the frame size of 2448 bytes is larger than 2048 bytes
net/ieee802154/nl802154.c:548:1: error: the frame size of 2232 bytes is larger than 2048 bytes
net/wireless/nl80211.c:1726:1: error: the frame size of 2224 bytes is larger than 2048 bytes
net/wireless/nl80211.c:2357:1: error: the frame size of 4584 bytes is larger than 2048 bytes
net/wireless/nl80211.c:5108:1: error: the frame size of 2760 bytes is larger than 2048 bytes
net/wireless/nl80211.c:6472:1: error: the frame size of 2112 bytes is larger than 2048 bytes

The structleak plugin was previously disabled for CONFIG_COMPILE_TEST,
but meant we missed some bugs, so this time we should address them.

The frame size warnings are distracting, and risking a kernel stack
overflow is generally not beneficial to performance, so it may be best
to disallow that particular combination. This can be done by turning
off either one. I picked the dependency in GCC_PLUGIN_STRUCTLEAK_BYREF
and GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, as this option is designed to
make uninitialized stack usage less harmful when enabled on its own,
but it also prevents KASAN from detecting those cases in which it was
in fact needed.

KASAN_STACK is currently implied by KASAN on gcc, but could be made a
user selectable option if we want to allow combining (non-stack) KASAN
with GCC_PLUGIN_STRUCTLEAK_BYREF.

Note that it would be possible to specifically address the files that
print the warning, but presumably the overall stack usage is still
significantly higher than in other configurations, so this would not
address the full problem.

I could not test this with CONFIG_INIT_STACK_ALL, which may or may not
suffer from a similar problem.

Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
[v2] do it for both GCC_PLUGIN_STRUCTLEAK_BYREF and GCC_PLUGIN_STRUCTLEAK_BYREF_ALL.
---
 security/Kconfig.hardening | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index a1ffe2eb4d5f..af4c979b38ee 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -61,6 +61,7 @@ choice
 	config GCC_PLUGIN_STRUCTLEAK_BYREF
 		bool "zero-init structs passed by reference (strong)"
 		depends on GCC_PLUGINS
+		depends on !(KASAN && KASAN_STACK=1)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any structures on the stack that may
@@ -70,9 +71,15 @@ choice
 		  exposures, like CVE-2017-1000410:
 		  https://git.kernel.org/linus/06e7e776ca4d3654
 
+		  As a side-effect, this keeps a lot of variables on the
+		  stack that can otherwise be optimized out, so combining
+		  this with CONFIG_KASAN_STACK can lead to a stack overflow
+		  and is disallowed.
+
 	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
 		bool "zero-init anything passed by reference (very strong)"
 		depends on GCC_PLUGINS
+		depends on !(KASAN && KASAN_STACK=1)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any stack variables that may be passed
-- 
2.20.0

