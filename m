Return-Path: <netdev+bounces-3391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7E6706D6F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23D091C20C2F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB4B111A6;
	Wed, 17 May 2023 15:55:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1874436
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:55:14 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622F1A5C7
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:54:50 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6436dfa15b3so675791b3a.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1684338889; x=1686930889;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUzReXj0nWnFn07ZzussDEAMfGKStbPLovVcIxOF9pU=;
        b=IYS6aeNo66H8HstSJReWm+MH1FdrPAtpw15mWL7tZWpzani+HeVaof5oQU7Sx8Eqtl
         En5w0CkmnvZgtGD54K+mnZwDjFVO+QZqKLCHe0A9ZhEUWQGLv87d795duJWqeZIygY8b
         x/GVwx5MDpcWZ7ZaUaWnaBw+Vwg+VCANnowcg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684338889; x=1686930889;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZUzReXj0nWnFn07ZzussDEAMfGKStbPLovVcIxOF9pU=;
        b=gXtBaf4e6BnKXk+wjudcI1MpAOj2fGI0um0lFNMALJgtwr7ZDTsyCOe6USrwSUTuKN
         0qg6YaJcAhdpQSj0I7tP6ZEN/mUTUh74Ghh6WU7YrNeZgyOkwWzi9raR2IBmV4OmDNjZ
         imWK9CBzlG+3sOQ5sRepuzlaCbU1tsVEjAnzrNyqy1U2v1e0+lsjsQivTyPAn85GMY6A
         bZJWmJGyFiQRqOcxnCh3Q4dw4xCNqDz8o8JYNEnHiouSEqQQoQYdXBMO1/Z7I8az00Mb
         KvYoJpPeUHAy0RP2xrsDOzsYQtTrdELCQsRJXjZav47/8UJ2/X/kdRXcS1Ftc1wqCFM/
         6XMA==
X-Gm-Message-State: AC+VfDxV9QfQEnjgm1/QstFON/IjS2GD+d93AfUTyPZ4xY8YgxxyKOEd
	D/AcRhzjEJwl/nGrnjX13P4mag==
X-Google-Smtp-Source: ACHHUZ7Ct+TgnsVcNwY1/C0PorXEMap0dQWRIaNrsotYLXgLw212xc98zMZsIW3KHkDaF0H1Pqr+wg==
X-Received: by 2002:a05:6a20:7d8d:b0:101:166:863f with SMTP id v13-20020a056a207d8d00b001010166863fmr39625632pzj.23.1684338888614;
        Wed, 17 May 2023 08:54:48 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:98e2:8350:9124:862f? ([2600:8802:b00:4a48:98e2:8350:9124:862f])
        by smtp.gmail.com with ESMTPSA id a9-20020a63e409000000b0050376cedb3asm15618046pgi.24.2023.05.17.08.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 08:54:48 -0700 (PDT)
Message-ID: <011706c2-f0fb-42d2-81a9-7e5e4fbd784d@broadcom.com>
Date: Wed, 17 May 2023 08:54:46 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Add support for
 WAKE_FILTER
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, open list <linux-kernel@vger.kernel.org>
References: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
 <20230516231713.2882879-3-florian.fainelli@broadcom.com>
 <a47d27e0-a8ef-4df0-aa45-623dda9e6412@lunn.ch>
From: Florian Fainelli <florian.fainelli@broadcom.com>
In-Reply-To: <a47d27e0-a8ef-4df0-aa45-623dda9e6412@lunn.ch>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000002948ee05fbe5b5c1"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000002948ee05fbe5b5c1
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/17/2023 5:49 AM, Andrew Lunn wrote:
> On Tue, May 16, 2023 at 04:17:12PM -0700, Florian Fainelli wrote:
>> Since the PHY is capable of matching any arbitrary Ethernet MAC
>> destination as a programmable wake-up pattern, add support for doing
>> that using the WAKE_FILTER and ethtool::rxnfc API.
> 
> Are there other actions the PHY can perform?

