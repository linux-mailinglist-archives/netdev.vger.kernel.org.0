Return-Path: <netdev+bounces-1258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EEB6FD11C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8DE328130B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5838F1993B;
	Tue,  9 May 2023 21:23:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4231719933
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:04 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B3DD2FF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:44 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-643bb9cdd6eso3976873b3a.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667293; x=1686259293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycXfe3kBqmm2tf9gpohySSc0Cel6lk/s2F5OjMdAV5c=;
        b=pax9Y1Z9EjpU7/CfHl1Lrdmi66hL3x4vvdjLzN2nB/kq0lQB2DVHfJUbOxpMguBD7a
         Fx+R+oCBZ1uCvUcyUsmPuYRhVFZ3Obg0MCT0izHeEUep5wDeiNXy/10H6WrTybhwSw12
         np02RqY5Jb1r5mJyRwxuIlMmkWkiS2h+URe+u0vb2u+AA0PaHP6aFlsYVgQHyOIklHy8
         md9z0J9A7PCr/cM212DG2lnfn9ezqK8k1g1W1YCyzYkX2dwOEQIW+eepWUjwmLtLVrsR
         IfQhK5+3UT60XV2CZLAsmXyQ/MTdZmR2vAmVfCPyVWFqt/DWRcOF8hpxSTkEWvkFumHp
         pViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667293; x=1686259293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ycXfe3kBqmm2tf9gpohySSc0Cel6lk/s2F5OjMdAV5c=;
        b=Co9EqzqDvsPGJAsMXK/CRue1cuqQEVR6snoTxXXeR0uQoHgxOSEm0lT/FshVwZW9sp
         j5OFMfhsYtpha14GfvaSbDuhtwXgjPSE6oV16BgUYDek9sA+7IAHB9hS5i1mKHJur7yY
         C3xtrN9DYcbmdPprXQD4OEYWCwKCiQEV54khIFZ1JBZEdZwnHG7qRo+Zk1/Bp24Jmh+Q
         4g7NkcLT1ggFgUdavJOdnR769p+Q1Il4hnznlr7FwB2G1faPMfbBZkqOMyRPDUn2qi80
         y3rY0VwPkfdRrqQh1ETGoj+dxSby2vqGWncwuPC/dPQJj0zHNoLV1n0QaVc1i5Cw3+dH
         6qGg==
X-Gm-Message-State: AC+VfDz0S6W+5yDJu2FM0sdskxKt0lzx+C20dg2bYRnPQG4WxeOizaoL
	9i0HHQuEOaE1zmKsUr0VK4KTqmD7F85YUMj8TWsWEw==
X-Google-Smtp-Source: ACHHUZ742ybShdU5ez3eGjQPnA6x03n3cCMK9fK7mCxnLZ4VvWnuwggn8OELObxOgpOHT8MnBnEYTQ==
X-Received: by 2002:a05:6a00:188d:b0:636:f899:46a0 with SMTP id x13-20020a056a00188d00b00636f89946a0mr20858232pfh.15.1683667293441;
        Tue, 09 May 2023 14:21:33 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:32 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 04/11] tc_filter: fix unitialized warning
Date: Tue,  9 May 2023 14:21:18 -0700
Message-Id: <20230509212125.15880-5-stephen@networkplumber.org>
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

When run with -fanalyzer.

