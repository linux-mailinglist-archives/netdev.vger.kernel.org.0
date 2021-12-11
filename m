Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9EB47106E
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345915AbhLKCGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345786AbhLKCGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:09 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A8EC061D60;
        Fri, 10 Dec 2021 18:02:26 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r11so34623812edd.9;
        Fri, 10 Dec 2021 18:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5OJ4KZ3Wvo0KL3MZbU9A20ovDpRwukmdDwNvqmPd5Z0=;
        b=n1zkX+Nni9OfThZuFNgI4lW5mbz7QRR+2dWXuLX1kzPM4JFtGOSN/CnHeUq9iTaZSE
         2tXtfd12vPtU7+pAH07RpqKZhxvS4C9cdokrzyNfSzIIK3zH0IObi1cKrZaOuKmAy95B
         o7GRF3RzKEXaFe63wC50IOfeHijGIY22V1CAD53iGca/XKshRxnJ3OTB76lso39OpRqy
         CXvelAXYqDF8BZablr2pK/L2v9LZr/OTLQN9DmLrWfEYEaMNgXazxa3Buhyn+2/RrtTR
         y09dhbhAgTZLwniTMtby9PO1g4VfWEg+QzQONXPRiMsxml1XtNB29CKzqtsI7uhUBs1n
         BkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5OJ4KZ3Wvo0KL3MZbU9A20ovDpRwukmdDwNvqmPd5Z0=;
        b=Xk7SwsYCJ2jXSyfhwGoqUiJYHkM5gA4ExiXYFKug/UYYurWfNNiXUafvi4Ca1iHwOT
         nDF3Gq1vek7mESs7UQf53pBdSmhBGHc+NiMT7imZOcrWDtqECuCG5omctJms1rJdBNFV
         LgEjXb5+GI17ZKWkeadERSKr1lJy7eODIld5viL35J26C4qyfWx7Jjx/AJSnnf33vg4a
         W/rxQiBodkLNdFT5FRXLsIS6OMPpQfsD9Fu87gKRPmZ3RvE3pnp6dCvz9t+WicC0UeeM
         YKvq9pK/A8NkBazp2xASelo5DwFtsivdN9bkV99TFHaHrXWjjbJc/uAaeBKWLQ6ZPlTS
         HvDw==
X-Gm-Message-State: AOAM531r6qEWGIr4JazNuOvWKdZL7IB90Up0+5o4Qjh2JP2aBo8DwtaI
        rOpJHD3qUw+aIZjdVZrc6zM=
X-Google-Smtp-Source: ABdhPJwtKzlrLPrxV0lQoASDY1a7ZBySnV21N8wPE5rhDekbCgJ/ex49/cXlRZntm3k1ScIEmEQ7aQ==
X-Received: by 2002:a05:6402:5c9:: with SMTP id n9mr43424215edx.306.1639188144829;
        Fri, 10 Dec 2021 18:02:24 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:24 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 07/15] net: da: tag_qca: enable promisc_on_master flag
Date:   Sat, 11 Dec 2021 03:01:39 +0100
Message-Id: <20211211020155.10114-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet MDIO packets are non-standard and DSA master expects the first
6 octets to be the MAC DA. To address these kind of packet, enable
promisc_on_master flag for the tagger.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/tag_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 34e565e00ece..f8df49d5956f 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -68,6 +68,7 @@ static const struct dsa_device_ops qca_netdev_ops = {
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
 	.needed_headroom = QCA_HDR_LEN,
+	.promisc_on_master = true,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.32.0

