Return-Path: <netdev+bounces-1267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F226FD170
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FC811C20C26
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7CE19935;
	Tue,  9 May 2023 21:30:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376F31990E
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:30:33 +0000 (UTC)
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C8F868D
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:30:02 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-77d049b9040so32913254241.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667749; x=1686259749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCAMuhT0Lspy7U+C4HPIny0OSgsSu/nIVqTyp9kVRMI=;
        b=pjRqHT/OJUB9NFrBFq2ZS1QKnlQVAxokPcMhIlmCZ1rtCJbAXX+GtnT9Dkpsazu8Js
         QyUHytLxW5ru2/7dxrMj2MQc8dEljK8wLFpR7ILMzJ11tzTXecA3sZHKfQbIatf3TiyN
         TRTOqZL85nC77b7ixazk4vPDxobY1wK6cgOLfpjIySZ8hPySPDHLI1cWEb8aEGYcvn/9
         6veXBo/0SRUb12v0lXzwQshFhq81jbomMySftB5wwHIVRb33vFlTXDhNkdjRqcGv89uD
         pqq3Gd+fOzzWs7t2WJc9LPC5CgSuNsiUHmnj4XQTR3wpfzb9UHgTioMRSEbHUVJxxlQT
         XBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667749; x=1686259749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCAMuhT0Lspy7U+C4HPIny0OSgsSu/nIVqTyp9kVRMI=;
        b=GuqUNF9oxX6iEm7LT4rrTNU+AR9Ll6/v/U3V1fB+7qobhCCh0WjagiMjcgSRY0SAhD
         Sc7GVeKvXhAogPb9w0qc76HpXjsL13uzi665bPm5/Oo1OJGQof4YLpzllSFX9tk1WmXB
         n/Mqx1fwDLx5X9QKhPnZUrzSGty9mogGWg8TMCffqmdZVRf5+aQE9pHcumgw6dl+/Wga
         f79zPPpBmJvY1c5bSJra/s+SayoNR23p9WiE96uQdGh0QUChg5epYVtQRJvQ0g5gs7fc
         8hBIBy1li5qay/SV6Fk3Pcv17Uc/PmKOW11w78ly2tlRpE6z26UJNNYjIAUi8cWBgXeO
         YoIw==
X-Gm-Message-State: AC+VfDyO7PbQoMu4W/UVBWeO1waZLJHgJyTMwPSIaZM9h1KUWGC9HRDI
	+Nva9FaQgqXx12vB2pfgzHj7FuDyP3jKsb7tyzGkKA==
X-Google-Smtp-Source: ACHHUZ4zwvibGpTcZr6WzThk3ef//DNZJRHzy2x7uE807TapgO6jQJ/nxGgorMEI03PyqlR1CyicAg==
X-Received: by 2002:a05:6a00:1ad1:b0:635:1770:beb7 with SMTP id f17-20020a056a001ad100b006351770beb7mr17408617pfv.14.1683667298038;
        Tue, 09 May 2023 14:21:38 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:37 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 08/11] netem: fix NULL deref on allocation failure
Date: Tue,  9 May 2023 14:21:22 -0700
Message-Id: <20230509212125.15880-9-stephen@networkplumber.org>
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

