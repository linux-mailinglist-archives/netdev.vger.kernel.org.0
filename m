Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0296B28AA26
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 22:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgJKUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 16:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgJKUTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 16:19:05 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EE6C0613CE;
        Sun, 11 Oct 2020 13:19:05 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so14780037eds.6;
        Sun, 11 Oct 2020 13:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v4MsclsAjBQ07tS6Y2k6AL+A2oNnHE0z2Kb1St2ZEIk=;
        b=neCttq4/0J3+3NTrhanFCgR56+zz6hfDnAOzM1dINwDLIuAqA3tMADIrgI6aUb+zAi
         +eW84mbUHzG1mA5KER0AFuvgMSlGeNFlSeYUrjL3m0dJOszx4WBDI7kWKXISNlENJhPD
         050WWxG7qW9dQuQpk2PmuXO+528K82e7K89uJXuvnEVnilQvnYJVi757k2QQYxh4CVa5
         Ed4GZZNn1vn+kv1i5dFESGPhlygVY4oDvkiD0PyxkFWDbCeb3YrRkppBbbm0d5WR0fxd
         tkkajfw+0ba0e9Nb5KjCCcTqY9wUM/LHdfNPLudLcRYIk6kS1/Eq5VLz1CoqDWXm0BU7
         Hy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v4MsclsAjBQ07tS6Y2k6AL+A2oNnHE0z2Kb1St2ZEIk=;
        b=trTzE1LmGNkvCypiEmBtvOENyg2rmSNX8QaQ8pqO0Mf7QiPSd/uNFbF5tK2UBCU/XE
         LpnUVfA7NTsA2+bhyo84KKCMGI/DbDK6wWPQryvdh1EZKo6x+iw/G+67tyFVN76LQGRt
         BqrCjiu95k9OHty6PQVzwBaMPBCD6yMF0mN1ZXVlTgVDiENfhDBWhKN1AsgVvRBzHzdu
         lvQLkK8CGsnxnjrCZFJpLxOkk1kEwzE2v4C8fo/snFnfv+xqr4CuShqJ6qnJaEu9mbTc
         8cM1rCKgpNT1+ZWWItuC4oS7MVxAfoql31+IYAaZtZchG/j4fxujwXcPBaAIHN9KIbkB
         5FOw==
X-Gm-Message-State: AOAM53205Y3oDDv0oguZ4t6nKvcJIuY4OyuzB084L5PnrjwGpWQX4MHR
        IcZSCajWAkKw21j8UP57Xl8=
X-Google-Smtp-Source: ABdhPJzdFiYdZKEVK13ixfB6IsshtIGvkXhMrrs+wlxjwrdUKK04SccKxJeGGB6X2gkUtDB6t4LhNg==
X-Received: by 2002:aa7:c98f:: with SMTP id c15mr10791684edt.200.1602447543892;
        Sun, 11 Oct 2020 13:19:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id l17sm9690345eji.14.2020.10.11.13.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 13:19:03 -0700 (PDT)
Subject: Re: [PATCH net-next 01/12] net: core: add function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
 <5bb71143-0dac-c413-7e97-50eed8a57862@gmail.com>
 <20201011125412.3719926a@hermes.local>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0a127353-4358-9664-6784-dec2c48e9b9d@gmail.com>
Date:   Sun, 11 Oct 2020 22:18:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201011125412.3719926a@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.10.2020 21:54, Stephen Hemminger wrote:
> On Sun, 11 Oct 2020 21:36:43 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> +void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
>> +			   struct pcpu_sw_netstats __percpu *netstats)
> 
> netstats is unmodified, should it be const?
> 
>> +{
>> +	int cpu;
>> +
>> +	if (IS_ERR_OR_NULL(netstats))
>> +		return;
> 
> Any code calling this with a null pointer is broken/buggy, please don't
> ignore that.
> 
Thanks, I'll consider both points in a v2.
