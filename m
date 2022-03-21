Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5329B4E2FF9
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352158AbiCUS3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352159AbiCUS3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:29:38 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABACA23168
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:28:09 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b24so18889881edu.10
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vxDjZJw8YbIa7yiqHZ1qJ5BVI/pM3gs0fIypyNkId0E=;
        b=o92drQsrHxiM+597JdDKj4aJymkZS+L0voHvG4N2ietOg910EnUQEscO026sCaI7PK
         0XH2BUwiafqY7l73Ur9nAXfhER83tr13Iu05jCnAbeh0+EH9Ge/wvLM1d8cexM/22bXW
         YAG8wGrbfoiGuRUzA9MBpYt4GBpOeGdH1S0TkeO1yqjqyf5l6PiSc62KdvsUuRP2uwAJ
         TyfouS/NN4I5jdJnAstAW/1bDn4uqKIzuL7EIdKXiO+jdFoqMbP+VlZfoUh13o/+nvFB
         Qst19DhCRJD/ApzU00ukgCbKmtNPJAV/dvsGgXsk75F+untHt6+RvOvMMq4s61g+9AOK
         mwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vxDjZJw8YbIa7yiqHZ1qJ5BVI/pM3gs0fIypyNkId0E=;
        b=tld29y446S+m7JKJtsNou9dJ1S3J/RbK9Evl5/+Ig0tk7FcCYLw7b7Zx1WVvB61z6M
         JLhBqYVzHWJgzjCLr6SG/ghln2KMNeZVmCfOdnJgRhz22rCCv43XXaLqYpXm9J5OJcNU
         JoJXM/dcRSefOLlnyyN5Z+cLIDJKu66bC3+lDt61IB+Peb3OTsVoQ3sXW1vdeSMb80n5
         cJG1RMV3JMY8Arq31iDrQykuQHsxJ0V/kZvs+yzEPYsgF/4UxPXQF+lDq+/PxNRmei5D
         dKgKaaHVWLGNcTmxjAjHI2+sJEYC6AN51u0HJspI5gmfRuiwW3WZb/wiskpVBfklQe39
         9J5w==
X-Gm-Message-State: AOAM531g8w4KjC+Xk1d9U9KOxWfYOurOkFlfPvCQQ5nEc17aeBVT5koQ
        jIU49q5UpBFtKmb5Kl76pyHjDEVBasZhBg==
X-Google-Smtp-Source: ABdhPJztVJAlgbdWomE6lg3jzdsBULKTEtuaQI75n3NHAQf2hf3asGICrlK5DdNU+zeV1OmcvSyECQ==
X-Received: by 2002:a05:6402:1e92:b0:419:76:21a6 with SMTP id f18-20020a0564021e9200b00419007621a6mr21271948edf.128.1647887287578;
        Mon, 21 Mar 2022 11:28:07 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id o7-20020a17090608c700b006cef23cf158sm7212692eje.175.2022.03.21.11.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 11:28:07 -0700 (PDT)
Message-ID: <dfeb092a-21ba-386c-11e4-584fd936743a@gmail.com>
Date:   Mon, 21 Mar 2022 19:28:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v2] ipv6: acquire write lock for addr_list in
 dev_forward_change
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220317155637.29733-1-dossche.niels@gmail.com>
 <7bd311d0846269f331a1d401c493f5511491d0df.camel@redhat.com>
 <a24b13ea10ca898bb003300084039b459d553f6d.camel@redhat.com>
 <13558e3e0ed23097f04bb90b43c261062dca9107.camel@redhat.com>
 <f8b7e306-916d-a3e7-5755-b71d6b118489@gmail.com>
 <0cf800e8bb28116fce7466cacbabde395abfac4f.camel@redhat.com>
 <8b90b4a6-a906-0f46-bb87-0ec51c9c89fe@gmail.com>
 <5bda97a3-6efc-4ce2-859a-be44f3c2345e@kernel.org>
 <f8a4117900f09cd1b5f6c51d6a7299549d7cd3c1.camel@redhat.com>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <f8a4117900f09cd1b5f6c51d6a7299549d7cd3c1.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2022 19:15, Paolo Abeni wrote:
> On Mon, 2022-03-21 at 09:42 -0600, David Ahern wrote:
>> On 3/19/22 7:17 AM, Niels Dossche wrote:
>>> I have an additional question about the locks on the addr_list actually.
>>> In addrconf_ifdown, there's a loop on addr_list within a write lock in idev->lock
>>>> list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list)
>>> The loop body unlocks the idev->lock and reacquires it later. I assume because of the lock dependency on ifa->lock and the calls that acquire the mc_lock? Shouldn't that list iteration also be protected during the whole iteration?
>>>
>>
>>
>> That loop needs to be improved as well. Locking in ipv6 code is a bit
>> hairy.
> 
> I *think* we could re-use the if_list_aux trick: create a tmp list
> under idev->lock using ifa->if_list_aux and traverse (still using the
> _safe variant) such list with no lock.
> 

This sounds like a good plan.

> Still in addrconf_ifdown(), there is a similar loop for
> 'tempaddr_list'.
> 
> In the latter case I think we could splice the idev->lock protected
> list into a tmp one and traverse the latter with no lock held.
> 
> @Niels: could you look at that, too?

I will be able to look into this tomorrow in more detail, I'll try then to create a patch series.

> 
> Thanks!
> 
> Paolo
> 

Cheers
Niels
