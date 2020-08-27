Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00F32543AD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgH0KZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgH0KZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:25:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B321BC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 03:25:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x9so4628280wmi.2
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 03:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vXTWLsJBole/p2haj9af1GwFx/JtWTMkjr5gEQjk11w=;
        b=MGNJmLrBpH9cs8HoV3LeRRhwouKzuSJaP/EgnIQrzNibbGrOvVU9Xe0p/yX4y4Igen
         jJTsoyGVZoXpnOaOhcaQ1R/6tpzIy+q93a48IXa6GFXyYw6E7LOIsUT8JKdYbDhqEq9M
         er3/tstwZ1TZlYJIgRlaFoZiGwCdQPX0frVf6Rt5rQuoIGUBmQmQbTIlD+rFaExW7Jgc
         Kadabo6fF5JXNVspjaVM8ovkaw7/OD3zMD1aYAThKQOgMAvrV0zHFEllJ6zQYy+CaN2K
         60JUYqY89sTnG5gRSFMevZcGnh+UUA9bzxsfUgZx8gXjLoXX4fJj03HJgRyDwQsR8PXI
         OoOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vXTWLsJBole/p2haj9af1GwFx/JtWTMkjr5gEQjk11w=;
        b=X4Hh/mc1BYtcx+NFpQ6gi0KWBmRD/DJIu/V5FiJiUHWHpvXHLSzFOLkvWJv9oyqHYM
         0rYIoTG6Y0BmoZQ/k9xNtAMQwtLguRPTjdNjV21ZkHFtp7hOWf+VvevbIVEWzeYz7HdC
         2ATgaDrHBdioGdpujnedXV0ajwjsKmtnMVwWn0Q7Jeez9cjbPyfmWKwupBdwlgqGB96j
         syjaFX6Z0vD+44X7wHVaRj6WVQuqZ3kszm2i9gWY31k6Um7G5JHtd4PzD5UCNQv/IZMl
         6b3ELLfCyiHBF5cq6hB7AvEaE/rWxZMrrS9BrBEqBg/LLOMS2oAro/jQ7+wvZWIpm7bL
         GgHg==
X-Gm-Message-State: AOAM530Q/gDxx1EfTzuNlA1JsX/IX7dsbXvxRxfM98tPQuTva+hGWWIc
        0KWfsFBGwJmqpU6Uh3Gk2WtG8UYsCEAmsg==
X-Google-Smtp-Source: ABdhPJyed+/ioB8CHP7jcjwVHc3rDi496Q08ZFZRLTjt/pDjofTx4yqhUlKSGGwJktLPXdMh/6+xjg==
X-Received: by 2002:a7b:c317:: with SMTP id k23mr10539605wmj.167.1598523948764;
        Thu, 27 Aug 2020 03:25:48 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:590d:8a36:840b:ee6c? ([2a01:e0a:410:bb00:590d:8a36:840b:ee6c])
        by smtp.gmail.com with ESMTPSA id j24sm5578213wrb.49.2020.08.27.03.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 03:25:48 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2] gtp: add notification mechanism
To:     Harald Welte <laforge@gnumonks.org>
Cc:     netdev@vger.kernel.org, osmocom-net-gprs@lists.osmocom.org,
        Gabriel Ganne <gabriel.ganne@6wind.com>, kuba@kernel.org,
        davem@davemloft.net, pablo@netfilter.org
References: <20200825143556.23766-1-nicolas.dichtel@6wind.com>
 <20200825155715.24006-1-nicolas.dichtel@6wind.com>
 <20200825170109.GH3822842@nataraja>
 <bd834ad7-b06e-69f0-40a6-5f4a21a1eba2@6wind.com>
 <20200826185202.GZ3739@nataraja>
 <0e2c4c04-a6dc-d081-2bdd-09f8d78607c4@6wind.com>
 <20200827090026.GK130874@nataraja>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <784761a0-a01d-a05b-e624-40c13f9a5771@6wind.com>
Date:   Thu, 27 Aug 2020 12:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827090026.GK130874@nataraja>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

Le 27/08/2020 à 11:00, Harald Welte a écrit :
> Hi Nicolas,
> 
> On Thu, Aug 27, 2020 at 12:36:24AM +0200, Nicolas Dichtel wrote:
>> Le 26/08/2020 à 20:52, Harald Welte a écrit :
> 
>>> Wouldn't it make sense to only allocate + fill those messages if we
>>> actually knew a subscriber existed?
>>
>> In fact, this is actually how the netlink framework works.
> 
> Well, as you can tell from my responses, I've not been doing kernel work
> for a decade now, so I'm looking at things from a more distant and
> ignorant perspective.  To me it seems odd to allocate memory and copy
> data to it (cache misses, ...) if nobody every requested that data, and
> nobody will ever use it.  But if this is how it is supposed to work,
> then I will of course defer to that.  All netlink would have to expose
> is a function that returns whether or not there are any subscribers
> to the given multicast group.  Then all of the allocation +
> initialization would disappear in a branch that is not executed most of
> the time, at least for current, existing gtpnl systems.  Yes, that means
> one more branch, of course.  But that branch will happen later on
> anyway, event today: Only after the allocation + initialization.
I agree, but I didn't find a good solution for this right now. The lookup is not
straight forward.

> 
> So having said the above, if this is how it is supposed to work with
> netlink:
> 
> Acked-by: Harald Welte <laforge@gnumonks.org>
> 
Thank you.
