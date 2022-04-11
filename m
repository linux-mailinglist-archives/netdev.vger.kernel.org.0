Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83214FBFB1
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiDKO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiDKO7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:59:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E317717AB6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:56:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id be5so8098041plb.13
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=rpVWTE3/0wxg7mrk4bQZPwGiu2n6Hhtow1iZx6VVQY4=;
        b=N3rUMgJLJYe2y8bZ8d9afXFISZ/914Jy6E7lfZ48ZH2cSo97NhWl+fSlUoCmD3UZsc
         hTULsZb+u8ThDdAza8lbGp7uiAOV9spTcSLdcOiXQDyCn0vwE72561j0qrBCgJlImHtA
         xbdbEszkOpSZ3ZP+DoPNzjNnVEG1ymWqh47Vk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=rpVWTE3/0wxg7mrk4bQZPwGiu2n6Hhtow1iZx6VVQY4=;
        b=Fm1MXdL8CETZQdjZehddiKqzcBSKMZJC8i4tjfx26zdevMhunGIegwIX/DteVKV8Yr
         o8zsVBVHJQmToONdyJZFiFq6nRTe1e3CHuL5zhLQOO+QREu8tN/QFB0X+yD43EioTiAZ
         ypo/hj9ONjjSbVLdfbsac4BJZ5dZtD4AND9j7sGf+nQ6E8ANJfw3ewF7qGggyUG3FCKh
         WAbbaExqj7cBr8SHplzbaMD2mDeuRUrcaCS5juiwGMHb3Qa/suF8o3JBUUkg2Mq0DoJX
         JQ3LxgqIuYL33FMrctWzrMKm4CKC27x+Vvc6SWMwHIV6Hnk7Cje7ot+q9IBLbRtmHFdO
         Mjkg==
X-Gm-Message-State: AOAM532WBL/cl9+BCPa1p8wgrG8mRIlONC+93sU2U1Y6Z2uH6TKsF9AP
        z/QGZvLyeP9hDE/gb4q/vr7aZw==
X-Google-Smtp-Source: ABdhPJy8vI+MV8BjPnu29NWMVwFTJCjYW26ekBPOsTXCdZbmgEPaddFfryvMB1mcmlEFi1gD7lJABQ==
X-Received: by 2002:a17:903:22c6:b0:154:4156:f397 with SMTP id y6-20020a17090322c600b001544156f397mr32681461plg.29.1649689019110;
        Mon, 11 Apr 2022 07:56:59 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id k23-20020a17090a591700b001ca00b46cf9sm20630431pji.18.2022.04.11.07.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 07:56:58 -0700 (PDT)
Date:   Mon, 11 Apr 2022 17:56:47 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next 0/5] flower: match on the number of vlan tags
Message-ID: <20220411145647.GA23636@noodle>
References: <20220411133100.18126-1-boris.sukholitko@broadcom.com>
 <1b1b82a9-3e1b-d20a-f62c-f35fe1f155b8@mojatatu.com>
MIME-Version: 1.0
In-Reply-To: <1b1b82a9-3e1b-d20a-f62c-f35fe1f155b8@mojatatu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000001a3e005dc62280a"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000001a3e005dc62280a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 11, 2022 at 10:07:14AM -0400, Jamal Hadi Salim wrote:
> On 2022-04-11 09:30, Boris Sukholitko wrote:
> > Hi,
> > 
> > Our customers in the fiber telecom world have network configurations
> > where they would like to control their traffic according to the number
> > of tags appearing in the packet.
> > 
> > For example, TR247 GPON conformance test suite specification mostly
> > talks about untagged, single, double tagged packets and gives lax
> > guidelines on the vlan protocol vs. number of vlan tags.
> > 
> > This is different from the common IT networks where 802.1Q and 802.1ad
> > protocols are usually describe single and double tagged packet. GPON
> > configurations that we work with have arbitrary mix the above protocols
> > and number of vlan tags in the packet.
> > 
> > The following patch series implement number of vlans flower filter. They
> > add num_of_vlans flower filter as an alternative to vlan ethtype protocol
> > matching. The end result is that the following command becomes possible:
> > 
> > tc filter add dev eth1 ingress flower \
> >    num_of_vlans 1 vlan_prio 5 action drop
> > 
> 
> The idea looks sane. I guess flow dissector is now not just involving
> headers but metadata as well. I can see this applied to MPLS for example,
> etc.
> Can you please provide more elaborate example of more than 1 vlan?

Perusing our logs, we have redirect rules such as:

tc filter add dev $GPON ingress flower num_of_vlans $N \
   action mirred egress redirect dev $DEV

where N can range from 0 to 3 and $DEV is the function of $N.

Also there are rules setting skb mark based on the number of vlans:

tc filter add dev $GPON ingress flower num_of_vlans $N vlan_prio \
   $P action skbedit mark $M

> Where would the line be drawn:
> Is it max of two vlans?

We have seen the maximum of 3 vlans.

> Is there potential of <=X, meaning matching of upto X Vlans?
> 

We've managed to get by without such feature somehow :)

Thanks,
Boris.


> cheers,
> jamal

--00000000000001a3e005dc62280a
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGRVPN0NvrHj1FhK
+LtqQRTH0/c//DLyHgDnS+ld9IHxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQxMTE0NTY1OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCtf+zVwbyIgXFVpT5Zf7BzPh7eJATcLkw8
cRnW5gK7zPpuc2H/KnuIn3+7IdnvgcPG2+M3YNfORvUZOjIGQTuj7qRRIjeZmLvr4r3/krPPPRiT
1dwM8u267or/GkpeXnX7q3ca8diaaTF4pkjJX5zzdYJeyYuMf7rAjmxivP0Ryf8ivjBJzsQZQRqZ
qQ7PNLDKMsosQI8J0J6yzDBjFdr2vFyu0CfimEYBpLF5WPOoO1/lDNmvUS26dETXOnBaBdvGlCWX
4l6p42GHesb6Wot18yzBXDGMzKnLdw7KdHQypwkcyunz0ELatF2O4Ju+hPkeOCxH8mQCiVD/2k6t
MgeG
--00000000000001a3e005dc62280a--
