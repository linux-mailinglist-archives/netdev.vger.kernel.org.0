Return-Path: <netdev+bounces-8229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B24437232E4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1590B281477
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDBA27721;
	Mon,  5 Jun 2023 22:04:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F94A1C752
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:04:09 +0000 (UTC)
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88492F9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:04:07 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6af6df840ffso4102108a34.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 15:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686002646; x=1688594646;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iucZvVKHCK/JirfNM/4dBpU4xvInDmH84gVAMlfm8A4=;
        b=bKc+169L8U+/B8iLd0I+JUE739kDZXMwvsKzmVkmpcG5L9o7OJoTVHKDD17Hzrw81M
         MhGERPLB0ZAgNiuqBWMI07HkhFzT/CG1BFWcGOZZUQxTsDhKL/ZKGMexSt/FyP3AqJYw
         1TzdEf6HB4Q2NNOdp8SxyAjK56yVTslFI8Few=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686002646; x=1688594646;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iucZvVKHCK/JirfNM/4dBpU4xvInDmH84gVAMlfm8A4=;
        b=I9zZTOXZD/PKCjQ3IODNaoQTFU1yxxLdcJSPsBiwiuqdpgL6t8vop3S9frOMoS3+EP
         7wMxIWWreo9OSvkC8jODZsPg5+Msrf4lasWxDv8jIZjMc+SlPUDJTZCUCRfQjIHPIC1r
         qPvRr0cV+U2Ioy/TVCD7CqzI3JU175hx8YpfKVZEBb6sBxwE+Lle9phfd+RoKt0GLVJb
         QZn2zhEoTrMBZfF87398RKGpVfmrEMBJ+/PCu6tfHd+kGU+dTnNccXccaeiPByKm4Yl6
         6sIFJMJXCDug6FjFU9zeoBn8HUYhnz9phck6T3AMiUDy4x6RAyYy3+Av2jcQJTfl8zYh
         OIjQ==
X-Gm-Message-State: AC+VfDxQeKAEK2mssB+x/YDeu0356fjMZH8aYlwd5qwYElJJ3BDoxZSC
	CDrwSMQu/VVrI2l8Pr3TvEmnOg==
X-Google-Smtp-Source: ACHHUZ5mRIBYBO2Gz/qYBcOHfhQig0mtjuUuBqF1PSi4oZuy2S67YP2tty9RNd8q8Rw5ixBwa0/udQ==
X-Received: by 2002:a9d:4e8a:0:b0:6b2:27f3:6e19 with SMTP id v10-20020a9d4e8a000000b006b227f36e19mr78091otk.8.1686002646643;
        Mon, 05 Jun 2023 15:04:06 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d17-20020a05620a141100b0074e389245e6sm4487409qkj.41.2023.06.05.15.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 15:04:05 -0700 (PDT)
Message-ID: <91341500-79f0-b565-98ec-be47cfd488cc@broadcom.com>
Date: Mon, 5 Jun 2023 15:04:02 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v6 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
To: Jakub Kicinski <kuba@kernel.org>, Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, opendmb@gmail.com,
 andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 richardcochran@gmail.com, sumit.semwal@linaro.org, christian.koenig@amd.com,
 simon.horman@corigine.com
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
 <1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
 <20230602235859.79042ff0@kernel.org>
