Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF233C613
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhCOSuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhCOStd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:49:33 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C01BC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:33 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a7so34494931iok.12
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTkmIya434QwLoJGaEtNgVzOY0oWG7aHELGWdpiMzDk=;
        b=qYjZa/2NccABXnXsA18YJbRMcVLBm8J8pWtggp5s1zjYJ5Ve9lWbyhOd/TUNJcHCxV
         emBcUk2XYj8Ora4kmpZtpn8cCwYKk8s3vgOSSywE+i/p4lnQR9KgKbc7/F7FAu4rOA8E
         MmXqq0IMx+EyYYYMCkRsfHRlQvyD2AVdj8fmfuALfvR+y7lTvM52Md0U+2dKGOZl7Go0
         NyGwQkqj/itv78AEUHD2ZUwG5ygQY+4O015tf5d7nm8F52tvipTqi2u7JOX60b9QyYgx
         gIMcQDUuvejpVxdTjvbHKwiZFsZZ5P0YvHTwboTNTnEsUML48fNHbEXjA+8dIdH87dRC
         bybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTkmIya434QwLoJGaEtNgVzOY0oWG7aHELGWdpiMzDk=;
        b=WkSIq3+tEfyvwlDPtZzuh7PPRDqVIgMgFs04rV2rKAQ2lsuRxV8UTGoNFGin0IIom+
         FtplIR3yw0H7Wr4AOp8AHrcH671rfekI4fHCWM9m9Pl4469QErqZk3gCru+B93F8XlU1
         stynpQ19RMUqCWyNbn2yIB1uoda5dfPqBm1TIs5LTDqvuJxvkoMvppTpP8ccAnMK4oSb
         OIgZ2UDjy28Atc8/v0W7tdFcEstvOq6eFhus7HDLrB2rcvK66s4xq+xeQWnj9oe4m6O+
         48TD3fRAYEXSK8QGfFQufxm7QF9w0gGDU2n/nLy/lKs9Ls6RwBLg/T7s87a3LVx75nH7
         svUA==
X-Gm-Message-State: AOAM530nggETWVSNxPgvRKsFWCXaSDRKxUoHa3CSFBikr5zm53bTO9hl
        7Co+l4yGq1Y3fkCtnK2iDIs4Pg==
X-Google-Smtp-Source: ABdhPJxfohasBT23s3DaArjc4+mN+tDiJTkakLsfqyW3BkqxoYlqoJ2b/q7Y3KN4ID9GeAhqv+iYBA==
X-Received: by 2002:a02:b890:: with SMTP id p16mr10508597jam.138.1615834172741;
        Mon, 15 Mar 2021 11:49:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a5sm8212162ilk.14.2021.03.15.11.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 11:49:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 0/6] net: qualcomm: rmnet: stop using C bit-fields
Date:   Mon, 15 Mar 2021 13:49:22 -0500
Message-Id: <20210315184928.2913264-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

