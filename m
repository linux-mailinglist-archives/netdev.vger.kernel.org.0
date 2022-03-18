Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17C4DDEAC
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbiCRQWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbiCRQWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:22:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5D6A180205
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nkT5UIYivW5SFiCEpbqJoYmzN8iv9pwyawnhfGj5UQ=;
        b=HmXSffYpj3crE2Pf++dVEX3yytWWnlo5eB94oJpSBAYczNSY1sxXiDFb2vTG3mlIIAzZJ7
        6IQlgiZAF0hZKkHmgxC9qAhDoRGSZnLiF6BInLXLakvM1mIo2Tnf0C5iJbwWfs0n9HaMs+
        pZ2fv0carNawn8XTLAqgNQkXJpgXTnA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-3xVfldHIP7OokTFHQ4LbEw-1; Fri, 18 Mar 2022 12:18:19 -0400
X-MC-Unique: 3xVfldHIP7OokTFHQ4LbEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B100510113D8;
        Fri, 18 Mar 2022 16:18:18 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81E3533250;
        Fri, 18 Mar 2022 16:18:15 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v3 17/17] Documentation: add HID-BPF docs
Date:   Fri, 18 Mar 2022 17:15:28 +0100
Message-Id: <20220318161528.1531164-18-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gives a primer on HID-BPF.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v3
---
 Documentation/hid/hid-bpf.rst | 444 ++++++++++++++++++++++++++++++++++
 Documentation/hid/index.rst   |   1 +
 include/uapi/linux/bpf_hid.h  |  54 ++++-
 3 files changed, 492 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/hid/hid-bpf.rst

