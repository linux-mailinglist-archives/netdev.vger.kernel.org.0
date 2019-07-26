Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDAF877386
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfGZVf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:35:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34591 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbfGZVf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:35:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so19128456pgc.1
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 14:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K1Uci2CHVh/6XLyFzUBThzQwDVbdp0rM3WL19majYrg=;
        b=IcKAMD7aJGvEShodu+zDM0BoROsyBNEJoUFgM1/5zkLtz6A5zfwerviyCn7gxjztFd
         m8KpvSimaYfdd/Y4ULAdSHHhfqVBD/62RxUIYfIJJ40+oSuH+gbzsFKDiSPyQzslzBm+
         xbyYhmPp2nrUjMMrgSXPHShq9cqv4gj1OLUhVRWKtzz5iWVEZRuypcgnThQMYcoJ6i3l
         XQfBSp/sWYiUuqE7NnQrTVmE9A+WbumY4/ohiZlvGXN6TCnx13u35b9wMp3y1PitM8bk
         gUY6kotVDpQ7N8ULbCycoRo6/R5AIdQJL8KaUbkTNJxKnkVWDwzFq8OZP4/3QnwE1trY
         gHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K1Uci2CHVh/6XLyFzUBThzQwDVbdp0rM3WL19majYrg=;
        b=pAOMNLdqkFWWFjeVX4l9Q1SashlOJ0fmd1JKaphaygoOjj35XtkLYRBaCUDpSUTbAs
         wZyKO818hrNvI+RIHi1hil1oX/pWi8DqpyIPfDjEwPLDt9Us+3hQfjNRm0P+iCpucbVX
         yAgLLsfPYFTF/0sZ6r5q0oHlMHKYIn/V5qaxgtT6wIlLxW2CV1QVqYcKZ/rU8ileWK+t
         rUtk39Ru0Zp9N2FLkzkm1WSfGnAfkUCeh2Pg6inmhdAbzguooNXxWo9xAG1zG7zAREJ7
         Ir/EwxgYe2DWuOg4Au5Jw0UMZ07dGMtMpeU0OgvG134EdOVDoFkpc8o/L5vZXGeOPx04
         VNHA==
X-Gm-Message-State: APjAAAXrKahjv2xr2u07Ia5Gp19gCU8THNyYRAfntENrMGhsaxkT4Z7d
        GyuVTTMz32KQkls7J145TstSvBbe
X-Google-Smtp-Source: APXvYqzgCmJLn0UoBCnSj8nHX3pz44u4S7jnY0KUV8DlXEsdaJpYQmKCgFrcXqX6ZDpj3Lj6Db3VPQ==
X-Received: by 2002:a65:6815:: with SMTP id l21mr4682457pgt.146.1564176954905;
        Fri, 26 Jul 2019 14:35:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r15sm58792813pfh.121.2019.07.26.14.35.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 14:35:54 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:35:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 2/2] tc: batch: fix line/line_next processing
 in batch
Message-ID: <20190726143552.403d22b0@hermes.lan>
In-Reply-To: <20190723112538.10977-2-jiri@resnulli.us>
References: <20190723112538.10977-1-jiri@resnulli.us>
        <20190723112538.10977-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 13:25:38 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
>=20
> When getcmdline fails, there is no valid string in line_next.
> So change the flow and don't process it. Alongside with that,
> free the previous line buffer and prevent memory leak.
>=20
> Fixes: 485d0c6001c4 ("tc: Add batchsize feature for filter and actions")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>