From: Florian Fainelli <florian.fainelli@broadcom.com>
In-Reply-To: <20230602235859.79042ff0@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000dc8d1b05fd691499"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000dc8d1b05fd691499
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/2/2023 11:58 PM, Jakub Kicinski wrote:
> On Thu,  1 Jun 2023 15:12:28 -0700 Justin Chen wrote:
>> +	/* general stats */
>> +	STAT_NETDEV(rx_packets),
>> +	STAT_NETDEV(tx_packets),
>> +	STAT_NETDEV(rx_bytes),
>> +	STAT_NETDEV(tx_bytes),
>> +	STAT_NETDEV(rx_errors),
>> +	STAT_NETDEV(tx_errors),
>> +	STAT_NETDEV(rx_dropped),
>> +	STAT_NETDEV(tx_dropped),
>> +	STAT_NETDEV(multicast),
> 
> please don't report standard interface stats in ethtool -S
> 
>> +	/* UniMAC RSV counters */
>> +	STAT_BCMASP_MIB_RX("rx_64_octets", mib.rx.pkt_cnt.cnt_64),
>> +	STAT_BCMASP_MIB_RX("rx_65_127_oct", mib.rx.pkt_cnt.cnt_127),
>> +	STAT_BCMASP_MIB_RX("rx_128_255_oct", mib.rx.pkt_cnt.cnt_255),
>> +	STAT_BCMASP_MIB_RX("rx_256_511_oct", mib.rx.pkt_cnt.cnt_511),
>> +	STAT_BCMASP_MIB_RX("rx_512_1023_oct", mib.rx.pkt_cnt.cnt_1023),
>> +	STAT_BCMASP_MIB_RX("rx_1024_1518_oct", mib.rx.pkt_cnt.cnt_1518),
>> +	STAT_BCMASP_MIB_RX("rx_vlan_1519_1522_oct", mib.rx.pkt_cnt.cnt_mgv),
>> +	STAT_BCMASP_MIB_RX("rx_1522_2047_oct", mib.rx.pkt_cnt.cnt_2047),
>> +	STAT_BCMASP_MIB_RX("rx_2048_4095_oct", mib.rx.pkt_cnt.cnt_4095),
>> +	STAT_BCMASP_MIB_RX("rx_4096_9216_oct", mib.rx.pkt_cnt.cnt_9216),
> 
> these should also be removed, and you should implement @get_rmon_stats.
> 
>> +	STAT_BCMASP_MIB_RX("rx_pkts", mib.rx.pkt),
>> +	STAT_BCMASP_MIB_RX("rx_bytes", mib.rx.bytes),
>> +	STAT_BCMASP_MIB_RX("rx_multicast", mib.rx.mca),
>> +	STAT_BCMASP_MIB_RX("rx_broadcast", mib.rx.bca),
>> +	STAT_BCMASP_MIB_RX("rx_fcs", mib.rx.fcs),
> 
> there's a FCS error statistic in the standard stats, no need to
> duplicate
> 
>> +	STAT_BCMASP_MIB_RX("rx_control", mib.rx.cf),
>> +	STAT_BCMASP_MIB_RX("rx_pause", mib.rx.pf),
> 
> @get_pause_stats
> 
>> +	STAT_BCMASP_MIB_RX("rx_unknown", mib.rx.uo),
>> +	STAT_BCMASP_MIB_RX("rx_align", mib.rx.aln),
>> +	STAT_BCMASP_MIB_RX("rx_outrange", mib.rx.flr),
>> +	STAT_BCMASP_MIB_RX("rx_code", mib.rx.cde),
>> +	STAT_BCMASP_MIB_RX("rx_carrier", mib.rx.fcr),
>> +	STAT_BCMASP_MIB_RX("rx_oversize", mib.rx.ovr),
>> +	STAT_BCMASP_MIB_RX("rx_jabber", mib.rx.jbr),
> 
> these look like candidates from standard stats, too.
> Please read thru:
> 
> https://docs.kernel.org/next/networking/statistics.html
> 
>> +	STAT_BCMASP_MIB_RX("rx_mtu_err", mib.rx.mtue),
>> +	STAT_BCMASP_MIB_RX("rx_good_pkts", mib.rx.pok),
>> +	STAT_BCMASP_MIB_RX("rx_unicast", mib.rx.uc),
>> +	STAT_BCMASP_MIB_RX("rx_ppp", mib.rx.ppp),
>> +	STAT_BCMASP_MIB_RX("rx_crc", mib.rx.rcrc),
> 
> hm, what's the difference between rx_crc and rx_fcs ?

Since you are going to respin to address Jakub's feedback, we should 
also consider using the shared unimac.h header file. We could even make 
a library out of it for standardized statistics once this driver gets 
accepted.
-- 
Florian

--000000000000dc8d1b05fd691499
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
/D/YSkVckoN0L+QwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDpyCwcRUyfFnHlT
n3syQPfYpLJNmvPXuZ/3WJ44ah4eMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDYwNTIyMDQwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAoXi1fvSs8NH1hGYE604uX+0SBKYEPxUwf
SW+oRXUewoykzumssH7YMtpDcnFLSzCAK2nUY4neXsIP0LDubOQnbRlaajgKqcwCha1GUs9uFLb5
z0pEi/JLxvKfLuGf462Lk0vn7l6SsxRrVA8/T4TDijRkcdLps6EMswwd/l4VJw0p41y7AKLLrMvU
sGgo7nAWECQ5DqiaZrPXAiOhxmjnhVFeDcGyfbf7tJ9SxR67iOhtMW+ckEu+OnHwWQjvkZtl2dZ8
0+6jfEkH+FFzhkHizA8eMkKFKbuFdAMMq/LlK8nsLRYrhsD4WcV+HS8mMNQG3AtJKB9bblf0qvVk
jmqi
--000000000000dc8d1b05fd691499--

