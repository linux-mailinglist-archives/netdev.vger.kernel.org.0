Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF2D2AE248
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 22:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgKJV71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 16:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgKJV71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 16:59:27 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41298C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:27 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z2so15793ilh.11
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=34u/FsKjU5JEH21Mbeeqb1FNSVhPfOUCDpBOlpNDehc=;
        b=QSH8GEAkf83/tL0jZ9bgHJVnBUW/8KF0qTiX/oMhQ7Ta4RRwLsp7FWr2ASOBbbvMW8
         9rGLOCCIdI4Q6kapvVWuqwP8Ic3QAL25Vf2dkMH+/wJAICUjUc0HFY+l9ekvDVY2UKAe
         xCjMRDeYWv9okRZ6p8nsOHMJ+qf95Dr1eLHEA6kIqsm64lk9vpqZT3qIgB24GmSZYJn0
         qhzNjR1cx6ZXw9gPhfbPVNaxaRenMn7FKQBKcZ9bVfdQDuoSCpDrDDR73vWRwlqZ+q5+
         i/ihpPE1IaKTrCsjqxJ7kumDNuXqhpzwPrI/Ey/6DdxmHHOaksGhQtoSHEEeK8k87Co4
         0RHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=34u/FsKjU5JEH21Mbeeqb1FNSVhPfOUCDpBOlpNDehc=;
        b=UZFR+9F0gjOfVWdlKI/DH9NLYoh5MPZzGYTsX7FVdhD+uzSKQWDLQ11W0OXKf/zdg5
         DygcptO5g4D2Z3Gs4x0MFM9wgna6otMzRU356rUc4MYsA10w98WZ4uBHGzHxTobnRnVo
         qArIFsrQxAlqrl7cIV/kxluM0dzt5xkGz2LRgnS4EqUWYtHWdAOJD2h6CazR+SgwTqNJ
         MNwKBW1qOgC4x54IArxfI4oj8xY7ixxMOAHods0kT4W5Sg7ppOa9jtg94l1ppVRwjUVP
         md4SXYofcFjRro0a/h/T7EhVL+FyIW4r1g/k2jFXmVpmENczeUX3AtHPSHnD8ZFTHOD5
         2tfg==
X-Gm-Message-State: AOAM533PQOQf9Kw6NMIlS2yRRcpnIzXVc+dyLhkMuFHoMhd9oODmNr7W
        YLP8pEPLeklW+EmDmUO6BRJo0+cmjy83n70O
X-Google-Smtp-Source: ABdhPJzhsZ+ENqTCiV4KCRGDhG8JZJ7lEftSNWX0XUsfw4V+fx3xTndq+mto2M62r+HsJZC890cKRw==
X-Received: by 2002:a92:9f0c:: with SMTP id u12mr17100337ili.113.1605045566474;
        Tue, 10 Nov 2020 13:59:26 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d142sm102010iof.43.2020.11.10.13.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:59:25 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: GSI register consolidation
Date:   Tue, 10 Nov 2020 15:59:16 -0600
Message-Id: <20201110215922.23514-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series rearranges and consolidates some GSI register
definitions.  Its general aim is to make things more
consistent, by:
  - Using enumerated types to define the values held in GSI register
    fields
  - Defining field values in "gsi_reg.h", together with the
    definition of the register (and field) that holds them
  - Format enumerated type members consistently, with hexidecimal
    numeric values, and assignments aligned on the same column

There is one checkpatch "CHECK" warning requesting a blank line; I
ignored that because my intention was to group certain definitions.

					-Alex

Alex Elder (6):
  net: ipa: define GSI interrupt types with enums
  net: ipa: use common value for channel type and protocol
  net: ipa: move channel type values into "gsi_reg.h"
  net: ipa: move GSI error values into "gsi_reg.h"
  net: ipa: move GSI command opcode values into "gsi_reg.h"
  net: ipa: use enumerated types for GSI field values

 drivers/net/ipa/gsi.c     | 89 +++++++-----------------------------
 drivers/net/ipa/gsi_reg.h | 95 +++++++++++++++++++++++++++++++--------
 2 files changed, 93 insertions(+), 91 deletions(-)

-- 
2.20.1

