Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B951336B3A
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 05:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhCKEok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 23:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCKEoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 23:44:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11FCC061574;
        Wed, 10 Mar 2021 20:44:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so8454251pjc.2;
        Wed, 10 Mar 2021 20:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=PBkku/s8mSRHKOyuiBeMgbH6xJfrQRrxhjnYIQVUXQs=;
        b=SAQrWzzVIZjUX8ihYY/mELiJMaFs5+/w1hA1Xg6sWnLxVwVl5APgLAJnpFVTkwnaUZ
         a5Bj68/Edc1sDe8rskRtYrA7oMlUJusDwVfTEKKrYtPb+xZC4d9pJioPJWMuZDVRqSrE
         itoWIVYntz+9g8099eS3SBT+QXq8U2HXotamRX/PAwgVxUV1k9XG/sUQOtSug84mTK/l
         GzpS/2qo/Ye8N3t2lml6cWOFZL1kWOoFjjfZyYdkTna9ZjxX7BjBuQDN2SOPnVLEIhBS
         ka3nQtsUo3mCR58HBaPx/Y/1m+NZT7V28Gor9Bx3wBYxODgfuVg2BIVaf7N3beSHr3o1
         bMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=PBkku/s8mSRHKOyuiBeMgbH6xJfrQRrxhjnYIQVUXQs=;
        b=WmHpPlGpmEdUUBp7Z57rHa2ZakwlochYkN5ynMhGPwO+lFlRNH21X4DlomOLJfIbwE
         CZ4i6QakUZhy0TbocfsNWmVI+gTY6i/rqpRuBGdnNKhhOjWaQhoo05JRhxg0U/3ByBtF
         yl7WH+jPHx5CUN7SXoKvAXQk4IyIDKX/bvcPeiszDU6DWsD5/MhpfHuxczDAnoW6r1FR
         Pr1+XZBf56QG2vtSwDOgU4hl4IOmNXC68OcGZOhTd5kdP5zLfd2nOVqpMznkJyPrSpcm
         JgyU5qww7Ja8yLGEortIRhUiGTRTl115AL9eZ9B0emGB80eyT9hZc60liA/vawe3LTFU
         2/gg==
X-Gm-Message-State: AOAM532On3LvTymYc+8YanTB9cz8JuTssFfGSpe/WqPDSO+YnvFR8RNs
        bO+zdafT2Ek7guDt2XHJ+o8=
X-Google-Smtp-Source: ABdhPJzzzRgStXu2L42e7HgxDNVOCLfDuaoKyvKox8SmFfUzZDnTB42v/eChvfZOD3eaCCoWhUFe7w==
X-Received: by 2002:a17:90a:7f87:: with SMTP id m7mr6889022pjl.64.1615437858315;
        Wed, 10 Mar 2021 20:44:18 -0800 (PST)
Received: from localhost ([122.179.55.249])
        by smtp.gmail.com with ESMTPSA id 3sm822311pjk.26.2021.03.10.20.44.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 20:44:17 -0800 (PST)
Date:   Thu, 11 Mar 2021 10:14:08 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, bkkarthik@pesu.pes.edu
Subject: [PATCH] net: socket.c: Fix comparison issues
Message-ID: <20210311044408.t6qut7taaagt4a63@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The constant has been placed to the right side of the test.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 84a8049c2b09..a23dd4348793 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1495,7 +1495,7 @@ int __sys_socket(int family, int type, int protocol)
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
-	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+	if ((flags & SOCK_NONBLOCK) && SOCK_NONBLOCK != O_NONBLOCK)
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
 	retval = sock_create(family, type, protocol, &sock);
@@ -1526,7 +1526,7 @@ int __sys_socketpair(int family, int type, int protocol, int __user *usockvec)
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
-	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+	if ((flags & SOCK_NONBLOCK) && SOCK_NONBLOCK != O_NONBLOCK)
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
 	/*
@@ -1693,7 +1693,7 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 
-	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+	if ((flags & SOCK_NONBLOCK) && SOCK_NONBLOCK != O_NONBLOCK)
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
 	sock = sock_from_file(file);
-- 
2.17.1

