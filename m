Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0873425AAD9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 14:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIBMHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 08:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIBMHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 08:07:22 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E06AC061244;
        Wed,  2 Sep 2020 05:07:21 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so2187366plk.10;
        Wed, 02 Sep 2020 05:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1T6EMvFFNLUZudNoOgj0s3wkvH2sPer3XRVEffmaAyo=;
        b=ua/FvmEf5Wq5gwun7IO84daa9eJpuSmXTbhuIKr9zRgFnuAiKcoebQCqlUPnTkasvX
         T3avIr6C/OqsTwBsKlHz5hMYhvraOcxZADtD/Kq5ThMO4NeUVDuW+YsP75wzopIAFlvf
         +r3FgQ6972G3XLZTT0S3aIbG/iizTHeckyf46A93+WripS5P++nrPrPI/mGXF1PDdVYh
         qViQR0WJ0zeWb8Be5XgKBHK6APkXpiBU+Fq6a7NY8Yq1aeZP8jGcA/xDccvxXvGnscqd
         eCahaaKkxXkSjQN6qlWhkwXRiSKrJqP0KmvWgsaRjzYnYRm1FGSf451gFCnClfdhF27/
         989w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1T6EMvFFNLUZudNoOgj0s3wkvH2sPer3XRVEffmaAyo=;
        b=j3A1XekyhFpf0FzsSzSVVIhg2PjXYSYIakLAN4H20zpc47XvrOiHqT02KOHza78ZBt
         q7xD3H6XmV5KWVIVgV7g2HU3EZgmQoFoZvpjoWABVQPkFSoh9pjagkuOHoG5KQIvuKt3
         lgORRm6OSgZ2B2gWbj4qRQdPeWHrM5f+O8qD1d//0GgFghyPHjsWvasD5xg58Xji5IFN
         hl6okLLzvRdU1WRAsgVTXGnc9GFNDFEnHU2VFNV9S0sEiPQB86yfXyjVauRVDunJ1kiP
         IoDyKMhgDtg2zoRXptuWUt2XUQ9gW7I4jOsFeGFK6YgaDQo2XSANr9UUs0VNbSc+7Vm0
         n2sQ==
X-Gm-Message-State: AOAM533ZugF1SN4L4qQZNKMmgWfBab9j4lGflb0DwoxWDImW7SQgrdqh
        oooatPnnyGIf2sCWMLVAkJo=
X-Google-Smtp-Source: ABdhPJw7e1XNN4gEZ6ZmoszPk9PZjKzChf7ECXFYSmJGGWTPvk5hu/Rr5bgNGLeacbySK35s7gsAVQ==
X-Received: by 2002:a17:90b:95:: with SMTP id bb21mr1989091pjb.68.1599048440960;
        Wed, 02 Sep 2020 05:07:20 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:b49f:31b6:73e2:b3d2])
        by smtp.gmail.com with ESMTPSA id fv21sm4405169pjb.16.2020.09.02.05.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 05:07:20 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] drivers/net/wan/hdlc: Change the default of hard_header_len to 0
Date:   Wed,  2 Sep 2020 05:07:06 -0700
Message-Id: <20200902120706.3411-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the default value of hard_header_len in hdlc.c from 16 to 0.

Currently there are 6 HDLC protocol drivers, among them:

hdlc_raw_eth, hdlc_cisco, hdlc_ppp, hdlc_x25 set hard_header_len when
attaching the protocol, overriding the default. So this patch does not
affect them.

hdlc_raw and hdlc_fr don't set hard_header_len when attaching the
protocol. So this patch will change the hard_header_len of the HDLC
device for them from 16 to 0.

This is the correct change because both hdlc_raw and hdlc_fr don't have
header_ops, and the code in net/packet/af_packet.c expects the value of
hard_header_len to be consistent with header_ops.

In net/packet/af_packet.c, in the packet_snd function,
for AF_PACKET/DGRAM sockets it would reserve a headroom of
hard_header_len and call dev_hard_header to fill in that headroom,
and for AF_PACKET/RAW sockets, it does not reserve the headroom and
does not call dev_hard_header, but checks if the user has provided a
header of length hard_header_len (in function dev_validate_header).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 386ed2aa31fd..9b00708676cf 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -229,7 +229,7 @@ static void hdlc_setup_dev(struct net_device *dev)
 	dev->min_mtu		 = 68;
 	dev->max_mtu		 = HDLC_MAX_MTU;
 	dev->type		 = ARPHRD_RAWHDLC;
-	dev->hard_header_len	 = 16;
+	dev->hard_header_len	 = 0;
 	dev->needed_headroom	 = 0;
 	dev->addr_len		 = 0;
 	dev->header_ops		 = &hdlc_null_ops;
-- 
2.25.1

