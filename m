Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E64A304D83
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbhAZXKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731723AbhAZS5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:57:48 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA72BC061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:07 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id u7so4438526iol.8
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fou4Lq6mqe4XTJhzFND5pizo3LVmYALorA/wjxT+0ac=;
        b=sGHnTtrj7FyNa6xiPsUCJAQMIsP0G9PyW0J+KcYlWeD++uJfn/ri7o4fQVl2Wm3THE
         nWH+BpbHA6wOFpNLmYOxmkx97tE/08Vt0JX0eUhm9vr+EpzlHS94rtgKJpioumwq7A65
         XCM3t98NxMXAFgwOeo8mcALYUGhSCzTXjZZagAzD5Nbo8XVMomgpr6Q/2tRz6XRXj2Ck
         ToGrFmVcI2fX4elaUatKAWqZwLQVWU0pulrJED5Qfgu6ZdvayZZPTlk7wS2vp1GJqmoA
         4aOYISeZvG58f6p/Sf8nEuJQEwdN2IBQp8pCv/NeRBb6YNeDqUaLguF/HJoApyxAcoDH
         NZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fou4Lq6mqe4XTJhzFND5pizo3LVmYALorA/wjxT+0ac=;
        b=ebR1d0sWaLMs8ZvNPYD5UC+c0w6+JRcYtUiyufSBs9W2JotBn6qGTy7C49t3WREOng
         WtV53KFTbWVrkb9wT5MyrzYe4I9ijwPeJyn69kayWydckkr1WMCsoWEHIme+kqkfewQS
         cZIVIBDYYO3oMlGj6wBcFvj2uY40Ym4Ii/AsNTWeYPD68f0Lg7F+frlJeIhAy/E2zEcs
         DUvePgpQcakBlGjMtwGFWCuAp7WbdktkEttSYHBPZi+rcpqHlwQuVZzY+8xd2vZUPXBO
         GDzuOc8vxo7YQF8oWzGiQfrdZMpHnZurPuVrpw7S38ejC0En+r5iWBl6MsWEusD+lOGw
         P/mA==
X-Gm-Message-State: AOAM530zK/EvaFxjhc4JoCmPI3LeVpwIGV007uluv/7dmlhoCcyjCUBX
        xPMLtu+FrQXSFACTbJXFLjWo6g==
X-Google-Smtp-Source: ABdhPJy00gWpHXop/6jAzwA1TFCJ+LKJEXem6EQ1XuR1YkA5x/dJKi//oToRJjc3Rywwt8gJTYOXjQ==
X-Received: by 2002:a02:c80a:: with SMTP id p10mr5928747jao.3.1611687427249;
        Tue, 26 Jan 2021 10:57:07 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l14sm13060681ilh.58.2021.01.26.10.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 10:57:06 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/6] net: ipa: hardware pipeline cleanup fixes
Date:   Tue, 26 Jan 2021 12:56:57 -0600
Message-Id: <20210126185703.29087-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 2 of this series fixes a "restricted __le16 degrades to
integer" warning from sparse in the third patch.  The normal host
architecture is little-endian, so the problem did not produce
incorrect behavior, but the code was wrong not to perform the
endianness conversion.  The updated patch uses le16_get_bits() to
properly extract the value of the field we're interested in.

Everything else remains the same.  Below is the original description.

					-Alex

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

