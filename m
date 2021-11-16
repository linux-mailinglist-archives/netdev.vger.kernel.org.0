Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46B4453A34
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbhKPTfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhKPTf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 14:35:26 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6055AC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 11:32:29 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f18so339903lfv.6
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 11:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=lO4/FTpiksfAtA9KoP5nMIREYHjkmxCmNjcfKV2yLik=;
        b=dNpZf1PtV6fFDEuMEKtVkZwvS1DZDjamTsIs7r9SKK7Xw4QZacYm1GB9qGKEFrf/kU
         OJFFl1C0sDqecYxjVZkfpsh0URj3n7UFSDJHm1TgFoOPdEnHhZJmgG1iLxWd9SjGkN+Y
         aQjS4M4U3cOqJ7ecWzQF7R09GS1wkjJmtENOg5PTqQVkC9T20UoavCmr+eEnIgNvoyXK
         DzdQkd5nurj6+t4uNZirAruuh9RViD+toxRM7Fi+bW95XJnKYminQSx9u9QBF5LQEulK
         EX0N+/IaL0orgTewTwHahHMszwycLYWEJpqcKqiILODi1QdxBWueqlwTPRUBJ19oHe2x
         P7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=lO4/FTpiksfAtA9KoP5nMIREYHjkmxCmNjcfKV2yLik=;
        b=RBVY5aSOrgjHu1wEjGl+y/awggnu+x0rQrBE1nhulelD+GqetxPGzc8vf93Y3to7dg
         3XqvtbfXMYap0ntnmeVQMDzRu9XC8RCCeU/ra+pn1reA2dWP1WNA7AKCv9wOdYLhBArN
         dfrzGl/CF24l0MFG9cOPJkidkApj/ciE4YfFO/DeG6uURKiO+ZQf+JI16P9f0nX3UsYk
         KB2N2DUui7fdcX+5U+kCftheWB3f/vRi6pAKAh8A1Ie4ST/yE8+3woMka4W6m/MV45Hq
         WmqtVf3AC+Wwax5nqDV201F5JxYJM6TUlXrS1foSRENJM29pbXofrv4kSCPHRmhL4WMC
         ZwBA==
X-Gm-Message-State: AOAM532en3/u4JcUYgSI2JqpMOh6pMRe+r6aOAcVHbhFwuL6oqM8Okvm
        HguBm5if09jUaTO5Ss8TbVmjgBCQCYM=
X-Google-Smtp-Source: ABdhPJzMtQDUevl/WLQSX3X3YftsWJhoODVkL1o0yPnswKLMbzmIZfexQkVg/mnjisAXPCxArWoXLw==
X-Received: by 2002:a05:6512:33d4:: with SMTP id d20mr9032663lfg.664.1637091147802;
        Tue, 16 Nov 2021 11:32:27 -0800 (PST)
Received: from [192.168.88.200] ([178.71.193.198])
        by smtp.gmail.com with ESMTPSA id d18sm1822072lfl.30.2021.11.16.11.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 11:32:27 -0800 (PST)
To:     netdev@vger.kernel.org, stephen@networkplumber.org
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Subject: [PATCH iproute2] lib/bpf_legacy: remove always-true check
Message-ID: <0d278a59-f512-cce3-7c56-e3572da100c9@gmail.com>
Date:   Tue, 16 Nov 2021 22:32:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'name' field of the 'struct bpf_prog_info' is a plain C array. Thus, the
logical condition in bpf_dump_prog_info() is useless as the array address is
always true, so just remove it.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
 lib/bpf_legacy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 3bf08a09..6e3891c9 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -203,9 +203,7 @@ int bpf_dump_prog_info(FILE *f, uint32_t id)
 	if (!ret && len) {
 		int jited = !!info.jited_prog_len;
 
-		if (info.name)
-			print_string(PRINT_ANY, "name", "name %s ", info.name);
-
+		print_string(PRINT_ANY, "name", "name %s ", info.name);
 		print_string(PRINT_ANY, "tag", "tag %s ",
 			     hexstring_n2a(info.tag, sizeof(info.tag),
 					   tmp, sizeof(tmp)));
-- 
2.25.1