diff --git a/Documentation/hid/hid-bpf.rst b/Documentation/hid/hid-bpf.rst
new file mode 100644
index 000000000000..0bf0d937b0e1
--- /dev/null
+++ b/Documentation/hid/hid-bpf.rst
@@ -0,0 +1,444 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======
+HID-BPF
+=======
+
+HID is a standard protocol for input devices and it can greatly make use
+of the eBPF capabilities to speed up development and add new capabilities
+to the existing HID interfaces.
+
+.. contents::
+    :local:
+    :depth: 2
+
+
+When (and why) using HID-BPF
+============================
+
+We can enumerate several use cases for when using HID-BPF is better than
+using a standard kernel driver fix.
+
+dead zone of a joystick
+-----------------------
+
+Assuming you have a joystick that is getting older, it is common to see it
+wobbling around its neutral point. This is usually filtered at the application
+level by adding a *dead zone* for this specific axis.
+
+With HID-BPF, we can put the filtering of this dead zone in the kernel directly
+so we don't wake up userspace when nothing else is happening on the input
+controller.
+
+Of course, given that this dead zone is device specific, we can not create a
+generic fix for all of the same joysticks. We *could* create a custom kernel
+API for this (by adding a sysfs for instance), but there is no guarantees this
+new kernel API will be broadly adopted and maintained.
+
+HID-BPF allows the userspace program who knows it will make use of this capability
+to load the program itself, ensuring we only load the custom API when we have a user.
+
+simple fixup of report descriptor
+---------------------------------
+
+In the HID tree, we have half of the drivers that are "simple" and
+that just fix one key or one byte in the report descriptor.
+Currently, for users of such devices, the process of fixing them
+is long and painful.
+
+With eBPF, we can reduce the burden of building those fixup kernel patches
+by providing an eBPF program that does it. Once this has been validated by
+the user, we can then embed the source code into the kernel tree and ship it
+and load it directly instead of loading a specific kernel module for it.
+
+Note: the distribution and inclusion in the kernel is still not there yet.
+
+add a new fancy feature that requires a new kernel API
+------------------------------------------------------
+
+We have the case currently for the Universal Stylus Interface pens for example.
+Basically, USI pens are requiring a new kernel API because there are
+some channels of communication our HID and input stack are not capable
+of. Instead of using hidraw or creating new sysfs or ioctls, we can rely
+on eBPF to have the kernel API controlled by the consumer and to not
+impact the performances by waking up userspace every time there is an
+event.
+
+morph a device into something else and control that from userspace
+------------------------------------------------------------------
+
+Right now, the kernel has to make a choice on how a device looks like.
+For that, it can not decide to transform a given device into something else
+because that would be lying to userspace and will be even more harder to
+unwind when we need the actual definition of the device.
+
+However, sometimes some new devices are useless with that sane way of defining
+devices. For example, the Microsoft Surface Dial is a pushbutton with haptic
+feedback that is barely usable as of today.
+
+With eBPF, userspace can morph that device into a mouse, and convert the dial
+events into wheel events. Also, the userspace program can set/unset the haptic
+feedback depending on the context. For example, if a menu is popped-up on the
+screen we likely need to have a haptic click every 5 degrees, while when
+we are fine-grain scrolling in a web page, we probably want the best resolution
+without those annoying clicks.
+
+firewall
+--------
+
+What if we want to prevent other users to access a specific feature of a
+device? (think a possibly bonker firmware update entry popint)
+
+With eBPF, we can intercept any HID command emitted to the device and
+validate it or not.
+
+This also allows to sync the state between the userspace and the
+kernel/bpf program because we can intercept any incoming command.
+
+tracing
+-------
+
+The last usage is tracing events and all the fun we can do we BPF to summarize
+and analyze events.
+
+Right now, tracing relies on hidraw. It works well except for a couple
+of issues:
+
+1. if the driver doesn't export a hidraw node, we can't trace anything
+   (eBPF will be a "god-mode" there, so it might raise some eyebrows)
+2. hidraw doesn't catch the other process requests to the device, which
+   means that we have cases where we need to add printks to the kernel
+   to understand what is happening.
+
+High-level view of HID-BPF
+==========================
+
+The main idea behind HID-BPF is that it works at an array of bytes level.
+Thus, all of the parsing of the HID report and the HID report descriptor
+must be implemented in the userspace component that loads the eBPF
+program.
+
+For example, in the dead zone joystick from above, knowing which fields
+in the data stream needs to be set to ``0`` needs to be computed by userspace.
+
+A corrolar of this is that HID-BPF doesn't know about the other subsystems
+available in the kernel. *You can not directly emit input event through the
+input API from eBPF*.
+
+When a BPF program need to emit input events, it needs to talk HID, and rely
+on the HID kernel processing to translate the HID data into input events.
+
+Available types of programs
+===========================
+
+HID-BPF has the following attachment types available:
+
+1. ``BPF_HID_DEVICE_EVENT`` defined with a ``SEC("hid/device_event")`` in libbpf
+2. ``BPF_HID_USER_EVENT`` defined with a ``SEC("hid/user_event")`` in libbpf
+3. ``BPF_HID_DRIVER_EVENT`` defined with a ``SEC("hid/driver_event")`` in libbpf
+4. ``BPF_HID_RDESC_FIXUP`` defined with a ``SEC("hid/rdesc_fixup")`` in libbpf
+
+The above types are defined based on where the event came from.
+
+A ``BPF_HID_DEVICE_EVENT`` is calling a BPF program when an event is received from
+the device. Thus we are in IRQ context and can act on the data or notify userspace.
+
+In the same way, a ``BPF_HID_USER_EVENT`` means that userspace called the syscall
+``BPF_PROG_RUN`` facility.
+
+A ``BPF_HID_DRIVER_EVENT`` means that the kernel driver emitted an event that the bpf
+programs want to be notified of. Such events are resume, reset, probed, but also
+a call to a request toward the device (a call to ``hid_hw_raw_request()`` for example).
+
+Last, ``BPF_HID_RDESC_FIXUP`` is different from the others as there can be only one
+BPF program of this type. This is called on ``probe`` from the driver and allows to
+change the report descriptor from the BPF program.
+
+General overview of a HID-BPF program
+=====================================
+
+User API available as a context in programs
+-------------------------------------------
+
+.. kernel-doc:: include/uapi/linux/bpf_hid.h
+
+Accessing the data attached to the context
+------------------------------------------
+
+The ``struct hid_bpf_ctx`` doesn't export the ``data`` fields directly and to access
+it, a bpf program needs to first call ``bpf_hid_get_data(context, offset, size)``.
+
+``offset`` can be any integer, but ``size`` needs to be constant, known at compile
+time.
+
+This allows the following:
+
+1. for a given device, if we know that the report length will always be of a certain value,
+   we can request the ``data`` pointer to point at the full report length.
+
+   The kernel will ensure we are using a correct size and offset and eBPF will ensure
+   the code will not attempt to read or write outside of the boundaries::
+
+     __u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 256 /* size */);
+
+     if (!data)
+         return 0; /* ensure data is correct, now the verifier knows we
+                    * have 256 bytes available */
+
+     bpf_printk("hello world: %02x %02x %02x", data[0], data[128], data[255]);
+
+2. if the report length is variable, but we know the value of ``X`` is always a 16-bits
+   integer, we can then have a pointer to that value only::
+
+      __u16 *x = bpf_hid_get_data(ctx, offset, sizeof(*x));
+
+      if (!x)
+          return 0; /* something when wrong */
+
+      *x += 1; /* increment X by one */
+
+Bit access of data field (an alternative to ``bpf_hid_get_data``)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The HID devices often work at the bit level in the emitted report.
+For instance, a given button will be at a given offset (in bits) in the report
+and usually of size 1 bit.
+
+In order to easily access those data, BPF program can rely on ``bpf_hid_get_bits()``
+and ``bpf_hid_set_bits()``.
+
+Those 2 functions do not require any of the arguments to be a constant like
+``bpf_hid_get_data()``, meaning that they are appropriate for accessing
+a field unknown at compile time of an unknown size.
+The counterpart of those 2 helpers is that they are effectively copying the
+data to/from a ``__u32`` instead of having a direct pointer access to the
+field.
+
+Effect of a HID-BPF program
+---------------------------
+
+For all HID-BPF attachment types except for ``BPF_HID_RDESC_FIXUP``, several eBPF
+programs can be attached to the same device.
+
+Unless ``BPF_F_INSERT_HEAD`` is added to the flags while attaching the program, the
+new program is appended at the end of the list. In some cases (tracing for instance)
+we need to get the unprocessed events from the device, and ``BPF_F_INSERT_HEAD`` will
+insert the new program at the beginning of the list.
+
+Note however that there is no guarantees that another program is loaded with that
+same flag, and thus our program may be second in the list.
+
+``BPF_HID_DEVICE_EVENT``
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+Whenever a matching event is raised, the eBPF programs are called one after the other
+and are working on the same data buffer.
+
+If a program changes the data associated with the context, the next one will see
+the new data and will have *no* idea of what the original data was.
+
+Once all the programs are run and return ``0``, the rest of the HID stack will
+work on the modified data, with the ``size`` field of the hid_bpf_ctx being the new
+size of the input stream of data.
+
+If a BPF program returns a negative error, this has the same effect than setting
+the ``size`` field of ``hid_bpf_ctx`` to ``0``: the event is dropped from the HID
+processing. No clients (hidraw, input, LEDs) will ever see that event coming in.
+
+``BPF_HID_USER_EVENT``
+~~~~~~~~~~~~~~~~~~~~~~
+
+One can attach several ``BPF_HID_USER_EVENT`` on a given device. But because the caller
+needs to set which BPF program is used when calling the syscall ``BPF_PROG_RUN``, only
+this particular BPF program will be run.
+
+The ``data`` associated with the ``hid_bpf_ctx`` contains the input data of the given
+syscall and is big enough to contain both the input data and the requested output data.
+
+The output data from the syscall, if ``size_out`` is set to a positive value, is copied
+from the content of the ``data`` field of ``hid_bpf_ctx``.
+
+``BPF_HID_DRIVER_EVENT``
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+The availability of the ``data`` field of ``hid_bpf_ctx`` depends on the event subtype:
+
+* **probe** event: ``data`` contains the report descriptor of the device (this is read-only)
+* **reset**, **resume** events: no data is provided
+* **device request**: ``data`` contains the incoming request made to the device. The BPF
+  program can decide whether or not forwarding the request to the device.
+* **device request answer**: ``data`` contains the answer of the request.
+
+``BPF_HID_RDESC_FIXUP``
+~~~~~~~~~~~~~~~~~~~~~~~
+
+Last, the ``BPF_HID_RDESC_FIXUP`` program works in the similar maneer than
+``.report_fixup`` of ``struct hid_driver``.
+
+When the device is probed, the kernel sets the data buffer of the context with the
+content of the report descriptor. The memory associated with that buffer is
+``HID_MAX_DESCRIPTOR_SIZE`` (4 kB as of now).
+
+The eBPF program can modify the data buffer at will and then the kernel uses the
+new content and size as the report descriptor.
+
+Whenever a ``BPF_HID_RDESC_FIXUP`` program is attached (if no program was attached
+before), the kernel immediately disconnects the HID device, and do a reprobe.
+
+In the same way, when the ``BPF_HID_RDESC_FIXUP`` program is detached, the kernel
+issues a disconnect on the device.
+
+To update the report descriptor in place, users can replace the current
+``BPF_HID_RDESC_FIXUP`` program through the usual ``BPF_LINK_UPDATE`` syscall.
+There will be only one disconnect emitted by the kernel.
+
+Attaching a bpf program to a device
+===================================
+
+``libbpf`` exports a helper to attach a HID-BPF program: ``bpf_program__attach_hid(program, fd, flags)``.
+
+The ``program`` and ``flags`` parameters are relatively obvious, but what about the
+``fd`` argument?
+
+While working on HID-BPF it came out quickly enough that we can not rely on
+hidraw to bind a BPF program to a HID device. hidraw is an artefact of the processing
+of the HID device, and is not stable. Some drivers even disable it, so that removes the
+tracing capabilies on those devices (where it is interesting to get the non-hidraw
+traces).
+
+The solution is to use the sysfs tree and more specifically the ``uevent`` sysfs entry.
+
+For a given HID device, we have the ``uevent`` node at ``/sys/bus/hid/devices/BUS:VID:PID.000N/uevent``.
+
+``uevent`` is convenient as it contains already some information about the device itself:
+the driver in use, the name of the HID device, its ID, its Unique field and the modalias.
+
+However, as mentioned previously, we can not really rely on hidraw for HID-BPF.
+Which means we need to get the report descriptor from the device thorugh the sysfs too.
+This is available at ``/sys/bus/hid/devices/BUS:VID:PID.000N/report_descriptor`` as a
+binary stream.
+
+Parsing the report descriptor is the responsibility of the BPF programmer or the userspace
+component that loads the eBPF program.
+
+An (almost) complete example of a BPF enhanced HID device
+=========================================================
+
+*Foreword: for most parts, this could be implemented as a kernel driver*
+
+Let's imagine we have a new tablet device that has some haptic capabilities
+to simulate the surface the user is scratching on. This device would also have
+a specific 3 positions switch to toggle between *pencil on paper*, *cray on a wall*
+and *brush on a painting canvas*. To make things even better, we can control the
+physical position of the switch through a feature report.
+
+And of course, the switch is relying on some userspace component to control the
+haptic feature of the device itself.
+
+Filtering events
+----------------
+
+The first step consists in filtering events from the device. Given that the switch
+position is actually reported in the flow of the pen events, using hidraw to implement
+that filtering would mean that we wake up userspace for every single event.
+
+This is OK for libinput, but having an external library that is just interested in
+one byte in the report is less than ideal.
+
+For that, we can create a basic skeleton for our BPF program::
+
+  #include <linux/bpf.h>
+  #include <bpf/bpf_helpers.h>
+  #include <linux/bpf_hid.h>
+
+  /* HID programs need to be GPL */
+  char _license[] SEC("license") = "GPL";
+
+  struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 4096 * 64);
+  } ringbuf SEC(".maps");
+
+  __u8 current_value = 0;
+
+  SEC("hid/device_event")
+  int filter_switch(struct hid_bpf_ctx *ctx)
+  {
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 192 /* size */);
+	__u8 *buf;
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	if (current_value != data[152]) {
+		buf = bpf_ringbuf_reserve(&ringbuf, 1, 0);
+		if (!buf)
+			return 0;
+
+		*buf = data[152];
+
+		bpf_ringbuf_commit(buf, 0);
+
+		current_value = data[152];
+	}
+
+	return 0;
+  }
+
+Our userspace program can now listen to notifications on the ring buffer, and
+is awaken only when the value changes.
+
+Controlling the device
+----------------------
+
+To be able to change the haptic feedback from the tablet, the userspace program
+needs to emit a feature report on the device itself.
+
+Instead of using hidraw for that, we can create a ``BPF_HID_USER_EVENT`` program
+that talks to the device::
+
+  SEC("hid/user_event")
+  int send_haptic(struct hid_bpf_ctx *ctx)
+  {
+	__u8 *data = bpf_hid_get_data(ctx, 0 /* offset */, 1 /* size */);
+	int ret;
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	ret = bpf_hid_raw_request(ctx, data, HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
+	ctx->retval = ret;
+
+	return 0;
+  }
+
+And then userspace needs to call that program directly::
+
+  static int set_haptic(struct hid *hid_skel, int sysfs_fd, __u8 haptic_value)
+	int err, prog_fd;
+	int ret = -1;
+
+	LIBBPF_OPTS(bpf_test_run_opts, run_attrs,
+		    .repeat = 1,
+		    .ctx_in = &sysfs_fd,
+		    .ctx_size_in = sizeof(sysfs_fd),
+		    .data_in = &haptic_value,
+		    .data_size_in = 1,
+	);
+
+	prog_fd = bpf_program__fd(hid_skel->progs.set_haptic);
+
+	err = bpf_prog_test_run_opts(prog_fd, &run_attrs);
+	return err;
+  }
+
+Now the interesting bit is that our userspace program is aware of the haptic
+state and can control it.
+
+Which means, that we can also export a dbus API for applications to change the
+haptic feedback. The dbus API would be simple (probably just a string property).
+
+The interesting bit here is that we did not created a new kernel API for this.
+Which means that if there is a bug in our implementation, we can change the
+interface with the kernel as will, because the userspace application is responsible
+for its own usage.
diff --git a/Documentation/hid/index.rst b/Documentation/hid/index.rst
index e50f513c579c..b2028f382f11 100644
--- a/Documentation/hid/index.rst
+++ b/Documentation/hid/index.rst
@@ -11,6 +11,7 @@ Human Interface Devices (HID)
    hidraw
    hid-sensor
    hid-transport
