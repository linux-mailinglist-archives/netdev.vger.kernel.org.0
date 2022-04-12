Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA934FEB1F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiDLXgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiDLXdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:33:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188F0DF05
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:21:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n18so281138plg.5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=zD6hzjnMmGc0PQUfKpYde/y4NQUJhMVuEvypLk1hVDk=;
        b=HWzITp31V72Dk9vmLym7Xl7ubkQDmbuAi2hHbQhbTRsVNWqCeZSdZ7KRuGep5C+pas
         ftSqhiGo2n9sgkFNQjPizMF/+8IPcgZwui7s9xPGxLp4QLA62PgEqcJuNPH3iGzz5r1k
         +SiM5WCIQ+p+vGa2jxoaeiWw2ZZ9ylb5KCh/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=zD6hzjnMmGc0PQUfKpYde/y4NQUJhMVuEvypLk1hVDk=;
        b=u/tPILtasa9ydkyaRzsYWtfohLgK4vTuPKb0dmwWWxyhmS08I9IfX2YXReWK3VCRXp
         UR0nITF89yzxJ8VYR7t2mvbvdA7kd777aO1Dl/t2FlAcx3OjpGrUGYQTKC1hrxu3ZLc2
         HWYvYLly2StNnKVfrYp6tvbsNKbsBF80fsad7b/hs4PkCJRWu8wG9B97sYFmcbGTN7Ug
         4cCg3Ga/iyk/bEQvttMMLDlj43dX2SKLmr7y58D4WGOaec5/wB26PhQkVoWmZdatHu/C
         4lSObqtFmwpSLZMMiGjvyyrjSdqfxrg56D6ltSQDHOTQJlGwdaH3rCper3jYPS33x6sJ
         saSA==
X-Gm-Message-State: AOAM531XcZPo60UYgdekJ1Xqy7xCZ5v1MzPLukawNxpWi+NaARFZjdCt
        KLRuEyGiq7OendHANS8h5OFpaQ==
X-Google-Smtp-Source: ABdhPJwwKTm1e7rsAPjD2uRsIriufo+155dmgVXKn1fZqiXZHfjXbhk7z9vcUUG+ozZxsV7hRpet/A==
X-Received: by 2002:a17:90a:1197:b0:1bf:65ff:f542 with SMTP id e23-20020a17090a119700b001bf65fff542mr7265081pja.5.1649802117337;
        Tue, 12 Apr 2022 15:21:57 -0700 (PDT)
Received: from [10.136.8.240] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 205-20020a6303d6000000b003987eaef296sm120365pgd.44.2022.04.12.15.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 15:21:56 -0700 (PDT)
Message-ID: <7f2d508c-1e21-9ee4-1cef-9b2dbb7e0a02@broadcom.com>
Date:   Tue, 12 Apr 2022 15:21:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC] Applicability of using 'txq_trans_update' during ring
 recovery
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
References: <1bdb8417-233d-932b-1dc0-c56042aedabd@broadcom.com>
 <20220412103724.54924945@kernel.org>
 <999fab5e-08e1-888e-6672-4fc868555b32@broadcom.com>
 <CACKFLinCdTELX7-19-hp4dK3Ysm2tCmW=qeh-SHoiKU5TShwuw@mail.gmail.com>
 <7bdffaa4-0977-414d-c28f-7408fde20bab@broadcom.com>
 <CACKFLim6ty5Pxih+aPn_mDGEy5RvZpJLFN8aV5UAhzfysL9bdA@mail.gmail.com>
 <040cd578-946f-0141-c28a-2f04d00d9790@broadcom.com>
 <20220412144906.40d935f2@kernel.org>