Not really, it can match on a custom Ethernet MAC DA and that is pretty 
much it, unless you use the WAKE_MAGIC or WAKE_MAGICSECURE where it can 
match either or.

> 
> For a MAC based filter, i expect there are other actions, like drop,
> queue selection, etc. So using the generic RXNFC API makes some sense.
> 
>> ethtool -N eth0 flow-type ether dst 01:00:5e:00:00:fb loc 0 action -2
>> ethtool -n eth0
>> Total 1 rules
>>
>> Filter: 0
>>          Flow Type: Raw Ethernet
>>          Src MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
>>          Dest MAC addr: 01:00:5E:00:00:FB mask: 00:00:00:00:00:00
>>          Ethertype: 0x0 mask: 0xFFFF
>>          Action: Wake-on-LAN
>> ethtool -s eth0 wol f
> 
> What i don't particularly like about this is its not vary
> discoverable, since it is not part of:
> 
>            wol p|u|m|b|a|g|s|f|d...
>                    Sets Wake-on-LAN options.  Not all devices support
>                    this.  The argument to this option is a string of
>                    characters specifying which options to enable.
> 
>                    p   Wake on PHY activity
>                    u   Wake on unicast messages
>                    m   Wake on multicast messages
>                    b   Wake on broadcast messages
>                    a   Wake on ARP
>                    g   Wake on MagicPacket™
>                    s   Enable SecureOn™ password for MagicPacket™
>                    f   Wake on filter(s)
>                    d   Disable (wake on  nothing).   This  option
>                        clears all previous options.
> 
> If the PHY hardware is not generic, it only has one action, WoL, it
> might be better to have this use the standard wol commands. Can it be
> made to work under the 'f' option?

You actually need both, if you only configure the filter with 
RX_CLS_FLOW_WAKE but forget to set the 'f' bit in wolopts, then the 
wake-up will not occur because the PHY will not have been configured 
with the correct matching mode.

This is how I originally designed it for SYSTEMPORT and this was copied 
over to GENET and now to this PHY driver.

> 
> The API to the PHY driver could then be made much more narrow, and you
> would not need the comment this is supposed to only be used for WoL.

I was initially considering that the 'sopass' field could become an 
union since it is exactly the size of a MAC address (6 bytes) and you 
could do something like:

ethtool -s eth0 wol f mac 01:00:5E:00:00:FB

but then we have some intersection with the 'u', 'm' and 'b' options 
too, which are just short hand for specific MAC DAs. This felt a bit 
like bending the framework for one specific PHY that supports that use 
case, so I felt like RXNFC, although we only use a very narrow space 
could be a better fit in case a more capable PHY came along in the future.
-- 
Florian

--0000000000002948ee05fbe5b5c1
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
/D/YSkVckoN0L+QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIwlua/3vps7eQM9
dnZg8SfQvpeZ/hLtqbioZJyp6jVRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUxNzE1NTQ0OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC6sj4kZNZEcG+R4Td0+eto5O3mSz6faIor
ViJl2FV6rtDQWZjAgGMBwxWyjq9Kku+d/3LqH0LjELppybkMrKMhe/KkFHLH/7enUxr4hhwTuux2
2iUxbUprSVdWlku+GmzNb5AZujQz2gF1K+aNQU6wN8qzUZRLPnfiOKM92YcPpJJGqwVoWy4HaQ7D
JpA8kQt9Yfy8IRbJtU91MnUil4sVy5Mz3hxQmKNXPbBe25yjqDBRDzhqugnBTG0HM0uUeG/kxhwg
IBZsCFIZY+iEp/zhTAmOjMBaG0Qw/o2cCU/q0xGnpNH5/6N0hBiQ2iYISUABBMT2w/2OL6Wdy2N9
OYjx
--0000000000002948ee05fbe5b5c1--

