Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637291B62D6
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgDWR7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729991AbgDWR7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:59:13 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE7FC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:59:12 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z90so5601391qtd.10
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ARq+GYrKwOxiZmL3xV66/R3POy4C4cacRxWfDlDtoE0=;
        b=VM9XtHKIRzz4VIEBP2VqUF6snWj15qJA637pbfgalF9bphPj/jlmdHaaInGwsDut8q
         /tNIWgRmP3Vgq2UqpijehHE1pjvF9Ntm3RJ1MgNB/PeRSqz0tRTN17H1Lda5oMMjaeop
         rny9YzmETk4NSJ3/3EncHr7UzI8RUKIDLTMe4lWF4eZzaufeRH99bYACijwAEO1Z7VUb
         B/MELqtGokxO7UvfdTaBAuuuVf5zeqNdKRFW9vlUkEPTd76egvH+C/tj4HGhSt+paISv
         ejP/xK7o4c+VhSQFp2ROXeip4Zl+tUW5lM88AMZJFDf1LCInhKovwrZUR48wqBhGBgLV
         SGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ARq+GYrKwOxiZmL3xV66/R3POy4C4cacRxWfDlDtoE0=;
        b=p+8hWgPdP/JnmybzAV3pvqWs2JAxlRGqIWHeM9pVPDFniEhg7ja+QmmeHkHBkMFSoG
         bHDgLl/KbdPqQzOEFS9kFnY/3lJITDGEoIWQ7MBAK67X9vGI+QMlPZGfF8h8jlqK6xHw
         Ler6IwsSfvjsxJdyQVo9RWEYuCaxxPGJ6cor3bZn2PkXZc6IJJ2bU3VdIHCKnQeLhjme
         NPmN1/imWwHZECLot5j0C6iLhrNY8mh1scQIThglIf/Q1x2wiq0b6cUkiU2umv2SroK1
         zCtS9ij3z4udytvfCowUv4zUB9MduLzvmG4opWI5EXX3ty8F/JFfijFtgffkSHZscjJn
         C5/Q==
X-Gm-Message-State: AGi0PuYMz5hBCR7un4XCibV5V/bla4m2aj12Odp+8qnqL4bCDTcA4Iwj
        yvL8Y2zC1JuP/JYWzDRfyQq+IQ==
X-Google-Smtp-Source: APiQypIAFdF6yiKZ4SlBEXGYF1NbWb9NLLPWChLx4nzIpYeCA0JHukjXwgb6kq/T2nMjvHW+1s+gGg==
X-Received: by 2002:ac8:4253:: with SMTP id r19mr5417436qtm.116.1587664752150;
        Thu, 23 Apr 2020 10:59:12 -0700 (PDT)
Received: from mojaone.lan (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.gmail.com with ESMTPSA id 205sm2003040qkj.1.2020.04.23.10.59.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 10:59:11 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 v3 0/2] bpf: memory access fixes
Date:   Thu, 23 Apr 2020 13:58:55 -0400
Message-Id: <20200423175857.20180-1-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <jhs@mojatatu.com>

Changes from V2:
 1) Dont initialize tmp on stack (Stephen)
 2) Dont look at the return code of snprintf (Dominique)
 3) Set errno to EINVAL instead of returning -EINVAL for consistency (Dominique)

Changes from V1:
 1) use snprintf instead of sprintf and fix corresponding error message.
 Caught-by: Dominique Martinet <asmadeus@codewreck.org>
 2) Fix memory leak and extraneous free() in error path

Jamal Hadi Salim (2):
  bpf: Fix segfault when custom pinning is used
  bpf: Fix mem leak and extraneous free() in error path

 lib/bpf.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

-- 
2.20.1

