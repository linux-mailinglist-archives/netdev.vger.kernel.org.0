Return-Path: <netdev+bounces-1262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 601DA6FD143
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:24:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 376CF280C08
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6F018C12;
	Tue,  9 May 2023 21:23:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA49218C06
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:07 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE73DC6C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-643a6f993a7so3584805b3a.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667301; x=1686259301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAdljhZYUlbL6KX8+mnPa3LtJZLNNXTdCvCHKlgV7GM=;
        b=yGBx996Kt4B0ajVlYRA1uIA6ReX3c9Isi2zVC7PK8IxmN6pPL3AOIPvIBdOuuLCp2S
         Wtbtbkk4L9nsDaKk4BpfN9h2RadSt7r4KgLM6eAdPKhNyMT1OvReZlZsuinIXF9tLav6
         QE7eLEFxsOHuvzpaCa01SmVk0ZwCMT5/9zh6ZG5nuMkudQmp/Y8NlmamAfr8yBccx4BH
         M8xHZtuSX3xO3ZoJqHNC4Nk0iIV/I7QZoMVgaifdD6ugBrQYhdRhWnj2q5sKYX9tGXL2
         4lhyqZSTvFnwl1za/GW5dzzweKCcT3CPYOsMU8XlCWzzQh6CAxmBXQ2Dty14ka3SWwj/
         6SLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667301; x=1686259301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAdljhZYUlbL6KX8+mnPa3LtJZLNNXTdCvCHKlgV7GM=;
        b=ji48WQCyoUllVszxpkryh3Ezm7YGsmXfHMo8mlCG/HufqOP92FheyUAEeuOU/zanFX
         OpDp8Ki6Sj96R4sx3GWfZuznOmj4NvIst9sdtoiwWj8gG31XlSE0VeyqCRdnGrRxyayT
         KShIyJjMjcG8hrA04AdTUXcoy8fR9OJ8AwqNJtObZFkuo+yI3s0arGug9viiZVTLkTTL
         nqDsWMJ/1UCc+ykw2GcTHud7g03hrydiIkRMrpXG7hZGT0KyT6+A9P/1NEMoa7LAb95g
         gq/vckylJB2BeaTilOSlJb+nv7CW1KhQdre3dlt5vBv7Z2qKCcXuHYT9TH2wwjAzc7pn
         1Q8g==
X-Gm-Message-State: AC+VfDxMEjFIa/D1UVkFomev8Xh1ZYVntFY62CiGKgl1WFS4acjqcx42
	poKMqQFm0+1tiJMSwaBRiKSbZkocaYF70hYaN4sIPQ==
X-Google-Smtp-Source: ACHHUZ6CH3kTwq/CGTcdUnNftN0rtQoJOij+CkDXpTLSc9ylyftuZCsKbwlxlU2iOhjE+NNt53gQzw==
X-Received: by 2002:a05:6a00:1492:b0:63b:6149:7ad6 with SMTP id v18-20020a056a00149200b0063b61497ad6mr20601249pfu.34.1683667301478;
        Tue, 09 May 2023 14:21:41 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:41 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 11/11] tc/prio: handle possible truncated kernel response
Date: Tue,  9 May 2023 14:21:25 -0700
Message-Id: <20230509212125.15880-12-stephen@networkplumber.org>
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

Reported by -fanalyzer. If kernel did not send full qdisc
info, then uninitialized or null data could be referenced.

q_prio.c: In function ‘prio_print_opt’:
q_prio.c:105:57: warning: dereference of NULL ‘0’ [CWE-476] [-Wanalyzer-null-dereference]
  105 |         print_uint(PRINT_ANY, "bands", "bands %u ", qopt->bands);
      |                                                     ~~~~^~~~~~~
  ‘prio_print_opt’: event 1
    |
    |   98 |         if (opt == NULL)
    |      |            ^
    |      |            |
    |      |            (1) following ‘false’ branch (when ‘opt’ is non-NULL)...
    |
  ‘prio_print_opt’: event 2
    |
    |../include/uapi/linux/rtnetlink.h:228:38:
    |  228 | #define RTA_PAYLOAD(rta) ((int)((rta)->rta_len) - RTA_LENGTH(0))
    |      |                                ~~~~~~^~~~~~~~~~
    |      |                                      |
    |      |                                      (2) ...to here
../include/libnetlink.h:236:19: note: in expansion of macro ‘RTA_PAYLOAD’
    |  236 |         ({ data = RTA_PAYLOAD(rta) >= len ? RTA_DATA(rta) : NULL;       \
    |      |                   ^~~~~~~~~~~
q_prio.c:101:13: note: in expansion of macro ‘parse_rtattr_nested_compat’
    |  101 |         if (parse_rtattr_nested_compat(tb, TCA_PRIO_MAX, opt, qopt,
    |      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
    |
  ‘prio_print_opt’: event 3
    |
    |../include/libnetlink.h:236:59:
    |  236 |         ({ data = RTA_PAYLOAD(rta) >= len ? RTA_DATA(rta) : NULL;       \
q_prio.c:101:13: note: in expansion of macro ‘parse_rtattr_nested_compat’
    |  101 |         if (parse_rtattr_nested_compat(tb, TCA_PRIO_MAX, opt, qopt,
    |      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
    |
  ‘prio_print_opt’: events 4-5
    |
    |  105 |         print_uint(PRINT_ANY, "bands", "bands %u ", qopt->bands);
    |      |                                                     ~~~~^~~~~~~
    |      |                                                         |
    |      |                                                         (4) ...to here
    |      |                                                         (5) dereference of NULL ‘<unknown>’
    |

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/q_prio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tc/q_prio.c b/tc/q_prio.c
index c8c6477e1a98..a3781ffe8b2c 100644
--- a/tc/q_prio.c
+++ b/tc/q_prio.c
@@ -101,6 +101,8 @@ int prio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (parse_rtattr_nested_compat(tb, TCA_PRIO_MAX, opt, qopt,
 					sizeof(*qopt)))
 		return -1;
+	if (qopt == NULL)
+		return -1;	/* missing data from kernel */
 
 	print_uint(PRINT_ANY, "bands", "bands %u ", qopt->bands);
 	open_json_array(PRINT_ANY, "priomap");
-- 
2.39.2


