Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CE81C1892
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgEAOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbgEAOpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:08 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C39A2495B;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=HZ+1cCrnHwqymSnl/nTu7FohfNpgot2Ka93tsEWAPOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veWHDLduD/YtR/JL8m6M+YKxHR1bDoXNxewE9SPRcg+hXFtpCAgFhnnnC/Bqn6d30
         S4o9ZFFKwsuztbQwFVvzbuJ51ePLMScGuUXQvr7RTx00nL0LL2RDHLhaP/+I5mGJlp
         NifWC3/uAOlyEe6rzoVHaGNTaRV8CoR2phxitFcs=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCcV-8A; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxim Krasnyansky <maxk@qti.qualcomm.com>,
        netdev@vger.kernel.org
Subject: [PATCH 01/37] docs: networking: convert tuntap.txt to ReST
Date:   Fri,  1 May 2020 16:44:23 +0200
Message-Id: <012b840f86a0f1d67dc95052ef4a001fede0f52a.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- use copyright symbol;
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{tuntap.txt => tuntap.rst}     | 200 ++++++++++--------
 MAINTAINERS                                   |   2 +-
 drivers/net/Kconfig                           |   2 +-
 4 files changed, 119 insertions(+), 86 deletions(-)
 rename Documentation/networking/{tuntap.txt => tuntap.rst} (58%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index b423b2db5f96..e7a683f0528d 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -111,6 +111,7 @@ Contents:
    team
    timestamping
    tproxy
+   tuntap
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/tuntap.txt b/Documentation/networking/tuntap.rst
similarity index 58%
rename from Documentation/networking/tuntap.txt
rename to Documentation/networking/tuntap.rst
index 0104830d5075..a59d1dd6fdcc 100644
--- a/Documentation/networking/tuntap.txt
+++ b/Documentation/networking/tuntap.rst
@@ -1,20 +1,28 @@
-Universal TUN/TAP device driver.
-Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
 
-  Linux, Solaris drivers 
-  Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
+===============================
+Universal TUN/TAP device driver
+===============================
 
-  FreeBSD TAP driver 
-  Copyright (c) 1999-2000 Maksim Yevmenkin <m_evmenkin@yahoo.com>
+Copyright |copy| 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
+
+  Linux, Solaris drivers
+  Copyright |copy| 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
+
+  FreeBSD TAP driver
+  Copyright |copy| 1999-2000 Maksim Yevmenkin <m_evmenkin@yahoo.com>
 
   Revision of this document 2002 by Florian Thiel <florian.thiel@gmx.net>
 
 1. Description
-  TUN/TAP provides packet reception and transmission for user space programs. 
+==============
+
+  TUN/TAP provides packet reception and transmission for user space programs.
   It can be seen as a simple Point-to-Point or Ethernet device, which,
-  instead of receiving packets from physical media, receives them from 
-  user space program and instead of sending packets via physical media 
-  writes them to the user space program. 
+  instead of receiving packets from physical media, receives them from
+  user space program and instead of sending packets via physical media
+  writes them to the user space program.
 
   In order to use the driver a program has to open /dev/net/tun and issue a
   corresponding ioctl() to register a network device with the kernel. A network
@@ -33,41 +41,51 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
   br_sigio.c  - bridge based on async io and SIGIO signal.
   However, the best example is VTun http://vtun.sourceforge.net :))
 
-2. Configuration 
-  Create device node:
+2. Configuration
+================
+
+  Create device node::
+
      mkdir /dev/net (if it doesn't exist already)
      mknod /dev/net/tun c 10 200
-  
-  Set permissions:
+
+  Set permissions::
+
      e.g. chmod 0666 /dev/net/tun
-     There's no harm in allowing the device to be accessible by non-root users,
-     since CAP_NET_ADMIN is required for creating network devices or for 
-     connecting to network devices which aren't owned by the user in question.
-     If you want to create persistent devices and give ownership of them to 
-     unprivileged users, then you need the /dev/net/tun device to be usable by
-     those users.
+
+  There's no harm in allowing the device to be accessible by non-root users,
+  since CAP_NET_ADMIN is required for creating network devices or for
+  connecting to network devices which aren't owned by the user in question.
+  If you want to create persistent devices and give ownership of them to
+  unprivileged users, then you need the /dev/net/tun device to be usable by
+  those users.
 
   Driver module autoloading
 
      Make sure that "Kernel module loader" - module auto-loading
      support is enabled in your kernel.  The kernel should load it on
      first access.
-  
-  Manual loading 
-     insert the module by hand:
-        modprobe tun
+
+  Manual loading
+
+     insert the module by hand::
+
+	modprobe tun
 
   If you do it the latter way, you have to load the module every time you
   need it, if you do it the other way it will be automatically loaded when
   /dev/net/tun is being opened.
 
-3. Program interface 
-  3.1 Network device allocation:
+3. Program interface
+====================
 
-  char *dev should be the name of the device with a format string (e.g.
-  "tun%d"), but (as far as I can see) this can be any valid network device name.
-  Note that the character pointer becomes overwritten with the real device name
-  (e.g. "tun0")
+3.1 Network device allocation
+-----------------------------
+
+``char *dev`` should be the name of the device with a format string (e.g.
+"tun%d"), but (as far as I can see) this can be any valid network device name.
+Note that the character pointer becomes overwritten with the real device name
+(e.g. "tun0")::
 
   #include <linux/if.h>
   #include <linux/if_tun.h>
@@ -78,45 +96,51 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
       int fd, err;
 
       if( (fd = open("/dev/net/tun", O_RDWR)) < 0 )
-         return tun_alloc_old(dev);
+	 return tun_alloc_old(dev);
 
       memset(&ifr, 0, sizeof(ifr));
 
-      /* Flags: IFF_TUN   - TUN device (no Ethernet headers) 
-       *        IFF_TAP   - TAP device  
+      /* Flags: IFF_TUN   - TUN device (no Ethernet headers)
+       *        IFF_TAP   - TAP device
        *
-       *        IFF_NO_PI - Do not provide packet information  
-       */ 
-      ifr.ifr_flags = IFF_TUN; 
+       *        IFF_NO_PI - Do not provide packet information
+       */
+      ifr.ifr_flags = IFF_TUN;
       if( *dev )
-         strncpy(ifr.ifr_name, dev, IFNAMSIZ);
+	 strncpy(ifr.ifr_name, dev, IFNAMSIZ);
 
       if( (err = ioctl(fd, TUNSETIFF, (void *) &ifr)) < 0 ){
-         close(fd);
-         return err;
+	 close(fd);
+	 return err;
       }
       strcpy(dev, ifr.ifr_name);
       return fd;
-  }              
- 
-  3.2 Frame format:
-  If flag IFF_NO_PI is not set each frame format is: 
+  }
+
+3.2 Frame format
+----------------
+
+If flag IFF_NO_PI is not set each frame format is::
+
      Flags [2 bytes]
      Proto [2 bytes]
      Raw protocol(IP, IPv6, etc) frame.
 
