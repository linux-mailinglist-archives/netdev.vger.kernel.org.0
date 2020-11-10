Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47B42ACAD1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgKJCBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:01:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42877 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgKJCBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 21:01:14 -0500
Received: from mail-pl1-f198.google.com ([209.85.214.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kcIy8-0001sQ-H4
        for netdev@vger.kernel.org; Tue, 10 Nov 2020 02:01:12 +0000
Received: by mail-pl1-f198.google.com with SMTP id m8so5442474plt.7
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 18:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RK2xra2umGqFG+SzI89RLBjV289wxSEZaa8bAGmNZH8=;
        b=FdjXky2Ra/iEaFb5ijO3EvdM1jKcs3VMkkn2zNvaRFsyzVHNAaSr+ZJ/VhGVPai64m
         DDbgYv2BJxecxp+eUovnPj+bEJyHUN78OR1EIlQfIY2QD5iH7p+HDJg3/6bR4MyeAAtP
         Ozw7XfSva1qrktHJCPLu8vL7GaFtXjrCuU7mlGEziZzx19JARb31J8WywNTAi+qAzkmt
         s+Q+84SfjVI16zQi3aSo7E81o60oi89kJyT3fx6iGHG/4nvTdZl1N/M3sAuVoMe7AR6P
         ywLlpq3CXAc4hwBec0AnHEgywgX/kGNR49biRTITrzcPQJokci+vrAEtDEPF25Rcf+8o
         8iCA==
X-Gm-Message-State: AOAM5315VEGk3E65eORpBHnQaWO6MSB7m8HIMNRQqX2Qss1Z2nv4+Ptz
        iIbwJ34H+8LYNUKE0ca3e2vkdtgH2OFZqXPQW7z8VojcshMXf5RlXQ7Cn82f+BNGU4SUTjzv5eE
        C27fz68xLWezCGdq4AYpgaMAIvUKdxVgC
X-Received: by 2002:a63:4006:: with SMTP id n6mr14920445pga.171.1604973670943;
        Mon, 09 Nov 2020 18:01:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxY3UB2LhbbRYn8No1bJ7jZB3fD3rnenjheE0iTW1dlEQcjHFmUi1r5RbodJAJDhdcKbtmrEg==
X-Received: by 2002:a63:4006:: with SMTP id n6mr14920420pga.171.1604973670597;
        Mon, 09 Nov 2020 18:01:10 -0800 (PST)
Received: from localhost.localdomain (223-136-189-104.emome-ip.hinet.net. [223.136.189.104])
        by smtp.gmail.com with ESMTPSA id c193sm11855552pfb.78.2020.11.09.18.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 18:01:09 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Cc:     davem@davemloft.net, skhan@linuxfoundation.org,
        po-hsu.lin@canonical.com
Subject: [PATCHv2 0/2] selftests: pmtu.sh: improve the test result processing
Date:   Tue, 10 Nov 2020 10:00:47 +0800
Message-Id: <20201110020049.6705-1-po-hsu.lin@canonical.com>
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

 tools/testing/selftests/net/pmtu.sh | 79 +++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 33 deletions(-)

-- 
2.7.4

