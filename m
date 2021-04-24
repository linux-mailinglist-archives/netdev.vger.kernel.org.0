Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909B236A2F1
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 22:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbhDXUPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 16:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237339AbhDXUPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 16:15:31 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD498C06175F
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 13:14:52 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d10so37496773pgf.12
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 13:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pjMsIzX0qdBulXlBS8KgpZayy/fyucBOs33YxcDYICY=;
        b=iNb3yRscsZpdcJs3n4VVH5bNJ8wTUV9JEem2K5ABcIm93rZyobjzZpPkxX3H5oqJcz
         YAzZV2Tjg6aq/jjHoGTENSrYIc4Eo/8jmTf8rkZULSxzcXQrpKEu0FQb+XUO0IRnlgND
         TQN2ESX9Wgh5Hg7egVhmVVN9lFuoLO0Xii+TU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pjMsIzX0qdBulXlBS8KgpZayy/fyucBOs33YxcDYICY=;
        b=P/1e2pppYUOPj6zY+JjgO+bncImTWF4FfD9pdI3i5HleTvwQvaCH8LH6SIXlfgdVae
         8T/0B7D5ksvq+HL7IHEv/P6kWwHKiDpypWZdnScfQiPtL613gk8ga7+P1yC8RJn1Para
         tn8NuEINr98u95vM8+uuYyXOgSBlbVxPJa7LPqOGddzZmrD6B8syn0GXqQu3oyTo680p
         VnjcgnpvMfofUgFFznPjxX1+StMCbX0QHPFXdkyMGrseooO/kiXNCIHpn1SbfE2gNRRR
         LxeJioag/I/AdZYlcmdlaKSoyPoQ1tz4cDWb5cKleD0s3LyYSGoIQS9gUq3BuDEEtihC
         Hkog==
X-Gm-Message-State: AOAM533Mru4VySG/bXkU+J0bNxpqiKNxClxd17cmS4HgEGxN/Kw1b7T0
        Xttp8jtqDCP3dX4cf4liva4/Qg==
X-Google-Smtp-Source: ABdhPJyGvn8Voy36MY9BStqguRaj0MjmJwMetbJdaKCuW7FVN9z9UfAb/vBhKCZLhk1MeSYKYWYtrQ==
X-Received: by 2002:a63:48c:: with SMTP id 134mr9949511pge.448.1619295292095;
        Sat, 24 Apr 2021 13:14:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm7914070pga.52.2021.04.24.13.14.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Apr 2021 13:14:51 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 10/10] bnxt_en: Implement .ndo_features_check().
Date:   Sat, 24 Apr 2021 16:14:31 -0400
Message-Id: <1619295271-30853-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
References: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b31ee805c0bd9037"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b31ee805c0bd9037

For UDP encapsultions, we only support the offloaded Vxlan port and
Geneve port.  All other ports included FOU and GUE are not supported so
we need to turn off TSO and checksum features.

Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 41 +++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  2 ++
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 53db073b457c..9d7c98a617f9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10781,6 +10781,39 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	return rc;
 }
 
+static netdev_features_t bnxt_features_check(struct sk_buff *skb,
+					     struct net_device *dev,
+					     netdev_features_t features)
+{
+	u8 l4_proto = 0;
+
+	features = vlan_features_check(skb, features);
+	if (!skb->encapsulation)
+		return features;
+
+	switch (vlan_get_protocol(skb)) {
+	case htons(ETH_P_IP):
+		l4_proto = ip_hdr(skb)->protocol;
+		break;
+	case htons(ETH_P_IPV6):
+		l4_proto = ipv6_hdr(skb)->nexthdr;
+		break;
+	default:
+		return features;
+	}
+
+	/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
+	if (l4_proto == IPPROTO_UDP) {
+		struct bnxt *bp = netdev_priv(dev);
+		__be16 udp_port = udp_hdr(skb)->dest;
+
+		if (udp_port != bp->vxlan_port && udp_port != bp->nge_port)
+			return features & ~(NETIF_F_CSUM_MASK |
+					    NETIF_F_GSO_MASK);
+	}
+	return features;
+}
+
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
 			 u32 *reg_buf)
 {
@@ -12288,10 +12321,13 @@ static int bnxt_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
 	unsigned int cmd;
 
 	udp_tunnel_nic_get_port(netdev, table, 0, &ti);
-	if (ti.type == UDP_TUNNEL_TYPE_VXLAN)
+	if (ti.type == UDP_TUNNEL_TYPE_VXLAN) {
+		bp->vxlan_port = ti.port;
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN;
-	else
+	} else {
+		bp->nge_port = ti.port;
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE;
+	}
 
 	if (ti.port)
 		return bnxt_hwrm_tunnel_dst_port_alloc(bp, ti.port, cmd);
@@ -12391,6 +12427,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_change_mtu		= bnxt_change_mtu,
 	.ndo_fix_features	= bnxt_fix_features,
 	.ndo_set_features	= bnxt_set_features,
+	.ndo_features_check	= bnxt_features_check,
 	.ndo_tx_timeout		= bnxt_tx_timeout,
 #ifdef CONFIG_BNXT_SRIOV
 	.ndo_get_vf_config	= bnxt_get_vf_config,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a3744247740b..24d2ad6a8740 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1914,6 +1914,8 @@ struct bnxt {
 
 	u16			vxlan_fw_dst_port_id;
 	u16			nge_fw_dst_port_id;
+	__be16			vxlan_port;
+	__be16			nge_port;
 	u8			port_partition_type;
 	u8			port_count;
 	u16			br_mode;
-- 
2.18.1


--000000000000b31ee805c0bd9037
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAcz2rcj/FHR8LjZGzxw7UoREp95o2Ox
6TWjqAYMqJoEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NDIwMTQ1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA3ZdGukM+rhgHJKhY4WaP8CIvsrJ3Q/dUPtpM2FPuNgw1MwaC1
yca5kSpny3EdlejlFD70O8Uas+hkSM0zA2Lfs0OM2ETIWOdR4NkSjKKG2H/LlkRKVu4V47avHazQ
kV3PH8YMkOF4RH+fA+DjqT4JyGW8q50tZJ7CtflTR78lHLilyOptLMGqaeDnkNs7RfnGAysniVGf
GZ42Qel0DPQyTXBoiMsCW7HuDs5sNOKVymnUVxoenvv5YMl7u8hXUChJRJ4fqnz5jN1lG1Y8j2m5
UgMei4Gri0N3BJlQ7GqmqeCNk5oytoF6VJIpBgRoqPoRGEPNd9euEhQWeXT6VSBo
--000000000000b31ee805c0bd9037--
