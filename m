Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7879931D395
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhBQBJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhBQBJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:13 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFAEC061788;
        Tue, 16 Feb 2021 17:08:33 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id k22so6498540pll.6;
        Tue, 16 Feb 2021 17:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ZnA+7hfNqEFiLN330o/irmutXYLyaXm0jUQCg3QDWo=;
        b=LAO6dwoQ/da5DeUo368VDM5qD60mXd17TrohA9Pky89S2JYHrHmWwY2GNBPESVy/2o
         N3MD76TSVDf+rbLL+lcrBrnge8SBaEQytHDzNKP2GdofWKxEcuXrM2sRoVHIFUlZgTrp
         pynzLd7VspTCPqxh8R9FNx/tKqitDYUOuo0sYl6EYcWbyxWyfXemMlRvVvm7kVHxDD9z
         fwUrSo9mHuqsNrCV/FkzKmOf06Dz93wym/Tdc7r1eXWnGWXy1pvW6YWn+Pr8MWBAKPBm
         3fZ97agyjYHJk6h6jfS9ADBHgIL8PcPa86TrTFLqWsWL5TXAFQnSXh0bExVIIHukkOKW
         ubhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3ZnA+7hfNqEFiLN330o/irmutXYLyaXm0jUQCg3QDWo=;
        b=XDC8cyyD0KjDMuCnfK8tvlqanr8snaF3nHqP0L1ZvdyffQoczAGRcsl7LzwnJqr3Nx
         1Ru4PlTdqTZze4AQs4iDzq46KICjPeiLyajhbIsrlT7T1Ca7kdTC9gyoj36W7AWoMMq4
         1wQEAcT3GaVf3rTX+p+yCuGer1ATpm6ls9AmY0bLgFvOSF/I9evVb2K77Qx0FMgPIBgN
         GhrtnBD8oAoyS75JdavsMvDEOlb3UP/jye/rHzFTgwpyboAYXa6URUO+o5+4yz5pOvCz
         CvIFJwhUul+2ZNkG9c/eKEJr13mHNRauYFqH7Ahb+FjIRZjmAp2z0r2RxhrApAC9gG18
         gaPA==
X-Gm-Message-State: AOAM5330j+p2utVxRHnRWpJbSMoKjuUt2nH54CnJyCaxpL1LEZbLBYyh
        yOOBAl4S/ukSFEljqBhwXfTxKi6R5ee0HQ==
X-Google-Smtp-Source: ABdhPJxtdHrKu1j9wclbUBGHvtcyRKfQEUqYvNMw25jotYrSxucVhnQiXDAaDN1C2TJ5I1PMWmiS4Q==
X-Received: by 2002:a17:902:e80b:b029:e3:3df1:5e93 with SMTP id u11-20020a170902e80bb02900e33df15e93mr209266plg.80.1613524112320;
        Tue, 16 Feb 2021 17:08:32 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:31 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 03/17] bpf: Document BPF_F_LOCK in syscall commands
Date:   Tue, 16 Feb 2021 17:08:07 -0800
Message-Id: <20210217010821.1810741-4-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Document the meaning of the BPF_F_LOCK flag for the map lookup/update
descriptions. Based on commit 96049f3afd50 ("bpf: introduce BPF_F_LOCK
flag").

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
CC: Alexei Starovoitov <ast@kernel.org>
---
 include/uapi/linux/bpf.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ac6880d7b01b..d02259458fd6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -120,6 +120,14 @@ union bpf_iter_link_info {
  *		Look up an element with a given *key* in the map referred to
  *		by the file descriptor *map_fd*.
  *
+ *		The *flags* argument may be specified as one of the
+ *		following:
+ *
+ *		**BPF_F_LOCK**
+ *			Look up the value of a spin-locked map without
+ *			returning the lock. This must be specified if the
+ *			elements contain a spinlock.
+ *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
@@ -137,6 +145,8 @@ union bpf_iter_link_info {
  *			Create a new element only if it did not exist.
  *		**BPF_EXIST**
  *			Update an existing element.
+ *		**BPF_F_LOCK**
+ *			Update a spin_lock-ed map element.
  *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
-- 
2.27.0

