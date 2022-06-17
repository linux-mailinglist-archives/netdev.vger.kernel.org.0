Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF7854FFB9
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 00:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbiFQWHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 18:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiFQWHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 18:07:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FBC1EAC7
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 15:07:48 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 31so5088900pgv.11
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 15:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=Lcw11kKN0B0AOmYUAOoyK3Jql9n8xcmyqWWeaz2fjD0=;
        b=CbMhVf/eIbpEXIOZNw0vqbebQWyTfqZ/GBzrImsnzVAvN+1G9nvQvOs46eIzfO7Wz/
         PjdwHK/SMsqb+rZqWbtrkvOu2kMGRTcYFEAFmRkLM5Gx0uHfepBgLKSO7XzzYHml4wPM
         4s7O7TKVqoNKXH3HWv+x7V2jbVly1Gkh1hFd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=Lcw11kKN0B0AOmYUAOoyK3Jql9n8xcmyqWWeaz2fjD0=;
        b=yWJEro7HAig828dcD1HdcKLuEw+le6o2kpCZdRkN3/Y5GtoAlDTauU+xRCxcjYEMFu
         9H6TBRbKbyrspItpAWU2FjZ2Xvq3+bjxfcZMems9ClIlDltF8va8k4Ygxz4+L2vWfMyw
         tM9mXThMy9R12jaMN7j+K+5PxOTmSAxbMBUSpTEv07Ll94QoEGQ/6Iirp3TTX2hd5qqg
         HrbKgBGuqWYyKxtViLv53cbOqLH/8n/8JoT7zKtU5dy8ephBsX6WezaftGB8iUPviaoC
         jnNVi2pLyGglz2hn4NsOB2XkthLl9en+tLUa+Do0EJ7LQGzmrMwxsdG29q1zc7g7QI+M
         YnJw==
X-Gm-Message-State: AJIora/ucHh5w008cuq7shCfTlfZnAqU4dDz7ZwRTG+jpW56JSwnHnxT
        aC2OPVV+oJojwfYDTHat1QfuhQ==
X-Google-Smtp-Source: AGRyM1sja3tS/EBBuNcebQck0Kw8hBryWN0rGahtDRe5D0TBnZt2tXsovm4mStLZEKnP7NZqRIskMg==
X-Received: by 2002:a63:9dc9:0:b0:408:dcec:d291 with SMTP id i192-20020a639dc9000000b00408dcecd291mr10835425pgd.592.1655503668259;
        Fri, 17 Jun 2022 15:07:48 -0700 (PDT)
Received: from driver-testing.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b00165103c9903sm4026239plb.113.2022.06.17.15.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 15:07:47 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, toke@redhat.com, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Andy Gospodarek <gospo@broadcom.com>
Subject: [PATCH net-next] samples/bpf: fixup some xdp progs to be able to support xdp multibuffer
Date:   Fri, 17 Jun 2022 22:07:38 +0000
Message-Id: <20220617220738.3593-1-gospo@broadcom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000017426605e1abfc18"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000017426605e1abfc18
Content-Transfer-Encoding: 8bit

This changes the section name for the bpf program embedded in these
files to "xdp.frags" to allow the programs to be loaded on drivers that
are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
the buffers, the packet data is now accessed via xdp helper functions to
provide an example for those who may need to write more complex
programs.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
---
 samples/bpf/xdp1_kern.c            | 13 ++++++++++---
 samples/bpf/xdp2_kern.c            | 13 ++++++++++---
 samples/bpf/xdp_tx_iptunnel_kern.c |  2 +-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
index f0c5d95084de..a798553fca3b 100644
--- a/samples/bpf/xdp1_kern.c
+++ b/samples/bpf/xdp1_kern.c
@@ -39,17 +39,24 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
 	return ip6h->nexthdr;
 }
 
-SEC("xdp1")
+#define XDPBUFSIZE	64
+SEC("xdp.frags")
 int xdp_prog1(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	__u8 pkt[XDPBUFSIZE] = {};
+	void *data_end = &pkt[XDPBUFSIZE-1];
+	void *data = pkt;
 	struct ethhdr *eth = data;
 	int rc = XDP_DROP;
 	long *value;
 	u16 h_proto;
 	u64 nh_off;
 	u32 ipproto;
+	int err;
+
+	err = bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt));
+	if (err < 0)
+		return rc;
 
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index d8a64ab077b0..1502ef820aed 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -55,17 +55,24 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
 	return ip6h->nexthdr;
 }
 
