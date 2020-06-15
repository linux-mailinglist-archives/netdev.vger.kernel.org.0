Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFFB1F8D55
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 07:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgFOFjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 01:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgFOFjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 01:39:39 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58104C061A0E
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 22:39:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n2so6323044pld.13
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 22:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pVTAL9z2QJC8yogPilM2xaZGGPdA9FdHY9ZXBKe7BqU=;
        b=gpsQ6RB91sIssS/rmhPulji77m8RG9oyqIdK0jBHshfCkG0jEig9fst3NIaZWOOqR2
         2/DmkS1NsYIwBoPyaNiiAd1JHvG9w0Rgd+WKvPDDTk5S3TSIP5lcW2KJK0l7XcF8tGh5
         M8sz9rsFQnGZm5BYJ1BhXg2Wd4eYGcZPFAWt2UQcuvlfOhgCgUn9pejIkVRsVBjloeRG
         ZSIO3lHydg9NPswNmjVjnYmDBQPKM4CidwToz54HlSokAOXvwuITB0HTYSzlZt8QbZ9j
         ISXZ/8frad8i9IybsLDHp1mlXxQ+9bIORAdAoQv+CU68rit5RDdySdpzHQfFJ7LMwDov
         FmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pVTAL9z2QJC8yogPilM2xaZGGPdA9FdHY9ZXBKe7BqU=;
        b=TsIZobQVrHAaW3h0C4iT7wkgtF+6UEIt7kCZg5q3KHChBR+lx4ViDNp4w1IKlTUPZp
         x+4M9IhGlmioOD/poA/x+6yfL8gQC3omu4ycnZyUJVHG9MuL4z2GxBGDZty5yasOUuxd
         gHWzy85tV7wV2GS7nNLdWg6twwdgoMx9xqJZwXSWDA5hYtroBz5D0DrvDCu2uMx5ch2e
         inrlmmyEViemHxjimPbFVDUdPPr2tuO71O0znBlCZACpNsj1HrSxRwohtyYq222LbUmP
         YXxHQSyS819Tpd6tItCJbBMLsFHcFTBFl7PpQ/G9swt7J0yFcyXGujGHEDGBkmNah0kk
         Y8Zw==
X-Gm-Message-State: AOAM531KQh1RHBNWH0HQcqqUoTPZrlG7OKn6zRXxLmQ8hd2VdFf7Z+tV
        g8bejkIQBRTP1jVaJCUrQRXvLYnU
X-Google-Smtp-Source: ABdhPJw1BNYWhx/0zqi7UxM1CAUN+IfML9K+UIyUkWBRzp5gMoAWZiXRZsdb7/h87KkGJ7e+WBeqjQ==
X-Received: by 2002:a17:90a:284b:: with SMTP id p11mr10514632pjf.22.1592199578035;
        Sun, 14 Jun 2020 22:39:38 -0700 (PDT)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([137.97.160.52])
        by smtp.gmail.com with ESMTPSA id a14sm12255199pfc.133.2020.06.14.22.39.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jun 2020 22:39:37 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Martin <martin.varghese@nokia.com>
Subject: [PATCH net] bareudp: Fixed multiproto mode configuration
Date:   Mon, 15 Jun 2020 11:09:29 +0530
Message-Id: <1592199569-5243-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

Code to handle multiproto configuration is missing.

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS")
Signed-off-by: Martin <martin.varghese@nokia.com>
---
 drivers/net/bareudp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index efd1a1d..3dd46cd 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -552,6 +552,8 @@ static int bareudp_validate(struct nlattr *tb[], struct nlattr *data[],
 static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 			struct netlink_ext_ack *extack)
 {
+	memset(conf, 0, sizeof(*conf));
+
 	if (!data[IFLA_BAREUDP_PORT]) {
 		NL_SET_ERR_MSG(extack, "port not specified");
 		return -EINVAL;
@@ -570,6 +572,9 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 	if (data[IFLA_BAREUDP_SRCPORT_MIN])
 		conf->sport_min =  nla_get_u16(data[IFLA_BAREUDP_SRCPORT_MIN]);
 
+	if (data[IFLA_BAREUDP_MULTIPROTO_MODE])
+		conf->multi_proto_mode = true;
+
 	return 0;
 }
 
-- 
1.8.3.1

