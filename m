Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8172A7C38
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgKEKvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:51:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55479 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgKEKvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:51:41 -0500
Received: from mail-pg1-f199.google.com ([209.85.215.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kacri-0001bq-S8
        for netdev@vger.kernel.org; Thu, 05 Nov 2020 10:51:39 +0000
Received: by mail-pg1-f199.google.com with SMTP id q4so1006618pgk.13
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 02:51:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ucULeTLjP6GOC7ulykS2yzYXoLzwUi9LCJDnywesUs=;
        b=Ed3DrC/azi7qgX4X247O0FbVXhHGhCDSS/gdH5/o0wGmtlGizsNVBEowS3vNwaA551
         ANuGtyzww7gaYpfNV0FOtkaYuwz/lie0PbIfgNSkrxJ4V1M9KGXdninHkJdPQdeH/+BM
         LGDLX9DhxvVs180qwluYe8PxO/kXSkm2YcaIKH9tIwugZjYRt7GJ381LdhEDlPt0pSBV
         Aue30BdVyih+D8m1Dq1qwXooTVMKEs4MDG02cxLhlyl6MHkJ04b04KU0YmNTXgzWMwiZ
         m9WEUHzb+uQ01lRYCgHAuKQp4/JMiOt48YvoaDQ3g/xQp4tyhw0H3h5S+oEeLLXzHD2f
         ZvZA==
X-Gm-Message-State: AOAM532SZ8sWYWp9RXRuqI3JqGqojr+vc0b6v8m/KWmew4ZHQuf8lKKh
        FO8EcEv04jtBWGEVA883RV79fwcjcTaPUhAtl9cfJsGyuo6Wvgnf6RWPsQpHh9oHN41ocrqytzy
        4X6a1Zt2wt7Ra3DEdtx/p92QrSlfconYE
X-Received: by 2002:a17:902:690b:b029:d6:41d8:bdc7 with SMTP id j11-20020a170902690bb02900d641d8bdc7mr1705425plk.7.1604573497163;
        Thu, 05 Nov 2020 02:51:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwIl/S+AFKw+LnFNifIIHNzk7bmd7XgmkzcB0SlAFrCe6TT9vEqkRh3DGSqDxSaQkpk9TzTFQ==
X-Received: by 2002:a17:902:690b:b029:d6:41d8:bdc7 with SMTP id j11-20020a170902690bb02900d641d8bdc7mr1705406plk.7.1604573496884;
        Thu, 05 Nov 2020 02:51:36 -0800 (PST)
Received: from localhost.localdomain ([2001:67c:1560:8007::aac:c227])
        by smtp.gmail.com with ESMTPSA id c3sm1866852pjv.27.2020.11.05.02.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:51:36 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, skhan@linuxfoundation.org,
        po-hsu.lin@canonical.com
Subject: [PATCH 0/2] selftests: pmtu.sh: improve the test result processing
Date:   Thu,  5 Nov 2020 18:50:49 +0800
Message-Id: <20201105105051.64258-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pmtu.sh test script treats all non-zero return code as a failure,
thus it will be marked as FAILED when some sub-test got skipped.

This patchset will:
  1. Use the kselftest framework skip code $ksft_skip to replace the
     hardcoded SKIP return code.
  2. Improve the result processing, the test will be marked as PASSED
     if nothing goes wrong and not all the tests were skipped.

Po-Hsu Lin (2):
  selftests: pmtu.sh: use $ksft_skip for skipped return code
  selftests: pmtu.sh: improve the test result processing

 tools/testing/selftests/net/pmtu.sh | 83 ++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 33 deletions(-)

-- 
2.7.4

