Return-Path: <netdev+bounces-1263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 504446FD157
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69AB71C20CA0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B332D19937;
	Tue,  9 May 2023 21:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F4119E48
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:13 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E417DDBE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:59 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64388cf3263so4592830b3a.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667299; x=1686259299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsmBcgUebKPUHByZozvyrT4LxVt6vU9NOhArab8Y1QA=;
        b=pZM9y/lsJJb3nQu23XNxLevM0P0o3WiSAvT/dnPBvy6xcn+RCoY6DBHa8/BAmsUAlK
         zmqkcZH9PEMZyRu3JSISmWqwIqhSd9JRr0muF4xiYZ47TveVUZ5VuT3OgdwKaKuR90F9
         FPc1r+nyjt+o6Zuj7lxRKzWc/fWryZ4MpA+cDBAdLTrOZrW0WPJBVrovp0xMDayGr+QO
         AOfFW1HuH1n8nAksW0zzSbfXwFtZgiBHIUFO90ymxoIeJCuRbDrBjCK4CcsBy3cgMYv1
         R9xE/1BACMC40yKKqcaZemzMgVNmph+HNRAeizn14t7EuPtBJomKPsvDiSA4EqPMXqk6
         jGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667299; x=1686259299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qsmBcgUebKPUHByZozvyrT4LxVt6vU9NOhArab8Y1QA=;
        b=KfnOV7tNa5pGHnnOGbxK333OP5Y0nqrjALZZcPtou4coDHDzUlCt4V9T8tN+OdxljN
         drVPlfFiVH+qYdwPDMDrvGLW1z0IbxNqB3CulGj4OhPBbNO3AEXaPMbFlqLi5YdfGGug
         UGaITeQnaeUCE5R+edFZFUGmp5sEX+eTU6yGvaAwE2MzeNvbeDyZyM+MrfKRi7zLfjLM
         OfDee4LatfxZW93DNvWnuQKMOqtap1MOPUSTnPwkEq449bqUgZ2K3wCibAHe0C5jYUmq
         DmGgI0s4GETElGr/FWffsbwaDDQ9+fLz+c4xcVgxMtRp3F/CFnYnGIkjR63BxW/jRWRm
         UdBg==
X-Gm-Message-State: AC+VfDz5k3v06wl0gBTxD9ejbP0p/iYZ0iqwAK3TukiQXF4tYPPYzVlt
	3I7EppBjPLu+Y9akOT/M//GDUPxpOspZILsuNcBnCw==
X-Google-Smtp-Source: ACHHUZ6yEFFwrwBYsM/R/DOaqeI0i/4UGnbaEQC5O9/84du6rKxPQxom51rXRc7WWaxm2yPaIzx5jQ==
X-Received: by 2002:a05:6a00:ac2:b0:63d:2f13:200 with SMTP id c2-20020a056a000ac200b0063d2f130200mr22860369pfl.16.1683667298983;
        Tue, 09 May 2023 14:21:38 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:38 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 09/11] nstat: fix potential NULL deref
Date: Tue,  9 May 2023 14:21:23 -0700
Message-Id: <20230509212125.15880-10-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509212125.15880-1-stephen@networkplumber.org>
References: <20230509212125.15880-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Reported as:
    CC       nstat
