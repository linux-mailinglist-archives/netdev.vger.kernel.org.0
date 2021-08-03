Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C722A3DF253
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhHCQTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhHCQTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:19:18 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A437C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:19:07 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a192-20020a1c7fc90000b0290253b32e8796so2212693wmd.0
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PZe3mfwNO2BCmyEg9YoWlZoPkHdWOGufCTQOKlUjiHk=;
        b=J11j4pItE3BRXSb/WkaKkMra6Luuhk2qiYX9iA+WNEpva/Cq6HsPoMTwKSEthx9b7p
         gxI2ipx3Z31FY71Fo2NPebn9hg1SuNFAMEx6l3rUS9bSYHBm75XTaW5eKz0B2lvuRm0t
         0bVBj7gNWPaxml4YHoWpKiBXN6m+n779vkKV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PZe3mfwNO2BCmyEg9YoWlZoPkHdWOGufCTQOKlUjiHk=;
        b=sWvN/abbz2bWwtkj/ISNQmt2f/DTEfMoL9FlmPzia6dTQI4sDBgQMBfVPGBpQGkayx
         liOUwSxfah2Uv+yhzvpLqcEfGxXT1tvoPE2XTycnSDiG3fmF0+UI2amy2JBbuRznooUv
         g1WylsbBehrVecGDLbqc0iKANNvKagT2QAj5LIKtdicmYStbMjglLT4YO3CPH41/ZFt2
         6X7ryiCRpQGeGsV46gHOQ+Esq+VUxR+AbXMgAUg7Umdnz4TZ32zI462YBckNdJ+xmNo1
         WYpxwNON43Cg0Eap706xBYDwIqmENd3HG/NwK5sXDZ85dpzBw435riEWq1r4yEqkPmTd
         4miA==
X-Gm-Message-State: AOAM533Y54LrkZi60+boA6Fp7kKm0MQ43nRNM29rxS2Q5ZCIN425ELOp
        JYg2ndDmZkQ/RAyIAaH3V+FF21XNGHHIdg==
X-Google-Smtp-Source: ABdhPJwkq6BcF6QDrwC0CZZtSUryeuAZTpEmKLRdLg0zH4bHa5GnuMR9mTi9980eoFTf72v379UwxA==
X-Received: by 2002:a1c:a945:: with SMTP id s66mr22669760wme.67.1628007545781;
        Tue, 03 Aug 2021 09:19:05 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id d24sm3028223wmb.42.2021.08.03.09.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:19:05 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net v2 0/2]  net: usb: pegasus: better error checking and DRIVER_VERSION removal
Date:   Tue,  3 Aug 2021 19:18:51 +0300
Message-Id: <20210803161853.5904-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

v2:

Special thanks to Pavel Skripkin for the review and who caught a few bugs.
setup_pegasus_II() would not print an erroneous message on the success path.

v1:

Add error checking for get_registers() and derivatives.  If the usb transfer
fail then just don't use the buffer where the legal data should have been
returned.

Remove DRIVER_VERSION per Greg KH request.

Petko Manolov (2):
  Check the return value of get_geristers() and friends;
  Remove the changelog and DRIVER_VERSION.

 drivers/net/usb/pegasus.c | 134 +++++++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 60 deletions(-)

-- 
2.30.2

