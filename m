Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FC131D3A9
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhBQBL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhBQBJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:48 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A09FC06178C;
        Tue, 16 Feb 2021 17:08:41 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y25so4064976pfp.5;
        Tue, 16 Feb 2021 17:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8woX65qt/qStfvzx9YUb2TtgE8YzDYd/O7zmfhWhqxM=;
        b=hng6jOIfb+MwTjYrFJ1EmYdly9YDMgRt+ebBbmz00ZTM+LBn9sXtvr2Co9Qdgk4o+f
         cFsTZy/5P9XViQrHvG7aevHM6vUIAnvNTh1Rqf4p1/dETWaC60sVd97OoKcichxLq3DC
         FrcNv4q5IosMPI7I18gFi87LVglVeRZQSm5F8XRszYft6k50TGT8bsc8g/Kb+eTdjq77
         IdW8hzeXqmFR0vG+fjAorFPTjFteS0gahYH8X6PCM0CbEwq5DanZzde5oL05OMrBA/1v
         DXnrKlMIZa8CS7c3iw1pdeIzRLBydzJjDWg2OhYOiSE/wHwfk8DCYNmY5mh/gw8mIDfz
         rqqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=8woX65qt/qStfvzx9YUb2TtgE8YzDYd/O7zmfhWhqxM=;
        b=li3QeH5/tkUkwHYnXRItYM6UUGkP31BjEttYt9AWoEePqIfn0+e9rrno+xG6KWMwMD
         KVGNCFN/24W3N5a/h0cCAQLa5chDr+P4ia9R+HRAbY5vJsa/pCElEAmGtkTfSQfPWULO
         SkcMYcrUATV1lo+z82lLKdM0twmUck5Wpf8pzNy7gCpvDyOdxjaFPl09lUB/DgUoXQWx
         ugkIgFua2ulhGWFwr3DQlX1x577ZuJUZpgMb7N8YaEWgelMEKHeY7yzgAk1xeUQ0Em1v
         RU3ptVhHf5tyTQJgZR73Ke8C4Rl6UKz/lePeh7+9l1loltWW5HvUEmGo8wSKvkk3vqdl
         pwiw==
X-Gm-Message-State: AOAM533uUfmCTa80j5RI68QyiG1uv/bfD4J6L4eqMqXLtQ5Xg0BsszXI
        X4r/q0H0gA++i9BoH7/RTmTaLbfWy1oVuw==
X-Google-Smtp-Source: ABdhPJxkiO/5qP/ws/49azU5oHCJl39GjUlKXbqu4BQ8szhhVumUXXWyCsWtiJQU/UqLQl44jVM9GQ==
X-Received: by 2002:a63:1c1d:: with SMTP id c29mr22255658pgc.94.1613524120277;
        Tue, 16 Feb 2021 17:08:40 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:39 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>,
        Brian Vazquez <brianvv@google.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next 08/17] bpf: Document BPF_MAP_*_BATCH syscall commands
Date:   Tue, 16 Feb 2021 17:08:12 -0800
Message-Id: <20210217010821.1810741-9-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Based roughly on the following commits:
* Commit cb4d03ab499d ("bpf: Add generic support for lookup batch op")
* Commit 057996380a42 ("bpf: Add batch ops to all htab bpf map")
* Commit aa2e93b8e58e ("bpf: Add generic support for update and delete
  batch ops")

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
CC: Brian Vazquez <brianvv@google.com>
CC: Yonghong Song <yhs@fb.com>

@Yonghong, would you mind double-checking whether the text is accurate for the
case where BPF_MAP_LOOKUP_AND_DELETE_BATCH returns -EFAULT?
---
 include/uapi/linux/bpf.h | 114 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 111 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a07cecfd2148..893803f69a64 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -550,13 +550,55 @@ union bpf_iter_link_info {
  *	Description
  *		Iterate and fetch multiple elements in a map.
  *
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
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
  *
+ *		May set *errno* to **ENOSPC** to indicate that *keys* or
+ *		*values* is too small to dump an entire bucket during
+ *		iteration of a hash-based map type.
+ *
  * BPF_MAP_LOOKUP_AND_DELETE_BATCH
  *	Description
- *		Iterate and delete multiple elements in a map.
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
  *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
@@ -564,15 +606,81 @@ union bpf_iter_link_info {
  *
  * BPF_MAP_UPDATE_BATCH
  *	Description
- *		Iterate and update multiple elements in a map.
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
  *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
  *
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
  * BPF_MAP_DELETE_BATCH
  *	Description
- *		Iterate and delete multiple elements in a map.
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
  *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
-- 
2.27.0