nstat.c: In function ‘load_ugly_table’:
nstat.c:205:24: warning: dereference of NULL ‘p’ [CWE-476] [-Wanalyzer-null-dereference]
  205 |                 while (*p) {
      |                        ^~
  ‘main’: events 1-14
    |
    |  575 | int main(int argc, char *argv[])
    |      |     ^~~~
    |      |     |
    |      |     (1) entry to ‘main’
    |......
    |  635 |         if (scan_interval > 0) {
    |      |            ~
    |      |            |
    |      |            (2) following ‘true’ branch...
    |  636 |                 if (time_constant == 0)
    |      |                     ~~~~~~~~~~~~~~~~~~
    |      |                                   |
    |      |                                   (3) ...to here
    |......
    |  640 |                 if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
    |      |                    ~      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                    |      |
    |      |                    |      (4) when ‘socket’ succeeds
    |      |                    (5) following ‘false’ branch (when ‘fd >= 0’)...
    |......
    |  644 |                 if (bind(fd, (struct sockaddr *)&sun, 2+1+strlen(sun.sun_path+1)) < 0) {
    |      |                    ~                                      ~~~~~~~~~~~~~~~~~~~~~~
    |      |                    |                                      |
    |      |                    (7) following ‘false’ branch...        (6) ...to here
    |......
    |  648 |                 if (listen(fd, 5) < 0) {
    |      |                    ~~~~~~~~~~~~~~
    |      |                    ||
    |      |                    |(8) ...to here
    |      |                    |(9) when ‘listen’ succeeds
    |      |                    (10) following ‘false’ branch...
    |......
    |  652 |                 if (daemon(0, 0)) {
    |      |                    ~~~~~~~~~~~~~
    |      |                    ||
    |      |                    |(11) ...to here
    |      |                    (12) following ‘false’ branch...
    |......
    |  656 |                 signal(SIGPIPE, SIG_IGN);
    |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                 |
    |      |                 (13) ...to here
    |  657 |                 signal(SIGCHLD, sigchild);
    |  658 |                 server_loop(fd);
    |      |                 ~~~~~~~~~~~~~~~
    |      |                 |
    |      |                 (14) calling ‘server_loop’ from ‘main’
    |
    +--> ‘server_loop’: events 15-16
           |
           |  472 | static void server_loop(int fd)
           |      |             ^~~~~~~~~~~
           |      |             |
           |      |             (15) entry to ‘server_loop’
           |......
           |  483 |         load_netstat();
           |      |         ~~~~~~~~~~~~~~
           |      |         |
           |      |         (16) calling ‘load_netstat’ from ‘server_loop’
           |
           +--> ‘load_netstat’: events 17-20
                  |
                  |  302 | static void load_netstat(void)
                  |      |             ^~~~~~~~~~~~
                  |      |             |
                  |      |             (17) entry to ‘load_netstat’
                  |......
                  |  306 |         if (fp) {
                  |      |            ~
                  |      |            |
                  |      |            (18) following ‘true’ branch (when ‘fp’ is non-NULL)...
                  |  307 |                 load_ugly_table(fp);
                  |      |                 ~~~~~~~~~~~~~~~~~~~
                  |      |                 |
                  |      |                 (19) ...to here
                  |      |                 (20) calling ‘load_ugly_table’ from ‘load_netstat’
                  |
                  +--> ‘load_ugly_table’: events 21-26
                         |
                         |  178 | static void load_ugly_table(FILE *fp)
                         |      |             ^~~~~~~~~~~~~~~
                         |      |             |
                         |      |             (21) entry to ‘load_ugly_table’
                         |  179 | {
                         |  180 |         char *buf = NULL;
                         |      |               ~~~
                         |      |               |
                         |      |               (22) ‘buf’ is NULL
                         |......
                         |  186 |         while ((nread = getline(&buf, &buflen, fp)) != -1) {
                         |      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         |      |                                                     |
                         |      |                                                     (23) following ‘true’ branch...
                         |......
                         |  192 |                 p = strchr(buf, ':');
                         |      |                     ~~~~~~~~~~~~~~~~
                         |      |                     |
                         |      |                     (24) ...to here
                         |      |                     (25) when ‘strchr’ returns non-NULL
                         |  193 |                 if (!p) {
                         |      |                    ~
                         |      |                    |
                         |      |                    (26) following ‘false’ branch (when ‘p’ is non-NULL)...
                         |
                       ‘load_ugly_table’: event 27
                         |
                         |cc1:
                         | (27): ...to here
                         |
                       ‘load_ugly_table’: events 28-40
                         |
                         |  205 |                 while (*p) {
                         |      |                        ^~
                         |      |                        |
                         |      |                        (28) following ‘true’ branch...
                         |      |                        (40) dereference of NULL ‘p’
                         |......
                         |  208 |                         if ((next = strchr(p, ' ')) != NULL)
                         |      |                            ~        ~~~~~~~~~~~~~~
                         |      |                            |        |
                         |      |                            |        (29) ...to here
                         |      |                            |        (30) when ‘strchr’ returns NULL
                         |      |                            (31) following ‘false’ branch (when ‘next’ is NULL)...
                         |  209 |                                 *next++ = 0;
                         |  210 |                         else if ((next = strchr(p, '\n')) != NULL)
                         |      |                                 ~        ~~~~~~~~~~~~~~~
                         |      |                                 |        |
                         |      |                                 |        (32) ...to here
                         |      |                                 |        (33) when ‘strchr’ returns NULL
                         |      |                                 (34) following ‘false’ branch (when ‘next’ is NULL)...
                         |  211 |                                 *next++ = 0;
                         |  212 |                         if (off < sizeof(idbuf)) {
                         |      |                            ~~~~~~~~~~~~~~~~~~~~
                         |      |                            |    |
                         |      |                            |    (35) ...to here
                         |      |                            (36) following ‘false’ branch...
                         |......
                         |  216 |                         n = malloc(sizeof(*n));
                         |      |                             ~~~~~~~~~~~~~~~~~~
                         |      |                             |
                         |      |                             (37) ...to here
                         |  217 |                         if (!n) {
                         |      |                            ~
                         |      |                            |
                         |      |                            (38) following ‘false’ branch (when ‘n’ is non-NULL)...
                         |......
                         |  221 |                         n->id = strdup(idbuf);
                         |      |                                 ~~~~~~~~~~~~~
                         |      |                                 |
                         |      |                                 (39) ...to here
                         |
nstat.c:254:35: warning: dereference of NULL ‘n’ [CWE-476] [-Wanalyzer-null-dereference]
  254 |                                 n = n->next;
      |                                 ~~^~~~~~~~~
  ‘main’: events 1-14
    |
    |  575 | int main(int argc, char *argv[])
    |      |     ^~~~
    |      |     |
    |      |     (1) entry to ‘main’
    |......
    |  635 |         if (scan_interval > 0) {
    |      |            ~
    |      |            |
    |      |            (2) following ‘true’ branch...
    |  636 |                 if (time_constant == 0)
    |      |                     ~~~~~~~~~~~~~~~~~~
    |      |                                   |
    |      |                                   (3) ...to here
    |......
    |  640 |                 if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
    |      |                    ~      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                    |      |
    |      |                    |      (4) when ‘socket’ succeeds
    |      |                    (5) following ‘false’ branch (when ‘fd >= 0’)...
    |......
    |  644 |                 if (bind(fd, (struct sockaddr *)&sun, 2+1+strlen(sun.sun_path+1)) < 0) {
    |      |                    ~                                      ~~~~~~~~~~~~~~~~~~~~~~
    |      |                    |                                      |
    |      |                    (7) following ‘false’ branch...        (6) ...to here
    |......
    |  648 |                 if (listen(fd, 5) < 0) {
    |      |                    ~~~~~~~~~~~~~~
    |      |                    ||
    |      |                    |(8) ...to here
    |      |                    |(9) when ‘listen’ succeeds
    |      |                    (10) following ‘false’ branch...
    |......
    |  652 |                 if (daemon(0, 0)) {
    |      |                    ~~~~~~~~~~~~~
    |      |                    ||
    |      |                    |(11) ...to here
    |      |                    (12) following ‘false’ branch...
    |......
    |  656 |                 signal(SIGPIPE, SIG_IGN);
    |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                 |
    |      |                 (13) ...to here
    |  657 |                 signal(SIGCHLD, sigchild);
    |  658 |                 server_loop(fd);
    |      |                 ~~~~~~~~~~~~~~~
    |      |                 |
    |      |                 (14) calling ‘server_loop’ from ‘main’
    |
    +--> ‘server_loop’: events 15-16
           |
           |  472 | static void server_loop(int fd)
           |      |             ^~~~~~~~~~~
           |      |             |
           |      |             (15) entry to ‘server_loop’
           |......
           |  483 |         load_netstat();
           |      |         ~~~~~~~~~~~~~~
           |      |         |
           |      |         (16) calling ‘load_netstat’ from ‘server_loop’
           |
           +--> ‘load_netstat’: events 17-20
                  |
                  |  302 | static void load_netstat(void)
                  |      |             ^~~~~~~~~~~~
                  |      |             |
                  |      |             (17) entry to ‘load_netstat’
                  |......
                  |  306 |         if (fp) {
                  |      |            ~
                  |      |            |
                  |      |            (18) following ‘true’ branch (when ‘fp’ is non-NULL)...
                  |  307 |                 load_ugly_table(fp);
                  |      |                 ~~~~~~~~~~~~~~~~~~~
                  |      |                 |
                  |      |                 (19) ...to here
                  |      |                 (20) calling ‘load_ugly_table’ from ‘load_netstat’
                  |
                  +--> ‘load_ugly_table’: events 21-25
                         |
                         |  178 | static void load_ugly_table(FILE *fp)
                         |      |             ^~~~~~~~~~~~~~~
                         |      |             |
                         |      |             (21) entry to ‘load_ugly_table’
                         |......
                         |  186 |         while ((nread = getline(&buf, &buflen, fp)) != -1) {
                         |      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         |      |                                                     |
                         |      |                                                     (22) following ‘true’ branch...
                         |......
                         |  192 |                 p = strchr(buf, ':');
                         |      |                     ~~~~~~~~~~~~~~~~
                         |      |                     |
                         |      |                     (23) ...to here
                         |      |                     (24) when ‘strchr’ returns non-NULL
                         |  193 |                 if (!p) {
                         |      |                    ~
                         |      |                    |
                         |      |                    (25) following ‘false’ branch (when ‘p’ is non-NULL)...
                         |
                       ‘load_ugly_table’: event 26
                         |
                         |cc1:
                         | (26): ...to here
                         |
                       ‘load_ugly_table’: events 27-28
                         |
                         |  205 |                 while (*p) {
                         |      |                        ^
                         |      |                        |
                         |      |                        (27) following ‘false’ branch...
                         |......
                         |  228 |                 nread = getline(&buf, &buflen, fp);
                         |      |                         ~
                         |      |                         |
                         |      |                         (28) inlined call to ‘getline’ from ‘load_ugly_table’
                         |
                         +--> ‘getline’: event 29
                                |
                                |/usr/include/bits/stdio.h:120:10:
                                |  120 |   return __getdelim (__lineptr, __n, '\n', __stream);
                                |      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                |      |          |
                                |      |          (29) ...to here
                                |
                         <------+
                         |
                       ‘load_ugly_table’: events 30-36
                         |
                         |nstat.c:229:20:
                         |  229 |                 if (nread == -1) {
                         |      |                    ^
                         |      |                    |
                         |      |                    (30) following ‘false’ branch...
                         |......
                         |  234 |                 count2 = count_spaces(buf);
                         |      |                          ~~~~~~~~~~~~~~~~~
                         |      |                          |
                         |      |                          (31) ...to here
                         |......
                         |  239 |                         if (!p) {
                         |      |                            ~
                         |      |                            |
                         |      |                            (32) following ‘false’ branch (when ‘p’ is non-NULL)...
                         |......
                         |  244 |                         *p = 0;
                         |      |                         ~~~~~~
                         |      |                            |
                         |      |                            (33) ...to here
                         |  245 |                         if (sscanf(p+1, "%llu", &n->val) != 1) {
                         |      |                            ~
                         |      |                            |
                         |      |                            (34) following ‘false’ branch...
                         |......
                         |  251 |                         if (skip)
                         |      |                            ~
                         |      |                            |
                         |      |                            (35) ...to here
                         |......
                         |  254 |                                 n = n->next;
                         |      |                                 ~~~~~~~~~~~
                         |      |                                   |
                         |      |                                   (36) dereference of NULL ‘n’
                         |

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 misc/nstat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/misc/nstat.c b/misc/nstat.c
index 0ab92ecbeb47..2c10feaa3adf 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -219,9 +219,15 @@ static void load_ugly_table(FILE *fp)
 				exit(-1);
 			}
 			n->id = strdup(idbuf);
+			if (n->id == NULL) {
+				perror("nstat: strdup");
+				exit(-1);
+			}
 			n->rate = 0;
 			n->next = db;
 			db = n;
+			if (next == NULL)
+				break;
 			p = next;
 		}
 		n = db;
-- 
2.39.2


