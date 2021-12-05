Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7584468B81
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhLEOzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 09:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbhLEOzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 09:55:08 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4205C061A83
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 06:51:40 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i12so7750721pfd.6
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 06:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h3YljNelpLYurDb9qdET1+BdmKMP449z9py0Gh1sNcI=;
        b=KlyrDEascSedjmQ6m/eg0D7PY7G612B3EmrP1NscQ4eGbJj037PV8M1Zqtheb9+iwj
         AviQ0zImdyacEmnQoGcfHQmj9rgspgyCDSljp3SbLn0a0kITqDiFzACuqlNquyDB/aUq
         khC6D78Hlm54RUCVwrvYwn0QGePXwTgubI6CFc0WGrFzMvEUKJkXe6sgWprCQRTyf1KQ
         2g1KWGPY0eLViCDSUZQkV901Iumk+ZRnoCmGC/XEgkCxoLsB/3eeoAxIw0d2HY2OvASB
         SNScQOEdxWI1dMoWQRQcwl68nHAENfYelEVYRK/JoIVvYToujYdjoYkhfPFsXxisz391
         heFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h3YljNelpLYurDb9qdET1+BdmKMP449z9py0Gh1sNcI=;
        b=WL8Y7vrq5qZmjSJwKq3VsH5eCOW48eK+zuXeyAOITOd/w61uCBmGWK5qee2m0vMqbu
         Nw/WxhojfRvVT84ynCtq+zzYQ4g1YbkQMplWa10BAcIEdSm71x/vLHhwutH2uj3YOODb
         rtCxjyMLrXMHDoK4GunB0QZXH7pt9WIC36DFCkBG9mJThkamOM/3v5MGHXNdvZdkZ5Z1
         RH9i786uNUeUvfSO5Xo9e9Dxj/15B6xJCmfu0XPlV7yBAo+TU/dGJMezaXTL6b1gohDn
         or2/1601bwIcB18qiTeYHVaLbuBKLqalAVnogAxF8szmue9qEuXJ55o7GMFWEcTbiDIE
         5n8Q==
X-Gm-Message-State: AOAM532MdMDbcpUwa08TM5O26BwY9g1nrL5LhhGUO7ttYU6c0CyGIWxF
        ee7JWog4vZnoYg6ygSagtKdiLg==
X-Google-Smtp-Source: ABdhPJw/kut7WA2CgtIMvPTxsWYwUnt4uJMZW1REaKKpU+Wjg8UkgeddhtYG0nXWVQme7QOqSE/rLg==
X-Received: by 2002:a05:6a00:1248:b0:4a2:5cba:89cb with SMTP id u8-20020a056a00124800b004a25cba89cbmr31642944pfi.12.1638715900203;
        Sun, 05 Dec 2021 06:51:40 -0800 (PST)
Received: from localhost ([2602:feda:dd6:6166:ad52:d50b:8700:3c60])
        by smtp.gmail.com with ESMTPSA id y130sm8967440pfg.202.2021.12.05.06.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:51:39 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 6/7] audit: Use task_is_in_root_ns()
Date:   Sun,  5 Dec 2021 22:51:04 +0800
Message-Id: <20211205145105.57824-7-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205145105.57824-1-leo.yan@linaro.org>
References: <20211205145105.57824-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace open coded checking root PID namespace with
task_is_in_root_ns().

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 121d37e700a6..c71d4182c05d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1034,7 +1034,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_MAKE_EQUIV:
 		/* Only support auditd and auditctl in initial pid namespace
 		 * for now. */
-		if (task_active_pid_ns(current) != &init_pid_ns)
+		if (!task_is_in_root_ns(current))
 			return -EPERM;
 
 		if (!netlink_capable(skb, CAP_AUDIT_CONTROL))
-- 
2.25.1

