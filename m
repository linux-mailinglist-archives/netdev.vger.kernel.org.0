Return-Path: <netdev+bounces-8638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A4E72505A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 00:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC59F2810E1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25522D273;
	Tue,  6 Jun 2023 22:58:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D567E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 22:58:31 +0000 (UTC)
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7191910F2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:58:26 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-39a505b901dso5764456b6e.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 15:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686092305; x=1688684305;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hdSuB/0QCF74kLdaCIhXFBkwJfiC0B++hDE9w764ZI0=;
        b=V9HTUW+pw8swOhDWUGNa7jRBXzcKqV43C1Fn6a2V2L99B9i8CP3qk8B3Ce2pC3fsWe
         YjkJwW6tyz7dYKOWKe1nsX+H+SE/u9VLwc0LvGpVOxKk2iGGFiujN0fWezRFTRMrnmJX
         u5vv7Qi8l9qa9nf9lYvIcKkY7vTxcBvOxjj4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686092305; x=1688684305;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdSuB/0QCF74kLdaCIhXFBkwJfiC0B++hDE9w764ZI0=;
        b=QWfZkgs47I0dmymLxAslw8EDUGXGwl/FR4WLvD3FKK1+sow2mr5KdNot2dzoGgJfRw
         fpOggQx7lyJzoDkFjDJMTj+adUTFnzvQFeQGxdPCGl9+N9eQmvvVlO1w1pAgv5LrZWO4
         t7qQZGNGf0J2L/8ZcqHSLY+wZ6sEQ6XIvOde4H+VAhoZwPVgvMOrvRKtG5ywXigPbvY4
         K4noVrIp+cNCj+7e6Ehb+UJpNqo/0TjWB7uhTj/8QQQL/CpD9Httph4pEPJsEYeYUmqe
         qSasYZaq9lQiQYsfNaYKq6e33rTXN+dk7fkmY692K+a4BtDxQRdl+lQzvKF4icK6jHvY
         0hWg==
X-Gm-Message-State: AC+VfDw1gYxeUwgJr7KQhjgmQMC/yU4dTQ+piH+JkcxHFh5ID3uLy9ZB
	3EWxMcvnOzj7uRMQMJjx6xKORA==
X-Google-Smtp-Source: ACHHUZ697HsQRJCyCMlLNIPxV2mlkOm/g4O0OEbsibU0NM/vg/UGiFsv0pj+f/FoSInChgJS+tXaEw==
X-Received: by 2002:a05:6358:cb26:b0:129:c905:27ec with SMTP id gr38-20020a056358cb2600b00129c90527ecmr1443883rwb.13.1686092305261;
        Tue, 06 Jun 2023 15:58:25 -0700 (PDT)
