Return-Path: <netdev+bounces-7226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4962471F1BF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 007A5281936
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6E951805;
	Thu,  1 Jun 2023 18:28:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083647017
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:28:15 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE5FE58
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:27:45 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b015c0508so111069685a.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 11:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1685644063; x=1688236063;
        h=in-reply-to:references:cc:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AFUkj8w233SpZT4WnnybLCi2jgrTm7EzdRDS1ho0XTo=;
        b=LefdBLxqSzAhpdB2plRh/N+rM9+u2TMv0taBtfJ7vo9pPpF4K8zcF+LUJUSiY3mLnB
         kLx9zwCyxxzKZMqiUrvyHvfKsH0jFdHWI81DJnmuDBdlQYJ7aihBxGenfB6Mz7FA9k6K
         sJ/vtS0x1QP2An//1BM2nPQ0D4C/0giYrPL/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685644063; x=1688236063;
        h=in-reply-to:references:cc:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFUkj8w233SpZT4WnnybLCi2jgrTm7EzdRDS1ho0XTo=;
        b=lbSMuMVjMTPs1FV2cH/aTHoERUMjMAq0I26oJtIoF+F+Ri8p2vlX5cNM6XCI8Ghs7k
         +twgcU10LJQPlx3kaS8wOJTBBsaZU8FACLeOFwkF42m1BGXsMGpb0mS2CTEVZr4MHUIY
         bKINY7946RPEXCZkMqPy7fpV7O2FtZxu+EuJswm63o20xv0yYc1mtrSXpqnqNaN/LIP/
         hG78B/ntnG1NJCBJEvM7lVXlpc+q13T3rl0+45nNa/tdiscxDbt3IamWB+nPjHeMEevd
         nT/b2AdLaz/unXWykGqjz/TRzkHWCgRZPbBecpbWJLRXX+5u7GO7X825bhI3aHtkg/dP
         eLXA==
X-Gm-Message-State: AC+VfDxcuFwY8+1XvfECuhMmLUhHUFqbmwpNNzl1PdOYoqn037HFAIiX
	mBLDVxnMRZwu81nOB2r/s85PUw==
X-Google-Smtp-Source: ACHHUZ4q0JrWFaaixNQ3ZCit5evtbtbloWX4ACpBjuMoBjbBEyb3ABY3fWH/gK2pmlafVg9AX2UAlQ==
X-Received: by 2002:a05:620a:3e87:b0:75b:23a1:3659 with SMTP id tv7-20020a05620a3e8700b0075b23a13659mr9099461qkn.26.1685644063183;
        Thu, 01 Jun 2023 11:27:43 -0700 (PDT)
Received: from [10.67.50.169] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15-20020ae9e30f000000b007594229600csm6946622qkf.81.2023.06.01.11.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 11:27:42 -0700 (PDT)
Message-ID: <eda87740-669c-a6e1-9c71-a9a92d3b173a@broadcom.com>
Date: Thu, 1 Jun 2023 11:27:40 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.1
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
From: Justin Chen <justin.chen@broadcom.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, bcm-kernel-feedback-list@broadcom.com,
 florian.fainelli@broadcom.com, Daniil Tatianin <d-tatianin@yandex-team.ru>,
 Andrew Lunn <andrew@lunn.ch>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
 <ZHi/aT6vxpdOryD8@corigine.com>
 <e7e49753-3ad6-9e03-44ff-945e66fca9a3@broadcom.com>
In-Reply-To: <e7e49753-3ad6-9e03-44ff-945e66fca9a3@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000009f67cb05fd15973c"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000009f67cb05fd15973c
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/1/23 9:22 AM, Justin Chen wrote:
> 
> 
> On 6/1/2023 8:55 AM, Simon Horman wrote:
>> + Daniil Tatianin <d-tatianin@yandex-team.ru>, Andrew Lunn 
>> <andrew@lunn.ch>
>>    as per ./scripts/get_maintainer.pl --git-min-percent 25 
>> net/ethtool/ioctl.c
>>
>> On Wed, May 31, 2023 at 01:53:49PM -0700, Justin Chen wrote:
>>> The netlink version of set_wol checks for not supported wolopts and 
>>> avoids
>>> setting wol when the correct wolopt is already set. If we do the same 
>>> with
>>> the ioctl version then we can remove these checks from the driver layer.
>>
>> Hi Justin,
>>
>> Are you planning follow-up patches for the driver layer?
>>
> 
> I was planning to for the Broadcom drivers since those I can test. But I 
> could do it across the board if that is preferred.
> 
>>> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
>>> ---
>>>   net/ethtool/ioctl.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>>> index 6bb778e10461..80f456f83db0 100644
>>> --- a/net/ethtool/ioctl.c
>>> +++ b/net/ethtool/ioctl.c
>>> @@ -1436,15 +1436,25 @@ static int ethtool_get_wol(struct net_device 
>>> *dev, char __user *useraddr)
>>>   static int ethtool_set_wol(struct net_device *dev, char __user 
>>> *useraddr)
>>>   {
>>> -    struct ethtool_wolinfo wol;
>>> +    struct ethtool_wolinfo wol, cur_wol;
>>>       int ret;
>>> -    if (!dev->ethtool_ops->set_wol)
>>> +    if (!dev->ethtool_ops->get_wol || !dev->ethtool_ops->set_wol)
>>>           return -EOPNOTSUPP;
>>
>> Are there cases where (in-tree) drivers provide set_wol byt not get_wol?
>> If so, does this break their set_wol support?
>>
> 
> My original thought was to match netlink set wol behavior. So drivers 
> that do that won't work with netlink set_wol right now. I'll skim around 
> to see if any drivers do this. But I would reckon this should be a 
> driver fix.
> 
> Thanks,
> Justin
> 

I see a driver at drivers/net/phy/microchip.c. But this is a phy driver 
set_wol hook.

Justin

>>> +    memset(&cur_wol, 0, sizeof(struct ethtool_wolinfo));
>>> +    cur_wol.cmd = ETHTOOL_GWOL;
>>> +    dev->ethtool_ops->get_wol(dev, &cur_wol);
>>> +
>>>       if (copy_from_user(&wol, useraddr, sizeof(wol)))
>>>           return -EFAULT;
>>> +    if (wol.wolopts & ~cur_wol.supported)
>>> +        return -EOPNOTSUPP;
>>> +
>>> +    if (wol.wolopts == cur_wol.wolopts)
>>> +        return 0;
>>> +
>>>       ret = dev->ethtool_ops->set_wol(dev, &wol);
>>>       if (ret)
>>>           return ret;

--0000000000009f67cb05fd15973c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJjqqTOWcaDpNk2fYHTJDwT3UomhpBtQMTLF
h+bWQAQxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYwMTE4
Mjc0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQBM7R6Ie09AZLEbZ+AcbRCQHprJChEJxTJZsRAbTrlSEyO+9DZJ2Qfk
1jS1wCHe+1m67REEVRzIzPUkfS6kCqEy4LxzsDc+GXnOBeB/LSrHJZM7nFLqLa9GaeseA1e3Jr2g
c6tYrgojeo9/k60RH8ttHohLF0SF7gJEX6lROIHOY6lBfBVryrHE05Y5kZP3YFXeSspBu6DnDQqC
fkh4Ey4TAmmUALv4DLbefpIRdfwnQV/py/MboM07xGmk6B4JdVHkJQrRotjHGyW7NC+EZwuMvvhv
1aw0EDFWoYWqUD4JiY/N5NfrUYzDHrZ2eLqwRuhxUtkdMRp1QrNQettYR71R
--0000000000009f67cb05fd15973c--

