Return-Path: <netdev+bounces-11636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7E6733C5C
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D93301C2108E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3608C08;
	Fri, 16 Jun 2023 22:15:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191251B906
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 22:15:40 +0000 (UTC)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5934230
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:15:16 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-54f71fa7e41so792730a12.3
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686953691; x=1689545691;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UnXRNNnoKJq2HdNoJR6iPlGHyKMfK+iDQUStl1PXctU=;
        b=EwfxhJqxNuaZNUa4RFLEtHmN+EJygfPjnme8WRTZWMzHSIchKz/W/B7L+ti8NU4TCY
         Hdm2RScl10h2+8Vk23vkjKbfJFzbNcdD5Vd2gz6a7ysWIh/CVadoNSTsal9JxkVqszzV
         jwod4CoFWSNZdE9DwydX0u2F5jl/Lppc7qtyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686953691; x=1689545691;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnXRNNnoKJq2HdNoJR6iPlGHyKMfK+iDQUStl1PXctU=;
        b=JRHaV3XhYhIP0eznPoW7pOMSD0xpVQSJgz5o+0eM1GdneoYjLB9RAuic0q6dyX8CpD
         QIteXcLhoTy/G/qeLggV49Yn7ztByiYneGZL0plo5Pcz5tSdfRAF/koKN/7nryMDr2On
         Wc4Lv8i1r4dNaVyuznfXQrtYFIDsJZhizMkEdABMEPnAR576ee6avBDz7XanwAyMRZ42
         jtuAG8uVXZcjpMgk9Dbd6v47iYapFIpamWrMjDIX2Lfc36fJMimwEh06+BVfDLPfk9mg
         TCoZIlrTmDZqE6B91SX6jhg0cPp5KD5LjYCt35QA0CHxGeFOJpKxC8guoUApFbojZBL6
         d5FA==
X-Gm-Message-State: AC+VfDwU//7kUZu/7nBrgB/Dn3Y6Zn/Kd38z0VvBZzmUz04wOUP8jumf
	kySb61Pksbbf/+qQswgu14+4wCib5o3CKhgrmgZYemDLtroJ5a/phRyCeDs6jj9Z0sp8v3L/Xyh
	DB0kd+KxlETGtllUhgGjd2eentVplTY0hRWqLib57J96SsBisNsS9Bh3uMGlllmS2aWqx/hFd8D
	IbGn39Dg==
X-Google-Smtp-Source: ACHHUZ7qXafwnrRCNJJTX8prsXwKgvhYXrYPHL4KkFryI17z7LV0uq9LLx7Tbt4Jbrj+WifGTrKm5g==
X-Received: by 2002:a05:6a21:6d87:b0:10b:97c8:2e15 with SMTP id wl7-20020a056a216d8700b0010b97c82e15mr3657913pzb.45.1686953691446;
        Fri, 16 Jun 2023 15:14:51 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ab8c00b001aaed524541sm16220860plr.227.2023.06.16.15.14.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Jun 2023 15:14:51 -0700 (PDT)
From: Justin Chen <justin.chen@broadcom.com>
To: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com
Cc: florian.fainelli@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	opendmb@gmail.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	richardcochran@gmail.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	simon.horman@corigine.com,
	Justin Chen <justin.chen@broadcom.com>
Subject: [PATCH net-next v8 10/11] net: phy: bcm7xxx: Add EPHY entry for 74165
Date: Fri, 16 Jun 2023 15:14:23 -0700
Message-Id: <1686953664-17498-11-git-send-email-justin.chen@broadcom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1686953664-17498-1-git-send-email-justin.chen@broadcom.com>
References: <1686953664-17498-1-git-send-email-justin.chen@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000008da81b05fe4683fb"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

--0000000000008da81b05fe4683fb

From: Florian Fainelli <florian.fainelli@broadcom.com>

74165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
utilize the recently defined 16nm EPHY macro to configure that PHY.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
---
 drivers/net/phy/bcm7xxx.c | 1 +
 include/linux/brcmphy.h   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index f8c17a253f8b..8478b081c058 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -913,6 +913,7 @@ static struct phy_driver bcm7xxx_driver[] = {
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7278, "Broadcom BCM7278"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7364, "Broadcom BCM7364"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7366, "Broadcom BCM7366"),
+	BCM7XXX_16NM_EPHY(PHY_ID_BCM74165, "Broadcom BCM74165"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM74371, "Broadcom BCM74371"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7439, "Broadcom BCM7439"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7439_2, "Broadcom BCM7439 (2)"),
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 5d732f48f787..c55810a43541 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -44,6 +44,7 @@
 #define PHY_ID_BCM7366			0x600d8490
 #define PHY_ID_BCM7346			0x600d8650
 #define PHY_ID_BCM7362			0x600d84b0
+#define PHY_ID_BCM74165			0x359052c0
 #define PHY_ID_BCM7425			0x600d86b0
 #define PHY_ID_BCM7429			0x600d8730
 #define PHY_ID_BCM7435			0x600d8750
-- 
2.7.4


--0000000000008da81b05fe4683fb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
NhTY3E+cXCB11wty89QStajwXdhGJTYEvUgvsq1h8CwJj9w/38ldAQf5WjhPmApYeJR2ewFrBMCM
4lHkdRJ6TDc9nXoEkypUfjJkJHe7Eal06tosh6JpAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGGp1c3Rpbi5jaGVuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUIWGeYuaTsnIada5Xx8TR3cheUbgw
DQYJKoZIhvcNAQELBQADggEBAHNQlMqQOFYPYFO71A+8t+qWMmtOdd2iGswSOvpSZ/pmGlfw8ZvY
dRTkl27m37la84AxRkiVMes14JyOZJoMh/g7fbgPlU14eBc6WQWkIA6AmNkduFWTr1pRezkjpeo6
xVmdBLM4VY1TFDYj7S8H2adPuypd62uHMY/MZi+BIUys4uAFA+N3NuUBNjcVZXYPplYxxKEuIFq6
sDL+OV16G+F9CkNMN3txsym8Nnx5WAYZb6+rBUIhMGz70V05xsHQfzvo2s7f0J1tJ5BoRlPPhL0h
VOnWA3h71u9TfSsv+PXVm3P21TfOS2uc1hbzEqyENCP4i5XQ0rv0TmPW42GZ0o4xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwj8BKLXNpALfemdRAwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILud5hDTsFVW/CmCgRXSecajL/5p0K2C5Qac
eOL4CtXLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYxNjIy
MTQ1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQBzAicVwK4U3/QYPlF33SwRzySNvN+OsTzFv05FptMw+ZgyegR+9qsB
rfIo4wvojB6X2HybMjiRYe0gw6xKNbg/wLhsGPxty/k1229g4S4ueDQHm6L2khqqC+Iky/gfedjv
FgVu8GE/AI7Ec8ddprZFj1Qy8T3D9JNJefsMN+6u5629RkVs8whT5XS1yBBWtEPdzcZX4BQoijfN
reDmt4iGWz/k0X4zUjdjkvF+cbMCkWJJ70M8EotQR3UfHoTwIwTxWgy6TzKqPRk/q3NVHAoVPSbo
wPW8325KukoOL7l2CwAJEox1qjUzLQkTUxIwI9PznwIRzClN1zvnCeHW5qVi
--0000000000008da81b05fe4683fb--