+   hid-bpf
 
    uhid
 
diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
index 64a8b9dd8809..8e907e7fe77b 100644
--- a/include/uapi/linux/bpf_hid.h
+++ b/include/uapi/linux/bpf_hid.h
@@ -11,20 +11,60 @@
 
 #include <linux/types.h>
 
+/**
+ * enum hid_bpf_event - event types in struct hid_bpf_ctx
+ *
+ * Event types are not tied to a given attach type, there might
+ * be multiple event types for one attach type.
+ *
+ * @HID_BPF_UNDEF: sentinel value, should never be set by the kernel
+ * @HID_BPF_DEVICE_EVENT: used when attach type is ``BPF_HID_DEVICE_EVENT``
+ * @HID_BPF_RDESC_FIXUP: used when attach type is ``BPF_HID_RDESC_FIXUP``
+ * @HID_BPF_USER_EVENT: used when attach type is ``BPF_HID_USER_EVENT``
+ */
 enum hid_bpf_event {
 	HID_BPF_UNDEF = 0,
-	HID_BPF_DEVICE_EVENT,		/* when attach type is BPF_HID_DEVICE_EVENT */
-	HID_BPF_RDESC_FIXUP,		/* ................... BPF_HID_RDESC_FIXUP */
-	HID_BPF_USER_EVENT,		/* ................... BPF_HID_USER_EVENT */
+	HID_BPF_DEVICE_EVENT,
+	HID_BPF_RDESC_FIXUP,
+	HID_BPF_USER_EVENT,
 };
 
 /* User accessible data for HID programs. Add new fields at the end. */
