Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF78C31D391
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhBQBJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhBQBJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:12 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118C7C061786;
        Tue, 16 Feb 2021 17:08:32 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 75so4051045pgf.13;
        Tue, 16 Feb 2021 17:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5fKzG8JmJ15nM649fVhyJSDnrHFPPSgaEHYMjgBGmTI=;
        b=FvWDuAxZR7NA+CN8uodzBws6VelrdsQyqJ1DofMXvevdtrH7GZSA+6soTdIj9yrYKf
         65Gs9o/sdz/oDnojWu3CcV87Qk23Ek2DEmAnkQP4baNuf/l1BlGTcQpE/yGnguIZuGKr
         7D0x49tmFKduz6hZDAZ4fvxkB6ELvS7OzKh4dlLhqE8/KvRrDqFMatdcFryxjk2Kh5mP
         e34gmjtX7G6fqKRJz4e4OdbIKH+i4JBwC46EoJ0pLGQrVhpOFb9XXvzI+Q2j1qVv1/V1
         LOII5Oy8YW8rUgKdXJPL89QX4ij2AGEMfAvMVFK7sge3Ps2dVmqwd8owNOueMkVkqK0q
         GCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=5fKzG8JmJ15nM649fVhyJSDnrHFPPSgaEHYMjgBGmTI=;
        b=mW0pdW1UPuYkt5Vew6S8rgAHlVktDgd+ohteJFMv5ESaXFcbM7XYiG2yUQGBheDXOa
         P2RmdFco6mHcN+vTWYS62Jy8Khu3Gpa9Q5/j95T6hUsNL5br+fvAy0TkH+08LjRaxpXs
         jE8YyMyUoAFmv8qR7TDiFvmp/FZq4p2w9awY+qRLcAbzMmbMRUGqFgp4AX+8gi+aO8HX
         21jIuQ+Ru8Nbbp3RDvENs3SaXkVQkt64gdDPBlQE8NwdGBaWvZh8qdTRhnU52ID2SJDE
         KBOnGprOdxMIKkntJodz+gca/6Q0MR+zU80s4t+PkJCtzjluJ5Ns4yEjSknZd0CqvL3J
         hWCw==
X-Gm-Message-State: AOAM531KPIT14ILnu+Nef0hh5/kEwAsa8aO/YzzKF7NLMQYrpg0FObSu
        RMl2PC2sA1nWuRb0TeZR5BrozMD9dW5pEg==
X-Google-Smtp-Source: ABdhPJw7ClzaNqmsKaSmbumtOCfNPy4mbMLKHNuV8MhWfNJX2iIzHcfcz5xxQqEurOaadBoxN+QKig==
X-Received: by 2002:aa7:9ec5:0:b029:1e7:a1c:8f8a with SMTP id r5-20020aa79ec50000b02901e70a1c8f8amr22740274pfq.41.1613524110859;
        Tue, 16 Feb 2021 17:08:30 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:30 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 02/17] bpf: Add minimal bpf() command documentation
Date:   Tue, 16 Feb 2021 17:08:06 -0800
Message-Id: <20210217010821.1810741-3-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Introduce high-level descriptions of the intent and return codes of the
bpf() syscall commands. Subsequent patches may further flesh out the
content to provide a more useful programming reference.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 include/uapi/linux/bpf.h | 368 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 368 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 56d7db0f3daf..ac6880d7b01b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -201,6 +201,374 @@ union bpf_iter_link_info {
  *		A new file descriptor (a nonnegative integer), or -1 if an
  *		error occurred (in which case, *errno* is set appropriately).
  *
+ * BPF_OBJ_PIN
+ *	Description
+ *		Pin an eBPF program or map referred by the specified *bpf_fd*
+ *		to the provided *pathname* on the filesystem.
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
+ *		Run an eBPF program a number of times against a provided
+ *		program context and return the modified program context and
+ *		duration of the test run.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
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
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_LOOKUP_AND_DELETE_BATCH
+ *	Description
+ *		Iterate and delete multiple elements in a map.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_UPDATE_BATCH
+ *	Description
+ *		Iterate and update multiple elements in a map.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_DELETE_BATCH
+ *	Description
+ *		Iterate and delete multiple elements in a map.
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
  * NOTES
  *	eBPF objects (maps and programs) can be shared between processes.
  *	For example, after **fork**\ (2), the child inherits file descriptors
-- 
2.27.0

