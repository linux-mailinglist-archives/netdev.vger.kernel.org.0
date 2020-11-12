Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783A02B04C0
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgKLMMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgKLMMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:12:01 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72FC0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 04:12:01 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id p10so5044709ile.3
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 04:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fnoYpz56ibAMj1qjJjzVWCKsrD3fu7HOMcpzb6SFLQw=;
        b=gUqQZ2VPC1SYq3DSRL1Mev6Svu2VXswDHMQzJuxychcL/EmpCIhoGuqKjdrTNuqrc0
         WGCR55j22sMxj5TMPMUd60RWUdQU0Adj/y9zr0UPeXqjfNMPdqIyOjsi/UItyZ+Wx/cq
         K4gD5n8UTDH899lmjb1/szWtkPfdHM6Q6TSnr0ZP1ur3/isg7HfirvGJX8f/80qMre4g
         9EqQtn8asZON+70qSiL3xweNiVDbAMfzIYqA1VM7tX3egAkQWDqXmNJiAN3Tql84ORYD
         A+CxHlVTgkVuH3ZgOWgJpk6r9ghosV/DeKjn3ARF64qrNBIqTP03E0ICU7uaCO+PygMy
         rtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fnoYpz56ibAMj1qjJjzVWCKsrD3fu7HOMcpzb6SFLQw=;
        b=oaVB4QlOO9gVnZunj/CUSb/dZnbv4KVTzxKW87nrxx2RhcDjqhb8dJunsa4dpOHCDo
         hgtm/CczvclIx64p7r2GrW/mmMjZqbxnrfX8GmGa3EFfKT6GmUmusioTKI3V0q6u/EOT
         Vqqc9lCcn1pKa5gHDKFVSBTVYHwG2RGceMUevylnSmF2XgX9WAl1XhJHZelEKA4Js2qZ
         mw2dMN1q1VNO6LQPTXiDHmdq69dEcVSmr5aGjzgJk863E1DeBG9AajuJdVPZG5UosKZL
         4khfKfBugiZ1JYKJakAXjkKlrg1TZ0KXbbqn9wphS8zJAYAbUXEyJORxweNKKEHrkoq3
         cdcA==
X-Gm-Message-State: AOAM5314dX+ELnzYubfUoAR6d+4d2O/O4leHRcGikfBFLDwQQH0qQ4hF
        I0ZPi8a8YeVjjpTwmNJnzWamx7BYTUiIhRuz
X-Google-Smtp-Source: ABdhPJwz9MFnm9EG7SSCZl1dWGVR12C9FHy/qqxm+kVm/Gg8RdjcALez3W2uf4wQg8xL5h5fgTSIbQ==
X-Received: by 2002:a05:6e02:926:: with SMTP id o6mr23467158ilt.287.1605183120861;
        Thu, 12 Nov 2020 04:12:00 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i14sm2609563iow.13.2020.11.12.04.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 04:12:00 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: ipa: two fixes
Date:   Thu, 12 Nov 2020 06:11:55 -0600
Message-Id: <20201112121157.19784-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series makes two fixes to the IPA code:
  - While reviewing something else I found that one of the resource
    limits on the SDM845 used the wrong value.  The first patch
    fixes this.  The correct value allocates more resources of this
    type for IPA to use, and otherwise does not change behavior.
  - When the IPA-resident microcontroller starts up it generates an
    event, which triggers an AP interrupt.  The event merely
    provides some information for logging, which we don't support.
    We already ignore the event, and that's harmless.  So this
    patch explicitly ignores it rather than issuing a warning when
    it occurs.
     
    					-Alex

Alex Elder (2):
  net: ipa: fix source packet contexts limit
  net: ipa: ignore the microcontroller log event

 drivers/net/ipa/ipa_data-sdm845.c | 4 ++--
 drivers/net/ipa/ipa_uc.c          | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.20.1

