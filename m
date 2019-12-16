Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000B011FE87
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfLPGoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:09 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:47021 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfLPGoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:09 -0500
Received: by mail-pf1-f175.google.com with SMTP id y14so5027811pfm.13
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BFM6++6pj232g5zVopS7EPYCO+SS3KwTkhcwJUtE7ng=;
        b=Wzlh2y04CEykc8NQzWC5Ofr9naKEs2vMwJjDfGjvaEQuLx2xTJD4GOn7DHFRDd0kiE
         EpqQd0Gg377u9GDNwZD51xUjIMnq3L4JsNGUfoIwsiL+PYbwWyBfnkbLOj9luAB9H4ai
         T6CDclUEXGeXVDc5QVkBZ7Mqa8p04tXwrsHkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BFM6++6pj232g5zVopS7EPYCO+SS3KwTkhcwJUtE7ng=;
        b=uhedFg9r4KYan+i1QD23a9CaJ3rJ3kZEsPsaEpASlAfkHsTbs2P5f9+LssQBDDBtXc
         9zVWbZVB9BxnlJtXaIF6cggx1mBXu1dnhc+K34epfEfuz9Ol7pjEW8VbsPdU+/j81zkc
         /vyZioUpRjmvSJUVIgZEV/cYfBp1F+JsYJxIZ+b+qF84upntYPxrx/r1NcbXOkQApCsw
         F9TvSO4y7Md3QyNnXlL+MctOeX+5ITHdZ43o5gDSSE83Y9ty8sF0cQ9WYi1cprroTGz8
         mQGSZpiWq45cY5gSzKnj3lxMaIzSWmJa5++2TsNTE/HamPS5kNIMDRynqO2sby1c1pA5
         N7EQ==
X-Gm-Message-State: APjAAAXxzu9LbOO5m6uYeRiKI9rWJiFRFHAOLbYA7oClvWggOuQ3PWUk
        nkq41vg1wq0MdM4iQUTzpIq+faN/HWE=
X-Google-Smtp-Source: APXvYqw31QaIu/qVtaKuZ2UeEwbkHSmcXYMYHUdaR1JdigTtRjNhGoANf2Co6kaiyZOtn8avQ3myjQ==
X-Received: by 2002:a63:5818:: with SMTP id m24mr16343142pgb.358.1576478648483;
        Sun, 15 Dec 2019 22:44:08 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:08 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 2/8] testsuite: Fix line count test
Date:   Mon, 16 Dec 2019 15:43:38 +0900
Message-Id: <20191216064344.1470824-3-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a substring match is not enough, ex: 10 != 1

Fixes: 30383b074de1 ("tests: Add output testing")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 testsuite/lib/generic.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/testsuite/lib/generic.sh b/testsuite/lib/generic.sh
index f92260fc..e909008a 100644
--- a/testsuite/lib/generic.sh
+++ b/testsuite/lib/generic.sh
@@ -121,7 +121,7 @@ test_on_not()
 test_lines_count()
 {
 	echo -n "test on lines count ($1): "
-	if cat "$STD_OUT" | wc -l | grep -q "$1"
+	if [ $(cat "$STD_OUT" | wc -l) -eq "$1" ]
 	then
 		pr_success
 	else
-- 
2.24.0

