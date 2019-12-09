Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE4116FFC
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfLIPLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:11:46 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:34517 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfLIPLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:11:45 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M9npV-1ihvCW2eQv-005qF0; Mon, 09 Dec 2019 16:11:29 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, isdn4linux@listserv.isdn4linux.de,
        linux-bluetooth@vger.kernel.org,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] isdn: capi: dead code removal
Date:   Mon,  9 Dec 2019 16:11:14 +0100
Message-Id: <20191209151114.2410762-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191209151114.2410762-1-arnd@arndb.de>
References: <20191209151114.2410762-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vCdyRQzY+Cgca3IS7OcViqzX2s4vkXLEtp+QCkgZmdkyIRBDKK8
 LDerh2jlg3X7RFw+gEGtgWMdie09fOMMMCPsXL+f2JyhAWQjv5vyliFWnF0be1kMGsfr67k
 NvJ2IALndFxHgna3DXP8gz29EXMm+tNghz0FWtF1AyLxFO/nc10eYPRafdNJTVaqUMj92of
 mHuMv3dbXxiA3NnIjqfYQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xV/J6JaVuAg=:5f3suJUcH4bvrPnU4Ax6ti
 a29YiBVqTWjnXGmZdcXZy/edPnsk4wucNqCQMaZ6Y+wCiCVV0jcxy49NtPdKG3xruIJt0o5Sz
 ZfVqVMD9/lXSsm6Ai3BQzrqs0ucwL6juFTpj2P3COmIRCjqky0wg/mL8VS+I1PQi7JgxgZES3
 BQ1paNB0L2Vlxi7+AAGBOGnV8wP9DUjOPf5dGN6LvYXqEr74HvJSwBO75f5pFFizJp7AwFkrs
 uo7UMB80JxGvXnC/26ITLbhRSybrF6v83yGMIN3WQW9QKkkmx79VJrTkNnUGxNydz9R4W94M8
 H2ePBAxJEAP3fQcjZrXZVk5b9M9dye+hU/hGCgP5d5Uzzm0MT8UXqD7kPuGSDTF3bqZgTUSYE
 VDcXWt//NRtzMDQGuE8zh6oSXlcnu0aeW77FUPM8ntxzVkefwy6xt8PaK9+ewQCAUQxP/M2vQ
 Y6zHtY/4Gbv3zmDXwNsxYEMnFuilIrSY8secCeoN2WgxqD+GrJNjyDrBnb2n9ntkMClQoAaCO
 qsWNLFuidAxAMWWpEv5jNQesu8dvBrm6Upg+dDKR0djqbxdYNkEj3PxnYMHxV43+2q109VqCJ
 KBaWn1o6O2sxz4ov85BT/EhMuE/7u6EAVx5QuCJinKK3pWzXOqslt1FXWP8GUhOO6+z8DN9XF
 jJMTLBk+yHypJPdYMJFLeXkNK4zE0k8tn2b9oL0ChAqN7vQOa7OdYdQhuLnou9NIFD8Rv6fGC
 8SksUKrNG6Jvv3a+UaVLWKuvoz9lkIykEeGW/LE3DRAZB5veF2MqXjoLTds9fZb/sK+j3o4Uu
 g5fz59IoufUjyezDhx1PgoQrfdJV1vJVeYR/EkEugBCdEJqPlTqz2dIJQAie784ZkjUCAsINA
 gFZBrcs9FntdRlnFbj6g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The staging isdn drivers are gone, and CONFIG_BT_CMTP is now
the only user. This means a lot of the code in the subsystem
has no remaining callers and can be removed.

Change the capi user space front-end to be part of kernelcapi,
and the combined module to only be compiled if BT_CMTP is
also enabled, then remove the interfaces that have no remaining
callers.

As the notifier list and the capi_drivers list have no callers
outside of kcapi.c, the implementation gets much simpler.

