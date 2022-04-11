Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0F44FBD20
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346509AbiDKNdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbiDKNdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:33:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FD63BA79
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:31:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso18399279pju.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=676tlC8V+fD6Y2L0zNJ5Godg1bIryaH83HQ0927Kk8I=;
        b=DbI9qIVL7zGvHPBGxDpfDCNYoOJzAm0g4hDgprtOF7jNymRTzYYv+WWtEX4w24XYph
         eRYEh6jJyB0BVAz551pPTb0lQo4eHbE4cobje6IIjRR2eWcMQpusqSss0hBly336V9al
         hKNU5UKs4UTUe1MVTk/3hGTmJCw3nmUR+d8c0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=676tlC8V+fD6Y2L0zNJ5Godg1bIryaH83HQ0927Kk8I=;
        b=ziWZR26IL0jB03/lJOxeBZMHkw7ZCFGwUJ0nBGx+q7iJ2xTCeNCZQMBqRcIzoAcUUH
         F73O86ce9OF0L9LoW9AfIjwyZdjV3QFSF8pNKhzyjk6sW7ivPEfxARjdRZZOIPx0N0VE
         CAxXEvdHPRL6QkFun9vaDNW1y4GFCY01XVK3VjI/XVpGRJlTxYouriDHbuRxMSfKvays
         GjXxWqp4GsVUvhJmTRk7O5Q4BNE1C3143r4qDCgJndSr15Bg5sTe+CFhosUGrX2KgP7c
         /ZK/5uWg30nfucofEVKVG80mRTIpTyfHW64N+PDGs9CKfuodyt3hb4vHnvhTxbaaBq2c
         8Tew==
X-Gm-Message-State: AOAM530hBUkPdL8Yan4mOdQqXeILk+A/Eely296VyHIneo+GPy794kXt
        sx2AYsm6fRsFA/ZSkar9/KmLxiL0OC6/xhaZJU/WJEY7js5JG3jJL5gY4mY12NEch/TXPpttuZn
        EmcWEH6zUt0qGvF/FkQV327o2GZb6eQA61AHZrVQOvmBYXm6E+zaDkNAqW+MDJSJAkc+CThwbtJ
        72pD/13hc+0g==
X-Google-Smtp-Source: ABdhPJxavH6riJJDLDKFXdm0x0RfVb1zEyBJdDyB4ucC9xB4m5jWyBduKe6r206gZO6uql4ehkjMsg==
X-Received: by 2002:a17:902:ecc4:b0:156:b8ab:3ad with SMTP id a4-20020a170902ecc400b00156b8ab03admr32694565plh.132.1649683894892;
        Mon, 11 Apr 2022 06:31:34 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm35716311pfx.34.2022.04.11.06.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:31:34 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next 1/5] Helper function for vlan ethtype checks
Date:   Mon, 11 Apr 2022 16:30:56 +0300
Message-Id: <20220411133100.18126-2-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220411133100.18126-1-boris.sukholitko@broadcom.com>
References: <20220411133100.18126-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000937c9505dc60f665"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000937c9505dc60f665
Content-Transfer-Encoding: 8bit

There are somewhat repetitive ethertype checks in fl_set_key. Refactor
them into is_vlan_key helper function.

To make the changes clearer, avoid touching identation levels. This is
the job for the next patch in the series.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/sched/cls_flower.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 1a9b1f140f9e..6c355b293f02 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1492,6 +1492,21 @@ static int fl_set_key_ct(struct nlattr **tb,
 	return 0;
 }
 
+static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
+			struct fl_flow_key *key, struct fl_flow_key *mask)
+{
+	if (!tb)
+		return false;
+
+	*ethertype = nla_get_be16(tb);
+	if (eth_type_vlan(*ethertype))
+		return true;
+
+	key->basic.n_proto = *ethertype;
+	mask->basic.n_proto = cpu_to_be16(~0);
+	return false;
+}
+
 static int fl_set_key(struct net *net, struct nlattr **tb,
 		      struct fl_flow_key *key, struct fl_flow_key *mask,
 		      struct netlink_ext_ack *extack)
@@ -1514,17 +1529,12 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		       mask->eth.src, TCA_FLOWER_KEY_ETH_SRC_MASK,
 		       sizeof(key->eth.src));
 
