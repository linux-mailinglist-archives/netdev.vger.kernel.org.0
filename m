Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE5F33C8D1
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhCOVwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhCOVvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:51:55 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9168C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:51:55 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z13so35042556iox.8
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+3h28b0z5t+pu3hUlF/JbmCo8y9gS7Fj3VAcCI2xm/M=;
        b=HUo2qadrm2mDoNodF998irnIV5gR1wbCCeNp4XDBF2ibAzRMxnGUdROWERxgZWMLkl
         XP0syXbet2hL86tRGgQfb3wD9riHD0Cg6xGIdKzBYRFBzwR/nEp1VSnNt2V9uyRCf1yg
         Fr+IZBekp15XNLzgUEKyKZR5eD2jhPZgWwgvf6hQGc4agyUWDM0wFig1v7NsP9pxtHlp
         eMvm5k2gcead9bGQcYZnKdha59EJIVC1QnxZZx+qUcpQ0+uPfsiaBA5WL/sgIwtGsjgD
         HjZnKM3UPQOCNL9qmo4enXMrjfnxq7xizQNTcSxIpIPriSxLIRgX0pnFRO93PhSyRaXJ
         1n0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+3h28b0z5t+pu3hUlF/JbmCo8y9gS7Fj3VAcCI2xm/M=;
        b=TXC3KVVUriQds3M73BDLfn26I2ypU1P+pfyZllHBuz1g62VsVjWAwQI+EvU7tx23gf
         YbfNSNf166wKYPHhfJhlviJX+rQ4BUlqrUl/V419PuxBeJV+M3z1bAPiLftjCQlLM2/d
         WmArG5wbbYw6/jujI/18i/W6jfc/HVhwQlcLwPTe+R3+MA69sQYhgdnH41+cfVK0Rloe
         mfBSTMbZ5TNQWtvo62iNIXEZ6p1+8Its3debnn8jhSThuVpWqjkM7kdvpA99q1fxLEGO
         Ncc6RByu0wUXn+x57UvZfgrqIFFl0m7iovesS2Wnz5U/XBXYIamFQYyXNXOujnbu3qka
         uYhw==
X-Gm-Message-State: AOAM530F1opYfd5/aUt80wY+2j2pWgR6bDhrzy9ivz35m8yNTvJdvzsB
        PQzUGho+n0EMJNqOSbzD6ypB/w==
X-Google-Smtp-Source: ABdhPJxA/koZsxWi9IP2AGJazPMgvZdQwOprnd4NlKqe1EtEQhmibHumb8dilXY7ywVZr8vIjbf0GQ==
X-Received: by 2002:a02:c017:: with SMTP id y23mr11561344jai.3.1615845115134;
        Mon, 15 Mar 2021 14:51:55 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y3sm7424625iot.15.2021.03.15.14.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:51:54 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 0/6] net: qualcomm: rmnet: stop using C bit-fields
Date:   Mon, 15 Mar 2021 16:51:45 -0500
Message-Id: <20210315215151.3029676-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 6 is the same as version 5, but has been rebased on updated
net-next/master.  With any luck, the patches I'm sending out this
time won't contain garbage.

Version 5 of this series responds to a suggestion made by Alexander
Duyck, to determine the offset to the checksummed range of a packet
using skb_network_header_len() on patch 2.  I have added his
Reviewed-by tag to all (other) patches, and removed Bjorn's from
patch 2.

The change required some updates to the subsequent patches, and I
reordered some assignments in a minor way in the last patch.

I don't expect any more discussion on this series (but will respond
if there is any).  So at this point I would really appreciate it
if KS and/or Sean would offer a review, or at least acknowledge it.
I presume you two are able to independently test the code as well,
so I request that, and hope you are willing to do so.

Version 4 of this series is here:
  https://lore.kernel.org/netdev/20210315133455.1576188-1-elder@linaro.org

					-Alex


Alex Elder (6):
  net: qualcomm: rmnet: mark trailer field endianness
  net: qualcomm: rmnet: simplify some byte order logic
  net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
  net: qualcomm: rmnet: use masks instead of C bit-fields
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header

 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 10 +--
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 12 ----
 .../qualcomm/rmnet/rmnet_map_command.c        | 11 +++-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 56 ++++++----------
 include/linux/if_rmnet.h                      | 65 +++++++++----------
 5 files changed, 64 insertions(+), 90 deletions(-)

-- 
2.27.0

