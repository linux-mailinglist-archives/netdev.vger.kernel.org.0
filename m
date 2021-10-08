Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326AD426E1D
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbhJHPyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhJHPx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 11:53:58 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D21C061570;
        Fri,  8 Oct 2021 08:52:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i20so21825989edj.10;
        Fri, 08 Oct 2021 08:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IVEyw9lhSKPQ7nk9zbyzY3MrQrMoG1UtQeH4s0obVK4=;
        b=BM5xU+bdXxzonaku12ZWanDBg3J5jwMF5mf7bW7HLlYzVf8k0HQqHvPbcVNKlsSPwQ
         o9gQFaatbEyCzZhB0kNZe5pBZrXldMpFWwrokdwduTGDKwTH6kPL8+EsiICKEi7lNhhR
         Gzwvb/wJxLO7WShx1Os1Tuj7k1dbMhtBn9JFKJrii8aYBtL5cQ8Qd3IRcENHFRc+bPL2
         fSWjOtDODq5ob2bOtdN0dHpktB2oxne3oO1EIAlu4EP339BQYswftr6cUvAgA/OoJhhf
         lClv/s3iNghPEoWOeY0V0uQ2YtoTySzugNh9bgY9G+5M4rrWlZiS4OS0FcFAgtUtsO+r
         JSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IVEyw9lhSKPQ7nk9zbyzY3MrQrMoG1UtQeH4s0obVK4=;
        b=gb6WSmjKUGyY62xbZMwEDhwkUz+Y4bpxCnQiMAeRqkGhlNuVz+gPEgDm4Na5sOyiTd
         bUOKtb02/V0PSBe7LdHWO43iNAVyERPovOOUDIqMGcC0XNBvV4Ax3n7dqe5KSrHSkfB+
         SPJiIfCKcaq+5j6SqMn5HMSg0AwFWUbBWEhdbVukECdCWJJG5VBG+QVecvTRLTi2/rIN
         lOs8Zi7bxyibD1vD6YnR2KNdkcijYWXSDN3l7exbe6t4dT7WxjlxXGBQsDaI2hu60Vn4
         m7IRtsHlIc21190bcndmlWKzkYLp/eRWSuc+mN9jQgt0CYpfVIs65bhiB6/vMl3TVJCP
         PueA==
X-Gm-Message-State: AOAM530q7y0CsIt+ol42nvhi6KIXSqH9vGYPHUSVBs4mLaLDwqYaRmQJ
        iRMqJRaTn8kr5GJFpLUzXLP8SMQ5jWJ/ODXO2Fg=
X-Google-Smtp-Source: ABdhPJy3TaFBLqNXb8BVZCGZUNm9ZMgFaGVCu+met/21chfsLQ16DtBDc+JGLDhMZrDGWzUIuK2OXw==
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr5382310ejc.239.1633708319854;
        Fri, 08 Oct 2021 08:51:59 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870::d1c? ([2a04:241e:501:3870::d1c])
        by smtp.gmail.com with ESMTPSA id g2sm827697edq.81.2021.10.08.08.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 08:51:59 -0700 (PDT)
Subject: Re: [PATCH] tcp: md5: Fix overlap between vrf and non-vrf keys
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com>
 <209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com>
 <912670a5-8ef2-79cc-b74b-ee5c83534f2b@gmail.com>
 <5c77ac1a-b6af-982f-d72f-e71098df3112@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <3b52d69d-c39f-c662-7211-4b9130c8b527@gmail.com>
Date:   Fri, 8 Oct 2021 18:51:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5c77ac1a-b6af-982f-d72f-e71098df3112@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.10.2021 21:27, David Ahern wrote:
> On 10/7/21 12:41 AM, Leonard Crestez wrote:
>> On 07.10.2021 04:14, David Ahern wrote:
>>> On 10/6/21 11:48 AM, Leonard Crestez wrote:
>>>> @@ -1103,11 +1116,11 @@ static struct tcp_md5sig_key
>>>> *tcp_md5_do_lookup_exact(const struct sock *sk,
>>>>    #endif
>>>>        hlist_for_each_entry_rcu(key, &md5sig->head, node,
>>>>                     lockdep_sock_is_held(sk)) {
>>>>            if (key->family != family)
>>>>                continue;
>>>> -        if (key->l3index && key->l3index != l3index)
>>>> +        if (key->l3index != l3index)
>>>
>>> That seems like the bug fix there. The L3 reference needs to match for
>>> new key and existing key. I think the same change is needed in
>>> __tcp_md5_do_lookup.
>>
>> Current behavior is that keys added without tcpm_ifindex will match
>> connections both inside and outside VRFs. Changing this might break real
>> applications, is it really OK to claim that this behavior was a bug all
>> along?
> 
> no.
> 
> It's been a few years. I need to refresh on the logic and that is not
> going to happen before this weekend.

It seems that always doing a strict key->l3index != l3index condition 
inside of __tcp_md5_do_lookup breaks the usecase of binding one listener 
to each VRF and not specifying the ifindex for each key.

This is a very valid usecase, maybe the most common way to use md5 with vrf.

Ways to fix this:
* Make this comparison only take effect if TCP_MD5SIG_FLAG_IFINDEX is set.
* Make this comparison only take effect if tcp_l3mdev_accept=1
* Add a new flag?

Right now passing TCP_MD5SIG_FLAG_IFINDEX and ifindex == 0 results in an 
error but maybe it should be accepted to mean "key applies only for 
default VRF".

--
Regards,
Leonard
