Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811714FC7F2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 01:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiDKXFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 19:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiDKXFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 19:05:48 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A6C1C120;
        Mon, 11 Apr 2022 16:03:32 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-deb9295679so19010317fac.6;
        Mon, 11 Apr 2022 16:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ryqgiSf02C8RME8gbpqdqWHQXz1iF0ms7ybIkewvqM=;
        b=YYId1C0MNJbZWRPrH9i+16EdBv11RnpvpqQ5TTxAuzo5UpF/pmxZ3/pn83wlhTTe45
         MO6Cj2kf5LoVXxX2xvyxTNZtXMnV3uyRpH1UcyPeuzO597P0g+UuWMuj/C3gmulVJukr
         LHxnQVWxLHSJFCmTNC1RFWa4em5ptiRdvhqZQrlfdneH3zZps76s2OCEkJhGYVd9Sb68
         6uy2GBFIOkaLyvu9ScmkYrdP9Je2QTWg3LI+yQVUglJwWA9iFcI4N4v2pYj5NO8QcEK/
         YEXguO4fT67rbGzXs34k/aO05B/7MATJQRDQZgYSfmoG6dMwz4PMYRKun6U9lj4yPxDW
         uh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ryqgiSf02C8RME8gbpqdqWHQXz1iF0ms7ybIkewvqM=;
        b=4krD1NxGcQ6Dv5+/C3DlRgWKRS9CXA2tiQhv0MyhP/iOwhwsI+qXHMSOO3q+BfeOiE
         4+pf7/34j7BTnTT3Fr02DD/G+RLU1Uq5q/BGUjODdzPt4DquqNAddp2jQNiZQTCyNvBz
         6kHBNugmejFzJGg0kspLMHtTksL10dkraVxRDKp5yVkdJtqwx5idjWsdn2jq+vOjg+wx
         oNoRV0uaxqzorcWs887wtfunz/V3e/LlMmmcFmYbhIQCzaXmwEEd9/0bqp68d1LjgeDv
         3NLxL5B6W8HDKAS46+HiiB4nqHoFlI/f9jNy87OPzweFiJxMFveU9VfJUCSis4q4vxxi
         DLPg==
X-Gm-Message-State: AOAM530SnIwbOTKanD/OE8WqerwIQCC8FGdAzHhpbdLHlABWJT3Kym6z
        JTH3W/V0c3MtxxEUhIDmocgskh2yTtcFew==
X-Google-Smtp-Source: ABdhPJzN62gzuBU4C6LWY72+1P6SS/FOKr0CxvsG0mVxjvWZoxtxk8d7X87i0QeVXeRRf3nCi/2t8A==
X-Received: by 2002:a05:6870:f624:b0:e1:c071:121c with SMTP id ek36-20020a056870f62400b000e1c071121cmr828819oab.182.1649718211986;
        Mon, 11 Apr 2022 16:03:31 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p1-20020a05683003c100b005c927b6e645sm12808326otc.20.2022.04.11.16.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 16:03:31 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, bhelgaas@google.com,
        vladimir.oltean@nxp.com, corbet@lwn.net, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2] docs: net: dsa: describe issues with checksum offload
Date:   Mon, 11 Apr 2022 20:03:06 -0300
Message-Id: <20220411230305.28951-1-luizluca@gmail.com>
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

