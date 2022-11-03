Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967E2618305
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbiKCPkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiKCPkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:40:20 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCAD1740D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:40:14 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso1445607wmp.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 08:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=heCsF5+oksMkKllVhJuNqNh9mZu8ZtuLSZhGNPkuZUU=;
        b=awPwB40AqRzdI+kaKO27twDciZZUa4wRghMQ5H/0a2587mmwsT8ce5/+TwRPtir9qb
         Ue4YnZR0stUuot+GTLmCKAQphR/mSEXhy+ubpz8KJfPCEJzJVhMRNMXQCXLb6NJpUHTL
         UetbKMthucTcZE/68dqbYKFRtCiOee/L6nb3Ze3h2kWMdIE0zcxUoR/hGw/N9NFbiGxh
         pzv6WKvTAziZPBzbuivwaweJUDDVw3um7ka3zOz4dyEpmzTL/4Yn6NxxO0srkyX8p2W+
         NS7wLNG8qRLep0Q7rjQQ9JHVAvJWTrOGOAAgfs6Ly7geOJFMcz0P1WxaVFbFyAgd1EZi
         CAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=heCsF5+oksMkKllVhJuNqNh9mZu8ZtuLSZhGNPkuZUU=;
        b=6myXr55BsSxdPz1W8SbjHOUxKdCpYx+LHI6RByMeIDRS+r0XcCUEGpocEkqLKOtS/8
         X6eHh1dNpIRg0v4kkl5nKAyveNwWxwhCNlOXyc+jqgnf589PercEvxhVRcGeydBb+6tt
         54/3bEipo3KkZu6mQs8KQ1jrgnlJA5Gfz/39vuJ9gi7+49CYKAZxeGc25B+7GerOBW9x
         Uyr27YfCq1kCoQSXFS9AO2l2oPsV944GrUI+tu0LGg6WePt6DxqbUdzpvBr8m7G6LcBS
         Bg6nnMVCc7+njOEsFg+5rIuT/NkOj4mWYoLLbKbf82AA7HUEcTOd+6rAs8TfQk3emJQg
         UfJA==
X-Gm-Message-State: ACrzQf07lDTlQgukQ05K8HeQ4TmWWttofWErOPd/xwk57mennOArjpyw
        E29UXAe8dVH84FW9/vNQVjuk7w==
X-Google-Smtp-Source: AMsMyM5W3IK+XSPxncETUlmZfWRiaYwnj6m0Q7dFp4g0bufxPolS3y/IKY4/UkTiEiUWOM8xAdLSvw==
X-Received: by 2002:a05:600c:35cf:b0:3c6:e957:b403 with SMTP id r15-20020a05600c35cf00b003c6e957b403mr31542271wmq.162.1667490013382;
        Thu, 03 Nov 2022 08:40:13 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id v20-20020adfa1d4000000b002238ea5750csm1459001wrv.72.2022.11.03.08.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:40:12 -0700 (PDT)
Message-ID: <ad9be7ae-aeec-b208-8252-7a566534ded4@arista.com>
Date:   Thu, 3 Nov 2022 15:40:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 2/2] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
References: <20221102211350.625011-1-dima@arista.com>
 <20221102211350.625011-3-dima@arista.com>
 <CANn89iLbOikuG9+Tna9M0Gr-diF2vFpfMV8MDP8rBuN49+Mwrg@mail.gmail.com>
 <483848f5-8807-fd97-babc-44740db96db4@arista.com>
 <CANn89i+XyQhh0eNMJWNn6NNLDaMtrzX3sq9Atu-ic7P5uqDODg@mail.gmail.com>
 <CANn89i+UxgHwm9apzBXV-afpcfXfuX2S+6i4vPzF2ec4Dr6X0A@mail.gmail.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <CANn89i+UxgHwm9apzBXV-afpcfXfuX2S+6i4vPzF2ec4Dr6X0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 21:53, Eric Dumazet wrote:
> On Wed, Nov 2, 2022 at 2:49 PM Eric Dumazet <edumazet@google.com> wrote:
> 
>>
>> Are you sure ?
>>
>> static_branch_inc() is what we want here, it is a nice wrapper around
>> the correct internal details,
>> and ultimately boils to an atomic_inc(). It is safe for all contexts.
>>
>> But if/when jump labels get refcount_t one day, we will not have to
>> change TCP stack because
>> it made some implementation assumptions.
> 
> Oh, I think I understand this better now.
> 
> Please provide a helper like
> 
> static inline void static_key_fast_inc(struct static_key *key)
> {
>        atomic_inc(&key->enabled);
> }
> 
> Something like that.

Sure, that sounds like a better thing to do, rather than the hack I had.

Thanks, will send v2 soon,
          Dmitry

