Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF551378D57
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348117AbhEJMkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 08:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236356AbhEJM2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7D36101D;
        Mon, 10 May 2021 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620649643;
        bh=LbmnOxpyt0WXqdMViFTAMoJEaPqlNEegibwGaPEZGG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MvIyYeVZJjyVYPo6ZRMXjb5Wtr+O8pSeu/Vqj2jEZnOpovUksVrQSoDjNHhf+GLkV
         4Xx0fmZ0I8V1A4Kb2+7hdIVjD7dyCDZ4X9WiEgLMaXkHT9nvdsdXD0qTASlyCtYXHQ
         +sba+YoRuzJSpeKSzMjmk9gfn+Npl0eiyN4rc0rwhqfC0EHszQ12OYVU7kieINgBKf
         7gbQpH2YQ/L3zo+vBbuAbSMpy+qiymgJnswcNNZB+ZL9u0csMThXFNu9JeGtygmfK/
         OJmXKy7SgKeZNkUPykTozc6JFS9iiGjJrQ1MKbH/YSYOaN3FnpGT6AlJS2F55XRmi4
         6g1zaYWjm1/jw==
Date:   Mon, 10 May 2021 14:27:12 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Thorsten Leemhuis <linux@leemhuis.info>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as
 ASCII
Message-ID: <20210510142712.02969f6d@coco.lan>
In-Reply-To: <20210510131950.063f0608@coco.lan>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
        <c4479ced-f4d8-1a1e-ee54-9abc55344187@leemhuis.info>
        <20210510131950.063f0608@coco.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 10 May 2021 13:19:50 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:

> Em Mon, 10 May 2021 12:52:44 +0200
> Thorsten Leemhuis <linux@leemhuis.info> escreveu:
>=20
> > On 10.05.21 12:26, Mauro Carvalho Chehab wrote: =20
> > >
> > > As Linux developers are all around the globe, and not everybody has U=
TF-8
> > > as their default charset, better to use UTF-8 only on cases where it =
is really
> > > needed.
> > > [=E2=80=A6]
> > > The remaining patches on series address such cases on *.rst files and=
=20
> > > inside the Documentation/ABI, using this perl map table in order to d=
o the
> > > charset conversion:
> > >=20
> > > my %char_map =3D (
> > > [=E2=80=A6]
> > > 	0x2013 =3D> '-',		# EN DASH
> > > 	0x2014 =3D> '-',		# EM DASH   =20
>=20
>=20
> > I might be performing bike shedding here, but wouldn't it be better to
> > replace those two with "--", as explained in
> > https://en.wikipedia.org/wiki/Dash#Approximating_the_em_dash_with_two_o=
r_three_hyphens
> >=20
> > For EM DASH there seems to be even "---", but I'd say that is a bit too
> > much. =20
>=20
> Yeah, we can do, instead:
>=20
>  	0x2013 =3D> '--',		# EN DASH
>  	0x2014 =3D> '---',	# EM DASH =20
>=20
> I was actually in doubt about those ;-)

On a quick test, I changed my script to use "--" and "---" for
EN/EM DASH chars.

The diff below is against both versions.

There are a couple of places where it got mathematically wrong,=20
like this one:

	-operation over a temperature range of -40=C2=B0C to +125=C2=B0C.
	+operation over a temperature range of --40=C2=B0C to +125=C2=B0C.

On others, it is just a matter of personal taste. My personal opinion
is that, on most cases, a single "-" would be better.

Thanks,
Mauro

diff --git a/Documentation/ABI/testing/sysfs-class-net-cdc_ncm b/Documentat=
ion/ABI/testing/sysfs-class-net-cdc_ncm
index 41a1eef0d0e7..469325255887 100644
--- a/Documentation/ABI/testing/sysfs-class-net-cdc_ncm
+++ b/Documentation/ABI/testing/sysfs-class-net-cdc_ncm
@@ -93,7 +93,7 @@ Contact:	Bj=C3=B8rn Mork <bjorn@mork.no>
 Description:
 		- Bit 0: 16-bit NTB supported (set to 1)
 		- Bit 1: 32-bit NTB supported
-		- Bits 2 - 15: reserved (reset to zero; must be ignored by host)
+		- Bits 2 -- 15: reserved (reset to zero; must be ignored by host)
=20
 What:		/sys/class/net/<iface>/cdc_ncm/dwNtbInMaxSize
 Date:		May 2014
diff --git a/Documentation/PCI/acpi-info.rst b/Documentation/PCI/acpi-info.=
rst
index 9b4b04039982..7a75f1f6e73c 100644
--- a/Documentation/PCI/acpi-info.rst
+++ b/Documentation/PCI/acpi-info.rst
@@ -140,8 +140,8 @@ address always corresponds to bus 0, even if the bus ra=
nge below the bridge
     Extended Address Space Descriptor (.4)
       General Flags: Bit [0] Consumer/Producer:
=20
-        * 1 - This device consumes this resource
-        * 0 - This device produces and consumes this resource
+        * 1 -- This device consumes this resource
+        * 0 -- This device produces and consumes this resource
=20
 [5] ACPI 6.2, sec 19.6.43:
     ResourceUsage specifies whether the Memory range is consumed by
diff --git a/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Order=
ing.rst b/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering=
.rst
index d76c6bfdc659..34a12b12df51 100644
--- a/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.rst
+++ b/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.rst
@@ -215,7 +215,7 @@ newly arrived RCU callbacks against future grace period=
s:
    43 }
=20
 But the only part of ``rcu_prepare_for_idle()`` that really matters for
-this discussion are lines 37-39. We will therefore abbreviate this
+this discussion are lines 37--39. We will therefore abbreviate this
 function as follows:
=20
 .. kernel-figure:: rcu_node-lock.svg
diff --git a/Documentation/RCU/Design/Requirements/Requirements.rst b/Docum=
entation/RCU/Design/Requirements/Requirements.rst
index a3493b34f3dd..a42dc3cf26bd 100644
--- a/Documentation/RCU/Design/Requirements/Requirements.rst
+++ b/Documentation/RCU/Design/Requirements/Requirements.rst
@@ -2354,8 +2354,8 @@ which in practice also means that RCU must have an ag=
gressive
 stress-test suite. This stress-test suite is called ``rcutorture``.
=20
 Although the need for ``rcutorture`` was no surprise, the current
-immense popularity of the Linux kernel is posing interesting-and perhaps
-unprecedented-validation challenges. To see this, keep in mind that
+immense popularity of the Linux kernel is posing interesting---and perhaps
+unprecedented---validation challenges. To see this, keep in mind that
 there are well over one billion instances of the Linux kernel running
 today, given Android smartphones, Linux-powered televisions, and
 servers. This number can be expected to increase sharply with the advent
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guid=
e/index.rst
index b1692643718d..1a6dbda71ad6 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -3,7 +3,7 @@ The Linux kernel user's and administrator's guide
=20
 The following is a collection of user-oriented documents that have been
 added to the kernel over time.  There is, as yet, little overall order or
-organization here - this material was not written to be a single, coherent
+organization here --- this material was not written to be a single, cohere=
nt
 document!  With luck things will improve quickly over time.
=20
 This initial section contains overall information, including the README
diff --git a/Documentation/admin-guide/module-signing.rst b/Documentation/a=
dmin-guide/module-signing.rst
index bd1d2fef78e8..0d185ba8b8b5 100644
--- a/Documentation/admin-guide/module-signing.rst
+++ b/Documentation/admin-guide/module-signing.rst
@@ -100,8 +100,8 @@ This has a number of options available:
      ``certs/signing_key.pem`` will disable the autogeneration of signing =
keys
      and allow the kernel modules to be signed with a key of your choosing.
      The string provided should identify a file containing both a private =
key
-     and its corresponding X.509 certificate in PEM form, or - on systems =
where
-     the OpenSSL ENGINE_pkcs11 is functional - a PKCS#11 URI as defined by
+     and its corresponding X.509 certificate in PEM form, or --- on system=
s where
+     the OpenSSL ENGINE_pkcs11 is functional --- a PKCS#11 URI as defined =
by
      RFC7512. In the latter case, the PKCS#11 URI should reference both a
      certificate and a private key.
=20
diff --git a/Documentation/admin-guide/ras.rst b/Documentation/admin-guide/=
ras.rst
index 00445adf8708..66c2c62c1cd4 100644
--- a/Documentation/admin-guide/ras.rst
+++ b/Documentation/admin-guide/ras.rst
@@ -40,10 +40,10 @@ it causes data loss or system downtime.
=20
 Among the monitoring measures, the most usual ones include:
=20
-* CPU - detect errors at instruction execution and at L1/L2/L3 caches;
-* Memory - add error correction logic (ECC) to detect and correct errors;
-* I/O - add CRC checksums for transferred data;
-* Storage - RAID, journal file systems, checksums,
+* CPU -- detect errors at instruction execution and at L1/L2/L3 caches;
+* Memory -- add error correction logic (ECC) to detect and correct errors;
+* I/O -- add CRC checksums for transferred data;
+* Storage -- RAID, journal file systems, checksums,
   Self-Monitoring, Analysis and Reporting Technology (SMART).
=20
 By monitoring the number of occurrences of error detections, it is possible
diff --git a/Documentation/admin-guide/reporting-issues.rst b/Documentation=
/admin-guide/reporting-issues.rst
index f691930e13c0..af699015d266 100644
--- a/Documentation/admin-guide/reporting-issues.rst
+++ b/Documentation/admin-guide/reporting-issues.rst
@@ -824,7 +824,7 @@ and look a little lower at the table. At its top you'll=
 see a line starting with
 mainline, which most of the time will point to a pre-release with a version
 number like '5.8-rc2'. If that's the case, you'll want to use this mainline
 kernel for testing, as that where all fixes have to be applied first. Do n=