-  3.3 Multiqueue tuntap interface:
+3.3 Multiqueue tuntap interface
+-------------------------------
 
-  From version 3.8, Linux supports multiqueue tuntap which can uses multiple
-  file descriptors (queues) to parallelize packets sending or receiving. The
-  device allocation is the same as before, and if user wants to create multiple
-  queues, TUNSETIFF with the same device name must be called many times with
-  IFF_MULTI_QUEUE flag.
+From version 3.8, Linux supports multiqueue tuntap which can uses multiple
+file descriptors (queues) to parallelize packets sending or receiving. The
+device allocation is the same as before, and if user wants to create multiple
+queues, TUNSETIFF with the same device name must be called many times with
+IFF_MULTI_QUEUE flag.
 
-  char *dev should be the name of the device, queues is the number of queues to
-  be created, fds is used to store and return the file descriptors (queues)
-  created to the caller. Each file descriptor were served as the interface of a
-  queue which could be accessed by userspace.
+``char *dev`` should be the name of the device, queues is the number of queues
+to be created, fds is used to store and return the file descriptors (queues)
+created to the caller. Each file descriptor were served as the interface of a
+queue which could be accessed by userspace.
+
+::
 
   #include <linux/if.h>
   #include <linux/if_tun.h>
@@ -127,7 +151,7 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
       int fd, err, i;
 
       if (!dev)
