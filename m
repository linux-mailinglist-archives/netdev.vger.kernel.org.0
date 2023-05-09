Return-Path: <netdev+bounces-1261-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C546FD13F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B16DE280F09
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0089C182C8;
	Tue,  9 May 2023 21:23:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA44D18C05
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:07 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD4B3C0C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:49 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6434e65d808so6780533b3a.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667297; x=1686259297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SyABgZ6kkWDM9JoBrAo/EnkL9KnbMq4g/Z4xY3yM2ZQ=;
        b=pX/z4o+5XnX25k5I3bZ18pMe1sMGxVUDHGW8CxilPyjK9AjGxC6VPV/hm/HxbveS+S
         4SPJUXvcfhP6B7Fr5Ona+gFg2HhMk16Y/D+nQrnrolEvTveFoJQujdfsFtlGKG5NrDXc
         jqLnc2UJ/rBXDudX0Zv8tHQ9ztcavd9Y/4f25KYjKZi2eI450sleJX/FbVzzUdsnmDCF
         R2tUBgHPcWOr+gCEENdrFvreWgxURe84rIxlK9KAImvu2s/PQoQuIkpXjdmJQPThNrol
         tPvu6NX3Pj8i1y+Nsc3Pb5kSZOpeuq2Qx4Qk3Ub9tdlLRMx4ilS6IRpU1/FrvmiS3iM6
         QIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667297; x=1686259297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SyABgZ6kkWDM9JoBrAo/EnkL9KnbMq4g/Z4xY3yM2ZQ=;
        b=aVIBMp3y+hITvC8vqKLAqriEYaf9sml7SJ+TkPdmZFr8c600+5Qx98L2NSrfkqd/ks
         x1ukAryf2B06JWOzqAmCyYq1qcGVk8j6h4OVs1RrnqgveHgFg6ROTZZQAX+xbvEmaEOR
         RVQii99sRMVOsjkZfc1Ps6AZXFJgw9a8LFmYXJ7eISA5V7/ey811gb+Sn4sWZmTlrJvW
         Pf0nwzgq0S4GAK7czG8Y8vMMDI1SLLXip/xvt2UddeOU3wM2rQGhwrY0x5aoEjuPiR8J
         5E833+X0svR0wjrJOv6k3c+2BjjQ1C8Dao2C6lmrUJq2qa68PmXVB8jkrwtox9Oafy46
         sITw==
X-Gm-Message-State: AC+VfDzZChY90C1ByZ2CN1CyonWnoz7J5MA7sf+BxCCGVVckJqkr9kYI
	okQxfSVyG2gsP5Uqb3kxTobjXYLnZcgz/bMZL54t8Q==
X-Google-Smtp-Source: ACHHUZ7ROC4EefvRI/FBEYFu8VTeasgV7dBendfU2De5jrRvP7wmS0afsJPQttlIKNcwkMGfQgx5dQ==
X-Received: by 2002:a05:6a00:2189:b0:63d:4446:18ab with SMTP id h9-20020a056a00218900b0063d444618abmr18803912pfi.23.1683667297161;
        Tue, 09 May 2023 14:21:37 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:36 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 07/11] m_action: fix warning of overwrite of const string
Date: Tue,  9 May 2023 14:21:21 -0700
Message-Id: <20230509212125.15880-8-stephen@networkplumber.org>
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

The function get_action_kind() searches first for the given
action, then rescans on failure for "gact". In the process,
it would overwrite the argument.  Avoid the warning
by using a const argument and not copying.

The problem dates back to pre-git history.

