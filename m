Return-Path: <netdev+bounces-1260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 581236FD13C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 588341C20944
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1C418C01;
	Tue,  9 May 2023 21:23:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2BF182DB
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:07 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A54D2E1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64115eef620so45606495b3a.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667295; x=1686259295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGAQF6ZyT4RZ3bVmBNWGKTuWkFpmHEXY2H7+E4jYjss=;
        b=jI7Q/WsVsYyawNxhaz9xobTX+OShOmpdUuGvTyKIyVbAAxSP8LXp/EhrMqCzikysZ4
         E+ASGZz9jIS1opzufPMaqBEf2HieaXjfXr4dHTff0mr4OD6HIV9fyrIBBoRer3ViUmDu
         Ezbe+D1fDYL5sH30oLXBXZ4QQha472VEBx/hxaqlTq3sVc90LCZZhgN/Br+zeQHJea+i
         J6q9q97JLPmbt2E0FCLDSwNZoG/1UvUG0QN838G27FRymxVHBs1TmmNhb7TbDCZtJk4i
         4Gw/GsovdDKpEUrv2m2g4EBnjDdN7/OUEIS67DzPnSw9V1FQP0UczqxqYSeihCYLhdp2
         vabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667295; x=1686259295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wGAQF6ZyT4RZ3bVmBNWGKTuWkFpmHEXY2H7+E4jYjss=;
        b=Cm0CHuMsCpuODRL4BfeQdGqlTzoxoRXBxq2Sr6rihYk+sppLEUhcRd7xUT4XoYjBlE
         DSKUKFx3wwOdU95OHzUBIy0J6FgJpy7yVG0hXzlY1nOUZQMkpMj4sLI0vtVxW2p8gXVj
         Af3vtnZOEyQh25e4MU7BwF6RX+hd16/+MYGT7aLSbb2ftHv5bB0uL7petnk5/qrN+hU4
         C27TlHSpTCwipuHloBycIeqf2nS8+cI/MZmymdVcBSQQ7Sd3H1qoeh3ITO0ohr3s/WrY
         E0tXpr37d8xw+iXCN7b/ONlOWOoLxWLOolf1WXT9Js2+kbIm6jR+ceQU14iDSHqiy/I/
         yyhg==
X-Gm-Message-State: AC+VfDxrkprudDxmHFGAe/CHLUwnc0/YdcUkBY9xj8GItmPRCT5BfGXJ
	vr8v0uvBXzXd0zeEWF0F/faIxF29yJ0Pi0fHqwHzng==
X-Google-Smtp-Source: ACHHUZ7y4mUM5rasm+aDaBVtxL34h6c6HBi97cHR5bP5l38/lgX7ozkMr3AoF0uDo9rXdGj2WzOgeQ==
X-Received: by 2002:a05:6a20:441c:b0:101:6908:2b03 with SMTP id ce28-20020a056a20441c00b0010169082b03mr3414236pzb.25.1683667295182;
        Tue, 09 May 2023 14:21:35 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:34 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 05/11] tc_util fix unitialized warning
Date: Tue,  9 May 2023 14:21:19 -0700
Message-Id: <20230509212125.15880-6-stephen@networkplumber.org>
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

