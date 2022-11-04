Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6096195D5
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiKDMIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDMIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:08:10 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA832CDF7
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:08:04 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221104120800epoutp017206d48d5ff34b148ef4f46e2a7d5858~kYFUt2qoX2140121401epoutp01X
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:08:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221104120800epoutp017206d48d5ff34b148ef4f46e2a7d5858~kYFUt2qoX2140121401epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667563681;
        bh=YRLF5DS/tqrXsIZXg451wsoqtu+Afm6bvCI0QM0l6XY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=hKWgtfxtKO5grgKjBUdha3bL19NCfLV/WrtOnyq1SmtKwrYsWCxbKZCtikxnpvukU
         IhyRuRk1KK8WHGRiQ/4SB9ff8Z3oQT5A8IKmPLmMVVk8c/2BI+AOcEdsxVE7rPMMYx
         42gnLNiYj8hJkreG5of2nGsjhL3vasqtguIJPAC8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221104120800epcas5p46bbed9eab4ea7d36b1404a428d8c6242~kYFUIrTq51044710447epcas5p4B;
        Fri,  4 Nov 2022 12:08:00 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N3fXG5SP4z4x9Px; Fri,  4 Nov
        2022 12:07:58 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.37.01710.B9005636; Fri,  4 Nov 2022 21:07:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20221104115833epcas5p31f68ef0a192e0d6678d2e2a0b3b89c4e~kX9EfOrox2273022730epcas5p3k;
        Fri,  4 Nov 2022 11:58:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221104115833epsmtrp2ad4f1a72c7fae89f15602d4dd69e5e97~kX9EeOKpO1549915499epsmtrp20;
        Fri,  4 Nov 2022 11:58:33 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-05-6365009b4468
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.A5.18644.96EF4636; Fri,  4 Nov 2022 20:58:33 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104115831epsmtip299d990875c2308913c0776aa836b0ba7~kX9CjapXL2474124741epsmtip2H;
        Fri,  4 Nov 2022 11:58:31 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: [PATCH 0/4] net: stmmac: dwc-qos: Add FSD EQoS support
