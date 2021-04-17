Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E8D362FA0
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 13:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhDQLii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 07:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhDQLih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 07:38:37 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D0C061574
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 04:38:10 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x7so29102360wrw.10
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 04:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=eVMc07oV4zlE+ZLSK9XUNlvUXSzu0BaEt5ZjTVdpawQ=;
        b=f6qSjEzJe57e8v8oRPLd4e5EYd/CkxrzUbyVNHYNlkOUGV+OkWCMFANzrofc+Nslin
         hJGf212HWqrLY/YOJXBbu4KwiapoD0Oj7yOp/APfy5e95kGW7jwH2MIzPncZwO4zjaiG
         0IGL4jz1bvlhzUhlMd3Ox6KQ9SI/dQt9No/in90HDLi7ISr69vxSOniQwZ6uBMRoYF90
         sTLf4cjRnaFDZj/e6P0QlDeoVRGeLzSW1OKt8buj7euf7EiFwhvWeGJb0hFWybAQH2sz
         5XPo/2W84cVkDXlasuihO7OSZ91DjVMbM53NmqBjbz5HWJdTJdQbv38VBx5by8WI9so+
         7IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=eVMc07oV4zlE+ZLSK9XUNlvUXSzu0BaEt5ZjTVdpawQ=;
        b=FsqvjT5M099Pu/iWnKWu8Ac6m1nkQxRlccaCzdSCG9V0NUvP/GrOoMkTdH2FpmnC5I
         iAQXFYFmEsuhAgWNKbg+WoYMyJtpkNLTPCjrTYKiN4+XNq6Fo2bUGBWpT+wE/Iha8kl2
         1X+UT0DEZye3XLOpxWNNfVrY4U1dRpquYnJwZojN05PG6g6+4iNwUOC+u0vcIyxwEUIc
         ec3WR3ggB1likQzkigpoPSBRNGPh1mxwcCsOTGDealwBpbidOFmeDff9vQ14m38jWAMJ
         K3+tHtOwBV2NCI3yDWxYuc3fmRt4uoB8R4v2eUL/7eVYRfpj0Me9UTDm0N0B/koZdX4M
         EIwg==
X-Gm-Message-State: AOAM533UNnFfn++j/JPHFWPcBTPEQ9K3bYZ345zpP36juyOc16sM5xNs
        sYWdIASuA3Jonjvy5/Y/tU0UsWzh4g==
X-Google-Smtp-Source: ABdhPJxgZE5laF5+2fLOLoj6G7RQWGfcOeFlwlGASLuYQtxExE7e9LCK03XyoWG13IYXp30L8O2zSQ==
X-Received: by 2002:adf:fe09:: with SMTP id n9mr4047577wrr.284.1618659489403;
        Sat, 17 Apr 2021 04:38:09 -0700 (PDT)
Received: from localhost.localdomain ([46.53.252.24])
        by smtp.gmail.com with ESMTPSA id z17sm15058469wro.1.2021.04.17.04.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 04:38:09 -0700 (PDT)
Date:   Sat, 17 Apr 2021 14:38:07 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com
Subject: [PATCH net-next] netlink: simplify nl_set_extack_cookie_u64(),
 nl_set_extack_cookie_u32()
Message-ID: <YHrInysXIB+SQC5C@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taking address of a function argument directly works just fine.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/netlink.h |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -129,23 +129,19 @@ struct netlink_ext_ack {
 static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 					    u64 cookie)
 {
-	u64 __cookie = cookie;
-
 	if (!extack)
 		return;
-	memcpy(extack->cookie, &__cookie, sizeof(__cookie));
-	extack->cookie_len = sizeof(__cookie);
+	memcpy(extack->cookie, &cookie, sizeof(cookie));
+	extack->cookie_len = sizeof(cookie);
 }
 
 static inline void nl_set_extack_cookie_u32(struct netlink_ext_ack *extack,
 					    u32 cookie)
 {
-	u32 __cookie = cookie;
-
 	if (!extack)
 		return;
-	memcpy(extack->cookie, &__cookie, sizeof(__cookie));
-	extack->cookie_len = sizeof(__cookie);
+	memcpy(extack->cookie, &cookie, sizeof(cookie));
+	extack->cookie_len = sizeof(cookie);
 }
 
 void netlink_kernel_release(struct sock *sk);
