Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680298B993
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfHMNJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:09:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40594 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbfHMNJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:09:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so1395488wmj.5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 06:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5t2Cjkq2qCeaG9kNbXuJM01Wwz49tMsT0IYIprvtUF8=;
        b=FA3IsM7WCftMDKM0KjEbh9ABTtcFnjKmj12/6SWB8PeXc4fR7K44ra8Iab2SO4Jp4e
         QTtTaobooTjCmkDrYD5zV9oRRHGwGiwUs/ASEtee0k4otrCtjM+4QMwUj0DEYLsgltQ5
         +i3zSu29EgB1vmd5SX3Q6epR3pQoDAZPhV53t6ILZV9oDXPujLuvSI3fmfa8mshpdUq3
         9K8m7sEkSHL4WceaASxVo6HTFdkbmssFWnLray1mqp3BdPBAZERNtQLPanSKjd2aOkOA
         ylK+I6iOb9OeSHse0mCeQg505nQxGFk1oZtYLqDb6fpoRFsppMbeh/aXkieG23D3WGe+
         JiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5t2Cjkq2qCeaG9kNbXuJM01Wwz49tMsT0IYIprvtUF8=;
        b=MT8JykIjenOAl8idg14Lbqv2ZY8uzrL3ZNtxiGVit+RrY2nDKAxvyb1IFRR8fnY2Xk
         OKotK/72ZEC+X6RD2HZtkcSHy2rJS0nEi8NoUUpGYAZ6EFxnYvPapPL6HXT46Bcabr5a
         FP39En2gmnLaIOiZ32MUt0uoit61vYUHAV12gDpv2NLQhhADaskzJzFJRDOxmJuqY2fi
         yAuTtGSCZZlnHd+kfG9x4U8yltT/u4SH2iwyG2I2FNEw9OjerSFxWyCg33RbcrnOy0GP
         5omrOL4wGr0llYTbU/mlChl+rkGoOV90Qxf+BSpIux7b0dD87aOtw/CrAQpflRZKEDCo
         GhUw==
X-Gm-Message-State: APjAAAXxwOhVNexZqYrsMkBB87W04jP95KbnViZ6ry+k7eXlHUXKYRi6
        44lBbH6iUQ01mLje0SjmGuQjfA==
X-Google-Smtp-Source: APXvYqxc+qQGpvM2IgwsH3+RygwGjsblkYoJEGg1sDVSn/qkgvJxBi2OIVQW+kU7lZtysghRtLpIlw==
X-Received: by 2002:a05:600c:2411:: with SMTP id 17mr2853483wmp.171.1565701778589;
        Tue, 13 Aug 2019 06:09:38 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id e3sm130534191wrs.37.2019.08.13.06.09.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:09:37 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [RFC bpf-next 2/3] tools: bpftool: make comment more explicit for count of dumped entries
Date:   Tue, 13 Aug 2019 14:09:20 +0100
Message-Id: <20190813130921.10704-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813130921.10704-1-quentin.monnet@netronome.com>
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The counter printed at the end of plain map dump does not reflect the
exact number of entries in the map, but the number of entries bpftool
managed to dump (some of them could not be read, or made no sense to
dump (map-in-map...)).

Edit slightly the message to make this more explicit.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 206ee46189d9..cead639b3ab1 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -809,7 +809,7 @@ static int do_dump(int argc, char **argv)
 		jsonw_end_array(btf_wtr);
 		jsonw_destroy(&btf_wtr);
 	} else {
-		printf("Found %u element%s\n", num_elems,
+		printf("Found %u element%s to dump\n", num_elems,
 		       num_elems != 1 ? "s" : "");
 	}
 
-- 
2.17.1

