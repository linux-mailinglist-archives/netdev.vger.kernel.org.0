Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B76168175B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbjA3RNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbjA3RNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:13:51 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0E98A71
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:13:50 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5063029246dso168749937b3.6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lixSC76vyPNWSyhVLFBh/ba2LGNduxP95qqNS4cziqg=;
        b=l2DuZ8IPOz3WKC8x/hEovmx2OTRDtFWHDwnCyMb9LbsvaVgp7uFWraxk04iiA69KFI
         yh56oFhhyI1IOH4ozNHTwTEdde9ntYek7yMMD37sjL0C+YHsidcwYPSHWdCDfb28QAQa
         my+867HigOUNmE7Aj70gBJVtS60ufEkBzuxLpz52CqFi7A+M23KdE8Q33Gd1fEQdw0cU
         GUXRgaPMcDOVmacxPIrMrBHMQ7FyRgBZa87faaUYcGrm1/dDg1Sl326fuwSZvuJFltEX
         dp/2XObC9pYKOzAg7J2RHfgxultRJr5S8OCf0XpPUrZuqJ4v1C3QhE3GTSuBBE1jcJNA
         b1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lixSC76vyPNWSyhVLFBh/ba2LGNduxP95qqNS4cziqg=;
        b=qEEMKlyVaUU3T4QIXslEnLT+gGq8Zh50w+k7smVCjh2+CCIr2FxNOYLJFmFaDhNoCD
         HT9mxbkklBnAn8mEU+9iQL74jVrLmn0CRiplpTcFPQjQEbj05D46Geh53ScL6lkuzZ8f
         MSQSgXOXg19iFD/2HWHO3w2lypasuM79F02GiY79QPh3lVmKhzOEbWEelUFn+TlC6RMs
         w8llSlcf41KtbyPOATtGnGkYvFlKDd6zIbMTnbZLLbTvuRmmzOI5m3jh3EU7m7WfigwR
         DtERDmnHIysC5gUoUzxXEjnLV8CpyyTVJn2w/ehNv0ku76XxYk6qkVhuWTJ2ASlMadMQ
         jPJw==
X-Gm-Message-State: AO0yUKU5fl9n2oL1r1R6F3c/nJDw1kA4Ct350i8InZMmSK0hOsRVSQYu
        GimwJIn4oP0qM4QU5BYdmUo=
X-Google-Smtp-Source: AK7set9qsEkFUXJm7z8484jOe0YgRJAcBXszH8T4j5oFPVBQARHryzyxDR13OVYieq4uT8zdZdk0EA==
X-Received: by 2002:a0d:ea4b:0:b0:506:39eb:7e02 with SMTP id t72-20020a0dea4b000000b0050639eb7e02mr20598747ywe.13.1675098829482;
        Mon, 30 Jan 2023 09:13:49 -0800 (PST)
Received: from ?IPV6:2601:18f:700:287c::1006? ([2601:18f:700:287c::1006])
        by smtp.gmail.com with ESMTPSA id op52-20020a05620a537400b007186c9e167esm6801109qkn.52.2023.01.30.09.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 09:13:49 -0800 (PST)
Message-ID: <78b84d51-b758-8e1b-f2f9-8c844b8a25d2@gmail.com>
Date:   Mon, 30 Jan 2023 12:13:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] neighbor: fix proxy_delay usage when it is
 zero
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
References: <20230125195114.596295-1-haleyb.dev@gmail.com>
 <20230126233713.28c64c4e@kernel.org>
From:   Brian Haley <haleyb.dev@gmail.com>
In-Reply-To: <20230126233713.28c64c4e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/23 2:37 AM, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 14:51:14 -0500 Brian Haley wrote:
>> +	or proxy_ndp is enabled. A random value between [0, proxy_delay]
> 
> Do you mean: [0, proxy_delay) or there's something that can give us an
> extra jiffy (IOW shouldn't the upper limit be open) ?
> 
> it's
>    random() % MAX - (1 - noise)
> 
> where (1 - noise) is the fraction of jiffy which already passed since
> the tick.
> 
> Sorry if I'm slow to get it..

Yes, it's [0, proxy_delay), should have just copied that right from the 
get_random_u32_below() definition. I'll send a v3 fixing the commit 
message and sysctl doc.

-Brian
