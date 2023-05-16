Return-Path: <netdev+bounces-2971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7DE704C27
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 375B2281062
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7104834CEA;
	Tue, 16 May 2023 11:18:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8B34CE3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:18:49 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016D81717
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:18:25 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9661047f8b8so2186994666b.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684235898; x=1686827898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oLNTOgpd74kTGPMOubmCg/68yes1Cl/99CRgAydnyPY=;
        b=KanS41noryOELVYIa+m4eah7qvA+WecJpxc2xTF7gfEUW2viqVfNiPckR+sm7Q2jjY
         edTpP9uSmKSf7Vuu92x+N3iQqUk1cihKECxg3ti3LAQWRVNUJhYvrqhcUNpppV2Lr+3C
         N/U4hyEBmP2cnxxYmsAE8MWcAi/c0zHNwWOOp9R2YeWqk1HXeWl0YtjzN+9rIv/eGUdO
         a61/tgnvSocGwmAsbXJd54448SNms8Z8QYJqM+TGbwEPMAOcVBS6N1S2nuaunCgwvBfR
         GPzwYiYrb8Xdx+GF6mbJDhbce4IrTzSJecEglgqQzpMCXRkRuIZ6yTy8CTLDl7wOpJpT
         6V8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684235898; x=1686827898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oLNTOgpd74kTGPMOubmCg/68yes1Cl/99CRgAydnyPY=;
        b=WzURUJQ3iM1jPMre0U8nIt81a+hEHEQ860YAFbi2mFR/Bb6sy4X2jKhseS8IQ1Cnab
         LfbpuZyBpKAH29UyXN8vIGWWcDf3Jbbi40po876x3ozYZPl+5u80w2gdg9ufetsG3F/z
         ur194avpmfJZ8n47Kp/Aeo2OZK48J5eCajnFvsN3Kqa4bdr47Pu3tQqyX001SiymvGhA
         fwQhrvOfWTlweyKJCv5aJ95+LzW8AX0sHPFKMK1hO6mp7LQHXjBCUX1d1jaLetcPUVl0
         HXaFh7B5Pwc8c5Y5kE2UOqC2MuFw2yY/P4W9xWNTg/sj/qi4JsHPPfPYIhSMEtBqgXXt
         Ux5A==
X-Gm-Message-State: AC+VfDxW6NcCDe16IQV0oUcPHWew30j3jTrYL5tPxWdkWFsw0eR79NWq
	5qHPageceIy1kj3QT006JYaDnA==
X-Google-Smtp-Source: ACHHUZ5gc7lTURRGrAfJ8U5+sM1JJ/y6/zFwOq/biKUbPIowfKMQ7jVV07UDhRnOO97l3E1nsQ+bpQ==
X-Received: by 2002:a17:907:26c3:b0:96a:f6f6:4efd with SMTP id bp3-20020a17090726c300b0096af6f64efdmr7917304ejc.49.1684235897646;
        Tue, 16 May 2023 04:18:17 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id y10-20020a170906914a00b009663cf5dc3bsm10696963ejw.53.2023.05.16.04.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 04:18:17 -0700 (PDT)
Message-ID: <b12a817f-de9f-6d25-f189-67e5e7ef49a4@blackwall.org>
Date: Tue, 16 May 2023 14:18:15 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Content-Language: en-US
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>,
 Johannes Nixdorf <jnixdorf-oss@avm.de>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Ido Schimmel <idosch@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <a1d13117-a0c5-d06e-86b7-eacf4811102f@blackwall.org>
 <ZGNEk3F8mcT7nNdB@u-jnixdorf.ads.avm.de>
 <f899f032-b726-7b6d-953d-c7f3f98744ca@blackwall.org>
 <20230516102141.w75yh6pdo53ufjur@skbuf>
 <ce3835d9-c093-cfcb-3687-3a375236cb8f@blackwall.org>
 <20230516104428.i5ou4ogx7gt2x6gq@skbuf>
 <c05b5623-c096-162f-3a2d-db19ca760098@blackwall.org>
 <20230516105509.xaalfs77vrlr663u@skbuf>
 <6a688292-a7a0-20c9-03b9-cad11a61144f@blackwall.org>
 <20230516111005.ni3jygnnxgygoenh@skbuf>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230516111005.ni3jygnnxgygoenh@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/05/2023 14:10, Vladimir Oltean wrote:
> On Tue, May 16, 2023 at 02:04:30PM +0300, Nikolay Aleksandrov wrote:
>> That was one of the questions actually. More that I'm thinking about this, the more
>> I want to break it apart by type because we discussed being able to specify a flag
>> mask for the limit (all, dynamic, dynamic+static etc). If we embed these stats into a
>> bridge fdb count attribute, it can be easily extended later if anything new comes along.
>> If switchdev doesn't support some of these global limit configs, we can pass the option
>> and it can deny setting it later. I think this should be more than enough as a first step.
> 
> Ok, and by "type" you actually mean the impossibly hard to understand
> neighbor discovery states used by the bridge UAPI? Like having

Yes, that is what I mean. It's not that hard, we can limit it to a few combinations
that are well understood and defined.

> (overlapping) limits per NUD_REACHABLE, NUD_NOARP etc flags set in
> ndm->ndm_state? Or how should the UAPI look like?

Hmm, perhaps for the time being and for keeping it simpler it'd be best if the type initially is just about
dynamic entries and the count reflects only those. We can add an abstraction later if we want "per-type"/mask limits.
Adding such abstraction should be pretty-straight forward if we keep in mind the flags that can change only
under lock, otherwise proper counting would have to be revisited.

