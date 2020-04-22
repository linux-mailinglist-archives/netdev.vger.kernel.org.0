Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C491B3EBD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 12:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgDVKbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 06:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730996AbgDVK21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 06:28:27 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33234C03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 03:28:27 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id t3so1830573qkg.1
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 03:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLVnDdq2mKVm2PZsjOUW8AMYEuqdrLPHJgplBbgaWjQ=;
        b=Pno0wxPO9RQfeDWQlhRprCFjDs5PhDV8vfIGQavxLkx/VgMqGwNKRx1C1m1bW8fvYO
         CasvmIRDkIeds8hH0FSIgjKzKEHUE+tUZbJi4N14+Dq6wSZzofZrYhE4pE2wld+H7kBb
         BxkfHGAUz64bv065b9TbgGGdoTt8vDdQCWb45UnoPCIzCMsZUH3AE6v6AIxt6eML3L0y
         uei+m2S1nu186+JlIpAn/bEUp8wzm6ghJy0l7LP4ZLpmBSNhs8euDV2o2I+lbW8g+4Xy
         lXBWAWTA7wXJieH/BWGo738Stw5+/aWZbvMh/I2q0salXKjoAd5WcCHbvc3z3hvd6e99
         OiLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLVnDdq2mKVm2PZsjOUW8AMYEuqdrLPHJgplBbgaWjQ=;
        b=s/3TC7Chq+FzylvTwFPlwYzL94ozsTCs8xfnDCHK1U4mr3H6txx0KH9Cea0gFnuCbq
         22KK70IKxQPwN+yLJ2e3E4LQJc/rCwJq6eiJ/JKpvGUSpZbtfQY3Dc6qsmqsM+QhBK/l
         WOjRb83VvWXW8wppFmNhlcMGh7f1A+0igPFvrC1Wr+v52nR77GJVoGh08XqN0vawWIK3
         Ir981FYm+lmxj5YmbAb7FEtNdnUYuppQPhRirAwdbCpj5rBxCIQaqB+LvMvBBIPPtKlt
         YoicZa4puBfcXjjl4nTZt0o6wk3n20rCuqmZAVOwRfESWTBCMD7muh4U434A4xwZlJIs
         y5WQ==
X-Gm-Message-State: AGi0PubqscqFA5tUjBBduTv/HEWxRf+GuLLdpkyEgf4NjMPiQMYTiDFs
        ugCNrmF5v0JBjIKnZ43Pt0TP0w==
X-Google-Smtp-Source: APiQypJc8oiUJ5wG+4rzhnQUchuIEECKyrWFN/xpVxsIyWmncXyMjRKsVGwpYF2P1RJ+NsClrraZIw==
X-Received: by 2002:a05:620a:49e:: with SMTP id 30mr4489216qkr.294.1587551306435;
        Wed, 22 Apr 2020 03:28:26 -0700 (PDT)
Received: from localhost.localdomain (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.gmail.com with ESMTPSA id h3sm3531964qkf.15.2020.04.22.03.28.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 03:28:25 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <hadi@mojatatu.com>
Subject: [PATCH iproute2 v2 0/2] bpf: memory access fixes
Date:   Wed, 22 Apr 2020 06:28:06 -0400
Message-Id: <20200422102808.9197-1-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <hadi@mojatatu.com>

Changes from V1:
 1) use snprintf instead of sprintf and fix corresponding error message.
 Caught-by: Dominique Martinet <asmadeus@codewreck.org>
 2) Fix memory leak and extraneous free() in error path

Jamal Hadi Salim (2):
  bpf: Fix segfault when custom pinning is used
  bpf: Fix mem leak and extraneous free() in error path

 lib/bpf.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
2.20.1

