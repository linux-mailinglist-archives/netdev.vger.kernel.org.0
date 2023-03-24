Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2573D6C8353
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjCXR1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCXR1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:27:04 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F082A243;
        Fri, 24 Mar 2023 10:27:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id ix20so2468104plb.3;
        Fri, 24 Mar 2023 10:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679678823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AnvXrRJKa5P2NMvsWXKJzSsvK0N/BZGMgdJ89bSB0JU=;
        b=db3j+hF0DVS9BZbZ2OKLfb9wzIcnRZUS+v+w0B9JRK5ZVCDuRdty9Lm6swyEnKPtVY
         pRyzY85fsiY3O6/o1vyWI2WQ7uYIkYvIt8Omzkml6z9pkPf0KvYQIndRzF0OV1mrfp56
         udsgzKpXBP+CRBmjm7dveKgaWgGNC2Vd4nPcAIIYlKRGwoL7sgfsP22AUB2VCSfaC+Ce
         GWuE1huSB0AFhAw1113Tl9ngFJx57Iv8ZHE8Xq7fLX8oH58jJHNJ+7RNL1kjZylVg1bq
         RdUBO9dY9AoYNoGYqwXZaAYoCAC4LEKh6T9VQB7iuHq3csHif7zgSQl44uu/154UROWE
         BW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679678823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AnvXrRJKa5P2NMvsWXKJzSsvK0N/BZGMgdJ89bSB0JU=;
        b=BUz3ARDACv29/kin/6K2tKzOUqz/ZNC4QxekIn/QG7bIJqR2ZJfFV7WtlbHF1XdMpR
         dkxF387jm9k03Dw1TsxTNFeHUd1l7e1pwgjDEeg9sCQd5cJSDl90Ebt6JC8W1gp5ustK
         vpwhF+lHeqF4dXukNs9UcXzNX1v9WKbsjY7xNuZuAdooHXYzfWeOJoQS4tgEYP7UR+2w
         3dFyu2L4BSinp3WlcJ/BzKMqVdT4yllR5T4pl+WbCjzCzFuAdT6lZk8/jwWK1DTIgWAB
         KDEd8203m/co1/KnascpGiZ94A3kLmnEGHEpnXp18wsdkVXkHaelfGmRt2N7TpJaqAYh
         x38Q==
X-Gm-Message-State: AO0yUKW/TxHybaHh09Osx9XQLgSXoQvreXJ1OsBIMIoGuKLZrhYre1vF
        P+Wbc35+yhbkFq1YtoVx6Jq8oBebA4I=
X-Google-Smtp-Source: AK7set/SseYZJ0UgELJmgVTzcdT9Nh8XNw0+h+NLrMME772OeS8seRcLDRWyNqDuGR7WKCH5DF6J9w==
X-Received: by 2002:a05:6a20:98a7:b0:d3:c972:9a83 with SMTP id jk39-20020a056a2098a700b000d3c9729a83mr3561462pzb.56.1679678822560;
        Fri, 24 Mar 2023 10:27:02 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5-20020aa78b45000000b005a8cc32b23csm14164214pfd.20.2023.03.24.10.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 10:27:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cdleonard@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Qais Yousef <qyousef@layalina.io>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vasily Averin <vasily.averin@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        Kirill Tkhai <tkhai@ya.ru>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] mailmap: Add an entry for Leonard Crestez
Date:   Fri, 24 Mar 2023 10:26:58 -0700
Message-Id: <20230324172659.3495258-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- also copy netdev@vger.kernel.org so we can route the patch there

 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index 317e51a0065c..9a450f17690b 100644
--- a/.mailmap
+++ b/.mailmap
@@ -263,6 +263,7 @@ Krzysztof Kozlowski <krzk@kernel.org> <k.kozlowski@samsung.com>
 Krzysztof Kozlowski <krzk@kernel.org> <krzysztof.kozlowski@canonical.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Kuogee Hsieh <quic_khsieh@quicinc.com> <khsieh@codeaurora.org>
+Leonard Crestez <leonard.crestez@nxp.com> Leonard Crestez <cdleonard@gmail.com>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
 Leon Romanovsky <leon@kernel.org> <leon@leon.nu>
-- 
2.34.1