Received: from [10.69.71.77] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk21-20020a17090b119500b0025930e46596sm41825pjb.55.2023.06.06.15.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 15:58:23 -0700 (PDT)
Message-ID: <956dc20f-386c-f4fe-b827-1a749ee8af02@broadcom.com>
Date: Tue, 6 Jun 2023 15:58:21 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.1
Subject: Re: [PATCH net-next v6 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, simon.horman@corigine.com
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
 <1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
 <20230602235859.79042ff0@kernel.org>
From: Justin Chen <justin.chen@broadcom.com>
In-Reply-To: <20230602235859.79042ff0@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f2da5605fd7df4a7"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000f2da5605fd7df4a7
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/2/23 11:58 PM, Jakub Kicinski wrote:
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

These are not netdev statistics but MAC block counters. Guess it is not 
clear with the naming here, will fix this. We have a use case where the 
MAC traffic may be redirected from the associated net dev, so the 
counters may not be the same.

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

Same comment as above

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

Looks like the way we are doing stats are a bit outdated. Thanks for 
pointing it out. I got a bit of refactoring to do.

>> +	STAT_BCMASP_MIB_RX("rx_mtu_err", mib.rx.mtue),
>> +	STAT_BCMASP_MIB_RX("rx_good_pkts", mib.rx.pok),
>> +	STAT_BCMASP_MIB_RX("rx_unicast", mib.rx.uc),
>> +	STAT_BCMASP_MIB_RX("rx_ppp", mib.rx.ppp),
>> +	STAT_BCMASP_MIB_RX("rx_crc", mib.rx.rcrc),
> 
> hm, what's the difference between rx_crc and rx_fcs ?

This looks like some debug feature that really has nothing to do with 
verifying crcs. I will remove it.

Apologies, probably should have done my due diligence with each stats 
instead of blindly including everything.

Thanks,
Justin

--000000000000f2da5605fd7df4a7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQagYJKoZIhvcNAQcCoIIQWzCCEFcCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3BMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUkwggQxoAMCAQICDCPwEotc2kAt96Z1EDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAxMjM5NTBaFw0yNTA5MTAxMjM5NTBaMIGM
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFDASBgNVBAMTC0p1c3RpbiBDaGVuMScwJQYJKoZIhvcNAQkB
FhhqdXN0aW4uY2hlbkBicm9hZGNvbS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQDKX7oyRqaeT81UCy+OTzAUHJeHABD6GDVZu7IJxt8GWSGx+ebFexFz/gnRO/sgwnPzzrC2DwM1
kaDgYe+pI1lMzUZvAB5DfS1qXKNGoeeNv7FoNFlv3iD4bvOykX/K/voKtjS3QNs0EDnwkvETUWWu
yiXtMiGENBBJcbGirKuFTT3U/2iPoSL5OeMSEqKLdkNTT9O79KN+Rf7Zi4Duz0LUqqpz9hZl4zGc
NhTY3E+cXCB11wty89QStajwXdhGJTYEvUgvsq1h8CwJj9w/38ldAQf5WjhPmApYeJR2ewFrBMCM
4lHkdRJ6TDc9nXoEkypUfjJkJHe7Eal06tosh6JpAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGGp1c3Rpbi5jaGVuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUIWGeYuaTsnIada5Xx8TR3cheUbgw
DQYJKoZIhvcNAQELBQADggEBAHNQlMqQOFYPYFO71A+8t+qWMmtOdd2iGswSOvpSZ/pmGlfw8ZvY
dRTkl27m37la84AxRkiVMes14JyOZJoMh/g7fbgPlU14eBc6WQWkIA6AmNkduFWTr1pRezkjpeo6
xVmdBLM4VY1TFDYj7S8H2adPuypd62uHMY/MZi+BIUys4uAFA+N3NuUBNjcVZXYPplYxxKEuIFq6
sDL+OV16G+F9CkNMN3txsym8Nnx5WAYZb6+rBUIhMGz70V05xsHQfzvo2s7f0J1tJ5BoRlPPhL0h
VOnWA3h71u9TfSsv+PXVm3P21TfOS2uc1hbzEqyENCP4i5XQ0rv0TmPW42GZ0o4xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwj8BKLXNpALfemdRAwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFgLTkmgtO27eFP8Ei7ojHPElv1J8EXYAF5a
a7w6pRo4MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYwNjIy
NTgyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQAGBXj/LL3yfEZgMarW/7O2dluO/5cS9Y+CnzCxLAvh39TR9TOUXvB5
zuev8pQwHOTqb9lRfDs87R5mpkyG4AyOcKGUTdbFA1uvlzVwb9b1UPrE4HSmdbZ7Yb9MwyTIa8Z8
6A9PYRF12+Y2kGN7B5qoNEmPe1Q4/fUlZjJ2lw8/w8oJ+ihcPUHC6JMyL+N9+aEIYTIj5uJMFRCa
u3NsCHb0NYzuJohOoZ7qzLUgO6YvLp7APGMZ0JWvGojlvtu6KeEBIm+RIGMJtlOw1KRYaOluEakP
skqa+qtDsybhC/ucXHdJ/PS1Lx5EX8C1AlHOnI/RtHaPOvXD28LzocXunf9z
--000000000000f2da5605fd7df4a7--

