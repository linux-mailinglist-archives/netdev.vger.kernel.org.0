Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF402500E1D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbiDNMyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240566AbiDNMyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:54:31 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D0192320
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:52:07 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id t2so3415869qtw.9
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=phmsGVxFARIdBuJu/YQGX4HGvJHHCFWteZnoiFypqS0=;
        b=OfTWOUodt6VHf0opxQ+u8QbI3/q/zTDMhMvy6Dm5NQU08Ao2eHWSPsh9Kxm1gvG/GB
         GNZpNjdrhKt1OGk/qqgKoB9bO7Y+M8/8mDrIhZLcc7eqYGjVaMiJ4OxkU03W8M7oMopF
         CclioIvkdRh47DyZpcFp3NZXH8Hh0uzIBE4J4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=phmsGVxFARIdBuJu/YQGX4HGvJHHCFWteZnoiFypqS0=;
        b=H/d5r/+gCf4NnFUKd4ufsQLmUFLAEU2g+w3uhbxmkuz5R4iW9kl2hpwW8QB4gOFrMc
         bfUtFWFiVw57HnOzRZBgRGuist+KpJVzZXcmc0/AjGGGKihsM6uvcHtNmFmPxy8QST9T
         wooS7djwID67T0KipGYks+7e5z+SyAKFXHixF0ISkbjNl4FzlojGznpvM7zs6ZET7iEK
         yAdtINyfgGozfywXkvNC1vhohLdOD9AOb1Xu1NG98xinCc56w7z1d1DY4oREsWFC3U/L
         pDqlAUisEhLcOaW0EQlS2ZBlQi6jTYxdeaZ5gxEq1wKD6D341Xyj9ykfGIi3Bv8kowor
         MVCw==
X-Gm-Message-State: AOAM530iYJocs7pJCaA8257IOE0BbNnhqAt9qEh6zmsNgRtmv7a8AtX4
        RA5ptfEr0glnWNa4TJTw2F/wkrnIfFX8huOBg6gi4RgHuhtb8WOkQIoP6rvy+u4et97c+Ha9A0F
        cZELbWsp32vXmSoZDi8v5TAO88JG1QBPDYgD3eruKGLJ/6ZFXE09NDSSZ6R7yLwnv/dDaf/627c
        OlnkOHesF/Ww==
X-Google-Smtp-Source: ABdhPJyz4eX3h4eCabUmGAFQAnam2DLqVLngO92tf5pxpJH7jEYJ96ifpDOZWtQaCwgUiteeiGvGLA==
X-Received: by 2002:ac8:5883:0:b0:2e1:c6f9:a12f with SMTP id t3-20020ac85883000000b002e1c6f9a12fmr1557741qta.439.1649940725771;
        Thu, 14 Apr 2022 05:52:05 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id o10-20020a05620a15ca00b0069c39e2970bsm875910qkm.80.2022.04.14.05.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 05:52:05 -0700 (PDT)
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
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next v3 1/5] net/sched: flower: Helper function for vlan ethtype checks
Date:   Thu, 14 Apr 2022 15:51:17 +0300
Message-Id: <20220414125121.13599-2-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220414125121.13599-1-boris.sukholitko@broadcom.com>
References: <20220414125121.13599-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e1917605dc9cc271"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e1917605dc9cc271
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
index 87e030dfc328..9a9b7849e657 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1573,6 +1573,21 @@ static int fl_set_key_ct(struct nlattr **tb,
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
@@ -1595,17 +1610,12 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
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
@@ -1615,15 +1625,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
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


--000000000000e1917605dc9cc271
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJy3n7poaVpuWqcH
PARVOzd24BlgtI7jhVmP5xew9uk8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQxNDEyNTIwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAuQoXdN1jAei8Iu7rexnsRWEjpCvj7Eybj
oo5MvvNJs40Akx8yrDQ9HegYtWcJGiB53mY72OUt1V+zLoYqBsj2ee3DuhFi9UX+7KlO2QZ6duyD
8xM7IW1jWAecUNXos01lgwvzdx5AKMVrFM/1Ql6unGBar6vMxEuE2N6bs8UqhsgLMYoCjx56WbKe
DAZfI9NUGVBa2mPVUjPQomBdvbBtX/gXjjjSB5eMmAB1MUGi0ifFko5S5MbSUxSQT8kvO98G6kks
5xuLavA6rWvVb9vfzNJw0qhdLGquBYNnwNcjBQKMrCWQ4XSiJNx2s7Bfuf95eXDM7RssiY5cGlc0
A5wQ
--000000000000e1917605dc9cc271--
