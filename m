Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B29321C6A
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhBVQI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhBVQH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 11:07:59 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFF5C061574;
        Mon, 22 Feb 2021 08:07:18 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id k13so1922058otn.13;
        Mon, 22 Feb 2021 08:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HQMLiQEqf7rFRpTKzRG90QcYRXwBbpW9ZX/tJUT+9X0=;
        b=Y0x2wx8QXR5uoPzvvIRno7OEU1mrNwjBhAPHTz2Yw2fyDuXajSbDubYnA5jv3TYAf9
         Aa2EEes1if0pi9OZhL5DIdnRulf5I9RInuMYZTNRcx/Gjpp+xStCvOVVJVsQ/ShIz52o
         T0ezfE4e+8Ufz4n6TSrVJrxb5x7KLOer+39vDL/Y4YTFZXlHTDT/22+C0Q0fXn66G+z6
         d312sAS0tZLkZddGB6IzFtU4pQ0KrL4f8MxW+Rcuel1OVpVf/B+FMonsj5Rb5z+XoYYl
         V+RQUV05vBpS/TpcEtYAbOjp87FxFU7dq2GIxz4Dkd3M9pqwcVxyUXh96jCObUZCd99+
         SojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HQMLiQEqf7rFRpTKzRG90QcYRXwBbpW9ZX/tJUT+9X0=;
        b=WX7GnfZBhZR0ckcsfpkuvn+DTP9Yr42TzOrKhmTMuv9AoGz0ZxUN8a8odONirjeXZp
         iKkNbjHG3mkE6avTNJQDufmIPiqSVhjqvOBVLDpVLjqD0z2nkEA+/Gg//Sc4GddB/CDq
         tnmN0HKSP8nqJwf61FrLafO9lMh+Ll9CXfJwO7kHF3QHlUMTfauxwsTTa+UrY1Agi2YK
         W04A8CA4hV9/OFg85O8FrGxuQjowEWkzpt6URXd8iZ25qm0VHDKA/jRkliLunceVq5Yx
         H7M5MU/ElBKgmzTQ2Bmhj77xY7cAU8Xq/W3V9CvOUhphh3Hl6enPvoMxAasqazOUJRkI
         DrUw==
X-Gm-Message-State: AOAM530soCGBSljcUYFJkUfKxvkDp7lvMdNucvdZk/UB43UPwzTDMwDD
        g56V+OEHjFJxuhvhN9x4qR4LhR5uIWU=
X-Google-Smtp-Source: ABdhPJwhtOQderNHNT4rvTl6a59QQESPcB5tPVff2abbwaOXuBtTkrMrveihihrbIk2TFx8DfZDBsw==
X-Received: by 2002:a05:6830:1ac2:: with SMTP id r2mr8289181otc.80.1614010037553;
        Mon, 22 Feb 2021 08:07:17 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:2446:7349:da2b:ae97])
        by smtp.googlemail.com with ESMTPSA id f29sm3619605ook.7.2021.02.22.08.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 08:07:17 -0800 (PST)
Subject: Re: [PATCH] arp: Remove the arp_hh_ops structure
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Yejune Deng <yejune.deng@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
References: <20210222031526.3834-1-yejune.deng@gmail.com>
 <0143f961-7530-3ae9-27f2-f076ea951975@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8de8cee8-55d3-5748-d17e-08dba3cf778d@gmail.com>
Date:   Mon, 22 Feb 2021 09:07:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <0143f961-7530-3ae9-27f2-f076ea951975@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/21 1:37 AM, Eric Dumazet wrote:
> 
> 
> On 2/22/21 4:15 AM, Yejune Deng wrote:
>> The arp_hh_ops structure is similar to the arp_generic_ops structure.
>> but the latter is more general,so remove the arp_hh_ops structure.
>>
>> Fix when took out the neigh->ops assignment:
>> 8.973653] #PF: supervisor read access in kernel mode
>> [    8.975027] #PF: error_code(0x0000) - not-present page
>> [    8.976310] PGD 0 P4D 0
>> [    8.977036] Oops: 0000 [#1] SMP PTI
>> [    8.977973] CPU: 1 PID: 210 Comm: sd-resolve Not tainted 5.11.0-rc7-02046-g4591591ab715 #1
>> [    8.979998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>> [    8.981996] RIP: 0010:neigh_probe (kbuild/src/consumer/net/core/neighbour.c:1009)
>>
> 
> I have a hard time understanding this patch submission.
> 
> This seems a mix of a net-next and net material ?

It is net-next at best.

> 
> 
> 
>> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> If this is a bug fix, we want a Fixes: tag
> 
> This will really help us. Please don't let us guess what is going on.
> 

This patch is a v2. v1 was clearly wrong and not tested; I responded as
such 12 hours before the robot test.
