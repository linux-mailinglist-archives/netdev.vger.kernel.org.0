Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BDF6A4A1C
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjB0Sp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjB0SpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:45:25 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9F91CF67
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:45:20 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-172afa7bee2so8397188fac.6
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ByzdAbn5omZ94wnFIqkAJnsSPXdLHwwRWgKaeGpJrE4=;
        b=VfHyT/j63lwNb9gudV0Hxz0yGRukOXxTM5fye+XieeDc01dpUcsSclWYyyZx0V/TJS
         +V/QO7I4ttftMnPoBd0uVqs22LAR5Ha1B7tUypLihcD6vJ3WeIUL+uZK8ovu4dCTcjNT
         hqjQVQgjvg4z5nHTStOpT4jAlZ/QyDiQLLj+unmX7/l7icDSQ0gUDUFLivjIzOnUyMxK
         1MX5Xa3QANbYmDZrrTVlu+a2w4aI8dd326BmSMQie/VF0alVR5oK0rW2Hh3jfTvkKa6x
         hA9HffJiJ1mSRcD04WBtLbGlH/UEepgguygbuFJqlFS/IOXW6p38oL5NLZ2Y67NW8cMu
         znxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ByzdAbn5omZ94wnFIqkAJnsSPXdLHwwRWgKaeGpJrE4=;
        b=s6IOSPW6Ds+1Cyhq3pJQsvhG9QdyR88P0NVTeF0gJf05M3WppEWHKump0v0mzqeBG3
         mfCgkxydf2xCdJjjvbyLT/j/oMgGAQClFpCtj/XLNbSlnQRSl4CBJ4ybKJg+cwluWqvJ
         0Isp9QjVBJwXw6i0xmBNN1IGr8rvennxPwNHYffti4ZRH0zmgthGzmRPgVyUTrJlwYCc
         +0XfXnQ0wwFXuKKAdShYLKxQcFfBDaMlEgimHo7hvOFPqMEYYxHwdNz0xcuD7fL+iKO9
         nXEMNXClx0CXbv4pJGdJ0NIDeR6kMChWs5edxyBUiZFvgdVDzDXTGZWS/GQe6kstftXv
         O/Tw==
X-Gm-Message-State: AO0yUKWpchljTLaG+X9hmRcNyxxkzoMnE7UncUEw6tazzeORbf0EgvgP
        +e662nsKT3kff5rSFHnR5v0kU4YRr1KtcZ4O
X-Google-Smtp-Source: AK7set/t4xX++nY7l/vN+ZQ8PT/v1krvVfulpjXGfT0ZpLd1mr0nISLDzbTJAzZ7r2feHaiceP/4UA==
X-Received: by 2002:a05:6870:b609:b0:16e:72e1:7152 with SMTP id cm9-20020a056870b60900b0016e72e17152mr20815914oab.47.1677523519780;
        Mon, 27 Feb 2023 10:45:19 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:4174:ef7a:c9ab:ab62])
        by smtp.gmail.com with ESMTPSA id b5-20020a05687061c500b001435fe636f2sm2492061oah.53.2023.02.27.10.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 10:45:19 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, stephen@networkplumber.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH iproute2 v2 0/3] tc: parse index argument correctly
Date:   Mon, 27 Feb 2023 15:45:07 -0300
Message-Id: <20230227184510.277561-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the kernel side series, we fix the iproute2 side to parse the
index argument correctly.
It's valid in the TC architecture to pass to create a filter that
references an action object:
"tc filter ... action csum index 1"

v1->v2:
- Don't use matches()

Pedro Tammela (3):
  tc: m_csum: parse index argument correctly
  tc: m_mpls: parse index argument correctly
  tc: m_nat: parse index argument correctly

 tc/m_csum.c | 5 ++++-
 tc/m_mpls.c | 4 ++++
 tc/m_nat.c  | 5 ++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

-- 
2.34.1

