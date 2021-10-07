Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E86425ABD
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243652AbhJGS3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhJGS3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 14:29:38 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A36C061570;
        Thu,  7 Oct 2021 11:27:44 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h10so378191ilq.3;
        Thu, 07 Oct 2021 11:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hTmSLuC5KvcfBNoN/JulGigdZCXvDXx6oyLyWAeBh50=;
        b=PKOIFLpOvb1GVCDeXgmng7e5pVjnw17YFBuTLRiMYolahDTeFWOYcDM4su7McU8uvG
         Dxw0PAelKB2/Pr9eukgQ2CGo3HHToIeU14Pey6vJZ677pfI7b8Bw/Vbh+CJdNfy/1ln9
         bfgDTICx0/O/tlLnTGAVHjzeZhyCBAih71w4xj6tqZXXxIiUyups9UNOBCkOkVb6c3yF
         L2Axj647q5ht7FJZ8pZfFrneyiYKl27EAIF9/nwSi7Pm0cC68w1cx+g+IF7V05s1ZhAg
         Z/ZQdpx2SIp81gQ4c0i6Dnx2P3fOkssIEeP9ZEyegYA9MJvrotfTuslf/QXlXbYrMcb2
         vnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hTmSLuC5KvcfBNoN/JulGigdZCXvDXx6oyLyWAeBh50=;
        b=Sb4fvjH8AzA9jdVWCextRVBxctIXYsRnfw/VlcMD8qtfh2UcDs0AT8Zcotu74nOhkd
         xda89nc+oRYE6SB6BFUXgi58KFxY15HWiWezPksDWfWnTrfny7TZDHs3d/zzlmgfQYNp
         lOiEwMoj0UhNZ/egk4R7Ipxe/WtxgGQYOKm1d8H2NAuzaxUsOYpyh9TDzYicyOhb78wk
         XfODUBNUKiQpBRrkpZgKqln4uMcZ6IUUDiF/oE/5MyqFz37cuVYQVwXjfdNI2L9wVfOf
         zcRMT7joRujKiixtoEYCdQZA2wCXzW95nQHm4bpMk3JreShVQxdrFDz88VfEIVNJGXSt
         zSkw==
X-Gm-Message-State: AOAM533Wh6GkexBzj9Q0QA9pAGRoonkWcu6oyYVT7IS5aEK5m4z+jolj
        Py9byMEaGJwJ0gvTsJhxSX4rlgGVP5qu/g==
X-Google-Smtp-Source: ABdhPJzCgNX8oJGtwmBHcJPqdYu9zPp24PO171StgIofcJwCErVdCfcJ1RNMi+tEa0OAm0RnqYNriw==
X-Received: by 2002:a05:6e02:16cc:: with SMTP id 12mr4428989ilx.296.1633631263772;
        Thu, 07 Oct 2021 11:27:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k4sm59522ilc.10.2021.10.07.11.27.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 11:27:43 -0700 (PDT)
Subject: Re: [PATCH] tcp: md5: Fix overlap between vrf and non-vrf keys
To:     Leonard Crestez <cdleonard@gmail.com>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5c77ac1a-b6af-982f-d72f-e71098df3112@gmail.com>
Date:   Thu, 7 Oct 2021 12:27:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <912670a5-8ef2-79cc-b74b-ee5c83534f2b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 12:41 AM, Leonard Crestez wrote:
> 
> 
> On 07.10.2021 04:14, David Ahern wrote:
>> On 10/6/21 11:48 AM, Leonard Crestez wrote:
>>> @@ -1103,11 +1116,11 @@ static struct tcp_md5sig_key
>>> *tcp_md5_do_lookup_exact(const struct sock *sk,
>>>   #endif
>>>       hlist_for_each_entry_rcu(key, &md5sig->head, node,
>>>                    lockdep_sock_is_held(sk)) {
>>>           if (key->family != family)
>>>               continue;
>>> -        if (key->l3index && key->l3index != l3index)
>>> +        if (key->l3index != l3index)
>>
>> That seems like the bug fix there. The L3 reference needs to match for
>> new key and existing key. I think the same change is needed in
>> __tcp_md5_do_lookup.
> 
> Current behavior is that keys added without tcpm_ifindex will match
> connections both inside and outside VRFs. Changing this might break real
> applications, is it really OK to claim that this behavior was a bug all
> along?

no.

It's been a few years. I need to refresh on the logic and that is not
going to happen before this weekend.

