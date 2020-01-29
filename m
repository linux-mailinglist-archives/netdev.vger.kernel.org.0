Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158B514D2EF
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 23:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgA2WSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 17:18:34 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:38627 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgA2WSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 17:18:34 -0500
Received: by mail-wm1-f53.google.com with SMTP id a9so1788210wmj.3
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 14:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=OlTorTdUmgJN8IxK7i3AS2zJs6rioQMgbclTI7pellc=;
        b=FtZcylepwJKMDZvYc0zLPYNcJyd3TdtahTzsDNAn8ncYWc6AWL/OLuqXDmIYgoFE/F
         Hwxrh+nEP+mpCVC21saCF/6PIoUzJdHPrUcVaOTV7b/NNn9JxWvfm0iTv62K7F3Fp5IS
         PKsVNg/tt80hb0dDkddQD80R5oW/ydAeBU0980cE++WUTFaRnx5wvyLKe8ixHV7q6qyH
         QIVDKv9LuUfgV5E6Ee38Lr/ZuGaYLw6LYMmjN67uQQ/O5gDIpNuFLn95Q4+STnn9LfDk
         +FhliQQlTeJa0+AzOX52ZFhBb7kMR/TjVmRyBCVXgzQty5r58/79Hpc7Ok8nW6HQHirT
         aqjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=OlTorTdUmgJN8IxK7i3AS2zJs6rioQMgbclTI7pellc=;
        b=b0nWz4Uk1YWqT1mtqVkvD/juBs1b53MqdU3xbvVABTpKIuys+TCCBlnGEdqvVYurwz
         tK+BIJoqNxbLWzhmhLEIHv9cbBTQjoBu9lpv+cbwAX5R+Igr1lTrfWFCURHV3YKdBfbL
         Dhx++KVereqgZxSP6dKHXoC3vB4xzLdsDs3xb3my22Gt/FXDHFSsPMgKD9VsJH8eCe+4
         flIaiaQbB8WaLAU0VCTaUFlbfLbVHoz+CDXHqUqPT3mocpQv6+wzLnw9KwadHaHcqB1h
         RB/dJy72b4GWu9RVPGERuqqlCeKsKigQg+JRcA62UZy1A2uj0XaRdloFxIWiKvrU0vHR
         9KEg==
X-Gm-Message-State: APjAAAX3F6kNFSqi/2dA2AmoMU2ECDgiNXVWgPlZzfGyytqJWVUYCBC3
        ZWElgha2II3xUstzBQ4sXTgh6KoJGiY=
X-Google-Smtp-Source: APXvYqyX2dCvkJ/m146AlxpVCRbmF0B/d65QA0WdB1E6qRwGSjhdePMhTP7RHLkwAZ9IbKPt3QLahw==
X-Received: by 2002:a1c:6588:: with SMTP id z130mr1366690wmb.0.1580336311586;
        Wed, 29 Jan 2020 14:18:31 -0800 (PST)
Received: from peto-laptopnovy (46.229.228.5.host.vnet.sk. [46.229.228.5])
        by smtp.gmail.com with ESMTPSA id t131sm3944018wmb.13.2020.01.29.14.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 14:18:31 -0800 (PST)
Date:   Wed, 29 Jan 2020 23:18:21 +0100
From:   Peter =?utf-8?B?SsO6bm/FoQ==?= <petoju@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org
Cc:     dsahern@gmail.com, petoju@gmail.com
Subject: [PATCH net-next] ss: fix tests to reflect compact output
Message-ID: <20200129221821.GA47050@peto-laptopnovy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129061619.76283217@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes broken tests in c4f58629945898722ad9078e0f407c96f1ec7d2b

It also escapes stars as grep is used and more bugs could sneak under
the radar with the previous solution.
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

