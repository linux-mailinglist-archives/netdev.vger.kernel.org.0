Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288C1534A0C
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 06:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345538AbiEZE5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 00:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiEZE5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 00:57:49 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F2D3587F
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 21:57:48 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 318D42C00CE;
        Thu, 26 May 2022 04:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1653541066;
        bh=s3/Ayd5Siv2MYThV/2NaPd3UP06c8iKmsGIuSxdAgQQ=;
        h=From:To:Cc:Subject:Date:From;
        b=uFyecqmiAqIco+aDzjmXs8r0kG/sNLzwpCW8gEFBjLvx7bC0Yj7dzG4KmxjgMNlg0
         yd0OYr01iT0sbtnOlIK3GwP/Bn75Z8PuSS6VSkZFoszKJ+Hw94/9wuo04F8JhUr5Ni
         UPn64ldD6fLQxeNQklaKV6E+6tujDepqjV28jmXWhZnqUkHeGLmtqK8rWWWC9i1Yxd
         oxXTApQumd+29a90e6sLdKE8RAcAQgqj8nBNimiQ+9Jme8KTpp5nYAFPN+R9fU68w5
         SVSB6dxtqU/Fa6lJlQVWrGSeqCp3tbr1Pb8czXejBmwgkAkrqxJ4cOuXIVkO+Aztlh
         8a3JXs2exZ/gg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B628f08ca0000>; Thu, 26 May 2022 16:57:46 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 0338713ED7D;
        Thu, 26 May 2022 16:57:46 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id F2CA62A0088; Thu, 26 May 2022 16:57:45 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     michael.hennerich@analog.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        alexandru.ardelean@analog.com, josua@solid-run.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] dt-bindings: net: adin: use YAML block scalar to avoid parse issue
Date:   Thu, 26 May 2022 16:57:40 +1200
Message-Id: <20220526045740.4073762-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=U+Hs8tju c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=oZkIemNP1mAA:10 a=ulgbnlt9sKkKSAmG-DsA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YAML doesn't like colons (:) in text. Use a block scalar so that the
colon in the description text doesn't cause a parse error.

Fixes: 1f77204e11f8 ("dt-bindings: net: adin: document phy clock output p=
roperties")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Docume=
ntation/devicetree/bindings/net/adi,adin.yaml
index 77750df0c2c4..88611720545d 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -37,7 +37,8 @@ properties:
     default: 8
=20
   adi,phy-output-clock:
-    description: Select clock output on GP_CLK pin. Two clocks are avail=
able:
+    description: |
+      Select clock output on GP_CLK pin. Two clocks are available:
       A 25MHz reference and a free-running 125MHz.
       The phy can alternatively automatically switch between the referen=
ce and
       the 125MHz clocks based on its internal state.
--=20
2.36.1

