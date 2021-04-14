Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEC235EEB5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349661AbhDNHql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhDNHql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:46:41 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B003C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:19 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id i81so19704629oif.6
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 00:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KD6ZREftw2DaKdhNdLsUqMAfzc4b5XxeyQiCkSwgfZo=;
        b=FcG+A8cTKoutg6GuEtD/OYnYSrVccuQD+LP99yTxbtBh3nI9MheY+bTv+9N91v0d9A
         Vgdsx/IAojiXy06DBAUTY10/dAuySIFUBJiTB9zcxgP2d45AuXW+G9JH7dPncXyRQ0Dy
         SRkvLipR/+G/SGGK4QUYOkg98Hi2akEtVtVoMAQ2nXXH8NZqbEY2zQyRF2Jw2DJSzwow
         LVJOMD9jqYaRuiiPrubMNYgC78sdBJi+J0XPxCJ4RApBuo0L0Urx/h98Fh3FoZjKMVVi
         cdKWP2N+ZIpnDFuvM4JGT7+SDrNeb22xhQn4bvem8NZJjsWhn/plh12rau1lTeTsthQc
         uYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KD6ZREftw2DaKdhNdLsUqMAfzc4b5XxeyQiCkSwgfZo=;
        b=ishnpWGSVX+81OfvtaqDotYUMZzKRMQE2vfu/eObMv8WEH4T942hjBKhpqTznecxGK
         qgdYTxWQBKE52vyM9+B6JnUYw2dccUhtkZOK7Su0lXWx7BA6BO2OUiP87KWeo0p1dqwh
         vpUdC4LrTJ5776RaA7TuGqyOMO1Xn4uCtoMlBVGl3+bu8a5HSTtXw/L6AHcPgG5e2hfv
         UpRO3kVCpgTgWpcAUXJ0PTKNUcKBFOGWc4TlNitVFTwQc3pTQWFfx3Gi078EgGPM2Vdq
         WCoeWyNB8xkijjeEemScLR8WSajNXiETnyxW8fNFadyh9Gn2H1Fz6oy2tbBs+fjjFMGu
         GlOw==
X-Gm-Message-State: AOAM533gR5B2P5CGw6xniQznOKmg8qsQlvd/lP7kFsi3l4tN27vUeB2G
        MkJP7bw1uXrVcvhvW+F8815DMyQTOCGt4w==
X-Google-Smtp-Source: ABdhPJwCFvgOH6Mmi3ywyYVp3TtS1XEWAr0Hy9Wiq3xH4XRmiU550N14CXolEPFd2BQ+oUwviK1AOA==
X-Received: by 2002:aca:a989:: with SMTP id s131mr1456918oie.179.1618386378680;
        Wed, 14 Apr 2021 00:46:18 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:7124:9f6b:8552:7fdf])
        by smtp.gmail.com with ESMTPSA id w3sm2833015otg.78.2021.04.14.00.46.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Apr 2021 00:46:18 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net 0/3] ibmvnic: correctly call NAPI APIs
Date:   Wed, 14 Apr 2021 02:46:13 -0500
Message-Id: <20210414074616.11299-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series correct some misuse of NAPI APIs in the driver.

Lijun Pan (3):
  ibmvnic: avoid calling napi_disable() twice
  ibmvnic: remove duplicate napi_schedule call in do_reset function
  ibmvnic: remove duplicate napi_schedule call in open function

 drivers/net/ethernet/ibm/ibmvnic.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

-- 
2.23.0

