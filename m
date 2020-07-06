Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9630C2161E7
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGFXKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGFXKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:10:14 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C3FC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 16:10:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y2so41192531ioy.3
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 16:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MvdQAtR2qLs6B429J/6XsvbOWOPlty7E5zuF1Tgl9m8=;
        b=GDiOOarHp+MEQ+Uu3HqUP9PHZ4Qz4Gf5zVG2X2eXXv10rUAE4NTfBuWeMk/yrxDiji
         hi0Kr7CpTalp92Fzx1ItR+NxhhtCqqUmG/FQXrM6QsNJJpl6GcE4KZrf3l0PN9gmXUaC
         NR343QyAF+vR2ilpU61weijHo5fLVIc1nyNAXdkzizkQVyPL60YEakmOf9ABVESld1TK
         XDseO0ZGtFD7hVSYWIn4510XRPHrHPsoA/Lav71I703H6JOhU27zH1c6CB5nI6q5tV+C
         L6Kh/CewEH77zMl7hr9YvDFKj+mSRvRC572C55NrvjPBtg4zby149VvxvbgbUXb1bILy
         K6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MvdQAtR2qLs6B429J/6XsvbOWOPlty7E5zuF1Tgl9m8=;
        b=HvtlAbIn7ftO4i9xcXfkH9hVU2nzljUYVSC0CnjwvALyrI+ro9v9LqkBANtcgGsMB8
         4/qZpBQ9Wwy3f+GiSJGwUODtLVcm1eLPVIRLFrNGyH2IKIwwwjQrnbWgVK+08cB1GJR9
         P9IB/paV3hfzmdp5lewJncKp2xhFgPez14klX7s7a7ES4Iou5oTJfEa8C4ITzTbr5pb+
         6IM19RUzHcdhXWChjNlQ+fsUqEPgXmWIg0ce6pM/Hp1BHywFu7QZx50HFehag6NwXbBw
         4QnthAW/NhODEX/JCPwKHmv+KJ8N/SBrgMoQgLn7UkywOmEsQdBTeNZAng5Ye466BIdt
         /j1w==
X-Gm-Message-State: AOAM530Ju1lM932sE0XszfaRTemz9SPwYShapYSSeEDTnRDN2+eFhXzo
        Zw9ro0rqgn0Rfy5rtQtMT82B80ZGdP0u1A==
X-Google-Smtp-Source: ABdhPJxHTuxCo5/s7nKOrl258qMT98b9xIBsONO5xuPusMwKd3AOokf9GdfhUGWXvusnGV1JY66HBg==
X-Received: by 2002:a6b:611a:: with SMTP id v26mr14884468iob.22.1594077013475;
        Mon, 06 Jul 2020 16:10:13 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w16sm11523029iom.27.2020.07.06.16.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 16:10:12 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] net: ipa: fix warning-reported errors
Date:   Mon,  6 Jul 2020 18:10:07 -0500
Message-Id: <20200706231010.1233505-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building the kernel with W=1 produces numerous warnings for the IPA
code.  Some of those warnings turn out to flag real problems, and
this series fixes them.  The first patch fixes the most important
ones, but the second and third are problems I think are worth
treating as bugs as well.

Note:  I'll happily combine any of these if someone prefers that.

					-Alex

Alex Elder (3):
  net: ipa: fix QMI structure definition bugs
  net: ipa: declare struct types in "ipa_gsi.h"
  net: ipa: include declarations in "ipa_gsi.c"

 drivers/net/ipa/ipa_gsi.c     | 1 +
 drivers/net/ipa/ipa_gsi.h     | 2 ++
 drivers/net/ipa/ipa_qmi_msg.c | 6 +++---
 3 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.25.1

