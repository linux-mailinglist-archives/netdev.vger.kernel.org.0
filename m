Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BCF25C4E9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgICPUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbgICL0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:26:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF86FC061251
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 04:26:28 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s13so2481112wmh.4
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 04:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nc6MxWoH99DjixSRVdSMeHaEhaef8qKcEjb+SKOFbog=;
        b=YN77sscLoFq78q8k877XkZ9lmjctVHbR9J6CMcLCW79QZWUZSt+IqMkLc1qjljmIN5
         sTV13N76gS3IkgRRRxQN85C3uZBaKIP4fIvV4OOEeqwBkR3e+jwcZMEF8DQy6zVBGDg0
         UeVvnwDbZ4Z5CqZ8KYhSp3EruEoibul86XGGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nc6MxWoH99DjixSRVdSMeHaEhaef8qKcEjb+SKOFbog=;
        b=SlElnEsZ1h0BuGdFezSmTPQBqu5jTdEHR5NT247AeBq02wjtPY9QNu74YLUhWweWVR
         gdmkD8q6wzaE45fdA8ssuXh9GH74x4ehbCOqjI74nhmZth22CLUHu98p4T5qsDqwpeL6
         HV5BHWdMx1vFjVvfO1i+NdijGoNczvLstaGZv02YlJtVMC2QQcnlObc0bdSa5NLAGPHd
         yAzLcUi58UBXcOr/3E14tijwRLhRS7vk7bBMyf3Sl0bz9PCXu8Xow0zbQkwcUwNGaqYw
         SgE/Ur7RmiCjynCi7a+GOlV7Ut+6R88Z9tsjIibfJvPS1R6AdZrwyLc3lAgKmHTmErSb
         pMkg==
X-Gm-Message-State: AOAM53209n5UmrfYxzD+FABqU0NfCiaZ7M4RwSDpJ9VSUDMrJoz4Hl6q
        dqUF8cTaMQtWggyUhEaTrSYGVXYsuESRUg==
X-Google-Smtp-Source: ABdhPJyqEYNxlDaoEYNT6jFHr91oVocV1qB1OgUPbJG8yjXQ/TvR1OhN3dgteouhymDt6AoAJrI0Gg==
X-Received: by 2002:a7b:cf36:: with SMTP id m22mr2098394wmg.51.1599132387278;
        Thu, 03 Sep 2020 04:26:27 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id 71sm4312734wrm.23.2020.09.03.04.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 04:26:26 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 0/2] Minor improvements to b53 dmesg output
Date:   Thu,  3 Sep 2020 12:26:19 +0100
Message-Id: <20200903112621.379037-1-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These changes were made while debugging the b53 driver for use on a
custom board. They've been runtime tested on a patched 4.14.y kernel
which supports this board as well as build tested with 5.9-rc3. The
changes are straightforward enough that I think this testing is
sufficient but let me know if further testing is required.

Unfortunately I don't have a board to hand which boots with a more
recent kernel and has a switch supported by the b53 driver. I'd still
like to upstream these patches if possible though.

Paul Barker (2):
  net: dsa: b53: Use dev_{err,info} instead of pr_*
  net: dsa: b53: Print err message on SW_RST timeout

 drivers/net/dsa/b53/b53_common.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 
2.28.0

