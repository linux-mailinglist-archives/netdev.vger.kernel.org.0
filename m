Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426E42D1ECE
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgLHAN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgLHANz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 19:13:55 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE93FC061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 16:13:15 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t37so10545619pga.7
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 16:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jDwNXbiJ8Z2sxaEdWrtMAFonvwN2YLjodC+16pA07b8=;
        b=LHWWMFT9u/U2fnJvx41Xx/NSzc+RV7L9B3jAx6zwyPMZE3X8VnFooVBCyLKrl7uyY/
         3rDJxXOHNhuQbOsXhwVMVO2WT+ff9DocL50LU87CrtuxYlEhASmtsblD13ahwCwcfq3M
         i5E+9o8h8+l+Y4FiDRQRPexYxDYCiJJ8f6rm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jDwNXbiJ8Z2sxaEdWrtMAFonvwN2YLjodC+16pA07b8=;
        b=P+eqY5C61LieSWnoaL/CbPw6GN33hFtwAyeAzqvCicHY0/bPoxSW1LJ1yU3P5jmNex
         5VF6UGpyWQWg57+3X8vpfuPKg7uh1kCfXzPTHT4RzIlEXq4HgbDihc3+sCc9FO/PuHFk
         IgE+m2mVpx1QhaTltU95y/7Xw93QkkEPd7YYYPL+kHt/I7BNcqmg/WJauWJjqHRAdfXG
         rv1EPS4vKvMg4JYVZoUlZ4XnbRFENaVL23VlxhmmxmLXWFT20zNdQ5LJBGm6VP+XKxvD
         LtSeAQIlHWVY+wzySKzVQ6ba+YB5kQWeorkr2m/2Mq55vhs3lPsuQPKlR3sIwQSj46d9
         LN0w==
X-Gm-Message-State: AOAM530epakT6yEZ5PBAJjN5GS0XnXIO4Eu9OCgx7+XQKexp5GhIAA5f
        YrgcWSf/uczt8gJuNJsyqPJJhA==
X-Google-Smtp-Source: ABdhPJza2GAZ9j8CMf2rSaLa7BcKFmO4JIdbZcvzE7/dUbAKD8S3LTUGjsXMRghhcnAWAWqqL66+Tw==
X-Received: by 2002:a17:90b:1882:: with SMTP id mn2mr1261561pjb.236.1607386395193;
        Mon, 07 Dec 2020 16:13:15 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id v8sm514214pjk.39.2020.12.07.16.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:13:14 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        netdev@vger.kernel.org, Howard Chung <howardchung@google.com>
Subject: [PATCH 0/1] Bluetooth: Further improvements for suspend tasks
Date:   Mon,  7 Dec 2020 16:12:53 -0800
Message-Id: <20201208001254.575890-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel,

This patch further improves suspend handling by getting rid of the
separate function used for always configuring LE scan. Instead, we only
configure LE scan if it is necessary and properly set the task bits
depending on what actions were taken.

The previously sent-up CL was incomplete due to a merge problem between
ChromeOS and upstream. We merged https://patchwork.kernel.org/project/bluetooth/patch/20200917164632.BlueZ.v2.4.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid/
but the upstream version didn't have the same changes:
https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=36afe87ac10fd71f98c40ccf9923b83e0d3fab68

This fix was tested after reverting all our local patches, applying the
upstream patches and this patch on top.

Thanks
Abhishek



Abhishek Pandit-Subedi (1):
  Bluetooth: Remove hci_req_le_suspend_config

 net/bluetooth/hci_request.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

