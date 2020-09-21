Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0DC2719D5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 06:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgIUEX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 00:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgIUEX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 00:23:28 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95588C0613CE
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 21:23:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r24so7189399pgu.23
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 21:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KBETbgHJRtwnWH3QRJ6V38Ec73b7Ro5YQIkQRswxAOg=;
        b=tJuzUxiw1SA9quuoXjslcjTek27JhLsC98t22DS3rNXHxHyfi9QHtNqsTtmZebk5e2
         /HWmclAyu8Ro01J4F3vQdTRr8Jf0YA64+XmaMQB+6hfU3cc2wD9YLcjdKkrHWZtG14JI
         IBs7U/3kpXNKUjzQ2sW1NLMHCSYlWvjI07HWDrMVWOoHrj5yxKVLXalI12rSBb+l7UaP
         R8WdyoYjR8SAWLwBiPluWLb6DbrVE/4OZyh04mOKQEDfBySB9lJ+0lEUZvRElvj0g6Qq
         g2VCB9QK//uRtVAgrUIBlTa4gqWQLqIIygz3Db2uNxtZfm8Oy77jxM6mOenqgIaPRpbP
         sDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KBETbgHJRtwnWH3QRJ6V38Ec73b7Ro5YQIkQRswxAOg=;
        b=JRhNwgb67qOS0GkrXUT2d5AxEqlXCEsSJd/tZtNji1UDBuALmX4ldE4OBjhUmE1ux3
         uZhhl/cJQjGFJuHWEKdu3JuC7PEwrcgz1wIW5wHl6xFucgT4SVB97T+zeRQuYlHy6UeD
         fFLhAtbT3JjtTV4hadVe/jKMp7MiuI08GYzUGUVI9H3Z/Ft3kcJOWhyIvxLXLsRD8a4o
         3qS+C+mgb8iTASEoMqTdxY73HmNzr6gsCrArmw5pt1WKou2zVqXWRwS4A+Ccr+pEavnP
         WzSsjW7AUe8We+DrHGsUc0UCN+XZRsvUsBwNpbClT0dUTzH3aeZHz9A/A0Quq4kIsWsB
         XYmQ==
X-Gm-Message-State: AOAM533TJdzdyrpKXlCfteskaJPEYBO7Kcl/slvDJRbcdNQKjE1tyAN2
        ZTqu6xKvG5vnB+R5lSPY9bwx2pnc8N7XeFUXNA==
X-Google-Smtp-Source: ABdhPJyBY4AJhf1noantDjUICD2bTO6IE5Zw0P4pyRPtpEdk8XdZ3Ir4ib1DpFYqwc56u6U0F6GiYNnFgaIJLfN9hg==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:902:a418:b029:d1:e598:4009 with
 SMTP id p24-20020a170902a418b02900d1e5984009mr26109409plq.67.1600662207933;
 Sun, 20 Sep 2020 21:23:27 -0700 (PDT)
Date:   Mon, 21 Sep 2020 12:23:07 +0800
In-Reply-To: <20200921122216.v4.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200921122216.v4.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20200921122216.v4.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v4 3/4] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.orgi,
        Howard Chung <howardchung@google.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds code to handle the active scan during interleave
scan. The interleave scan will be canceled when users start active scan,
and it will be restarted after active scan stopped.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
---

(no changes since v1)

 net/bluetooth/hci_request.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index d9082019b6386..1fcf6736811e4 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -3085,8 +3085,10 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	 * running. Thus, we should temporarily stop it in order to set the
 	 * discovery scanning parameters.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
+	if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
 		hci_req_add_le_scan_disable(req, false);
+		cancel_interleave_scan(hdev);
+	}
 
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
-- 
2.28.0.681.g6f77f65b4e-goog

