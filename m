Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956E524C59F
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHTSdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgHTSdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:33:09 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6CAC061385;
        Thu, 20 Aug 2020 11:33:08 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so3087202wrw.1;
        Thu, 20 Aug 2020 11:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XdLts6rvq2H0YVcIjGx4AO/NpE2Y7Q5mTkuY6ixaYlw=;
        b=dd3jcqufhs9QvMtTE8VBXBAaIsSjdXUN3iygiPJWGYBr4IqsQzKDX105bYva3z5Q5H
         nQgUkyCaPt1rgTVr3nK85K07MDfxciiKqh/KeVQT6YP4mAw0W2Rrfhhwz2zLplbT0GIk
         mOJCLkkpmGSVGInfQkHBlAA1Fo+dcLiC3O+OTsdmke5kvxE0au/vTcIuUIEutKWM+Bwa
         E7xSkNiylgV36nIARD/g36d3iFymiT6gpTjlQ0LKLISt9jFggZ34xc4XRRrMXEdzJXCx
         wu/K7dgL3DRMNcasm61KXwyLYu4ljOBwh2/MrCwkClMfaSn/+XhGb+RBcw9cFDuc2KLM
         GsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XdLts6rvq2H0YVcIjGx4AO/NpE2Y7Q5mTkuY6ixaYlw=;
        b=o3KTNSY8fLkBkToylNWUFOqENsJ0RH1pp78nugnSxtpZ4CQpeadla7wZ5OQr6O+oBY
         V8p8LhPWAHqu4oD8OCDM3MKtN4VoSZqrCLQO1iuyMpNQ3DbKo9szgrsuuV0XmQm45KQQ
         peRAoT4Yvs4GEUy8U32jP7RUonUqNPnIMWJ5lSeR/ClZvns5ZKpWa7Pil78qGnpJnlhm
         yei+Q+qOPMos7GScRB+sEnTAAz4BllWq5tUqU93lGWQtk3+qZ9xxWaZzr50pOmSn0eaw
         7QkjKrTWvPGm5KGfYLi6ivC+uPBuFwPVU2M0ZPHSVlDAPOCjxRkSdacXhkXia05TLj7s
         LJRg==
X-Gm-Message-State: AOAM530YokpuNc0MbxKKG5BsXsZeX9AMvaH/S76+NNM8f3OHpcm8gDGm
        /KDFP3cc2QMLAFUOssxKTEM=
X-Google-Smtp-Source: ABdhPJxTnvW3t/djwmitUnLC0YRx3lssSMdCd4S8WWUe32lIQpvrIFKMAILk/P7MPJwb5C8XwoOdBg==
X-Received: by 2002:a5d:6910:: with SMTP id t16mr54379wru.178.1597948387108;
        Thu, 20 Aug 2020 11:33:07 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id y142sm6176344wmd.3.2020.08.20.11.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 11:33:06 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     Alex Dewar <alex.dewar90@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: st-nci: Remove unnecessary cast
Date:   Thu, 20 Aug 2020 19:32:58 +0100
Message-Id: <20200820183301.902460-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In st_nci_hci_connectivity_event_received(), the return value of
devm_kzalloc() is unnecessarily cast from void*. Remove cast.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/nfc/st-nci/se.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index f25f1ec5f9e9..807eae04c1e3 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -331,8 +331,7 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
-					    skb->len - 2, GFP_KERNEL);
+		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
 		if (!transaction)
 			return -ENOMEM;
 
-- 
2.28.0