tc_filter.c: In function ‘tc_filter_list’:
tc_filter.c:718:17: warning: use of uninitialized value ‘chain_index’ [CWE-457] [-Wanalyzer-use-of-uninitialized-value]
  718 |                 addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ‘do_chain’: events 1-4
    |
    |  772 | int do_chain(int argc, char **argv)
    |      |     ^~~~~~~~
    |      |     |
    |      |     (1) entry to ‘do_chain’
    |  773 | {
    |  774 |         if (argc < 1)
    |      |            ~
    |      |            |
    |      |            (2) following ‘true’ branch (when ‘argc <= 0’)...
    |  775 |                 return tc_filter_list(RTM_GETCHAIN, 0, NULL);
    |      |                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                        |
    |      |                        (3) ...to here
    |      |                        (4) calling ‘tc_filter_list’ from ‘do_chain’
    |
    +--> ‘tc_filter_list’: events 5-8
           |
           |  582 | static int tc_filter_list(int cmd, int argc, char **argv)
           |      |            ^~~~~~~~~~~~~~
           |      |            |
           |      |            (5) entry to ‘tc_filter_list’
           |......
           |  597 |         __u32 chain_index;
           |      |               ~~~~~~~~~~~
           |      |               |
           |      |               (6) region created on stack here
           |      |               (7) capacity: 4 bytes
           |......
           |  601 |         while (argc > 0) {
           |      |                ~~~~~~~~
           |      |                     |
           |      |                     (8) following ‘false’ branch (when ‘argc <= 0’)...
           |
         ‘tc_filter_list’: event 9
           |
           |../include/uapi/linux/pkt_sched.h:72:35:
           |   72 | #define TC_H_MAKE(maj,min) (((maj)&TC_H_MAJ_MASK)|((min)&TC_H_MIN_MASK))
           |      |                             ~~~~~~^~~~~~~~~~~~~~~
           |      |                                   |
           |      |                                   (9) ...to here
tc_filter.c:698:26: note: in expansion of macro ‘TC_H_MAKE’
           |  698 |         req.t.tcm_info = TC_H_MAKE(prio<<16, protocol);
           |      |                          ^~~~~~~~~
           |
         ‘tc_filter_list’: events 10-16
           |
           |  702 |         if (d[0]) {
           |      |            ^
           |      |            |
           |      |            (10) following ‘false’ branch...
           |......
           |  707 |         } else if (block_index) {
           |      |                   ~~~~~~~~~~~~
           |      |                   ||
           |      |                   |(11) ...to here
           |      |                   (12) following ‘false’ branch...
           |......
           |  717 |         if (filter_chain_index_set)
           |      |            ~~~~~~~~~~~~~~~~~~~~~~~
           |      |            ||
           |      |            |(13) ...to here
           |      |            (14) following ‘true’ branch...
           |  718 |                 addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
           |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |                 |
           |      |                 (15) ...to here
           |      |                 (16) use of uninitialized value ‘chain_index’ here
           |
tc_filter.c:718:17: warning: use of uninitialized value ‘chain_index’ [CWE-457] [-Wanalyzer-use-of-uninitialized-value]
  718 |                 addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ‘do_filter’: events 1-4
    |
    |  744 | int do_filter(int argc, char **argv)
    |      |     ^~~~~~~~~
    |      |     |
    |      |     (1) entry to ‘do_filter’
    |  745 | {
    |  746 |         if (argc < 1)
    |      |            ~
    |      |            |
    |      |            (2) following ‘true’ branch (when ‘argc <= 0’)...
    |  747 |                 return tc_filter_list(RTM_GETTFILTER, 0, NULL);
    |      |                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                        |
    |      |                        (3) ...to here
    |      |                        (4) calling ‘tc_filter_list’ from ‘do_filter’
    |
    +--> ‘tc_filter_list’: events 5-8
           |
           |  582 | static int tc_filter_list(int cmd, int argc, char **argv)
           |      |            ^~~~~~~~~~~~~~
           |      |            |
           |      |            (5) entry to ‘tc_filter_list’
           |......
           |  597 |         __u32 chain_index;
           |      |               ~~~~~~~~~~~
           |      |               |
           |      |               (6) region created on stack here
           |      |               (7) capacity: 4 bytes
           |......
           |  601 |         while (argc > 0) {
           |      |                ~~~~~~~~
           |      |                     |
           |      |                     (8) following ‘false’ branch (when ‘argc <= 0’)...
           |
         ‘tc_filter_list’: event 9
           |
           |../include/uapi/linux/pkt_sched.h:72:35:
           |   72 | #define TC_H_MAKE(maj,min) (((maj)&TC_H_MAJ_MASK)|((min)&TC_H_MIN_MASK))
           |      |                             ~~~~~~^~~~~~~~~~~~~~~
           |      |                                   |
           |      |                                   (9) ...to here
tc_filter.c:698:26: note: in expansion of macro ‘TC_H_MAKE’
           |  698 |         req.t.tcm_info = TC_H_MAKE(prio<<16, protocol);
           |      |                          ^~~~~~~~~
           |
         ‘tc_filter_list’: events 10-16
           |
           |  702 |         if (d[0]) {
           |      |            ^
           |      |            |
           |      |            (10) following ‘false’ branch...
           |......
           |  707 |         } else if (block_index) {
           |      |                   ~~~~~~~~~~~~
           |      |                   ||
           |      |                   |(11) ...to here
           |      |                   (12) following ‘false’ branch...
           |......
           |  717 |         if (filter_chain_index_set)
           |      |            ~~~~~~~~~~~~~~~~~~~~~~~
           |      |            ||
           |      |            |(13) ...to here
           |      |            (14) following ‘true’ branch...
           |  718 |                 addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
           |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |                 |
           |      |                 (15) ...to here
           |      |                 (16) use of uninitialized value ‘chain_index’ here
           |

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_filter.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index 700a09f62882..a1203c73738a 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -70,7 +70,7 @@ static int tc_filter_modify(int cmd, unsigned int flags, int argc, char **argv)
 	__u32 protocol = 0;
 	int protocol_set = 0;
 	__u32 block_index = 0;
-	__u32 chain_index;
+	__u32 chain_index = 0;
 	int chain_index_set = 0;
 	char *fhandle = NULL;
 	char  d[IFNAMSIZ] = {};
@@ -594,7 +594,6 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 	char d[IFNAMSIZ] = {};
 	__u32 prio = 0;
 	__u32 protocol = 0;
-	__u32 chain_index;
 	__u32 block_index = 0;
 	char *fhandle = NULL;
 
@@ -676,6 +675,8 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 			protocol = res;
 			filter_protocol = protocol;
 		} else if (matches(*argv, "chain") == 0) {
+			__u32 chain_index;
+
 			NEXT_ARG();
 			if (filter_chain_index_set)
 				duparg("chain", *argv);
@@ -715,7 +716,7 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 	}
 
 	if (filter_chain_index_set)
-		addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
+		addattr32(&req.n, sizeof(req), TCA_CHAIN, filter_chain_index);
 
 	if (brief) {
 		struct nla_bitfield32 flags = {
-- 
2.39.2


