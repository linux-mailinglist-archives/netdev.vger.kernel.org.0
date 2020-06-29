Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8169720E584
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391265AbgF2Vhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731043AbgF2Vho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:37:44 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D909CC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:37:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k1so14681526ils.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qO4ruJi3PkHIFqtk9SeCvrzbofsNNbj7BYEByAmu5bA=;
        b=Gey87y3jt6nWsaveT2OTLNBOEHZawnXKmUWQlevdIEUWRgf7sOubP1TcMEKCXTj9mV
         r2nQ2Sv2HcbBNenrKbZ1479H4nyPjZrjXMRmrzt++sVcPCB8WUAyE5kpthQ0y51XWQnC
         52YdiC9EC7f7tw+/ap9OBgWfnPJ41THUCNJjzBRPFyRR46bi0VOYecwH3M1IWfpDKKez
         pLXpYNsZLLfJuA0LEvIib0MhoG6GpTsg41hdSI6esuIkD/gUA+LuDlhMZF8DJ+nflAKA
         uJaSZpGRFCS1nw3Jt0JwxZb1jowvkIYE7pBQ0xGKE4GcGhdzfc/438Hkbt1Oq9ORh+nP
         wjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qO4ruJi3PkHIFqtk9SeCvrzbofsNNbj7BYEByAmu5bA=;
        b=TTqw8ldCvDkQoN8o5ihgpbSBN/qPVKry/B+lnDp682aXn5Y2fKTWnEBB3FNS4g2Iz2
         M8/enrxx31DhSDS9rVc7IUCkFr2VnsQtf5oGjawmhdSA7Qo64BBStiIVMpZi3QnzHIG3
         hz91+fjlh/Or+jhgb2uSsH9GiUqMrbIQrKaP03ESz7TK8SaV85Vs3UBIcR4xX6LMBlpC
         9C6Hj6xIaUbQZDw9cLr61jBHGmXjQ4kN+0vvUv3H4Ed2NzEKjHVKPXZo81cmsncmKr4w
         iGNFuqudujtH9u0orExPBeRXO/oizcmnHd79X0gf0CGTdgHiUg+SMZs0qj9tnYdL3k5W
         X9aw==
X-Gm-Message-State: AOAM533Hbw5UiJm5OCQDlgmqw1f8/p19ZhS57Nkmo1F4SOmVu/W07xjz
        Hgi+3gRx21x5UnQXsA8oFqYzPg==
X-Google-Smtp-Source: ABdhPJwm4KYV+HQnzhOwU7UoeEZy92fwTDCelEPfXe7+2jgZFqpJkhmsmTWJh970ZUwuXV2rqJv/Gg==
X-Received: by 2002:a92:bb91:: with SMTP id x17mr16714746ilk.156.1593466662318;
        Mon, 29 Jun 2020 14:37:42 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u6sm571353ilg.32.2020.06.29.14.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:37:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ipa: small improvements
Date:   Mon, 29 Jun 2020 16:37:35 -0500
Message-Id: <20200629213738.1180618-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains two patches that improve the error output
that's reported when an error occurs while changing the state of a
GSI channel or event ring.  The first ensures all such error
conditions report an error, and the second simplifies the messages a
little and ensures they are all consistent.

A third (indepenedent) patch gets rid of an unused symbol in the
microcontroller code.

					-Alex

Alex Elder (3):
  net: ipa: always report GSI state errors
  net: ipa: standarize more GSI error messages
  net: ipa: kill IPA_MEM_UC_OFFSET

 drivers/net/ipa/gsi.c    | 111 +++++++++++++++++++++------------------
 drivers/net/ipa/ipa_uc.c |  10 ++--
 2 files changed, 63 insertions(+), 58 deletions(-)

-- 
2.25.1

