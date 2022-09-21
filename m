Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B05BFEBD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiIUNNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiIUNNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:13:44 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2418B2DF
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:13:42 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u18so9130384lfo.8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=QH/PwubPd+yNlbYfHl5TNR1/EKplw6cIhRp3ulwWfjs=;
        b=6vYn/qf1uwsdhZ3m3zwPOEf82apOrFH5cAFYv1sJCbB4NXEK+W2URS4QY7NkXwKk8k
         H4eFa0aghcxYMsr37y7CdJ3ApEF39HcnKtj+9Z+mImaUMerG10tKC0p0ENdLJ+VKRN0e
         WtCg/zmkfbLYfiKNoCxJesKg05rRQ0z+nJzB0AcWPTD3e5U554FQUTiRKrSshQNanivI
         L5u3mufhIHK/1u5duOSBPx2JQuipjzmcpazQOhNKy/suEhiweog8rCHZ/LyStIcy2KSC
         al2d8GfZfEviY5TC7IGbIhZOism+JCsrCGSGHCCuEhlwRADLmUV+5SYnsdDqvyQrknFh
         vijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=QH/PwubPd+yNlbYfHl5TNR1/EKplw6cIhRp3ulwWfjs=;
        b=228gWDRhR4eAHEX41RNzWf2Vgls7cIpY32DuHjZgI5YJuf4ZmEkQE3ZMJVO+cA8w7z
         kgYxnT+2E1iq92fY9/KLbkRJY+eT5ZYdwRhzJUxDnAy90E1/lmNfzyl7eLs8PJCYLhWt
         TRmIUEsmEsUUwDtlEP1VPoa8o97GjO3RnzhLXGOhyFJJy6/a47g/zRnop6MaYIt8DWj9
         uW1qJchsfADNyxfgRUIA3AxjC6J0XJwlXkIbNwkqTyropW31vPaOltNK9Khdp/mY2J73
         mBM93oK/8CPDh3tLh4/qK09whw1Myn+GYy0oLeuLfvBu6bYkPrMIPjrsl04IakzLdSEq
         HO6Q==
X-Gm-Message-State: ACrzQf38s04F9x1ehbCsRGsU0edvVCLUqTi6ael2ichIqtOqiJouu+ww
        m6M/+YG9tw14ZmFboFRADl9j3AZkdECnIpNzKwk=
X-Google-Smtp-Source: AMsMyM7Oo5p1rfWChQ4M9IjfqAjRLQ4ijrh514J9c4ELqcJyaDZRumNhRknS7CWtxEnWSa6O3oXmLA==
X-Received: by 2002:a05:6512:3128:b0:499:3c1d:f9e with SMTP id p8-20020a056512312800b004993c1d0f9emr9971052lfd.634.1663766020972;
        Wed, 21 Sep 2022 06:13:40 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id k1-20020ac257c1000000b00492e98c27ebsm429022lfo.91.2022.09.21.06.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 06:13:39 -0700 (PDT)
Message-ID: <2bc08e2d-1814-ce3d-c7e9-bd35f3fb114e@blackwall.org>
Date:   Wed, 21 Sep 2022 16:13:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <20220921060123.1236276d@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220921060123.1236276d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2022 16:01, Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 11:07:21 +0800 Hangbin Liu wrote:
>> Netlink messages are used for communicating between user and kernel space.
>> When user space configures the kernel with netlink messages, it can set the
>> NLM_F_ECHO flag to request the kernel to send the applied configuration back
>> to the caller. This allows user space to retrieve configuration information
>> that are filled by the kernel (either because these parameters can only be
>> set by the kernel or because user space let the kernel choose a default
>> value).
>>
>> This patch handles NLM_F_ECHO flag and send link info back after
>> rtnl_{new, set}link.
>>
>> Suggested-by: Guillaume Nault <gnault@redhat.com>
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> ---
>>
>> In this patch I use rtnl_unicast to send the nlmsg directly. But we can
>> also pass "struct nlmsghdr *nlh" to rtnl_newlink_create() and
>> do_setlink(), then call rtnl_notify to send the nlmsg. I'm not sure
>> which way is better, any comments?
>>
>> For iproute2 patch, please see
>> https://patchwork.kernel.org/project/netdevbpf/patch/20220916033428.400131-2-liuhangbin@gmail.com/
> 
> I feel like the justification for the change is lacking.
> 
> I'm biased [and frankly it takes a lot of self-restraint for me not
> to say how I _really_ feel about netlink msg flags ;)] but IMO the
> message flags fall squarely into the "this is magic which was never
> properly implemented" bucket.
> 
> What makes this flag better than just issuing a GET command form user
> space?
> 
> The flag was never checked on input and is not implemented by 99% of
> netlink families and commands.
> > I'd love to hear what others think. IMO we should declare a moratorium
> on any use of netlink flags and fixed fields, push netlink towards
> being a simple conduit for TLVs.
> 

+1
Just issue a "get" after the change.