This is not sufficient to avoid valgrind detected uninitialized memory.
The following changes to your patch (#2 alone) is enough to fix
the issue.

The logic here is still a mess and needs to be cleaned up to avoid
future related bugs.

=46rom bbcc22899566556ced9692e4811aea2a38817834 Mon Sep 17 00:00:00 2001
From: Jiri Pirko <jiri@mellanox.com>
Date: Tue, 23 Jul 2019 13:25:38 +0200
Subject: [PATCH] tc: batch: fix line/line_next processing in batch

When getcmdline fails, there is no valid string in line_next.
So change the flow and don't process it. Alongside with that,
free the previous line buffer and prevent memory leak.

Also, avoid passing uninitialized memory to filters.

Fixes: 485d0c6001c4 ("tc: Add batchsize feature for filter and actions")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc.c | 84 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/tc/tc.c b/tc/tc.c
index 64e342dd85bf..95e5481955ad 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -325,11 +325,10 @@ static int batch(const char *name)
 {
 	struct batch_buf *head =3D NULL, *tail =3D NULL, *buf_pool =3D NULL;
 	char *largv[100], *largv_next[100];
-	char *line, *line_next =3D NULL;
+	char *line =3D NULL, *line_next =3D NULL;
 	bool bs_enabled =3D false;
 	bool lastline =3D false;
 	int largc, largc_next;
-	bool bs_enabled_saved;
 	bool bs_enabled_next;
 	int batchsize =3D 0;
 	size_t len =3D 0;
@@ -360,47 +359,40 @@ static int batch(const char *name)
 	largc =3D makeargs(line, largv, 100);
 	bs_enabled =3D batchsize_enabled(largc, largv);
 	do {
-		if (getcmdline(&line_next, &len, stdin) =3D=3D -1)
+		if (getcmdline(&line_next, &len, stdin) =3D=3D -1) {
 			lastline =3D true;
-
-		largc_next =3D makeargs(line_next, largv_next, 100);
-		bs_enabled_next =3D batchsize_enabled(largc_next, largv_next);
-		if (bs_enabled) {
-			struct batch_buf *buf;
-
-			buf =3D get_batch_buf(&buf_pool, &head, &tail);
-			if (!buf) {
-				fprintf(stderr,
-					"failed to allocate batch_buf\n");
-				return -1;
-			}
-			++batchsize;
-		}
-
-		/*
-		 * In batch mode, if we haven't accumulated enough commands
-		 * and this is not the last command and this command & next
-		 * command both support the batchsize feature, don't send the
-		 * message immediately.
-		 */
-		if (!lastline && bs_enabled && bs_enabled_next
-		    && batchsize !=3D MSG_IOV_MAX)
-			send =3D false;
-		else
 			send =3D true;
+		} else {
+			largc_next =3D makeargs(line_next, largv_next, 100);
+			bs_enabled_next =3D batchsize_enabled(largc_next, largv_next);
+			if (bs_enabled) {
+				struct batch_buf *buf;
+
+				buf =3D get_batch_buf(&buf_pool, &head, &tail);
+				if (!buf) {
+					fprintf(stderr,
+						"failed to allocate batch_buf\n");
+					return -1;
+				}
+				++batchsize;
+			}
=20
-		line =3D line_next;
-		line_next =3D NULL;
-		len =3D 0;
-		bs_enabled_saved =3D bs_enabled;
-		bs_enabled =3D bs_enabled_next;
-
-		if (largc =3D=3D 0) {
-			largc =3D largc_next;
-			memcpy(largv, largv_next, largc * sizeof(char *));
-			continue;	/* blank line */
+			/*
+			 * In batch mode, if we haven't accumulated enough
+			 * commands and this is not the last command and this
+			 * command & next command both support the batchsize
+			 * feature, don't send the message immediately.
+			 */
+			if (bs_enabled && bs_enabled_next
+			    && batchsize !=3D MSG_IOV_MAX)
+				send =3D false;
+			else
+				send =3D true;
 		}
=20
+		if (largc =3D=3D 0)
+			goto to_next_line;	/* blank line */
+
 		err =3D do_cmd(largc, largv, tail =3D=3D NULL ? NULL : tail->buf,
 			     tail =3D=3D NULL ? 0 : sizeof(tail->buf));
 		fflush(stdout);
@@ -411,10 +403,8 @@ static int batch(const char *name)
 			if (!force)
 				break;
 		}
-		largc =3D largc_next;
-		memcpy(largv, largv_next, largc * sizeof(char *));
=20
-		if (send && bs_enabled_saved) {
+		if (send && bs_enabled) {
 			struct iovec *iov, *iovs;
 			struct batch_buf *buf;
 			struct nlmsghdr *n;
@@ -438,6 +428,18 @@ static int batch(const char *name)
 			}
 			batchsize =3D 0;
 		}
+
+to_next_line:
+		if (lastline)
+			continue;
+		free(line);
+		line =3D line_next;
+		line_next =3D NULL;
+		len =3D 0;
+		bs_enabled =3D bs_enabled_next;
+		largc =3D largc_next;
+		memcpy(largv, largv_next, largc * sizeof(char *));
+
 	} while (!lastline);
=20
 	free_batch_bufs(&buf_pool);
--=20
2.20.1

