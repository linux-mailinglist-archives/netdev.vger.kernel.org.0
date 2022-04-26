Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4606650F957
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 11:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348161AbiDZJ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 05:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345113AbiDZJ4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 05:56:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A9E36161
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:14:55 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p12so5707951pfn.0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=kBx8KTV4cCQ5F5Vp4zg+QAENCViNYF/iEP8UvSG/FiU=;
        b=T2ZF+FtRI3el4HdOltD6A47sbXQ7CP/WA1yvqRZzzx0iu2BX+PNMPFHBmujEXKyxYO
         oM/1YihKtvYfdhQHwkfjR6ovlNXIkPEY/SYS7aoFd7MQWfjWpFdzvbofg0sW4RFjjqUa
         jE5G7P1QsY7NpTmIzGTagFMtcK1uqOuu7az+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=kBx8KTV4cCQ5F5Vp4zg+QAENCViNYF/iEP8UvSG/FiU=;
        b=8LOCdp6t2n2S4tCjM4v5T96dN5LqfbYWv1qslf7qddK4x7ZBhovsFYHmNtiqUg1mQR
         +x3cBiw+U3KDrfyd2hvTowDIn8lHip151Of7+4Tkt6N89brt2yVkGKolCZvUIB2e+Ksr
         eUnWjLBOUi+uc39702yt/PeklWabFlXk2pDKj3+K+kgXf04REMoVjK0QbOw6HK3vyeQM
         tKIR/FOAAoik/MiXoWCVWsV8nMYfhlp/BoEER+CGmdFbo+frL93qwdFEU5a43YIDy6kz
         eWU89RCcKdUaLAkKt+EhvWUF8SaN4XcyIvtMZpQm1QZY+E47m2PiF9abCLum0Kl4g19k
         5tHg==
X-Gm-Message-State: AOAM531K3CASzyqIOyk67frrsdYqRm1kb7fZGEE8sI4P4SwnFQiesz0F
        lw9iBYbh2a2LbrQNm/naRo5zOr/QrrNi3f0oG4akhrPCl2pOF15wFNPfx4jqv2d1NUkeeqR8qPO
        ACmraHHuvykCoVPRWtiLSjrOM2KbEqPnuO/WTjoP8f9PPzYbVBmkVJ1AhzXq52f7/kXFomi7NXM
        KSuRnZ
X-Google-Smtp-Source: ABdhPJyqsBejtjqWJfonGEdcHzxTEbNFn+5bjEijuMX+gIaJfGQb7HpsjboX722MZcl3qqQ5NNpkUg==
X-Received: by 2002:a63:8b41:0:b0:3ab:6c5:79ba with SMTP id j62-20020a638b41000000b003ab06c579bamr11530417pge.382.1650964494931;
        Tue, 26 Apr 2022 02:14:54 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id z10-20020a62d10a000000b0050d3c3668bcsm7593829pfg.137.2022.04.26.02.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 02:14:54 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH iproute2-next v3 1/2] f_flower: Add num of vlans parameter
Date:   Tue, 26 Apr 2022 12:14:16 +0300
Message-Id: <20220426091417.7153-2-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
References: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000047748205dd8b20e7"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000047748205dd8b20e7
Content-Transfer-Encoding: 8bit

Our customers in the fiber telecom world have network configurations
where they would like to control their traffic according to the number
of tags appearing in the packet.

For example, TR247 GPON conformance test suite specification mostly
talks about untagged, single, double tagged packets and gives lax
guidelines on the vlan protocol vs. number of vlan tags.

This is different from the common IT networks where 802.1Q and 802.1ad
protocols are usually describe single and double tagged packet. GPON
configurations that we work with have arbitrary mix the above protocols
and number of vlan tags in the packet.

This patch adds num_of_vlans flower key and associated print and parse
routines. The following command becomes possible:

tc filter add dev eth1 ingress flower num_of_vlans 1 action drop

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 tc/f_flower.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 686cf121..25ffd295 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -48,6 +48,7 @@ static void explain(void)
 		"\n"
 		"Where: MATCH-LIST := [ MATCH-LIST ] MATCH\n"
 		"       MATCH      := {	indev DEV-NAME |\n"
+		"			num_of_vlans VLANS_COUNT |\n"
 		"			vlan_id VID |\n"
 		"			vlan_prio PRIORITY |\n"
 		"			vlan_ethtype [ ipv4 | ipv6 | ETH-TYPE ] |\n"
@@ -1525,6 +1526,17 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			if (check_ifname(*argv))
 				invarg("\"indev\" not a valid ifname", *argv);
 			addattrstrz(n, MAX_MSG, TCA_FLOWER_INDEV, *argv);
+		} else if (matches(*argv, "num_of_vlans") == 0) {
+			__u8 num_of_vlans;
+
+			NEXT_ARG();
+			ret = get_u8(&num_of_vlans, *argv, 10);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"num_of_vlans\"\n");
+				return -1;
+			}
+			addattr8(n, MAX_MSG,
+				 TCA_FLOWER_KEY_NUM_OF_VLANS, num_of_vlans);
 		} else if (matches(*argv, "vlan_id") == 0) {
 			__u16 vid;
 
@@ -2694,6 +2706,14 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 
 	open_json_object("keys");
 
+	if (tb[TCA_FLOWER_KEY_NUM_OF_VLANS]) {
+		struct rtattr *attr = tb[TCA_FLOWER_KEY_NUM_OF_VLANS];
+
+		print_nl();
+		print_uint(PRINT_ANY, "num_of_vlans", "  num_of_vlans %d",
+			   rta_getattr_u8(attr));
+	}
+
 	if (tb[TCA_FLOWER_KEY_VLAN_ID]) {
 		struct rtattr *attr = tb[TCA_FLOWER_KEY_VLAN_ID];
 
-- 
2.29.2


--00000000000047748205dd8b20e7
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHsYDAuE+TUCznlI
+EAE5hm27aLJDZPG1vUzjr39IIawMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQyNjA5MTQ1NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAZ8xV+LiNB8YdvyVNymhH/iKzAcUzNuTuV
1KOosD6x9z1GdGNw+fX3dejewesr1r4zp1lweJd6EVGrGXxIwRyxWfYy4NRx2XscaNoS3NnnWqrz
UU6xutT4bAMg2I61q9ZgN3uCl2lDDn4WoZ3GClg3MQTFHyvqM2YQRUQjU2L+NHSEXjNnzFiB11qO
PL46kQn7+jbFQTL6E9pM5qF96B7VhjAofOkoa5HtXtkv+v6jAdiSAiTtjq2INu9DEoDxF/m39vGO
LSKCN5LpqUf4mchCvEitxteIrrPuMp6Oc3+eoSBgSQ2/XFx7jgWW/FKSUNRZIA64y/XWezzcg2RL
ly/M
--00000000000047748205dd8b20e7--
