Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBA56286C4
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbiKNROD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiKNROB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:14:01 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DDE193F4;
        Mon, 14 Nov 2022 09:14:00 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v1so19444297wrt.11;
        Mon, 14 Nov 2022 09:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZXvGvMcSWYTf7p+iAerqTrr94sDG0yvY/k9yRgt/478=;
        b=VTHWia4NGf9OUb0WlVfl3n2QUg/q1x0OgS//PVb2kFQAnAEntOeRqWwmiQpTM9vOOZ
         RcC+Ngtfm3ijSghBOkQiiRZxDjal1WG08Ie4ZO3Vak2AHyW3OPvftpnDKlqqB++hwdPZ
         6kQzN/CsRSyW8gGfu9fyJTZ0fRABayTGs5YZ6A+2EYyKksb54kAbmMdC1Ayoeh4ijBGM
         /CjMB5Ir3IsNMJ9zaqXQ+nbGK4CQ9Pc82jbRRRM1P0B1vGJ2LuRur9rO3o/aqfIjLGfu
         X+2LkLrUeb2HzClFnIUMEmTmjI74bBU9GGTvvywNZyDn7DkHsSvsUtXgHHuNrlquuHWY
         Vlhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXvGvMcSWYTf7p+iAerqTrr94sDG0yvY/k9yRgt/478=;
        b=vV3GlsYowLXwc+B9f2o1+6/45ABjLb6gbv+cbX46JbRFLB0YU6B73fcw89yMkM/tYk
         1LIE9eJ2ytVJd+Q51ACkkrWJvve8P3h3ESNz1RI9OcGSOD45dFqV4CFKQPQ6EmZbyd2+
         Y774YzjJ6qgW5CSfTwDVWG+F7jK7/UgEjDGNniVtWWhq/Bek1zMcmUjJiqtVfu6QKfyP
         6KxRSuF8LeR0s/X2irdXMqC+u/tYLQFtpiO1ZYhsC/WqBhlM7ph+Vo8p/Ou21s5rmABQ
         XDA9ZC3C424qELgKu8qYa/bDAIFTAk2vcqKPRNnKXQbNfCys49uEo/KaNoVIVTtrKple
         gicQ==
X-Gm-Message-State: ANoB5pnFlIz86cRzCqx2Cpt4yAImVa8j8aJIlf1XQMWZMgg7fwP63Z//
        8mhXGf+JHLYkxJ2cU96OI+A=
X-Google-Smtp-Source: AA0mqf4TMEre0i6MP4H/ebpkH6tghewWKBkKm44cf8q2uJuBNOrBaJOKZCSLR973hn25XEwF24f2qg==
X-Received: by 2002:adf:fa10:0:b0:241:753d:6018 with SMTP id m16-20020adffa10000000b00241753d6018mr7449297wrr.67.1668446038598;
        Mon, 14 Nov 2022 09:13:58 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o37-20020a05600c512500b003cf54b77bfesm20104796wms.28.2022.11.14.09.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 09:13:58 -0800 (PST)
Message-ID: <96cb7d74-a3e1-10d0-0af2-2b845b6da0ae@gmail.com>
Date:   Mon, 14 Nov 2022 17:13:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 1/3] jump_label: Prevent key->enabled int overflow
Content-Language: en-US
To:     Jason Baron <jbaron@akamai.com>, Dmitry Safonov <dima@arista.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20221111212320.1386566-1-dima@arista.com>
 <20221111212320.1386566-2-dima@arista.com>
 <ae9e4333-7070-d550-c0b5-f4d122d2f025@akamai.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <ae9e4333-7070-d550-c0b5-f4d122d2f025@akamai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/22 16:24, Jason Baron wrote:
> 
[..]
>> @@ -148,16 +167,23 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
>>  		 */
>>  		atomic_set_release(&key->enabled, 1);
>>  	} else {
>> -		atomic_inc(&key->enabled);
>> +		if (WARN_ON_ONCE(static_key_fast_inc(key))) {
> 
> Shouldn't that be negated to catch the overflow:
> 
> if (WARN_ON_ONCE(!static_key_fast_inc(key)))

Oh, that's just embarrassing!
I wonder how did I miss it during tests..

Thanks for spotting this, will fix in v4,
            Dmitry
