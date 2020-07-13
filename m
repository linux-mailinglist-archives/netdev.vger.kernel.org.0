Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD1B21E1FB
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGMVUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgGMVUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:20:08 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFD6C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 14:20:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g75so1463260wme.5
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 14:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a59aUXCAB+LV+EKJ5CJnnsTyTeBIVtWXfFDQmrllEZg=;
        b=j7E+BTK81RVmFJA5whgac7TGPbDzI7j4jBMtgW3xmRIV1dUO/NAJHxMJZxc9YwTq0B
         qoiSviQCjDJ3PFUa3mixASPkkzOYiiDLUeyrQy3K9URxEZy7PXQKn1N0HULzksn1gkNY
         MamAlL4N1C6v29uyBXiSJsDR8hqqEeUJqNz74rk4kgHdOWDFLrOWG9OepXwNBjYFLkCc
         cwDSYOroSr7wGj7klgEYR9anoYRciVyJg1bnCUWkAndUu6jLKw2ZnI/06dUWfDpKPipF
         2EjKYhl29+YGpQYdNgBet1Nm2vhHe5I+G9u3GKQi6jgKi6Rj0mnWsOaF0cZmNOCqZe86
         MQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a59aUXCAB+LV+EKJ5CJnnsTyTeBIVtWXfFDQmrllEZg=;
        b=ZFXOew6/mGHkmigN3b4opJpBKrhT7k71YzisevSvhIIGbxfcndKKmZCyCAcJ181+Rd
         nXA+LBR3VjUbtmTODGQe7A8av8Z+HvXTe8RrY9UvuTxSrFYypa0a+AGyijJf0Vkg3BMm
         sFnPj7uwKfpB1AqWmRtaH7aNhmtGNRirFydRm8TKj3zp0JpEwPACq0t3/IUU9euL94k4
         1gvkfXSKlFDey2ErgU08IK/eJnLx4VKBq+41RAiwvLCpt0FwovdGxijn1lfl3eGHbqK0
         Xbo609yjjXKfKL7ARhgihd0qriir5daq160SdV++bF8w0E/qUKijQ5UzY93t4JPuLamQ
         2Ksw==
X-Gm-Message-State: AOAM531pWyVx8X31sOVrN7LshWT7YWQnlai+WEIGQ28u2mut1QMPPmyP
        EoRgwzcJoN/VO2gjgUo1/wYVlh3F
X-Google-Smtp-Source: ABdhPJwmW34x2etR5ybcjGAK+XP20bzBnkFXwvJYw1y/XzCrxAchfgNluEhn6yHnolJv+KmH+vxDMQ==
X-Received: by 2002:a05:600c:21ca:: with SMTP id x10mr1210574wmj.63.1594675206074;
        Mon, 13 Jul 2020 14:20:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q1sm25488837wro.82.2020.07.13.14.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:20:05 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: Preserve netdev_ops equality tests
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        mkubecek@suse.cz, davem@davemloft.net
References: <20200712221625.287763-1-f.fainelli@gmail.com>
 <20200713130929.0fc74fa1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <22f861f0-39f0-8c26-6571-d10903f53297@gmail.com>
Date:   Mon, 13 Jul 2020 14:20:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713130929.0fc74fa1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2020 1:09 PM, Jakub Kicinski wrote:
> On Sun, 12 Jul 2020 15:16:22 -0700 Florian Fainelli wrote:
>> Hi David, Jakub,
>>
>> This patch series addresses a long standing with no known impact today
>> with the overloading of netdev_ops done by the DSA layer.
> 
> Do you plan to make use of this comparison? Or trying to protect the
> MAC driver from misbehaving because it's unaware the DSA may replace
> its ops? For non-DSA experts I think it may be worth stating :)

We have at least one network device driver that is always used in a DSA
set-up (bcmsysport.c) which does check DSA notifiers against its own
netdev_ops, however this happens before the mangling of DSA netdev_ops
is done, so the check is not defeated there.

> 
>> First we introduce a ndo_equal netdev_ops function pointer, then we have
>> DSA utilize it, and finally all in tree users are converted to using
>> either netdev_ops_equal() or __netdev_ops_equal() (for const struct
>> net_device reference).
> 
> The experience with TCP ULPs made me dislike hijacking ops :( 
> Maybe it's just my limited capability to comprehend complex systems
> but the moment there is more than one entity that tries to insert
> itself as a proxy, ordering etc. gets quite hairy.. Perhaps we 
> have some well understood rules for ndo replacement but if that's not
> the case I prefer the interception to be done explicitly in the caller.
> (e.g. add separate dsa_ops to struct net_device and call that prior to/
> /instead of calling the ndo).
> 
> At the very least I'd think it's better to create an explicit hierarchy
> of the ops by linking them (add "const struct net_device_ops *base_ops"
> to ndos) rather than one-off callback for comparisons.

Initially I was going to introduce a way to do recursive operations, but
the problem with that approach is that you need to impose an ordering
within the core about how operations are invoked.

The idea to add dsa_ops as a singleton that DSA would provide (very much
like the recent ethtool_phy_ops introduction) is probably the sanest
approach.

Thanks for the suggestions and review Jakub!
-- 
Florian
