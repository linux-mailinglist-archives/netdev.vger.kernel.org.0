Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDECC96BA
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 04:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfJCCe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 22:34:26 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:32974 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfJCCeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 22:34:25 -0400
Received: by mail-io1-f65.google.com with SMTP id z19so2115743ior.0
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 19:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7KasjAOsUmvtgdRLEuqxKGaAkvxihLuuVFRLHF9qhmU=;
        b=PxyQFb7W+0gc5DBx6IACmU0RSARxE3BZsU/2O3yUz5rBd2RFx5MRPCOdJ4LqMCz5Kc
         Dacy0/+hTvO2J7mMh5zNjHb8I0KHESFOXmc4nfTaBjirCizf6wBf9/73DA1Qlu2khppa
         1ZszjjtBeUL1ick2F5XLHRjBTb2Kh9RKRZ7lyOO1x5k0JEwj5oKdxx+IgWy0KEwMlTz0
         1FUB3nlzL9aeMFpODZtV5KNFcVzuq/4cInXkSSS9D4SL5tHV9Ps/Nj9HojK6EfwC2GhJ
         2YBNjrkjyCQ52oeRtE9bBeJIb4fE788p1SGi8dIGb0T/rrNa2i0g2pAKa+ioW0AhXHwz
         Mgug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7KasjAOsUmvtgdRLEuqxKGaAkvxihLuuVFRLHF9qhmU=;
        b=Uz4DNJuzCxy+0y9ywaPC33BSG+ABuiJrFOjoEzOoEldIH/oBeYXdSaHJNMmEtdBWOM
         nG+0dPiJ0AwhjHYHS746OYhk8Y0ddtu+MDcZoeXAAT3S43oIh/JhiDHKNBlinFgqxuV6
         XoyoHcMAfW2f/o2a0KJVdvzy07nEy1moK0DAswsNV69eSv0Jg6JTNdPlqOwRCPJaafln
         VEH2HOuJCYippNTsnEODDDuxaVf37ziZYVC+asjpq77ALHGfvIeMUQ7euQuddpDokGlh
         33KkMxVPVZvqGzuRlvnz3PbUuYSZELc5TXfwF3UYntVnxfXtP7WO3i5mxm2/J+LlNKqu
         +Yhw==
X-Gm-Message-State: APjAAAVHf6I+J6dQcl7ZwjtaTv6NLMWo/VydScW0Jgi4gogDDnVgjpI4
        X4hFrhSxqN0AHrMVHDReF94=
X-Google-Smtp-Source: APXvYqw2/eYaLwQ59ghCq8cGW6m0yj79XjlovH7BJsw944LngabbOB27l2PLJ5IwtIwuNyFY+4Y3uw==
X-Received: by 2002:a5e:c641:: with SMTP id s1mr6273929ioo.308.1570070065208;
        Wed, 02 Oct 2019 19:34:25 -0700 (PDT)
Received: from [172.16.99.106] (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id d9sm452509ioq.9.2019.10.02.19.34.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 19:34:23 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
To:     Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
Date:   Wed, 2 Oct 2019 20:34:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191002182119.GF2279@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 12:21 PM, Jiri Pirko wrote:
>>> This patch adds an "in hardware" indication to IPv4 routes, so that
>>> users will have better visibility into the offload process. In the
>>> future IPv6 will be extended with this indication as well.
>>>
>>> 'struct fib_alias' is extended with a new field that indicates if
>>> the route resides in hardware or not. Note that the new field is added
>>> in the 6 bytes hole and therefore the struct still fits in a single
>>> cache line [1].
>>>
>>> Capable drivers are expected to invoke fib_alias_in_hw_{set,clear}()
>>> with the route's key in order to set / clear the "in hardware
>>> indication".
>>>
>>> The new indication is dumped to user space via a new flag (i.e.,
>>> 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
>>>
>>
>> nice series Ido. why not call this RTM_F_OFFLOAD to keep it consistent
>> with the nexthop offload indication ?.
> 
> See the second paragraph of this description.

I read it multiple times. It does not explain why RTM_F_OFFLOAD is not
used. Unless there is good reason RTM_F_OFFLOAD should be the name for
consistency with all of the other OFFLOAD flags. I realize rtm_flags is
overloaded and the lower 8 bits contains RTNH_F flags, but that can be
managed with good documentation - that RTNH_F is for the nexthop and
RTM_F is for the prefix.