Date:   Fri,  4 Nov 2022 17:35:13 +0530
Message-Id: <20221104120517.77980-1-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmuu5shtRkg0u3BC1+vpzGaDHnfAuL
        xdNjj9gt7i16x2pxYVsfq8Wmx9dYLS7vmsNm0XXtCavFvL9rWS2OLRCz+Hb6DaPF/9dbGS2O
        nHnBbHH7zTpWBz6PLStvMnk87d/K7rFz1l12jwWbSj02repk89i8pN7j/b6rbB59W1Yxehzc
        Z+jx9MdeZo8t+z8zenzeJBfAE5Vtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6k
        kJeYm2qr5OIToOuWmQP0iJJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgx
        t7g0L10vL7XEytDAwMgUqDAhO+Pf+rWsBTM4KxZ9eMHYwLiAvYuRk0NCwETib8cPpi5GLg4h
        gd2MErvW/WeEcD4xSvzuWM8O4XxmlGhYvYEZpuVN726oql2MEq8XnYXqb2WS2PloL1gVm4Cu
        ROu1z2AJEYHrjBIPJ98Am8UssJVRYvKmBrD1wgL2Ess2tjGC2CwCqhJzm/+ygNi8ArYSDyYt
        YIXYJy+xesMBZpBmCYGJHBIP90yHut1F4uKVTVC2sMSr41ugbCmJz+/2skHY6RKbj2yGGpQj
        0dHUDPWEvcSBK3OAlnEAXaQpsX6XPkRYVmLqqXVMIDazAJ9E7+8nTBBxXokd82BsNYnFjzqh
        bBmJtY8+QY33kFjyfh/YeCGBWIm9m7uYJzDKzkLYsICRcRWjZGpBcW56arFpgWFeajk8rpLz
        czcxgpOolucOxrsPPugdYmTiYDzEKMHBrCTC+2lbcrIQb0piZVVqUX58UWlOavEhRlNgmE1k
        lhJNzgem8bySeEMTSwMTMzMzE0tjM0Mlcd7FM7SShQTSE0tSs1NTC1KLYPqYODilGpjEptU/
        WbTRutMg2G39q7qAMMseppK19zkfmZxWtsgp1JGfrefSxyV6pSwwePbbH0dU3vP9lurcvvnx
        29a+76ra88xDPG9tyI9ak3z1fZjF0nUN3+9uF/35guXV5FsO3K7aZ8uTZBr7ElX8Dh/Ka9oV
        EOqmyt55YuO665d6D8mce6kf+PSfSVOv4TmHmd/CH6htzy8y3Dn7wcOb4SXvbyxSVto0+614
        6W2LPh/j+Mc3XfLj5Pn2b668bLXku6Tj7PhjHT8Ypvku1vuiunD9FTl/3mmlU54Wc3dUBdz4
        WD3lxJXzO7h8xB3PdS7T3qrWs0mPNSBmXULAqXP11g9uKFaa2C5wn9D55fEV1aQnEQeVWIoz
        Eg21mIuKEwHSJxTfKwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvG7mv5Rkg75/2hY/X05jtJhzvoXF
        4umxR+wW9xa9Y7W4sK2P1WLT42usFpd3zWGz6Lr2hNVi3t+1rBbHFohZfDv9htHi/+utjBZH
        zrxgtrj9Zh2rA5/HlpU3mTye9m9l99g56y67x4JNpR6bVnWyeWxeUu/xft9VNo++LasYPQ7u
        M/R4+mMvs8eW/Z8ZPT5vkgvgieKySUnNySxLLdK3S+DK+Ld+LWvBDM6KRR9eMDYwLmDvYuTk
        kBAwkXjTu5uxi5GLQ0hgB6PEpG8/oBIyEicfLGGGsIUlVv57zg5R1MwkceL/LBaQBJuArkTr
        tc9MIAkRgYeMEuc/d7KCOMwCOxklnixtYwWpEhawl1i2sY0RxGYRUJWY2/wXrJtXwFbiwaQF
        rBAr5CVWbzjAPIGRZwEjwypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOBw1tLawbhn
        1Qe9Q4xMHIyHGCU4mJVEeD9tS04W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6Yklq
        dmpqQWoRTJaJg1OqgYnpfUTFn3nFTt1P2Bxus+fKaGjsUfkY0aCWwsP20X3hlOefvikmhLZ+
        nTqrNrKi+KfjszbRUvnGB0vm/Wg6otH9sb/1/FuxX8q71jQ9SZicvnA/h2n0b8GH0XXsLjMW
        bX4X4KHwXKN2mujn0P7WjxUpISUzTp358DzgSB9f+aMbU7sC1vUcC+D8mlF/WT3TUs2K9+b0
        Sa2XfrPVOVlYXUor3lwSdeaEt+qJs48uhu1/Ii5/InSKr0xE8FeLUrfjHQ397P2iYimd2V1u
        YW/Wm72SeLXc6bdHZGhxqVqLofel/z8Xiiv0GMWvW8F+XyZh5rfJv4JVrbh7RWytdnz+Z3gp
        ctetyCxVY2dVLh82JZbijERDLeai4kQAWlq2O9YCAAA=
X-CMS-MailID: 20221104115833epcas5p31f68ef0a192e0d6678d2e2a0b3b89c4e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115833epcas5p31f68ef0a192e0d6678d2e2a0b3b89c4e
References: <CGME20221104115833epcas5p31f68ef0a192e0d6678d2e2a0b3b89c4e@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FSD platform has two instances of EQoS IP, one is in FSYS0 block and
another one is in PERIC block. This patch series add required DT binding,
DT file modifications and platform driver specific changes for the same.

This series needs following two patches [1,2] posted as part of MCAN IP
support for FSD platform.

[1]: https://www.spinics.net/lists/netdev/msg854161.html
[2]: https://www.spinics.net/lists/netdev/msg854158.html

Sriranjani P (4):
  dt-bindings: net: Add EQoS compatible for FSD SoC
  net: stmmac: dwc-qos: Add FSD EQoS support
  arm64: dts: fsd: Add Ethernet support for FSYS0 Block of FSD SoC
  arm64: dts: fsd: Add Ethernet support for PERIC Block of FSD SoC

 .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
 arch/arm64/boot/dts/tesla/fsd-evb.dts         |  18 ++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi    | 112 +++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi            |  96 ++++++++
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 229 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  12 +
 include/linux/stmmac.h                        |   1 +
 7 files changed, 469 insertions(+)

-- 
2.17.1