Some definitions from the include/linux/*.h headers are only
needed internally and are moved to kcapi.h.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/isdn/interface_capi.rst |  71 ----
 drivers/isdn/Makefile                 |   2 +-
 drivers/isdn/capi/Kconfig             |  32 +-
 drivers/isdn/capi/Makefile            |  18 +-
 drivers/isdn/capi/capi.c              |  14 +-
 drivers/isdn/capi/capilib.c           | 202 ------------
 drivers/isdn/capi/capiutil.c          | 231 +------------
 drivers/isdn/capi/kcapi.c             | 409 +----------------------
 drivers/isdn/capi/kcapi.h             | 149 ++++++++-
 drivers/isdn/capi/kcapi_proc.c        |  34 +-
 include/linux/isdn/capilli.h          |  18 -
 include/linux/isdn/capiutil.h         | 456 --------------------------
 include/linux/kernelcapi.h            |  75 -----
 include/uapi/linux/b1lli.h            |  74 -----
 14 files changed, 179 insertions(+), 1606 deletions(-)
 delete mode 100644 drivers/isdn/capi/capilib.c
 delete mode 100644 include/uapi/linux/b1lli.h

diff --git a/Documentation/isdn/interface_capi.rst b/Documentation/isdn/interface_capi.rst
index 01a4b5ade9a4..fe2421444b76 100644
--- a/Documentation/isdn/interface_capi.rst
+++ b/Documentation/isdn/interface_capi.rst
@@ -26,13 +26,6 @@ This standard is freely available from https://www.capi.org.
 2. Driver and Device Registration
 =================================
 
-CAPI drivers optionally register themselves with Kernel CAPI by calling the
-Kernel CAPI function register_capi_driver() with a pointer to a struct
-capi_driver. This structure must be filled with the name and revision of the
-driver, and optionally a pointer to a callback function, add_card(). The
-registration can be revoked by calling the function unregister_capi_driver()
-with a pointer to the same struct capi_driver.
-
 CAPI drivers must register each of the ISDN devices they control with Kernel
 CAPI by calling the Kernel CAPI function attach_capi_ctr() with a pointer to a
 struct capi_ctr before they can be used. This structure must be filled with
@@ -89,9 +82,6 @@ register_capi_driver():
 	the name of the driver, as a zero-terminated ASCII string
 ``char revision[32]``
 	the revision number of the driver, as a zero-terminated ASCII string
-``int (*add_card)(struct capi_driver *driver, capicardparams *data)``
-	a callback function pointer (may be NULL)
-
 
 4.2 struct capi_ctr
 -------------------
@@ -178,12 +168,6 @@ to be set by the driver before calling attach_capi_ctr():
 	pointer to a callback function returning the entry for the device in
 	the CAPI controller info table, /proc/capi/controller
 
-``const struct file_operations *proc_fops``
-	pointers to callback functions for the device's proc file
-	system entry, /proc/capi/controllers/<n>; pointer to the device's
-	capi_ctr structure is available from struct proc_dir_entry::data
-	which is available from struct inode.
-
 Note:
   Callback functions except send_message() are never called in interrupt
   context.
@@ -267,25 +251,10 @@ _cmstruct   alternative representation for CAPI parameters of type 'struct'
 	    _cmsg structure members.
 =========== =================================================================
 
-Functions capi_cmsg2message() and capi_message2cmsg() are provided to convert
-messages between their transport encoding described in the CAPI 2.0 standard
-and their _cmsg structure representation. Note that capi_cmsg2message() does
-not know or check the size of its destination buffer. The caller must make
-sure it is big enough to accommodate the resulting CAPI message.
-
 
 5. Lower Layer Interface Functions
 ==================================
 
-(declared in <linux/isdn/capilli.h>)
-
-::
-
-  void register_capi_driver(struct capi_driver *drvr)
-  void unregister_capi_driver(struct capi_driver *drvr)
-
-register/unregister a driver with Kernel CAPI
-
 ::
 
   int attach_capi_ctr(struct capi_ctr *ctrlr)
@@ -300,13 +269,6 @@ register/unregister a device (controller) with Kernel CAPI
 
 signal controller ready/not ready
 
-::
-
-  void capi_ctr_suspend_output(struct capi_ctr *ctrlr)
-  void capi_ctr_resume_output(struct capi_ctr *ctrlr)
-
-signal suspend/resume
-
 ::
 
   void capi_ctr_handle_message(struct capi_ctr * ctrlr, u16 applid,
@@ -319,21 +281,6 @@ for forwarding to the specified application
 6. Helper Functions and Macros
 ==============================
 
-Library functions (from <linux/isdn/capilli.h>):
-
-::
-
-  void capilib_new_ncci(struct list_head *head, u16 applid,
-			u32 ncci, u32 winsize)
-  void capilib_free_ncci(struct list_head *head, u16 applid, u32 ncci)
-  void capilib_release_appl(struct list_head *head, u16 applid)
-  void capilib_release(struct list_head *head)
-  void capilib_data_b3_conf(struct list_head *head, u16 applid,
-			u32 ncci, u16 msgid)
-  u16  capilib_data_b3_req(struct list_head *head, u16 applid,
-			u32 ncci, u16 msgid)
-
-
 Macros to extract/set element values from/in a CAPI message header
 (from <linux/isdn/capiutil.h>):
 
@@ -357,24 +304,6 @@ CAPIMSG_DATALEN(m)	CAPIMSG_SETDATALEN(m, len)	Data Length (u16)
 Library functions for working with _cmsg structures
 (from <linux/isdn/capiutil.h>):
 
-``unsigned capi_cmsg2message(_cmsg *cmsg, u8 *msg)``
-	Assembles a CAPI 2.0 message from the parameters in ``*cmsg``,
-	storing the result in ``*msg``.
-
-``unsigned capi_message2cmsg(_cmsg *cmsg, u8 *msg)``
-	Disassembles the CAPI 2.0 message in ``*msg``, storing the parameters
-	in ``*cmsg``.
-
-``unsigned capi_cmsg_header(_cmsg *cmsg, u16 ApplId, u8 Command, u8 Subcommand, u16 Messagenumber, u32 Controller)``
-	Fills the header part and address field of the _cmsg structure ``*cmsg``
-	with the given values, zeroing the remainder of the structure so only
-	parameters with non-default values need to be changed before sending
-	the message.
-
-``void capi_cmsg_answer(_cmsg *cmsg)``
-	Sets the low bit of the Subcommand field in ``*cmsg``, thereby
-	converting ``_REQ`` to ``_CONF`` and ``_IND`` to ``_RESP``.
-
 ``char *capi_cmd2str(u8 Command, u8 Subcommand)``
 	Returns the CAPI 2.0 message name corresponding to the given command
 	and subcommand values, as a static ASCII string. The return value may
diff --git a/drivers/isdn/Makefile b/drivers/isdn/Makefile
index 63baf27a2c79..d14334f4007e 100644
--- a/drivers/isdn/Makefile
+++ b/drivers/isdn/Makefile
@@ -3,6 +3,6 @@
 
 # Object files in subdirectories
 
-obj-$(CONFIG_ISDN_CAPI)			+= capi/
+obj-$(CONFIG_BT_CMTP)			+= capi/
 obj-$(CONFIG_MISDN)			+= mISDN/
 obj-$(CONFIG_ISDN)			+= hardware/
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index 573fea5500ce..cc408ad9aafb 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-menuconfig ISDN_CAPI
-	tristate "CAPI 2.0 subsystem"
+config ISDN_CAPI
+	def_bool ISDN && BT
 	help
 	  This provides CAPI (the Common ISDN Application Programming
 	  Interface) Version 2.0, a standard making it easy for programs to
@@ -15,42 +15,18 @@ menuconfig ISDN_CAPI
 	  See CONFIG_BT_CMTP for the last remaining regular driver
 	  in the kernel that uses the CAPI subsystem.
 
-if ISDN_CAPI
-
 config CAPI_TRACE
-	bool "CAPI trace support"
-	default y
+	def_bool BT_CMTP
 	help
 	  If you say Y here, the kernelcapi driver can make verbose traces
 	  of CAPI messages. This feature can be enabled/disabled via IOCTL for
 	  every controller (default disabled).
-	  This will increase the size of the kernelcapi module by 20 KB.
-	  If unsure, say Y.
-
-config ISDN_CAPI_CAPI20
-	tristate "CAPI2.0 /dev/capi20 support"
-	help
-	  This option will provide the CAPI 2.0 interface to userspace
-	  applications via /dev/capi20. Applications should use the
-	  standardized libcapi20 to access this functionality.  You should say
-	  Y/M here.
 
 config ISDN_CAPI_MIDDLEWARE
-	bool "CAPI2.0 Middleware support"
-	depends on ISDN_CAPI_CAPI20 && TTY
+	def_bool BT_CMTP && TTY
 	help
 	  This option will enhance the capabilities of the /dev/capi20
 	  interface.  It will provide a means of moving a data connection,
 	  established via the usual /dev/capi20 interface to a special tty
 	  device.  If you want to use pppd with pppdcapiplugin to dial up to
 	  your ISP, say Y here.
-
-config ISDN_CAPI_CAPIDRV_VERBOSE
-	bool "Verbose reason code reporting"
-	depends on ISDN_CAPI_CAPIDRV
-	help
-	  If you say Y here, the capidrv interface will give verbose reasons
-	  for disconnecting. This will increase the size of the kernel by 7 KB.
-	  If unsure, say N.
-
-endif
diff --git a/drivers/isdn/capi/Makefile b/drivers/isdn/capi/Makefile
index d299f3e75f89..352217ebabd8 100644
--- a/drivers/isdn/capi/Makefile
+++ b/drivers/isdn/capi/Makefile
@@ -1,17 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-# Makefile for the CAPI subsystem.
+# Makefile for the CAPI subsystem used by BT_CMTP
 
-# Ordering constraints: kernelcapi.o first
-
-# Each configuration option enables a list of files.
-
-obj-$(CONFIG_ISDN_CAPI)			+= kernelcapi.o
-obj-$(CONFIG_ISDN_CAPI_CAPI20)		+= capi.o 
-obj-$(CONFIG_ISDN_CAPI_CAPIDRV)		+= capidrv.o
-
-# Multipart objects.
-
-kernelcapi-y				:= kcapi.o capiutil.o capilib.o
-kernelcapi-$(CONFIG_PROC_FS)		+= kcapi_proc.o
-
-ccflags-y += -I$(srctree)/$(src)/../include -I$(srctree)/$(src)/../include/uapi
+obj-$(CONFIG_BT_CMTP)			+= kernelcapi.o
+kernelcapi-y				:= kcapi.o capiutil.o capi.o kcapi_proc.o
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 1675da34239b..85767f52fe3c 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -39,7 +39,9 @@
 #include <linux/isdn/capiutil.h>
 #include <linux/isdn/capicmd.h>
 
-MODULE_DESCRIPTION("CAPI4Linux: Userspace /dev/capi20 interface");
+#include "kcapi.h"
+
+MODULE_DESCRIPTION("CAPI4Linux: kernel CAPI layer and /dev/capi20 interface");
 MODULE_AUTHOR("Carsten Paeth");
 MODULE_LICENSE("GPL");
 
@@ -1412,15 +1414,22 @@ static int __init capi_init(void)
 {
 	const char *compileinfo;
 	int major_ret;
+	int ret;
+
+	ret = kcapi_init();
+	if (ret)
+		return ret;
 
 	major_ret = register_chrdev(capi_major, "capi20", &capi_fops);
 	if (major_ret < 0) {
 		printk(KERN_ERR "capi20: unable to get major %d\n", capi_major);
+		kcapi_exit();
 		return major_ret;
 	}
 	capi_class = class_create(THIS_MODULE, "capi");
 	if (IS_ERR(capi_class)) {
 		unregister_chrdev(capi_major, "capi20");
+		kcapi_exit();
 		return PTR_ERR(capi_class);
 	}
 
@@ -1430,6 +1439,7 @@ static int __init capi_init(void)
 		device_destroy(capi_class, MKDEV(capi_major, 0));
 		class_destroy(capi_class);
 		unregister_chrdev(capi_major, "capi20");
+		kcapi_exit();
 		return -ENOMEM;
 	}
 
@@ -1455,6 +1465,8 @@ static void __exit capi_exit(void)
 	unregister_chrdev(capi_major, "capi20");
 
 	capinc_tty_exit();
+
+	kcapi_exit();
 }
 
 module_init(capi_init);
diff --git a/drivers/isdn/capi/capilib.c b/drivers/isdn/capi/capilib.c
deleted file mode 100644
index a39ad3796bba..000000000000
--- a/drivers/isdn/capi/capilib.c
+++ /dev/null
@@ -1,202 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <linux/slab.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/isdn/capilli.h>
-
-#define DBG(format, arg...) do {					\
-		printk(KERN_DEBUG "%s: " format "\n" , __func__ , ## arg); \
-	} while (0)
-
-struct capilib_msgidqueue {
-	struct capilib_msgidqueue *next;
-	u16 msgid;
-};
-
-struct capilib_ncci {
-	struct list_head list;
-	u16 applid;
-	u32 ncci;
-	u32 winsize;
-	int   nmsg;
-	struct capilib_msgidqueue *msgidqueue;
-	struct capilib_msgidqueue *msgidlast;
-	struct capilib_msgidqueue *msgidfree;
-	struct capilib_msgidqueue msgidpool[CAPI_MAXDATAWINDOW];
-};
-
-// ---------------------------------------------------------------------------
-// NCCI Handling
-
-static inline void mq_init(struct capilib_ncci *np)
-{
-	u_int i;
-	np->msgidqueue = NULL;
-	np->msgidlast = NULL;
-	np->nmsg = 0;
-	memset(np->msgidpool, 0, sizeof(np->msgidpool));
-	np->msgidfree = &np->msgidpool[0];
-	for (i = 1; i < np->winsize; i++) {
-		np->msgidpool[i].next = np->msgidfree;
-		np->msgidfree = &np->msgidpool[i];
-	}
-}
-
-static inline int mq_enqueue(struct capilib_ncci *np, u16 msgid)
-{
-	struct capilib_msgidqueue *mq;
-	if ((mq = np->msgidfree) == NULL)
-		return 0;
-	np->msgidfree = mq->next;
-	mq->msgid = msgid;
-	mq->next = NULL;
-	if (np->msgidlast)
-		np->msgidlast->next = mq;
-	np->msgidlast = mq;
-	if (!np->msgidqueue)
-		np->msgidqueue = mq;
-	np->nmsg++;
-	return 1;
-}
-
-static inline int mq_dequeue(struct capilib_ncci *np, u16 msgid)
-{
-	struct capilib_msgidqueue **pp;
-	for (pp = &np->msgidqueue; *pp; pp = &(*pp)->next) {
-		if ((*pp)->msgid == msgid) {
-			struct capilib_msgidqueue *mq = *pp;
-			*pp = mq->next;
-			if (mq == np->msgidlast)
-				np->msgidlast = NULL;
-			mq->next = np->msgidfree;
-			np->msgidfree = mq;
-			np->nmsg--;
-			return 1;
-		}
-	}
-	return 0;
-}
-
-void capilib_new_ncci(struct list_head *head, u16 applid, u32 ncci, u32 winsize)
-{
-	struct capilib_ncci *np;
-
-	np = kmalloc(sizeof(*np), GFP_ATOMIC);
-	if (!np) {
-		printk(KERN_WARNING "capilib_new_ncci: no memory.\n");
-		return;
-	}
-	if (winsize > CAPI_MAXDATAWINDOW) {
-		printk(KERN_ERR "capi_new_ncci: winsize %d too big\n",
-		       winsize);
-		winsize = CAPI_MAXDATAWINDOW;
-	}
-	np->applid = applid;
-	np->ncci = ncci;
-	np->winsize = winsize;
-	mq_init(np);
-	list_add_tail(&np->list, head);
-	DBG("kcapi: appl %d ncci 0x%x up", applid, ncci);
-}
-
-EXPORT_SYMBOL(capilib_new_ncci);
-
-void capilib_free_ncci(struct list_head *head, u16 applid, u32 ncci)
-{
-	struct list_head *l;
-	struct capilib_ncci *np;
-
-	list_for_each(l, head) {
-		np = list_entry(l, struct capilib_ncci, list);
-		if (np->applid != applid)
-			continue;
-		if (np->ncci != ncci)
-			continue;
-		printk(KERN_INFO "kcapi: appl %d ncci 0x%x down\n", applid, ncci);
-		list_del(&np->list);
-		kfree(np);
-		return;
-	}
-	printk(KERN_ERR "capilib_free_ncci: ncci 0x%x not found\n", ncci);
-}
-
-EXPORT_SYMBOL(capilib_free_ncci);
-
-void capilib_release_appl(struct list_head *head, u16 applid)
-{
-	struct list_head *l, *n;
-	struct capilib_ncci *np;
-
-	list_for_each_safe(l, n, head) {
-		np = list_entry(l, struct capilib_ncci, list);
-		if (np->applid != applid)
-			continue;
-		printk(KERN_INFO "kcapi: appl %d ncci 0x%x forced down\n", applid, np->ncci);
-		list_del(&np->list);
-		kfree(np);
-	}
-}
-
-EXPORT_SYMBOL(capilib_release_appl);
-
-void capilib_release(struct list_head *head)
-{
-	struct list_head *l, *n;
-	struct capilib_ncci *np;
-
-	list_for_each_safe(l, n, head) {
-		np = list_entry(l, struct capilib_ncci, list);
-		printk(KERN_INFO "kcapi: appl %d ncci 0x%x forced down\n", np->applid, np->ncci);
-		list_del(&np->list);
-		kfree(np);
-	}
-}
-
-EXPORT_SYMBOL(capilib_release);
-
-u16 capilib_data_b3_req(struct list_head *head, u16 applid, u32 ncci, u16 msgid)
-{
-	struct list_head *l;
-	struct capilib_ncci *np;
-
-	list_for_each(l, head) {
-		np = list_entry(l, struct capilib_ncci, list);
-		if (np->applid != applid)
-			continue;
-		if (np->ncci != ncci)
-			continue;
-
-		if (mq_enqueue(np, msgid) == 0)
-			return CAPI_SENDQUEUEFULL;
-
-		return CAPI_NOERROR;
-	}
-	printk(KERN_ERR "capilib_data_b3_req: ncci 0x%x not found\n", ncci);
-	return CAPI_NOERROR;
-}
-
-EXPORT_SYMBOL(capilib_data_b3_req);
-
-void capilib_data_b3_conf(struct list_head *head, u16 applid, u32 ncci, u16 msgid)
-{
-	struct list_head *l;
-	struct capilib_ncci *np;
-
-	list_for_each(l, head) {
-		np = list_entry(l, struct capilib_ncci, list);
-		if (np->applid != applid)
-			continue;
-		if (np->ncci != ncci)
-			continue;
-
-		if (mq_dequeue(np, msgid) == 0) {
-			printk(KERN_ERR "kcapi: msgid %hu ncci 0x%x not on queue\n",
-			       msgid, ncci);
-		}
-		return;
-	}
-	printk(KERN_ERR "capilib_data_b3_conf: ncci 0x%x not found\n", ncci);
-}
-
-EXPORT_SYMBOL(capilib_data_b3_conf);
diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
index 9846d82eb097..f26bf3c66d7e 100644
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -20,6 +20,8 @@
 #include <linux/isdn/capiutil.h>
 #include <linux/slab.h>
 
+#include "kcapi.h"
+
 /* from CAPI2.0 DDK AVM Berlin GmbH */
 
 typedef struct {
@@ -245,190 +247,6 @@ static void jumpcstruct(_cmsg *cmsg)
 		}
 	}
 }