From:   Ray Jui <ray.jui@broadcom.com>
In-Reply-To: <20220412144906.40d935f2@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002f277d05dc7c7de5"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002f277d05dc7c7de5
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/2022 2:49 PM, Jakub Kicinski wrote:
> On Tue, 12 Apr 2022 12:34:23 -0700 Ray Jui wrote:
>> Sure, that is the general error recovery case which is very different
>> from this specific recovery case we are discussing here. This specific
>> recovery is solely performed by driver (without resetting firmware and
>> chip) on a per NAPI ring set basis. While a specific NAPI ring set is
>> being recovered, traffic is still going with the rest of the NAPI ring
>> sets. Average recovery time is in the 1 - 2 ms range in this type of
>> recovery.
>>
>> Also as I already said, 'netif_carrier_off' is not an option given that
>> the RoCE/infiniband subsystem has a dependency on 'netif_carrier_status'
>> for many of their operations.
>>
>> Basically I'm looking for a solution that allows one to be able to:
>> 1) quieice traffic and perform recovery on a per NAPI ring set basis
>> 2) During recovery, it does not cause any drastic effect on RoCE
>>
>> 'txq_trans_update' may not be the most optimal solution, but it is a
>> solution that satisfies the two requirements above. If there are any
>> other option that is considered more optimal than 'txq_trans_update' and
>> can satisfy the two requirements, please let me know.
> 
> The optimal solution would be to not have to reset your rings and
> pretend like nothing happened :/

Yes, I wish we have a more robust HW so we don't need to deal with this
in SW. Unfortunately not my choice.

> If you can't reset the ring in time
> you'll have to live with the splat. End of story.

But the splat is not caused by the fact that we cannot recovery in time;
instead, it is caused by the fact there was no activity on the TX queue
for some time and now when we stop the individual TX queue (without
tapping off at netif level), TX timeout can be falsely triggered.

Basically it sounds like we currently do not have an optimal way in the
kernel to allow us to stop and re-start TX queue on a per NAPI ring set
basis (whether we need it or not can be a separate discussion). Is this
statement correct?

Thanks!

--0000000000002f277d05dc7c7de5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Pi3DQoJNNR5cV1dw3cNMKQyHRziEjFTVmILshClu9AljdXzCUoHXDUbge8TIJ/fK36qTGCYWwA01
rTB3drVX3FZq/Uqo0JnVcyP1dtYVzQIDAQABo4IB1TCCAdEwDgYDVR0PAQH/BAQDAgWgMIGjBggr
BgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9j
YWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUFBzABhjVodHRwOi8v
b2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMDBNBgNVHSAERjBE
MEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20v
cmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLmdsb2Jh
bHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAfBgNVHREEGDAWgRRyYXku
anVpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdb
NHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU5E1VdIocTRYIpXh6e6OnGvwfrEgwDQYJKoZIhvcNAQEL
BQADggEBADcZteuA4mZVmXNzp/tJky+9TS87L/xAogg4z+0bFDomA2JdNGKjraV7jE3LKHUyCQzU
Bvp8xXjxCndLBgltr+2Fn/Dna/f29iAs4mPBxgPKhqnqpQuTo2DLID2LWU1SLI9ewIlROY57UCvO
B6ni+9NcOot0MbKF2A1TnzJjWyd127CVyU5vL3un1/tbtmjiT4Ku8ZDoBEViuuWyhdB6TTEQiwDo
2NxZdezRkkkq+RoNek6gmtl8IKmXsmr1dKIsRBtLQ0xu+kdX+zYJbAQymI1mkq8qCmFAe5aJkrNM
NbsYBZGZlcox4dHWayCpn4sK+41xyJsmGrygY3zghqBuHPUxggJtMIICaQIBATBrMFsxCzAJBgNV
BAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdD
QyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxnTAexrtwIst251kUwDQYJYIZIAWUDBAIBBQCg
gdQwLwYJKoZIhvcNAQkEMSIEIBGWVWZDpSzj74lOEdmZXjxoBS2RBcfHjxMNj5hosJ7WMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQxMjIyMjE1N1owaQYJKoZI
hvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG
9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEF
AASCAQCIwZ4YoaIl74ZlnNdPri+w5xRw0SG6OSpkxMHYgx2vsHeNLHl2PFg0uSwT7M9mfozFK4SH
hRjVGh+18ZvSb2jhmjOyWoRx5ri4u//a6FLJG9bP4AAN8c2WiVo58JtIThel5vuQCtaxzcMZHTEt
YtPN7mh3TV+jYgo7sPBoO0kKMqCOmISBqZ1PHVPDwZhwUlH2yCbTL27cdArhW06UA867Goj7JbOK
vrcKrO2G898gxmEOQlg2v6jgiNlFPMTWU4NENDoeqp/+CA6sLigm0FIoNA3DsfoSUSvRKv+ue0sQ
Gim4e8qprRIHJdSFKTEUCEWQPAZMS6BSO7FkJF52Ah95
--0000000000002f277d05dc7c7de5--
