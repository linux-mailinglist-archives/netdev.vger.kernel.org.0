Return-Path: <netdev+bounces-2903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4470E7047C0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 892992815A6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B0D200D4;
	Tue, 16 May 2023 08:27:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7871F94F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:27:05 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74141BFD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:27:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50b37f3e664so24239662a12.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684225622; x=1686817622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Q/Wa8M+8uvC4yapXeHr/mR9kOO52paWXj/dqyPoiGY=;
        b=QBexmk+DMOo6mdKn5THtfjbOH7Fh/sar7zK4I1M/u/4HUWDtu9v8bKl/3t18wSNBro
         oE12HbynSoEYrSJoElh+Zqa6TVqFxJnUthg+jxikGz9G+0tZm9NG0TzrFjZnaBTsDE3B
         vF0ucHloTC5lpw0cIFX+5JD1aKa8uqbrHr0rXsqjaGdGLkLxFD2z1nqHiT1TrJM5FaJJ
         8U3uLmynbkNmLLlbAV5ZjSote3XXh3ybIrOzP2PTcsCTdgV5QPc7iAJW7oawAOEPBQjQ
         CP5+zR7nyHQ1HenOE+ibGvpdguNwUmSETmCeALgAl0yuFiDU8IS76OZy6cdtEHTYwB+x
         lnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684225622; x=1686817622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Q/Wa8M+8uvC4yapXeHr/mR9kOO52paWXj/dqyPoiGY=;
        b=lMNPZ6cJVG9sGipvy1tbaklMZB8L5NtlkdpvM7UnKusoDnZAVv6ZNeWN/rGjThWRju
         O5UaJqbpA0xO74axYzGGEroQYXsNouJdzJEx9AYGXFP4+zZzDxm4+3zEJGKYk8GOh4cg
         ll7AIBdX2WVUZ/o37Wj5ISHlDB8NZgGvb9gtRdciyJUJcPeiQqlL9OCh+mJJgRTj2dp8
         c3hh/RylZqVnJ8/y6yW0ZgRU+w8me95hFH0cVS5Q9k2KU9Vp/VGiuhI97UksfHqa/KMT
         XSW+4rHRM9zMHkfwvq805HeeqvgVh+twn8pWCB1uvljQlKuLE9OeG/9hz9yxX2Hve7II
         Nvrw==
X-Gm-Message-State: AC+VfDyd4kNt8Ee7cCeJ8uoFPsA8bfx6yDQX4f17kPtzd1PPwth093Pf
	dWyjGxsQj6y1B8s/SWD8PaLz2w==
X-Google-Smtp-Source: ACHHUZ6NlWOJz275z3obUYiEtP8c/TLdPOFJP2OeK1hzxpP/JQGDLY0gdxUlrMuCCjjRzG9IMUV0nA==
X-Received: by 2002:a05:6402:b03:b0:50b:c4a1:c6c0 with SMTP id bm3-20020a0564020b0300b0050bc4a1c6c0mr29560885edb.16.1684225622170;
        Tue, 16 May 2023 01:27:02 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id i12-20020aa7c70c000000b0050bd7267a5csm7900857edq.58.2023.05.16.01.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 01:27:01 -0700 (PDT)
Message-ID: <824ad48b-c419-fd21-1889-23cd94d4b75d@blackwall.org>
Date: Tue, 16 May 2023 11:27:00 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] bridge: Add a sysctl to limit new brides FDB
 entries
Content-Language: en-US
To: Johannes Nixdorf <jnixdorf-oss@avm.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <20230515085046.4457-2-jnixdorf-oss@avm.de>
 <dc8dfe0b-cf22-c4f9-8532-87643a6a9ceb@blackwall.org>
 <ZGIXB2DYA4sal9eW@u-jnixdorf.ads.avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZGIXB2DYA4sal9eW@u-jnixdorf.ads.avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15/05/2023 14:27, Johannes Nixdorf wrote:
> On Mon, May 15, 2023 at 12:35:47PM +0300, Nikolay Aleksandrov wrote:
>> On 15/05/2023 11:50, Johannes Nixdorf wrote:
>>> This is a convenience setting, which allows the administrator to limit
>>> the default limit of FDB entries for all created bridges, instead of
>>> having to set it for each created bridge using the netlink property.
>>>
>>> The setting is network namespace local, and defaults to 0, which means
>>> unlimited, for backwards compatibility reasons.
>>>
>>> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
>>> ---
>>>  net/bridge/br.c         | 83 +++++++++++++++++++++++++++++++++++++++++
>>>  net/bridge/br_device.c  |  4 +-
>>>  net/bridge/br_private.h |  9 +++++
>>>  3 files changed, 95 insertions(+), 1 deletion(-)
>>>
>>
>> The bridge doesn't need private sysctls. Netlink is enough.
>> Nacked-by: Nikolay Aleksandrov <razor@blackwall.org>
> 
> Fair enough.
> 
> I originally included the setting so there is a global setting an
> administrator could toggle instead of having to hunt down each process
> that might create a bridge, and teaching them to create them with an
> FDB limit.
> 
> Does any of the following alternatives sound acceptable to you?:
>  - Having the default limit (instead of the proposed default to unlimited)
>    configurable in Kbuild. This would solve our problem, as we build
>    our kernels ourselves, but I don't know whether putting a limit there
>    would be acceptable for e.g. distributions.

I don't mind, but it would be useless for everyone else. Kernels would be built
without that limit set.

>  - Hardcoding a default limit != 0. I was afraid I'd break someones
>    use-case with far too large bridged networks if I don't default to
>    unlimited, but if you maintainers have a number in mind with which
>    you don't see a problem, I'd be fine with it as well.
> 
> (Sorry for sending this mail twice, I accidentally dropped the list and
> CC on the fist try)


Right, that has been discussed before. So far there hasn't been any good
option, so I'd say for the time being (or unless you have some better idea)
we should stick with the netlink max attribute and distributions/admins
would have to set it on bridge creation. We could add a warning when creating
a bridge without fdb limit to remind people that it's advisable to set it.
That warning can be removed when we come up with a proper solution.