-/*-------------------------------------------------------*/
-static void pars_2_message(_cmsg *cmsg)
-{
-
-	for (; TYP != _CEND; cmsg->p++) {
-		switch (TYP) {
-		case _CBYTE:
-			byteTLcpy(cmsg->m + cmsg->l, OFF);
-			cmsg->l++;
-			break;
-		case _CWORD:
-			wordTLcpy(cmsg->m + cmsg->l, OFF);
-			cmsg->l += 2;
-			break;
-		case _CDWORD:
-			dwordTLcpy(cmsg->m + cmsg->l, OFF);
-			cmsg->l += 4;
-			break;
-		case _CSTRUCT:
-			if (*(u8 **) OFF == NULL) {
-				*(cmsg->m + cmsg->l) = '\0';
-				cmsg->l++;
-			} else if (**(_cstruct *) OFF != 0xff) {
-				structTLcpy(cmsg->m + cmsg->l, *(_cstruct *) OFF, 1 + **(_cstruct *) OFF);
-				cmsg->l += 1 + **(_cstruct *) OFF;
-			} else {
-				_cstruct s = *(_cstruct *) OFF;
-				structTLcpy(cmsg->m + cmsg->l, s, 3 + *(u16 *) (s + 1));
-				cmsg->l += 3 + *(u16 *) (s + 1);
-			}
-			break;
-		case _CMSTRUCT:
-/*----- Metastruktur 0 -----*/
-			if (*(_cmstruct *) OFF == CAPI_DEFAULT) {
-				*(cmsg->m + cmsg->l) = '\0';
-				cmsg->l++;
-				jumpcstruct(cmsg);
-			}
-/*----- Metastruktur wird composed -----*/
-			else {
-				unsigned _l = cmsg->l;
-				unsigned _ls;
-				cmsg->l++;
-				cmsg->p++;
-				pars_2_message(cmsg);
-				_ls = cmsg->l - _l - 1;
-				if (_ls < 255)
-					(cmsg->m + _l)[0] = (u8) _ls;
-				else {
-					structTLcpyovl(cmsg->m + _l + 3, cmsg->m + _l + 1, _ls);
-					(cmsg->m + _l)[0] = 0xff;
-					wordTLcpy(cmsg->m + _l + 1, &_ls);
-				}
-			}
-			break;
-		}
-	}
-}
-
-/**
- * capi_cmsg2message() - assemble CAPI 2.0 message from _cmsg structure
- * @cmsg:	_cmsg structure
- * @msg:	buffer for assembled message
- *
- * Return value: 0 for success
- */
-
-unsigned capi_cmsg2message(_cmsg *cmsg, u8 *msg)
-{
-	cmsg->m = msg;
-	cmsg->l = 8;
-	cmsg->p = 0;
-	cmsg->par = capi_cmd2par(cmsg->Command, cmsg->Subcommand);
-	if (!cmsg->par)
-		return 1;	/* invalid command/subcommand */
-
-	pars_2_message(cmsg);
-
-	wordTLcpy(msg + 0, &cmsg->l);
-	byteTLcpy(cmsg->m + 4, &cmsg->Command);
-	byteTLcpy(cmsg->m + 5, &cmsg->Subcommand);
-	wordTLcpy(cmsg->m + 2, &cmsg->ApplId);
-	wordTLcpy(cmsg->m + 6, &cmsg->Messagenumber);
-
-	return 0;
-}
-
-/*-------------------------------------------------------*/
-static void message_2_pars(_cmsg *cmsg)
-{
-	for (; TYP != _CEND; cmsg->p++) {
-
-		switch (TYP) {
-		case _CBYTE:
-			byteTRcpy(cmsg->m + cmsg->l, OFF);
-			cmsg->l++;
-			break;
-		case _CWORD:
-			wordTRcpy(cmsg->m + cmsg->l, OFF);
-			cmsg->l += 2;
-			break;
-		case _CDWORD:
-			dwordTRcpy(cmsg->m + cmsg->l, OFF);
-			cmsg->l += 4;
-			break;
-		case _CSTRUCT:
-			*(u8 **) OFF = cmsg->m + cmsg->l;
-
-			if (cmsg->m[cmsg->l] != 0xff)
-				cmsg->l += 1 + cmsg->m[cmsg->l];
-			else
-				cmsg->l += 3 + *(u16 *) (cmsg->m + cmsg->l + 1);
-			break;
-		case _CMSTRUCT:
-/*----- Metastruktur 0 -----*/
-			if (cmsg->m[cmsg->l] == '\0') {
-				*(_cmstruct *) OFF = CAPI_DEFAULT;
-				cmsg->l++;
-				jumpcstruct(cmsg);
-			} else {
-				unsigned _l = cmsg->l;
-				*(_cmstruct *) OFF = CAPI_COMPOSE;
-				cmsg->l = (cmsg->m + _l)[0] == 255 ? cmsg->l + 3 : cmsg->l + 1;
-				cmsg->p++;
-				message_2_pars(cmsg);
-			}
-			break;
-		}
-	}
-}
-
-/**
- * capi_message2cmsg() - disassemble CAPI 2.0 message into _cmsg structure
- * @cmsg:	_cmsg structure
- * @msg:	buffer for assembled message
- *
- * Return value: 0 for success
- */
-
-unsigned capi_message2cmsg(_cmsg *cmsg, u8 *msg)
-{
-	memset(cmsg, 0, sizeof(_cmsg));
-	cmsg->m = msg;
-	cmsg->l = 8;
-	cmsg->p = 0;
-	byteTRcpy(cmsg->m + 4, &cmsg->Command);
-	byteTRcpy(cmsg->m + 5, &cmsg->Subcommand);
-	cmsg->par = capi_cmd2par(cmsg->Command, cmsg->Subcommand);
-	if (!cmsg->par)
-		return 1;	/* invalid command/subcommand */
-
-	message_2_pars(cmsg);
-
-	wordTRcpy(msg + 0, &cmsg->l);
-	wordTRcpy(cmsg->m + 2, &cmsg->ApplId);
-	wordTRcpy(cmsg->m + 6, &cmsg->Messagenumber);
-
-	return 0;
-}
-
-/**
- * capi_cmsg_header() - initialize header part of _cmsg structure
- * @cmsg:	_cmsg structure
- * @_ApplId:	ApplID field value
- * @_Command:	Command field value
- * @_Subcommand:	Subcommand field value
- * @_Messagenumber:	Message Number field value
- * @_Controller:	Controller/PLCI/NCCI field value
- *
- * Return value: 0 for success
- */
-
-unsigned capi_cmsg_header(_cmsg *cmsg, u16 _ApplId,
-			  u8 _Command, u8 _Subcommand,
-			  u16 _Messagenumber, u32 _Controller)
-{
-	memset(cmsg, 0, sizeof(_cmsg));
-	cmsg->ApplId = _ApplId;
-	cmsg->Command = _Command;
-	cmsg->Subcommand = _Subcommand;
-	cmsg->Messagenumber = _Messagenumber;
-	cmsg->adr.adrController = _Controller;
-	return 0;
-}
 
 /*-------------------------------------------------------*/
 
@@ -561,8 +379,6 @@ static char *pnames[] =
 	/*2f */ "Useruserdata"
 };
 
-
-
 #include <stdarg.h>
 
 /*-------------------------------------------------------*/
@@ -800,37 +616,6 @@ _cdebbuf *capi_message2str(u8 *msg)
 	return cdb;
 }
 
-/**
- * capi_cmsg2str() - format _cmsg structure for printing
- * @cmsg:	_cmsg structure
- *
- * Allocates a CAPI debug buffer and fills it with a printable representation
- * of the CAPI 2.0 message stored in @cmsg by a previous call to
- * capi_cmsg2message() or capi_message2cmsg().
- * Return value: allocated debug buffer, NULL on error
- * The returned buffer should be freed by a call to cdebbuf_free() after use.
- */
-
-_cdebbuf *capi_cmsg2str(_cmsg *cmsg)
-{
-	_cdebbuf *cdb;
-
-	if (!cmsg->m)
-		return NULL;	/* no message */
-	cdb = cdebbuf_alloc();
-	if (!cdb)
-		return NULL;
-	cmsg->l = 8;
-	cmsg->p = 0;
-	cdb = bufprint(cdb, "%s ID=%03d #0x%04x LEN=%04d\n",
-		       capi_cmd2str(cmsg->Command, cmsg->Subcommand),
-		       ((u16 *) cmsg->m)[1],
-		       ((u16 *) cmsg->m)[3],
-		       ((u16 *) cmsg->m)[0]);
-	cdb = protocol_message_2_pars(cdb, cmsg, 1);
-	return cdb;
-}
-
 int __init cdebug_init(void)
 {
 	g_cmsg = kmalloc(sizeof(_cmsg), GFP_KERNEL);
@@ -854,7 +639,7 @@ int __init cdebug_init(void)
 	return 0;
 }
 
