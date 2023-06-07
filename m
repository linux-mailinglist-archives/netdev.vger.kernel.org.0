Return-Path: <netdev+bounces-8952-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDD9726641
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C612128140E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17CE174D6;
	Wed,  7 Jun 2023 16:46:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B095D16402
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:46:14 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ABA1FC0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:46:12 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75b14216386so693969285a.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 09:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686156371; x=1688748371;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PpJZGrduVpkhltvd8rcqGyPTIaAhADrG0jvC/PPLD7I=;
        b=P7FnPJymP00uhplyvsf59JmeY5QRqDPuTvLWCb3Fe51ozD9cOcso7K9vjB6K4kDLDO
         6C60avkHxbyOuKcFbJ7vJUlrFjOpKo7hPuca3BHKYeRKNfVeT7NAA3rHdK14ET10+QyO
         9024FwYn6XXaBmkY2BmBBARYwbJNYxmkrKKAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156371; x=1688748371;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpJZGrduVpkhltvd8rcqGyPTIaAhADrG0jvC/PPLD7I=;
        b=Cnta5H11p28jjEVejZUq04RJrlgHAfVq7ylW0PxLcXisOkFbVV+/h1JTHgfhSNO2sJ
         SYnOCpIKzUq4qap9n9ZKVNLMt4/6zwB2Z0eHhIbQKTQnJlaq4MTUSfv8dIqGwtWMGiFa
         1HBY6mSje+hb64KLRav3sfmwC42BnPJiuS0O364HXzbbZyRVuSbWjmAjA5hqjQiqvAMc
         UZEPZ+A8vGKS6NOe1rQnns0ga5UvrqGIC6KISgz4rjeKb5Lxd7baOBXLmVIQKBMYHVLH
         Zn0L8aAcuR/9SD/irTHkZYqhL3laE/2WJXufM3DON2uPNfI0Efg9jAa8fm7JffK9ah8H
         KdlA==
X-Gm-Message-State: AC+VfDyPpou29dpW1JBkXJJd/FcD1TrGrdm/Jqz52VJ8vq5J0PaMo2p+
	c2xRQCyTssvCDxBAUJ7fsHXWYw==
X-Google-Smtp-Source: ACHHUZ6g0zQ+QhyeOUkpe8vMNBjxoZdNqAGgocN22cgGPGJ8Tcu2J3gtULh6DC7fs5ngD2uh2+oJ2g==
X-Received: by 2002:a05:620a:1aa8:b0:75b:23a0:e7be with SMTP id bl40-20020a05620a1aa800b0075b23a0e7bemr3117150qkb.31.1686156371139;
        Wed, 07 Jun 2023 09:46:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15-20020ae9e30f000000b0075b23e55640sm3851qkf.123.2023.06.07.09.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 09:46:10 -0700 (PDT)
Message-ID: <77cc2923-99fa-49e4-8e3d-7c525a88a2a3@broadcom.com>
Date: Wed, 7 Jun 2023 09:45:58 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net: bcmgenet: Fix EEE implementation
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, o.rempel@pengutronix.de, andrew@lunn.ch,
 hkallweit1@gmail.com, Doug Berger <opendmb@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20230606214348.2408018-1-florian.fainelli@broadcom.com>
 <ZH+tAKg4hqlosb2N@shell.armlinux.org.uk>
 <1074c668-3e75-dff7-9d23-d43fbeb98d84@broadcom.com>
 <ZIBD7B8cwSjjFWuq@shell.armlinux.org.uk>
From: Florian Fainelli <florian.fainelli@broadcom.com>
In-Reply-To: <ZIBD7B8cwSjjFWuq@shell.armlinux.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000008ed5ee05fd8cdf3c"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000008ed5ee05fd8cdf3c
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 01:46, Russell King (Oracle) wrote:
> On Tue, Jun 06, 2023 at 03:16:03PM -0700, Florian Fainelli wrote:
>> On 6/6/23 15:02, Russell King (Oracle) wrote:
>>> On Tue, Jun 06, 2023 at 02:43:47PM -0700, Florian Fainelli wrote:
>>>> We had a number of short comings:
>>>>
>>>> - EEE must be re-evaluated whenever the state machine detects a link
>>>>     change as wight be switching from a link partner with EEE
>>>>     enabled/disabled
>>>>
>>>> - tx_lpi_enabled controls whether EEE should be enabled/disabled for the
>>>>     transmit path, which applies to the TBUF block
>>>>
>>>> - We do not need to forcibly enable EEE upon system resume, as the PHY
>>>>     state machine will trigger a link event that will do that, too
>>>>
>>>> Fixes: 6ef398ea60d9 ("net: bcmgenet: add EEE support")
>>>> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
>>>> ---
>>>> netdev maintainers, please do not apply without Andrew, Russell and
>>>> Oleksij reviewing first since this relates to the on-going EEE rework
>>>> from Andrew.
>>>
>>> Hi Florian,
>>>
>>> Please could you include some information on the UMAC_EEE_CTRL EEE_EN
>>> bit - is this like the main switch for EEE which needs to be set
>>> along with the bits in the tbuf register for the transmit side to
>>> signal LPI?
>>
>> EEE_EN is described as:
>>
>> If set, the TX LPI policy control engine is enabled and the MAC inserts
>> LPI_idle codes if the link is idle. The rx_lpi_detect assertion is
>> independent of this configuration.
>>
>> in the RBUF, EEE_EN is described as:
>>
>> 1: to enable Energy Efficient feature between Unimac and PHY for Rx Path
>>
>> and in the TBUF, EEE_EN is described as:
>>
>> 1: to enable Energy Efficient feature between Unimac and PHY for Tx Path
>>
>> The documentation is unfortunately scare about how these two signals connect
>> :/
> 
> Thanks for the clarification. Squaring this with my understanding of
> EEE, the transmit side makes sense. LPI on the transmit side is only
> asserted only when EEE_EN and TBUF_EEE_EN are both set, so this is
> the behaviour we want. If we were evaluating this in software, my
> understanding is it would be:
> 
> 	if (eee_enabled && eee_active && tx_lpi_enabled)
> 		enable LPI generation at MAC;
> 	else
> 		disable LPI generation at MAC;
> 
> and the code here treats eee_enabled && eee_active as the "enabled"
> flag controlling EEE_EN, and tx_lpi_enabled controls TBUF_EEE_EN.
> The hardware effectively does the last && operation for us. So
> this all seems fine.
> 
> On the receive side, if the link partner successfully negotiates
> EEE, then it can assert LPI, and the local end will see that
> assertion (hence, rx_lpi_detect may become true.) If the transmit
> side doesn't generate LPI, then this won't have any effect other
> than maybe setting status bits, so I don't see that setting
> RBUF_EEE_EN when eee_enabled && eee_active would be wrong.
> 
> Moving the phy_init_eee() (as it currently stands) into the adjust_link
> path is definitely the right thing, since it provides the resolution
> of the negotiated EEE state.
> 
> So, all round, I think your patch makes complete sense as far as the
> logic goes.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> However, one thing I will ask is whether the hardware has any
> configuration of the various timers for EEE operation, and if it does,
> are they dependent on the negotiated speed of the interface? In
> Marvell's neta and pp2 drivers, the timers scale with link speed and
> thus need reprogramming accordingly. In any case, 802.3 specifies
> different timer settings depending on link speed and media type.

