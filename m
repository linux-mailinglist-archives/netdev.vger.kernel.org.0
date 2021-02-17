Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE3631D396
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhBQBJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbhBQBJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:16 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09DAC06178A;
        Tue, 16 Feb 2021 17:08:34 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id m6so7363057pfk.1;
        Tue, 16 Feb 2021 17:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KAnAbTTe8mmyGdTip1CGM5L9IEVFc3mWnvSe2CSkws=;
        b=KVi3gtAUMTmsDOl1WRMk7ZiqqtxipOJaAW2Ez2R2O3geu6HCBcT0pyjyFxvburERWG
         AFBfcnsj+AkMfoK15FPUBHV+X0S3gkvCvtdtXxQCd4xxCS1qzhhGs5Cc75QgcsKovpSN
         nplAmXLe567CYPEgRcYG0bP/tycAzuO+HRjTKCCAuFTdJF6ZB+rfAsTLO7ro3kaKyyZ0
         Frcyl3klg0WmHgh4zIlwwCGHIDkhgFPiVYlp2DkTI5IHe9nqBzB3FGv4IB+ToL/9UL3J
         RbTxtRquGbRUlusiT5uVFURmAbqF0DYbhbNPl/slA4DANmohaMQsD8sGWspwCyRYQF0u
         bLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3KAnAbTTe8mmyGdTip1CGM5L9IEVFc3mWnvSe2CSkws=;
        b=UxN6chU6vGhGDIiSp3OdzFnGvMEcCiaBfoDv1wLePUCkeNrgeqkH2mmhbO86JYACeG
         OW/9aDOW8iBPSW4agj7cfj+FZNRkhsTzs3/WnZkB+raQAY36NOZ13X2hpipDiQNdaVWB
         exf2wgRxEiH7egYeGU/wbtPk1C/Lxbjmvb4MNVbEeuHiO0soL8s+X+cfsCmCIHIy+s+k
         iie/PmEcmX5e9vxM6UQWyt5WJBoyysvGS5/o3PBENu+7U1uTXSFdBSbSh30h9gJxZbUX
         TncG6cxJDSO+j+iinWTzO0NcV319jrqTXLVAdhC8Yeofr0NvCeExyZzNd34wjtGQNzBW
         ofRg==
X-Gm-Message-State: AOAM532o8iJegWJghIXB+8gFwhw8QQBr56slPwGW0xq3fTDxJAqyPyOz
        tsUReCplvzOM3qpylYSPo8kdunvZO9w8AA==
X-Google-Smtp-Source: ABdhPJyxeCM/3c/TdtluttSnoPdGFMwn79SU5ygjwDajObQTF6wvEMc3fBBbCZiVA/r8GtmqM4rxsw==
X-Received: by 2002:aa7:80ca:0:b029:1c1:b636:ecc2 with SMTP id a10-20020aa780ca0000b02901c1b636ecc2mr22076437pfn.20.1613524113856;
        Tue, 16 Feb 2021 17:08:33 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:33 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 04/17] bpf: Document BPF_PROG_PIN syscall command
Date:   Tue, 16 Feb 2021 17:08:08 -0800
Message-Id: <20210217010821.1810741-5-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Commit b2197755b263 ("bpf: add support for persistent maps/progs")
contains the original implementation and git logs, used as reference for
this documentation.

Also pull in the filename restriction as documented in commit 6d8cb045cde6
("bpf: comment why dots in filenames under BPF virtual FS are not allowed")

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
CC: Daniel Borkmann <daniel@iogearbox.net>
---
 include/uapi/linux/bpf.h | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d02259458fd6..8301a19c97de 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -216,6 +216,22 @@ union bpf_iter_link_info {
  *		Pin an eBPF program or map referred by the specified *bpf_fd*
  *		to the provided *pathname* on the filesystem.
  *
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
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
@@ -581,13 +597,17 @@ union bpf_iter_link_info {
  *
  * NOTES
  *	eBPF objects (maps and programs) can be shared between processes.
- *	For example, after **fork**\ (2), the child inherits file descriptors
- *	referring to the same eBPF objects. In addition, file descriptors
- *	referring to eBPF objects can be transferred over UNIX domain sockets.
- *	File descriptors referring to eBPF objects can be duplicated in the
- *	usual way, using **dup**\ (2) and similar calls. An eBPF object is
- *	deallocated only after all file descriptors referring to the object
- *	have been closed.
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
  */
 enum bpf_cmd {
 	BPF_MAP_CREATE,
-- 
2.27.0