ot let
-that 'rc' scare you, these 'development kernels' are pretty reliable - and=
 you
+that 'rc' scare you, these 'development kernels' are pretty reliable --- a=
nd you
 made a backup, as you were instructed above, didn't you?
=20
 In about two out of every nine to ten weeks, mainline might point you to a
@@ -866,7 +866,7 @@ How to obtain a fresh Linux kernel
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=20
 **Using a pre-compiled kernel**: This is often the quickest, easiest, and =
safest
-way for testing - especially is you are unfamiliar with the Linux kernel. =
The
+way for testing --- especially is you are unfamiliar with the Linux kernel=
. The
 problem: most of those shipped by distributors or add-on repositories are =
build
 from modified Linux sources. They are thus not vanilla and therefore often
 unsuitable for testing and issue reporting: the changes might cause the is=
sue
@@ -1345,7 +1345,7 @@ about it to a chatroom or forum you normally hang out.
=20
 **Be patient**: If you are really lucky you might get a reply to your repo=
rt
 within a few hours. But most of the time it will take longer, as maintaine=
rs
-are scattered around the globe and thus might be in a different time zone =
- one
+are scattered around the globe and thus might be in a different time zone =
-- one
 where they already enjoy their night away from keyboard.
=20
 In general, kernel developers will take one to five business days to respo=
nd to
@@ -1388,7 +1388,7 @@ Here are your duties in case you got replies to your =
report:
=20
 **Check who you deal with**: Most of the time it will be the maintainer or=
 a
 developer of the particular code area that will respond to your report. Bu=
t as
-issues are normally reported in public it could be anyone that's replying -
+issues are normally reported in public it could be anyone that's replying =
---
 including people that want to help, but in the end might guide you totally=
 off
 track with their questions or requests. That rarely happens, but it's one =
of
 many reasons why it's wise to quickly run an internet search to see who yo=
u're
@@ -1716,7 +1716,7 @@ Maybe their test hardware broke, got replaced by some=
thing more fancy, or is so
 old that it's something you don't find much outside of computer museums
 anymore. Sometimes developer stops caring for their code and Linux at all,=
 as
 something different in their life became way more important. In some cases
-nobody is willing to take over the job as maintainer - and nobody can be f=
orced
+nobody is willing to take over the job as maintainer -- and nobody can be =
forced
 to, as contributing to the Linux kernel is done on a voluntary basis. Aban=
doned
 drivers nevertheless remain in the kernel: they are still useful for peopl=
e and
 removing would be a regression.
diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/ad=
min-guide/sysctl/kernel.rst
index 743a7c70fd83..639dd58518ca 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1285,7 +1285,7 @@ The soft lockup detector monitors CPUs for threads th=
at are hogging the CPUs
 without rescheduling voluntarily, and thus prevent the 'watchdog/N' threads
 from running. The mechanism depends on the CPUs ability to respond to timer
 interrupts which are needed for the 'watchdog/N' threads to be woken up by
-the watchdog timer function, otherwise the NMI watchdog - if enabled - can
+the watchdog timer function, otherwise the NMI watchdog --- if enabled ---=
 can
 detect a hard lockup condition.
=20
=20
diff --git a/Documentation/dev-tools/testing-overview.rst b/Documentation/d=
ev-tools/testing-overview.rst
index 8adffc26a2ec..381c571eb52c 100644
--- a/Documentation/dev-tools/testing-overview.rst
+++ b/Documentation/dev-tools/testing-overview.rst
@@ -18,8 +18,8 @@ frameworks. These both provide infrastructure to help mak=
e running tests and
 groups of tests easier, as well as providing helpers to aid in writing new
 tests.
=20
-If you're looking to verify the behaviour of the Kernel - particularly spe=
cific
-parts of the kernel - then you'll want to use KUnit or kselftest.
+If you're looking to verify the behaviour of the Kernel --- particularly s=
pecific
+parts of the kernel --- then you'll want to use KUnit or kselftest.
=20
=20
 The Difference Between KUnit and kselftest
diff --git a/Documentation/doc-guide/contributing.rst b/Documentation/doc-g=
uide/contributing.rst
index c2d709467c68..ac5c9f1d2311 100644
--- a/Documentation/doc-guide/contributing.rst
+++ b/Documentation/doc-guide/contributing.rst
@@ -76,7 +76,7 @@ comments that look like this::
=20
 The problem is the missing "*", which confuses the build system's
 simplistic idea of what C comment blocks look like.  This problem had been
-present since that comment was added in 2016 - a full four years.  Fixing
+present since that comment was added in 2016 --- a full four years.  Fixing
 it was a matter of adding the missing asterisks.  A quick look at the
 history for that file showed what the normal format for subject lines is,
 and ``scripts/get_maintainer.pl`` told me who should receive it.  The
