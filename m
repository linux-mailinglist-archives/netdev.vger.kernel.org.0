Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75103E985F
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhHKTLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKTLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 15:11:35 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE87C061765;
        Wed, 11 Aug 2021 12:11:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id k9so5296509edr.10;
        Wed, 11 Aug 2021 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lAVdRx8rVAjw15yYg5jd7VMToET9O633GZgFgh52dVg=;
        b=DA9mbXuBxYWj7+ua8E6uQ5C8JSMI+m5xoTojHyv1T/gvnw5jeFQVk8YOJgB8B2NpUe
         Ux/Xj9alDzEqcloFr2+aTKhrXSsG7YY05pncG7dPd+i9RswdvSz2mwEQsQY/tafyfcVP
         DcNDRztzG7Ifj/wc9nS7XeUnU1wqS8lPxA5xFKT3xewLTaBSSwOyxAL3VyDtuecjtndJ
         1W0fpw3/OEM1G4LUFlS1JUj9LXHV8iEgl7Zo2r24l1j9GM101q9P4BLEc5Me2OXe0P31
         M4TN6HDa7tjKV3kSDXvj8wmJwBg00i4FDks8g4NoqQKDlad8YtOaN94w6grjPd75EqdH
         e0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lAVdRx8rVAjw15yYg5jd7VMToET9O633GZgFgh52dVg=;
        b=sWK9YvpIdsQDqV5h6wPo+/TgEjLMkNiReivwCkZbu3sS8wLdCbE9pszOCvxPVJVmwu
         TJH1zN0aUHbeAhc5ZRNgTK8ftzbRCNjViiFnnKqEvQaHltu8uyF7oieKBtWoOdMJbBwQ
         YPX03iGQgdibVSKPpNX4FL78ftmSrZ2h9A3ALsViBRK7jf8oa2LrZvGQBSCHNLLHrwZI
         6pCe8wFrWOqLipX+lHN5hTEftUURUQnh1iaNFtPoerWGGO/KvN7JTRYI5ZUNBG2PX6ID
         N6s2fJY1RoLQo4tTcpVLhp1nigggL+IHCdsEIqtlHw7GXV750L9ka5JwjImCY+F5DfOj
         yRQg==
X-Gm-Message-State: AOAM532GH/CFmWUs7QPRRedydS556dZCMTOIADagUrzaWtAYe1h0Xt82
        6ZteLPZU3b4yQo3oe/9tghk=
X-Google-Smtp-Source: ABdhPJxsc3ca7mnoHqKpnNSxclnTyX85FrZpIgAy3sJ2UVM9yLWlN0i30DxTjiefb1gBBDbOMcR0Kw==
X-Received: by 2002:a05:6402:184b:: with SMTP id v11mr478907edy.267.1628709070407;
        Wed, 11 Aug 2021 12:11:10 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:48ac:8fee:19a2:adc6? ([2a04:241e:502:1d80:48ac:8fee:19a2:adc6])
        by smtp.gmail.com with ESMTPSA id u2sm94423ejc.61.2021.08.11.12.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 12:11:09 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     David Ahern <dsahern@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dmitry Safonov <dima@arista.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
 <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
 <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
 <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
 <8d656f85-6f66-6c40-c4af-b05c6639b9ab@gmail.com>
Message-ID: <18235a42-72ad-8471-c940-c70b476cf0e0@gmail.com>
Date:   Wed, 11 Aug 2021 22:11:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8d656f85-6f66-6c40-c4af-b05c6639b9ab@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.08.2021 16:42, David Ahern wrote:
> On 8/11/21 2:29 AM, Leonard Crestez wrote:
>> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
>>> Hi Leonard,
>>>
>>> On Tue, 10 Aug 2021 at 02:50, Leonard Crestez <cdleonard@gmail.com>
>>> wrote:
>>> [..]
>>>> +/* Representation of a Master Key Tuple as per RFC5925 */
>>>> +struct tcp_authopt_key_info {
>>>> +       struct hlist_node node;
>>>> +       /* Local identifier */
>>>> +       u32 local_id;
>>>
>>> There is no local_id in RFC5925, what's that?
>>> An MKT is identified by (send_id, recv_id), together with
>>> (src_addr/src_port, dst_addr/dst_port).
>>> Why introducing something new to already complicated RFC?
>>
>> It was there to simplify user interface and initial implementation.
>>
>> But it seems that BGP listeners already needs to support multiple
>> keychains for different peers so identifying the key by (send_id,
>> recv_id, binding) is easier for userspace to work with. Otherwise they
>> need to create their own local_id mapping internally.
>>
> 
> any proposed simplification needs to be well explained and how it
> relates to the RFC spec.

The local_id only exists between userspace and kernel so it's not really 
covered by the RFC.

There are objections to this and it seems to be unhelpful for userspace 
zo I will replace it with match by binding.

BTW: another somewhat dubious simplification is that I offloaded the RFC 
requirement to never add overlapping keys to userspace. So if userspace 
adds keys with same recvid that match the same TCP 4-tuple then 
connections will just start failing.

It's arguably fine to allow userspace misconfiguration to cause failures.

--
Regards,
Leonard
