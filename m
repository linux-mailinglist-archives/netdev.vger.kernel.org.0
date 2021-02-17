Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D2331D3B2
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhBQBN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhBQBKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:10:11 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04204C06121C;
        Tue, 16 Feb 2021 17:09:04 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b8so6484505plh.12;
        Tue, 16 Feb 2021 17:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q1UuE0qBxhnnVS107NY6bBjPoOkYenkq/PEKhaBEofQ=;
        b=ioAk5+TH38cqb12aanbaKhecpIESk6QbzMsAwhh6pDgbM+gxr4gjnh6awP7BFd4cC9
         FpoDhaj8TnMKcUl8ThKf6V91Jhi1bsTv+6rXAOmn0zgV0WNJ+mX42AdvzQbSvPLfwEvg
         R6XEwVHXo09wPKqnY4aHiJuFf3CfnfY/F/UhjkZICbmh5hxnvDTclRFNwXGjSFvU9qoZ
         8KE6oYlfCQj0u5AKLTqv79sMZTkNYoJOk7+88sMOm7CEbnn5xejyDgrQqGTly7nGLyC1
         m14C1NbfAkhvv5OL1BJmbXZbWBOrHWSy4CTWyt8M6AH7IBNexPKo53LNNRyalXCogcm0
         E+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Q1UuE0qBxhnnVS107NY6bBjPoOkYenkq/PEKhaBEofQ=;
        b=B1Znls1nCAYEk+Lysy3XL9VT+NRf0N3evK5SDdP/9FumR95L6dKLcTjJjIgYSp+210
         5cilnIgE0sYfx/j1HtKO6yEcVMxk8R1NHHFKRGrmoWLgRKRXf+bNUkAZ6gCmoVV+WTnD
         /ZmS1Tg3HzyFUCBR/AT/ChtBAwy/eUTH70lKi6lHqtz+zOoP7ng4M3LMIIq9WuTFkJLf
         kWXZK8xgH7DfEiCzq/5O3Rmaa27eU9Io6USCWVWgZts5MB6j0LVfxfXlI7rD/lFtEMZg
         fl5mxEq1mytmwpZdiKtsW72fQf/3bkXVofAHvKdW20tIqJ2JJ6aLafOAXHlswsH11Z0B
         aGcA==
X-Gm-Message-State: AOAM531lNaJR21R0SQTpV4EJQiHDdbwHv5tM0/wlZjtMGwsOCn0ZYQ24
        TJODBWTQkoU5fNsyChcTiuw9KyEBA4dg3Q==
X-Google-Smtp-Source: ABdhPJxB1OfExApGt5rtJ7PuBsbOi0c6Zx6yWiAksVmsIP1otyS5asm+uHspj0JtCFFhT9lIpiCNHA==
X-Received: by 2002:a17:90b:1008:: with SMTP id gm8mr6928780pjb.174.1613524142407;
        Tue, 16 Feb 2021 17:09:02 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:09:01 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 17/17] tools: Sync uapi bpf.h header with latest changes
Date:   Tue, 16 Feb 2021 17:08:21 -0800
Message-Id: <20210217010821.1810741-18-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Synchronize the header after all of the recent changes.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 tools/include/uapi/linux/bpf.h | 707 ++++++++++++++++++++++++++++++++-
 1 file changed, 706 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 16f2f0d2338a..4abf54327612 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -93,7 +93,712 @@ union bpf_iter_link_info {
 	} map;
 };
 
