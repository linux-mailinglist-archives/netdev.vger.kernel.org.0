Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E423A6413
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhFNLUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:20:46 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:55895 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbhFNLR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:17:27 -0400
Received: by mail-pj1-f46.google.com with SMTP id k7so9503782pjf.5
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 04:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=4mEPM/hkZyhpjS71lvgPrA6xJGFWf93wJ5GIjqE+KcQ=;
        b=TfM4jnhGMIHtBkOLxTNQBB6gpvXyut85Nr0qroG2RtYEZd0yqMuRWt6hcX+wCDuVAQ
         nblaGX+3LDB13ExqYmrNGOZY3GzajUh61eVPEMFRu12cojbM9K9wcVoG55kSoO9RcGuf
         yI3cM0bFFCIdhKSzs5+xnO/7FmrH+8lCOJYUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=4mEPM/hkZyhpjS71lvgPrA6xJGFWf93wJ5GIjqE+KcQ=;
        b=nLFn7qpNRFRMhsx7o2JPsV2usyq02OyInysb26DnLzwptTkaIVDeVMNNQMSMbyHrYc
         s7zX1B+BPBuH/gUt9YADrb4j8J0MDoMn5AxSYVLEZOA0gTExTYAB9h0/UhCPiCpNKKAW
         ltWcAN6fSvSKfoOuQMU3dQPyJd2N8TgYu0KcUT+zj0HEK3iEdhJlXfOopX4uKtAE07Z3
         WJHoYVNzEzR9Cw7mosTJO7N86e5gydo2qZnZ4TFRkYZ8QlOYu+j1v+uUlZVKXkKtcijj
         v68STv1eDpmYLNjQdTkX+Voq2p4GIo4wbWjCbaQrw2JvHrLnvkUOtuLSOu1o5GyXw5UO
         0Y5Q==
X-Gm-Message-State: AOAM533Dlnn0lkkhKEJRuqt9J6qOIGW4YStYbcd33HjyPS1urInMfCWM
        7GzIQRwU23sTNkQdvWXuO4yzidYc8uOOVeGheM4MA3J4jFoB1UzXTj4I37iDf5M7mqNv7/TH6sq
        2cJsfDhYDbehSPbrYwgKUiVcPvxkQbLEVFRMBecZxsbffHGBWuxTXV3/lGXyt4RC0LBSKjLJdcW
        bP6J5M
X-Google-Smtp-Source: ABdhPJwyA5klQ8PeHPVRtr47VLREE2CEx6oc0/WUXigoIe4LJp/LSJH1nQnsU2u4I3E3TgtozjH0Bw==
X-Received: by 2002:a17:90a:af90:: with SMTP id w16mr7778883pjq.129.1623669264225;
        Mon, 14 Jun 2021 04:14:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id q9sm8850226pjd.9.2021.06.14.04.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 04:14:23 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next] net/sched: cls_flower: Remove match on n_proto
Date:   Mon, 14 Jun 2021 14:13:22 +0300
Message-Id: <20210614111322.26914-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.3
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c20dd905c4b7f542"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c20dd905c4b7f542
Content-Transfer-Encoding: 8bit

The following flower filters fail to match packets:

tc filter add dev eth0 ingress protocol 0x8864 flower \
	action simple sdata hi64
tc filter add dev eth0 ingress protocol 802.1q flower \
	vlan_ethtype 0x8864 action simple sdata "hi vlan"

The protocol 0x8864 (ETH_P_PPP_SES) is a tunnel protocol. As such, it is
being dissected by __skb_flow_dissect and it's internal protocol is
being set as key->basic.n_proto. IOW, the existence of ETH_P_PPP_SES
tunnel is transparent to the callers of __skb_flow_dissect.

OTOH, in the filters above, cls_flower configures its key->basic.n_proto
to the ETH_P_PPP_SES value configured by the user. Matching on this key
fails because of __skb_flow_dissect "transparency" mentioned above.

In the following, I would argue that the problem lies with cls_flower,
unnessary attempting key->basic.n_proto match.

There are 3 close places in fl_set_key in cls_flower setting up
mask->basic.n_proto. They are (in reverse order of appearance in the
code) due to:

(a) No vlan is given: use TCA_FLOWER_KEY_ETH_TYPE parameter
(b) One vlan tag is given: use TCA_FLOWER_KEY_VLAN_ETH_TYPE
(c) Two vlans are given: use TCA_FLOWER_KEY_CVLAN_ETH_TYPE

The match in case (a) is unneeded because flower has no its own
eth_type parameter. It was removed by Jamal Hadi Salim in commit
488b41d020fb06428b90289f70a41210718f52b7 in iproute2. For
TCA_FLOWER_KEY_ETH_TYPE the userspace uses the generic tc filter
protocol field. Therefore the match for the case (a) is done by tc
itself.

The matches in cases (b), (c) are unneeded because the protocol will
appear in and will be matched by flow_dissector_key_vlan.vlan_tpid.
Therefore in the best case, key->basic.n_proto will try to repeat vlan
key match again.

The below patch removes mask->basic.n_proto setting and resets it to 0
in case (c).

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/sched/cls_flower.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index d7869a984881..2e704c7a105a 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1531,14 +1531,13 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 						       &mask->basic.n_proto,
 						       TCA_FLOWER_UNSPEC,
 						       sizeof(key->basic.n_proto));
+					mask->basic.n_proto = cpu_to_be16(0);
 				} else {
 					key->basic.n_proto = ethertype;
-					mask->basic.n_proto = cpu_to_be16(~0);
 				}
 			}
 		} else {
 			key->basic.n_proto = ethertype;
-			mask->basic.n_proto = cpu_to_be16(~0);
 		}
 	}
 
-- 
2.29.3


--000000000000c20dd905c4b7f542
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPuruPtwjskBkeF/
/yneHb+9Nv/Aud+xgV8NXFhfeBo1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDYxNDExMTQyNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDEb/32l2HzBuyGO52h8bzkTiUlvWQwijgU
g5kuinFLh5afL0I/unbrD80QcTjITO60H2qZNYden3WrwSso2w2Ity4J04jD2UZZdO/VvH3EIl+x
i78UtwFqa9r2Ek7tbAIALaW4sNpEb13rxhA6ZdWom23fKU/SmKo8Sb4gEYcQpRZRk0lGXbtgRNQI
bUfl2xuQheumU3DEB0D6tIdWlgHentdohrXb8359ZybTgvwobX8eFqUZZrK6jVlqPH8YHLtHQ4/n
o0n8JDsORzdfDfZBsi5StTo18u1J1UnI5yA/7X9ej7NEO0zzUuGL9VoIQ3YoCzREBjuxzm6q66Cg
ZtcM
--000000000000c20dd905c4b7f542--
