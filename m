Return-Path: <netdev+bounces-9350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5398B72893B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0897D2816E2
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033692D27F;
	Thu,  8 Jun 2023 20:15:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AAB17740
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:15:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F902D59
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686255327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L48RUw9YMqyOqmKmJhsjcW6o+lsA4cxkY+mrl6+2nfQ=;
	b=FKFjoQ7Ef2qaGYd5Iafy7zYij/tLw/TXP805VHzK2J6rV0g+OPCpGVvfN6uFP0SGoB8JKz
	LarpDVrwVI4s/ZplV6qlUIn29wSZ6irzyAZXWjsoLfrmYmGuHD0M4AnG1iynX8IR6qeTOV
	SjxYEv2QUYCd38T6wtyzmqAEfe+gin8=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-0a-4oELoNCSYx8h4I3Q8Mg-1; Thu, 08 Jun 2023 16:15:20 -0400
X-MC-Unique: 0a-4oELoNCSYx8h4I3Q8Mg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-19f9f28b142so65568fac.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 13:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686255319; x=1688847319;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L48RUw9YMqyOqmKmJhsjcW6o+lsA4cxkY+mrl6+2nfQ=;
        b=Aqo14vdbc7xJw/5pMFG3nmj5RtNSJB6N84F+aESZdFUE7/2GyiN9X4VTvgetMPiVQc
         Z3e/EBb9YMuoGvU5Sqi6IDwEaEfrXf2r3pheb5GPGADkr2HscVVsqjSRriIAa+z/FxZK
         intRFBuoRjIKVOxcZUhcqtMF87nNqFCuA37oFB9eBAg3nPpikuMwoDATZZ/o8ryEhuzz
         ekYjNYALKyrtYQuhUmIPGfcBw8gnJdE+zPkBkPBKi+1eB2ZZSkZpQnMnQIs5jL/F2d+d
         BjHHgfQE7HhGIYBzNlnQImtP36sawcLxuvCzcqahx7WPikYVOrMQ3MemZK2BTAYrManQ
         GlFA==
X-Gm-Message-State: AC+VfDxw5q3GZKY02M0Q8YBLRTUe0Pa30+6GAj92gFNiWH4PzMRDsT1N
	oiOITpPzfWCMCsRFJptR136Wlm94o7/pYoWAXfzXz4KiYHUYa0VXSvHcWvE6d2Ptr0BHCUP15vd
	yS45EKPRw9UcoP/lg
X-Received: by 2002:a05:6870:4315:b0:19f:5c37:ab9d with SMTP id w21-20020a056870431500b0019f5c37ab9dmr6615028oah.43.1686255319648;
        Thu, 08 Jun 2023 13:15:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5kmzEz2a3R2fs33iV8rCMEYImysyVNpw81buOmDc0MgwnMxyKIw9y3vKvsr4l68kGBj9qIJA==
X-Received: by 2002:a05:6870:4315:b0:19f:5c37:ab9d with SMTP id w21-20020a056870431500b0019f5c37ab9dmr6615020oah.43.1686255319392;
        Thu, 08 Jun 2023 13:15:19 -0700 (PDT)
Received: from halaney-x13s.redhat.com ([2600:1700:1ff0:d0e0::22])
        by smtp.gmail.com with ESMTPSA id r11-20020a4aa8cb000000b0055afc1ef866sm179976oom.15.2023.06.08.13.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 13:15:19 -0700 (PDT)
From: Andrew Halaney <ahalaney@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	konrad.dybcio@linaro.org,
	andersson@kernel.org,
	agross@kernel.org,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	richardcochran@gmail.com,
	bmasney@redhat.com,
	echanude@redhat.com,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH] arm64: dts: qcom: sa8540p-ride: Specify ethernet phy OUI
Date: Thu,  8 Jun 2023 15:15:13 -0500
Message-Id: <20230608201513.882950-1-ahalaney@redhat.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With wider usage on more boards, there have been reports of the
following:

    [  315.016174] qcom-ethqos 20000.ethernet eth0: no phy at addr -1
    [  315.016179] qcom-ethqos 20000.ethernet eth0: __stmmac_open: Cannot attach to PHY (error: -19)

