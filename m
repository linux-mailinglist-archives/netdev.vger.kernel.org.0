Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48758F0846
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbfKEV0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:26:24 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36943 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfKEV0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:26:23 -0500
Received: by mail-lf1-f68.google.com with SMTP id b20so16275110lfp.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cZ26JBQIoBY23DV5k8hGYoWb47mlUdnTspjgecIa5wM=;
        b=APbKFtMQ2SHX2pQB4bKVAr4twXh8SRMMbyg6ODxWkz8PtOWx5RQFkO63wBrgv9IVzl
         kVae3DT6U0PQm0qU+ktzkFH6ml1p+b5rW6ApswD/GpPwpyf9yhRZRtXT1y6hftyjMBr4
         6boIDlDGTd1DIOnriGrwR0eyqF5Oi0hDn3aOBPMdAFvQ5Dydkyo/JOslAWt8Zu7qpHqZ
         +cwekU4Afzrb8ks3Zi5U4Ibs7k1I4FUx5xB+GRYwDwNeTo166j8hgeapDj97gEf5H3ch
         GxlFzeocyNlv/OJzrhSBVLg2pSfllB1cj/wzTa6WdjQotbFKkUSoDX9tL3rshCbM2MHP
         QO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cZ26JBQIoBY23DV5k8hGYoWb47mlUdnTspjgecIa5wM=;
        b=XVh0wt7b/OZHh9y3nMaZa1v9sEAHvZ018QEYx/izXqjfIneyQvDc1l1YCWpjVt7q+o
         M7Bkpqa4CXVEFjYmyKs657zOmUdyKAp9ijUDdtEMSKh4fMYIXCE0N0zjJIZVJHIlrQKZ
         RScnI+nXgaUVp/SfAyrnnnRwfp0QtLgJYwvu12AW675EE1EE1Hx3lHXuVfU5dWNhQ3Dp
         X8I4s+HVGgiD3tTNthPqtjZbplUSWpQKWcxZvD1KIwJT1zXFhr+0AWQo4+Q9Rng7NjaD
         JaD/j/OfUqR5UvCaqvrqeY23ntHBlWFpWj04+V29yZXBrOQEQSVKaZPR+jY178hVLvM0
         gUSA==
X-Gm-Message-State: APjAAAX2XiwKLPPYrL8FyNi/IFsb92LxRtpySWY2uCrVM8/DBYAr3tmu
        bcD4Ep/K/xAzqxjUylvBiHrwOA==
X-Google-Smtp-Source: APXvYqylxhFAzKo//+Fkt9rlH+XugzmXeA06ti4A6Z+DX20sEdZLUpFHOOmJT/LsVg73DO1AI5Cy2Q==
X-Received: by 2002:a19:ac48:: with SMTP id r8mr23112074lfc.181.1572989182070;
        Tue, 05 Nov 2019 13:26:22 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v1sm9319601lji.89.2019.11.05.13.26.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:26:20 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/2] netdevsim: fix tests and netdevsim
Date:   Tue,  5 Nov 2019 13:26:10 -0800
Message-Id: <20191105212612.10737-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The first patch fixes a merge which brought back some dead
code. Next a tiny re-write of the main test using netdevsim
aims to ease debugging.

Jakub Kicinski (2):
  netdevsim: drop code duplicated by a merge
  selftests: bpf: log direct file writes

 drivers/net/netdevsim/dev.c                 | 47 ++++-----------------
 tools/testing/selftests/bpf/test_offload.py | 20 ++++++---
 2 files changed, 22 insertions(+), 45 deletions(-)

-- 
2.23.0