-void __exit cdebug_exit(void)
+void cdebug_exit(void)
 {
 	if (g_debbuf)
 		kfree(g_debbuf->buf);
@@ -885,16 +670,8 @@ int __init cdebug_init(void)
 	return 0;
 }
 
-void __exit cdebug_exit(void)
+void cdebug_exit(void)
 {
 }
 
 #endif
-
-EXPORT_SYMBOL(cdebbuf_free);
-EXPORT_SYMBOL(capi_cmsg2message);
-EXPORT_SYMBOL(capi_message2cmsg);
-EXPORT_SYMBOL(capi_cmsg_header);
-EXPORT_SYMBOL(capi_cmd2str);
-EXPORT_SYMBOL(capi_cmsg2str);
-EXPORT_SYMBOL(capi_message2str);
diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index a4ceb61c5b60..7168778fbbe1 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -10,8 +10,6 @@
  *
  */
 
-#define AVMB1_COMPAT
-
 #include "kcapi.h"
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -31,18 +29,12 @@
 #include <linux/uaccess.h>
 #include <linux/isdn/capicmd.h>
 #include <linux/isdn/capiutil.h>
-#ifdef AVMB1_COMPAT
-#include <linux/b1lli.h>
-#endif
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 
 static int showcapimsgs = 0;
 static struct workqueue_struct *kcapi_wq;
 
-MODULE_DESCRIPTION("CAPI4Linux: kernel CAPI layer");
-MODULE_AUTHOR("Carsten Paeth");
-MODULE_LICENSE("GPL");
 module_param(showcapimsgs, uint, 0);
 
 /* ------------------------------------------------------------- */
@@ -61,9 +53,6 @@ static char capi_manufakturer[64] = "AVM Berlin";
 
 #define NCCI2CTRL(ncci)    (((ncci) >> 24) & 0x7f)
 
-LIST_HEAD(capi_drivers);
-DEFINE_MUTEX(capi_drivers_lock);
-
 struct capi_ctr *capi_controller[CAPI_MAXCONTR];
 DEFINE_MUTEX(capi_controller_lock);
 
@@ -71,8 +60,6 @@ struct capi20_appl *capi_applications[CAPI_MAXAPPL];
 
 static int ncontrollers;
 
-static BLOCKING_NOTIFIER_HEAD(ctr_notifier_list);
-
 /* -------- controller ref counting -------------------------------------- */
 
 static inline struct capi_ctr *
@@ -200,8 +187,6 @@ static void notify_up(u32 contr)
 			if (ap)
 				register_appl(ctr, applid, &ap->rparam);
 		}
-
-		wake_up_interruptible_all(&ctr->state_wait_queue);
 	} else
 		printk(KERN_WARNING "%s: invalid contr %d\n", __func__, contr);
 
@@ -229,8 +214,6 @@ static void ctr_down(struct capi_ctr *ctr, int new_state)
 		if (ap)
 			capi_ctr_put(ctr);
 	}
-
-	wake_up_interruptible_all(&ctr->state_wait_queue);
 }
 
 static void notify_down(u32 contr)
@@ -251,36 +234,23 @@ static void notify_down(u32 contr)
 	mutex_unlock(&capi_controller_lock);
 }
 
-static int
-notify_handler(struct notifier_block *nb, unsigned long val, void *v)
+static void do_notify_work(struct work_struct *work)
 {
-	u32 contr = (long)v;
+	struct capictr_event *event =
+		container_of(work, struct capictr_event, work);
 
-	switch (val) {
+	switch (event->type) {
 	case CAPICTR_UP:
-		notify_up(contr);
+		notify_up(event->controller);
 		break;
 	case CAPICTR_DOWN:
-		notify_down(contr);
+		notify_down(event->controller);
 		break;
 	}
-	return NOTIFY_OK;
-}
 
-static void do_notify_work(struct work_struct *work)
-{
-	struct capictr_event *event =
-		container_of(work, struct capictr_event, work);
-
-	blocking_notifier_call_chain(&ctr_notifier_list, event->type,
-				     (void *)(long)event->controller);
 	kfree(event);
 }
 
-/*
- * The notifier will result in adding/deleteing of devices. Devices can
- * only removed in user process, not in bh.
- */
 static int notify_push(unsigned int event_type, u32 controller)
 {
 	struct capictr_event *event = kmalloc(sizeof(*event), GFP_ATOMIC);
@@ -296,18 +266,6 @@ static int notify_push(unsigned int event_type, u32 controller)
 	return 0;
 }
 
-int register_capictr_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&ctr_notifier_list, nb);
-}
-EXPORT_SYMBOL_GPL(register_capictr_notifier);
-
-int unregister_capictr_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&ctr_notifier_list, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_capictr_notifier);
-
 /* -------- Receiver ------------------------------------------ */
 
 static void recv_handler(struct work_struct *work)
@@ -454,48 +412,6 @@ void capi_ctr_down(struct capi_ctr *ctr)
 
 EXPORT_SYMBOL(capi_ctr_down);
 
-/**
- * capi_ctr_suspend_output() - suspend controller
- * @ctr:	controller descriptor structure.
- *
- * Called by hardware driver to stop data flow.
- *
- * Note: The caller is responsible for synchronizing concurrent state changes
- * as well as invocations of capi_ctr_handle_message.
- */
-
-void capi_ctr_suspend_output(struct capi_ctr *ctr)
-{
-	if (!ctr->blocked) {
-		printk(KERN_DEBUG "kcapi: controller [%03d] suspend\n",
-		       ctr->cnr);
-		ctr->blocked = 1;
-	}
-}
-
-EXPORT_SYMBOL(capi_ctr_suspend_output);
-
-/**
- * capi_ctr_resume_output() - resume controller
- * @ctr:	controller descriptor structure.
- *
- * Called by hardware driver to resume data flow.
- *
- * Note: The caller is responsible for synchronizing concurrent state changes
- * as well as invocations of capi_ctr_handle_message.
- */
-
-void capi_ctr_resume_output(struct capi_ctr *ctr)
-{
-	if (ctr->blocked) {
-		printk(KERN_DEBUG "kcapi: controller [%03d] resumed\n",
-		       ctr->cnr);
-		ctr->blocked = 0;
-	}
-}
-
-EXPORT_SYMBOL(capi_ctr_resume_output);
-
 /* ------------------------------------------------------------- */
 
 /**
@@ -531,7 +447,6 @@ int attach_capi_ctr(struct capi_ctr *ctr)
 	ctr->state = CAPI_CTR_DETECTED;
 	ctr->blocked = 0;
 	ctr->traceflag = showcapimsgs;
-	init_waitqueue_head(&ctr->state_wait_queue);
 
 	sprintf(ctr->procfn, "capi/controllers/%d", ctr->cnr);
 	ctr->procent = proc_create_single_data(ctr->procfn, 0, NULL,
@@ -586,38 +501,6 @@ int detach_capi_ctr(struct capi_ctr *ctr)
 
 EXPORT_SYMBOL(detach_capi_ctr);
 
-/**
- * register_capi_driver() - register CAPI driver
- * @driver:	driver descriptor structure.
- *
- * Called by hardware driver to register itself with the CAPI subsystem.
- */
-
-void register_capi_driver(struct capi_driver *driver)
-{
-	mutex_lock(&capi_drivers_lock);
-	list_add_tail(&driver->list, &capi_drivers);
-	mutex_unlock(&capi_drivers_lock);
-}
-
-EXPORT_SYMBOL(register_capi_driver);
-
-/**
- * unregister_capi_driver() - unregister CAPI driver
- * @driver:	driver descriptor structure.
- *
- * Called by hardware driver to unregister itself from the CAPI subsystem.
- */
-
-void unregister_capi_driver(struct capi_driver *driver)
-{
-	mutex_lock(&capi_drivers_lock);
-	list_del(&driver->list);
-	mutex_unlock(&capi_drivers_lock);
-}
-
-EXPORT_SYMBOL(unregister_capi_driver);
-
 /* ------------------------------------------------------------- */
 /* -------- CAPI2.0 Interface ---------------------------------- */
 /* ------------------------------------------------------------- */
@@ -648,8 +531,6 @@ u16 capi20_isinstalled(void)
 	return ret;
 }
 