There are a couple of timers that are available:

- LPI timer (EEE_LPI_TIMER register)
- WAKE_TIMER (EEE_WAKE_TIMER register)

both are dependent upon the EEE_REF_COUNT register which is described as:

Clock divider for 1 us quanta count in EEE. This field controls clock 
divider used to generate ~1us reference pulses used by EEE timers.
It specifies integer number of system clock cycles contained within 1us.

the value is currently set to 0x7d (125) which does make some sense 
given that the system clock is considered stable and is provided at the 
same frequency irrespective of the link speed.

Hope this helps.
-- 
Florian


--0000000000008ed5ee05fd8cdf3c
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
XzCCBVgwggRAoAMCAQICDBP8P9hKRVySg3Qv5DANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAxMjE4MTFaFw0yNTA5MTAxMjE4MTFaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEZsb3JpYW4gRmFpbmVsbGkxLDAqBgkqhkiG
9w0BCQEWHWZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA+oi3jMmHltY4LMUy8Up5+1zjd1iSgUBXhwCJLj1GJQF+GwP8InemBbk5rjlC
UwbQDeIlOfb8xGqHoQFGSW8p9V1XUw+cthISLkycex0AJ09ufePshLZygRLREU0H4ecNPMejxCte
KdtB4COST4uhBkUCo9BSy1gkl8DJ8j/BQ1KNUx6oYe0CntRag+EnHv9TM9BeXBBLfmMRnWNhvOSk
nSmRX0J3d9/G2A3FIC6WY2XnLW7eAZCQPa1Tz3n2B5BGOxwqhwKLGLNu2SRCPHwOdD6e0drURF7/
Vax85/EqkVnFNlfxtZhS0ugx5gn2pta7bTdBm1IG4TX+A3B1G57rVwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1mbG9yaWFuLmZhaW5lbGxpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUwwfJ6/F
KL0fRdVROal/Lp4lAF0wDQYJKoZIhvcNAQELBQADggEBAKBgfteDc1mChZjKBY4xAplC6uXGyBrZ
kNGap1mHJ+JngGzZCz+dDiHRQKGpXLxkHX0BvEDZLW6LGOJ83ImrW38YMOo3ZYnCYNHA9qDOakiw
2s1RH00JOkO5SkYdwCHj4DB9B7KEnLatJtD8MBorvt+QxTuSh4ze96Jz3kEIoHMvwGFkgObWblsc
3/YcLBmCgaWpZ3Ksev1vJPr5n8riG3/N4on8gO5qinmmr9Y7vGeuf5dmZrYMbnb+yCBalkUmZQwY
NxADYvcRBA0ySL6sZpj8BIIhWiXiuusuBmt2Mak2eEv0xDbovE6Z6hYyl/ZnRadbgK/ClgbY3w+O
AfUXEZ0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwT
/D/YSkVckoN0L+QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJHItUvKGOp1qGfD
fxOPrCxjLY29v7caCnQlSbTeLmSdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDYwNzE2NDYxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC9nTFbVLl4pZB+aaZEuppwIepeuQXoMfGH
ghdoOPKZWcll0xRgm34g2AzWc+iZ7mDK5pPgwht/Se6I+hcSYxMh+0bxhNBFQwAC9BUBn/XAXl+g
fxR1OsLVHRS8PD4dXcIHfOmBWH7jwP9q6NtprCiBd3RUB0cfQVOPOx4FfiIHJhK96c+ZkaRo/NZA
lbUQ4bkD5LAA2NLMkT17Cyq5X3F8JyIsJgBvJQAQOmW9ssbD7VsXpONHPs+9ne+lKmnVmyaytcOe
JN2xAVdMOOFRExb7E5/24rdB71aUEtVW0j+RrNdAO779zxNaUJ+TmkA9qGjzoUGck00pb/oGbv9I
2g6L
--0000000000008ed5ee05fd8cdf3c--

