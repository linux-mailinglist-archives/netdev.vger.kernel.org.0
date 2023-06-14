Return-Path: <netdev+bounces-10769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D3373035E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44218281420
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FBB101D8;
	Wed, 14 Jun 2023 15:17:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D008460
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:17:53 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938371BFF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:17:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b3be39e666so29498575ad.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686755870; x=1689347870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2FRakTwUO3HarAUoL8+C4HrsHI0Kc5B91QS0tw7ZEwU=;
        b=gCAAZkeo2KgvjuFPoE2j4s/jh0nZTZTRXI1WHsoaeHehCcFZfl/cN+TrXNxauVGtzP
         jwVV1odiqym59JhclFb9F/sKebxThwAvjWy7SXrJjNCkxMuDR1RU6CW68BrWlo3KZPbA
         JpKlb7JGal3/LgQeEgCzsqlvDrjWu0PUmYdM5uQiRQJqP3rGfx2gIdEJYh8zdl7nzbh3
         iQ2/ut9PJI8UKO1NBBXvILBhd9AHL/WUvSthMceLssRYK/utXMJc7n+Jmzp5dTu0+s7y
         9qjCmdizmot7xHoS4lTLNpILDZ3SdC3u1jjZBztKVp7Cr9I95NjGoZ0CNnZfNdka3GjE
         aZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686755870; x=1689347870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2FRakTwUO3HarAUoL8+C4HrsHI0Kc5B91QS0tw7ZEwU=;
        b=TIuh4p2J3XQDl9y3nN+MbfYLGTvH/F4qvzm0CQiZi0dvXGX9lUKQavmx4ijSEhq4Dc
         1klzzbdMVASpwedtS3R4vbkvzBX3yB0vad5n/PDveCdFzNg04Wc4Fcoyp7/Nk+lfPlYG
         pvdmz7SzgRPTGTQQycQ+3UWtzzgIU2gEKWdlhnzkL+ctX6COxEkUiRchplHHGLmjO71b
         n69RiN25tuZZ1INkt1gc0qCKGK9pl1H50b6eK9cFiAFB3HgZJfUNFrCnzdV9DmmveRgP
         meiZbCLd/cNLQZ+EgCJIZ8NTs5u3Xsz5GVFbW9OupK7TotlFyNFq8Htt0+d2tL8zCoya
         /Mgg==
X-Gm-Message-State: AC+VfDzDRcyrAkIYhPZKE/OJjdONZuKSFte+qEMrF0z+PZh5200zwjBs
	sJB+M9FOc836Z7QL75Ne+Ps=
X-Google-Smtp-Source: ACHHUZ59p9kMIWSc8WcF7d41D3CjLz45p7DVBgHmU8imwlR9nyvmf2WeoW3hCxiXysCTPaKce2hf3Q==
X-Received: by 2002:a17:902:d4d2:b0:1ae:9105:10a5 with SMTP id o18-20020a170902d4d200b001ae910510a5mr2361444plg.2.1686755869891;
        Wed, 14 Jun 2023 08:17:49 -0700 (PDT)
Received: from [172.16.103.191] ([216.110.217.114])
        by smtp.googlemail.com with ESMTPSA id f18-20020a635552000000b0054f81b2aedbsm6101160pgm.51.2023.06.14.08.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 08:17:49 -0700 (PDT)
Message-ID: <15de5df0-9a29-d592-0ac8-e2c470b17c83@gmail.com>
Date: Wed, 14 Jun 2023 08:17:44 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
Content-Language: en-US
To: Paolo Abeni <pabeni@redhat.com>,
 "Keller, Jacob E" <jacob.e.keller@intel.com>, Gal Pressman <gal@nvidia.com>,
 Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Edwin Peer <edwin.peer@broadcom.com>, Edwin Peer <espeer@gmail.com>
References: <20230611105108.122586-1-gal@nvidia.com>
 <20230611080655.35702d7a@hermes.local>
 <9b59a933-0457-b9f2-a0da-9b764223c250@nvidia.com>
 <CO1PR11MB50899E098BB3FFE0DE322222D654A@CO1PR11MB5089.namprd11.prod.outlook.com>
 <a9d5cf824500c3a4d86f26bd18ec29b6dfd2daf8.camel@redhat.com>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <a9d5cf824500c3a4d86f26bd18ec29b6dfd2daf8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/14/23 3:03 AM, Paolo Abeni wrote:
> On Mon, 2023-06-12 at 05:34 +0000, Keller, Jacob E wrote:
>>> -----Original Message-----
>>> From: Gal Pressman <gal@nvidia.com>
>>> Sent: Sunday, June 11, 2023 10:59 AM
>>> To: Stephen Hemminger <stephen@networkplumber.org>
>>> Cc: David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
>>> David Ahern <dsahern@gmail.com>; Michal Kubecek <mkubecek@suse.cz>;
>>> netdev@vger.kernel.org; Edwin Peer <edwin.peer@broadcom.com>; Edwin Peer
>>> <espeer@gmail.com>
>>> Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
>>> IFLA_VF_INFO
>>>
>>> On 11/06/2023 18:06, Stephen Hemminger wrote:
>>>
>>>> Better but it is still possible to create too many VF's that the response
>>>> won't fit.
>>>
>>> Correct, no argues here.
>>> It allowed me to see around ~200 VFs instead of ~70, a step in the right
>>> direction.
>>
>> I remember investigating this a few years ago and we hit limits of ~200 that were essentially unfixable without creating a new API that can separate the reply over more than one message. The VF info data was not designed in the current op to allow processing over multiple messages. It also (unfortunately) doesn't report errors so it ends up just truncating instead of producing an error.
>>
>> Fixing this completely is non-trivial.
> 
> As it looks like the is substantial agreement on this approach being a
> step in the right direction and I can't think of anything better, I
> suggest to merge this as is, unless someone voices concerns very soon,
> very loudly.
> 

My only concern is that this "hot potato" stays in the air longer. This
problem has been around for years, and someone needs to step up and
propose an API.