-EXPORT_SYMBOL(capi20_isinstalled);
-
 /**
  * capi20_register() - CAPI 2.0 operation CAPI_REGISTER
  * @ap:		CAPI application descriptor structure.
@@ -711,8 +592,6 @@ u16 capi20_register(struct capi20_appl *ap)
 	return CAPI_NOERROR;
 }
 
-EXPORT_SYMBOL(capi20_register);
-
 /**
  * capi20_release() - CAPI 2.0 operation CAPI_RELEASE
  * @ap:		CAPI application descriptor structure.
@@ -755,8 +634,6 @@ u16 capi20_release(struct capi20_appl *ap)
 	return CAPI_NOERROR;
 }
 
-EXPORT_SYMBOL(capi20_release);
-
 /**
  * capi20_put_message() - CAPI 2.0 operation CAPI_PUT_MESSAGE
  * @ap:		CAPI application descriptor structure.
@@ -834,8 +711,6 @@ u16 capi20_put_message(struct capi20_appl *ap, struct sk_buff *skb)
 	return ctr->send_message(ctr, skb);
 }
 
-EXPORT_SYMBOL(capi20_put_message);
-
 /**
  * capi20_get_manufacturer() - CAPI 2.0 operation CAPI_GET_MANUFACTURER
  * @contr:	controller number.
@@ -869,8 +744,6 @@ u16 capi20_get_manufacturer(u32 contr, u8 *buf)
 	return ret;
 }
 
-EXPORT_SYMBOL(capi20_get_manufacturer);
-
 /**
  * capi20_get_version() - CAPI 2.0 operation CAPI_GET_VERSION
  * @contr:	controller number.
@@ -904,8 +777,6 @@ u16 capi20_get_version(u32 contr, struct capi_version *verp)
 	return ret;
 }
 
-EXPORT_SYMBOL(capi20_get_version);
-
 /**
  * capi20_get_serial() - CAPI 2.0 operation CAPI_GET_SERIAL_NUMBER
  * @contr:	controller number.
@@ -939,8 +810,6 @@ u16 capi20_get_serial(u32 contr, u8 *serial)
 	return ret;
 }
 
-EXPORT_SYMBOL(capi20_get_serial);
-
 /**
  * capi20_get_profile() - CAPI 2.0 operation CAPI_GET_PROFILE
  * @contr:	controller number.
@@ -974,209 +843,6 @@ u16 capi20_get_profile(u32 contr, struct capi_profile *profp)
 	return ret;
 }
 
-EXPORT_SYMBOL(capi20_get_profile);
-
-/* Must be called with capi_controller_lock held. */
-static int wait_on_ctr_state(struct capi_ctr *ctr, unsigned int state)
-{
-	DEFINE_WAIT(wait);
-	int retval = 0;
-
-	ctr = capi_ctr_get(ctr);
-	if (!ctr)
-		return -ESRCH;
-
-	for (;;) {
-		prepare_to_wait(&ctr->state_wait_queue, &wait,
-				TASK_INTERRUPTIBLE);
-
-		if (ctr->state == state)
-			break;
-		if (ctr->state == CAPI_CTR_DETACHED) {
-			retval = -ESRCH;
-			break;
-		}
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			break;
-		}
-
-		mutex_unlock(&capi_controller_lock);
-		schedule();
-		mutex_lock(&capi_controller_lock);
-	}
-	finish_wait(&ctr->state_wait_queue, &wait);
-
-	capi_ctr_put(ctr);
-
-	return retval;
-}
-
-#ifdef AVMB1_COMPAT
-static int old_capi_manufacturer(unsigned int cmd, void __user *data)
-{
-	avmb1_loadandconfigdef ldef;
-	avmb1_extcarddef cdef;
-	avmb1_resetdef rdef;
-	capicardparams cparams;
-	struct capi_ctr *ctr;
-	struct capi_driver *driver = NULL;
-	capiloaddata ldata;
-	struct list_head *l;
-	int retval;
-
-	switch (cmd) {
-	case AVMB1_ADDCARD:
-	case AVMB1_ADDCARD_WITH_TYPE:
-		if (cmd == AVMB1_ADDCARD) {
-			if ((retval = copy_from_user(&cdef, data,
-						     sizeof(avmb1_carddef))))
-				return -EFAULT;
-			cdef.cardtype = AVM_CARDTYPE_B1;
-			cdef.cardnr = 0;
-		} else {
-			if ((retval = copy_from_user(&cdef, data,
-						     sizeof(avmb1_extcarddef))))
-				return -EFAULT;
-		}
-		cparams.port = cdef.port;
-		cparams.irq = cdef.irq;
-		cparams.cardnr = cdef.cardnr;
-
-		mutex_lock(&capi_drivers_lock);
-
-		switch (cdef.cardtype) {
-		case AVM_CARDTYPE_B1:
-			list_for_each(l, &capi_drivers) {
-				driver = list_entry(l, struct capi_driver, list);
-				if (strcmp(driver->name, "b1isa") == 0)
-					break;
-			}
-			break;
-		case AVM_CARDTYPE_T1:
-			list_for_each(l, &capi_drivers) {
-				driver = list_entry(l, struct capi_driver, list);
-				if (strcmp(driver->name, "t1isa") == 0)
-					break;
-			}
-			break;
-		default:
-			driver = NULL;
-			break;
-		}
-		if (!driver) {
-			printk(KERN_ERR "kcapi: driver not loaded.\n");
-			retval = -EIO;
-		} else if (!driver->add_card) {
-			printk(KERN_ERR "kcapi: driver has no add card function.\n");
-			retval = -EIO;
-		} else
-			retval = driver->add_card(driver, &cparams);
-
-		mutex_unlock(&capi_drivers_lock);
-		return retval;
-
-	case AVMB1_LOAD:
-	case AVMB1_LOAD_AND_CONFIG:
-
-		if (cmd == AVMB1_LOAD) {
-			if (copy_from_user(&ldef, data,
-					   sizeof(avmb1_loaddef)))
-				return -EFAULT;
-			ldef.t4config.len = 0;
-			ldef.t4config.data = NULL;
-		} else {
-			if (copy_from_user(&ldef, data,
-					   sizeof(avmb1_loadandconfigdef)))
-				return -EFAULT;
-		}
-
-		mutex_lock(&capi_controller_lock);
-
-		ctr = get_capi_ctr_by_nr(ldef.contr);
-		if (!ctr) {
-			retval = -EINVAL;
-			goto load_unlock_out;
-		}
-
-		if (ctr->load_firmware == NULL) {
-			printk(KERN_DEBUG "kcapi: load: no load function\n");
-			retval = -ESRCH;
-			goto load_unlock_out;
-		}
-
-		if (ldef.t4file.len <= 0) {
-			printk(KERN_DEBUG "kcapi: load: invalid parameter: length of t4file is %d ?\n", ldef.t4file.len);
-			retval = -EINVAL;
-			goto load_unlock_out;
-		}
-		if (ldef.t4file.data == NULL) {
-			printk(KERN_DEBUG "kcapi: load: invalid parameter: dataptr is 0\n");
-			retval = -EINVAL;
-			goto load_unlock_out;
-		}
-
-		ldata.firmware.user = 1;
-		ldata.firmware.data = ldef.t4file.data;
-		ldata.firmware.len = ldef.t4file.len;
-		ldata.configuration.user = 1;
-		ldata.configuration.data = ldef.t4config.data;
-		ldata.configuration.len = ldef.t4config.len;
-
-		if (ctr->state != CAPI_CTR_DETECTED) {
-			printk(KERN_INFO "kcapi: load: contr=%d not in detect state\n", ldef.contr);
-			retval = -EBUSY;
-			goto load_unlock_out;
-		}
-		ctr->state = CAPI_CTR_LOADING;
-
-		retval = ctr->load_firmware(ctr, &ldata);
-		if (retval) {
-			ctr->state = CAPI_CTR_DETECTED;
-			goto load_unlock_out;
-		}
-
-		retval = wait_on_ctr_state(ctr, CAPI_CTR_RUNNING);
-
-	load_unlock_out:
-		mutex_unlock(&capi_controller_lock);
-		return retval;
-
-	case AVMB1_RESETCARD:
-		if (copy_from_user(&rdef, data, sizeof(avmb1_resetdef)))
-			return -EFAULT;
-
-		retval = 0;
-
-		mutex_lock(&capi_controller_lock);
-
-		ctr = get_capi_ctr_by_nr(rdef.contr);
-		if (!ctr) {
-			retval = -ESRCH;
-			goto reset_unlock_out;
-		}
-
-		if (ctr->state == CAPI_CTR_DETECTED)
-			goto reset_unlock_out;
-
-		if (ctr->reset_ctr == NULL) {
-			printk(KERN_DEBUG "kcapi: reset: no reset function\n");
-			retval = -ESRCH;
-			goto reset_unlock_out;
-		}
-
-		ctr->reset_ctr(ctr);
-
-		retval = wait_on_ctr_state(ctr, CAPI_CTR_DETECTED);
-
-	reset_unlock_out:
-		mutex_unlock(&capi_controller_lock);
-		return retval;
-	}
-	return -EINVAL;
-}
-#endif
-
 /**
  * capi20_manufacturer() - CAPI 2.0 operation CAPI_MANUFACTURER
  * @cmd:	command.
@@ -1192,14 +858,6 @@ int capi20_manufacturer(unsigned long cmd, void __user *data)
 	int retval;
 
 	switch (cmd) {
-#ifdef AVMB1_COMPAT
-	case AVMB1_LOAD:
-	case AVMB1_LOAD_AND_CONFIG:
-	case AVMB1_RESETCARD:
-	case AVMB1_GET_CARDINFO:
-	case AVMB1_REMOVECARD:
-		return old_capi_manufacturer(cmd, data);
-#endif
 	case KCAPI_CMD_TRACE:
 	{
 		kcapi_flagdef fdef;
@@ -1222,43 +880,6 @@ int capi20_manufacturer(unsigned long cmd, void __user *data)
 
 		return retval;
 	}
-	case KCAPI_CMD_ADDCARD:
-	{
-		struct list_head *l;
-		struct capi_driver *driver = NULL;
-		capicardparams cparams;
-		kcapi_carddef cdef;
-
-		if ((retval = copy_from_user(&cdef, data, sizeof(cdef))))
-			return -EFAULT;
-
-		cparams.port = cdef.port;
-		cparams.irq = cdef.irq;
-		cparams.membase = cdef.membase;
-		cparams.cardnr = cdef.cardnr;
-		cparams.cardtype = 0;
-		cdef.driver[sizeof(cdef.driver) - 1] = 0;
-
-		mutex_lock(&capi_drivers_lock);
-
-		list_for_each(l, &capi_drivers) {
-			driver = list_entry(l, struct capi_driver, list);
-			if (strcmp(driver->name, cdef.driver) == 0)
-				break;
-		}
-		if (driver == NULL) {
-			printk(KERN_ERR "kcapi: driver \"%s\" not loaded.\n",
-			       cdef.driver);
-			retval = -ESRCH;
-		} else if (!driver->add_card) {
-			printk(KERN_ERR "kcapi: driver \"%s\" has no add card function.\n", cdef.driver);
-			retval = -EIO;
-		} else
-			retval = driver->add_card(driver, &cparams);
-
-		mutex_unlock(&capi_drivers_lock);
-		return retval;
-	}
 
 	default:
 		printk(KERN_ERR "kcapi: manufacturer command %lu unknown.\n",
@@ -1269,8 +890,6 @@ int capi20_manufacturer(unsigned long cmd, void __user *data)
 	return -EINVAL;
 }
 
-EXPORT_SYMBOL(capi20_manufacturer);
-
 /* ------------------------------------------------------------- */
 /* -------- Init & Cleanup ------------------------------------- */
 /* ------------------------------------------------------------- */
@@ -1279,12 +898,7 @@ EXPORT_SYMBOL(capi20_manufacturer);
  * init / exit functions
  */
 
-static struct notifier_block capictr_nb = {
-	.notifier_call = notify_handler,
-	.priority = INT_MAX,
-};
-
-static int __init kcapi_init(void)
+int __init kcapi_init(void)
 {
 	int err;
 
@@ -1292,11 +906,8 @@ static int __init kcapi_init(void)
 	if (!kcapi_wq)
 		return -ENOMEM;
 
-	register_capictr_notifier(&capictr_nb);
-
 	err = cdebug_init();
 	if (err) {
-		unregister_capictr_notifier(&capictr_nb);
 		destroy_workqueue(kcapi_wq);
 		return err;
 	}
@@ -1305,14 +916,10 @@ static int __init kcapi_init(void)
 	return 0;
 }
 
-static void __exit kcapi_exit(void)
+void kcapi_exit(void)
 {
 	kcapi_proc_exit();
 
-	unregister_capictr_notifier(&capictr_nb);
 	cdebug_exit();
 	destroy_workqueue(kcapi_wq);
 }
