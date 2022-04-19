Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776935066B6
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiDSISX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349948AbiDSISN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:18:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145AF65DA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:14:58 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id n43so3892921pfv.10
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=HnZ169+hdxEEhEWXUVCgxToz/0/vSv2yswgbUCjCCrA=;
        b=BRDT1WU72ebFbSyGLJSa0jmCwqZpswJEwvqj0nvVVGkMpunGzIv5AbQKAIzhFD65bl
         jYoao2j/1kouoUDsV8IMJV8E3URc7nc2fytXPFfUuC12gEFTyFeYUQ8/MIKDAIfExB/k
         m+9FMfCRbqYWE71zOA7iyFmj678eZj259zexI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=HnZ169+hdxEEhEWXUVCgxToz/0/vSv2yswgbUCjCCrA=;
        b=3AGbrG9OlzKtrI08E795dVS1BrtOq7m6iTWjB6L1Zf0XdSETDGqqQI7FPCuA/J+L3S
         xwGuXIFa+m02nm9eFNdvSdCd9CX+W1NjjNOaP3Pg4+/vmKExd5Wn47557uIKkijN7pxp
         U2cF9AWDFWxl5slQehmtu2/FGXJXFmBQ73VGnvVdu2XjyoT91pBeDA89wlDNoYLlu1Qy
         dimeHyTaeX2LtdhMHE1QeuDAfpI7B9fqGJQkfWMfQUL5KQojgr39MtrziohmUqgL4zw9
         qaXOUoVvCW33LPy6FZ0wblFdPNxHeGU2A+gylEjBwB6a19vPay6P6yHD1aT9r2MY7W93
         FPsw==
X-Gm-Message-State: AOAM530uPmw6TWAB9W33Uu6krdZHJEHy60s8xKn7ZQbrAkV9/YOGLC9f
        nnv3HOmjtgTQMMhqtmMNQvhO6ijZ6TNM0EBGsjjYlHnQyYl57BExebwjapwMgeX7rOuT/kD6Sfu
        /otmZV8S4Xi4tGhHFfIWCarto4yEgoC0AS0NgWhN1KVo8JmRWpnThSmMMtv23NlDBJ0FhdseNhD
        g5CRoFfu0UhQ==
X-Google-Smtp-Source: ABdhPJzu1BaQ3ZlcuumfAz/WU/LrZ7Vb3Ue8BSwKB+juymUfB0ErRDIVrB8YfIW90XIEez+xb6wEJQ==
X-Received: by 2002:a63:5560:0:b0:399:4e32:42 with SMTP id f32-20020a635560000000b003994e320042mr13642323pgm.164.1650356097173;
        Tue, 19 Apr 2022 01:14:57 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id cp19-20020a056a00349300b0050a890c8c16sm4284570pfb.19.2022.04.19.01.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 01:14:55 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/5] net/sched: flower: match on the number of vlan tags
Date:   Tue, 19 Apr 2022 11:14:29 +0300
Message-Id: <20220419081434.5192-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f29ba005dcfd78f1"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_NO_TEXT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f29ba005dcfd78f1
Content-Transfer-Encoding: 8bit

Hi,

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

The following patch series implement number of vlans flower filter. They
add num_of_vlans flower filter as an alternative to vlan ethtype protocol
matching. The end result is that the following command becomes possible:

tc filter add dev eth1 ingress flower \
  num_of_vlans 1 vlan_prio 5 action drop

Also, from our logs, we have redirect rules such that:

tc filter add dev $GPON ingress flower num_of_vlans $N \
     action mirred egress redirect dev $DEV

where N can range from 0 to 3 and $DEV is the function of $N.

Also there are rules setting skb mark based on the number of vlans:

tc filter add dev $GPON ingress flower num_of_vlans $N vlan_prio \
    $P action skbedit mark $M

More about the patch series:
  - patches 1-2 remove duplicate code by introducing is_key_vlan
    helper.
  - patch 3, 4 implement num_of_vlans in the dissector and in the
    flower.
  - patch 5 uses the num_of_vlans filter to allow further matching on
    vlan attributes.

Complementary iproute2 patches are being sent separately.

Thanks,
Boris.

- v4: rebased to the latest net-next
- v3:
    - more example commands in patch 3 description (request by Jamal)
    - patch 5 description made clearer (thanks to Jiri)
- v2:
    - add suitable subject prefixes
    - more evolved patch 5 description

Boris Sukholitko (5):
  net/sched: flower: Helper function for vlan ethtype checks
  net/sched: flower: Reduce identation after is_key_vlan refactoring
  flow_dissector: Add number of vlan tags dissector
  net/sched: flower: Add number of vlan tags filter
  net/sched: flower: Consider the number of tags for vlan filters

 include/net/flow_dissector.h |  9 ++++
 include/uapi/linux/pkt_cls.h |  2 +
 net/core/flow_dissector.c    | 20 ++++++++
 net/sched/cls_flower.c       | 90 +++++++++++++++++++++++-------------
 4 files changed, 88 insertions(+), 33 deletions(-)

-- 
2.29.2


--000000000000f29ba005dcfd78f1
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHQxmUsvmwQMxy06
5ykhGd7JLwtNkzp6YD1Yhnps+CTKMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQxOTA4MTQ1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAT7C/nDhbxB6FqiPvP9+EXVIdO4GeEh+2F
Si/R9kWBtEBPoBQe4nvL7X0oCJ265qNHOzNlB0LIEC5dm80eDHY6HG0Un1zaz3OtTKtYMRCgOGM1
RknFEW+u+JMTS2DC1uyMYCw9Q7YO/bfcMSeQcfcIPaYxogOkzN/mLylQJsa0TAvL/wwakdA/biBm
V5pe7pRHwCRGw/n+VKoMGBzp8we5mRi80DDWuxMtpdfv3EO9a1RSubyhADCOhYBwf2xbiWoIvgwo
fxdcZ4qHlYJlBvB8P86DKgMUlBzpsDiQRsYFLMMvwjFvMfCE+rfALsk5XVnTU2JHu1fyRXBpAHeY
BzHI
--000000000000f29ba005dcfd78f1--
