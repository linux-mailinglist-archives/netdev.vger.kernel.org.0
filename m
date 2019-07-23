Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C103721F2
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392289AbfGWWEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:04:43 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35842 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389193AbfGWWEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:04:42 -0400
Received: by mail-io1-f68.google.com with SMTP id o9so85286219iom.3;
        Tue, 23 Jul 2019 15:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Dcq7GaULRwTyw6H+WNhrW6avgxyobmt81tnNwJ/fCdY=;
        b=hG7YIqXxNfpm/v/2a1gq+4skRYWmtSDMq31K7fptH+hNI4oCCkiJXDCQNT3CHVHR5H
         vWz9uFF2o1hGooERleAJgfKpL0POUKLAR7W6EZMcRElPdhkFljLm7sjdUCJJE7fu4uSX
         zc574DBnqIyPsSABdqGCv8ZKD72DuvzRwXbRrJcWkVbkxQYGOxP9o2E8MtO9Ra2u54YW
         SyYpjgA+ojGFLrGtxWJfHEJqlP6bw1TNmvVzcr96IkA2GIB6uAyP3ucngc3GiUa1/EbA
         TPqIs2iq+l7wgVqkEZ6Ox16rJ0W9+BNSxjVaCTOQIsn1oQoH386USRdiRUIwlPftto1W
         6s/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Dcq7GaULRwTyw6H+WNhrW6avgxyobmt81tnNwJ/fCdY=;
        b=oyvLpE913c7L09w9vLlzCU2A37lG2qVuyVX6gqu81QExzHxIUPskmc7Q5AxZYSjB3u
         31sDnGb2Lzd588SHhRLqGxo8PYsiQAmqn2nua5P5bJFRM38j15xqcLrAxQj8QRVSPFGY
         9u9kV+PBNWLFLrWtJsK7hRsjykJE6SGe0O5qIiBGuR5NusEFiDwPrfC1yOvjng77Z/sV
         SkkZlXg7+4n7tZy0fguGT3/mFJmVoqHoFR6XbOZoIGtkiFQdHNW/2hKwuG2bRf6/XEyq
         qVyPpPcoRAmvMbIIzUbki+pCAjHUYABwULsYt1o+K8EI1/Bw7BdkJb6tszcdzRZKW7qx
         A2qA==
X-Gm-Message-State: APjAAAWklZBLkdnLShd21RwGHrEH1JCsOkgvKn7jOGjqlabOIHoYVLOH
        L6fXJM/ZJHZ5VRY6VQJydss=
X-Google-Smtp-Source: APXvYqwNqmP9HNx3b0cJI/Xgktzx1y4ggUOBK5iARgUlDKREKuf7s0bUPNO7oU6nrNfZs9gxMCmOVw==
X-Received: by 2002:a6b:8bcb:: with SMTP id n194mr75767439iod.194.1563919481847;
        Tue, 23 Jul 2019 15:04:41 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id s24sm36867593ioc.58.2019.07.23.15.04.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:04:40 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] st21nfca_connectivity_event_received: null check the allocation
Date:   Tue, 23 Jul 2019 17:04:30 -0500
Message-Id: <20190723220431.4923-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kzalloc may fail and return null. So the null check is needed.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/nfc/st21nfca/se.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 06fc542fd198..6586378cacb0 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -317,6 +317,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 						   skb->len - 2, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2],
-- 
2.17.1

