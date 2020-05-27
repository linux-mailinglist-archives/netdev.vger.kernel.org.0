Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50B1E4CA9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbgE0SEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387706AbgE0SEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:04:00 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAFDC03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:04:00 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x22so285644qkj.6
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9i/bRUwAPM9mXEvfvIkOtCPtY5I/1oqqu8v1lj5old4=;
        b=vvpbDaly7MZWTjpshFpXk3YSKJvEP9B/TQyPqdYGotownUuZ5M5dePHv3PJkeJ8SJS
         hpoXnN8M6rHUFd2BQPrsavJHMxpfE1kmDhVjrM6bb39IpRU9zbQBJdLTZNvg9kUO0D4Y
         pWlSIFzOmzhjIO+0Zb/e/e9DUxY/TInVUr+wPu1oylmoQm1l4+MiGuH0NR+sf5O8ry63
         AFODZ3ZrgOQquGzBk31De0hFvACnFOs2kUc4+n2VcRXcxpyn1q74tlHz6z96JXYRKxpI
         cDmtu2nXvx2YIS/dsFMDnXjOGDVkFzL6JSQdzbFIZvS181zCZPL4Aifh9rrHzk0jaZ0a
         eVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9i/bRUwAPM9mXEvfvIkOtCPtY5I/1oqqu8v1lj5old4=;
        b=dnIjUBiyqMZ/gmaw0VPj8t/aMMBeNPj9Z8pVUFA9GOJ7ozICzRb/JvwQMrqURoPX9P
         ZWlEtp8aYYn0gzSsQBX0wusaX4HwplS3tU5swL2myErgtt1esDM51SSp+k96iXHNQfdF
         oKFO652qC1BkBQLKxRn7BPQlxeJ9vMS7eAwVtYZL9dp+eF2h6aBQr2cLwcOEpqhubANK
         SsLiCUkt/KurC1FDHBH2/9CHVXNI1ArtW/okPe0ewcu7XT30EvYz4UO7QsM7VDRSnKlx
         UGbQbqN9LqE3wPF8c3xcgrZmN8SyxvbjGnE7JTUrwLEwtRswGVECtwPeSeEf3wctKsYx
         1stw==
X-Gm-Message-State: AOAM532aJQE/HzIStRrFrCPiVwTrzZL8qxAb5nf6G8hY0mpoCMB6tya8
        cdqg1tlNuGzdh5BU1LcBYDKezPuuEByye4vh6WJdtfL+Ni0WPBSrnGLEEDpyw1bQAkFlCw1B6Fk
        PtKI3pA3tRVzVniXsMamJyB6xUVhoesAkU2gEXcpL/JaNpsY86LSH4TZC30b926/PAOVRnA==
X-Google-Smtp-Source: ABdhPJxqWCz16wtNho5W+bSNyuB7J1ktCujttzQLQKUaZw3XD6MeJFpjNX/KLxu9ycNXQpcuF2HWBXK4w4+ZEbA=
X-Received: by 2002:ad4:5506:: with SMTP id az6mr24719913qvb.136.1590602639210;
 Wed, 27 May 2020 11:03:59 -0700 (PDT)
Date:   Wed, 27 May 2020 11:03:46 -0700
In-Reply-To: <20200527180346.58573-1-icoolidge@google.com>
Message-Id: <20200527180346.58573-2-icoolidge@google.com>
Mime-Version: 1.0
References: <20200524015144.44017-1-icoolidge@google.com> <20200527180346.58573-1-icoolidge@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 2/2] iproute2: ip addr: Add support for setting 'optimistic'
From:   "Ian K. Coolidge" <icoolidge@google.com>
To:     netdev@vger.kernel.org
Cc:     ek@google.com, "Ian K. Coolidge" <icoolidge@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

optimistic DAD is controllable via sysctl for an interface
or all interfaces on the system. This would affect addresses
added by the kernel only.

Recent kernels, however, have enabled support for adding optimistic
address via userspace. This plumbs that support.
---
 ip/ipaddress.c           | 2 +-
 man/man8/ip-address.8.in | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 403f7010..3b53933f 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1243,7 +1243,7 @@ static const struct ifa_flag_data_t {
 	{ .name = "secondary",		.mask = IFA_F_SECONDARY,	.readonly = true,	.v6only = false},
 	{ .name = "temporary",		.mask = IFA_F_SECONDARY,	.readonly = true,	.v6only = false},
 	{ .name = "nodad",		.mask = IFA_F_NODAD,	 	.readonly = false,	.v6only = true},
-	{ .name = "optimistic",		.mask = IFA_F_OPTIMISTIC,	.readonly = true,	.v6only = true},
+	{ .name = "optimistic",		.mask = IFA_F_OPTIMISTIC,	.readonly = false,	.v6only = true},
 	{ .name = "dadfailed",		.mask = IFA_F_DADFAILED,	.readonly = true,	.v6only = true},
 	{ .name = "home",		.mask = IFA_F_HOMEADDRESS,	.readonly = false,	.v6only = true},
 	{ .name = "deprecated",		.mask = IFA_F_DEPRECATED,	.readonly = true,	.v6only = true},
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index 2a553190..fe773c91 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -92,7 +92,7 @@ ip-address \- protocol address management
 
 .ti -8
 .IR CONFFLAG " := "
-.RB "[ " home " | " mngtmpaddr " | " nodad " | " noprefixroute " | " autojoin " ]"
+.RB "[ " home " | " mngtmpaddr " | " nodad " | " optimstic " | " noprefixroute " | " autojoin " ]"
 
 .ti -8
 .IR LIFETIME " := [ "
@@ -258,6 +258,11 @@ stateless auto-configuration was active.
 (IPv6 only) do not perform Duplicate Address Detection (RFC 4862) when
 adding this address.
 
+.TP
+.B optimistic
+(IPv6 only) When performing Duplicate Address Detection, use the RFC 4429
+optimistic variant.
+
 .TP
 .B noprefixroute
 Do not automatically create a route for the network prefix of the added
-- 
2.27.0.rc0.183.gde8f92d652-goog

