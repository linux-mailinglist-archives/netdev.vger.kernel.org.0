Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E91232B3B7
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449965AbhCCEFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581335AbhCBSug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:50:36 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAF0C061D7E
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 10:49:43 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id k22so12549449pll.6
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 10:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ICT+rzXe6Uf7SYTOFwtfIOL39YlZQ7S1ZDWq8wbgKdw=;
        b=ls2q8gqX0V96FwSbFWk52WiMJyp+XvHetFkLhAkPpRym9jxonqOVaO8b+u2RFcpKE9
         dyggFIiZhdRX+hkFHWZkyj4ZqSqiR3/MrFOTvvJYeVF/RcWC39tC9ccobE9Ml+IBloZl
         Xa046p7c7N/sJt4/YyAwknUjv0hf2k1I+iBFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ICT+rzXe6Uf7SYTOFwtfIOL39YlZQ7S1ZDWq8wbgKdw=;
        b=lSY/6aVc8N9UNjlsy2/AHOcvQGNPHff8J8ad4hApNTMJx4UzVLcr9m9anxpa3EDRRJ
         F8LDZvQQsII/D6kNnyNxJv0nykL3xkmPF18nIwwmOMXixmRcEYQ1J05SdnRlRhLWNbzL
         zSqRy9Lr0T2U1cO0Ci2MrcndRKUjwXbUftPbKkWm9wEeUIyAF5VCl8HZp0R8f8lNLBZV
         Zjx5yEYtp/pIbPDj4ab7QEEQbOwjBRrGY/N8IajcImSLHWyCODoY8YhRH/MHrrbgO+NI
         wyw3fwSK839P40otFwIiJx1TLQQGhy59CsDr0KVvpg1DTRb++bGrfQcLGn+U/iC+22mS
         vrVw==
X-Gm-Message-State: AOAM533qHXcuMMsR7ThqR/o0oyaiNK3snGLMp1frusT4kWyEWbwk8Cg2
        MwjOvp34bfWG6V1OOKL/HnUhog==
X-Google-Smtp-Source: ABdhPJyUbr688nxLCQmvjUglkPWkLxdMy+8VrCxK/FGD23O7xIN2l+BsuOGpwYr0DvUCTB9bk7sDfg==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr5618286pjb.29.1614710983315;
        Tue, 02 Mar 2021 10:49:43 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:9c83:cccc:4c1:7b17])
        by smtp.gmail.com with ESMTPSA id 140sm21800839pfv.83.2021.03.02.10.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 10:49:42 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Hans de Goede <hdegoede@redhat.com>,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: [PATCH v2 0/1] Bluetooth: Suspend improvements
Date:   Tue,  2 Mar 2021 10:49:35 -0800
Message-Id: <20210302184936.619740-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel (and linux bluetooth),

Here are a few suspend improvements based on user reports we saw on
ChromeOS and feedback from Hans de Goede on the mailing list.

I have tested this using our ChromeOS suspend/resume automated tests
(full SRHealth test coverage and some suspend resume stress tests).

Thanks
Abhishek


Changes in v2:
* Removed hci_dev_lock from hci_cc_set_event_filter since flags are
  set/cleared atomically

Abhishek Pandit-Subedi (1):
  Bluetooth: Remove unneeded commands for suspend

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_event.c   | 24 ++++++++++++++++++++
 net/bluetooth/hci_request.c | 44 +++++++++++++++++++++++--------------
 3 files changed, 52 insertions(+), 17 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

