Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98CA133938
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 03:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgAHClX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 21:41:23 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35095 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgAHClX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 21:41:23 -0500
Received: by mail-il1-f193.google.com with SMTP id g12so1423143ild.2
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 18:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F35JszdgUmfIvwmuel0eQARqKnvxKYaygPfxavMA464=;
        b=fyXTxInjyvvF129t5Gtswwt3FzdLQY//AFv33AijMXeGxkA8P7arIt8QhzIxEf/6Mr
         rgoC0J7/k4ti7JgdPOBqBC7UDWfVx+6+9EG6L5v6VXxR9vfDjT5YIqKwCqSWUdRvLjcA
         JuZAnS8ltCOoDArpddPfVB0Nv3PnY1Chs4V+3Cb6n3ev8efL/FIzF7/z80Qpkl07tJ+T
         cxuxRuntNoaUXYd+ZByIQ7GHG/Tj5udARZSJ0jP09T4Ut4Aw2EB6TDyD8UpqoalawpxN
         wvm91YFjzI5QmjZI3LzRn99d1xBha3dKkCPb0NFPRO/Sl3KG6avp0XmMyYOyfIXppq2q
         pGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F35JszdgUmfIvwmuel0eQARqKnvxKYaygPfxavMA464=;
        b=uXKo8Hd8j+fXvMLkHTM2+i8uUkBoQineTSxkT6PQhWnaCjNhyDaXJgqSTTnQWolEzn
         BDDZlGv0o5hpIrZCftJxuvqbaPsAyGmtoD5dbMpVWC/0aZWCHkWoZu94QOwy2rk3yuIF
         t6WfXrvSZ1h0gJJpB+s+0Uj59cYDnnLXmWRc6efoBodBxnDuMrYw2pBudODlTxA6NMR3
         ykD7dbswPV8diF+q69nl82MtdhgoBo1lwnkCHxhXac3kAt3pNIKfUKLjT34qW8FBAGLw
         KhjacOutD1ACKeHyFa/Gq73J0+BCuKGPOcsuqbTFOIV2vjcOPORCfhu43oql5y/UOXGN
         uHkg==
X-Gm-Message-State: APjAAAWKnzcl3V1sNxN5bd/MVeFE15mi8/zL1vn2kbZDyn0H0eeTG/24
        yc7bIduKox30YYyBmymN7C8PVezgSuo=
X-Google-Smtp-Source: APXvYqxISgJhW6u8r83lvhh32COgl9hNVibvmHGrHlygfxAdqB9h5DXP24hVUMYOQadu76AxrDCHGg==
X-Received: by 2002:a92:5a16:: with SMTP id o22mr1972772ilb.152.1578451282294;
        Tue, 07 Jan 2020 18:41:22 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:601d:4dc7:bf1b:dae9? ([2601:282:800:7a:601d:4dc7:bf1b:dae9])
        by smtp.googlemail.com with ESMTPSA id b9sm319761iok.52.2020.01.07.18.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 18:41:21 -0800 (PST)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
From:   David Ahern <dsahern@gmail.com>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
 <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
 <8e0fd132-4574-4ae7-45ea-88c4a2ec94b2@gmail.com>
Message-ID: <a730696a-9361-d39e-5dc1-280dc8d0f052@gmail.com>
Date:   Tue, 7 Jan 2020 19:41:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <8e0fd132-4574-4ae7-45ea-88c4a2ec94b2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 11:44 AM, David Ahern wrote:
> On 1/7/20 11:40 AM, Casey Schaufler wrote:
>> Does this patch address the Debian issue? It works for the test program
>> and on my Fedora system.
>>
>>
>>  security/smack/smack_lsm.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index 50c536cad85b..b0bb36419aeb 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -2857,7 +2857,9 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
>>  		rc = smack_netlabel_send(sock->sk, (struct sockaddr_in *)sap);
>>  		break;
>>  	case PF_INET6:
>> -		if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family != AF_INET6)
>> +		if (addrlen < SIN6_LEN_RFC2133)
>> +			return 0;
>> +		if (sap->sa_family != AF_INET6)
>>  			return -EINVAL;
> 
> I doubt it; can't test it until tonight. strace for ping on buster is
> showing this:
> 
> $ strace -e connect ping6 -c1 -w1 ff02::1%eth1
> connect(4, {sa_family=AF_UNSPEC,
> sa_data="\4\1\0\0\0\0\377\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\3\0\0\0"}, 28)
> 
> ie., the addrlen >= SIN6_LEN_RFC2133 but the family is AF_UNSPEC. That
> suggests to me the first check passes and the second check fails.
> 

confirmed. connect still fails EINVAL.