q_netem.c: In function ‘get_distribution’:
q_netem.c:159:35: warning: dereference of possibly-NULL ‘data’ [CWE-690] [-Wanalyzer-possible-null-dereference]
  159 |                         data[n++] = x;
      |                         ~~~~~~~~~~^~~
  ‘netem_parse_opt’: events 1-24
    |
    |  192 | static int netem_parse_opt(struct qdisc_util *qu, int argc, char **argv,
    |      |            ^~~~~~~~~~~~~~~
    |      |            |
    |      |            (1) entry to ‘netem_parse_opt’
    |......
    |  212 |         for ( ; argc > 0; --argc, ++argv) {
    |      |                 ~~~~~~~~
    |      |                      |
    |      |                      (2) following ‘true’ branch (when ‘argc > 0’)...
    |  213 |                 if (matches(*argv, "limit") == 0) {
    |      |                    ~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                    ||
    |      |                    |(3) ...to here
    |      |                    (4) following ‘true’ branch...
    |......
    |  219 |                 } else if (matches(*argv, "latency") == 0 ||
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||                              |
    |      |                           |(5) ...to here                 (8) following ‘true’ branch...
    |      |                           (6) following ‘true’ branch...
    |  220 |                            matches(*argv, "delay") == 0) {
    |      |                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                            |
    |      |                            (7) ...to here
    |......
    |  243 |                 } else if (matches(*argv, "loss") == 0 ||
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||                           |
    |      |                           |(9) ...to here              (12) following ‘true’ branch...
    |      |                           (10) following ‘true’ branch...
    |  244 |                            matches(*argv, "drop") == 0) {
    |      |                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                            |
    |      |                            (11) ...to here
    |......
    |  366 |                 } else if (matches(*argv, "ecn") == 0) {
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||
    |      |                           |(13) ...to here
    |      |                           (14) following ‘true’ branch...
    |  367 |                         present[TCA_NETEM_ECN] = 1;
    |  368 |                 } else if (matches(*argv, "reorder") == 0) {
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||
    |      |                           |(15) ...to here
    |      |                           (16) following ‘true’ branch...
    |......
    |  383 |                 } else if (matches(*argv, "corrupt") == 0) {
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||
    |      |                           |(17) ...to here
    |      |                           (18) following ‘true’ branch...
    |......
    |  398 |                 } else if (matches(*argv, "gap") == 0) {
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||
    |      |                           |(19) ...to here
    |      |                           (20) following ‘true’ branch...
    |......
    |  404 |                 } else if (matches(*argv, "duplicate") == 0) {
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||
    |      |                           |(21) ...to here
    |      |                           (22) following ‘true’ branch...
    |......
    |  417 |                 } else if (matches(*argv, "distribution") == 0) {
    |      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                           ||
    |      |                           |(23) ...to here
    |      |                           (24) following ‘false’ branch...
    |
  ‘netem_parse_opt’: event 25
    |
    |../include/utils.h:50:29:
    |   50 | #define NEXT_ARG() do { argv++; if (--argc <= 0) incomplete_command(); } while(0)
    |      |                         ~~~~^~
    |      |                             |
    |      |                             (25) ...to here
q_netem.c:418:25: note: in expansion of macro ‘NEXT_ARG’
    |  418 |                         NEXT_ARG();
    |      |                         ^~~~~~~~
    |
  ‘netem_parse_opt’: event 26
    |
    |../include/utils.h:50:36:
    |   50 | #define NEXT_ARG() do { argv++; if (--argc <= 0) incomplete_command(); } while(0)
    |      |                                    ^
    |      |                                    |
    |      |                                    (26) following ‘false’ branch (when ‘argc != 0’)...
q_netem.c:418:25: note: in expansion of macro ‘NEXT_ARG’
    |  418 |                         NEXT_ARG();
    |      |                         ^~~~~~~~
    |
  ‘netem_parse_opt’: events 27-29
    |
    |  419 |                         dist_data = calloc(sizeof(dist_data[0]), MAX_DIST);
    |      |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                                     |
    |      |                                     (27) ...to here
    |      |                                     (28) this call could return NULL
    |  420 |                         dist_size = get_distribution(*argv, dist_data, MAX_DIST);
    |      |                                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                                     |
    |      |                                     (29) calling ‘get_distribution’ from ‘netem_parse_opt’
    |
    +--> ‘get_distribution’: events 30-31
           |
           |  124 | static int get_distribution(const char *type, __s16 *data, int maxdata)
           |      |            ^~~~~~~~~~~~~~~~
           |      |            |
           |      |            (30) entry to ‘get_distribution’
           |......
           |  135 |         if (f == NULL) {
           |      |            ~
           |      |            |
           |      |            (31) following ‘false’ branch (when ‘f’ is non-NULL)...
           |
         ‘get_distribution’: event 32
           |
           |cc1:
           | (32): ...to here
           |
         ‘get_distribution’: events 33-35
           |
           |  142 |         while (getline(&line, &len, f) != -1) {
           |      |                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
           |      |                                        |
           |      |                                        (33) following ‘true’ branch...
           |......
           |  145 |                 if (*line == '\n' || *line == '#')
           |      |                    ~~~~~~
           |      |                    ||
           |      |                    |(34) ...to here
           |      |                    (35) following ‘false’ branch...
           |
         ‘get_distribution’: event 36
           |
           |cc1:
           | (36): ...to here
           |
         ‘get_distribution’: events 37-41
           |
           |  150 |                         if (endp == p)
           |      |                            ^
           |      |                            |
           |      |                            (37) following ‘false’ branch...
           |......
           |  153 |                         if (n >= maxdata) {
           |      |                            ~
           |      |                            |
           |      |                            (38) ...to here
           |      |                            (39) following ‘false’ branch (when ‘n < maxdata’)...
           |......
           |  159 |                         data[n++] = x;
           |      |                         ~~~~~~~~~~~~~
           |      |                               |   |
           |      |                               |   (41) ‘data + (long unsigned int)n * 2’ could be NULL: unchecked value from (28)
           |      |                               (40) ...to here
           |

Fixes: c1b81cb5fe92 ("netem potential dist table overflow")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/q_netem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tc/q_netem.c b/tc/q_netem.c
index 26402e9ad93f..d1d79b0b4d35 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -417,6 +417,9 @@ random_loss_model:
 		} else if (matches(*argv, "distribution") == 0) {
 			NEXT_ARG();
 			dist_data = calloc(sizeof(dist_data[0]), MAX_DIST);
+			if (dist_data == NULL)
+				return -1;
+			
 			dist_size = get_distribution(*argv, dist_data, MAX_DIST);
 			if (dist_size <= 0) {
 				free(dist_data);
-- 
2.39.2