diff --git a/Documentation/driver-api/fpga/fpga-bridge.rst b/Documentation/=
driver-api/fpga/fpga-bridge.rst
index 8d650b4e2ce6..1d6e910c27df 100644
--- a/Documentation/driver-api/fpga/fpga-bridge.rst
+++ b/Documentation/driver-api/fpga/fpga-bridge.rst
@@ -4,11 +4,11 @@ FPGA Bridge
 API to implement a new FPGA bridge
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=20
-* struct fpga_bridge - The FPGA Bridge structure
-* struct fpga_bridge_ops - Low level Bridge driver ops
-* devm_fpga_bridge_create() - Allocate and init a bridge struct
-* fpga_bridge_register() - Register a bridge
-* fpga_bridge_unregister() - Unregister a bridge
+* struct fpga_bridge --- The FPGA Bridge structure
+* struct fpga_bridge_ops --- Low level Bridge driver ops
+* devm_fpga_bridge_create() --- Allocate and init a bridge struct
+* fpga_bridge_register() --- Register a bridge
+* fpga_bridge_unregister() --- Unregister a bridge
=20
 .. kernel-doc:: include/linux/fpga/fpga-bridge.h
    :functions: fpga_bridge
diff --git a/Documentation/driver-api/fpga/fpga-mgr.rst b/Documentation/dri=
ver-api/fpga/fpga-mgr.rst
index 4d926b452cb3..272161361c6a 100644
--- a/Documentation/driver-api/fpga/fpga-mgr.rst
+++ b/Documentation/driver-api/fpga/fpga-mgr.rst
@@ -101,12 +101,12 @@ in state.
 API for implementing a new FPGA Manager driver
 ----------------------------------------------
=20
-* ``fpga_mgr_states`` -  Values for :c:expr:`fpga_manager->state`.
-* struct fpga_manager -  the FPGA manager struct
-* struct fpga_manager_ops -  Low level FPGA manager driver ops
-* devm_fpga_mgr_create() -  Allocate and init a manager struct
-* fpga_mgr_register() -  Register an FPGA manager
-* fpga_mgr_unregister() -  Unregister an FPGA manager
+* ``fpga_mgr_states`` ---  Values for :c:expr:`fpga_manager->state`.
+* struct fpga_manager ---  the FPGA manager struct
+* struct fpga_manager_ops ---  Low level FPGA manager driver ops
+* devm_fpga_mgr_create() ---  Allocate and init a manager struct
+* fpga_mgr_register() ---  Register an FPGA manager
+* fpga_mgr_unregister() ---  Unregister an FPGA manager
=20
 .. kernel-doc:: include/linux/fpga/fpga-mgr.h
    :functions: fpga_mgr_states
diff --git a/Documentation/driver-api/fpga/fpga-programming.rst b/Documenta=
tion/driver-api/fpga/fpga-programming.rst
index fb4da4240e96..adc725855bad 100644
--- a/Documentation/driver-api/fpga/fpga-programming.rst
+++ b/Documentation/driver-api/fpga/fpga-programming.rst
@@ -84,10 +84,10 @@ will generate that list.  Here's some sample code of wh=
at to do next::
 API for programming an FPGA
 ---------------------------
=20
-* fpga_region_program_fpga() -  Program an FPGA
-* fpga_image_info() -  Specifies what FPGA image to program
-* fpga_image_info_alloc() -  Allocate an FPGA image info struct
-* fpga_image_info_free() -  Free an FPGA image info struct
+* fpga_region_program_fpga() ---  Program an FPGA
+* fpga_image_info() ---  Specifies what FPGA image to program
+* fpga_image_info_alloc() ---  Allocate an FPGA image info struct
+* fpga_image_info_free() ---  Free an FPGA image info struct
=20
 .. kernel-doc:: drivers/fpga/fpga-region.c
    :functions: fpga_region_program_fpga
