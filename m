Return-Path: <netdev+bounces-10896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 903E2730AC4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 501C8280FCD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE77E11CB2;
	Wed, 14 Jun 2023 22:31:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC26B24155
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:31:01 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2653B26AA
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:30:47 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f9e33a3d3fso24400891cf.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686781846; x=1689373846;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CT2RqFbac26jkZqUQfbiamJ/LujrCis+BxpJnYDo1Zk=;
        b=TA80jfmtG70kvUx564H7SK9IBRKstMMed1+kLcf1RqcfsILRg1F+WF4SLIqwnxO5Dv
         yvx+OLwa2vjyeFWFoGXRziePtGv8CX1P9hCen5XiFS6L+dQaDIcnaicPAJdsRqWseMBm
         zdPZ56nxuI/szKywI6mqtsIdYVyc/14y1eM7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686781846; x=1689373846;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CT2RqFbac26jkZqUQfbiamJ/LujrCis+BxpJnYDo1Zk=;
        b=hOXAa6JNcfBkL+agLXM/gZA0jndd7UEqK4ekhjVvU9FK4b2+h4wYIbJBd/5aDmamN2
         rNgIs/sNDzl2n/gbnQJMN8iTXia9wwNOxJcpJgnSgkA5rYNQULg+inLX33+1cgglClvP
         wfeNqZVLjvBd2dYly7rHmR9Uq3OIlVAKkAYIhfATIGAmP5qk/HADJWGtPC7z1fzw8GWq
         w9KfuTVtalAME1p8ycZ9OMe/fnm5Niu1UcweRVVtUdhCpZFUfN/CCCCI+G10+BeM2HRU
         V61Ib/KbSSiEeazuiABrMHN59kn+NQ95nUunXvBKynaSHCIrMN1Fbx87vdZZ5ggzA3k2
         2H6Q==
X-Gm-Message-State: AC+VfDyFqrRDZCplE7IX62epFAH0BQIfuLtqOWRgjgeL9xCPuD4dYkMF
	dMPNblu6Urf+VhJjT2MZWDa+pJFrhDS3j+rhLliE6+Xi/2iyiHoN1NEc+GRnN7Q21m3Yp8lgxcx
	fRwjv7S2ZG89tHSrKZZ+iqkNuJGVsFhOZ5ccrIJ1GjnTIYitmfE2u6u0DAGuSpL6Pjf6RkxuSeZ
	es3BVn3w==
X-Google-Smtp-Source: ACHHUZ6sHEmCPeDGmaMMLsxVNAtumV0la2BZpd26m3iGByrORCEZQfLUGkpF6zsQyulPU1cD32CEJQ==
X-Received: by 2002:a05:622a:1a8a:b0:3f5:2faf:7917 with SMTP id s10-20020a05622a1a8a00b003f52faf7917mr4220057qtc.9.1686781846338;
        Wed, 14 Jun 2023 15:30:46 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d3-20020ac85443000000b003ef2db16e72sm5419360qtq.94.2023.06.14.15.30.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jun 2023 15:30:46 -0700 (PDT)
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
Subject: [PATCH net-next v7 07/11] net: bcmasp: Add support for ethtool standard stats
Date: Wed, 14 Jun 2023 15:30:16 -0700
Message-Id: <1686781820-832-8-git-send-email-justin.chen@broadcom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1686781820-832-1-git-send-email-justin.chen@broadcom.com>
References: <1686781820-832-1-git-send-email-justin.chen@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000caf21805fe1e8076"
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

--000000000000caf21805fe1e8076

Add support for eth_mac_stats, rmon_stats, and eth_ctrl_stats.

Signed-off-by: Justin Chen <justin.chen@broadcom.com>
---
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    | 77 ++++++++++++++++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  | 63 +++++++++++++++++-
 2 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
index 1e96a69043f3..59d853c2293c 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
@@ -250,6 +250,80 @@ static int bcmasp_set_eee(struct net_device *dev, struct ethtool_eee *e)
 	return phy_ethtool_set_eee(dev->phydev, e);
 }
 