+/**
+ * struct hid_bpf_ctx - User accessible data for all HID programs
+ *
+ * ``data`` is not directly accessible from the context. We need to issue
+ * a call to ``bpf_hid_get_data()`` in order to get a pointer to that field.
+ *
+ * @type: Of type enum hid_bpf_event. This value is read-only and matters when there
+ *        is more than one event type per attachment type.
+ * @allocated_size: Allocated size of data, read-only.
+ *
+ *                  This is how much memory is available and can be requested
+ *                  by the HID program.
+ *                  Note that for ``HID_BPF_RDESC_FIXUP``, that memory is set to
+ *                  ``4096`` (4 KB)
+ * @size: Valid data in the data field, read-write.
+ *
+ *        Programs can get the available valid size in data by fetching this field.
+ *        Programs can also change this value and even set it to ``0`` to discard the
+ *        data from this event.
+ *
+ *        ``size`` must always be less or equal than ``allocated_size`` (it is enforced
+ *        once all BPF programs have been run).
+ * @retval: Return value of the program when type is ``HID_BPF_USER_EVENT``, read-write.
+ *
+ *          Returning from the program an error means that the execution of the program
+ *          failed. However, one may want to express that the program executed correctly,
+ *          but the underlying calls failed for a specific reason. This is when we use
+ *          retval.
+ */
 struct hid_bpf_ctx {
-	__u32	type;			/* enum hid_bpf_event, RO */
-	__u32	allocated_size;		/* allocated size of data, RO */
+	__u32	type;
+	__u32	allocated_size;
 
-	__u32	size;			/* valid data in data field, RW */
-	__s32	retval;			/* when type is HID_BPF_USER_EVENT, RW */
+	__u32	size;
+	__s32	retval;
 };
 
 #endif /* _UAPI__LINUX_BPF_HID_H__ */
-- 
2.35.1