tc_util.c: In function ‘parse_action_control_slash_spaces’:
tc_util.c:488:28: warning: use of uninitialized value ‘result2’ [CWE-457] [-Wanalyzer-use-of-uninitialized-value]
  488 |                 *result2_p = result2;
      |                 ~~~~~~~~~~~^~~~~~~~~
  ‘parse_action_control_slash_spaces’: events 1-5
    |
    |  455 | static int parse_action_control_slash_spaces(int *argc_p, char ***argv_p,
    |      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |            |
    |      |            (1) entry to ‘parse_action_control_slash_spaces’
    |......
    |  461 |         int result1 = -1, result2;
    |      |                           ~~~~~~~
    |      |                           |
    |      |                           (2) region created on stack here
    |      |                           (3) capacity: 4 bytes
    |......
    |  467 |                 switch (ok) {
    |      |                 ~~~~~~
    |      |                 |
    |      |                 (4) following ‘case 0:’ branch...
    |......
    |  475 |                         ret = parse_action_control(&argc, &argv,
    |      |                               ~
    |      |                               |
    |      |                               (5) inlined call to ‘parse_action_control’ from ‘parse_action_control_slash_spaces’
    |
    +--> ‘parse_action_control’: events 6-7
           |
           |  432 |         return __parse_action_control(argc_p, argv_p, result_p,
           |      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |                |
           |      |                (6) ...to here
           |      |                (7) calling ‘__parse_action_control’ from ‘parse_action_control_slash_spaces’
           |  433 |                                       allow_num, false);
           |      |                                       ~~~~~~~~~~~~~~~~~
           |
         ‘__parse_action_control’: events 8-11
           |
           |  371 | static int __parse_action_control(int *argc_p, char ***argv_p, int *result_p,
           |      |            ^~~~~~~~~~~~~~~~~~~~~~
           |      |            |
           |      |            (8) entry to ‘__parse_action_control’
           |......
           |  378 |         if (!argc)
           |      |            ~
           |      |            |
           |      |            (9) following ‘false’ branch (when ‘argc != 0’)...
           |  379 |                 return -1;
           |  380 |         if (action_a2n(*argv, &result, allow_num) == -1) {
           |      |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |             |
           |      |             (10) ...to here
           |      |             (11) calling ‘action_a2n’ from ‘__parse_action_control’
           |
           +--> ‘action_a2n’: events 12-16
                  |
                  |  335 | int action_a2n(char *arg, int *result, bool allow_num)
                  |      |     ^~~~~~~~~~
                  |      |     |
                  |      |     (12) entry to ‘action_a2n’
                  |......
                  |  356 |         for (iter = a2n; iter->a; iter++) {
                  |      |                          ~~~~
                  |      |                          |
                  |      |                          (13) following ‘true’ branch...
                  |  357 |                 if (matches(arg, iter->a) != 0)
                  |      |                     ~~~~~~~~~~~~~~~~~~~~~
                  |      |                     |
                  |      |                     (14) ...to here
                  |......
                  |  366 |         if (result)
                  |      |            ~
                  |      |            |
                  |      |            (15) following ‘true’ branch (when ‘result’ is non-NULL)...
                  |  367 |                 *result = n;
                  |      |                 ~~~~~~~~~~~
                  |      |                         |
                  |      |                         (16) ...to here
                  |
           <------+
           |
         ‘__parse_action_control’: event 17
           |
           |  380 |         if (action_a2n(*argv, &result, allow_num) == -1) {
           |      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |             |
           |      |             (17) returning to ‘__parse_action_control’ from ‘action_a2n’
           |
    <------+
    |
  ‘parse_action_control_slash_spaces’: event 18
    |
    |  475 |                         ret = parse_action_control(&argc, &argv,
    |      |                               ^
    |      |                               |
    |      |                               (18) inlined call to ‘parse_action_control’ from ‘parse_action_control_slash_spaces’
    |
    +--> ‘parse_action_control’: event 19
           |
           |  432 |         return __parse_action_control(argc_p, argv_p, result_p,
           |      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |                |
           |      |                (19) returning to ‘parse_action_control_slash_spaces’ from ‘__parse_action_control’
           |  433 |                                       allow_num, false);
           |      |                                       ~~~~~~~~~~~~~~~~~
           |
    <------+
    |
  ‘parse_action_control_slash_spaces’: events 20-24
    |
    |  477 |                         if (ret)
    |      |                            ^
    |      |                            |
    |      |                            (20) following ‘false’ branch...
    |  478 |                                 return ret;
    |  479 |                         ok++;
    |      |                         ~~~~
    |      |                           |
    |      |                           (21) ...to here
    |......
    |  487 |         if (ok == 2)
    |      |            ~
    |      |            |
    |      |            (22) following ‘true’ branch (when ‘ok == 2’)...
    |  488 |                 *result2_p = result2;
    |      |                 ~~~~~~~~~~~~~~~~~~~~
    |      |                            |
    |      |                            (23) ...to here
    |      |                            (24) use of uninitialized value ‘result2’ here
    |
tc_util.c:488:28: warning: use of uninitialized value ‘result2’ [CWE-457] [-Wanalyzer-use-of-uninitialized-value]
  488 |                 *result2_p = result2;
      |                 ~~~~~~~~~~~^~~~~~~~~
  ‘parse_action_control_slash’: events 1-5
    |
    |  505 | int parse_action_control_slash(int *argc_p, char ***argv_p,
    |      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |     |
    |      |     (1) entry to ‘parse_action_control_slash’
    |......
    |  510 |         char *p = strchr(*argv, '/');
    |      |                   ~~~~~~~~~~~~~~~~~~
    |      |                   |
    |      |                   (2) when ‘strchr’ returns NULL
    |  511 |
    |  512 |         if (!p)
    |      |            ~
    |      |            |
    |      |            (3) following ‘true’ branch (when ‘p’ is NULL)...
    |  513 |                 return parse_action_control_slash_spaces(argc_p, argv_p,
    |      |                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                        |
    |      |                        (4) ...to here
    |      |                        (5) calling ‘parse_action_control_slash_spaces’ from ‘parse_action_control_slash’
    |  514 |                                                          result1_p, result2_p,
    |      |                                                          ~~~~~~~~~~~~~~~~~~~~~
    |  515 |                                                          allow_num);
    |      |                                                          ~~~~~~~~~~
    |
    +--> ‘parse_action_control_slash_spaces’: events 6-10
           |
           |  455 | static int parse_action_control_slash_spaces(int *argc_p, char ***argv_p,
           |      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |            |
           |      |            (6) entry to ‘parse_action_control_slash_spaces’
           |......
           |  461 |         int result1 = -1, result2;
           |      |                           ~~~~~~~
           |      |                           |
           |      |                           (7) region created on stack here
           |      |                           (8) capacity: 4 bytes
           |......
           |  467 |                 switch (ok) {
           |      |                 ~~~~~~
           |      |                 |
           |      |                 (9) following ‘case 0:’ branch...
           |......
           |  475 |                         ret = parse_action_control(&argc, &argv,
           |      |                               ~
           |      |                               |
           |      |                               (10) inlined call to ‘parse_action_control’ from ‘parse_action_control_slash_spaces’
           |
           +--> ‘parse_action_control’: events 11-12
                  |
                  |  432 |         return __parse_action_control(argc_p, argv_p, result_p,
                  |      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                |
                  |      |                (11) ...to here
                  |      |                (12) calling ‘__parse_action_control’ from ‘parse_action_control_slash_spaces’
                  |  433 |                                       allow_num, false);
                  |      |                                       ~~~~~~~~~~~~~~~~~
                  |
                ‘__parse_action_control’: events 13-16
                  |
                  |  371 | static int __parse_action_control(int *argc_p, char ***argv_p, int *result_p,
                  |      |            ^~~~~~~~~~~~~~~~~~~~~~
                  |      |            |
                  |      |            (13) entry to ‘__parse_action_control’
                  |......
                  |  378 |         if (!argc)
                  |      |            ~
                  |      |            |
                  |      |            (14) following ‘false’ branch (when ‘argc != 0’)...
                  |  379 |                 return -1;
                  |  380 |         if (action_a2n(*argv, &result, allow_num) == -1) {
                  |      |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |             |
                  |      |             (15) ...to here
                  |      |             (16) calling ‘action_a2n’ from ‘__parse_action_control’
                  |
                  +--> ‘action_a2n’: events 17-21
                         |
                         |  335 | int action_a2n(char *arg, int *result, bool allow_num)
                         |      |     ^~~~~~~~~~
                         |      |     |
                         |      |     (17) entry to ‘action_a2n’
                         |......
                         |  356 |         for (iter = a2n; iter->a; iter++) {
                         |      |                          ~~~~
                         |      |                          |
                         |      |                          (18) following ‘true’ branch...
                         |  357 |                 if (matches(arg, iter->a) != 0)
                         |      |                     ~~~~~~~~~~~~~~~~~~~~~
                         |      |                     |
                         |      |                     (19) ...to here
                         |......
                         |  366 |         if (result)
                         |      |            ~
                         |      |            |
                         |      |            (20) following ‘true’ branch (when ‘result’ is non-NULL)...
                         |  367 |                 *result = n;
                         |      |                 ~~~~~~~~~~~
                         |      |                         |
                         |      |                         (21) ...to here
                         |
                  <------+
                  |
                ‘__parse_action_control’: event 22
                  |
                  |  380 |         if (action_a2n(*argv, &result, allow_num) == -1) {
                  |      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |             |
                  |      |             (22) returning to ‘__parse_action_control’ from ‘action_a2n’
                  |
           <------+
           |
         ‘parse_action_control_slash_spaces’: event 23
           |
           |  475 |                         ret = parse_action_control(&argc, &argv,
           |      |                               ^
           |      |                               |
           |      |                               (23) inlined call to ‘parse_action_control’ from ‘parse_action_control_slash_spaces’
           |
           +--> ‘parse_action_control’: event 24
                  |
                  |  432 |         return __parse_action_control(argc_p, argv_p, result_p,
                  |      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                |
                  |      |                (24) returning to ‘parse_action_control_slash_spaces’ from ‘__parse_action_control’
                  |  433 |                                       allow_num, false);
                  |      |                                       ~~~~~~~~~~~~~~~~~
                  |
           <------+
           |
         ‘parse_action_control_slash_spaces’: events 25-29
           |
           |  477 |                         if (ret)
           |      |                            ^
           |      |                            |
           |      |                            (25) following ‘false’ branch...
           |  478 |                                 return ret;
           |  479 |                         ok++;
           |      |                         ~~~~
           |      |                           |
           |      |                           (26) ...to here
           |......
           |  487 |         if (ok == 2)
           |      |            ~
           |      |            |
           |      |            (27) following ‘true’ branch (when ‘ok == 2’)...
           |  488 |                 *result2_p = result2;
           |      |                 ~~~~~~~~~~~~~~~~~~~~
           |      |                            |
           |      |                            (28) ...to here
           |      |                            (29) use of uninitialized value ‘result2’ here
           |

Fixes: e67aba559581 ("tc: actions: add helpers to parse and print control actions")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 0714134eb548..ed9efa70cabd 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -458,7 +458,7 @@ static int parse_action_control_slash_spaces(int *argc_p, char ***argv_p,
 {
 	int argc = *argc_p;
 	char **argv = *argv_p;
-	int result1 = -1, result2;
+	int result1 = -1, result2 = -1;
 	int *result_p = &result1;
 	int ok = 0;
 	int ret;
-- 
2.39.2


