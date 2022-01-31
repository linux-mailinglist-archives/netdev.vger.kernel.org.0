Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7086E4A4AF8
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379892AbiAaPu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245390AbiAaPu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:50:29 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DF0C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:50:29 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y84so17520144iof.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Spw79LtFUqEtDnUrXcMpMzb4Ayn8shQNWTZSOKxn9yI=;
        b=XOp83OQf4cW5Ps1MkxIPV+fjYZG8140n59Ah7S4rOK1ATO4QTMZX4UZNXWwFH5wsdQ
         FC1NBihgNKlJ5qrLp6JruRl/0aZbLcFJi3wJPGwL7Ac13mwDFdqzrXS/JERC1MSUHnDt
         SzEy4AHlkrYP4GGOr6O8kb9cxuKW2u0GH+K54mjXdrOkDLPusg5rkcvOJAuBOXPzfiVF
         VbJ5GzRkPDj7AfimWLHuvo85Npx5fWlsepR4J9wzri4T9sBSEBlSCuFKIjJz2x23wuxd
         Ul5Jcw9HIHcQJNecHdt9W2h96O9wN2bXwpk8b70sz/ac96DKCUuLbSVASQ9rKIsz+Okv
         WQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Spw79LtFUqEtDnUrXcMpMzb4Ayn8shQNWTZSOKxn9yI=;
        b=4L/TybU6iqz3Jsa6ir7d7nwcroeNQG3S51Gmjf6XQ5TGybRb9bdsalkPG2cRIi3VMB
         v6KVPJdNQuZrowYptr1YnXp9QjxeMfGxcSxl+h6ITQILog0XSSup3A4DsLv96FBx40W8
         FSSBAiVb/B3Jl6+9Qag0GbpkhhVHoAiWB5x7qUaKvm8hPrYa5Jm8D7e/wAmsMaT9ehrw
         v7oKofje5OjSW/e5Zfbc7A+3K6bFsT/RMkKkdZel850HLQNYzLGsitfT+di4Xu451aVE
         9F54YKpriq4jeHhMwh5t28jio8meI3SgrMVla6uDJ4jPf7rUPXcimdaXEpGhcy1R/MB8
         QyJw==
X-Gm-Message-State: AOAM533u4Mad4mOTnV183kW/qIrMARTui3KQuxD3VnP1aTBavFVB/myr
        BPMUiQjvXTTwPxccNL6jTSs=
X-Google-Smtp-Source: ABdhPJzey7dVyoYP7GchrmIU5gMJemFnaXV56WsJi+a51IiQDnq7lbjZVjbuWFcKcKdFmlgNAUU9MQ==
X-Received: by 2002:a05:6638:2484:: with SMTP id x4mr1885505jat.245.1643644228533;
        Mon, 31 Jan 2022 07:50:28 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id g8sm18085700ilc.10.2022.01.31.07.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 07:50:27 -0800 (PST)
Message-ID: <72312384-7b8d-5c14-4e23-ed92be41ff53@gmail.com>
Date:   Mon, 31 Jan 2022 08:50:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local> <Ye7vAmKjAQVEDhyQ@tc2>
 <20220124105016.66e3558c@hermes.local> <Ye8abWbX5TZngvIS@tc2>
 <20220124164354.7be21b1c@hermes.local>
 <848d9baa-76d1-0a60-c9e4-7d59efbc5cbc@mojatatu.com>
 <a7ec49d5-8969-7999-43c4-12247decae9e@gmail.com>
 <78ac271a-7d00-7526-54b5-2aabb5b3a3ba@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <78ac271a-7d00-7526-54b5-2aabb5b3a3ba@mojatatu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/22 5:54 AM, Jamal Hadi Salim wrote:
>>> Do you need a patch for that in some documentation?
>>>
>>
>> How about adding some comments to README.devel?
> 
> 
> Sure - but it wont be sufficient IMO.
> Best course of action is for the maintainers to remind people to run
> tests.

Above, you said the tests were meant for bots.

> 
> BTW: We found out that Stephen's patches still break the latest -next.
> 

ugh. I committed them after running tdc.sh and not seeing a change in
output. We'll need fixup patches then.

Clearly some work is needed on getting the test suite usable by a wider
audience. I am new to running those tests as well and probably had some
pilot errors running them.

I do wait for ACKs from tc folks, but can't wait forever. Right now
there is the 'skip_hw' and 'skip_sw' patch that Victor sent a Tested-by.
When I apply that v2 patch, I see errors in the tdc.sh output so my
mileage varies from Victor's. There is also the v5 of this set which I
have no applied yet; it could use some acks and tdc testing as well.
