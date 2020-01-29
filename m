Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D31214D31F
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 23:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgA2Wdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 17:33:53 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54964 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgA2Wdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 17:33:53 -0500
Received: by mail-wm1-f65.google.com with SMTP id g1so1539887wmh.4
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 14:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=9FwLYqxKXGRiqi7Jk1j8mTNta0A/+BTttSZUoM+7jS4=;
        b=K/Z7CkuxG2WHPrasRmJSKBSMRdBTGWK21TUv/iQ07iQfm7qlrZVdQLo/SczQZIwZPI
         YLEQAaueZRE2yws1MxIWDV9JpfMN8MUoMBoBzGOwY9dPcgIT82ilSg6M5Q7PsjE83vx0
         BEWsG4EAIg5gF6kcZr6mnPyX36WrOUQNCgPlgd9H4gnB8eOxqMIPboFw6kqOVRrUKTRm
         kVDx82Np7r8D+/LNJnFjbPX9aCuFjiclyw2gr37Yy9gixpwBp+ninRAhotrUUU45t1ES
         XidjttDBUX/juH0QCTVDD7gXiPNacrWJQy8ACzLlEt3Bx3HcG2gMf+L0/GM1yNYNTIYp
         iXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=9FwLYqxKXGRiqi7Jk1j8mTNta0A/+BTttSZUoM+7jS4=;
        b=CM/5a81ZgvMn3LAmD/v9UYIX5Z4cb+wL9T6BdpJs/YQibBjB8GBH3ArwZWUwtOtrjj
         9KSz4+IOwBnRNrGtYwoKPIoWXbZbiI2+ihQ3dXJim46ktyglqA17RLZL6ZOSo6XYDsWV
         PoOe/0rnk59eTQTazhXlOm3PdwASntSlGr+kQITvt4niDprQwl5YZEdy28Ip+uKytUsS
         wleu2xkpvWaFw+nNQmhO2rZ+ghHGROMkP8ETNkNIwz3ib2YgFEJFXIFvX0l5a++EDP9H
         2Xq/1hF1utA/7HPHed18CSlUuq3OERP9TZ0SdU9TnVajmQSwsYS7+gcwGeA4fWAah9Ko
         /aTw==
X-Gm-Message-State: APjAAAVANVBvcFgcUrHrvkh0C3UZnmNEgcaxLGQhL87oIeTOviFbaZHj
        LDDWFbAD4aDpv79UneCtBpc=
X-Google-Smtp-Source: APXvYqx8R0uVLCD1elWboqfYYPwI6ubNQXnvPVB+UhaS8C2p6zlR/EXULFRioelZM19RNI8m++mi6Q==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr1384122wma.87.1580337231457;
        Wed, 29 Jan 2020 14:33:51 -0800 (PST)
Received: from peto-laptopnovy (46.229.228.5.host.vnet.sk. [46.229.228.5])
        by smtp.gmail.com with ESMTPSA id i11sm4683844wrs.10.2020.01.29.14.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 14:33:50 -0800 (PST)
Date:   Wed, 29 Jan 2020 23:33:48 +0100
From:   Peter Junos <petoju@gmail.com>
To:     stephen@networkplumber.org
Cc:     petoju@gmail.com, dsahern@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net] ss: fix tests to reflect compact output
Message-ID: <20200129223348.GA49265@peto-laptopnovy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129061619.76283217@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes broken tests in commit c4f5862994589 ("ss: use compact output 
for undetected screen width")

It also escapes stars as grep is used and more bugs could sneak under
the radar with the previous solution.

Signed-off-by: Peter Junos <petoju@gmail.com>
---
 testsuite/tests/ss/ssfilter.t | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/testsuite/tests/ss/ssfilter.t b/testsuite/tests/ss/ssfilter.t
index 3091054f..4c2315ca 100755
--- a/testsuite/tests/ss/ssfilter.t
+++ b/testsuite/tests/ss/ssfilter.t
@@ -12,37 +12,37 @@ export TCPDIAG_FILE="$(dirname $0)/ss1.dump"
 ts_log "[Testing ssfilter]"
 
 ts_ss "$0" "Match dport = 22" -Htna dport = 22
-test_on "ESTAB     0           0                10.0.0.1:36266           10.0.0.1:22"
+test_on "ESTAB 0      0      10.0.0.1:36266 10.0.0.1:22"
 
 ts_ss "$0" "Match dport 22" -Htna dport 22
-test_on "ESTAB     0           0                10.0.0.1:36266           10.0.0.1:22"
+test_on "ESTAB 0      0      10.0.0.1:36266 10.0.0.1:22"
 
 ts_ss "$0" "Match (dport)" -Htna '( dport = 22 )'
-test_on "ESTAB     0           0                10.0.0.1:36266           10.0.0.1:22"
+test_on "ESTAB 0      0      10.0.0.1:36266 10.0.0.1:22"
 
 ts_ss "$0" "Match src = 0.0.0.0" -Htna src = 0.0.0.0
-test_on "LISTEN      0           128               0.0.0.0:22             0.0.0.0:*"
+test_on "LISTEN 0      128    0.0.0.0:22 0.0.0.0:\*"
 
 ts_ss "$0" "Match src 0.0.0.0" -Htna src 0.0.0.0
-test_on "LISTEN      0           128               0.0.0.0:22             0.0.0.0:*"
+test_on "LISTEN 0      128    0.0.0.0:22 0.0.0.0:\*"
 
 ts_ss "$0" "Match src sport" -Htna src 0.0.0.0 sport = 22
-test_on "LISTEN      0           128               0.0.0.0:22             0.0.0.0:*"
+test_on "LISTEN 0      128    0.0.0.0:22 0.0.0.0:\*"
 
 ts_ss "$0" "Match src and sport" -Htna src 0.0.0.0 and sport = 22
-test_on "LISTEN      0           128               0.0.0.0:22             0.0.0.0:*"
+test_on "LISTEN 0      128    0.0.0.0:22 0.0.0.0:\*"
 
 ts_ss "$0" "Match src and sport and dport" -Htna src 10.0.0.1 and sport = 22 and dport = 50312
-test_on "ESTAB     0           0                10.0.0.1:22           10.0.0.2:50312"
+test_on "ESTAB 0      0      10.0.0.1:22 10.0.0.2:50312"
 
 ts_ss "$0" "Match src and sport and (dport)" -Htna 'src 10.0.0.1 and sport = 22 and ( dport = 50312 )'
-test_on "ESTAB     0           0                10.0.0.1:22           10.0.0.2:50312"
+test_on "ESTAB 0      0      10.0.0.1:22 10.0.0.2:50312"
 
 ts_ss "$0" "Match src and (sport and dport)" -Htna 'src 10.0.0.1 and ( sport = 22 and dport = 50312 )'
-test_on "ESTAB     0           0                10.0.0.1:22           10.0.0.2:50312"
+test_on "ESTAB 0      0      10.0.0.1:22 10.0.0.2:50312"
 
 ts_ss "$0" "Match (src and sport) and dport" -Htna '( src 10.0.0.1 and sport = 22 ) and dport = 50312'
-test_on "ESTAB     0           0                10.0.0.1:22           10.0.0.2:50312"
+test_on "ESTAB 0      0      10.0.0.1:22 10.0.0.2:50312"
 
 ts_ss "$0" "Match (src or src) and dst" -Htna '( src 0.0.0.0 or src 10.0.0.1 ) and dst 10.0.0.2'
-test_on "ESTAB     0           0                10.0.0.1:22           10.0.0.2:50312"
+test_on "ESTAB 0      0      10.0.0.1:22 10.0.0.2:50312"
-- 
2.24.0