-
-module_init(kcapi_init);
-module_exit(kcapi_exit);
diff --git a/drivers/isdn/capi/kcapi.h b/drivers/isdn/capi/kcapi.h
index 6d439f9a76b2..479623e1db2a 100644
--- a/drivers/isdn/capi/kcapi.h
+++ b/drivers/isdn/capi/kcapi.h
@@ -30,22 +30,153 @@ enum {
 	CAPI_CTR_RUNNING  = 3,
 };
 
-extern struct list_head capi_drivers;
-extern struct mutex capi_drivers_lock;
-
 extern struct capi_ctr *capi_controller[CAPI_MAXCONTR];
 extern struct mutex capi_controller_lock;
 
 extern struct capi20_appl *capi_applications[CAPI_MAXAPPL];
 
-#ifdef CONFIG_PROC_FS
-
 void kcapi_proc_init(void);
 void kcapi_proc_exit(void);
 
-#else
+struct capi20_appl {
+	u16 applid;
+	capi_register_params rparam;
+	void (*recv_message)(struct capi20_appl *ap, struct sk_buff *skb);
+	void *private;
 
-static inline void kcapi_proc_init(void) { };
-static inline void kcapi_proc_exit(void) { };
+	/* internal to kernelcapi.o */
+	unsigned long nrecvctlpkt;
+	unsigned long nrecvdatapkt;
+	unsigned long nsentctlpkt;
+	unsigned long nsentdatapkt;
+	struct mutex recv_mtx;
+	struct sk_buff_head recv_queue;
+	struct work_struct recv_work;
+	int release_in_progress;
+};
 
-#endif
+u16 capi20_isinstalled(void);
+u16 capi20_register(struct capi20_appl *ap);
+u16 capi20_release(struct capi20_appl *ap);
+u16 capi20_put_message(struct capi20_appl *ap, struct sk_buff *skb);
+u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN]);
+u16 capi20_get_version(u32 contr, struct capi_version *verp);
+u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN]);
+u16 capi20_get_profile(u32 contr, struct capi_profile *profp);
+int capi20_manufacturer(unsigned long cmd, void __user *data);
+
+#define CAPICTR_UP			0
+#define CAPICTR_DOWN			1
+
+int kcapi_init(void);
+void kcapi_exit(void);
+
+/*----- basic-type definitions -----*/
+
+typedef __u8 *_cstruct;
+
+typedef enum {
+	CAPI_COMPOSE,
+	CAPI_DEFAULT
+} _cmstruct;
+
+/*
+   The _cmsg structure contains all possible CAPI 2.0 parameter.
+   All parameters are stored here first. The function CAPI_CMSG_2_MESSAGE
+   assembles the parameter and builds CAPI2.0 conform messages.
+   CAPI_MESSAGE_2_CMSG disassembles CAPI 2.0 messages and stores the
+   parameter in the _cmsg structure
+ */
+
+typedef struct {
+	/* Header */
+	__u16 ApplId;
+	__u8 Command;
+	__u8 Subcommand;
+	__u16 Messagenumber;
+
+	/* Parameter */
+	union {
+		__u32 adrController;
+		__u32 adrPLCI;
+		__u32 adrNCCI;
+	} adr;
+
+	_cmstruct AdditionalInfo;
+	_cstruct B1configuration;
+	__u16 B1protocol;
+	_cstruct B2configuration;
+	__u16 B2protocol;
+	_cstruct B3configuration;
+	__u16 B3protocol;
+	_cstruct BC;
+	_cstruct BChannelinformation;
+	_cmstruct BProtocol;
+	_cstruct CalledPartyNumber;
+	_cstruct CalledPartySubaddress;
+	_cstruct CallingPartyNumber;
+	_cstruct CallingPartySubaddress;
+	__u32 CIPmask;
+	__u32 CIPmask2;
+	__u16 CIPValue;
+	__u32 Class;
+	_cstruct ConnectedNumber;
+	_cstruct ConnectedSubaddress;
+	__u32 Data;
+	__u16 DataHandle;
+	__u16 DataLength;
+	_cstruct FacilityConfirmationParameter;
+	_cstruct Facilitydataarray;
+	_cstruct FacilityIndicationParameter;
+	_cstruct FacilityRequestParameter;
+	__u16 FacilitySelector;
+	__u16 Flags;
+	__u32 Function;
+	_cstruct HLC;
+	__u16 Info;
+	_cstruct InfoElement;
+	__u32 InfoMask;
+	__u16 InfoNumber;
+	_cstruct Keypadfacility;
+	_cstruct LLC;
+	_cstruct ManuData;
+	__u32 ManuID;
+	_cstruct NCPI;
+	__u16 Reason;
+	__u16 Reason_B3;
+	__u16 Reject;
+	_cstruct Useruserdata;
+
+	/* intern */
+	unsigned l, p;
+	unsigned char *par;
+	__u8 *m;
+
+	/* buffer to construct message */
+	__u8 buf[180];
+
+} _cmsg;
+
+/*-----------------------------------------------------------------------*/
+
+/*
+ * Debugging / Tracing functions
+ */
+
+char *capi_cmd2str(__u8 cmd, __u8 subcmd);
+
+typedef struct {
+	u_char	*buf;
+	u_char	*p;
+	size_t	size;
+	size_t	pos;
+} _cdebbuf;
+
+#define	CDEBUG_SIZE	1024
+#define	CDEBUG_GSIZE	4096
+
+void cdebbuf_free(_cdebbuf *cdb);
+int cdebug_init(void);
+void cdebug_exit(void);
+
+_cdebbuf *capi_message2str(__u8 *msg);
diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index 28cd051f1dfd..eadbe59b3753 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -192,37 +192,15 @@ static const struct seq_operations seq_applstats_ops = {
 
 // ---------------------------------------------------------------------------
 
-static void *capi_driver_start(struct seq_file *seq, loff_t *pos)
-	__acquires(&capi_drivers_lock)
+/* /proc/capi/drivers is always empty */
+static ssize_t empty_read(struct file *file, char __user *buf,
+			  size_t size, loff_t *off)
 {
-	mutex_lock(&capi_drivers_lock);
-	return seq_list_start(&capi_drivers, *pos);
-}
-
-static void *capi_driver_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	return seq_list_next(v, &capi_drivers, pos);
-}
-
-static void capi_driver_stop(struct seq_file *seq, void *v)
-	__releases(&capi_drivers_lock)
-{
-	mutex_unlock(&capi_drivers_lock);
-}
-
-static int capi_driver_show(struct seq_file *seq, void *v)
-{
-	struct capi_driver *drv = list_entry(v, struct capi_driver, list);
-
-	seq_printf(seq, "%-32s %s\n", drv->name, drv->revision);
 	return 0;
 }
 
-static const struct seq_operations seq_capi_driver_ops = {
-	.start	= capi_driver_start,
-	.next	= capi_driver_next,
-	.stop	= capi_driver_stop,
-	.show	= capi_driver_show,
+static const struct file_operations empty_fops = {
+	.read	= empty_read,
 };
 
 // ---------------------------------------------------------------------------
@@ -236,7 +214,7 @@ kcapi_proc_init(void)
 	proc_create_seq("capi/contrstats",   0, NULL, &seq_contrstats_ops);
 	proc_create_seq("capi/applications", 0, NULL, &seq_applications_ops);
 	proc_create_seq("capi/applstats",    0, NULL, &seq_applstats_ops);
-	proc_create_seq("capi/driver",       0, NULL, &seq_capi_driver_ops);
+	proc_create("capi/driver",           0, NULL, &empty_fops);
 }
 
 void
