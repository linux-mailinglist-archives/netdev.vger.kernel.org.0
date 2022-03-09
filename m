Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1E44D3866
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiCISDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237312AbiCISDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:03:10 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584C4F8B86;
        Wed,  9 Mar 2022 10:02:10 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id y27-20020a4a9c1b000000b0032129651bb0so3854711ooj.2;
        Wed, 09 Mar 2022 10:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mBlOVX0NXRJuM7V7BhS1Yc8WsbiXTu+ggP9Dq+jvbng=;
        b=LHd0NfLaHbvBKe3Uq0ZOKggf6d+HcX9lA2Wy6AVpNPCL5XGB61yJT52s+4Wf4h0T6v
         gxaUjPJq6C1VnwJyadIaRDrymwSgxkIOpigmpwP3XmWGZfLRocA982sRUFrRURigBnfj
         Oz50CSmooN0YmGffy99Lpuxbw3AbqK20TMnaDOAWtT0zDGuQ4wFAD8ncQPvvO+xhJeeW
         rgUHaFqMV6O6vYOVcZn5uBLkrLU0fgTeHZQlrm9+H/rSbMki3sY2mrSfqIenUlUnt6d6
         hKCQMmi7sIvurQIbPKPUfu2aKmc1IxMFWMXkXS6zAfc3/5UfMkMO667gauxp04c1PLtB
         +45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mBlOVX0NXRJuM7V7BhS1Yc8WsbiXTu+ggP9Dq+jvbng=;
        b=f3YrpuReI9S+OSrzPpwpYOGGkm2dYvq/8A1mbFRU8IAdQlBNyHrdWBRfSksyOgMWdD
         kN880PTYtuyEKbMk3jeI5+h+0664224dUqvFZ7vhA566N8RtMw8qGs2QWkL3RjrLQMiN
         3Z+BV4K5+1B8xL5rYIMNcRzu2ZRZCOxnBu9koCwqQbEnKdoeHnhHx9dpv5I4c2jNxHN5
         8/tmJmOuWibaPkYuBqQwwBl5y0ssCKj5IJx2ijYKOcZv3qJGvGKLw7aFro040PwXvtlb
         C+yVelvwODHujSHjn+G+nIS4ukcxFy5Lm7dOFgGH9LACMkuzKw1KDrHWIAdIdedt7F/9
         nDlw==
X-Gm-Message-State: AOAM532L2R2cxZC4XFy30/6pHcAYIXUezceIoZyRqex9VqP59FWXZp36
        C4GV9JHj/L43ghN2zDMsRw4hH0ED9iHyUg==
X-Google-Smtp-Source: ABdhPJziZIS+5ZU35znffxrn4eSvbE5Mvef0c5Y3OY+DRRFLLhiLIbVFN8f034gZmy/HqhBNTxwaHA==
X-Received: by 2002:a05:6870:2389:b0:d6:caf1:9c72 with SMTP id e9-20020a056870238900b000d6caf19c72mr5889029oap.16.1646848929425;
        Wed, 09 Mar 2022 10:02:09 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id c8-20020a4ad788000000b0031ce69b1640sm1255287oou.10.2022.03.09.10.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:02:08 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, tobias@waldekranz.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vladimir.oltean@nxp.com, corbet@lwn.net,
        kuba@kernel.org, davem@davemloft.net,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net-next] docs: net: dsa: describe issues with checksum offload
Date:   Wed,  9 Mar 2022 15:01:49 -0300
Message-Id: <20220309180148.13286-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA tags before IP header (categories 1 and 2) or after the payload (3)
might introduce offload checksum issues.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 Documentation/networking/dsa/dsa.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 89bb4fa4c362..c8885e60eac5 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -193,6 +193,18 @@ protocol. If not all packets are of equal size, the tagger can implement the
 default behavior by specifying the correct offset incurred by each individual
 RX packet. Tail taggers do not cause issues to the flow dissector.
 
+Tagging protocols might also break checksum offload. The offload hardware must
+either be able to parse the proprietary tag, usually when it matches the switch
+vendor, or, in the case of category 1 and 2, the driver and the hardware must
+be able to use the sum_start/csum_offset adjusted by the DSA framework. Drivers
+that enable the checksum offload based only on the network/transport headers
+might wrongly delegate the checksum to incompatible hardware, sending packets
+with an uncalculated checksum to the network. For category 3, when the offload
+hardware cannot parse the proprietary tag, the checksum must be calculated
+before any tag is inserted because both software and hardware checksums will
+include any trailing tag as part of the payload. When the switch strips the tag,
+the packet sent to the network will not match the checksum.
+
 Due to various reasons (most common being category 1 taggers being associated
 with DSA-unaware masters, mangling what the master perceives as MAC DA), the
 tagging protocol may require the DSA master to operate in promiscuous mode, to
-- 
2.35.1

