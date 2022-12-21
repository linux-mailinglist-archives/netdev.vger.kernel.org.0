Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34490652D45
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiLUH2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLUH2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:28:21 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7345C1CFDE
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 23:28:20 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bj12so34643650ejb.13
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 23:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z+bHBCE2MXh1kW8rjyOWsgxy9qRS48It+Vaz6G2WMT0=;
        b=mVk9vm+URVhq0VX3W1uhjC3bUeF40EvBRVpiT7krAj5yU98pHMAAuUjziAgNLDgc+u
         xydWRwGzfau2Z/BgVTnMh9MuqRAvHs404eoDgnZn6TGBPZQuVZZsrvBzRLhYMz4hC1/k
         fzWZ56PpFRduSYipPgvsRlEDB8Xmu03BD0bA4MSDJ8jrYhRfLQKE5FyTRXjm8RBsdTX2
         FrGDZSRnI0G7oGMmloPhJDH7IZM3acXAZ50KGUj1QVLe/G56WVaJgDe2d5b/HvOnpYDU
         GsfNCrjhKZGXiYsXZ5D1B+c6fzXSOF1XpQy9flziTwyM5kpuz3eyr8HF2yd6o37ZHOR2
         R4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+bHBCE2MXh1kW8rjyOWsgxy9qRS48It+Vaz6G2WMT0=;
        b=sDX/Jg1QWjM8oV3c7FToyRIZ/fNNlVi7XWdV5nvqge2yvxo4CLonGTaEvJjk9taUds
         DWjvVtE6k0o7G7RCgwho905+CO7sHpQXaqgVxHxQYzW5sALuZo3/ddB3AkngzCe7TAgz
         KuQuFbp9YHOKP6/YkIUYmoNRv7uk7AVNa5S4eafBqE20lkb979YEyyAybMjisdHFd7R9
         mynj7h+6FvBAj/6tLowzI/d+U8cPkR8DQutG8wbqwwpm0T6+AFs3cWKt15xI/28dYE6/
         FANdIIPYWeXR0vKOtq/AzcPYwtmSOPtOzCNhTC8kwamhm3u+L4dwWehKzxsOAxO8zka7
         gF6g==
X-Gm-Message-State: AFqh2krjfNrUE64ijKTmY56ZDEnwJ36QUAmk60rIArjiNCV0TDvdNPwB
        kOC6yG0eJU1FFaA0LAeawekkxA==
X-Google-Smtp-Source: AMrXdXuhVtTnfPDeHgZiNlrbPEC2BXwNQzHIcORFZqmaNw19rlO0CrgJckUQCjTzesYSbrtCVgx5+Q==
X-Received: by 2002:a17:907:c717:b0:7c1:ad6:638a with SMTP id ty23-20020a170907c71700b007c10ad6638amr575163ejc.17.1671607699037;
        Tue, 20 Dec 2022 23:28:19 -0800 (PST)
Received: from [192.168.0.173] ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id a14-20020a170906670e00b007c0f45ad6bcsm6666612ejp.109.2022.12.20.23.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 23:28:18 -0800 (PST)
Message-ID: <a13f83f3-737d-1bfe-c9ef-031a6cd4d131@linaro.org>
Date:   Wed, 21 Dec 2022 09:28:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: kernel BUG in __skb_gso_segment
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        gregkh@linuxfoundation.org
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com, liuhangbin@gmail.com,
        linux-kernel@vger.kernel.org, joneslee@google.com
References: <82b18028-7246-9af9-c992-528a0e77f6ba@linaro.org>
 <CAF=yD-KEwVnH6PRyxbJZt4iGfKasadYwU_6_V+hHW2s+ZqFNcw@mail.gmail.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <CAF=yD-KEwVnH6PRyxbJZt4iGfKasadYwU_6_V+hHW2s+ZqFNcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I added Greg KH to the thread, maybe he can shed some light on whether
new support can be marked as fixes and backported to stable. The rules
on what kind of patches are accepted into the -stable tree don't mention
new support:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

On 20.12.2022 20:27, Willem de Bruijn wrote:
> On Tue, Dec 20, 2022 at 8:21 AM Tudor Ambarus <tudor.ambarus@linaro.org> wrote:
>>
>> Hi,
>>
>> There's a bug [1] reported by syzkaller in linux-5.15.y that I'd like
>> to squash. The commit in stable that introduces the bug is:
>> b99c71f90978 net: skip virtio_net_hdr_set_proto if protocol already set
>> The upstream commit for this is:
>> 1ed1d592113959f00cc552c3b9f47ca2d157768f
>>
>> I discovered that in mainline this bug was squashed by the following
>> commits:
>> e9d3f80935b6 ("net/af_packet: make sure to pull mac header")
>> dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
>>
>> I'm seeking for some guidance on how to fix linux-5.15.y. From what I
>> understand, the bug in stable is triggered because we end up with a
>> header offset of 18, that eventually triggers the GSO crash in
>> __skb_pull. If I revert the commit in culprit from linux-5.15.y, we'll
>> end up with a header offset of 14, the bug is not hit and the packet is
>> dropped at validate_xmit_skb() time. I'm wondering if reverting it is
>> the right thing to do, as the commit is marked as a fix. Backporting the
>> 2 commits from mainline is not an option as they introduce new support.
>> Would such a patch be better than reverting the offending commit?
> 
> If both patches can be backported without conflicts, in this case I
> think that is the preferred solution.

I confirm both patches can be backported without conflicts.

> 
> If the fix were obvious that would be an option. But the history for
> this code indicates that it isn't. It has a history of fixes for edge
> cases.
> 
> Backporting the two avoids a fork that would make backporting
> additional fixes harder. The first of the two is technically not a

I agree that a fork would make backporting additional fixes harder.
I'm no networking guy, but I can debug further to understand whether the
patch that I proposed or other would make sense for both mainline and
stable kernels. We'll avoid the fork this way.

> fix, but evidently together they are for this case. And the additional
> logic and risk backported seems manageable.

It is, indeed.

> 
> Admittedly that is subjective. I can help take a closer look at a
> custom fix if consensus is that is preferable.

Thanks. Let's wait for others to comment so that we have an agreement.

Cheers,
ta