-/* BPF syscall commands, see bpf(2) man-page for details. */
+/* BPF syscall commands, see bpf(2) man-page for more details.
+ *
+ * The operation to be performed by the **bpf**\ () system call is determined
+ * by the *cmd* argument. Each operation takes an accompanying argument,
+ * provided via *attr*, which is a pointer to a union of type *bpf_attr* (see
+ * below). The size argument is the size of the union pointed to by *attr*.
+ *
+ * Start of BPF syscall commands:
+ *
+ * BPF_MAP_CREATE
+ *	Description
+ *		Create a map and return a file descriptor that refers to the
+ *		map. The close-on-exec file descriptor flag (see **fcntl**\ (2))
+ *		is automatically enabled for the new file descriptor.
+ *
+ *		Applying **close**\ (2) to the file descriptor returned by
+ *		**BPF_MAP_CREATE** will delete the map (but see NOTES).
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_MAP_LOOKUP_ELEM
+ *	Description
+ *		Look up an element with a given *key* in the map referred to
+ *		by the file descriptor *map_fd*.
+ *
+ *		The *flags* argument may be specified as one of the
+ *		following:
+ *
+ *		**BPF_F_LOCK**
+ *			Look up the value of a spin-locked map without
+ *			returning the lock. This must be specified if the
+ *			elements contain a spinlock.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_UPDATE_ELEM
+ *	Description
+ *		Create or update an element (key/value pair) in a specified map.
+ *
+ *		The *flags* argument should be specified as one of the
+ *		following:
+ *
+ *		**BPF_ANY**
+ *			Create a new element or update an existing element.
+ *		**BPF_NOEXIST**
+ *			Create a new element only if it did not exist.
+ *		**BPF_EXIST**
+ *			Update an existing element.
+ *		**BPF_F_LOCK**
+ *			Update a spin_lock-ed map element.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ *		May set *errno* to **EINVAL**, **EPERM**, **ENOMEM**,
+ *		**E2BIG**, **EEXIST**, or **ENOENT**.
+ *
+ *		**E2BIG**
+ *			The number of elements in the map reached the
+ *			*max_entries* limit specified at map creation time.
+ *		**EEXIST**
+ *			If *flags* specifies **BPF_NOEXIST** and the element
+ *			with *key* already exists in the map.
+ *		**ENOENT**
+ *			If *flags* specifies **BPF_EXIST** and the element with
+ *			*key* does not exist in the map.
+ *
+ * BPF_MAP_DELETE_ELEM
+ *	Description
+ *		Look up and delete an element by key in a specified map.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_GET_NEXT_KEY
+ *	Description
+ *		Look up an element by key in a specified map and return the key
+ *		of the next element. Can be used to iterate over all elements
+ *		in the map.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ *		The following cases can be used to iterate over all elements of
+ *		the map:
+ *
+ *		* If *key* is not found, the operation returns zero and sets
+ *		  the *next_key* pointer to the key of the first element.
+ *		* If *key* is found, the operation returns zero and sets the
+ *		  *next_key* pointer to the key of the next element.
+ *		* If *key* is the last element, returns -1 and *errno* is set
+ *		  to **ENOENT**.
+ *
+ *		May set *errno* to **ENOMEM**, **EFAULT**, **EPERM**, or
+ *		**EINVAL** on error.
+ *
+ * BPF_PROG_LOAD
+ *	Description
+ *		Verify and load an eBPF program, returning a new file
+ *		descriptor associated with the program.
+ *
+ *		Applying **close**\ (2) to the file descriptor returned by
+ *		**BPF_PROG_LOAD** will unload the eBPF program (but see NOTES).
+ *
+ *		The close-on-exec file descriptor flag (see **fcntl**\ (2)) is
+ *		automatically enabled for the new file descriptor.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_OBJ_PIN
+ *	Description
+ *		Pin an eBPF program or map referred by the specified *bpf_fd*
+ *		to the provided *pathname* on the filesystem.
+ *
+ *		The *pathname* argument must not contain a dot (".").
+ *
+ *		On success, *pathname* retains a reference to the eBPF object,
+ *		preventing deallocation of the object when the original
+ *		*bpf_fd* is closed. This allow the eBPF object to live beyond
+ *		**close**\ (\ *bpf_fd*\ ), and hence the lifetime of the parent
+ *		process.
+ *
+ *		Applying **unlink**\ (2) or similar calls to the *pathname*
+ *		unpins the object from the filesystem, removing the reference.
+ *		If no other file descriptors or filesystem nodes refer to the
+ *		same object, it will be deallocated (see NOTES).
+ *
+ *		The filesystem type for the parent directory of *pathname* must
+ *		be **BPF_FS_MAGIC**.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_OBJ_GET
+ *	Description
+ *		Open a file descriptor for the eBPF object pinned to the
+ *		specified *pathname*.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_PROG_ATTACH
+ *	Description
+ *		Attach an eBPF program to a *target_fd* at the specified
+ *		*attach_type* hook.
+ *
+ *		The *attach_type* specifies the eBPF attachment point to
+ *		attach the program to, and must be one of *bpf_attach_type*
+ *		(see below).
+ *
+ *		The *attach_bpf_fd* must be a valid file descriptor for a
+ *		loaded eBPF program of a cgroup, flow dissector, LIRC, sockmap
+ *		or sock_ops type corresponding to the specified *attach_type*.
+ *
+ *		The *target_fd* must be a valid file descriptor for a kernel
+ *		object which depends on the attach type of *attach_bpf_fd*:
+ *
+ *		**BPF_PROG_TYPE_CGROUP_DEVICE**,
+ *		**BPF_PROG_TYPE_CGROUP_SKB**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCK**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCK_ADDR**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCKOPT**,
+ *		**BPF_PROG_TYPE_CGROUP_SYSCTL**,
+ *		**BPF_PROG_TYPE_SOCK_OPS**
+ *
+ *			Control Group v2 hierarchy with the eBPF controller
+ *			enabled. Requires the kernel to be compiled with
+ *			**CONFIG_CGROUP_BPF**.
+ *
+ *		**BPF_PROG_TYPE_FLOW_DISSECTOR**
+ *
+ *			Network namespace (eg /proc/self/ns/net).
+ *
+ *		**BPF_PROG_TYPE_LIRC_MODE2**
+ *
+ *			LIRC device path (eg /dev/lircN). Requires the kernel
+ *			to be compiled with **CONFIG_BPF_LIRC_MODE2**.
+ *
+ *		**BPF_PROG_TYPE_SK_SKB**,
+ *		**BPF_PROG_TYPE_SK_MSG**
+ *
+ *			eBPF map of socket type (eg **BPF_MAP_TYPE_SOCKHASH**).
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_PROG_DETACH
+ *	Description
+ *		Detach the eBPF program associated with the *target_fd* at the
+ *		hook specified by *attach_type*. The program must have been
+ *		previously attached using **BPF_PROG_ATTACH**.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_PROG_TEST_RUN
+ *	Description
+ *		Run the eBPF program associated with the *prog_fd* a *repeat*
+ *		number of times against a provided program context *ctx_in* and
+ *		data *data_in*, and return the modified program context
+ *		*ctx_out*, *data_out* (for example, packet data), result of the
+ *		execution *retval*, and *duration* of the test run.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ *		**ENOSPC**
+ *			Either *data_size_out* or *ctx_size_out* is too small.
+ *		**ENOTSUPP**
+ *			This command is not supported by the program type of
+ *			the program referred to by *prog_fd*.
+ *
+ * BPF_PROG_GET_NEXT_ID
+ *	Description
+ *		Fetch the next eBPF program currently loaded into the kernel.
+ *
+ *		Looks for the eBPF program with an id greater than *start_id*
+ *		and updates *next_id* on success. If no other eBPF programs
+ *		remain with ids higher than *start_id*, returns -1 and sets
+ *		*errno* to **ENOENT**.
+ *
+ *	Return
+ *		Returns zero on success. On error, or when no id remains, -1
+ *		is returned and *errno* is set appropriately.
+ *
+ * BPF_MAP_GET_NEXT_ID
+ *	Description
+ *		Fetch the next eBPF map currently loaded into the kernel.
+ *
+ *		Looks for the eBPF map with an id greater than *start_id*
+ *		and updates *next_id* on success. If no other eBPF maps
+ *		remain with ids higher than *start_id*, returns -1 and sets
+ *		*errno* to **ENOENT**.
+ *
+ *	Return
+ *		Returns zero on success. On error, or when no id remains, -1
+ *		is returned and *errno* is set appropriately.
+ *
+ * BPF_PROG_GET_FD_BY_ID
+ *	Description
+ *		Open a file descriptor for the eBPF program corresponding to
+ *		*prog_id*.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_MAP_GET_FD_BY_ID
+ *	Description
+ *		Open a file descriptor for the eBPF map corresponding to
+ *		*map_id*.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_OBJ_GET_INFO_BY_FD
+ *	Description
+ *		Obtain information about the eBPF object corresponding to
+ *		*bpf_fd*.
+ *
+ *		Populates up to *info_len* bytes of *info*, which will be in
+ *		one of the following formats depending on the eBPF object type
+ *		of *bpf_fd*:
+ *
+ *		* **struct bpf_prog_info**
+ *		* **struct bpf_map_info**
+ *		* **struct bpf_btf_info**
+ *		* **struct bpf_link_info**
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_PROG_QUERY
+ *	Description
+ *		Obtain information about eBPF programs associated with the
+ *		specified *attach_type* hook.
+ *
+ *		The *target_fd* must be a valid file descriptor for a kernel
+ *		object which depends on the attach type of *attach_bpf_fd*:
+ *
+ *		**BPF_PROG_TYPE_CGROUP_DEVICE**,
+ *		**BPF_PROG_TYPE_CGROUP_SKB**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCK**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCK_ADDR**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCKOPT**,
+ *		**BPF_PROG_TYPE_CGROUP_SYSCTL**,
+ *		**BPF_PROG_TYPE_SOCK_OPS**
+ *
+ *			Control Group v2 hierarchy with the eBPF controller
+ *			enabled. Requires the kernel to be compiled with
+ *			**CONFIG_CGROUP_BPF**.
+ *
+ *		**BPF_PROG_TYPE_FLOW_DISSECTOR**
+ *
+ *			Network namespace (eg /proc/self/ns/net).
+ *
+ *		**BPF_PROG_TYPE_LIRC_MODE2**
+ *
+ *			LIRC device path (eg /dev/lircN). Requires the kernel
+ *			to be compiled with **CONFIG_BPF_LIRC_MODE2**.
+ *
+ *		**BPF_PROG_QUERY** always fetches the number of programs
+ *		attached and the *attach_flags* which were used to attach those
+ *		programs. Additionally, if *prog_ids* is nonzero and the number
+ *		of attached programs is less than *prog_cnt*, populates
+ *		*prog_ids* with the eBPF program ids of the programs attached
+ *		at *target_fd*.
+ *
+ *		The following flags may alter the result:
+ *
+ *		**BPF_F_QUERY_EFFECTIVE**
+ *			Only return information regarding programs which are
+ *			currently effective at the specified *target_fd*.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_RAW_TRACEPOINT_OPEN
+ *	Description
+ *		Attach an eBPF program to a tracepoint *name* to access kernel
+ *		internal arguments of the tracepoint in their raw form.
+ *
+ *		The *prog_fd* must be a valid file descriptor associated with
+ *		a loaded eBPF program of type **BPF_PROG_TYPE_RAW_TRACEPOINT**.
+ *
+ *		No ABI guarantees are made about the content of tracepoint
+ *		arguments exposed to the corresponding eBPF program.
+ *
+ *		Applying **close**\ (2) to the file descriptor returned by
+ *		**BPF_RAW_TRACEPOINT_OPEN** will delete the map (but see NOTES).
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_BTF_LOAD
+ *	Description
+ *		Verify and load BPF Type Format (BTF) metadata into the kernel,
+ *		returning a new file descriptor associated with the metadata.
+ *		BTF is described in more detail at
+ *		https://www.kernel.org/doc/html/latest/bpf/btf.html.
+ *
+ *		The *btf* parameter must point to valid memory providing
+ *		*btf_size* bytes of BTF binary metadata.
+ *
+ *		The returned file descriptor can be passed to other **bpf**\ ()
+ *		subcommands such as **BPF_PROG_LOAD** or **BPF_MAP_CREATE** to
+ *		associate the BTF with those objects.
+ *
+ *		Similar to **BPF_PROG_LOAD**, **BPF_BTF_LOAD** has optional
+ *		parameters to specify a *btf_log_buf*, *btf_log_size* and
+ *		*btf_log_level* which allow the kernel to return freeform log
+ *		output regarding the BTF verification process.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_BTF_GET_FD_BY_ID
+ *	Description
+ *		Open a file descriptor for the BPF Type Format (BTF)
+ *		corresponding to *btf_id*.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_TASK_FD_QUERY
+ *	Description
+ *		Obtain information about eBPF programs associated with the
+ *		target process identified by *pid* and *fd*.
+ *
+ *		If the *pid* and *fd* are associated with a tracepoint, kprobe
+ *		or uprobe perf event, then the *prog_id* and *fd_type* will
+ *		be populated with the eBPF program id and file descriptor type
+ *		of type **bpf_task_fd_type**. If associated with a kprobe or
+ *		uprobe, the  *probe_offset* and *probe_addr* will also be
+ *		populated. Optionally, if *buf* is provided, then up to
+ *		*buf_len* bytes of *buf* will be populated with the name of
+ *		the tracepoint, kprobe or uprobe.
+ *
+ *		The resulting *prog_id* may be introspected in deeper detail
+ *		using **BPF_PROG_GET_FD_BY_ID** and **BPF_OBJ_GET_INFO_BY_FD**.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_LOOKUP_AND_DELETE_ELEM
+ *	Description
+ *		Look up an element with the given *key* in the map referred to
+ *		by the file descriptor *fd*, and if found, delete the element.
+ *
+ *		The **BPF_MAP_TYPE_QUEUE** and **BPF_MAP_TYPE_STACK** map types
+ *		implement this command as a "pop" operation, deleting the top
+ *		element rather than one corresponding to *key*.
+ *		The *key* and *key_len* parameters should be zeroed when
+ *		issuing this operation for these map types.
+ *
+ *		This command is only valid for the following map types:
+ *		* **BPF_MAP_TYPE_QUEUE**
+ *		* **BPF_MAP_TYPE_STACK**
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_FREEZE
+ *	Description
+ *		Freeze the permissions of the specified map.
+ *
+ *		Write permissions may be frozen by passing zero *flags*.
+ *		Upon success, no future syscall invocations may alter the
+ *		map state of *map_fd*. Write operations from eBPF programs
+ *		are still possible for a frozen map.
+ *
+ *		Not supported for maps of type **BPF_MAP_TYPE_STRUCT_OPS**.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_BTF_GET_NEXT_ID
+ *	Description
+ *		Fetch the next BPF Type Format (BTF) object currently loaded
+ *		into the kernel.
+ *
+ *		Looks for the BTF object with an id greater than *start_id*
+ *		and updates *next_id* on success. If no other BTF objects
+ *		remain with ids higher than *start_id*, returns -1 and sets
+ *		*errno* to **ENOENT**.
+ *
+ *	Return
+ *		Returns zero on success. On error, or when no id remains, -1
+ *		is returned and *errno* is set appropriately.
+ *
+ * BPF_MAP_LOOKUP_BATCH
+ *	Description
+ *		Iterate and fetch multiple elements in a map.
+ *
+ *		Two opaque values are used to manage batch operations,
+ *		*in_batch* and *out_batch*. Initially, *in_batch* must be set
+ *		to NULL to begin the batched operation. After each subsequent
+ *		**BPF_MAP_LOOKUP_BATCH**, the caller should pass the resultant
+ *		*out_batch* as the *in_batch* for the next operation to
+ *		continue iteration from the current point.
+ *
+ *		The *keys* and *values* are output parameters which must point
+ *		to memory large enough to hold *count* items based on the key
+ *		and value size of the map *map_fd*. The *keys* buffer must be
+ *		of *key_size* * *count*. The *values* buffer must be of
+ *		*value_size* * *count*.
+ *
+ *		The *elem_flags* argument may be specified as one of the
+ *		following:
+ *
+ *		**BPF_F_LOCK**
+ *			Look up the value of a spin-locked map without
+ *			returning the lock. This must be specified if the
+ *			elements contain a spinlock.
+ *
+ *		On success, *count* elements from the map are copied into the
+ *		user buffer, with the keys copied into *keys* and the values
+ *		copied into the corresponding indices in *values*.
+ *
+ *		If an error is returned and *errno* is not **EFAULT**, *count*
+ *		is set to the number of successfully processed elements.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ *		May set *errno* to **ENOSPC** to indicate that *keys* or
+ *		*values* is too small to dump an entire bucket during
+ *		iteration of a hash-based map type.
+ *
+ * BPF_MAP_LOOKUP_AND_DELETE_BATCH
+ *	Description
+ *		Iterate and delete all elements in a map.
+ *
+ *		This operation has the same behavior as
+ *		**BPF_MAP_LOOKUP_BATCH** with two exceptions:
+ *
+ *		* Every element that is successfully returned is also deleted
+ *		  from the map. This is at least *count* elements. Note that
+ *		  *count* is both an input and an output parameter.
+ *		* Upon returning with *errno* set to **EFAULT**, up to
+ *		  *count* elements may be deleted without returning the keys
+ *		  and values of the deleted elements.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_UPDATE_BATCH
+ *	Description
+ *		Update multiple elements in a map by *key*.
+ *
+ *		The *keys* and *values* are input parameters which must point
+ *		to memory large enough to hold *count* items based on the key
+ *		and value size of the map *map_fd*. The *keys* buffer must be
+ *		of *key_size* * *count*. The *values* buffer must be of
+ *		*value_size* * *count*.
+ *
+ *		Each element specified in *keys* is sequentially updated to the
+ *		value in the corresponding index in *values*. The *in_batch*
+ *		and *out_batch* parameters are ignored and should be zeroed.
+ *
+ *		The *elem_flags* argument should be specified as one of the
+ *		following:
+ *
+ *		**BPF_ANY**
+ *			Create new elements or update a existing elements.
+ *		**BPF_NOEXIST**
+ *			Create new elements only if they do not exist.
+ *		**BPF_EXIST**
+ *			Update existing elements.
+ *		**BPF_F_LOCK**
+ *			Update spin_lock-ed map elements. This must be
+ *			specified if the map value contains a spinlock.
+ *
+ *		On success, *count* elements from the map are updated.
+ *
+ *		If an error is returned and *errno* is not **EFAULT**, *count*
+ *		is set to the number of successfully processed elements.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ *		May set *errno* to **EINVAL**, **EPERM**, **ENOMEM**, or
+ *		**E2BIG**. **E2BIG** indicates that the number of elements in
+ *		the map reached the *max_entries* limit specified at map
+ *		creation time.
+ *
+ *		May set *errno* to one of the following error codes under
+ *		specific circumstances:
+ *
+ *		**EEXIST**
+ *			If *flags* specifies **BPF_NOEXIST** and the element
+ *			with *key* already exists in the map.
+ *		**ENOENT**
+ *			If *flags* specifies **BPF_EXIST** and the element with
+ *			*key* does not exist in the map.
+ *
+ * BPF_MAP_DELETE_BATCH
+ *	Description
+ *		Delete multiple elements in a map by *key*.
+ *
+ *		The *keys* parameter is an input parameter which must point
+ *		to memory large enough to hold *count* items based on the key
+ *		size of the map *map_fd*, that is, *key_size* * *count*.
+ *
+ *		Each element specified in *keys* is sequentially deleted. The
+ *		*in_batch*, *out_batch*, and *values* parameters are ignored
+ *		and should be zeroed.
+ *
+ *		The *elem_flags* argument may be specified as one of the
+ *		following:
+ *
+ *		**BPF_F_LOCK**
+ *			Look up the value of a spin-locked map without
+ *			returning the lock. This must be specified if the
+ *			elements contain a spinlock.
+ *
+ *		On success, *count* elements from the map are updated.
+ *
+ *		If an error is returned and *errno* is not **EFAULT**, *count*
+ *		is set to the number of successfully processed elements. If
+ *		*errno* is **EFAULT**, up to *count* elements may be been
+ *		deleted.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_LINK_CREATE
+ *	Description
+ *		Attach an eBPF program to a *target_fd* at the specified
+ *		*attach_type* hook and return a file descriptor handle for
+ *		managing the link.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_LINK_UPDATE
+ *	Description
+ *		Update the eBPF program in the specified *link_fd* to
+ *		*new_prog_fd*.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_LINK_GET_FD_BY_ID
+ *	Description
+ *		Open a file descriptor for the eBPF Link corresponding to
+ *		*link_id*.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_LINK_GET_NEXT_ID
+ *	Description
+ *		Fetch the next eBPF link currently loaded into the kernel.
+ *
+ *		Looks for the eBPF link with an id greater than *start_id*
+ *		and updates *next_id* on success. If no other eBPF links
+ *		remain with ids higher than *start_id*, returns -1 and sets
+ *		*errno* to **ENOENT**.
+ *
+ *	Return
+ *		Returns zero on success. On error, or when no id remains, -1
+ *		is returned and *errno* is set appropriately.
+ *
+ * BPF_ENABLE_STATS
+ *	Description
+ *		Enable eBPF runtime statistics gathering.
+ *
+ *		Runtime statistics gathering for the eBPF runtime is disabled
+ *		by default to minimize the corresponding performance overhead.
+ *		This command enables statistics globally.
+ *
+ *		Multiple programs may independently enable statistics.
+ *		After gathering the desired statistics, eBPF runtime statistics
+ *		may be disabled again by calling **close**\ (2) for the file
+ *		descriptor returned by this function. Statistics will only be
+ *		disabled system-wide when all outstanding file descriptors
+ *		returned by prior calls for this subcommand are closed.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_ITER_CREATE
+ *	Description
+ *		Create an iterator on top of the specified *link_fd* (as
+ *		previously created using **BPF_LINK_CREATE**) and return a
+ *		file descriptor that can be used to trigger the iteration.
+ *
+ *		If the resulting file descriptor is pinned to the filesystem
+ *		using  **BPF_OBJ_PIN**, then subsequent **read**\ (2) syscalls
+ *		for that path will trigger the iterator to read kernel state
+ *		using the eBPF program attached to *link_fd*.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_LINK_DETACH
+ *	Description
+ *		Forcefully detach the specified *link_fd* from its
+ *		corresponding attachment point.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_PROG_BIND_MAP
+ *	Description
+ *		Bind a map to the lifetime of an eBPF program.
+ *
+ *		The map identified by *map_fd* is bound to the program
+ *		identified by *prog_fd* and only released when *prog_fd* is
+ *		released. This may be used in cases where metadata should be
+ *		associated with a program which otherwise does not contain any
+ *		references to the map (for example, embedded in the eBPF
+ *		program instructions).
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * NOTES
+ *	eBPF objects (maps and programs) can be shared between processes.
+ *	* After **fork**\ (2), the child inherits file descriptors
+ *	  referring to the same eBPF objects.
+ *	* File descriptors referring to eBPF objects can be transferred over
+ *	  **unix**\ (7) domain sockets.
+ *	* File descriptors referring to eBPF objects can be duplicated in the
+ *	  usual way, using **dup**\ (2) and similar calls.
+ *	* File descriptors referring to eBPF objects can be pinned to the
+ *	  filesystem using the **BPF_OBJ_PIN** command of **bpf**\ (2).
+ *	An eBPF object is deallocated only after all file descriptors referring
+ *	to the object have been closed and no references remain pinned to the
+ *	filesystem or attached (for example, bound to a program or device).
+ */
 enum bpf_cmd {
 	BPF_MAP_CREATE,
 	BPF_MAP_LOOKUP_ELEM,
-- 
2.27.0

