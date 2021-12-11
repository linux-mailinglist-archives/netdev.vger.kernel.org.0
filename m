Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C194471717
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 23:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhLKWNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 17:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhLKWNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 17:13:04 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB77C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 14:13:04 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id t23so18192594oiw.3
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 14:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6PahRn5fhdyuZk4v9z4RI/X3Cz0LXioqj2f5JFCTO4Y=;
        b=SIFd/vSy6kmrt/3xCOU/yOjWVW9D6jYQ27VGzjhR5s0ba773fYYFIX7gN7CGK36h2B
         dfg6gHKwDyiqajAW2td2zDDnSdmzvbOOz1TRD18r8OYF2zaWVi9tmEvPVbxtxqZEKx+/
         MX2Z9E+uNuLmAWXdxZOdXCfbzy/x7FOW6AeunDefUXvPmA+haLkh3RoF+cG58zTlhbzq
         maEzalGxNLAdYUAD3bF2hPHmfx1PhWfJToz15gyjB0qozlGOIS24ZJzEk6RZ6+DRs+GI
         EtULIaR4Pkep2MoZCsB1b69w//AGOUIUuEKrfWGqOMNCrjDL7CNjbyuuGn3MSvtXlfpO
         PnDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6PahRn5fhdyuZk4v9z4RI/X3Cz0LXioqj2f5JFCTO4Y=;
        b=xvFcLRgdY0z07cGhZEGzZMiLdSCqySICt8/HxjP5MzMgBeND/VpkVFR5Pm1XZJ2brC
         eUyC+M58NG1Wa9q1QYJxkWPjBIPCDuEEbZ+LEJBy0Mw3u+hgLCiEARt4WTeN5LubbmN2
         DP6qerhYqd3Osl+iqn7/BKyBUY/g1yty4UB4TaV9zVzR1M5Ht8krKy39K/03SW8fi5O7
         EQ6ZuOQQtpf6YzKQeGAbbiscKGafAV9kq9wC48NvRi0oy1omeIpimaGZqXbSboZfdx0g
         Gp6Hzjg8mMErDGkhbFRDy48eu//g/iuwr/0Wn8unCL/ipKN6HoPhhc0PW3KU9BPPKVVr
         Q/MQ==
X-Gm-Message-State: AOAM5336/WYAzb0Kk/D6mVF8v28+iRdVrhGsbe16PJ7JAWkWk+e2iFJA
        tZkW4A5ll678RM/1mSN4PT0Bl34/L8k=
X-Google-Smtp-Source: ABdhPJxo0iXdCveQdQpss1fFCj4JWBQQauQSBQ61dKY5DLXNiMjJZXCUvUNMKuoSb6kspYqxHbUQLQ==
X-Received: by 2002:aca:ad95:: with SMTP id w143mr19409565oie.47.1639260784067;
        Sat, 11 Dec 2021 14:13:04 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id v2sm1276535oto.3.2021.12.11.14.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 14:13:03 -0800 (PST)
Message-ID: <73de092c-e6d0-72d6-3547-b4217076f6f9@gmail.com>
Date:   Sat, 11 Dec 2021 15:13:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] ipv4: Check attribute length for RTA_GATEWAY
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>, David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org,
        syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com,
        Thomas Graf <tgraf@suug.ch>
References: <20211211162148.74404-1-dsahern@kernel.org>
 <YbT4ZJ+bSc/qeT5A@shredder>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YbT4ZJ+bSc/qeT5A@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/21 12:13 PM, Ido Schimmel wrote:
> On Sat, Dec 11, 2021 at 09:21:48AM -0700, David Ahern wrote:
>> syzbot reported uninit-value:
>> ============================================================
>>   BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80
>>   net/ipv4/fib_semantics.c:708
>>    fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
>>    fib_create_info+0x2411/0x4870 net/ipv4/fib_semantics.c:1453
>>    fib_table_insert+0x45c/0x3a10 net/ipv4/fib_trie.c:1224
>>    inet_rtm_newroute+0x289/0x420 net/ipv4/fib_frontend.c:886
>>
>> Add length checking before using the attribute.
>>
>> Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
>> Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com
>> Signed-off-by: David Ahern <dsahern@kernel.org>
>> Cc: Thomas Graf <tgraf@suug.ch>
>> ---
>> I do not have KMSAN setup, so this is based on a code analysis. Before
> 
> Was using this in the past:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bugs

thanks for the pointer. I am a bit hardware challenged at the moment for
out of tree features.

> 
>> 4e902c57417c fib_get_attr32 was checking the attribute length; the
>> switch to nla_get_u32 does not.
>>
>>  net/ipv4/fib_semantics.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index 3cad543dc747..930843ba3b17 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -704,6 +704,10 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
>>  				return -EINVAL;
>>  			}
>>  			if (nla) {
>> +				if (nla_len(nla) < sizeof(__be32)) {
>> +					NL_SET_ERR_MSG(extack, "Invalid IPv4 address in RTA_GATEWAY");
>> +					return -EINVAL;
>> +				}
> 
> Isn't the problem more general than that? It seems that there is no
> minimum length validation to any of the attributes inside RTA_MULTIPATH.
> Except maybe RTA_VIA
> 

A follow up commit is needed for RTA_FLOW.
