Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A54D922F
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344240AbiCOBTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344236AbiCOBTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:19:09 -0400
X-Greylist: delayed 13546 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 18:17:57 PDT
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0B613DC4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:17:55 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 21E772C072F;
        Tue, 15 Mar 2022 01:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647307073;
        bh=UivpbKymV5CHwwJgz2qOrdXwYdgZWXTFgTeVW/TVydM=;
        h=From:To:Cc:Subject:Date:From;
        b=aCVY4N27u7p+ilXSVJz9m3XiMJq/r7Ga/qcu7md0eWQu7t9ui23EaYJgP+MoWieWz
         YJjf2qyNhQo4nC2Nv+mxcHEqUa1agkekYJ3C/41CYM3lsRFAGD0jJLK5+QSxej/hm5
         0Bz7BlNwVHAIYjDnJo2Hp8STEBY71E3/K1SGEi3VL9HQaQsMX1U/MzCbvdgyf4Kfso
         7f+v6aCZsQBembYP4oU6lX7PttK0qjfgxhXUsta6OV/yJcpASuYuRJYcaQrNRVHwtx
         qyTLxPxgtXeIR7C6vyUQJycLch3T9xV8PC6G66NGaUJn8oaDsVOmMsmx8mY8V/6BGO
         vLkB3jDu9u9jg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fe9400000>; Tue, 15 Mar 2022 14:17:52 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id C564813EE2B;
        Tue, 15 Mar 2022 14:17:52 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 552692A2678; Tue, 15 Mar 2022 14:17:50 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH net-next v3 0/2] net: mvneta: Armada 98DX2530 SoC
Date:   Tue, 15 Mar 2022 14:17:40 +1300
Message-Id: <20220315011742.2465356-1-chris.packham@alliedtelesis.co.nz>
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

 .../bindings/net/marvell-armada-370-neta.txt        |  1 +
 drivers/net/ethernet/marvell/mvneta.c               | 13 +++++++++++++
 2 files changed, 14 insertions(+)

--=20
2.35.1

