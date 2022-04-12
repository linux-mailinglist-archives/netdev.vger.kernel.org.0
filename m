Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCEB4FE8B3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 21:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243498AbiDLTgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 15:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiDLTgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 15:36:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BB01AF1F
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:34:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so17696635plh.1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=dv/AVYlU4/xx+SQTU+yHKi8bvtv4va2GhIS/KcNpxjg=;
        b=W36l22Vva5Dh7Ecr2l5Ssl2IyNS/TgZ1DR6CNFl5YZWlzVJsB/LT4eDPq5Ryn/QMMI
         iB/bQ9AKAkWOWYRnru0xFn7XJI6MMbmsjqArazMIMbBTqGULt5sYYbSi7g92YWm/fCFb
         ZGJCE9M6vvVFWf/UudrjxU3fHnGrkMv1oAAHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=dv/AVYlU4/xx+SQTU+yHKi8bvtv4va2GhIS/KcNpxjg=;
        b=IzwtZbKcWkqPn9t9AzjyCuXVDbUnZ6LPfwAJfr0nB5shaaPer070sIzc5bpM7mJQ9+
         5/9mDB0aojl8XWnXpmnLaPBRuL0MTs6X+lR02CJh+rSDISKXY7yyThTi59Vv/1rWEFab
         lPDh8fQF2Pfq3olbPUkhE3f6vEu1V0m64J6XsZe7OqPQ1feAU5xNNMn+tqolS8nGCoBj
         BSRZXbls+dyWUPJbX1+vPtbNW/lRqT9eOZPJiAknXb84HsaRUOgHBtqfehnLKKNrHYiY
         nVm756PLa6EgytB9kvhZELH+FwMW5fzU7d1eBZAX15cP7bpdJz8n/g5cxdfOSzkrxnBY
         gbZg==
X-Gm-Message-State: AOAM5337rR2a7ZWkKropJGBmz4A5kLaOVpwi5wGozkyuXCKb2GnrMc5O
        MG3Q/0NGqnvW6t37cBLFNhqV98ZrrDy6zEQ+
X-Google-Smtp-Source: ABdhPJxqP83mWEKbLGxKwO2iXFYv6UxstGvHZidR8giSl72+EoPV37fglT1bE/+dUaQpSqlloOvuKQ==
X-Received: by 2002:a17:903:11cc:b0:151:71e4:dadc with SMTP id q12-20020a17090311cc00b0015171e4dadcmr38360170plh.78.1649792066923;
        Tue, 12 Apr 2022 12:34:26 -0700 (PDT)
Received: from [10.136.8.240] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm40005327pfl.15.2022.04.12.12.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 12:34:25 -0700 (PDT)
Message-ID: <040cd578-946f-0141-c28a-2f04d00d9790@broadcom.com>
Date:   Tue, 12 Apr 2022 12:34:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC] Applicability of using 'txq_trans_update' during ring
 recovery
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
References: <1bdb8417-233d-932b-1dc0-c56042aedabd@broadcom.com>
 <20220412103724.54924945@kernel.org>
 <999fab5e-08e1-888e-6672-4fc868555b32@broadcom.com>
 <CACKFLinCdTELX7-19-hp4dK3Ysm2tCmW=qeh-SHoiKU5TShwuw@mail.gmail.com>
 <7bdffaa4-0977-414d-c28f-7408fde20bab@broadcom.com>
 <CACKFLim6ty5Pxih+aPn_mDGEy5RvZpJLFN8aV5UAhzfysL9bdA@mail.gmail.com>
From:   Ray Jui <ray.jui@broadcom.com>
In-Reply-To: <CACKFLim6ty5Pxih+aPn_mDGEy5RvZpJLFN8aV5UAhzfysL9bdA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000020d9e205dc7a2661"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000020d9e205dc7a2661
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/2022 12:19 PM, Michael Chan wrote:
> On Tue, Apr 12, 2022 at 11:36 AM Ray Jui <ray.jui@broadcom.com> wrote:
>> On 4/12/22 11:24, Michael Chan wrote:
>>> On Tue, Apr 12, 2022 at 11:08 AM Ray Jui <ray.jui@broadcom.com> wrote:
>>>
>>>> Can you please also comment on whether 'txq_trans_update' is considered
>>>> an acceptable approach in this particular scenario?
>>>
>>> In my opinion, updating trans_start to the current jiffies to prevent
>>> TX timeout is not a good solution.  It just buys you the arbitrary TX
>>> timeout period before the next TX timeout.  If you take more than this
>>> time to restart the TX queue, you will still get TX timeout.
>>
>> However, one can argue that the recovery work is expected to be finished
>> in much less time than any arbitrary TX timeout period. If the recovery
>> of the particular NAPI ring set is taking more than an arbitrary TX
>> timeout period, then something is wrong and we should really TX timeout.
> 
> Even if it should work in a specific case, you are still expanding the
> definition of TX timeout to be no shorter than this specific recovery
> time.
> 
> Our general error recovery time that includes firmware and chip reset
> can take longer than the TX timeout period.  And we call
> netif_carrier_off() for the whole duration.

Sure, that is the general error recovery case which is very different
from this specific recovery case we are discussing here. This specific
recovery is solely performed by driver (without resetting firmware and
chip) on a per NAPI ring set basis. While a specific NAPI ring set is
being recovered, traffic is still going with the rest of the NAPI ring
sets. Average recovery time is in the 1 - 2 ms range in this type of
recovery.

Also as I already said, 'netif_carrier_off' is not an option given that
the RoCE/infiniband subsystem has a dependency on 'netif_carrier_status'
for many of their operations.

Basically I'm looking for a solution that allows one to be able to:
1) quieice traffic and perform recovery on a per NAPI ring set basis
2) During recovery, it does not cause any drastic effect on RoCE

'txq_trans_update' may not be the most optimal solution, but it is a
solution that satisfies the two requirements above. If there are any
other option that is considered more optimal than 'txq_trans_update' and
can satisfy the two requirements, please let me know.

Thanks.



--00000000000020d9e205dc7a2661
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
gdQwLwYJKoZIhvcNAQkEMSIEIKnXUuaYbl0aoutpHNRpcIgIEJfb4F0d4avNHteLoaJJMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQxMjE5MzQyN1owaQYJKoZI
hvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG
9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEF
AASCAQCJT1+6tbyBZ04m001oq0G/D8gB7mxDO6l41+K7XFhlF3rd6TM+CKInFd8Y58rX753zMDox
ojKO054QHF4Cc8gvlzmScD9sLrPCK8BbkQzL8VY4QgVdaith6NbWu/BHH6Mt9F6kkHg38alSxWx7
bP8oGED4w4zYVAaysKGTuXfX48qyJLE/HJniLPpGae1COhUz/O98JJgdxdBgEQNdgNd9KfwDH+bG
HTDn9sa4vZUJI4JgzPkStZ7mnkjqz3v+kkybOK/VxHdPS2JfQPV3VO14YBHyUIa770dhhiIj/zrI
N0KZoCrIkbrml3KQjTdp/pEBkWTItYAiRNgcwN3WoEBm
--00000000000020d9e205dc7a2661--
