Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7C0302DB9
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 22:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732691AbhAYVan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732630AbhAYVad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:30:33 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D233FC06174A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:52 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q129so29620590iod.0
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UrNpQ7SOH+d8blqYOKjYMogMaDLbwPx+2kuPIs3yNy0=;
        b=x4DJIRqqQXqK37TCmxkPI3seKWh5Css2rLKLSnHf6gmyL1Fl9yWUz8kC+UZRSJdAs6
         XK8vDJjUxsgtxbCmnk9wdlGj9pv35V2OeBb9IzBIDCNiPryJuo1EAGw912WS+G4zcCKC
         7BtYk/vBritg9FaF+WbjLhD8oL9+PpIxb7u+efGHd+shUFbp89hSeVxFPtEnm6ui6pMv
         lVVnhtPY9OnRe/NJhDaIhNjH80KFOtFa3YJiKy7BZK3XPrl/6EBVb+dM/woBjm2L8Axi
         wxfYW1mRUlRVJ7TXGVHk62B7CmS+UoEfGH59oZUUrT/N8rzRkizY6D1GeZsaaTEqFW2F
         V6fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UrNpQ7SOH+d8blqYOKjYMogMaDLbwPx+2kuPIs3yNy0=;
        b=KNEagGomm3wyzMOsEQ6n+2Os4ps6uq1wnvtG3y0XzVrjGB1zjcgv1uEIEWvd1nqamV
         8b1VAv2fSjg1M33XkIk2HAGKSQexBx5SF1lDx0maWIBbZf2OR9xxg6uN1mzlGGvlt13y
         f5REo+xDoVVChG6D44xxTAmbjzoMZMexD4Yg5xJ1JFNxI2xKSk2hmmtJdW/ZznE2z5jZ
         Dr0hTJjThe/9S+t8trd3WYCl+xu6GWHnroROQs68ded5xhyqGzWQQ60Tk70pW9zUzSz5
         NJ4thCCAT7OzytGyr5maoFekJBVB5XZN1jgU97AnVD4HcABvGhlFldu9ib4d+7zTnk9F
         NQgQ==
X-Gm-Message-State: AOAM532Q8G2EVNeyxpfMh5xEY1t3IOcPS53Z9+mCBlP1Vg6Fzp2dEcr+
        pEzXGr7hWLpEjSyVUSI+o6TLTg==
X-Google-Smtp-Source: ABdhPJz8uvE8SMwpYe+oCni7l+kPBBLvPL2VGcJFyM51j/BFID2hIs82LKEw2GImPnfFjRXXxizvEw==
X-Received: by 2002:a5e:c74b:: with SMTP id g11mr1938225iop.152.1611610192019;
        Mon, 25 Jan 2021 13:29:52 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o18sm11136241ioa.39.2021.01.25.13.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:29:51 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: hardware pipeline cleanup fixes
Date:   Mon, 25 Jan 2021 15:29:41 -0600
Message-Id: <20210125212947.17097-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a procedure currently referred to as a "tag process" that
is performed to clear the IPA hardware pipeline--either at the time
of a modem crash, or when suspending modem GSI channels.

One thing done in this procedure is issuing a command that sends a
data packet originating from the AP->command TX endpoint, destined
for the AP<-LAN RX (default) endpoint.  And although we currently
wait for the send to complete, we do *not* wait for the packet to be
received.  But the pipeline can't be assumed clear until we have
actually received this packet.

This series addresses this by detecting when the pipeline-clearing
packet has been received, and using a completion to allow a waiter
to know when that has happened.  This uses the IPA status capability
(which sends an extra status buffer for certain packets).  It also
uses the ability to supply a "tag" with a packet, which will be
delivered with the packet's status buffer.  We tag the data packet
that's sent to clear the pipeline, and use the receipt of a status
buffer associated with a tagged packet to determine when that packet
has arrived.

"Tag status" just desribes one aspect of this procedure, so some
symbols are renamed to be more like "pipeline clear" so they better
describe the larger purpose.  Finally, two functions used in this
code don't use their arguments, so those arguments are removed.

					-Alex

Alex Elder (6):
  net: ipa: rename "tag status" symbols
  net: ipa: minor update to handling of packet with status
  net: ipa: drop packet if status has valid tag
  net: ipa: signal when tag transfer completes
  net: ipa: don't pass tag value to ipa_cmd_ip_tag_status_add()
  net: ipa: don't pass size to ipa_cmd_transfer_add()

 drivers/net/ipa/ipa.h          |  2 +
 drivers/net/ipa/ipa_cmd.c      | 45 +++++++++++++------
 drivers/net/ipa/ipa_cmd.h      | 24 ++++++-----
 drivers/net/ipa/ipa_endpoint.c | 79 ++++++++++++++++++++++++++--------
 drivers/net/ipa/ipa_main.c     |  1 +
 5 files changed, 109 insertions(+), 42 deletions(-)

-- 
2.20.1

