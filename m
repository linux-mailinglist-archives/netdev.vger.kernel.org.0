Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1322503453
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiDPFbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 01:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiDPFbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 01:31:06 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D017B105044;
        Fri, 15 Apr 2022 22:28:34 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-df02f7e2c9so9631449fac.10;
        Fri, 15 Apr 2022 22:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WdhLn0xBW1CBAGWGNiG+mlM/bnJbRbITdURA5inxlfM=;
        b=J/DK+1zC+eFUhCBlGmyqY+6nb5pjq1LLWFft9zwdP/dERv1sT3pazeT+o6gw2kKL+r
         Nw/eY9C2EoUtdkhknm82JpvuDl7sSxy7l036SWGnSVLPbwY5Hulh9pxAPDcQa+8Pvymx
         EUlp2yQIsEyAZRRPbFpXBYCcdnRpn5zGK5LWFWhQdVkFz5ALhzwAnfVrbXMcsuuo7s/n
         MQNavx5cnW/37/or5mSnKmdjydaiBBi5rxmqbP2mJcHJUAZ1hsfIZUiLABDTEeOOcrFf
         kIz0HrguXZzzN/8qRD3vc63pl1247DeiuuGC40qm9WGcYLM3uydJJGeOXYZy+u0kNu9j
         Y4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WdhLn0xBW1CBAGWGNiG+mlM/bnJbRbITdURA5inxlfM=;
        b=ZCrh8ZICia7TX+Bk0QhPTj3jeNVIKNY4AbCz+CAfW89bWCRDY0Xx9qfn6vSCu7ihb2
         SMT4zp7jQ5L1jcBPURLgHSYfJs8i07QFVQixeJYSnvUBj/nzNAGCK8mf0cpHxgVDGxQu
         C5ywrbriRkCiKKjzFGZ5m2ALe+aBbMHeok2nCptbMRIsnedEsHOqWHSAdrMSZ8EmrjkL
         xCSRfLM+0O8UJfgmpc54Kdenv8LFqumdjniF/7DfTfk5Rdahx7m6hRv3jHGFZmEhPbOi
         0okDiEGF1+u+FltSLhSfB+c9mEKISkoA0h0ulToHWvnYjQQyHHHE6YL/Xm3xgBr9RBaN
         gsIg==
X-Gm-Message-State: AOAM532ZUznFxFzH/jn40h5Nsnqzx5zIgZTEmBEx7RCjuKMlZD5VHrZi
        55QjYBA02acrVqWDHLfOHcQZyLWXJ4sh3Q==
X-Google-Smtp-Source: ABdhPJxOBI1/Jdl3xE5TP8Y3w37cCdw62EEbXRQS2wdKknpOvr7usGLBGNppua5vlcWX9tXw9krVcw==
X-Received: by 2002:a05:6870:3482:b0:e2:d03a:41e8 with SMTP id n2-20020a056870348200b000e2d03a41e8mr2453808oah.79.1650086913864;
        Fri, 15 Apr 2022 22:28:33 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id j72-20020a9d17ce000000b005e6b89f9f54sm1780775otj.32.2022.04.15.22.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 22:28:31 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, tobias@waldekranz.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vladimir.oltean@nxp.com, corbet@lwn.net,
        kuba@kernel.org, davem@davemloft.net,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3] docs: net: dsa: describe issues with checksum offload
Date:   Sat, 16 Apr 2022 02:27:37 -0300
Message-Id: <20220416052737.25509-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index ddc1dd039337..ed7fa76e7a40 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -193,6 +193,23 @@ protocol. If not all packets are of equal size, the tagger can implement the
 default behavior by specifying the correct offset incurred by each individual
 RX packet. Tail taggers do not cause issues to the flow dissector.
 
+Checksum offload should work with category 1 and 2 taggers when the DSA master
+driver declares NETIF_F_HW_CSUM in vlan_features and looks at csum_start and
+csum_offset. For those cases, DSA will shift the checksum start and offset by
+the tag size. If the DSA master driver still uses the legacy NETIF_F_IP_CSUM
+or NETIF_F_IPV6_CSUM in vlan_features, the offload might only work if the
+offload hardware already expects that specific tag (perhaps due to matching
+vendors). DSA slaves inherit those flags from the master port, and it is up to
+the driver to correctly fall back to software checksum when the IP header is not
+where the hardware expects. If that check is ineffective, the packets might go
+to the network without a proper checksum (the checksum field will have the
+pseudo IP header sum). For category 3, when the offload hardware does not
+already expect the switch tag in use, the checksum must be calculated before any
+tag is inserted (i.e. inside the tagger). Otherwise, the DSA master would
+include the tail tag in the (software or hardware) checksum calculation. Then,
+when the tag gets stripped by the switch during transmission, it will leave an
+incorrect IP checksum in place.
+
 Due to various reasons (most common being category 1 taggers being associated
 with DSA-unaware masters, mangling what the master perceives as MAC DA), the
 tagging protocol may require the DSA master to operate in promiscuous mode, to
-- 
2.35.1

