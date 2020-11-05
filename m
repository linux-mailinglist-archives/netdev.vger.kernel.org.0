Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9A22A7BD0
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgKEK33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgKEK33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:29:29 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B587C0613CF;
        Thu,  5 Nov 2020 02:29:29 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z24so1129431pgk.3;
        Thu, 05 Nov 2020 02:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o05g9lm8nxzKqTNUi88bFCci2Fg4t0bp4is002sYr4w=;
        b=uqzEHaNXEdvcOFYpRFYUGY3EEh5p2uuuBjKl6cXsU+RsiYBcdrtM7lDHXRPAuakWtR
         yLMHbRQ25U0p4exJ0TzWLlbweM3dxAiwjtLlv+F11X4mMHtJmeEpzobBfUxfblP6lhBL
         woIQCVlpGoD9Ed0RnOzIxQ0qexaDoSAxzom78dgtv+4NGxQzXAZsymsFcuOAFLrZ1bf+
         NlumzdymzXF5CNwL1+tymgkLKuOkOX6xp8e+ZiUEiJ5jW6dI3JaTQYSN5B3V4Q5ymQGI
         IuYg1cDDEWmYQSyhiNLFkPwoxc5tkOZW0LRqqk9Vmrgc/BPhQlEayJ4gYCBiNfOQqk1K
         u36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o05g9lm8nxzKqTNUi88bFCci2Fg4t0bp4is002sYr4w=;
        b=h0Eehy4zVwk/WecFJxvGfRNDJCaxN8ZXrdT0ALHbHpUOJMjSO2iDHIz2wfEH9RCYSz
         IoXoVXpgVL8B3l9BpYVyr0O4r20XN36bY6Zb3wUogkOHD1kbl5ycWWZOCjPkdm5RTV/3
         99vOs3TnrEIqJHJ8lmqyQaCwpu4udPYKIVE7A9V4jm/ZcAO9EzTTh+ZVVI1886wXHXn0
         ci4XHZSL2yDxKBTzgK5e2kn/625UoxWfU38y6jbRsxNm86sKv7ejz406Ejl87SxIsQoF
         LJ8TJWBYmBMx/YTk7WgbN1Ei6XeyDm/y93oq4+yckGlmLc3Gg1vL8/d8VeEk7ZqPLig2
         eLyA==
X-Gm-Message-State: AOAM530lpM0AdBpbj0VJEgW3HBNhy39OgPFMsjfyNM+MHmQg+USWiiJK
        GxuypsWt6ezsWs/ceq8VZlIe+wTNeMdxMyZH
X-Google-Smtp-Source: ABdhPJygWbdDi+RdXm++zo6+HKTUkEGJTSqTyIcn9A9mmP3OyL+AXdLE6DkqkgRHVLcXDsDENrkejw==
X-Received: by 2002:a17:90a:1188:: with SMTP id e8mr1798390pja.61.1604572168128;
        Thu, 05 Nov 2020 02:29:28 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 192sm2050117pfz.200.2020.11.05.02.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:29:27 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next v2 9/9] samples/bpf: add option to set the busy-poll budget
Date:   Thu,  5 Nov 2020 11:28:12 +0100
Message-Id: <20201105102812.152836-10-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201105102812.152836-1-bjorn.topel@gmail.com>
References: <20201105102812.152836-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Support for the SO_BUSY_POLL_BUDGET setsockopt, via the batching
option ('b').

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 162444fa9627..0ed05e6e40e2 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1482,6 +1482,11 @@ static void apply_setsockopt(struct xsk_socket_info *xsk)
 	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
 		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
 		exit_with_error(errno);
+
+	sock_opt = opt_batch_size;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL_BUDGET,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
 }
 
 int main(int argc, char **argv)
-- 
2.27.0

