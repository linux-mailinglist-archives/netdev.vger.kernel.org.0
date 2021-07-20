Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114843D013D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGTR0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbhGTRYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 13:24:17 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84221C0613DB
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 11:04:44 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id q15so7278174qkm.8
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 11:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tTspJFBreioQm4l0ODj9BEx6x6J2wjJ5rEOrdp1b4Ww=;
        b=GbgxzMem92Q0A2o5+zBC76s8X7qrpvN8Ht3Abkd7aq8/u+q6WJInvVhuTxoz1B6TwB
         2bxA+lChwH93VdpeIe1di4xjQpnBitLeeBQQqkRkk1RCZMpn+PuhMXK7h1blF8lYUBnZ
         ixz44Hc4YR0+QzFTMhKqWyFw/oFAbdXXO4tYZ/KMmHv7Cf4MH5p7/vTMg11e0t9rEuJS
         y4+5ta5JEEtoCp4SVJSyIiSO4Wb+q1lQmGuofIkWgWDJteS2r/PmS4AzNRcsY/dNga8G
         1lWlg0slb4vGnQd0oO5siVpq/njrN7+2gC0pqtiJtQwyPQqNNsTYzHuo3kfMaCa4k6fo
         O7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tTspJFBreioQm4l0ODj9BEx6x6J2wjJ5rEOrdp1b4Ww=;
        b=ZedLySidFrbRYjoOo4XRmo+u7vb0Nfkw1nf3f1CS7GUyUuVquMRRTPVJfkq6nmUtAC
         QIopr9mrtLzmphoCLGvvufeBjUNf4WrCcNGF9etGOanlNZeq0Al431ULmTJj6lS5dB/K
         G9atfkGzyf7nigk6ih3KLexcEcB/be5dYTtQ+z/bnd0fetdiktSHf5Ut905ocQHlPBwV
         x9qcvmz0eC5B82qINWsLXhx8iWXqy6dsXNfY7L9TvvJMBMaReJDIj+FRzLVJ/S+Waj2i
         iteXB3+yqVPg/Oqr1raxv0BlU0LJwM6+t4bOGrnNveL0bUXJe4389+QMHohjyMVAS6yE
         +AVw==
X-Gm-Message-State: AOAM533Ths5/OaolyYivPubGWRnLubEVGT2BbLZt1dDEO4AjxW73f04F
        UMQte4svl2UIjlhf6DdEur+cLn22Iw==
X-Google-Smtp-Source: ABdhPJy1uVLYw3ItID8Q4Y9i1OFpUuDMRzza/ikHWwRZQlGtKoXVOWgWqr+9+vjcDxTpfhnFhj0Eig==
X-Received: by 2002:a05:620a:14b8:: with SMTP id x24mr11779776qkj.475.1626804283339;
        Tue, 20 Jul 2021 11:04:43 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id k125sm10130159qkf.16.2021.07.20.11.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 11:04:42 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2] man: tc-skbmod.8: Remove misinformation about the swap action
Date:   Tue, 20 Jul 2021 11:04:16 -0700
Message-Id: <20210720180416.19897-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently man 8 tc-skbmod says that "...the swap action will occur after
any smac/dmac substitutions are executed, if they are present."

This is false.  In fact, trying to "set" and "swap" in a single skbmod
command causes the "set" part to be completely ignored.  As an example:

	$ tc filter add dev eth0 parent 1: protocol ip prio 10 \
		matchall action skbmod \
        	set dmac AA:AA:AA:AA:AA:AA smac BB:BB:BB:BB:BB:BB \
        	swap mac

The above command simply does a "swap", without setting DMAC or SMAC to
AA's or BB's.  The root cause of this is in the kernel, see
net/sched/act_skbmod.c:tcf_skbmod_init():

	parm = nla_data(tb[TCA_SKBMOD_PARMS]);
	index = parm->index;
	if (parm->flags & SKBMOD_F_SWAPMAC)
		lflags = SKBMOD_F_SWAPMAC;
		^^^^^^^^^^^^^^^^^^^^^^^^^^

Doing a "=" instead of "|=" clears all other "set" flags when doing a
"swap".  Discourage using "set" and "swap" in the same command by
documenting it as undefined behavior, and update the "SYNOPSIS" section
accordingly.

If one really needs to e.g. "set" DMAC to all AA"s then "swap" DMAC and
SMAC, one should do two separate commands and "pipe" them together.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 man/man8/tc-skbmod.8 | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index eb3c38fa6bf3..76512311b17d 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -5,12 +5,12 @@ skbmod - user-friendly packet editor action
 .SH SYNOPSIS
 .in +8
 .ti -8
-.BR tc " ... " "action skbmod " "{ [ " "set "
-.IR SETTABLE " ] [ "
+.BR tc " ... " "action skbmod " "{ " "set "
+.IR SETTABLE " | "
 .BI swap " SWAPPABLE"
-.RI " ] [ " CONTROL " ] [ "
+.RI " } [ " CONTROL " ] [ "
 .BI index " INDEX "
-] }
+]
 
 .ti -8
 .IR SETTABLE " := "
@@ -25,6 +25,7 @@ skbmod - user-friendly packet editor action
 .IR SWAPPABLE " := "
 .B mac
 .ti -8
+
 .IR CONTROL " := {"
 .BR reclassify " | " pipe " | " drop " | " shot " | " continue " | " pass " }"
 .SH DESCRIPTION
@@ -48,10 +49,7 @@ Change the source mac to the specified address.
 Change the ethertype to the specified value.
 .TP
 .BI mac
-Used to swap mac addresses. The
-.B swap mac
-directive is performed
-after any outstanding D/SMAC changes.
+Used to swap mac addresses.
 .TP
 .I CONTROL
 The following keywords allow to control how the tree of qdisc, classes,
@@ -128,9 +126,13 @@ tc filter add dev eth3 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-As mentioned above, the swap action will occur after any
-.B " smac/dmac "
-substitutions are executed, if they are present.
+However, trying to
+.B set
+and
+.B swap
+in a single
+.B skbmod
+command will cause undefined behavior.
 
 .SH SEE ALSO
 .BR tc (8),
-- 
2.20.1

