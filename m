Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A4C4DC945
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiCQOwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiCQOwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:52:49 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C22202169
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:51:32 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id m12so6842300edc.12
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8wSsrcHpwbo8/uuMQoY5kz1GaEM5C5/H46ONEWM9xqE=;
        b=MGWev8sqtvgMB2kQ2vlxcCUXRMg62AeV8KBfx7/DUipJ7sVo0C8C27ZD94cxLGamvs
         mBMjE+x6JAp/gG5iI9EqGYw7ot3WPWIPyT/RO27idIfJvkUe3N/zbai8rd1oG6nAnMCM
         IUcJMf7hJHq7FRCC/beF+LCDIbj2oapU71v0aBvlFDByC4tctvGA+TkB63PLyX/Ko60v
         6lBTi3IvEStONOngL1+a4Py71vzG1NoNusvfrA3ti0Jimc81nhLgAfgdogFzBY73d3cu
         2DF3idMORiU4FXjHpaIIxOfRfER0sbKE7TEgW4E2yLCkJ1ALv0aDBY+f1M9SuW7JvFae
         5K/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8wSsrcHpwbo8/uuMQoY5kz1GaEM5C5/H46ONEWM9xqE=;
        b=KR4XpDdnXm7FZ7z3I2beofGJO1w9yxgEcFRkWjBPvqYAoNJIGJjiavxV+4vHEsrf10
         9/jezW9rHSP3OAJEiZAXfzrbdOPQUUXsdVeOy9OE2zOoJFmKyXzddm+u9ssoibRt77u9
         +itIVo44xlBQlJaaSep7BpC/tX3vjAbOUggn2pBt7l3DrAzIdEHwqfVyscUmne6XQewg
         QnYBRGMeH9Iy09nflenUWum2HsmUnP/1ZPunroTCC70/xloMpCb4dEm9czVK7kENiPgf
         CmnxlPa0Qq4WjjV+0qFBWUQxq2ZxYjzoWt3qDqNNHAkLIeKT7NgwabtkSInpLFq4neYn
         lHXA==
X-Gm-Message-State: AOAM531z/JV76tQlw4VKBj8kkCa//H8ketuU/clukm86GihdOYvXgRHO
        I/fcc/01ii38zMpS72Pufs8=
X-Google-Smtp-Source: ABdhPJz8Jtcj10743Mos5EqYqS99MfRc3uP/uHruwY5B7dgWXeJYPhBUET5iRPf6P2eRzx/qKa3dVQ==
X-Received: by 2002:a50:d097:0:b0:415:cec5:3b31 with SMTP id v23-20020a50d097000000b00415cec53b31mr4741554edd.377.1647528690609;
        Thu, 17 Mar 2022 07:51:30 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id zb5-20020a17090687c500b006ce2a98f715sm2422101ejb.117.2022.03.17.07.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 07:51:30 -0700 (PDT)
Message-ID: <f5e541f8-2222-8c24-381f-2fa28d37eb5a@gmail.com>
Date:   Thu, 17 Mar 2022 15:51:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] ipv6: acquire write lock for addr_list in
 dev_forward_change
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20220315230222.49793-1-dossche.niels@gmail.com>
 <37e7909450ebd3b1abcc83119603aa75ab8fc22b.camel@redhat.com>
 <7d15c878-c4bd-8a30-9faa-7279f78a271f@kernel.org>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <7d15c878-c4bd-8a30-9faa-7279f78a271f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2022 15:45, David Ahern wrote:
> On 3/17/22 5:13 AM, Paolo Abeni wrote:
>> On Wed, 2022-03-16 at 00:02 +0100, Niels Dossche wrote:
>>> No path towards dev_forward_change (common ancestor of paths is in
>>> addrconf_fixup_forwarding) acquires idev->lock for idev->addr_list.
>>> Since addrconf_{join,leave}_anycast acquire a write lock on addr_list in
>>> __ipv6_dev_ac_inc and __ipv6_dev_ac_dec, temporarily unlock when calling
>>> addrconf_{join,leave}_anycast analogous to how it's done in
>>> addrconf_ifdown.
>>>
>>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>>> ---
>>>  net/ipv6/addrconf.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>>> index f908e2fd30b2..4055ded4b7bf 100644
>>> --- a/net/ipv6/addrconf.c
>>> +++ b/net/ipv6/addrconf.c
>>> @@ -818,14 +818,18 @@ static void dev_forward_change(struct inet6_dev *idev)
>>>  		}
>>>  	}
>>>  
>>> +	write_lock_bh(&idev->lock);
>>>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>>>  		if (ifa->flags&IFA_F_TENTATIVE)
>>>  			continue;
>>> +		write_unlock_bh(&idev->lock);
>>
>> This looks weird?!? if 'addr_list' integrity is guaranteed by 
>> idev->lock, than this patch looks incorrect. If addr_list integrity is
>> ensured elsewhere, why acquiring idev->lock at all?
>>
>> @David: can you please comment here?
>>
> 
> I have stared at this change a few times. It does look weird and does
> not seem to be really solving the problem (or completely solving it).
> 
> I think a better option is to investigate moving the locks in the
> anycast functions up a layer or two so that the lock here can be held
> for the entire list walk.

Hi
Thanks for the review.
I can write a patch today that fixes it the way you suggest and then send it as a v2.
