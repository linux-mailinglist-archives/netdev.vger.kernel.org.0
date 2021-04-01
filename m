Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24310351A32
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbhDAR6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:58:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236737AbhDARzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kYB7nsQRvgOWwahxIriUsv1ff+yhn1+1fBCAwwTEGdg=;
        b=MklzievNQ6c4MBqpj3sm5puvlBz0rOWVidhf4ezkodjU2h72iEaypZ9LImCbLR7+zfAxEN
        REM25d9iAY7nRsEsuymYL++Kfcz5zhg4oWD9cFyyvCL1xQ7aOHJKeUFuJmv1oeeP+S3CYC
        EK8Sf5C4XQzousPkuTGqheVdUHdcRFU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-KMMWWz-6OiGm9Wt1JUUHHA-1; Thu, 01 Apr 2021 07:28:42 -0400
X-MC-Unique: KMMWWz-6OiGm9Wt1JUUHHA-1
Received: by mail-ed1-f70.google.com with SMTP id j18so2677892edv.6
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 04:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kYB7nsQRvgOWwahxIriUsv1ff+yhn1+1fBCAwwTEGdg=;
        b=mXgg2g6VI4y78zublnN3BYoauymi3/Y9EDEPFdZ/pdF/ZzNWyFP0jfII7LHTHM6AFm
         wHH26v7c0DF5fSFa8lKeEtAWYSZ0qHtphFAAKkivYqaCYea3O/AsDl8fG9rjtd9K1pr7
         AfmQ5TAEw8xC2oj4L07tH/ryukZw/LIxLC3vgMLB6qXeh+R3wUCgVDeJhbaVbV26Wohx
         jQF3Ke2RmvY8wfttyceez8yuPkSAy0Xx6k8E28/7ile1hQLxbDTQDBr2m/tVdI1ETpHv
         84x1LEz/jnxRsLCauhueob1VIc9G/udM3UeJ1gNo1Efb0ZZHvBlteFhGy8fKUWvhkAnk
         AxnA==
X-Gm-Message-State: AOAM530VZHyFHFd7juW77wPEMjqJ64XFOyqqjWJ0FDVzHKTvxZTz+2Q5
        czeWHDRxgxq2eQLQ9wiJANGEv2TBHZtkh189zSjztFc+mHg3ZRbo9BKcaY6JXEJq2rOXOOuEZTe
        apz3EQ1lnGnxErkka
X-Received: by 2002:a17:906:39cf:: with SMTP id i15mr8611412eje.534.1617276521096;
        Thu, 01 Apr 2021 04:28:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM90mMp9xxqB5PQWtgMXKmDDSnhDgqxIKiDnH3S76S/w+jiRFzJ+UAOVF2mpWfISBrhIMGEg==
X-Received: by 2002:a17:906:39cf:: with SMTP id i15mr8611385eje.534.1617276520940;
        Thu, 01 Apr 2021 04:28:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l18sm2580883ejk.86.2021.04.01.04.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 04:28:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C9E94180290; Thu,  1 Apr 2021 13:28:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        patchwork-bot+netdevbpf@kernel.org
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, alexander.duyck@gmail.com,
        ioana.ciornei@nxp.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, ilias.apalodimas@linaro.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 0/9] XDP for NXP ENETC
In-Reply-To: <20210331225543.oelvapw3pli45k5q@skbuf>
References: <20210331200857.3274425-1-olteanv@gmail.com>
 <161722921847.2890.11454275035323776176.git-patchwork-notify@kernel.org>
 <20210331225543.oelvapw3pli45k5q@skbuf>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 01 Apr 2021 13:28:39 +0200
Message-ID: <878s62nt08.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Wed, Mar 31, 2021 at 10:20:18PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This series was applied to netdev/net-next.git (refs/heads/master):
>>
>> On Wed, 31 Mar 2021 23:08:48 +0300 you wrote:
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> > This series adds support to the enetc driver for the basic XDP primitives.
>> > The ENETC is a network controller found inside the NXP LS1028A SoC,
>> > which is a dual-core Cortex A72 device for industrial networking,
>> > with the CPUs clocked at up to 1.3 GHz. On this platform, there are 4
>> > ENETC ports and a 6-port embedded DSA switch, in a topology that looks
>> > like this:
>> >
>> > [...]
>>
>> Here is the summary with links:
>>   - [net-next,1/9] net: enetc: consume the error RX buffer descriptors in a dedicated function
>>     https://git.kernel.org/netdev/net-next/c/2fa423f5f0c6
>>   - [net-next,2/9] net: enetc: move skb creation into enetc_build_skb
>>     https://git.kernel.org/netdev/net-next/c/a800abd3ecb9
>>   - [net-next,3/9] net: enetc: add a dedicated is_eof bit in the TX software BD
>>     https://git.kernel.org/netdev/net-next/c/d504498d2eb3
>>   - [net-next,4/9] net: enetc: clean the TX software BD on the TX confirmation path
>>     https://git.kernel.org/netdev/net-next/c/1ee8d6f3bebb
>>   - [net-next,5/9] net: enetc: move up enetc_reuse_page and enetc_page_reusable
>>     https://git.kernel.org/netdev/net-next/c/65d0cbb414ce
>>   - [net-next,6/9] net: enetc: add support for XDP_DROP and XDP_PASS
>>     https://git.kernel.org/netdev/net-next/c/d1b15102dd16
>>   - [net-next,7/9] net: enetc: add support for XDP_TX
>>     https://git.kernel.org/netdev/net-next/c/7ed2bc80074e
>>   - [net-next,8/9] net: enetc: increase RX ring default size
>>     https://git.kernel.org/netdev/net-next/c/d6a2829e82cf
>>   - [net-next,9/9] net: enetc: add support for XDP_REDIRECT
>>     https://git.kernel.org/netdev/net-next/c/9d2b68cc108d
>>
>> You are awesome, thank you!
>> --
>> Deet-doot-dot, I am a bot.
>> https://korg.docs.kernel.org/patchwork/pwbot.html
>
> Let's play a drinking game, the winner is who doesn't get drunk every
> time Dave merges a 9-patch series with no review in less than two hours
> after it was posted :D

No thanks! I value my liver too much for that ;)

(I was wondering about whether there was some black magic going on here
that I had missed; glad to see it's not just me)

> Now in all seriousness, I'm very much open to receiving feedback
> still.

Good - sent you one comment on the REDIRECT support to start with :)

-Toke

