Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D7A4DA4E7
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243110AbiCOVxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343589AbiCOVx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:53:29 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA3D5BE72
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:52:15 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 901BA2C02D7;
        Tue, 15 Mar 2022 21:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647381133;
        bh=jSMP2GY+BRoJAPT7lfNXwJIj8MAuXDNowgEYi4n43ns=;
        h=From:To:Cc:Subject:Date:From;
        b=n6nW6xqPYwnBezn4EgfzYCG/6Y0w9W9QhJ9x5z387YCTNgMGL6P/ZuSbHGI1/v3dC
         th5VHzZIl0RbaNiSetN8EuN0HzWnkJPUWGx5xpKcIpx0d0wwIquKMKwJJzTWC5fQ9j
         QE1UO+9fhDLZ5uuKezeCz56LQEaHI+uMhK4JM1M7I1yeZqSmSUgp4/EteJ+sB2PDRx
         UmIyGRZm/AUN51PioGtlUyJd4CN1AjuBie8NTvdGfElTrDm9h1jw7OpgjtORepxvUn
         aNN375stJfhBxpMvfi4ZIj0pusWaQhZS78M3Olgetqc3YSwCHmqsJrjZMnNDRoYvUk
         S+j+DnMFEswDg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B62310a8d0000>; Wed, 16 Mar 2022 10:52:13 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 4B86C13EDD7;
        Wed, 16 Mar 2022 10:52:13 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 018C32A2678; Wed, 16 Mar 2022 10:52:09 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH net-next v4 0/2] net: mvneta: Armada 98DX2530 SoC
Date:   Wed, 16 Mar 2022 10:52:05 +1300
Message-Id: <20220315215207.2746793-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=fHwNDZncxhfn92sU-sUA:9 a=AjGcO6oz07-iQ99wixmX:22
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

This is split off from [1] to let it go in via net-next rather than waiti=
ng for
the rest of the series to land.

[1] - https://lore.kernel.org/lkml/20220314213143.2404162-1-chris.packham=
@alliedtelesis.co.nz/

Chris Packham (2):
  dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
  net: mvneta: Add support for 98DX2530 Ethernet port

 .../bindings/net/marvell-armada-370-neta.txt         |  1 +
 drivers/net/ethernet/marvell/mvneta.c                | 12 ++++++++++++
 2 files changed, 13 insertions(+)

--=20
2.35.1

