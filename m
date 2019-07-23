Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5717220C
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392318AbfGWWMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:12:08 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44979 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731354AbfGWWMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:12:07 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so85126319iob.11;
        Tue, 23 Jul 2019 15:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ONcEgh2cJ4LWH4bp8qCcoMB2OgqjQB3F8II2dFP28qc=;
        b=qaC364b7ZOZynBML7b/waUhHDBbWtt507F8bRf4NnvzkXtAl0UHP0V5xb3V1L9+L6p
         SuIDoUYzetgI5j0A/mdbo6RF7w+ODEqwIy9mqAzefAyjfLmmB+ATg8Oe/juaFHENWBRg
         1ksuk4cbQnsODc/34qjm9sBAAV6zsr195PTgjc0gSYX+H12/c8hkS5hWEkjLdLjy8g9l
         c32JlloIlxGbs1StmGnkhHPQzRLDjVq4+l49AnmxQkTmVtbqaw9YsHeGkaZHRy8M4d7J
         B/H0OyaAIDL4cjrlmO2a/QmeHjcMgILdxGXa04sY1sF7KO+Y1vc+l4Y3AKFB4NcSeCSU
         Wxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ONcEgh2cJ4LWH4bp8qCcoMB2OgqjQB3F8II2dFP28qc=;
        b=p0yFYLAJ3664VBYrAOJh27nLtc7mp4WGNWl+k75U7f9F7HF7Zy1RE+iQqwUaluAQMO
         mo8K66VfMAXi/4uADHwPQriOZYDk8U3WO8gk0p//rXwjNGE6Xwg3w3i9aOoUqYTJ1foa
         QjDKEy/Kaw+4/iNtNj7o0v4j4qFbgsFip3X1mawbMWQ2K6J7Q+YzjaYKyXOvOAp36+XT
         nXng+OEsmQ5/DiDHDwzqnyuqzWtm1u/7JkGCFsMtxtvwATpere6DspzQJCD0BEtzRvh0
         egQXqU2KV4uiq8OwKr5ormPZbNUnWCuW0VQk6fPQnh7xvOw7c58z4KnlJpWIihDo5uUw
         LB9Q==
X-Gm-Message-State: APjAAAWS6nqLQxg90LyHCd7+wR9M5TaetY43Dw2mx5f3GOfZS5P7AAO6
        QYkG9OtBfje0NdI3wIDnKRg=
X-Google-Smtp-Source: APXvYqyiGvZXhuQYEG0dZHSvWBqg9G23NfGn4pEMz2uAg7pVWcv17qYGtdJv3K5+h8LmH0f5y47h/Q==
X-Received: by 2002:a6b:5a17:: with SMTP id o23mr67864631iob.41.1563919926819;
        Tue, 23 Jul 2019 15:12:06 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id t133sm64579056iof.21.2019.07.23.15.12.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:12:06 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] st_nci_hci_connectivity_event_received: null check the allocation
Date:   Tue, 23 Jul 2019 17:11:51 -0500
Message-Id: <20190723221153.6701-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kzalloc may fail and return NULL. So the null check is needed.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/nfc/st-nci/se.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index c3e10b6ab3a4..f25f1ec5f9e9 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -333,6 +333,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 					    skb->len - 2, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
-- 
2.17.1