diff --git a/Documentation/driver-api/fpga/fpga-region.rst b/Documentation/=
driver-api/fpga/fpga-region.rst
index 2636a27c11b2..6c0c2541de04 100644
--- a/Documentation/driver-api/fpga/fpga-region.rst
+++ b/Documentation/driver-api/fpga/fpga-region.rst
@@ -45,19 +45,19 @@ An example of usage can be seen in the probe function o=
f [#f2]_.
 API to add a new FPGA region
 ----------------------------
=20
-* struct fpga_region - The FPGA region struct
-* devm_fpga_region_create() - Allocate and init a region struct
-* fpga_region_register() -  Register an FPGA region
-* fpga_region_unregister() -  Unregister an FPGA region
+* struct fpga_region --- The FPGA region struct
+* devm_fpga_region_create() --- Allocate and init a region struct
+* fpga_region_register() ---  Register an FPGA region
+* fpga_region_unregister() ---  Unregister an FPGA region
=20
 The FPGA region's probe function will need to get a reference to the FPGA
 Manager it will be using to do the programming.  This usually would happen
 during the region's probe function.
=20
-* fpga_mgr_get() - Get a reference to an FPGA manager, raise ref count
-* of_fpga_mgr_get() -  Get a reference to an FPGA manager, raise ref count,
+* fpga_mgr_get() --- Get a reference to an FPGA manager, raise ref count
+* of_fpga_mgr_get() ---  Get a reference to an FPGA manager, raise ref cou=
nt,
   given a device node.
-* fpga_mgr_put() - Put an FPGA manager
+* fpga_mgr_put() --- Put an FPGA manager
=20
 The FPGA region will need to specify which bridges to control while progra=
mming
 the FPGA.  The region driver can build a list of bridges during probe time
@@ -66,11 +66,11 @@ the list of bridges to program just before programming
 (:c:expr:`fpga_region->get_bridges`).  The FPGA bridge framework supplies =
the
 following APIs to handle building or tearing down that list.
=20
-* fpga_bridge_get_to_list() - Get a ref of an FPGA bridge, add it to a
+* fpga_bridge_get_to_list() --- Get a ref of an FPGA bridge, add it to a
   list
-* of_fpga_bridge_get_to_list() - Get a ref of an FPGA bridge, add it to a
+* of_fpga_bridge_get_to_list() --- Get a ref of an FPGA bridge, add it to a
   list, given a device node
-* fpga_bridges_put() - Given a list of bridges, put them
+* fpga_bridges_put() --- Given a list of bridges, put them
=20
 .. kernel-doc:: include/linux/fpga/fpga-region.h
    :functions: fpga_region
diff --git a/Documentation/driver-api/iio/buffers.rst b/Documentation/drive=
r-api/iio/buffers.rst
index 24569ff0cf79..906dfc10b7ef 100644
--- a/Documentation/driver-api/iio/buffers.rst
+++ b/Documentation/driver-api/iio/buffers.rst
@@ -2,11 +2,11 @@
 Buffers
 =3D=3D=3D=3D=3D=3D=3D
=20
-* struct iio_buffer - general buffer structure
-* :c:func:`iio_validate_scan_mask_onehot` - Validates that exactly one cha=
nnel
+* struct iio_buffer --- general buffer structure
+* :c:func:`iio_validate_scan_mask_onehot` --- Validates that exactly one c=
hannel
   is selected
-* :c:func:`iio_buffer_get` - Grab a reference to the buffer
-* :c:func:`iio_buffer_put` - Release the reference to the buffer
+* :c:func:`iio_buffer_get` --- Grab a reference to the buffer
+* :c:func:`iio_buffer_put` --- Release the reference to the buffer
=20
 The Industrial I/O core offers a way for continuous data capture based on a
 trigger source. Multiple data channels can be read at once from
diff --git a/Documentation/driver-api/iio/hw-consumer.rst b/Documentation/d=
river-api/iio/hw-consumer.rst
index 75986358fc02..06969fde2086 100644
--- a/Documentation/driver-api/iio/hw-consumer.rst
+++ b/Documentation/driver-api/iio/hw-consumer.rst
@@ -8,11 +8,11 @@ software buffer for data. The implementation can be found=
 under
 :file:`drivers/iio/buffer/hw-consumer.c`
=20
=20
-* struct iio_hw_consumer - Hardware consumer structure
-* :c:func:`iio_hw_consumer_alloc` - Allocate IIO hardware consumer
-* :c:func:`iio_hw_consumer_free` - Free IIO hardware consumer
-* :c:func:`iio_hw_consumer_enable` - Enable IIO hardware consumer
-* :c:func:`iio_hw_consumer_disable` - Disable IIO hardware consumer
+* struct iio_hw_consumer --- Hardware consumer structure
+* :c:func:`iio_hw_consumer_alloc` --- Allocate IIO hardware consumer
+* :c:func:`iio_hw_consumer_free` --- Free IIO hardware consumer
+* :c:func:`iio_hw_consumer_enable` --- Enable IIO hardware consumer
+* :c:func:`iio_hw_consumer_disable` --- Disable IIO hardware consumer
=20
=20
 HW consumer setup
diff --git a/Documentation/driver-api/iio/triggered-buffers.rst b/Documenta=
tion/driver-api/iio/triggered-buffers.rst
index 7c37b2afa1ad..49831ff466c5 100644
--- a/Documentation/driver-api/iio/triggered-buffers.rst
+++ b/Documentation/driver-api/iio/triggered-buffers.rst
@@ -7,10 +7,10 @@ Now that we know what buffers and triggers are let's see =
how they work together.
 IIO triggered buffer setup
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=20
-* :c:func:`iio_triggered_buffer_setup` - Setup triggered buffer and pollfu=
nc
-* :c:func:`iio_triggered_buffer_cleanup` - Free resources allocated by
+* :c:func:`iio_triggered_buffer_setup` --- Setup triggered buffer and poll=
func
+* :c:func:`iio_triggered_buffer_cleanup` --- Free resources allocated by
   :c:func:`iio_triggered_buffer_setup`
-* struct iio_buffer_setup_ops - buffer setup related callbacks
+* struct iio_buffer_setup_ops --- buffer setup related callbacks
=20
 A typical triggered buffer setup looks like this::
=20
diff --git a/Documentation/driver-api/iio/triggers.rst b/Documentation/driv=
er-api/iio/triggers.rst
index a5d1fc15747c..5b3d475bc871 100644
--- a/Documentation/driver-api/iio/triggers.rst
+++ b/Documentation/driver-api/iio/triggers.rst
@@ -2,11 +2,11 @@
 Triggers
 =3D=3D=3D=3D=3D=3D=3D=3D
=20
-* struct iio_trigger - industrial I/O trigger device
-* :c:func:`devm_iio_trigger_alloc` - Resource-managed iio_trigger_alloc
-* :c:func:`devm_iio_trigger_register` - Resource-managed iio_trigger_regis=
ter
+* struct iio_trigger --- industrial I/O trigger device
+* :c:func:`devm_iio_trigger_alloc` --- Resource-managed iio_trigger_alloc
+* :c:func:`devm_iio_trigger_register` --- Resource-managed iio_trigger_reg=
ister
   iio_trigger_unregister
-* :c:func:`iio_trigger_validate_own_device` - Check if a trigger and IIO
+* :c:func:`iio_trigger_validate_own_device` --- Check if a trigger and IIO
   device belong to the same device
=20
 In many situations it is useful for a driver to be able to capture data ba=
sed
@@ -63,7 +63,7 @@ Let's see a simple example of how to setup a trigger to b=
e used by a driver::
 IIO trigger ops
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-* struct iio_trigger_ops - operations structure for an iio_trigger.
+* struct iio_trigger_ops --- operations structure for an iio_trigger.
=20
 Notice that a trigger has a set of operations attached:
=20
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/=
index.rst
index 29eb9230b7a9..e07e0d39c7f0 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -4,7 +4,7 @@ The Linux driver implementer's API guide
=20
 The kernel offers a wide variety of interfaces to support the development
 of device drivers.  This document is an only somewhat organized collection
-of some of those interfaces - it will hopefully get better over time!  The
+of some of those interfaces --- it will hopefully get better over time!  T=
he
 available subsections can be seen below.
=20
 .. class:: toc-title
diff --git a/Documentation/driver-api/media/drivers/vidtv.rst b/Documentati=
on/driver-api/media/drivers/vidtv.rst
index abb454302ac5..c3821d82df17 100644
--- a/Documentation/driver-api/media/drivers/vidtv.rst
+++ b/Documentation/driver-api/media/drivers/vidtv.rst
@@ -458,8 +458,8 @@ Add a way to test video
=20
 Currently, vidtv can only encode PCM audio. It would be great to implement
 a barebones version of MPEG-2 video encoding so we can also test video. The
-first place to look into is *ISO 13818-2: Information technology - Generic
-coding of moving pictures and associated audio information - Part 2: Video=
*,
+first place to look into is *ISO 13818-2: Information technology --- Gener=
ic
+coding of moving pictures and associated audio information --- Part 2: Vid=
eo*,
 which covers the encoding of compressed video in MPEG Transport Streams.
=20
 This might optionally use the Video4Linux2 Test Pattern Generator, v4l2-tp=
g,
diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver=
-api/nvdimm/btt.rst
index dd91a495e02e..1d2d9cd40def 100644
--- a/Documentation/driver-api/nvdimm/btt.rst
+++ b/Documentation/driver-api/nvdimm/btt.rst
@@ -91,7 +91,7 @@ Bit      Description
 	   0  0	  Initial state. Reads return zeroes; Premap =3D Postmap
 	   0  1	  Zero state: Reads return zeroes
 	   1  0	  Error state: Reads fail; Writes clear 'E' bit
-	   1  1	  Normal Block - has valid postmap
+	   1  1	  Normal Block -- has valid postmap
 	   =3D=3D =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 29 - 0	 Mappings to internal 'postmap' blocks
diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems=
/f2fs.rst
index 19d2cf477fc3..9b0e9abf8f88 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -42,7 +42,7 @@ areas on disk for fast writing, we divide  the log into s=
egments and use a
 segment cleaner to compress the live information from heavily fragmented
 segments." from Rosenblum, M. and Ousterhout, J. K., 1992, "The design and
 implementation of a log-structured file system", ACM Trans. Computer Syste=
ms
-10, 1, 26-52.
+10, 1, 26--52.
=20
 Wandering Tree Problem
 ----------------------
diff --git a/Documentation/hwmon/tmp103.rst b/Documentation/hwmon/tmp103.rst
index b3ef81475cf8..051282bd88b7 100644
--- a/Documentation/hwmon/tmp103.rst
+++ b/Documentation/hwmon/tmp103.rst
@@ -21,10 +21,10 @@ Description
 The TMP103 is a digital output temperature sensor in a four-ball
 wafer chip-scale package (WCSP). The TMP103 is capable of reading
 temperatures to a resolution of 1=C2=B0C. The TMP103 is specified for
-operation over a temperature range of -40=C2=B0C to +125=C2=B0C.
+operation over a temperature range of --40=C2=B0C to +125=C2=B0C.
=20
 Resolution: 8 Bits
-Accuracy: =C2=B11=C2=B0C Typ (-10=C2=B0C to +100=C2=B0C)
+Accuracy: =C2=B11=C2=B0C Typ (--10=C2=B0C to +100=C2=B0C)
=20
 The driver provides the common sysfs-interface for temperatures (see
 Documentation/hwmon/sysfs-interface.rst under Temperatures).
diff --git a/Documentation/index.rst b/Documentation/index.rst
index 11cd806ea3a4..7ae88aa57d98 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -30,7 +30,7 @@ tree, as well as links to the full license text.
 User-oriented documentation
 ---------------------------
=20
-The following manuals are written for *users* of the kernel - those who are
+The following manuals are written for *users* of the kernel --- those who =
are
 trying to get it to work optimally on a given system.
=20
 .. toctree::
@@ -90,7 +90,7 @@ Kernel API documentation
 These books get into the details of how specific kernel subsystems work
 from the point of view of a kernel developer.  Much of the information here
 is taken directly from the kernel source, with supplemental material added
-as needed (or at least as we managed to add it - probably *not* all that is
+as needed (or at least as we managed to add it --- probably *not* all that=
 is
 needed).
=20
 .. toctree::
diff --git a/Documentation/infiniband/tag_matching.rst b/Documentation/infi=
niband/tag_matching.rst
index b89528a31d10..2c26f76e43f9 100644
--- a/Documentation/infiniband/tag_matching.rst
+++ b/Documentation/infiniband/tag_matching.rst
@@ -8,8 +8,8 @@ match the following source and destination parameters:
=20
 *	Communicator
 *	User tag - wild card may be specified by the receiver
-*	Source rank - wild car may be specified by the receiver
-*	Destination rank - wild
+*	Source rank -- wild car may be specified by the receiver
+*	Destination rank -- wild
=20
 The ordering rules require that when more than one pair of send and receive
 message envelopes may match, the pair that includes the earliest posted-se=
nd
diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rs=
t b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
index 64024c77c9ca..e3e52b0e6b5e 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
@@ -173,7 +173,7 @@ Director rule is added from ethtool (Sideband filter), =
ATR is turned off by the
 driver. To re-enable ATR, the sideband can be disabled with the ethtool -K
 option. For example::
=20
-  ethtool -K [adapter] ntuple [off|on]
+  ethtool --K [adapter] ntuple [off|on]
=20
 If sideband is re-enabled after ATR is re-enabled, ATR remains enabled unt=
il a
 TCP-IP flow is added. When all TCP-IP sideband rules are deleted, ATR is
@@ -688,7 +688,7 @@ shaper bw_rlimit: for each tc, sets minimum and maximum=
 bandwidth rates.
 Totals must be equal or less than port speed.
=20
 For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
-monitoring tools such as ifstat or sar -n DEV [interval] [number of sample=
s]
+monitoring tools such as ifstat or sar --n DEV [interval] [number of sampl=
es]
=20
 2. Enable HW TC offload on interface::
=20
diff --git a/Documentation/networking/device_drivers/ethernet/intel/iavf.rs=
t b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
index 25e98494b385..44d2f85738b1 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
@@ -179,7 +179,7 @@ shaper bw_rlimit: for each tc, sets minimum and maximum=
 bandwidth rates.
 Totals must be equal or less than port speed.
=20
 For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
-monitoring tools such as ifstat or sar -n DEV [interval] [number of sample=
s]
+monitoring tools such as ifstat or sar --n DEV [interval] [number of sampl=
es]
=20
 NOTE:
   Setting up channels via ethtool (ethtool -L) is not supported when the
diff --git a/Documentation/riscv/vm-layout.rst b/Documentation/riscv/vm-lay=
out.rst
index 545f8ab51f1a..05615b3021bb 100644
--- a/Documentation/riscv/vm-layout.rst
+++ b/Documentation/riscv/vm-layout.rst
@@ -22,7 +22,7 @@ RISC-V Linux Kernel 64bit
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 The RISC-V privileged architecture document states that the 64bit addresses
-"must have bits 63-48 all equal to bit 47, or else a page-fault exception =
will
+"must have bits 63--48 all equal to bit 47, or else a page-fault exception=
 will
 occur.": that splits the virtual address space into 2 halves separated by =
a very
 big hole, the lower half is where the userspace resides, the upper half is=
 where
 the RISC-V Linux Kernel resides.
diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/sch=
eduler/sched-deadline.rst
index 0ff353ecf24e..b261ec2ab2ef 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -515,7 +515,7 @@ Deadline Task Scheduling
       pp 760-768, 2005.
   10 - J. Goossens, S. Funk and S. Baruah, Priority-Driven Scheduling of
        Periodic Task Systems on Multiprocessors. Real-Time Systems Journal,
-       vol. 25, no. 2-3, pp. 187-205, 2003.
+       vol. 25, no. 2--3, pp. 187--205, 2003.
   11 - R. Davis and A. Burns. A Survey of Hard Real-Time Scheduling for
        Multiprocessor Systems. ACM Computing Surveys, vol. 43, no. 4, 2011.
        http://www-users.cs.york.ac.uk/~robdavis/papers/MPSurveyv5.0.pdf
diff --git a/Documentation/userspace-api/media/v4l/biblio.rst b/Documentati=
on/userspace-api/media/v4l/biblio.rst
index 6e07b78bd39d..7b8e6738ff9e 100644
--- a/Documentation/userspace-api/media/v4l/biblio.rst
+++ b/Documentation/userspace-api/media/v4l/biblio.rst
@@ -51,7 +51,7 @@ ISO 13818-1
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
=20
-:title:     ITU-T Rec. H.222.0 | ISO/IEC 13818-1 "Information technology -=
 Generic coding of moving pictures and associated audio information: System=
s"
+:title:     ITU-T Rec. H.222.0 | ISO/IEC 13818-1 "Information technology -=
-- Generic coding of moving pictures and associated audio information: Syst=
ems"
=20
 :author:    International Telecommunication Union (http://www.itu.ch), Int=
ernational Organisation for Standardisation (http://www.iso.ch)
=20
@@ -61,7 +61,7 @@ ISO 13818-2
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
=20
-:title:     ITU-T Rec. H.262 | ISO/IEC 13818-2 "Information technology - G=
eneric coding of moving pictures and associated audio information: Video"
+:title:     ITU-T Rec. H.262 | ISO/IEC 13818-2 "Information technology ---=
 Generic coding of moving pictures and associated audio information: Video"
=20
 :author:    International Telecommunication Union (http://www.itu.ch), Int=
ernational Organisation for Standardisation (http://www.iso.ch)
=20
@@ -150,7 +150,7 @@ ITU-T.81
 =3D=3D=3D=3D=3D=3D=3D=3D
=20
=20
-:title:     ITU-T Recommendation T.81 "Information Technology - Digital Co=
mpression and Coding of Continous-Tone Still Images - Requirements and Guid=
elines"
+:title:     ITU-T Recommendation T.81 "Information Technology --- Digital =
Compression and Coding of Continous-Tone Still Images --- Requirements and =
Guidelines"
=20
 :author:    International Telecommunication Union (http://www.itu.int)
=20
@@ -310,7 +310,7 @@ ISO 12232:2006
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
=20
-:title:     Photography - Digital still cameras - Determination of exposur=
e index, ISO speed ratings, standard output sensitivity, and recommended ex=
posure index
+:title:     Photography --- Digital still cameras --- Determination of exp=
osure index, ISO speed ratings, standard output sensitivity, and recommende=
d exposure index
=20
 :author:    International Organization for Standardization (http://www.iso=
.org)
=20
diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documentati=
on/virt/kvm/running-nested-guests.rst
index e9dff3fea055..8b83b86560da 100644
--- a/Documentation/virt/kvm/running-nested-guests.rst
+++ b/Documentation/virt/kvm/running-nested-guests.rst
@@ -26,12 +26,12 @@ this document is built on this example)::
=20
 Terminology:
=20
-- L0 - level-0; the bare metal host, running KVM
+- L0 -- level-0; the bare metal host, running KVM
=20
-- L1 - level-1 guest; a VM running on L0; also called the "guest
+- L1 -- level-1 guest; a VM running on L0; also called the "guest
   hypervisor", as it itself is capable of running KVM.
=20
-- L2 - level-2 guest; a VM running on L1, this is the "nested guest"
+- L2 -- level-2 guest; a VM running on L1, this is the "nested guest"
=20
 .. note:: The above diagram is modelled after the x86 architecture;
           s390x, ppc64 and other architectures are likely to have
@@ -39,7 +39,7 @@ Terminology:
=20
           For example, s390x always has an LPAR (LogicalPARtition)
           hypervisor running on bare metal, adding another layer and
-          resulting in at least four levels in a nested setup - L0 (bare
+          resulting in at least four levels in a nested setup --- L0 (bare
           metal, running the LPAR hypervisor), L1 (host hypervisor), L2
           (guest hypervisor), L3 (nested guest).
=20
@@ -167,11 +167,11 @@ Enabling "nested" (s390x)
     $ modprobe kvm nested=3D1
=20
 .. note:: On s390x, the kernel parameter ``hpage`` is mutually exclusive
-          with the ``nested`` paramter - i.e. to be able to enable
+          with the ``nested`` paramter --- i.e. to be able to enable
           ``nested``, the ``hpage`` parameter *must* be disabled.
=20
 2. The guest hypervisor (L1) must be provided with the ``sie`` CPU
-   feature - with QEMU, this can be done by using "host passthrough"
+   feature --- with QEMU, this can be done by using "host passthrough"
    (via the command-line ``-cpu host``).
=20
 3. Now the KVM module can be loaded in the L1 (guest hypervisor)::