m_action.c: In function ‘get_action_kind’:
m_action.c:126:17: warning: write to string literal [-Wanalyzer-write-to-string-literal]
  126 |                 strcpy(str, "gact");
      |                 ^~~~~~~~~~~~~~~~~~~
  ‘do_action’: events 1-6
    |
    |  853 | int do_action(int argc, char **argv)
    |      |     ^~~~~~~~~
    |      |     |
    |      |     (1) entry to ‘do_action’
    |......
    |  858 |         while (argc > 0) {
    |      |                ~~~~~~~~
    |      |                     |
    |      |                     (2) following ‘true’ branch...
    |  859 |
    |  860 |                 if (matches(*argv, "add") == 0) {
    |      |                    ~~~~~~~~~~~~~~~~~~~~~~
    |      |                    ||
    |      |                    |(3) ...to here
    |      |                    (4) following ‘false’ branch...
    |  861 |                         ret =  tc_action_modify(RTM_NEWACTION,
    |      |                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                                |
    |      |                                (5) ...to here
    |      |                                (6) calling ‘tc_action_modify’ from ‘do_action’
    |  862 |                                                 NLM_F_EXCL | NLM_F_CREATE,
    |      |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
    |  863 |                                                 &argc, &argv);
    |      |                                                 ~~~~~~~~~~~~~
    |
    +--> ‘tc_action_modify’: events 7-8
           |
           |  715 | static int tc_action_modify(int cmd, unsigned int flags,
           |      |            ^~~~~~~~~~~~~~~~
           |      |            |
           |      |            (7) entry to ‘tc_action_modify’
           |......
           |  735 |         if (parse_action(&argc, &argv, TCA_ACT_TAB, &req.n)) {
           |      |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |             |
           |      |             (8) calling ‘parse_action’ from ‘tc_action_modify’
           |
           +--> ‘parse_action’: events 9-18
                  |
                  |  203 | int parse_action(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n)
                  |      |     ^~~~~~~~~~~~
                  |      |     |
                  |      |     (9) entry to ‘parse_action’
                  |......
                  |  217 |         if (argc <= 0)
                  |      |            ~
                  |      |            |
                  |      |            (10) following ‘false’ branch...
                  |......
                  |  220 |         tail2 = addattr_nest(n, MAX_MSG, tca_id);
                  |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                 |
                  |      |                 (11) ...to here
                  |  221 |
                  |  222 |         while (argc > 0) {
                  |      |                ~~~~~~~~
                  |      |                     |
                  |      |                     (12) following ‘true’ branch...
                  |  223 |
                  |  224 |                 memset(k, 0, sizeof(k));
                  |      |                 ~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                 |
                  |      |                 (13) ...to here
                  |  225 |
                  |  226 |                 if (strcmp(*argv, "action") == 0) {
                  |      |                    ~
                  |      |                    |
                  |      |                    (14) following ‘true’ branch (when the strings are equal)...
                  |  227 |                         argc--;
                  |      |                         ~~~~~~
                  |      |                             |
                  |      |                             (15) ...to here
                  |......
                  |  231 |                         if (!gact_ld)
                  |      |                            ~
                  |      |                            |
                  |      |                            (16) following ‘true’ branch...
                  |  232 |                                 get_action_kind("gact");
                  |      |                                 ~~~~~~~~~~~~~~~~~~~~~~~
                  |      |                                 |
                  |      |                                 (17) ...to here
                  |      |                                 (18) calling ‘get_action_kind’ from ‘parse_action’
                  |
                  +--> ‘get_action_kind’: events 19-24
                         |
                         |   86 | static struct action_util *get_action_kind(char *str)
                         |      |                            ^~~~~~~~~~~~~~~
                         |      |                            |
                         |      |                            (19) entry to ‘get_action_kind’
                         |......
                         |  114 |         if (a == NULL)
                         |      |            ~
                         |      |            |
                         |      |            (20) following ‘true’ branch (when ‘a’ is NULL)...
                         |  115 |                 goto noexist;
                         |      |                 ~~~~
                         |      |                 |
                         |      |                 (21) ...to here
                         |......
                         |  124 |         if (!looked4gact) {
                         |      |            ~
                         |      |            |
                         |      |            (22) following ‘true’ branch (when ‘looked4gact == 0’)...
                         |  125 |                 looked4gact = 1;
                         |  126 |                 strcpy(str, "gact");
                         |      |                 ~~~~~~~~~~~~~~~~~~~
                         |      |                 |
                         |      |                 (23) ...to here
                         |      |                 (24) write to string literal here
                         |

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/m_action.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index a446cabdb98c..16474c56118c 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -83,7 +83,7 @@ static int parse_noaopt(struct action_util *au, int *argc_p,
 	return -1;
 }
 
-static struct action_util *get_action_kind(char *str)
+static struct action_util *get_action_kind(const char *str)
 {
 	static void *aBODY;
 	void *dlh;
@@ -123,7 +123,7 @@ noexist:
 #ifdef CONFIG_GACT
 	if (!looked4gact) {
 		looked4gact = 1;
-		strcpy(str, "gact");
+		str = "gact";
 		goto restart_s;
 	}
 #endif
-- 
2.39.2


