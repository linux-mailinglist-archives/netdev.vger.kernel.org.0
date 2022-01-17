Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E0490FE2
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiAQRu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiAQRuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:25 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA08DC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:24 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso30726815pjo.5
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ORemWkIgIhYpjv2L/896OhU0cTQPr2PhxjAVl6VzpJo=;
        b=A20XI7fVO9myGhGqVsc09xbRKfykBjeDSLYwASBEmKQKEne7ApZQ+ggYa2uxfWH6jd
         XeZ1g5cD3fabJsLK7dZeJYFx0nJTKSPuNmiSe0LRmUfuqYkG2MnjRM+2pa584rkTJOpd
         p1c0hWN0TMk7LJvMbnccqJQATCkn8iIlAf2NPcJZDJ7Q8R53FeYjsK4F0LusMtzLMshz
         4nJQR3zJ0QEqaC+cxfF+AdxuhkianrwMNa7JPR2kmE5TH6rCM1SCE23Jd/EFZrIo27V3
         PzJlwNxaQWhUwDTHvY51c8/J1tsbQXe0jRTzvaPL8z/9T3Crqqn2XHVFwgudyB+xrDjj
         MFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORemWkIgIhYpjv2L/896OhU0cTQPr2PhxjAVl6VzpJo=;
        b=maF1+BDureeiRPtqH07ECmpPjV7U84HnWlf/ioQAvcnIW8Yst+qvsYoWvAwFruqFsW
         vr+3cNmwYqxfIO+YryMOVb/LkwVMxboLMtR7pqz6KXAOXHdJ4F785mGnVvRANifdvP6w
         3B66mChc4YKqOiJLCTytRZ14AbSPP2AliMvU8R7huFCcKkYP4XaUpGz+x0b2dBeiTXFG
         k1VX6mijUxPoVwOdQovYCaeHJEYZPFA4pS/kDqMshh4B6eelDNvsoZu5jvoW5eNrwmfT
         /NAN7MVAR0K7oYOvXC+O/QODRohEnAmbMUzGlC2rbXe+DA6c5WSGY3Tk61kHKmCzIVWj
         8SMQ==
X-Gm-Message-State: AOAM531BSbozjyGcL+pujYDugclZlgpGovz2/auLowcgr+SUa5v53CqE
        m4wD9+qNq4YMnQy//9Lpl27Buflq+357GQ==
X-Google-Smtp-Source: ABdhPJzIno6OcUUVrbeRNNckNEsPKwzun7tqDCjtgsaHJ9upWHlBSmK+o9tDYCh/CbWj1KbT8tiB8w==
X-Received: by 2002:a17:902:82ca:b0:14a:bd99:5566 with SMTP id u10-20020a17090282ca00b0014abd995566mr5475347plz.41.1642441824007;
        Mon, 17 Jan 2022 09:50:24 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:23 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 02/11] utils: add format attribute
Date:   Mon, 17 Jan 2022 09:50:10 -0800
Message-Id: <20220117175019.13993-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One more format attribute needed to resolve clang warnings.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/utils.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index b6c468e9cc86..d644202cc529 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -261,7 +261,9 @@ int print_timestamp(FILE *fp);
 void print_nlmsg_timestamp(FILE *fp, const struct nlmsghdr *n);
 
 unsigned int print_name_and_link(const char *fmt,
-				 const char *name, struct rtattr *tb[]);
+				 const char *name, struct rtattr *tb[])
+	__attribute__((format(printf, 1, 0)));
+
 
 #define BIT(nr)                 (UINT64_C(1) << (nr))
 
-- 
2.30.2