diff --git a/include/linux/isdn/capilli.h b/include/linux/isdn/capilli.h
index d75e1ad72964..12be09b6883b 100644
--- a/include/linux/isdn/capilli.h
+++ b/include/linux/isdn/capilli.h
@@ -69,7 +69,6 @@ struct capi_ctr {
 	unsigned short state;			/* controller state */
 	int blocked;				/* output blocked */
 	int traceflag;				/* capi trace */
-	wait_queue_head_t state_wait_queue;
 
 	struct proc_dir_entry *procent;
         char procfn[128];
@@ -80,8 +79,6 @@ int detach_capi_ctr(struct capi_ctr *);
 
 void capi_ctr_ready(struct capi_ctr * card);
 void capi_ctr_down(struct capi_ctr * card);
-void capi_ctr_suspend_output(struct capi_ctr * card);
-void capi_ctr_resume_output(struct capi_ctr * card);
 void capi_ctr_handle_message(struct capi_ctr * card, u16 appl, struct sk_buff *skb);
 
 // ---------------------------------------------------------------------------
@@ -91,23 +88,8 @@ struct capi_driver {
 	char name[32];				/* driver name */
 	char revision[32];
 
-	int (*add_card)(struct capi_driver *driver, capicardparams *data);
-
 	/* management information for kcapi */
 	struct list_head list; 
 };
 
-void register_capi_driver(struct capi_driver *driver);
-void unregister_capi_driver(struct capi_driver *driver);
-
-// ---------------------------------------------------------------------------
-// library functions for use by hardware controller drivers
-
-void capilib_new_ncci(struct list_head *head, u16 applid, u32 ncci, u32 winsize);
-void capilib_free_ncci(struct list_head *head, u16 applid, u32 ncci);
-void capilib_release_appl(struct list_head *head, u16 applid);
-void capilib_release(struct list_head *head);
-void capilib_data_b3_conf(struct list_head *head, u16 applid, u32 ncci, u16 msgid);
-u16  capilib_data_b3_req(struct list_head *head, u16 applid, u32 ncci, u16 msgid);
-
 #endif				/* __CAPILLI_H__ */
diff --git a/include/linux/isdn/capiutil.h b/include/linux/isdn/capiutil.h
index 44bd6046e6e2..953fd500dff7 100644
--- a/include/linux/isdn/capiutil.h
+++ b/include/linux/isdn/capiutil.h
@@ -57,460 +57,4 @@ static inline void capimsg_setu32(void *m, int off, __u32 val)
 #define	CAPIMSG_SETCONTROL(m, contr)	capimsg_setu32(m, 8, contr)
 #define	CAPIMSG_SETDATALEN(m, len)	capimsg_setu16(m, 16, len)
 
-/*----- basic-type definitions -----*/
-
-typedef __u8 *_cstruct;
-
-typedef enum {
-	CAPI_COMPOSE,
-	CAPI_DEFAULT
-} _cmstruct;
-
-/*
-   The _cmsg structure contains all possible CAPI 2.0 parameter.
-   All parameters are stored here first. The function CAPI_CMSG_2_MESSAGE
-   assembles the parameter and builds CAPI2.0 conform messages.
-   CAPI_MESSAGE_2_CMSG disassembles CAPI 2.0 messages and stores the
-   parameter in the _cmsg structure
- */
-
-typedef struct {
-	/* Header */
-	__u16 ApplId;
-	__u8 Command;
-	__u8 Subcommand;
-	__u16 Messagenumber;
-
-	/* Parameter */
-	union {
-		__u32 adrController;
-		__u32 adrPLCI;
-		__u32 adrNCCI;
-	} adr;
-
-	_cmstruct AdditionalInfo;
-	_cstruct B1configuration;
-	__u16 B1protocol;
-	_cstruct B2configuration;
-	__u16 B2protocol;
-	_cstruct B3configuration;
-	__u16 B3protocol;
-	_cstruct BC;
-	_cstruct BChannelinformation;
-	_cmstruct BProtocol;
-	_cstruct CalledPartyNumber;
-	_cstruct CalledPartySubaddress;
-	_cstruct CallingPartyNumber;
-	_cstruct CallingPartySubaddress;
-	__u32 CIPmask;
-	__u32 CIPmask2;
-	__u16 CIPValue;
-	__u32 Class;
-	_cstruct ConnectedNumber;
-	_cstruct ConnectedSubaddress;
-	__u32 Data;
-	__u16 DataHandle;
-	__u16 DataLength;
-	_cstruct FacilityConfirmationParameter;
-	_cstruct Facilitydataarray;
-	_cstruct FacilityIndicationParameter;
-	_cstruct FacilityRequestParameter;
-	__u16 FacilitySelector;
-	__u16 Flags;
-	__u32 Function;
-	_cstruct HLC;
-	__u16 Info;
-	_cstruct InfoElement;
-	__u32 InfoMask;
-	__u16 InfoNumber;
-	_cstruct Keypadfacility;
-	_cstruct LLC;
-	_cstruct ManuData;
-	__u32 ManuID;
-	_cstruct NCPI;
-	__u16 Reason;
-	__u16 Reason_B3;
-	__u16 Reject;
-	_cstruct Useruserdata;
-
-	/* intern */
-	unsigned l, p;
-	unsigned char *par;
-	__u8 *m;
-
-	/* buffer to construct message */
-	__u8 buf[180];
-
-} _cmsg;
-
-/*
- * capi_cmsg2message() assembles the parameter from _cmsg to a CAPI 2.0
- * conform message
- */
-unsigned capi_cmsg2message(_cmsg * cmsg, __u8 * msg);
-
-/*
- *  capi_message2cmsg disassembles a CAPI message an writes the parameter
- *  into _cmsg for easy access
- */
-unsigned capi_message2cmsg(_cmsg * cmsg, __u8 * msg);
-
-/*
- * capi_cmsg_header() fills the _cmsg structure with default values, so only
- * parameter with non default values must be changed before sending the
- * message.
- */
-unsigned capi_cmsg_header(_cmsg * cmsg, __u16 _ApplId,
-			  __u8 _Command, __u8 _Subcommand,
-			  __u16 _Messagenumber, __u32 _Controller);
-
-/*-----------------------------------------------------------------------*/
-
-/*
- * Debugging / Tracing functions
- */
-
-char *capi_cmd2str(__u8 cmd, __u8 subcmd);
-
-typedef struct {
-	u_char	*buf;
-	u_char	*p;
-	size_t	size;
-	size_t	pos;
-} _cdebbuf;
-
-#define	CDEBUG_SIZE	1024
-#define	CDEBUG_GSIZE	4096
-
-void cdebbuf_free(_cdebbuf *cdb);
-int cdebug_init(void);
-void cdebug_exit(void);
-
-_cdebbuf *capi_cmsg2str(_cmsg *cmsg);
-_cdebbuf *capi_message2str(__u8 *msg);
-
-/*-----------------------------------------------------------------------*/
-
-static inline void capi_cmsg_answer(_cmsg * cmsg)
-{
-	cmsg->Subcommand |= 0x01;
-}
-
-/*-----------------------------------------------------------------------*/
-
-static inline void capi_fill_CONNECT_B3_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					    __u32 adr,
-					    _cstruct NCPI)
-{
-	capi_cmsg_header(cmsg, ApplId, 0x82, 0x80, Messagenumber, adr);
-	cmsg->NCPI = NCPI;
-}
-
-static inline void capi_fill_FACILITY_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					  __u32 adr,
-					  __u16 FacilitySelector,
-				       _cstruct FacilityRequestParameter)
-{
-	capi_cmsg_header(cmsg, ApplId, 0x80, 0x80, Messagenumber, adr);
-	cmsg->FacilitySelector = FacilitySelector;
-	cmsg->FacilityRequestParameter = FacilityRequestParameter;
-}
-
-static inline void capi_fill_INFO_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-				      __u32 adr,
-				      _cstruct CalledPartyNumber,
-				      _cstruct BChannelinformation,
-				      _cstruct Keypadfacility,
-				      _cstruct Useruserdata,
-				      _cstruct Facilitydataarray)
-{
-	capi_cmsg_header(cmsg, ApplId, 0x08, 0x80, Messagenumber, adr);
-	cmsg->CalledPartyNumber = CalledPartyNumber;
-	cmsg->BChannelinformation = BChannelinformation;
-	cmsg->Keypadfacility = Keypadfacility;
-	cmsg->Useruserdata = Useruserdata;
-	cmsg->Facilitydataarray = Facilitydataarray;
-}
-
-static inline void capi_fill_LISTEN_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					__u32 adr,
-					__u32 InfoMask,
-					__u32 CIPmask,
-					__u32 CIPmask2,
-					_cstruct CallingPartyNumber,
-					_cstruct CallingPartySubaddress)
-{
-	capi_cmsg_header(cmsg, ApplId, 0x05, 0x80, Messagenumber, adr);
-	cmsg->InfoMask = InfoMask;
-	cmsg->CIPmask = CIPmask;
-	cmsg->CIPmask2 = CIPmask2;
-	cmsg->CallingPartyNumber = CallingPartyNumber;
-	cmsg->CallingPartySubaddress = CallingPartySubaddress;
-}
-
-static inline void capi_fill_ALERT_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-				       __u32 adr,
-				       _cstruct BChannelinformation,
-				       _cstruct Keypadfacility,
-				       _cstruct Useruserdata,
-				       _cstruct Facilitydataarray)
-{
-	capi_cmsg_header(cmsg, ApplId, 0x01, 0x80, Messagenumber, adr);
-	cmsg->BChannelinformation = BChannelinformation;
-	cmsg->Keypadfacility = Keypadfacility;
-	cmsg->Useruserdata = Useruserdata;
-	cmsg->Facilitydataarray = Facilitydataarray;
-}
-
-static inline void capi_fill_CONNECT_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					 __u32 adr,
-					 __u16 CIPValue,
-					 _cstruct CalledPartyNumber,
-					 _cstruct CallingPartyNumber,
-					 _cstruct CalledPartySubaddress,
-					 _cstruct CallingPartySubaddress,
-					 __u16 B1protocol,
-					 __u16 B2protocol,
-					 __u16 B3protocol,
-					 _cstruct B1configuration,
-					 _cstruct B2configuration,
-					 _cstruct B3configuration,
-					 _cstruct BC,
-					 _cstruct LLC,
-					 _cstruct HLC,
-					 _cstruct BChannelinformation,
-					 _cstruct Keypadfacility,
-					 _cstruct Useruserdata,
-					 _cstruct Facilitydataarray)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x02, 0x80, Messagenumber, adr);
-	cmsg->CIPValue = CIPValue;
-	cmsg->CalledPartyNumber = CalledPartyNumber;
-	cmsg->CallingPartyNumber = CallingPartyNumber;
-	cmsg->CalledPartySubaddress = CalledPartySubaddress;
-	cmsg->CallingPartySubaddress = CallingPartySubaddress;
-	cmsg->B1protocol = B1protocol;
-	cmsg->B2protocol = B2protocol;
-	cmsg->B3protocol = B3protocol;
-	cmsg->B1configuration = B1configuration;
-	cmsg->B2configuration = B2configuration;
-	cmsg->B3configuration = B3configuration;
-	cmsg->BC = BC;
-	cmsg->LLC = LLC;
-	cmsg->HLC = HLC;
-	cmsg->BChannelinformation = BChannelinformation;
-	cmsg->Keypadfacility = Keypadfacility;
-	cmsg->Useruserdata = Useruserdata;
-	cmsg->Facilitydataarray = Facilitydataarray;
-}
-
-static inline void capi_fill_DATA_B3_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					 __u32 adr,
-					 __u32 Data,
-					 __u16 DataLength,
-					 __u16 DataHandle,
-					 __u16 Flags)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x86, 0x80, Messagenumber, adr);
-	cmsg->Data = Data;
-	cmsg->DataLength = DataLength;
-	cmsg->DataHandle = DataHandle;
-	cmsg->Flags = Flags;
-}
-
-static inline void capi_fill_DISCONNECT_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					    __u32 adr,
-					    _cstruct BChannelinformation,
-					    _cstruct Keypadfacility,
-					    _cstruct Useruserdata,
-					    _cstruct Facilitydataarray)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x04, 0x80, Messagenumber, adr);
-	cmsg->BChannelinformation = BChannelinformation;
-	cmsg->Keypadfacility = Keypadfacility;
-	cmsg->Useruserdata = Useruserdata;
-	cmsg->Facilitydataarray = Facilitydataarray;
-}
-
-static inline void capi_fill_DISCONNECT_B3_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					       __u32 adr,
-					       _cstruct NCPI)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x84, 0x80, Messagenumber, adr);
-	cmsg->NCPI = NCPI;
-}
-
-static inline void capi_fill_MANUFACTURER_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					      __u32 adr,
-					      __u32 ManuID,
-					      __u32 Class,
-					      __u32 Function,
-					      _cstruct ManuData)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0xff, 0x80, Messagenumber, adr);
-	cmsg->ManuID = ManuID;
-	cmsg->Class = Class;
-	cmsg->Function = Function;
-	cmsg->ManuData = ManuData;
-}
-
-static inline void capi_fill_RESET_B3_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					  __u32 adr,
-					  _cstruct NCPI)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x87, 0x80, Messagenumber, adr);
-	cmsg->NCPI = NCPI;
-}
-
-static inline void capi_fill_SELECT_B_PROTOCOL_REQ(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-						   __u32 adr,
-						   __u16 B1protocol,
-						   __u16 B2protocol,
-						   __u16 B3protocol,
-						_cstruct B1configuration,
-						_cstruct B2configuration,
-						_cstruct B3configuration)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x41, 0x80, Messagenumber, adr);
-	cmsg->B1protocol = B1protocol;
-	cmsg->B2protocol = B2protocol;
-	cmsg->B3protocol = B3protocol;
-	cmsg->B1configuration = B1configuration;
-	cmsg->B2configuration = B2configuration;
-	cmsg->B3configuration = B3configuration;
-}
-
-static inline void capi_fill_CONNECT_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					  __u32 adr,
-					  __u16 Reject,
-					  __u16 B1protocol,
-					  __u16 B2protocol,
-					  __u16 B3protocol,
-					  _cstruct B1configuration,
-					  _cstruct B2configuration,
-					  _cstruct B3configuration,
-					  _cstruct ConnectedNumber,
-					  _cstruct ConnectedSubaddress,
-					  _cstruct LLC,
-					  _cstruct BChannelinformation,
-					  _cstruct Keypadfacility,
-					  _cstruct Useruserdata,
-					  _cstruct Facilitydataarray)
-{
-	capi_cmsg_header(cmsg, ApplId, 0x02, 0x83, Messagenumber, adr);
-	cmsg->Reject = Reject;
-	cmsg->B1protocol = B1protocol;
-	cmsg->B2protocol = B2protocol;
-	cmsg->B3protocol = B3protocol;
-	cmsg->B1configuration = B1configuration;
-	cmsg->B2configuration = B2configuration;
-	cmsg->B3configuration = B3configuration;
-	cmsg->ConnectedNumber = ConnectedNumber;
-	cmsg->ConnectedSubaddress = ConnectedSubaddress;
-	cmsg->LLC = LLC;
-	cmsg->BChannelinformation = BChannelinformation;
-	cmsg->Keypadfacility = Keypadfacility;
-	cmsg->Useruserdata = Useruserdata;
-	cmsg->Facilitydataarray = Facilitydataarray;
-}
-
-static inline void capi_fill_CONNECT_ACTIVE_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-						 __u32 adr)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x03, 0x83, Messagenumber, adr);
-}
-
-static inline void capi_fill_CONNECT_B3_ACTIVE_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-						    __u32 adr)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x83, 0x83, Messagenumber, adr);
-}
-
-static inline void capi_fill_CONNECT_B3_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					     __u32 adr,
-					     __u16 Reject,
-					     _cstruct NCPI)
-{
-	capi_cmsg_header(cmsg, ApplId, 0x82, 0x83, Messagenumber, adr);
-	cmsg->Reject = Reject;
-	cmsg->NCPI = NCPI;
-}
-
-static inline void capi_fill_CONNECT_B3_T90_ACTIVE_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-							__u32 adr)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x88, 0x83, Messagenumber, adr);
-}
-
-static inline void capi_fill_DATA_B3_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					  __u32 adr,
-					  __u16 DataHandle)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x86, 0x83, Messagenumber, adr);
-	cmsg->DataHandle = DataHandle;
-}
-
-static inline void capi_fill_DISCONNECT_B3_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-						__u32 adr)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x84, 0x83, Messagenumber, adr);
-}
-
-static inline void capi_fill_DISCONNECT_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					     __u32 adr)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x04, 0x83, Messagenumber, adr);
-}
-
-static inline void capi_fill_FACILITY_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					   __u32 adr,
-					   __u16 FacilitySelector)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x80, 0x83, Messagenumber, adr);
-	cmsg->FacilitySelector = FacilitySelector;
-}
-
-static inline void capi_fill_INFO_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-				       __u32 adr)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x08, 0x83, Messagenumber, adr);
-}
-
-static inline void capi_fill_MANUFACTURER_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					       __u32 adr,
-					       __u32 ManuID,
-					       __u32 Class,
-					       __u32 Function,
-					       _cstruct ManuData)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0xff, 0x83, Messagenumber, adr);
-	cmsg->ManuID = ManuID;
-	cmsg->Class = Class;
-	cmsg->Function = Function;
-	cmsg->ManuData = ManuData;
-}
-
-static inline void capi_fill_RESET_B3_RESP(_cmsg * cmsg, __u16 ApplId, __u16 Messagenumber,
-					   __u32 adr)
-{
-
-	capi_cmsg_header(cmsg, ApplId, 0x87, 0x83, Messagenumber, adr);
-}
-
 #endif				/* __CAPIUTIL_H__ */
