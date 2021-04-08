Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD5B3581CB
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhDHLaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhDHLav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:30:51 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272FEC061762
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 04:30:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p10so903151pld.0
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 04:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=idLyBB53a+zb7rBWXo0Xtc4Y2VYfNc3H3ETOy2Iv8JU=;
        b=haLvNZtI2/mr3CY4J+ayFNZg2Zb3d9szad6P8KL5g1mtbbXrvfWZx+MLyRpAWCP3Mk
         us3iS8EBJ4wfY0GZ5rbj1EU+7LFYsvH7Jjq7aRRB8ZCQsdOuLkBEB9+uz3uLdST8hMxz
         wsxx1b/GWF9MI//5jJZDKn79rJOOZ736GoYJDjsWs2M+0t+Kp1guqw47GDstTCW7BfsR
         c1bEmoPp5RTn/67fgDymzUY5U8n8l0tBpm1yR1GfcSTvx1BEcSxZRfFeh/qyd2UOIQhB
         SlexiSoabIELDQ61SnkykN499yYR1tN/xlGL/6XC6BnKdwgz7jHVc25ncN40rrqWID4D
         96Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=idLyBB53a+zb7rBWXo0Xtc4Y2VYfNc3H3ETOy2Iv8JU=;
        b=cEZKruzva4/wWq25t8f4U1gVrTiuseEv0L22zwl/F9hVlBjZ7mLREZtPOLqvH7EVlY
         310+M91UJUEBDaEbluocMvE1/2A+9ouxJZL3NrkbpGs/oQ44ygKVpoBECVcq00ZstX5E
         OjIiKc7DPnp5HtGfn/XOHlYOs9UYA1DN07mNbpDCUpSTfk7LsCnWncE8l7lsSMfwk0ai
         JOxIGy7KS2c/BZOVleCnkNJGuqxjUqdziKoVXa1Qy4Y/cffmV/w5hVGhsBPgz2/oZEOz
         AieJ3UemzEnY1RPnrNDVe9oU7RRI7WwLPKO/YZH1Qc/R3JahQZ01HKktIC69CIl0SEMF
         WLIw==
X-Gm-Message-State: AOAM533gLNLxXzUodvs1lyTkO5emLkTBVjXdo3E3Co8QmYAMvRITqq1a
        wkbVzyEpJuQzpVLHd5t2aR+8ow==
X-Google-Smtp-Source: ABdhPJxx3aj0+FumS5hLI1oRIvCZsO6w/JQp2J14V39WZ1ohHPEo50HXwT9OIwsmIeXRr+kT00pPBg==
X-Received: by 2002:a17:90a:94cc:: with SMTP id j12mr8196394pjw.159.1617881439623;
        Thu, 08 Apr 2021 04:30:39 -0700 (PDT)
Received: from localhost.localdomain (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id x18sm7753267pfi.105.2021.04.08.04.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 04:30:39 -0700 (PDT)
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 0/2] brcmfmac: support parse country code map from DT
Date:   Thu,  8 Apr 2021 19:30:20 +0800
Message-Id: <20210408113022.18180-1-shawn.guo@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a couple of patches adding optional brcm,ccode-map bindings for
brcmfmac driver to parse country code map from DT.

Shawn Guo (2):
  dt-binding: bcm43xx-fmac: add optional brcm,ccode-map
  brcmfmac: support parse country code map from DT

 .../net/wireless/brcm,bcm43xx-fmac.txt        |  7 +++
 .../wireless/broadcom/brcm80211/brcmfmac/of.c | 53 +++++++++++++++++++
 2 files changed, 60 insertions(+)

-- 
2.17.1

