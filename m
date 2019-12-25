Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F7012A8FA
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfLYTE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:26 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:43754 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:25 -0500
Received: by mail-pg1-f172.google.com with SMTP id k197so11890045pga.10
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vk4TxrenJB0UI/jaB6QOpaRDajVbyg1tXQjCjN7gbuE=;
        b=srLvAtteF0xJPJQLTqCUU3uAcdZbAsCUCU+RBifnrzz/0lkAztx91difpINd1MN7vi
         NE7rlwhKRbt++xa64dn4qV2fuxuV3HyWCmVbVHRYs348yBtbjCyGpSsOStGcxLuWBVh4
         y1mNTi5s/3PFOwFQORaG7RC/a145NkyXULhdvahV5FPDB5rOt6SU1avhEQAD4XbmBzE7
         HdFWuOCW4XnjqWepC+xTWV1wLQMVRD3aH0Bq315LJSKKfYUZj5bCiAYCC6V45FlFRwxd
         jlMjkMqjKruBqetjv5esz6K34JzvSjTh63wgzfPvzo/Dm1zQW4X2LOLys9MfOZ9drm5R
         b0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vk4TxrenJB0UI/jaB6QOpaRDajVbyg1tXQjCjN7gbuE=;
        b=YynO/V6gQ0KIOjQgU/sbZcXcjil7kAJBCleofsXEatSdb3raUkkUkwgqtpGtPu9IH5
         tcnlQIz7BTMRkRwtwZj1ZtV/4eFHkewx5m9tmtUukg5bxXC2Gu98VD3MaGfLhbKEQaey
         1xgUiggKz6WbtJ3eYIPMgLh0ArwEVgWW5uSc3bh5IJHqVbvsHY+Z3CvChrE9dCgTQ2LN
         gCH5ktCkFnsZZ9hwqOSGHkNtHiYBRMcjwun5CviOXH5Yi/K9mQBKD0kG/pCy3DiSDBRY
         bDOm4rHc78lvcOEFIaDrmJibfO1mdwZxyYnMmbFavHdtBR2h2EFQSpqJQYATGRXoyEfm
         DQEA==
X-Gm-Message-State: APjAAAU4hl7eFyYZ6fpQ0E3FSxcTU2GZ2bl7ckmOaD/3Iprb73JCOjQY
        BYKsb9kS7QED/Sf90HetLSFClFI7CeA=
X-Google-Smtp-Source: APXvYqzoiYTvCmHttzOarh23JmhbE1KlN8hOhkztZWh2VQ357ITahO29sHPIfjLTgNuhHRmdQsqW5g==
X-Received: by 2002:aa7:8d8f:: with SMTP id i15mr16321477pfr.220.1577300664739;
        Wed, 25 Dec 2019 11:04:24 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:24 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 00/10] tc: add support for JSON output in some qdiscs
Date:   Thu, 26 Dec 2019 00:34:08 +0530
Message-Id: <20191225190418.8806-1-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several qdiscs do not yet support the JSON output format. This patch series
adds the missing compatibility to 9 classless qdiscs. Some of the patches
also improve the oneline output of the qdiscs. The last patch in the series
fixes a missing statistic in the JSON output of fq_codel.

Leslie Monis (10):
  tc: cbs: add support for JSON output
  tc: choke: add support for JSON output
  tc: codel: add support for JSON output
  tc: fq: add support for JSON output
  tc: hhf: add support for JSON output
  tc: pie: add support for JSON output
  tc: sfb: add support for JSON output
  tc: sfq: add support for JSON output
  tc: tbf: add support for JSON output
  tc: fq_codel: fix missing statistic in JSON output

 man/man8/tc-fq.8  |  14 +++---
 man/man8/tc-pie.8 |  16 +++----
 tc/q_cbs.c        |  10 ++---
 tc/q_choke.c      |  26 +++++++----
 tc/q_codel.c      |  45 +++++++++++++------
 tc/q_fq.c         | 108 ++++++++++++++++++++++++++++++++--------------
 tc/q_fq_codel.c   |   4 +-
 tc/q_hhf.c        |  33 +++++++++-----
 tc/q_pie.c        |  47 ++++++++++++--------
 tc/q_sfb.c        |  67 ++++++++++++++++++----------
 tc/q_sfq.c        |  66 +++++++++++++++++-----------
 tc/q_tbf.c        |  68 ++++++++++++++++++++---------
 12 files changed, 335 insertions(+), 169 deletions(-)

-- 
2.17.1

