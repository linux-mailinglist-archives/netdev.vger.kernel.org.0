Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123A52A29C4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgKBLqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbgKBLqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:46:00 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F9CC0401C0
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:53 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id a9so14188694wrg.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xGhEowgdcWKuLXb9Pj9j/sbipGm9ceEZBmZdHTodzCE=;
        b=wKZjryqR/URTMssBcGm64w4KUfxhYG2WPxJQBrHlyVdGxCRdYxQammgX7+ShmZDJD+
         8LSA9+0F7ttyH3y1W3oMGPC7kLAaOCYlHQp9mUCIL6eYT04luKhFq5MlRBVa99tZeQPd
         u2mSCMIp4bxIq5WJOPtVbG3KSmCFXcmc4kRRpvLas+fOVCemv8qyx51AZXjpSpzrczUN
         zgN4y8kiq6c7lR8ix1Wfajl6SmiYrP8IffCOkZq/FSI20aGy4jw85PMlBBWE+zAH/T44
         BCESXXTqATDNCae+PemlLwGo5ZJcV+yYlfCJ/G4LWAafmpTvF3F8/kdFSzbNfA32+TPI
         Ue4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xGhEowgdcWKuLXb9Pj9j/sbipGm9ceEZBmZdHTodzCE=;
        b=CRJDXrXGIcfHgPyN9wHgLyAe8hI3iBxlfWRlEtSvudRvm0eDTY0LWfHZvG0xwajRnx
         rAHK//RNFg78KPjTpgehi8TK6YUzQdoqcCvi5hd0qCSn1FlXRrIBZijnMLdiKwD7T9Ad
         foZVvLwMH0PXBxwtQdsqj6403Qke4xYmszdh+U3hELL2V/UdLahyzPzj1JQ6IF5Tj17G
         EWr/RZ87DoOcOZav0knE91D1glSvq25ufkPZrxOnaeBQg+8UzvGub9SKuKeVT6qFBLGM
         13ZJBv5xe3kvDiSszDj2NIE2LdnyAo/1+beXnttGkyfz310JyG2G7x/BBhPtKbIF5uzl
         Si4A==
X-Gm-Message-State: AOAM531+JrSOQ5KzxkPqAl93vV/XPgyfVmPfKk9QzVAB8SJAuiFAjgLV
        fty3XcqwRPjONZWjrk1Y1oMYDw==
X-Google-Smtp-Source: ABdhPJyJAJryg0Y2/RgjMFbI+6TE1BgLepiCm1HDAowKJ0KbRJV00hGw+Q/Puf3A+TfrCF8Gv4wqOg==
X-Received: by 2002:adf:f90f:: with SMTP id b15mr19883731wrr.343.1604317551745;
        Mon, 02 Nov 2020 03:45:51 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:51 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Patrick McHardy <kaber@trash.net>,
        Broadband Ltd <ajz@cambridgebroadband.com>,
        Ben Greear <greearb@candelatech.com>, netdev@vger.kernel.org
Subject: [PATCH 26/30] net: macvlan: Demote nonconformant function header
Date:   Mon,  2 Nov 2020 11:45:08 +0000
Message-Id: <20201102114512.1062724-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/macvlan.c:1350: warning: Function parameter or member 'vlan' not described in 'macvlan_changelink_sources'
 drivers/net/macvlan.c:1350: warning: Function parameter or member 'mode' not described in 'macvlan_changelink_sources'
 drivers/net/macvlan.c:1350: warning: Function parameter or member 'data' not described in 'macvlan_changelink_sources'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Broadband Ltd <ajz@cambridgebroadband.com>
Cc: Ben Greear <greearb@candelatech.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c8d803d3616c9..dd960209da943 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1339,7 +1339,7 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 	return 0;
 }
 
-/**
+/*
  * reconfigure list of remote source mac address
  * (only for macvlan devices in source mode)
  * Note regarding alignment: all netlink data is aligned to 4 Byte, which
-- 
2.25.1

