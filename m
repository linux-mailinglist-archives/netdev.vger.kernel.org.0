Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EB22B8394
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgKRSEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKRSEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:04:52 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF65C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:04:52 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id r9so2976290ioo.7
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EYbIc0bx6KawQTbjukp0zhf42kppKq6tBuivLh8ljys=;
        b=qv3w44v1jflbM5MVlGFyaax4gpD+2Cio80ZI1qgEyS5v38YUp0di5dSkXOctEuYoiZ
         nqCwU+JcmFWwzmEn1ibWkpwPCB1ONvi4vQ1QtDfjcpEmANCgATU68YmiRyRTULH+kGul
         /GKXC8psfPwviKcJdCfBodMCZqP+45s8VUXbkWIY1gS+hlXj6y88Grj/jwVu8ZtKz1Mr
         oqC637vBjSEGrwZG99pboNXLtL1qONyhjybQ15O6UDDp7q4sh8+o45tPceA/xfk2YyOZ
         l/ej7wTeQH1Sj3mmkHEKo4E/9kRiEfeWaGBzR5CPk2oJefqEUKR9ZCzdTDfoX3x0QK33
         y87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EYbIc0bx6KawQTbjukp0zhf42kppKq6tBuivLh8ljys=;
        b=BommVmk6/3f97566PJZSsjUGIRlqBHyT8rUCUanKUFc0gOwLpLYwS52zgaaF3GCeeb
         TIrubfVLHR3RbxTUsaJfapneJvKeX6IL5x/162BWXhfRU/HsR/mCdE7X5LFPO5hwf9Yx
         4xIhlvS+1MLL0wEVn1vGboptCOm3db4FJcyz7JnbNmIwEtZDBfuwK2FlVVs6DQE0DsZ9
         dxEp4ADNbT/C2LsWHCvkvLyFdZCwavoMtttHS9UBSh4ey4yhaKxp06b5QRTxQ9MjzYEH
         R9ySaCxC/2JybS6CttIi/xW9F+it0L6XYs3oGkdqXpW445oo7HpPOck9k5Y7saeB/Wyv
         6QXQ==
X-Gm-Message-State: AOAM5326xGaHfULnw25P4tfltV7XhM8gfSeu1hVYvA/mlf+hNKLeh3wq
        eGCigi3KmyxtAtdiLmb2yOY=
X-Google-Smtp-Source: ABdhPJwN53K9Z87nL8GdCraNynJTBlPPRmoPsCBqwiv4AuJZ2IZasyq9cKoZcRds7POOeofP+WoyCQ==
X-Received: by 2002:a6b:8bcf:: with SMTP id n198mr15912100iod.122.1605722691663;
        Wed, 18 Nov 2020 10:04:51 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:cd3a:ec11:4d4f:e8d8])
        by smtp.googlemail.com with ESMTPSA id c3sm16299621ila.47.2020.11.18.10.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 10:04:50 -0800 (PST)
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>,
        nicolas.dichtel@6wind.com
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan>
 <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
 <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com>
 <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
 <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7b3f1d07-eca4-b012-c46a-e1f09bba9d6f@gmail.com>
Date:   Wed, 18 Nov 2020 11:04:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 10:39 AM, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Wed, Nov 18, 2020 at 8:58 AM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 18/11/2020 à 02:12, David Ahern a écrit :
>> [snip]
>>> If there is no harm in just creating lo in the up state, why not just do
>>> it vs relying on a sysctl? It only affects 'local' networking so no real
>>> impact to containers that do not do networking (ie., packets can't
>>> escape). Linux has a lot of sysctl options; is this one really needed?
>>>
> I started with that approach but then I was informed about these
> containers that disable networking all together including loopback.
> Also bringing up by default would break backward compatibility hence
> resorted to sysctl.
>> +1
>>
>> And thus, it will benefit to everybody.
> 
> Well, it benefits everyone who uses networking (most of us) inside
> netns but would create problems for workloads that create netns to
> disable networking. One can always disable it after creating the netns
> but that would mean change in the workflow and it could be viewed as
> regression.
> 

Then perhaps the relevant sysctl -- or maybe netns attribute -- is
whether to create a loopback device at all.
