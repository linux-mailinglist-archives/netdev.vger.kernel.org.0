Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855796A14EA
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 03:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBXC3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 21:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBXC3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 21:29:23 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A260A1554F
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 18:29:21 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id z6so1570657qtv.0
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 18:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=enaTQCm/lX2y+BlizaBS9gVaM0OUH5yxhTzHn8mIf1Y=;
        b=qUs9/rKeBAG3nj8ZnIc2QNek60TN9Jdm4DHj/eX+J5k7pgVFONl1OatUXqbb2Jw2Qz
         TMsaYjy/G3XJJXBVkKFJ1aSxlPJiUYXt3P2SVAfbvOLZlT/iImRIdgp+8ewLzkRdEqIa
         QL76Srmc82loXrTxaIOqhuemlGnGyDu2B8u58dt/6yIvcaE8jEq/XNerNFG9i7XH5EJ8
         EgMZc1n4hxRtDWuM6zFrGuQ7llVIocy089CLso2vSXKBg22BC2iUennpdaDPsw6n69A4
         GjayR1ubsEECozU7fyyWZR8j2vjfzlR4lbHKcF72+S/boTVrVR9zVZe/eHFuejC2Q1k7
         zKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=enaTQCm/lX2y+BlizaBS9gVaM0OUH5yxhTzHn8mIf1Y=;
        b=J1RZP96IzFcqliabX5V7xdzRxcN7AwAxhDnISsVida9f6oi9471G8BuimWNI89XYOn
         HmFCkLooJTSohSHXhobXMXJLqM1SB5jd95eL96elewkuHbzf7xvvxvt9MCO+PEC7MbY9
         DsTIDhg6CTQ4gYlabjjqbG/A8D+THAASvphFr732PhF4Vn5pPd3qmGvbtSjDCEgN13yx
         CJyfZFEx6V01cmJ8jEt+C3LC3cbuzXQP/+wzHksS+p9/Yely8knC2actrnZga232kC2a
         DVMcFlUGgt4GESraVNmjeMnwVu9tKuTaWJjNVlDDlS1yindIh31Jdq6Icoql/u/uVu9S
         3MTw==
X-Gm-Message-State: AO0yUKXkdJpsbexM2Ioaj6STiujkVVnr2Whj0MEtp4YVN8loyFfzAs77
        2nRieX2A+1080qD4rq7imDs=
X-Google-Smtp-Source: AK7set9EjaJ6fdhQEiadKxZ7//cqwL14JMUXhRkyMEbkK0W5XvvfCOR1YkcRhUHSfC6UvDWXepYgrw==
X-Received: by 2002:a05:622a:1009:b0:3b9:bc8c:c1ff with SMTP id d9-20020a05622a100900b003b9bc8cc1ffmr24203560qte.10.1677205760664;
        Thu, 23 Feb 2023 18:29:20 -0800 (PST)
Received: from vps.qemfd.net (vps.qemfd.net. [173.230.130.29])
        by smtp.gmail.com with ESMTPSA id ff23-20020a05622a4d9700b003b64f1b1f40sm5787075qtb.40.2023.02.23.18.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 18:29:18 -0800 (PST)
Received: from schwarzgerat.orthanc (schwarzgerat.danknet [192.168.128.2])
        by vps.qemfd.net (Postfix) with ESMTP id E94232BAE6;
        Thu, 23 Feb 2023 21:29:16 -0500 (EST)
Received: by schwarzgerat.orthanc (Postfix, from userid 1000)
        id C1A6F600143; Thu, 23 Feb 2023 21:29:16 -0500 (EST)
Date:   Thu, 23 Feb 2023 21:29:16 -0500
From:   nick black <dankamongmen@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH] [net] fix inaccuracies in msg_zerocopy.rst
Message-ID: <Y/gg/EhIIjugLdd3@schwarzgerat.orthanc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace "sendpage" with "sendfile". Remove comment about
ENOBUFS when the sockopt hasn't been set; experimentation
indicates that this is not true.

Signed-off-by: nick black <dankamongmen@gmail.com>
---
 Documentation/networking/msg_zerocopy.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git Documentation/networking/msg_zerocopy.rst Documentation/networking/msg_zerocopy.rst
index 15920db8d35d..b3ea96af9b49 100644
--- Documentation/networking/msg_zerocopy.rst
+++ Documentation/networking/msg_zerocopy.rst
@@ -15,7 +15,7 @@ Opportunity and Caveats
 
 Copying large buffers between user process and kernel can be
 expensive. Linux supports various interfaces that eschew copying,
-such as sendpage and splice. The MSG_ZEROCOPY flag extends the
+such as sendfile and splice. The MSG_ZEROCOPY flag extends the
 underlying copy avoidance mechanism to common socket send calls.
 
 Copy avoidance is not a free lunch. As implemented, with page pinning,
@@ -83,8 +83,8 @@ Pass the new flag.
 	ret = send(fd, buf, sizeof(buf), MSG_ZEROCOPY);
 
 A zerocopy failure will return -1 with errno ENOBUFS. This happens if
-the socket option was not set, the socket exceeds its optmem limit or
-the user exceeds its ulimit on locked pages.
+the socket exceeds its optmem limit or the user exceeds their ulimit on
+locked pages.
 
 
 Mixing copy avoidance and copying
-- 
2.39.1
