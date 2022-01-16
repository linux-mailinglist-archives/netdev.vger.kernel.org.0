Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C001F48FF06
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbiAPVQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbiAPVQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 16:16:02 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DFBC061401
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:16:02 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o7-20020a05600c510700b00347e10f66d1so6782556wms.0
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ZRW3oDhOxGZh12nnFCIRwcL+KGVdvZHn8X1zV+9ZLv4=;
        b=I8cLSRXIcXyA4Kq2yDP6ZcRkV6/IuSdvBN8mh0S+5IHpaYy1QM3dQp/lYGXEQLRxq3
         7Es8XLj10aoY1aGuWL1gmcgXCZKeP1KDkQMmTYhu8xd4AzPMgVTc/ttgwFL4lLHoFadW
         DoS6iUEEvi80m8vN7fwFLKYjpLgGkcLOBW5shTkZ7vy4avnweOaiz4JvgHnrWAID4FHf
         i+kdgO9SHB0zQrZwgqJQxSYDqjyQpaR/ia8xuNUF2lj6+mTfH2SF5W9SBjl6weGSw9Uw
         m9mK+enQRtAOg+3GXvGkoYG3g7oVJaK84GHtxRt4e5jEW0glpPL4cJmdhrISdLDLFTv2
         EZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ZRW3oDhOxGZh12nnFCIRwcL+KGVdvZHn8X1zV+9ZLv4=;
        b=DjDe7jxxBVVXZKdNlkAYEmMixgzQnNZn6DekFqSgJ/7wBNFkb4BJMmQMQsfAJTJKfr
         BNHdhD7eGAmrsBNg9VAlUeZw0zUTG/QbpZ+L+hhf0ExANFpQIGdZzDc55ui1HXvOF1Gf
         AQU8eh42u57V3l8OWSvliZQw3aIMRlg8QJAgV5wjgKhmvA3McOIk9YgF7ODxmKOohD5T
         8gOAq8hCzeKMZauuGjwSG7ApB0B5dv+GuGoHSLO84SNDrBsapM4rhEg+Uh8jsBt26U8h
         dtOsUWFApEm5InsFbcqGGlsxHc22/59O8aQQ/UjUxjvvGznmd0M8BEYUjy0vmReu2+oe
         Eijw==
X-Gm-Message-State: AOAM5326LTCvWreocwBERC5HPGLGnRlXur/kt2LM1iiFv8dFcsRRJ94e
        JkmDEbtmJzStM5fJhpfECuymPw==
X-Google-Smtp-Source: ABdhPJz3kSbmMli5hJqvOZ83d2ZGQygN/ukAJMlrPaXrgbXJnOmWK3Isz2XTLJ84yNoTdwFX6MrALw==
X-Received: by 2002:a1c:a747:: with SMTP id q68mr24369924wme.98.1642367760615;
        Sun, 16 Jan 2022 13:16:00 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l12sm8820445wrz.15.2022.01.16.13.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 13:16:00 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     madalin.bucur@nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net 3/4] powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
Date:   Sun, 16 Jan 2022 22:15:28 +0100
Message-Id: <20220116211529.25604-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220116211529.25604-1-tobias@waldekranz.com>
References: <20220116211529.25604-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This block is used in (at least) T1024 and T1040, including their
variants like T1023 etc.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
index c90702b04a53..48e5cd61599c 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
@@ -79,6 +79,7 @@ mdio0: mdio@fc000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfc000 0x1000>;
+		fsl,erratum-a009885;
 	};
 
 	xmdio0: mdio@fd000 {
@@ -86,6 +87,7 @@ xmdio0: mdio@fd000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfd000 0x1000>;
+		fsl,erratum-a009885;
 	};
 };
 
-- 
2.25.1

