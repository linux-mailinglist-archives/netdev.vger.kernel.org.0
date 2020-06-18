Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437F81FFE48
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgFRWpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgFRWpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:45:25 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22531C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:45:25 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id v11so3604363pgb.6
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ifGBlIEmCS49skqnyWvqGInSwOj97Hh1ZN3UY4qHJl0=;
        b=YUldrY2801mItxwtQjTWylooGb6KWuZ2Eq7pE+LbzaEbjfJr4Eo/ScPdK68sbsEszp
         pVq+KwTrF6u77nffILV4peQAn+60eAVnmTxSIJgUDCzWJ3iHUxu3B/Fc5Hghq5ohhMsO
         9yWa6j8DxTCHqmEAskWwxS8CKlKAOeIKRU12CipauMewdPfYHtcxzN0EnvXOs9Q07Hww
         Zanhh3Ed9QllFbFrLPOwBYtmYH1r5xelmPA0YdqnZB2+T6nmEUhJFCQ1mlJDCpumQxGt
         LOHz+tL5KPxpSqd0GyGzj4jAuy85ZYjqbLLjjc0r7D8tw9R/v2XlWH+NngOzFrXHkOYj
         /vIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ifGBlIEmCS49skqnyWvqGInSwOj97Hh1ZN3UY4qHJl0=;
        b=SJOPq98k3vTFpUbL7pmAc7uyH1bimWZ/A3YAvnCbJSlgjX0DoMLVbb9P9KdDJD7iMe
         gzJchrnKHkDDWNEs+ZMd7g2tYu3BC/sQT7CuSwA5a+zVXRgmVbEwl0T5Sw/fPkN5mgVD
         aQAr/4A2cw/EicZXqFhwC1SbD5K7HfuKTkj42c5VZCUKc5X33HMhHjYNm2Ufc9NBjW+5
         w3HzSSPIDlfmj8VR85m0kNVqrp+hfn9GJ9Kg1YALlaZ4KrCm548OAOjIB53yKMSspxMG
         6izQJfp0JR31M4ZEQndOUP8vuvj3TkTke3tU4iRwJDJUa6JfvTfwHESRJA1UrlkxdJht
         a44w==
X-Gm-Message-State: AOAM5306oucjoE+NuKDHcmcm8lQ92FNouIvHy9yYimIErGvNDA1xbqOi
        uHUfmdA24fkG0EjAx/WseDM=
X-Google-Smtp-Source: ABdhPJzUtPyxWY2y3vumNshjfiYlF9Q2qXwkF7Jw+nmr3Gv4ILN42E/qCZXfyJur8kev+MWyuIunUw==
X-Received: by 2002:a62:3183:: with SMTP id x125mr5544234pfx.3.1592520324676;
        Thu, 18 Jun 2020 15:45:24 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d7sm3878746pfh.78.2020.06.18.15.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 15:45:23 -0700 (PDT)
Subject: Re: [RFC PATCH 06/21] mlx5: add header_split flag
To:     Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        kernel-team@fb.com, axboe@kernel.dk,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
 <20200618160941.879717-7-jonathan.lemon@gmail.com>
 <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
 <20200618202526.zcbuzzxtln2ljawn@lion.mk-sys.cz>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ba7f6c19-989a-c5af-6ca7-12614680af59@gmail.com>
Date:   Thu, 18 Jun 2020 15:45:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200618202526.zcbuzzxtln2ljawn@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 1:25 PM, Michal Kubecek wrote:
> On Thu, Jun 18, 2020 at 11:12:57AM -0700, Eric Dumazet wrote:
>> On 6/18/20 9:09 AM, Jonathan Lemon wrote:
>>> Adds a "rx_hd_split" private flag parameter to ethtool.
>>>
>>> This enables header splitting, and sets up the fragment mappings.
>>> The feature is currently only enabled for netgpu channels.
>>
>> We are using a similar idea (pseudo header split) to implement 4096+(headers) MTU at Google,
>> to enable TCP RX zerocopy on x86.
>>
>> Patch for mlx4 has not been sent upstream yet.
>>
>> For mlx4, we are using a single buffer of 128*(number_of_slots_per_RX_RING),
>> and 86 bytes for the first frag, so that the payload exactly fits a 4096 bytes page.
>>
>> (In our case, most of our data TCP packets only have 12 bytes of TCP options)
>>
>> I suggest that instead of a flag, you use a tunable, that can be set by ethtool,
>> so that the exact number of bytes can be tuned, instead of hard coded in the driver.
> 
> I fully agree that such generic parameter would be a better solution
> than a private flag. But I have my doubts about adding more tunables.
> The point is that the concept of tunables looks like a workaround for
> the lack of extensibility of the ioctl interface where the space for
> adding new parameters to existing subcommands was limited (or none).
> 
> With netlink, adding new parameters is much easier and as only three
> tunables were added in 6 years (or four with your proposal), we don't
> have to worry about having too many different attributes (current code
> isn't even designed to scale well to many tunables).
> 
> This new header split parameter could IMHO be naturally put together
> with rx-copybreak and tx-copybreak and possibly any future parameters
> to control how packet contents is passed between NIC/driver and
> networking stack.

This is what I suggested, maybe this was not clear.

Currently known tunables are :

enum tunable_id {
	ETHTOOL_ID_UNSPEC,
	ETHTOOL_RX_COPYBREAK,
	ETHTOOL_TX_COPYBREAK,
	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
	/*
	 * Add your fresh new tunable attribute above and remember to update
	 * tunable_strings[] in net/core/ethtool.c
	 */
	__ETHTOOL_TUNABLE_COUNT,
};

Ie add a new ETHTOOL_RX_HEADER_SPLIT value.


Or maybe I am misunderstanding your point.

> 
>> (Patch for the counter part of [1] was resent 10 days ago on netdev@ by Govindarajulu Varadarajan)
>> (Not sure if this has been merged yet)
> 
> Not yet, I want to take another look in the rest of this week.
> 
> Michal
> 
>> [1]
>>
>> commit f0db9b073415848709dd59a6394969882f517da9
>> Author: Govindarajulu Varadarajan <_govind@gmx.com>
>> Date:   Wed Sep 3 03:17:20 2014 +0530
>>
>>     ethtool: Add generic options for tunables
>>     
>>     This patch adds new ethtool cmd, ETHTOOL_GTUNABLE & ETHTOOL_STUNABLE for getting
>>     tunable values from driver.
>>     
>>     Add get_tunable and set_tunable to ethtool_ops. Driver implements these
>>     functions for getting/setting tunable value.
>>     
>>     Signed-off-by: Govindarajulu Varadarajan <_govind@gmx.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
