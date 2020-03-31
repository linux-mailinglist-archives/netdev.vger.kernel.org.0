Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396A3199BBB
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgCaQgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:36:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41579 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaQgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:36:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id a24so3730785pfc.8;
        Tue, 31 Mar 2020 09:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a2tft5SN6SaD3+uP79omFRtB/u7uc82yKfjYjdFaNX4=;
        b=EyIQTa7Gh9iRVI86F5QKwzhJE9b/9FstuyoY6u5OW7bkBWMuSKUqv+/IGe84V0LIeJ
         pqIZTMEZtfCb8YTDtufdSjspLPrzLtRnE1li3NmEJrMdZbbRMi7cWugIlbXwgyaO+3wd
         QYJ8t7sPp3wYdHfg0mj6ms8jZeJ5gS7/Zh1FOOb712DiXML1DWWiUolCf6DXqdXEHE7+
         LQZ/zVLrAofAFWmetmJtuqCedg+jOOTXL/0n3LBoFEZ2/wt69bnJbEWVByok23NBVjUJ
         Yk/7yI+JCbe9y4AiSjd3+5Mma9avvWEl1w/f3aKvxNYi+iD8Gu9NuQAv/Wex4/5QGkt8
         ycAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a2tft5SN6SaD3+uP79omFRtB/u7uc82yKfjYjdFaNX4=;
        b=XgqiqMAonfDbX3mVnQIrAMO40vaz5kC4nL4IondWmlf2H2pIXpOg3ZuVsI3lS0q+l0
         5SlnkAJJuo50m30zgzZxJosVgxDxxEKgKxLp+HN49+5asPH6VOeIr6YOXKPO+mb/3LSw
         p5zGesCPYqV8RZT98mO28+zv75FlLJpmp3+jF0svjltlt8RarKrj4eU2XBltZIAQTR7W
         2hAIWRPYqqoQs8ncNf5L9VnR51DeQqQeTlzLrzKD/tXeHa553HgGd+YL547UZcx6p9mI
         TGpQGYQvcEn4+7X7QzoE7dIb6XtbNP8YCGRozpQZr+2t23A5NHvLdQxxQceMw3bi0do1
         9h+A==
X-Gm-Message-State: ANhLgQ23wwUlGJe2YSxDi+dekBEwV+lzZ/Pmow6D63zQzUM/y2PywIqP
        snQULZT775szEhN/eX06GG07L0I+Z6M=
X-Google-Smtp-Source: ADFU+vvU4guU7v+FNKDxX7K25ulInvTEptiThJOFl37u+jNhIxinmnJg4+MIwW0o0T4heZQvJv2XMA==
X-Received: by 2002:a63:e809:: with SMTP id s9mr18313818pgh.214.1585672567409;
        Tue, 31 Mar 2020 09:36:07 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id z15sm12927136pfg.152.2020.03.31.09.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 09:36:06 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
Date:   Tue, 31 Mar 2020 09:35:59 -0700
Message-Id: <20200331163559.132240-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Android has long had an extension to IDLETIMER to send netlink
messages to userspace, see:
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/include/uapi/linux/netfilter/xt_IDLETIMER.h#42
Note: this is idletimer target rev 1, there is no rev 0 in
the Android common kernel sources, see registration at:
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/net/netfilter/xt_IDLETIMER.c#483

When we compare that to upstream's new idletimer target rev 1:
  https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/tree/include/uapi/linux/netfilter/xt_IDLETIMER.h#n46

We immediately notice that these two rev 1 structs are the
same size and layout, and that while timer_type and send_nl_msg
are differently named and serve a different purpose, they're
at the same offset.

This makes them impossible to tell apart - and thus one cannot
know in a mixed Android/vanilla environment whether one means
timer_type or send_nl_msg.

Since this is iptables/netfilter uapi it introduces a problem
between iptables (vanilla vs Android) userspace and kernel
(vanilla vs Android) if the two don't match each other.

Additionally when at some point in the future Android picks up
5.7+ it's not at all clear how to resolve the resulting merge
conflict.

Furthermore, since upgrading the kernel on old Android phones
is pretty much impossible there does not seem to be an easy way
out of this predicament.

The only thing I've been able to come up with is some super
disgusting kernel version >= 5.7 check in the iptables binary
to flip between different struct layouts.

By adding a dummy field to the vanilla Linux kernel header file
we can force the two structs to be compatible with each other.

Long term I think I would like to deprecate send_nl_msg out of
Android entirely, but I haven't quite been able to figure out
exactly how we depend on it.  It seems to be very similar to
sysfs notifications but with some extra info.

Currently it's actually always enabled whenever Android uses
the IDLETIMER target, so we could also probably entirely
remove it from the uapi in favour of just always enabling it,
but again we can't upgrade old kernels already in the field.

(Also note that this doesn't change the structure's size,
as it is simply fitting into the pre-existing padding, and
that since 5.7 hasn't been released yet, there's still time
to make this uapi visible change)

Cc: Manoj Basapathi <manojbm@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/uapi/linux/netfilter/xt_IDLETIMER.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 434e6506abaa..49ddcdc61c09 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -48,6 +48,7 @@ struct idletimer_tg_info_v1 {
 
 	char label[MAX_IDLETIMER_LABEL_SIZE];
 
+	__u8 send_nl_msg;   /* unused: for compatibility with Android */
 	__u8 timer_type;
 
 	/* for kernel module internal use only */
-- 
2.26.0.rc2.310.g2932bb562d-goog