-	if (tb[TCA_FLOWER_KEY_ETH_TYPE]) {
-		ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_ETH_TYPE]);
-
-		if (eth_type_vlan(ethertype)) {
+	if (is_vlan_key(tb[TCA_FLOWER_KEY_ETH_TYPE], &ethertype, key, mask)) {
 			fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
 					TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
 					&mask->vlan);
 
-			if (tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]) {
-				ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]);
-				if (eth_type_vlan(ethertype)) {
+			if (is_vlan_key(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE], &ethertype, key, mask)) {
 					fl_set_key_vlan(tb, ethertype,
 							TCA_FLOWER_KEY_CVLAN_ID,
 							TCA_FLOWER_KEY_CVLAN_PRIO,
@@ -1534,15 +1544,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 						       &mask->basic.n_proto,
 						       TCA_FLOWER_UNSPEC,
 						       sizeof(key->basic.n_proto));
-				} else {
-					key->basic.n_proto = ethertype;
-					mask->basic.n_proto = cpu_to_be16(~0);
-				}
 			}
-		} else {
-			key->basic.n_proto = ethertype;
-			mask->basic.n_proto = cpu_to_be16(~0);
-		}
 	}
 
 	if (key->basic.n_proto == htons(ETH_P_IP) ||
-- 
2.29.2


--000000000000937c9505dc60f665
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
XzCCBVgwggRAoAMCAQICDDSzinKpvcPTN4ZIJTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNzMwMDRaFw0yMjA5MDUwNzM3NTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAy/C7bjpxs+95egWV8sWrK9KO0SQi6Nxu14tJBgP+MOK5tvokizPFHoiXTymZ
7ClfnmbcqT4PzWgI3thyfk64bgUo1nQkCTApn7ov3IRsWjmHExLSNoJ/siUHagO6BPAk4JSycrj5
9tC9sL4FnIAbAHmOSILCyGyyaBAcmiyH/3toYqXyjJkK+vbWQSTxk2NlqJLIN/ypLJ1pYffVZGUs
52g1hlQtHhgLIznB1Qx3Fop3nOUk8nNpQLON/aM8K5sl18964c7aXh7YZnalUQv3md4p2rAQQqIR
rZ8HBc7YjlZynwOnZl1NrK4cP5aM9lMkbfRGIUitHTIhoDYp8IZ1dwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtBmGs9S4
t1FcFSfkrP2LKQQwBKMwDQYJKoZIhvcNAQELBQADggEBAJMAjVBkRmr1lvVvEjMaLfvMhwGpUfh6
CMZsKICyz/ZZmvTmIZNwy+7b9r6gjLCV4tP63tz4U72X9qJwfzldAlYLYWIq9e/DKDjwJRYlzN8H
979QJ0DHPSJ9EpvSKXob7Ci/FMkTfq1eOLjkPRF72mn8KPbHjeN3VVcn7oTe5IdIXaaZTryjM5Ud
bR7s0ZZh6mOhJtqk3k1L1DbDTVB4tOZXZHRDghEGaQSnwU/qxCNlvQ52fImLFVwXKPnw6+9dUvFR
ORaZ1pZbapCGbs/4QLplv8UaBmpFfK6MW/44zcsDbtCFfgIP3fEJBByIREhvRC5mtlRtdM+SSjgS
ZiNfUggxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw0
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBfLGRYlL1wO2X0x
O97wQQk2H22K+XnxHcZcChV+59aGMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQxMTEzMzEzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBVhwGDVe0Q6nqa+/tzyMnmsFuORes+iDAA
uG3ubE1dJGy25+3qQx5qcDCzCQZ7NO+Zq5nS9uYEuHmkZ0FsXPUBNYcQw3BSzzZ7tR3EfmwmJ3jU
XbONAyARJfLCbpOlffjTmikyWaH0/eS1fcdcSzBY7nImvQQBK4l7ejUmZF5U14ZrB8GRdKRErjKQ
qxEGAIjwtbe/dwS/eN+2VKA62WSC51NqZ4Rx5jhXWd6Qf9GqW2CNmN1ibzWdp4MmJfT2KMY0y+UI
N1hgSP4CETLgm76xqpF/Nuj3zUNE1mwT0btP5tkz5gsO8+gDB484Ui3oc83hPU/1UkkzYwfdGsEn
Okm1
--000000000000937c9505dc60f665--
