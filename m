Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F6F2F9603
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbhAQWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:55:14 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:56156 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbhAQWzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:55:13 -0500
Received: by mail-wm1-f50.google.com with SMTP id c124so11996537wma.5
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 14:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S+9BoYevb6oGYlL5PcDUa+DB5WIMCM4Zg5ujR0S9IFY=;
        b=RoS3wGh4RY7d+jUbHcrvXy0Xf/9wjMb2pn6w7sdVJ0/yrySwJVT1Wb5jlyI0sTwZHr
         XAyHCMuCHa4gZl9ZXbSelN8Aser2oa5PcxaWGashpWP6DWzIBaaozM8NEhQk6eQs/50C
         z0J+Q7yY/oqmE9gQ7KZ1t9G8a55N6KoNj7G06ZsZTtLxXP7Qohfys8RKj3Dmlgi2ZJvE
         EKMMj79w/eeDxpoh6PE4tKJ7RCkTkElYSU9QnSz2503aHS/Rt2isP1fgjPHbgwgUDchB
         cGQcpdvr1DqhNB4s4sVsExP24tte3kH1KXZLjzBdDdJkAkk0Jtv0GnaMf/MH1cb30NPM
         F2cA==
X-Gm-Message-State: AOAM530vVUbY450jRk/L0nnnpfcy/OfkZ6ASVzjcyBWAbGf69kXP0d+S
        yQq+dzxKG3k/5z0gS/HCVu25ZlF1VSsj4Q==
X-Google-Smtp-Source: ABdhPJyU1ZBBn9AsLv9HYQIcssEDXne7JSrvaWbB6Cb19z/XybykUQnHy8vN9v7dNO7jQvbQKj+GOQ==
X-Received: by 2002:a05:600c:4101:: with SMTP id j1mr17998487wmi.55.1610924071771;
        Sun, 17 Jan 2021 14:54:31 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id m14sm25301640wrh.94.2021.01.17.14.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 14:54:31 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Subject: [PATCH iproute2 1/2] vrf: print BPF log buffer if bpf_program_load fails
Date:   Sun, 17 Jan 2021 22:54:26 +0000
Message-Id: <20210117225427.29658-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Necessary to understand what is going on when bpf_program_load fails

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 ip/ipvrf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 42779e5c..91578031 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -278,8 +278,8 @@ static int vrf_configure_cgroup(const char *path, int ifindex)
 	 */
 	prog_fd = prog_load(ifindex);
 	if (prog_fd < 0) {
-		fprintf(stderr, "Failed to load BPF prog: '%s'\n",
-			strerror(errno));
+		fprintf(stderr, "Failed to load BPF prog: '%s'\n%s",
+			strerror(errno), bpf_log_buf);
 
 		if (errno != EPERM) {
 			fprintf(stderr,
-- 
2.29.2