-          return -1;
+	  return -1;
 
       memset(&ifr, 0, sizeof(ifr));
       /* Flags: IFF_TUN   - TUN device (no Ethernet headers)
@@ -140,30 +164,30 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
       strcpy(ifr.ifr_name, dev);
 
       for (i = 0; i < queues; i++) {
-          if ((fd = open("/dev/net/tun", O_RDWR)) < 0)
-             goto err;
-          err = ioctl(fd, TUNSETIFF, (void *)&ifr);
-          if (err) {
-             close(fd);
-             goto err;
-          }
-          fds[i] = fd;
+	  if ((fd = open("/dev/net/tun", O_RDWR)) < 0)
+	     goto err;
+	  err = ioctl(fd, TUNSETIFF, (void *)&ifr);
+	  if (err) {
+	     close(fd);
+	     goto err;
+	  }
+	  fds[i] = fd;
       }
 
       return 0;
   err:
       for (--i; i >= 0; i--)
-          close(fds[i]);
+	  close(fds[i]);
       return err;
   }
 
-  A new ioctl(TUNSETQUEUE) were introduced to enable or disable a queue. When
-  calling it with IFF_DETACH_QUEUE flag, the queue were disabled. And when
-  calling it with IFF_ATTACH_QUEUE flag, the queue were enabled. The queue were
-  enabled by default after it was created through TUNSETIFF.
+A new ioctl(TUNSETQUEUE) were introduced to enable or disable a queue. When
+calling it with IFF_DETACH_QUEUE flag, the queue were disabled. And when
+calling it with IFF_ATTACH_QUEUE flag, the queue were enabled. The queue were
+enabled by default after it was created through TUNSETIFF.
 
-  fd is the file descriptor (queue) that we want to enable or disable, when
-  enable is true we enable it, otherwise we disable it
+fd is the file descriptor (queue) that we want to enable or disable, when
+enable is true we enable it, otherwise we disable it::
 
   #include <linux/if.h>
   #include <linux/if_tun.h>
@@ -175,53 +199,61 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
       memset(&ifr, 0, sizeof(ifr));
 
       if (enable)
-         ifr.ifr_flags = IFF_ATTACH_QUEUE;
+	 ifr.ifr_flags = IFF_ATTACH_QUEUE;
       else
-         ifr.ifr_flags = IFF_DETACH_QUEUE;
+	 ifr.ifr_flags = IFF_DETACH_QUEUE;
 
       return ioctl(fd, TUNSETQUEUE, (void *)&ifr);
   }
 
-Universal TUN/TAP device driver Frequently Asked Question.
-   
+Universal TUN/TAP device driver Frequently Asked Question
+=========================================================
+
 1. What platforms are supported by TUN/TAP driver ?
+
 Currently driver has been written for 3 Unices:
-   Linux kernels 2.2.x, 2.4.x 
-   FreeBSD 3.x, 4.x, 5.x
-   Solaris 2.6, 7.0, 8.0
+
+  - Linux kernels 2.2.x, 2.4.x
+  - FreeBSD 3.x, 4.x, 5.x
+  - Solaris 2.6, 7.0, 8.0
 
 2. What is TUN/TAP driver used for?
-As mentioned above, main purpose of TUN/TAP driver is tunneling. 
+
+As mentioned above, main purpose of TUN/TAP driver is tunneling.
 It is used by VTun (http://vtun.sourceforge.net).
 
 Another interesting application using TUN/TAP is pipsecd
 (http://perso.enst.fr/~beyssac/pipsec/), a userspace IPSec
 implementation that can use complete kernel routing (unlike FreeS/WAN).
 
-3. How does Virtual network device actually work ? 
+3. How does Virtual network device actually work ?
+
 Virtual network device can be viewed as a simple Point-to-Point or
-Ethernet device, which instead of receiving packets from a physical 
-media, receives them from user space program and instead of sending 
-packets via physical media sends them to the user space program. 
+Ethernet device, which instead of receiving packets from a physical
+media, receives them from user space program and instead of sending
+packets via physical media sends them to the user space program.
 
 Let's say that you configured IPv6 on the tap0, then whenever
 the kernel sends an IPv6 packet to tap0, it is passed to the application
-(VTun for example). The application encrypts, compresses and sends it to 
+(VTun for example). The application encrypts, compresses and sends it to
 the other side over TCP or UDP. The application on the other side decompresses
-and decrypts the data received and writes the packet to the TAP device, 
+and decrypts the data received and writes the packet to the TAP device,
 the kernel handles the packet like it came from real physical device.
 
 4. What is the difference between TUN driver and TAP driver?
+
 TUN works with IP frames. TAP works with Ethernet frames.
 
 This means that you have to read/write IP packets when you are using tun and
 ethernet frames when using tap.
 
 5. What is the difference between BPF and TUN/TAP driver?
+
 BPF is an advanced packet filter. It can be attached to existing
 network interface. It does not provide a virtual network interface.
 A TUN/TAP driver does provide a virtual network interface and it is possible
 to attach BPF to this interface.
 
 6. Does TAP driver support kernel Ethernet bridging?
-Yes. Linux and FreeBSD drivers support Ethernet bridging. 
+
+Yes. Linux and FreeBSD drivers support Ethernet bridging.
diff --git a/MAINTAINERS b/MAINTAINERS
index 64789b29c085..35bd81b436e1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17207,7 +17207,7 @@ TUN/TAP driver
 M:	Maxim Krasnyansky <maxk@qti.qualcomm.com>
 S:	Maintained
 W:	http://vtun.sourceforge.net/tun
-F:	Documentation/networking/tuntap.txt
+F:	Documentation/networking/tuntap.rst
 F:	arch/um/os-Linux/drivers/
 
 TURBOCHANNEL SUBSYSTEM
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index ad64be98330f..3f2c98a7906c 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -355,7 +355,7 @@ config TUN
 	  devices, driver will automatically delete tunXX or tapXX device and
 	  all routes corresponding to it.
 
-	  Please read <file:Documentation/networking/tuntap.txt> for more
+	  Please read <file:Documentation/networking/tuntap.rst> for more
 	  information.
 
 	  To compile this driver as a module, choose M here: the module
-- 
2.25.4

