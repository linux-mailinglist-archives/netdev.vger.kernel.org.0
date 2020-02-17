Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9D1619A3
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgBQSSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:18:02 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43317 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgBQSSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:18:02 -0500
Received: by mail-qt1-f195.google.com with SMTP id d18so12675505qtj.10;
        Mon, 17 Feb 2020 10:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SOcf8TuKJ88k2p/O21+wCb6aXk50+NW/MesqUsVcIbE=;
        b=Q7zrkAyEyl/8DtSY2WR7zOCW8m/nRmB+x/ePE2y0Dt/9g+xyKUI9DYnUPsER1XhcJD
         +/RjtjlPa+uJhT6RjAQ4372uxf0oUQ8shaIKQ6SKIYa65S4w/u2h7yIu5xNgczZeFTuT
         uD8quXbAgmvuI2laQ1R4CaRLGeXMJJsEDiRJhI0DK4t9Abl4Biv2lkvsg1d1kknNLuVc
         1zusGWLz5BdMs24jxAQdeiCXpnlNzIT/2vr09twfZ5IvKkbGHML0C6orDd0XMfHYj3fV
         FEpr1X9NAWzaxsOqGys4t2uzaGGPkcs5BVFAyojcof1XkaCg61I0mGZVqXdsA93aM2YV
         ++Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SOcf8TuKJ88k2p/O21+wCb6aXk50+NW/MesqUsVcIbE=;
        b=lRYH92xnsilhynM5TZH7HFoDQRY1SNvHiXV2Tul/mqGxYmfylXvfiMHMwNrxG17xvx
         kvp4ZGPe+tgqbZRGw2S+VkWzmWsSx9a45sdWc2JIo4Fh6OcdArLSZSY+V+Qxm5yINYYS
         v3U5VSbxNrNZKAbIQsd5RntaGdto85G/Z0sx66vayf1NPidM8gODCZxLXO3OWM4qGIg8
         wDQ/RmKYNUIYhWiBef+hGv53bgJfCo4OtIhLuAKbhI4X6gCk3GsCKHkedLNDMMVMMSQW
         dLdB2jfrFt1q6F74IG6V5QpSw9LJzlnIS5MhMEDTiBno/ir5IFNzb33pKL8mWL+En14u
         EQ8g==
X-Gm-Message-State: APjAAAUeYwM6MHC72g8cYMLeClW24JkA9oLRxZpHVapOSuU4r3rj4Y4D
        4Zy9vkJ+FyR7H3pYM2to9UFAEL89
X-Google-Smtp-Source: APXvYqwQGxsckCpI+nKuMkd3dne4GSOPW5AngfJ1jBDnoPJbBO8Nd+O1M07WvE3DI3Wf8GK6xRaSiA==
X-Received: by 2002:ac8:f7d:: with SMTP id l58mr7091qtk.50.1581963479501;
        Mon, 17 Feb 2020 10:17:59 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:65d1:a3b2:d15f:79af? ([2601:282:803:7700:65d1:a3b2:d15f:79af])
        by smtp.googlemail.com with ESMTPSA id 139sm618053qkg.79.2020.02.17.10.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 10:17:58 -0800 (PST)
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
 <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
 <20200217111718.2c9ab08a@carbon>
 <20200217102550.GB3080@localhost.localdomain>
 <20200217113209.2dab7f71@carbon> <20200217130515.GE32734@lunn.ch>
 <20200217155139.6363aa52@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ce801d5b-f86d-76e3-5faa-a10dac373f2c@gmail.com>
Date:   Mon, 17 Feb 2020 11:17:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200217155139.6363aa52@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/20 7:51 AM, Jesper Dangaard Brouer wrote:
> On Mon, 17 Feb 2020 14:05:15 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>> On Mon, Feb 17, 2020 at 11:32:09AM +0100, Jesper Dangaard Brouer wrote:
>>> On Mon, 17 Feb 2020 11:25:50 +0100
>>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>>>   
> [...]
>>>>
>>>> yes, I think it is definitely better. So to follow up:
>>>> - rename current "xdp_tx" counter in "xdp_xmit" and increment it for
>>>>   XDP_TX verdict and for ndo_xdp_xmit
>>>> - introduce a new "xdp_tx" counter only for XDP_TX verdict.
>>>>
>>>> If we agree I can post a follow-up patch.  
>>>
>>> I agree, that sounds like an improvement to this patchset.
>>>
>>>
>>> I suspect David Ahern have some opinions about more general stats for
>>> XDP, but that it is a more general discussion, that it outside this
>>> patchset, but we should also have that discussion.  
>>
>> Hi Jesper
>>
>> I've not been following XDP too much, but xdp_xmit seems pretty
>> generic. It would be nice if all drivers used the same statistics
>> names. Less user confusion that way. So why is this outside of the
>> discussion?

Hi Andrew: I brought this up over a year ago - the need for some
consistency in XDP stats (names and meaning) across drivers:

https://lore.kernel.org/netdev/1d9a6548-4d1d-6624-e808-6ab0460a8655@gmail.com/

I don't have strong preferences on which driver is right in the current
naming, only that we have consistency. There has not been much progress
in the past 15 months, so I am glad to see someone take this on.

> 
> I do want to have this discussion, please.
> 
> I had hoped this patchset sparked this that discussion... maybe we can
> have it despite this patchset already got applied?
> 
> My only request is that, if we don't revert, we fixup the "xdp_tx"
> counter name.  It would make it easier for us[1] if we can keep them
> applied, as we are preparing (asciinema) demos for [1].

Jesper: what about the mlx5 naming scheme:

     rx_xdp_drop: 86468350180
     rx_xdp_redirect: 18860584
     rx_xdp_tx_xmit: 0

The rx prefix shows the xdp action is in the Rx path, and then the Tx
path has tx_xdp_xmit.

i40e seems to have something similar for the Rx path:
     rx-0.xdp.pass: 0
     rx-0.xdp.drop: 0
     rx-0.xdp.tx: 0
     rx-0.xdp.unknown: 0
     rx-0.xdp.redirect: 0
     rx-0.xdp.redirect_fail: 0

I don't see any Tx stats for xdp, but this is an older kernel so not
sure what 5.x has.

Looks like sfc has a similar naming scheme:
     rx_xdp_drops: 0
     rx_xdp_bad_drops: 0
     rx_xdp_tx: 0
     rx_xdp_redirect: 0

So if mvneta follows these 3, the names just need rx_ prepended.