-SEC("xdp1")
+#define XDPBUFSIZE	64
+SEC("xdp.frags")
 int xdp_prog1(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	__u8 pkt[XDPBUFSIZE] = {};
+	void *data_end = &pkt[XDPBUFSIZE-1];
+	void *data = pkt;
 	struct ethhdr *eth = data;
 	int rc = XDP_DROP;
 	long *value;
 	u16 h_proto;
 	u64 nh_off;
 	u32 ipproto;
+	int err;
+
+	err = bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt));
+	if (err < 0)
+		return rc;
 
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
index 575d57e4b8d6..0e2bca3a3fff 100644
--- a/samples/bpf/xdp_tx_iptunnel_kern.c
+++ b/samples/bpf/xdp_tx_iptunnel_kern.c
@@ -212,7 +212,7 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 	return XDP_TX;
 }
 
-SEC("xdp_tx_iptunnel")
+SEC("xdp.frags")
 int _xdp_tx_iptunnel(struct xdp_md *xdp)
 {
 	void *data_end = (void *)(long)xdp->data_end;
-- 
2.25.1


--00000000000017426605e1abfc18
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVkwggRBoAMCAQICDBPdG+g0KtOPKKsBCTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDAyMzhaFw0yMjA5MjIxNDExNTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD0FuZHkgR29zcG9kYXJlazEtMCsGCSqGSIb3
DQEJARYeYW5kcmV3Lmdvc3BvZGFyZWtAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAp9JFtMqwgpbnvA3lNVCpnR5ehv0kWK9zMpw2VWslbEZq4WxlXr1zZLZEFo9Y
rdIZ0jlxwJ4QGYCvxE093p9easqc7NMemeMg7JpF63hhjCksrGnsxb6jCVUreXPSpBDD0cjaE409
9yo/J5OQORNPelDd4Ihod6g0XlcxOLtlTk1F0SOODSjBZvaDm0zteqiVZb+7xgle3NOSZm3kiCby
iRuyS0gMTdQN3gdgwal9iC3cSXHMZFBXyQz+JGSHomhPC66L6j4t6dUqSTdSP07wg38ZPV6ct/Sv
/O2HcK+E/yYkdMXrDBgcOelO4t8AYHhmedCIvFVp4pFb2oit9tBuFQIDAQABo4IB3zCCAdswDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDApBgNVHREEIjAggR5hbmRyZXcuZ29zcG9kYXJla0Bicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYI
KwYBBQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFKARn7Ud
RlGu+rBdUDirYE+Ee4TeMA0GCSqGSIb3DQEBCwUAA4IBAQAcWqh4fdwhDN0+MKyH7Mj0vS10E7xg
mDetQhQ+twwKk5qPe3tJXrjD/NyZzrUgguNaE+X97jRsEbszO7BqdnM0j5vLDOmzb7d6qeNluJvk
OYyzItlqZk9cJPoP9sD8w3lr2GRcajj5JCKV4pd2PX/i7r30Qco0VnloXpiesFmNTXQqD6lguUyn
nb7IGM3v/Nb7NTFH8/KUVg33xw829ztuGrOvfrHfBbeVcUoOHEHObXoaofYOJjtmSOQdMeJIiBgP
XEpJG8/HB8t4FF6A8W++4cHhv0+ayyEnznrbOCn6WUmIvV2WiJymRpvRG7Hhdlk0zA97MRpqK5yn
ai3dQ6VvMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBu
di1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIM
E90b6DQq048oqwEJMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCDoyZuJUCQfxXYI
h5NUgGr09pXHCwIJFDgtQZfX+95o4DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA2MTcyMjA3NDhaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEABsWNFcvYW5RsIabAcYOg6S4SukG72kyP
sYsX1Pg+O/7KhvlbMcaeKqm6wedgOMvO2qHOI/RZ8/ZuO3SvpCs1pObBj7lad9NDp5qOgsMEjm2L
SKeabE+NwYTg3IvOSSWCIXYEleOCvVxCUDOGNtYodoqyWhcQNvTEIq9WZ26sbGOwNErNPfnWckOo
OfcbbKRbMg/3xfAv8gkEJkIxIlcB225R+XsS1VBWsfL9tDGChgP4xYDUXmwpczUZtEV3CRxpMbAE
atsSVK46uCb3wN0V6MLgiJIgWI5tajkfJo5ILOqK+dwOOU3BHk/1/mGnDp7I//iiE6NV+wMBkpQi
dY44lg==
--00000000000017426605e1abfc18--
