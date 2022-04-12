Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA234FDE55
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346166AbiDLLTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241585AbiDLLRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:17:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03E3972C6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:03:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso1559841pjj.1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=V+nemT9Ud/JIWkiLHUEFLukYg/HG4bV42mp8IeM6TBQ=;
        b=dZRLxBiDxAgrqiS9CfmdzVKuKAuWND1p3Eth651w1kaf69U6v9uDtsFRBDlpzfPMbY
         pR6kl2Aj5nnO5V+wie3oQ90QcYqN6qbv7GFTCqxRLWujMQJARxjdS6FpK9aBb1Kb0AwK
         893x4ER0Kn8+q4UvJYZ+vazBF8a+ip78FJLAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=V+nemT9Ud/JIWkiLHUEFLukYg/HG4bV42mp8IeM6TBQ=;
        b=QsW5U105KGlM1CGAJ/gCocywKDY40diKlDDlCl2H/VBv+37sSckyMJvRK0s8NmTDwR
         jhcsK6VaamvuLeYB9LngKJAziiMkLXTZr9EezVLB5LnOLC6aVjboEHkbrcERpXnCGFas
         bO2iHFOAnVwlyMLxXM1YUYNUOeA5o63B/FYIJN83YjBkCvGNO85Nh1/FwA0A2JbOjMc2
         5NLyzhcc3IvRf33zmMuR1cvg/r9LKUP5n4PaBN9VzXMskeg2MR3fQwVapksqktWaoRXI
         iVqcWpbg7FyHgA76CE7Tr553jiWvSh8Vd8ayE7hk3W4asscIrCGcbHBtwzJvqkzcKYKX
         tUaA==
X-Gm-Message-State: AOAM5326q2a7/7JKSDjiF9Xnmy1s3xKC6FB1eaSRBps0T2dIe6nItSb5
        IwBNykyQV/bMgp/2yoMPPwgCux8cpPfnItChjc59Usvh3WOmriRv6xqMFl4HsMnYchsxdbUfDj4
        iK/+qYBzrRq1z02SvwlQcJqQ0pn+dYSdSftp6H7pcbSz1h8aWjU3KA3e4M94l/xy5Zn833W5b11
        mwJ9HZ8Vg6/A==
X-Google-Smtp-Source: ABdhPJxCKOf+Q2yEluCY2V6VvpJM0YYaRDK4ibkXHLEofr08/WIhp+ChwSHHeisnlkvnFMRcQ3QJxA==
X-Received: by 2002:a17:90b:224f:b0:1c9:949e:2202 with SMTP id hk15-20020a17090b224f00b001c9949e2202mr4063031pjb.56.1649757808520;
        Tue, 12 Apr 2022 03:03:28 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id u17-20020a056a00159100b004faef351ebcsm37020020pfk.45.2022.04.12.03.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:03:27 -0700 (PDT)
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
Subject: [PATCH net-next v2 5/5] net/sched: flower: Consider the number of tags for vlan filters
Date:   Tue, 12 Apr 2022 13:02:36 +0300
Message-Id: <20220412100236.27244-6-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220412100236.27244-1-boris.sukholitko@broadcom.com>
References: <20220412100236.27244-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002a36f805dc722cbd"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002a36f805dc722cbd
Content-Transfer-Encoding: 8bit

Currently the existence of vlan filters is conditional on the vlan
protocol being matched in the tc rule. I.e. the following rule:

tc filter add dev eth1 ingress flower vlan_prio 5

is illegal because we lack protocol 802.1q in the rule.

Having the num_of_vlans filter configured removes this restriction. The
following rule becomes ok:

tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5

because we know that the packet is single tagged.

We achieve the above by having is_vlan_key helper look at the number of
vlans in addition to the vlan ethertype. Outer tag vlan filters (e.g.
vlan_prio) require the number of vlan tags be greater than 0. Inner
filters (e.g. cvlan_prio) require the number of vlan tags be greater
than 1.

Number of vlans filter may cause ethertype to be set to 0. Check this in
fl_set_key_vlan.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/sched/cls_flower.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index fafb74198c8d..9bf15b44292c 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1029,8 +1029,10 @@ static void fl_set_key_vlan(struct nlattr **tb,
 			VLAN_PRIORITY_MASK;
 		key_mask->vlan_priority = VLAN_PRIORITY_MASK;
 	}
-	key_val->vlan_tpid = ethertype;
-	key_mask->vlan_tpid = cpu_to_be16(~0);
+	if (ethertype) {
+		key_val->vlan_tpid = ethertype;
+		key_mask->vlan_tpid = cpu_to_be16(~0);
+	}
 }
 
 static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
@@ -1576,13 +1578,18 @@ static int fl_set_key_ct(struct nlattr **tb,
 }
 
 static bool is_vlan_key(struct nlattr *tb, __be16 *ethertype,
-			struct fl_flow_key *key, struct fl_flow_key *mask)
+			struct fl_flow_key *key, struct fl_flow_key *mask,
+			int vthresh)
 {
-	if (!tb)
-		return false;
+	const bool good_num_of_vlans = key->num_of_vlans.num_of_vlans > vthresh;
+
+	if (!tb) {
+		*ethertype = 0;
+		return good_num_of_vlans;
+	}
 
 	*ethertype = nla_get_be16(tb);
-	if (eth_type_vlan(*ethertype))
+	if (good_num_of_vlans || eth_type_vlan(*ethertype))
 		return true;
 
 	key->basic.n_proto = *ethertype;
@@ -1617,12 +1624,13 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		       TCA_FLOWER_UNSPEC,
 		       sizeof(key->num_of_vlans));
 
-	if (is_vlan_key(tb[TCA_FLOWER_KEY_ETH_TYPE], &ethertype, key, mask)) {
+	if (is_vlan_key(tb[TCA_FLOWER_KEY_ETH_TYPE], &ethertype, key, mask, 0)) {
 		fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
 				TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
 				&mask->vlan);
 
-		if (is_vlan_key(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE], &ethertype, key, mask)) {
+		if (is_vlan_key(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE],
+				&ethertype, key, mask, 1)) {
 			fl_set_key_vlan(tb, ethertype,
 					TCA_FLOWER_KEY_CVLAN_ID,
 					TCA_FLOWER_KEY_CVLAN_PRIO,
-- 
2.29.2


--0000000000002a36f805dc722cbd
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHvGmJhKAyFJkdNK
imrE5/ZgprZTWn0zf3acMnnSp0oTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQxMjEwMDMyOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAypSyr2WeI9NFIqTtmVImK8QjnmsPCIPAq
NSQG14kcWmVe5RNlumy7I1KmHDcEqWXukyG/tvH1JrceCa6c7U2mN1RJMvyyrDyybP+a6wPysCLh
8/TB4OYYvakC2oBvbA7JU/13X4eLl5MObROZKz+T2p6lIZUulR+G6z8gbG5FnGbUOs11Fpgn8LGO
xtg3ZNVtZ59XHxV+pXLJ1EuWpfYoCPNEsHs7ezBAuADLOH25t59Hux+xepQmxRySKnsobOCPnBqJ
jpfXRMGreNEnNh/UR7m+oYBPfOhZMYfgRoIfZ1MgoQzAPNdn3soiwGvc27oOLNMvG4FcrFRWd+gz
9QGg
--0000000000002a36f805dc722cbd--