which has been fairly random and isolated to specific boards.
Early reports were written off as a hardware issue, but it has been
prevalent enough on boards that theory seems unlikely.

In bring up of a newer piece of hardware, similar was seen, but this
time _consistently_. Moving the reset to the mdio bus level (which isn't
exactly a lie, it is the only device on the bus so one could model it as
such) fixed things on that platform. Analysis on sa8540p-ride shows that
the phy's reset is not being handled during the OUI scan if the reset
lives in the phy node:

    # gpio 752 is the reset, and is active low, first mdio reads are the OUI
    modprobe-420     [006] .....   154.738544: mdio_access: stmmac-0 read  phy:0x08 reg:0x02 val:0x0141
    modprobe-420     [007] .....   154.738665: mdio_access: stmmac-0 read  phy:0x08 reg:0x03 val:0x0dd4
    modprobe-420     [004] .....   154.741357: gpio_value: 752 set 1
    modprobe-420     [004] .....   154.741358: gpio_direction: 752 out (0)
    modprobe-420     [004] .....   154.741360: gpio_value: 752 set 0
    modprobe-420     [006] .....   154.762751: gpio_value: 752 set 1
    modprobe-420     [007] .....   154.846857: gpio_value: 752 set 1
    modprobe-420     [004] .....   154.937824: mdio_access: stmmac-0 write phy:0x08 reg:0x0d val:0x0003
    modprobe-420     [004] .....   154.937932: mdio_access: stmmac-0 write phy:0x08 reg:0x0e val:0x0014

Moving it to the bus level, or specifying the OUI in the phy's
compatible ensures the reset is handled before any mdio access
Here is tracing with the OUI approach (which skips scanning the OUI):

    modprobe-549     [007] .....    63.860295: gpio_value: 752 set 1
    modprobe-549     [007] .....    63.860297: gpio_direction: 752 out (0)
    modprobe-549     [007] .....    63.860299: gpio_value: 752 set 0
    modprobe-549     [004] .....    63.882599: gpio_value: 752 set 1
    modprobe-549     [005] .....    63.962132: gpio_value: 752 set 1
    modprobe-549     [006] .....    64.049379: mdio_access: stmmac-0 write phy:0x08 reg:0x0d val:0x0003
    modprobe-549     [006] .....    64.049490: mdio_access: stmmac-0 write phy:0x08 reg:0x0e val:0x0014

The OUI approach is taken given the description matches the situation
perfectly (taken from ethernet-phy.yaml):

    - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
      description:
        If the PHY reports an incorrect ID (or none at all) then the
        compatible list may contain an entry with the correct PHY ID
        in the above form.
        The first group of digits is the 16 bit Phy Identifier 1
        register, this is the chip vendor OUI bits 3:18. The
        second group of digits is the Phy Identifier 2 register,
        this is the chip vendor OUI bits 19:24, followed by 10
        bits of a vendor specific ID.

With this in place the sa8540p-ride's phy is probing consistently, so
it seems the floating reset during mdio access was the issue. In either
case, it shouldn't be floating so this improves the situation. The below
link discusses some of the relationship of mdio, its phys, and points to
this OUI compatible as a way to opt out of the OUI scan pre-reset
handling which influenced this decision.

Link: https://lore.kernel.org/all/dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com/
Fixes: 57827e87be54 ("arm64: dts: qcom: sa8540p-ride: Add ethernet nodes")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 arch/arm64/boot/dts/qcom/sa8540p-ride.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
index 21e9eaf914dd..5a26974dcf8f 100644
--- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
@@ -171,6 +171,7 @@ mdio {
 
 		/* Marvell 88EA1512 */
 		rgmii_phy: phy@8 {
+			compatible = "ethernet-phy-id0141.0dd4";
 			reg = <0x8>;
 
 			interrupts-extended = <&tlmm 127 IRQ_TYPE_EDGE_FALLING>;
-- 
2.40.1


