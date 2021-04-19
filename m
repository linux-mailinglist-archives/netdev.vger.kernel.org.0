Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F762364EDE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhDSXyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhDSXyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 19:54:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C30C061763
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 16:53:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s34-20020a252d620000b02904e34d3a48abso9496030ybe.13
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 16:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eI+2lB2i0zkJaQIbQM7tK6wekgIsPHxRzUo5leb4rj4=;
        b=iGdhwBvLpWOvkaGIBS8myhQnNZLBWSQrFRI8b3G9Ueq7noHNfiggS5avakde/q9iIj
         jEtEL0gzVGSLALYIL46/hyn6tqLyMAUH4PzBJCc+u7IY4/VqV/3Bmy+SQlPiN2orQxsp
         8xSJT2yhKAJ9um/BXV1NfRSbxt8+D8gXPD22yt4vOIHBJRtAkZOtJY43+KKEr5KtdIUh
         nqNj71V+YzufEOflDJbH/Beasc8KnDQZfw0rM+2dyNsU7/zwn80fYBy9D+HjaNgy7hp3
         6uUygoUEuu+Qa35cdbc+MgSkqJ1FkpjMXKQK9sEYzD837QmQFsJRcUee6/IsGayJw4rm
         Rvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eI+2lB2i0zkJaQIbQM7tK6wekgIsPHxRzUo5leb4rj4=;
        b=Aa8tWfmHEo/u3tO4laN3Ogy7YWBsDEzoXOLYEJEdnbg68iFLnMeisrDCcxal14EUNf
         ly8FakyRdS41zjvTo4QoLm7BsdzfPzxZNUJE4XiS1wSPZzztEH75jZLotp4KoByXxkxw
         9Ph+1zku2R3RUVED72rIYGosjlIeBeyrPBAKn1DTtv956WoHHXOPLusOD0FqBEVT3gdk
         5GJdpyG2gcQsEdbfTAwED5uRLSaykPIKJy010zMIZflh1iTbE/t8NqSBIiEathdPKH9Y
         sDMkTUp9fFH3Txzl/DqGTzkNmgqmanT5R6DkO1zIOOw/O8YjFF71H0N4i2H6zQQpiKIl
         j2Ew==
X-Gm-Message-State: AOAM533GHvC8z+nSUHUvcU3vCVj6axQSbMX3NE4bMq+rtBvP3jm4XtaJ
        l/cZ5bFqXe4spOP92OmLsvCaiut7QlaM
X-Google-Smtp-Source: ABdhPJzyQMvShZV2mpRVxeIT+bd4q84WPlLqmiWLMbNsGXJlBE9QHedcRcR6GFBjgErUEyjnVAmHDpsg0VOS
X-Received: from yudiliu.mtv.corp.google.com ([2620:15c:202:201:ad3b:b707:fe95:d739])
 (user=yudiliu job=sendgmr) by 2002:a5b:152:: with SMTP id c18mr20397176ybp.4.1618876416181;
 Mon, 19 Apr 2021 16:53:36 -0700 (PDT)
Date:   Mon, 19 Apr 2021 16:53:30 -0700
Message-Id: <20210419165323.v1.1.I9f9e8bcc849d91c1bb588a5181317c3e2ad48461@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH v1] Bluetooth: Fix the HCI to MGMT status conversion table
From:   Yu Liu <yudiliu@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org
Cc:     Yu Liu <yudiliu@google.com>, Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0x2B, 0x31 and 0x33 are reserved for future use but were not present in
the HCI to MGMT conversion table, this caused the conversion to be
incorrect for the HCI status code greater than 0x2A.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Yu Liu <yudiliu@google.com>
---

Changes in v1:
- Initial change

 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 40f75b8e1416..b44e19c69c44 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -252,12 +252,15 @@ static const u8 mgmt_status_table[] = {
 	MGMT_STATUS_TIMEOUT,		/* Instant Passed */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Pairing Not Supported */
 	MGMT_STATUS_FAILED,		/* Transaction Collision */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_INVALID_PARAMS,	/* Unacceptable Parameter */
 	MGMT_STATUS_REJECTED,		/* QoS Rejected */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Classification Not Supported */
 	MGMT_STATUS_REJECTED,		/* Insufficient Security */
 	MGMT_STATUS_INVALID_PARAMS,	/* Parameter Out Of Range */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_BUSY,		/* Role Switch Pending */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_FAILED,		/* Slot Violation */
 	MGMT_STATUS_FAILED,		/* Role Switch Failed */
 	MGMT_STATUS_INVALID_PARAMS,	/* EIR Too Large */
-- 
2.31.1.368.gbe11c130af-goog