+static void bcmasp_get_eth_mac_stats(struct net_device *dev,
+				     struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	mac_stats->FramesTransmittedOK = umac_rl(intf, UMC_GTPOK);
+	mac_stats->SingleCollisionFrames = umac_rl(intf, UMC_GTSCL);
+	mac_stats->MultipleCollisionFrames = umac_rl(intf, UMC_GTMCL);
+	mac_stats->FramesReceivedOK = umac_rl(intf, UMC_GRPOK);
+	mac_stats->FrameCheckSequenceErrors = umac_rl(intf, UMC_GRFCS);
+	mac_stats->AlignmentErrors = umac_rl(intf, UMC_GRALN);
+	mac_stats->OctetsTransmittedOK = umac_rl(intf, UMC_GTBYT);
+	mac_stats->FramesWithDeferredXmissions = umac_rl(intf, UMC_GTDRF);
+	mac_stats->LateCollisions = umac_rl(intf, UMC_GTLCL);
+	mac_stats->FramesAbortedDueToXSColls = umac_rl(intf, UMC_GTXCL);
+	mac_stats->OctetsReceivedOK = umac_rl(intf, UMC_GRBYT);
+	mac_stats->MulticastFramesXmittedOK = umac_rl(intf, UMC_GTMCA);
+	mac_stats->BroadcastFramesXmittedOK = umac_rl(intf, UMC_GTBCA);
+	mac_stats->FramesWithExcessiveDeferral = umac_rl(intf, UMC_GTEDF);
+	mac_stats->MulticastFramesReceivedOK = umac_rl(intf, UMC_GRMCA);
+	mac_stats->BroadcastFramesReceivedOK = umac_rl(intf, UMC_GRBCA);
+}
+
+static const struct ethtool_rmon_hist_range bcmasp_rmon_ranges[] = {
+	{    0,   64},
+	{   65,  127},
+	{  128,  255},
+	{  256,  511},
+	{  512, 1023},
+	{ 1024, 1518},
+	{ 1519, 1522},
+	{}
+};
+
+static void bcmasp_get_rmon_stats(struct net_device *dev,
+				  struct ethtool_rmon_stats *rmon_stats,
+				  const struct ethtool_rmon_hist_range **ranges)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	*ranges = bcmasp_rmon_ranges;
+
+	rmon_stats->undersize_pkts = umac_rl(intf, UMC_RRUND);
+	rmon_stats->oversize_pkts = umac_rl(intf, UMC_GROVR);
+	rmon_stats->fragments = umac_rl(intf, UMC_RRFRG);
+	rmon_stats->jabbers = umac_rl(intf, UMC_GRJBR);
+
+	rmon_stats->hist[0] = umac_rl(intf, UMC_GR64);
+	rmon_stats->hist[1] = umac_rl(intf, UMC_GR127);
+	rmon_stats->hist[2] = umac_rl(intf, UMC_GR255);
+	rmon_stats->hist[3] = umac_rl(intf, UMC_GR511);
+	rmon_stats->hist[4] = umac_rl(intf, UMC_GR1023);
+	rmon_stats->hist[5] = umac_rl(intf, UMC_GR1518);
+	rmon_stats->hist[6] = umac_rl(intf, UMC_GRMGV);
+
+	rmon_stats->hist_tx[0] = umac_rl(intf, UMC_TR64);
+	rmon_stats->hist_tx[1] = umac_rl(intf, UMC_TR127);
+	rmon_stats->hist_tx[2] = umac_rl(intf, UMC_TR255);
+	rmon_stats->hist_tx[3] = umac_rl(intf, UMC_TR511);
+	rmon_stats->hist_tx[4] = umac_rl(intf, UMC_TR1023);
+	rmon_stats->hist_tx[5] = umac_rl(intf, UMC_TR1518);
+	rmon_stats->hist_tx[6] = umac_rl(intf, UMC_TRMGV);
+}
+
+static void bcmasp_get_eth_ctrl_stats(struct net_device *dev,
+				      struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+
+	ctrl_stats->MACControlFramesTransmitted = umac_rl(intf, UMC_GTXCF);
+	ctrl_stats->MACControlFramesReceived = umac_rl(intf, UMC_GRXCF);
+	ctrl_stats->UnsupportedOpcodesReceived = umac_rl(intf, UMC_GRXUO);
+}
+
 const struct ethtool_ops bcmasp_ethtool_ops = {
 	.get_drvinfo		= bcmasp_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
@@ -263,4 +337,7 @@ const struct ethtool_ops bcmasp_ethtool_ops = {
 	.set_rxnfc		= bcmasp_set_rxnfc,
 	.set_eee		= bcmasp_set_eee,
 	.get_eee		= bcmasp_get_eee,
+	.get_eth_mac_stats	= bcmasp_get_eth_mac_stats,
+	.get_rmon_stats		= bcmasp_get_rmon_stats,
+	.get_eth_ctrl_stats	= bcmasp_get_eth_ctrl_stats,
 };
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h
index b259a475207f..ad742612895f 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h
@@ -45,7 +45,68 @@
 #define  UMC_EEE_LPI_TIMER		0x68
 #define  UMC_PAUSE_CNTRL		0x330
 #define  UMC_TX_FLUSH			0x334
-#define  UMC_MIB_START			0x400
+#define  UMC_GR64			0x400
+#define  UMC_GR127			0x404
+#define  UMC_GR255			0x408
+#define  UMC_GR511			0x40c
+#define  UMC_GR1023			0x410
+#define  UMC_GR1518			0x414
+#define  UMC_GRMGV			0x418
+#define  UMC_GR2047			0x41c
+#define  UMC_GR4095			0x420
+#define  UMC_GR9216			0x424
+#define  UMC_GRPKT			0x428
+#define  UMC_GRBYT			0x42c
+#define  UMC_GRMCA			0x430
+#define  UMC_GRBCA			0x434
+#define  UMC_GRFCS			0x438
+#define  UMC_GRXCF			0x43c
+#define  UMC_GRXPF			0x440
+#define  UMC_GRXUO			0x444
+#define  UMC_GRALN			0x448
+#define  UMC_GRFLR			0x44c
+#define  UMC_GRCDE			0x450
+#define  UMC_GRFCR			0x454
+#define  UMC_GROVR			0x458
+#define  UMC_GRJBR			0x45c
+#define  UMC_GRMTUE			0x460
+#define  UMC_GRPOK			0x464
+#define  UMC_GRUC			0x468
+#define  UMC_GRPPP			0x46c
+#define  UMC_GRMCRC			0x470
+#define  UMC_TR64			0x480
+#define  UMC_TR127			0x484
+#define  UMC_TR255			0x488
+#define  UMC_TR511			0x48c
+#define  UMC_TR1023			0x490
+#define  UMC_TR1518			0x494
+#define  UMC_TRMGV			0x498
+#define  UMC_TR2047			0x49c
+#define  UMC_TR4095			0x4a0
+#define  UMC_TR9216			0x4a4
+#define  UMC_GTPKT			0x4a8
+#define  UMC_GTMCA			0x4ac
+#define  UMC_GTBCA			0x4b0
+#define  UMC_GTXPF			0x4b4
+#define  UMC_GTXCF			0x4b8
+#define  UMC_GTFCS			0x4bc
+#define  UMC_GTOVR			0x4c0
+#define  UMC_GTDRF			0x4c4
+#define  UMC_GTEDF			0x4c8
+#define  UMC_GTSCL			0x4cc
+#define  UMC_GTMCL			0x4d0
+#define  UMC_GTLCL			0x4d4
+#define  UMC_GTXCL			0x4d8
+#define  UMC_GTFRG			0x4dc
+#define  UMC_GTNCL			0x4e0
+#define  UMC_GTJBR			0x4e4
+#define  UMC_GTBYT			0x4e8
+#define  UMC_GTPOK			0x4ec
+#define  UMC_GTUC			0x4f0
+#define  UMC_RRPKT			0x500
+#define  UMC_RRUND			0x504
+#define  UMC_RRFRG			0x508
+#define  UMC_RRBYT			0x50c
 #define  UMC_MIB_CNTRL			0x580
 #define   UMC_MIB_CNTRL_RX_CNT_RST	BIT(0)
 #define   UMC_MIB_CNTRL_RUNT_CNT_RST	BIT(1)
-- 
2.7.4


--000000000000caf21805fe1e8076
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINSUuHPPaigdLLx8iez5lfL73yOaVZ0KloQq
0owaEGCuMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYxNDIy
MzA0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQCaNeOiEiOyFmHfzYsx2vw8cCukXO+45sEGiNymIp6gzzBt6ymFUZYt
3CKWBqeD1SYIk/zJZWcL0+3JJWNEBfplrMP2l2Pv+NbHxHjoQPIObVSQ9VC7NvYRwxLUS4/JXIvv
OPgMT0BvIph0I/1D4lhRUMZ2fYPYf8BSKUQ8bnQjPykO1CxNbrcJbt0TfMERLq1NKJ74KUhID9TP
7P758/ur6+ZJsT4zSyAMh6hKVOsAlTSw1/KVvEBcCr78il6f+JebfbZ8/ncD/OkMHmVGkloaboHg
SkElmHY4qdvITcZQcjgyQL40+YxWtbYmI6XdJKHjzTQbEZWC6oScVsDJWlY+
--000000000000caf21805fe1e8076--

