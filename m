Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B9449275F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiARNlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:41:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242872AbiARNlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 08:41:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642513280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OjmFL8JLFpwgH42MBB6gml2GfGQI5Vtp3QaY21Donc4=;
        b=iiEmjCb1uJnvunEkuMUxkBf0LhJkzAYHfcnUGpiuW262DopI/nnjmHFcekFBBPM4fObkLI
        m3on0jIM+x5B72eH+ovPDVj71S6yK1jTnVRmHDtgqIDLko+lQ8COE+UEjCBeqBRN5mLFmw
        mIrexX2k0MuuW+woKqOB2e5zIl4+lnU=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-ih279em0MIGzxHv4BQ8BHA-1; Tue, 18 Jan 2022 08:41:19 -0500
X-MC-Unique: ih279em0MIGzxHv4BQ8BHA-1
Received: by mail-oo1-f71.google.com with SMTP id m12-20020a4add0c000000b002e13ed4f7e7so2116002oou.0
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 05:41:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OjmFL8JLFpwgH42MBB6gml2GfGQI5Vtp3QaY21Donc4=;
        b=3c5yXuZw7pHowxw5Tu2Py7loXiBKQC1D68NVJou0in7FeAyTMrvIrBKhmEOMnw8IJQ
         AmMEeEf/1TFvutDqQC2JFrGfT9BXReIUuiHgr3JeHf6mlBVPYtsm07sTjFxZL/jlftWs
         xFOUe++A4hcbMf7xc95NxT2/Y0rDWP5Wf3KMAa0eg2k290TSKev+fDJA+PVnjRgKpfvQ
         Kao3nXWLB9AZhvezC4CpG5RRSq6sjLkdTq3g5LKT2eUZRxexqg9RqnDcTaHLqri31KyT
         i6VvMtbdC6FNFuz3aFyHQGDW1JpHRkTfUCwco+wcGUItz9DCby7TMwWVtBRu2VKN9e0u
         KyUw==
X-Gm-Message-State: AOAM53339xL4v35Y9HEVgDxhOa03my598xCZIqzeGBl1x30tm27jMxav
        a4Tesz4a/UivK0BTIB8FidLGhr4MkBA7RiTAL5x9OBMSAemBYu/TD2IIomWIeDYCxiC+ltqZI3x
        eZbjfRGrew8HLh2HO
X-Received: by 2002:aca:1e0b:: with SMTP id m11mr1660653oic.79.1642513278684;
        Tue, 18 Jan 2022 05:41:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyghdC0ZhlAJPquJYviwFxMn7EFulClxi3MtgxmaXSfPu6GBNwy6CxT09cDO6MXpBK5Xk0YBw==
X-Received: by 2002:aca:1e0b:: with SMTP id m11mr1660614oic.79.1642513278337;
        Tue, 18 Jan 2022 05:41:18 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id f12sm6883770ote.75.2022.01.18.05.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 05:41:17 -0800 (PST)
From:   trix@redhat.com
To:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        xiaoliang.yang_1@nxp.com
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: mscc: ocelot: fix using match before it is set
Date:   Tue, 18 Jan 2022 05:41:10 -0800
Message-Id: <20220118134110.591613-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this issue
ocelot_flower.c:563:8: warning: 1st function call argument
  is an uninitialized value
    !is_zero_ether_addr(match.mask->dst)) {
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The variable match is used before it is set.  So move the
block.

Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 4a0fda22d3436..949858891973d 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -559,13 +559,6 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 			return -EOPNOTSUPP;
 		}
 
-		if (filter->block_id == VCAP_IS1 &&
-		    !is_zero_ether_addr(match.mask->dst)) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Key type S1_NORMAL cannot match on destination MAC");
-			return -EOPNOTSUPP;
-		}
-
 		/* The hw support mac matches only for MAC_ETYPE key,
 		 * therefore if other matches(port, tcp flags, etc) are added
 		 * then just bail out
@@ -580,6 +573,14 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 			return -EOPNOTSUPP;
 
 		flow_rule_match_eth_addrs(rule, &match);
+
+		if (filter->block_id == VCAP_IS1 &&
+		    !is_zero_ether_addr(match.mask->dst)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Key type S1_NORMAL cannot match on destination MAC");
+			return -EOPNOTSUPP;
+		}
+
 		filter->key_type = OCELOT_VCAP_KEY_ETYPE;
 		ether_addr_copy(filter->key.etype.dmac.value,
 				match.key->dst);
-- 
2.26.3

