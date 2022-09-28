Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580C35EE3B4
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 19:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiI1R7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 13:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiI1R7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 13:59:04 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D6DFFA4B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:58:53 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id u28so8372019qku.2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date;
        bh=MKMXucgLabGlKBTbc2MWc1CPM3dndXEomDy8mteJ7ic=;
        b=RPhi+m9UQMLdmx5yyMuhq5IuZgpW58rbh9PCG0duLoSLb5CUiXbS44pZFX9FU7+OzD
         2531uvahJ4wVM16GT5Kv1V3aSb0wJPRhyHUN3yfG40y2Hygt0XQ4gxaaX+PHbNtK/zBu
         uoFI9E9Nu6rMDjpx4L/+mSHJ1U5+M5aK/DsR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date;
        bh=MKMXucgLabGlKBTbc2MWc1CPM3dndXEomDy8mteJ7ic=;
        b=0qum6K3gU6XDF60/+SKTBErzBORzd5PPQn5br7GIbbpQbOypNRQA0wvMDjy0QaJwY5
         4wIz2leNSDUYbfaHNvqXjTTFGTlJtnAeb1W5LRJSSnLKR866gVPgEzuBLMohMS7ljF0R
         JtdVzIp40QMS55V4xQJmcwI4V7hsv8FdeliQL8oh4dlApbNbkBbOgho/2Lt43eej2pVo
         pUC4cVDscVejjeUh5IQwNIoVtZ3kVI3DytXdgIM6AQsMNMphHH4UPOzXxlEajYlM6b6N
         Mj48uXdbWQ+A02BsGZzUah013gJlLoBOmFaxHTKJ+o5lXNxV4cIpjfPlA1L7iS+o/kmL
         xmaA==
X-Gm-Message-State: ACrzQf1iK+FKERbQrMxArsh4D0doVi1NfT9K+Mr1HyV7sq5gaduFzOTZ
        Toq0hFJE8Mkzh4KBCvKQ0QUTdclpZBgOrz+PqEPU9pzMqfbtwypSdwLiKN92BWvJMWR5Qg2rbbR
        lAT03Jnc=
X-Google-Smtp-Source: AMsMyM7bwAIxxar3j76+GeBHEFaamoE+exxIauiU6vylMUKqxnQ7U8HDP6rwUHV4Zb3V0qYTKNxrNg==
X-Received: by 2002:a05:620a:2627:b0:6b8:c8c3:78f9 with SMTP id z39-20020a05620a262700b006b8c8c378f9mr22204177qko.641.1664387932617;
        Wed, 28 Sep 2022 10:58:52 -0700 (PDT)
Received: from linuxpc-ThinkServer-TS140.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id dt35-20020a05620a47a300b006ce580c2663sm3706932qkb.35.2022.09.28.10.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 10:58:51 -0700 (PDT)
From:   Steven Hsieh <steven.hsieh@broadcom.com>
To:     Steven Hsieh <steven.hsieh@broadcom.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: bridge: assign path_cost for 2.5G and 5G link speed
Date:   Wed, 28 Sep 2022 10:57:58 -0700
Message-Id: <20220928175758.2106806-1-steven.hsieh@broadcom.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000837e9505e9c08326"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000837e9505e9c08326
Content-Type: text/plain; charset="US-ASCII"

As 2.5G, 5G ethernet ports are more common and affordable,
these ports are being used in LAN bridge devices.
STP port_cost() is missing path_cost assignment for these link speeds,
causes highest cost 100 being used.
This result in lower speed port being picked
when there is loop between 5G and 1G ports.

Original path_cost: 10G=2, 1G=4, 100m=19, 10m=100
Adjusted path_cost: 10G=2, 5G=3, 2.5G=4, 1G=5, 100m=19, 10m=100
                    speed greater than 10G = 1

Signed-off-by: Steven Hsieh <steven.hsieh@broadcom.com>

---

 net/bridge/br_if.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a84a7cfb9d6d..a24a1e782e8f 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -40,12 +40,21 @@ static int port_cost(struct net_device *dev)
 		switch (ecmd.base.speed) {
 		case SPEED_10000:
 			return 2;
-		case SPEED_1000:
+		case SPEED_5000:
+			return 3;
+		case SPEED_2500:
 			return 4;
+		case SPEED_1000:
+			return 5;
 		case SPEED_100:
 			return 19;
 		case SPEED_10:
 			return 100;
+		case SPEED_UNKNOWN:
+			return 100;
+		default:
+			if (ecmd.base.speed > SPEED_10000)
+				return 1;
 		}
 	}
 
-- 
2.34.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000837e9505e9c08326
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zqFsDrDD6cfwPFA8egCLRqlqcMvTsLO8Ak8PulZSDNLvAbFQEcKXLzfSS5I4bJEyNm+gDxU2ufWn
S26/TTgra4hsvkgl1igpsKFbDqYd5GXc4f+GLIfWlFUCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3RldmVuLmhzaWVoQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUo47KV++PjdaGX8yl9SYgLyqh
UFcwDQYJKoZIhvcNAQELBQADggEBACv8VBuGccogpklAkOkvfL8jtr7AUHpm2ZaG6RzE4EzvGTat
uzvVLmsDVHyVsa1ioxXjqCHYllCoea6lm9UEzsidojI+YYnkuh62tdBeZ7holVEdpaq39FmL1cdH
CSwbr9nedhgKPjQtcnY41wCwI1HMCUFiB3XW9DcBh94PSvqvYGsx0gFFJoXt2at06iqSLji8Rot+
jsXWHybl7AZDcupjJeQoApn6y0weM2xKcoG0WeN5SDDvmXTPe3AZG4n1xK1S8sjPJstMr++KiYS8
8l4ubZbXNKvsYhBY1PRITsrjcHkZbsufMbH2ZHAyxVN2QirJnb3Jocji5QBdKAX+pAAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxJVhM6Swu/6EH/BMgw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDEzxUv1CXSnkS3eXoabLY0plfm3wmJB
v6dAfbQiteTKMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDky
ODE3NTg1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBW8IwlQUKnQuQhc9ayiNMF8Ht5BmrHzzOf7dRQ5NpCFkRnkSZQ
9bUk5EbfEPk3aTRNNb5O53MC7Js5US5N0cPG0itR3PP7awBrZrulCR5keM9VdtNNEcYh/b0p1ATk
1GJZuaKLl26vj2uHsA9YUDId79OYZxrgVlNTVfTChtS1FJ7Uacw2xAUEd6gIAPGQ7uEiz9Ecnf2j
44hfVMX6d4+KWu5etmZ7YrG2x0u5a+7EISazwaRxV4VgXhX23ohMkrArk2Q2RgRfS4PsPczT/4YH
Q1ORd//Sn+iRVx3i/ZcliifWcpLnAVPd73Z23PBymXpkf/LPPNVc9cEc4KNeUL6/
--000000000000837e9505e9c08326--
