Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E1B3FB23D
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 10:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhH3IKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 04:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhH3IKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 04:10:06 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC671C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 01:09:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q68so12612202pga.9
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 01:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=x2tN/h5+mJI2LGzTVLuuL5eUheia6qyastuCgNr3a38=;
        b=WwSDzwHrnWmvogvMeffxtfRQh6w9xE2kxdechljRHfyzhZTe0vi5pb1UaI9DYIcejg
         tMlpHAciY8riwpbHp2+YQjiI7zKQHHO1/NKvuqJjdcPxDMhcKffSJkd0WaUwNO+8r+fq
         KXUbzUw7DN2k/w0JiLABhAobv4U+CsjE3yvzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=x2tN/h5+mJI2LGzTVLuuL5eUheia6qyastuCgNr3a38=;
        b=tnrOsNxqCYDg8a3dnjnEbiZSwBuN+SY7pqQx07VtAhl+ghgcXckiOyp+Wx3cDtmXuF
         cN8dtk3FwSnOQ2b66nO0+1pIQRK1KUKAC21k8/LJ7TS2vYGKj3x/QumzIyLf2UK4JqVR
         VnLcqvxW/yG7fVwtvTxYMmsEjlNbg4nDnNOX5uU6XrXTlr23jrL1kpahO3CzSAMItYCN
         6FYFRCGqX1UKP9P0ROo5Z3oqyPLC+96Oh5upuPYBmGwvPA9CS8U2c52FuP2jP8of4Prs
         gg1qNd20d6ROQD7oWKimC+BWlFukC6M1nyznsQ3D8iMIss2mvc5fsT3Ws7O/5y6+3pPj
         3gQA==
X-Gm-Message-State: AOAM530xbK/Y53J5fI28VEWEpKh6t+9eCKFgoY1/09ukwkcV8xqhXcm9
        XL+YVnNakqdpEc3luNOA9PWs4jjroPQHgECaNnby+pPpHrgIT+CR7SdchnmCbkFA4tA/vBXLUah
        Avo5yhPUDJMnQ3qZizfDxuW8RXsRJDupE5nndVqlJiLU9NL6aD/QBZxzZ0MDEp/nuIX/JaVUSyA
        CQj77BqNI=
X-Google-Smtp-Source: ABdhPJwmfiqp5PqwoxQUtkbMqOGaT7DRFG9XOg6DZzibc4JjceXCMzNI7CPsDdnufpukT95exqwzQQ==
X-Received: by 2002:a63:4b60:: with SMTP id k32mr20683813pgl.198.1630310951917;
        Mon, 30 Aug 2021 01:09:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id t15sm16178349pgi.80.2021.08.30.01.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 01:09:11 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH iproute2-next] flower: add orig_ethtype key
Date:   Mon, 30 Aug 2021 11:08:49 +0300
Message-Id: <20210830080849.18695-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000030f42405cac2593c"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000030f42405cac2593c
Content-Transfer-Encoding: 8bit

The following flower filter fails to match packets:

tc filter add dev eth0 ingress protocol 0x8864 flower \
        action simple sdata hi64

The following is explanation of the issue on the kernel side.

The protocol 0x8864 (ETH_P_PPP_SES) is a tunnel protocol. As such, it is
being dissected by __skb_flow_dissect and it's internal protocol is
being set as key->basic.n_proto. IOW, the existence of ETH_P_PPP_SES
tunnel is transparent to the callers of __skb_flow_dissect.

OTOH, in the filters above, cls_flower configures its key->basic.n_proto
to the ETH_P_PPP_SES value configured by the user. Matching on this key
fails because of __skb_flow_dissect "transparency" mentioned above.

Therefore there is no way currently to match on such packets using
flower.

To fix the issue add new orig_ethtype key to the flower along with the
necessary changes to the flow dissector etc.

To filter the ETH_P_PPP_SES packets the command becomes:

tc filter add dev eth0 ingress flower orig_ethtype 0x8864 \
        action simple sdata hi64

Corresponding kernel patch was sent separately.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 include/uapi/linux/pkt_cls.h |  1 +
 tc/f_flower.c                | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 025c40fe..238dee49 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -583,6 +583,7 @@ enum {
 	TCA_FLOWER_KEY_HASH,		/* u32 */
 	TCA_FLOWER_KEY_HASH_MASK,	/* u32 */
 
+	TCA_FLOWER_KEY_ORIG_ETH_TYPE,	/* be16 */
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/tc/f_flower.c b/tc/f_flower.c
index c5af0276..935d0cbd 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1431,6 +1431,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			if (check_ifname(*argv))
 				invarg("\"indev\" not a valid ifname", *argv);
 			addattrstrz(n, MAX_MSG, TCA_FLOWER_INDEV, *argv);
+		} else if (matches(*argv, "orig_ethtype") == 0) {
+			__be16 orig_ethtype;
+
+			NEXT_ARG();
+			if (ll_proto_a2n(&orig_ethtype, *argv))
+				invarg("invalid orig_ethtype", *argv);
+			addattr16(n, MAX_MSG, TCA_FLOWER_KEY_ORIG_ETH_TYPE, orig_ethtype);
 		} else if (matches(*argv, "vlan_id") == 0) {
 			__u16 vid;
 
@@ -2582,6 +2589,16 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 			     rta_getattr_str(attr));
 	}
 
+	if (tb[TCA_FLOWER_KEY_ORIG_ETH_TYPE]) {
+		SPRINT_BUF(buf);
+		struct rtattr *attr = tb[TCA_FLOWER_KEY_ORIG_ETH_TYPE];
+
+		print_nl();
+		print_string(PRINT_ANY, "orig_ethtype", "  orig_ethtype %s",
+			     ll_proto_n2a(rta_getattr_u16(attr),
+			     buf, sizeof(buf)));
+	}
+
 	open_json_object("keys");
 
 	if (tb[TCA_FLOWER_KEY_VLAN_ID]) {
-- 
2.29.2


--00000000000030f42405cac2593c
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGX+7ah48W0P2XSX
pygZqI7pQRlkdMXyiEqqIZ2E66LqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDgzMDA4MDkxMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC0isFdS0WApXO4bvXZTbonLfCduy8PclLv
YBc1tJ7N0xaFGP0NZhQIJArL7H3QMZbKQO1PIUYxBSDhUsShqUghed0B2ub9xT0chHmAGiGAieSj
BiQXbOfBbFLhrlesjSnaAckolrzIIOdwkMtDIH87pVHhHAdxP2bcna9gYYh6prbwre/C9t+/QeoP
4/UMMCq3dHi51X92BJrt9oidOH0xI5IFjk2Tj3L9/sw1AFgmCe0FyT2DpDYayBRNoIdfNkaFbaAR
1UqQQRRnJ7glX2zpCqhri6EWI5eSeGZXuC7v06s1riQIydNIxLx9OzHVLBtHcQ+Mk6+Z8b9ybEmc
qBir
--00000000000030f42405cac2593c--
