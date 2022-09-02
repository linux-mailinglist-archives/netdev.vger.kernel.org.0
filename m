Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033D45AADFA
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 14:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiIBMDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 08:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbiIBMDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 08:03:13 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B382D2765
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 05:03:09 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v16so2024460wrm.8
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 05:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=QD0f458hOs+Yc5mX36c226dEAIGqQyTyl2jnPRNMycE=;
        b=Nhb1ahfA74o2s885SBr3+p7hcg6A5trn06OdOOEsjKKjFz3xUQjTC+3l3BPw4x4Qki
         98tFbxCk29ZzNK7mwS9hdQLBXJ2U0PXMZ5YRU8SPhG0NBqBWxaUaS2FNC5qauktJkfRo
         9rZdTHGIQ0cizhHhmN3DsASDHBBg2+6yta30EzY18XTF2GzhyvwTT5WtHS4pUXNOokWM
         smV7YZ+D6cPPo9D1W/B0l/nDLsvOJ9pu2LT2+CSwck8KGk/8IsyKQWUrmcdEhVm+kqjm
         6yIn4isWEbDRvmS5iiZ93glHw6Qy+ZKUoLeE6TwLCCFch0cQkdmvcpJL0LY/GNtpb4EI
         zZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=QD0f458hOs+Yc5mX36c226dEAIGqQyTyl2jnPRNMycE=;
        b=KSUQ8gV3h6ExYKRr9cKSzNxReUQ2N0Fs5aje5POyvneNS0UWsXyBbC5hmKDGbJQXqd
         PYg7rmuwUuasvnUAP4r+kCa4iNB8H1wEgqm+O3DEWpvKpnhVpntrVvBw5NK0SLqQtZz9
         6teSF/kvA9iCQWbc9blEnfZEmxL+GdBhJ6tKtE3GK+ysuQkUYOS0TiTYHlF3l06pITnZ
         ztnzHhE8iRTU7wrNBePfAYKd/+Gw0FAA8v+Urjc0t0QCVgx+1h04X9LVYepinZl/Yiqz
         LU9xg8hugzIp3D+N4ZYbTyCcGd5txkHpF6SKBmpjUK6ijk9UfHdkapQ8OmH1PXNhXTlQ
         6q5g==
X-Gm-Message-State: ACgBeo0bIyzY0+N+itdA93BmIKsxRmGYkp7PL5QgMkw2qmzWdaKfjuHY
        9HPBhWQ5IFO7EY005s0nmjfMIU/AfygQ/A==
X-Google-Smtp-Source: AA6agR6NBs+WZRiv1NUV1OsVl1k+nVX/H7sz5z2SKboCwbDVO74A7WpVLMgN0Co/JBUiwBZUjdmenA==
X-Received: by 2002:a05:6000:799:b0:226:e3e9:e482 with SMTP id bu25-20020a056000079900b00226e3e9e482mr10057791wrb.219.1662120188014;
        Fri, 02 Sep 2022 05:03:08 -0700 (PDT)
Received: from [10.44.2.26] (84-199-106-91.ifiber.telenet-ops.be. [84.199.106.91])
        by smtp.gmail.com with ESMTPSA id s8-20020a1cf208000000b003a83fda1dc5sm1894953wmc.44.2022.09.02.05.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 05:03:06 -0700 (PDT)
Message-ID: <695db55b-959c-0165-b35d-338ba36fa0e4@tessares.net>
Date:   Fri, 2 Sep 2022 14:03:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] selftests: net: sort .gitignore file
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220829184748.1535580-1-axelrasmussen@google.com>
 <fe9280ff-50b3-805a-07ef-0227cbec13e8@tessares.net>
 <20220901130529.2f364617@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220901130529.2f364617@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 01/09/2022 22:05, Jakub Kicinski wrote:
> On Thu, 1 Sep 2022 12:15:02 +0200 Matthieu Baerts wrote:
>> Hello,
>>
>> On 29/08/2022 20:47, Axel Rasmussen wrote:
>>> This is the result of `sort tools/testing/selftests/net/.gitignore`, but
>>> preserving the comment at the top.  
>>
>> FYI, we got a small conflict (as expected by Jakub) when merging -net in
>> net-next in the MPTCP tree due to this patch applied in -net:
>>
>>   5a3a59981027 ("selftests: net: sort .gitignore file")
>>
>> and these ones from net-next:
>>
>>   c35ecb95c448 ("selftests/net: Add test for timing a bind request to a
>> port with a populated bhash entry")
>>   1be9ac87a75a ("selftests/net: Add sk_bind_sendto_listen and
>> sk_connect_zero_addr")
>>
>> The conflict has been resolved on our side[1] and the resolution we
>> suggest is attached to this email: new entries have been added in the
>> list respecting the alphabetical order.
> 
> Yup, that was my plan as well. Apologies for the trouble, I thought
> since the conflict will only exist for a day I'd be the only one
> suffering.

That's alright, it was not difficult to resolve :)

We do the sync everyday around 6AM UTC time:


https://github.com/multipath-tcp/mptcp_net-next/actions/workflows/update-tg-tree.yml

If you prefer and if we have issues on a Thursday, we can also wait for
the next day before looking at these conflicts and report them.

> I think we should also sort the Makefile FWIW.
> Perhaps it's better done during the merge window.

Indeed, that would make sense to do them at this period but I also
understand such clean-up are useful to reduce conflicts later.

Such conflicts created by the clean-up are also easy to resolve so no
need to worry to much I think.

>> I'm sharing this thinking it can help others but if it only creates
>> noise, please tell me! :-)
> 
>> [1] https://github.com/multipath-tcp/mptcp_net-next/commit/4151695b70b6
> 
> It is useful, thanks!

I'm glad it is! (Sharing them is also useful for us to avoid diverging
our tree from net and net-next if the conflicts are resolved differently
:) )

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
