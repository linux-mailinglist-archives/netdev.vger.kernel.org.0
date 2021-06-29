Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BD13B6BB6
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhF2AcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhF2AcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 20:32:01 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30231C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:29:35 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id v20so14495113eji.10
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ULe8fmPGZnvkudL7mSPycEeAcgK2mF03cUEPxFiqVso=;
        b=J6JFX3OZ4KUU+/6d0t6nWDV2ssoGI4N4n6CUipZE1QelXdP5VuZUQSAhLoutWU1UfN
         Y0ArR1L3GO/PPCgDJka78bEYn1ZWjV+79YML6DTWRe/s6nFAzM0MwY830zSXMgDVqaF3
         XBHITP1tOhv0x0WiL7AL9etxhEpwCv9uxur9lQKW1CJ0dTKoVAJgzigmKhwsovzKaP8g
         ufAAb415TmQI2ewMqpygo0AnKPqQbXn8hf6X99DP7Ox3RXQmaNHH2pZ7RKpdlni+UEXG
         PTAm96aNFFMJ5m9X/FeYoOapyhJz7bfsT+2D9b8J0iZoCIGV7mfucOVocOYvdh7YSvEh
         F/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ULe8fmPGZnvkudL7mSPycEeAcgK2mF03cUEPxFiqVso=;
        b=UwX29lbRy64+bjKHXDS8NsH5hO5ZV/CKYGLhCN/7gqtsi7kmL6MIjSjGPGbnc1p41Y
         xvsjz21QAuqhsSqrGeZaZrfYbGCNTr57H6+JG9jdJ6JPXzaszblkwXa9JGu0YEk2YL9N
         2ZZ3bJIXRnmHJsaWu8x3TEQ/wWzt9R3M8qyHiylylgvwNdaMz74iHFBA6HIa7SD0D8qD
         c/mnBTs+9PzCHLYKbmPdATteLuWaTAy/+PwsfJ7AG9URatvins6eDA16nB1wn9usiUmB
         yP0qGS4092gG3OIQclZnJdyQuA46ZBNdI3gV330qJIhucCM0bpspHmUtty12a8m8BEnb
         bj1A==
X-Gm-Message-State: AOAM5322afjBfirxmkbbikFzC+wuBKo1fveMnzpKEpIRP34Y9QjtqTmS
        3Xcdl8uLXGxMYev72TdJpkm8SYEoiSQ=
X-Google-Smtp-Source: ABdhPJy/NyeECpp9KKTEs5dolJOTTzRU7Jpp8ae8jJmp2m2gNGbs2KAQc//zlTn9s8WB2eiNW4ESEw==
X-Received: by 2002:a17:906:a38d:: with SMTP id k13mr27491978ejz.250.1624926573713;
        Mon, 28 Jun 2021 17:29:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s7sm7749913ejd.88.2021.06.28.17.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 17:29:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/2] Trivial print improvements in ndo_dflt_fdb_{add,del}
Date:   Tue, 29 Jun 2021 03:29:24 +0300
Message-Id: <20210629002926.1961539-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

These are some changes brought to the informational messages printed in
the default .ndo_fdb_add and .ndo_fdb_del method implementations.

Vladimir Oltean (2):
  net: use netdev_info in ndo_dflt_fdb_{add,del}
  net: say "local" instead of "static" addresses in
    ndo_dflt_fdb_{add,del}

 net/core/rtnetlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.25.1