diff --git a/include/linux/kernelcapi.h b/include/linux/kernelcapi.h
index 075fab5f92e1..94ba42bf9da1 100644
--- a/include/linux/kernelcapi.h
+++ b/include/linux/kernelcapi.h
@@ -10,46 +10,12 @@
 #ifndef __KERNELCAPI_H__
 #define __KERNELCAPI_H__
 
-
 #include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <uapi/linux/kernelcapi.h>
 
-struct capi20_appl {
-	u16 applid;
-	capi_register_params rparam;
-	void (*recv_message)(struct capi20_appl *ap, struct sk_buff *skb);
-	void *private;
-
-	/* internal to kernelcapi.o */
-	unsigned long nrecvctlpkt;
-	unsigned long nrecvdatapkt;
-	unsigned long nsentctlpkt;
-	unsigned long nsentdatapkt;
-	struct mutex recv_mtx;
-	struct sk_buff_head recv_queue;
-	struct work_struct recv_work;
-	int release_in_progress;
-};
-
-u16 capi20_isinstalled(void);
-u16 capi20_register(struct capi20_appl *ap);
-u16 capi20_release(struct capi20_appl *ap);
-u16 capi20_put_message(struct capi20_appl *ap, struct sk_buff *skb);
-u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN]);
-u16 capi20_get_version(u32 contr, struct capi_version *verp);
-u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN]);
-u16 capi20_get_profile(u32 contr, struct capi_profile *profp);
-int capi20_manufacturer(unsigned long cmd, void __user *data);
-
-#define CAPICTR_UP			0
-#define CAPICTR_DOWN			1
-
-int register_capictr_notifier(struct notifier_block *nb);
-int unregister_capictr_notifier(struct notifier_block *nb);
-
 #define CAPI_NOERROR                      0x0000
 
 #define CAPI_TOOMANYAPPLS		  0x1001
@@ -76,45 +42,4 @@ int unregister_capictr_notifier(struct notifier_block *nb);
 #define CAPI_MSGCTRLERNOTSUPPORTEXTEQUIP  0x110a
 #define CAPI_MSGCTRLERONLYSUPPORTEXTEQUIP 0x110b
 
-typedef enum {
-        CapiMessageNotSupportedInCurrentState = 0x2001,
-        CapiIllContrPlciNcci                  = 0x2002,
-        CapiNoPlciAvailable                   = 0x2003,
-        CapiNoNcciAvailable                   = 0x2004,
-        CapiNoListenResourcesAvailable        = 0x2005,
-        CapiNoFaxResourcesAvailable           = 0x2006,
-        CapiIllMessageParmCoding              = 0x2007,
-} RESOURCE_CODING_PROBLEM;
-
-typedef enum {
-        CapiB1ProtocolNotSupported                      = 0x3001,
-        CapiB2ProtocolNotSupported                      = 0x3002,
-        CapiB3ProtocolNotSupported                      = 0x3003,
-        CapiB1ProtocolParameterNotSupported             = 0x3004,
-        CapiB2ProtocolParameterNotSupported             = 0x3005,
-        CapiB3ProtocolParameterNotSupported             = 0x3006,
-        CapiBProtocolCombinationNotSupported            = 0x3007,
-        CapiNcpiNotSupported                            = 0x3008,
-        CapiCipValueUnknown                             = 0x3009,
-        CapiFlagsNotSupported                           = 0x300a,
-        CapiFacilityNotSupported                        = 0x300b,
-        CapiDataLengthNotSupportedByCurrentProtocol     = 0x300c,
-        CapiResetProcedureNotSupportedByCurrentProtocol = 0x300d,
-        CapiTeiAssignmentFailed                         = 0x300e,
-} REQUESTED_SERVICES_PROBLEM;
-
-typedef enum {
-	CapiSuccess                                     = 0x0000,
-	CapiSupplementaryServiceNotSupported            = 0x300e,
-	CapiRequestNotAllowedInThisState                = 0x3010,
-} SUPPLEMENTARY_SERVICE_INFO;
-
-typedef enum {
-	CapiProtocolErrorLayer1                         = 0x3301,
-	CapiProtocolErrorLayer2                         = 0x3302,
-	CapiProtocolErrorLayer3                         = 0x3303,
-	CapiTimeOut                                     = 0x3303, // SuppServiceReason
-	CapiCallGivenToOtherApplication                 = 0x3304,
-} CAPI_REASON;
-
 #endif				/* __KERNELCAPI_H__ */
diff --git a/include/uapi/linux/b1lli.h b/include/uapi/linux/b1lli.h
deleted file mode 100644
index 4ae6ac9950df..000000000000
--- a/include/uapi/linux/b1lli.h
+++ /dev/null
@@ -1,74 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* $Id: b1lli.h,v 1.8.8.3 2001/09/23 22:25:05 kai Exp $
- *
- * ISDN lowlevel-module for AVM B1-card.
- *
- * Copyright 1996 by Carsten Paeth (calle@calle.in-berlin.de)
- *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
- */
-
-#ifndef _B1LLI_H_
-#define _B1LLI_H_
-/*
- * struct for loading t4 file 
- */
-typedef struct avmb1_t4file {
-	int len;
-	unsigned char *data;
-} avmb1_t4file;
-
-typedef struct avmb1_loaddef {
-	int contr;
-	avmb1_t4file t4file;
-} avmb1_loaddef;
-
-typedef struct avmb1_loadandconfigdef {
-	int contr;
-	avmb1_t4file t4file;
-        avmb1_t4file t4config; 
-} avmb1_loadandconfigdef;
-
-typedef struct avmb1_resetdef {
-	int contr;
-} avmb1_resetdef;
-
-typedef struct avmb1_getdef {
-	int contr;
-	int cardtype;
-	int cardstate;
-} avmb1_getdef;
-
-/*
- * struct for adding new cards 
- */
-typedef struct avmb1_carddef {
-	int port;
-	int irq;
-} avmb1_carddef;
-
-#define AVM_CARDTYPE_B1		0
-#define AVM_CARDTYPE_T1		1
-#define AVM_CARDTYPE_M1		2
-#define AVM_CARDTYPE_M2		3
-
-typedef struct avmb1_extcarddef {
-	int port;
-	int irq;
-        int cardtype;
-        int cardnr;  /* for HEMA/T1 */
-} avmb1_extcarddef;
-
-#define	AVMB1_LOAD		0	/* load image to card */
-#define AVMB1_ADDCARD		1	/* add a new card - OBSOLETE */
-#define AVMB1_RESETCARD		2	/* reset a card */
-#define	AVMB1_LOAD_AND_CONFIG	3	/* load image and config to card */
-#define	AVMB1_ADDCARD_WITH_TYPE	4	/* add a new card, with cardtype */
-#define AVMB1_GET_CARDINFO	5	/* get cardtype */
-#define AVMB1_REMOVECARD	6	/* remove a card - OBSOLETE */
-
-#define	AVMB1_REGISTERCARD_IS_OBSOLETE
-
-#endif				/* _B1LLI_H_ */
-- 
2.20.0

