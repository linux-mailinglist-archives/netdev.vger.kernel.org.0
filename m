Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001B6235767
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 16:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgHBOXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 10:23:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36105 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725917AbgHBOXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 10:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596378228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=2/kHNXwW/Okw1oeFagoA94XTuvPYMO2ieikygdNu33E=;
        b=Erj3Mq7sCoAsePSyM9uTtcVGmZNB5aknHoaeFRYUiebTKHGbxts3am1Ntp8osMpsmQ+BAV
        eYbAqbXculULk14YwXtmT/BErUb2rWz9pQp16OaXUnlWxHM0QtCIzUV0l0UOd1+egC0Lwg
        Hc9R6W3oFNb4b2HaP+4AgvLqli3gOmo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-g10c6ahHMUaRJ98dEvuWUA-1; Sun, 02 Aug 2020 10:23:47 -0400
X-MC-Unique: g10c6ahHMUaRJ98dEvuWUA-1
Received: by mail-qv1-f69.google.com with SMTP id k17so10347488qvj.12
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 07:23:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2/kHNXwW/Okw1oeFagoA94XTuvPYMO2ieikygdNu33E=;
        b=TA5x1xAQn2jPg6lm6he4VUFkkIcaEWaLPvtuftwRREBMKqAnZLovhYMJ74JJ70yEnw
         Ni52Dn15qracrsoAC+klC8cG/XJex6+7JrBQUYV36Qc2aBdFtZ5kXW9Q/qyM7YZ10Wpi
         DuYdxYw/byU8IEvx8DKVIVeGgM6cAOXtY7Q7/IgcGemPwSyrPRv3IXBKAtn5cBQWiMO0
         d9EOHFq9E2/Y7XsufEbHmCxYM54DeegFyUCivvVepxU9DYl/ayhFWszqcKnhFXl3Edjx
         cybUMuIx6nRpucxxl4OwolVpZED6cDy4yDIkxb5irZfyBi8X1ykUT6fJf2rj864kDk3c
         EOQg==
X-Gm-Message-State: AOAM532hlr9WxIB8kcs5HwwJphyt+iBHj1biTt/ucbQsPHmUpPWMxcIR
        Y4kCzo5m1I+XYt/vczeyPusSs4T7TIwNPva4/Dh4/I9JlLNnjG2KpbCbIJw8nH0X92qPGaz1UB9
        7Nksg9os74b8BaO0H
X-Received: by 2002:a37:62cc:: with SMTP id w195mr12855858qkb.33.1596378226330;
        Sun, 02 Aug 2020 07:23:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgE09Sl0MfhLOKvnnEluSkBTqBNuCaM3HjAVewFzyYuhdgdEgcM4E45wQlwXc1nshAvd3KIA==
X-Received: by 2002:a37:62cc:: with SMTP id w195mr12855832qkb.33.1596378226027;
        Sun, 02 Aug 2020 07:23:46 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id g61sm18050245qtd.65.2020.08.02.07.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 07:23:45 -0700 (PDT)
From:   trix@redhat.com
To:     michael.hennerich@analog.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org, davem@davemloft.net, kuba@kernel.org,
        marcel@holtmann.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] ieee802154/adf7242: check status of adf7242_read_reg
Date:   Sun,  2 Aug 2020 07:23:39 -0700
Message-Id: <20200802142339.21091-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this error

adf7242.c:887:6: warning: Assigned value is garbage or undefined
        len = len_u8;
            ^ ~~~~~~

len_u8 is set in
       adf7242_read_reg(lp, 0, &len_u8);

When this call fails, len_u8 is not set.

So check the return code.

Fixes: 7302b9d90117 ("ieee802154/adf7242: Driver for ADF7242 MAC IEEE802154")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ieee802154/adf7242.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index c11f32f644db..7db9cbd0f5de 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -882,7 +882,9 @@ static int adf7242_rx(struct adf7242_local *lp)
 	int ret;
 	u8 lqi, len_u8, *data;
 
-	adf7242_read_reg(lp, 0, &len_u8);
+	ret = adf7242_read_reg(lp, 0, &len_u8);
+	if (ret)
+		return ret;
 
 	len = len_u8;
 
-- 
2.18.1

