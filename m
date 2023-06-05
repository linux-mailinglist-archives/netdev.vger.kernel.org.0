Return-Path: <netdev+bounces-8093-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C655722AC1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8C8C1C20C6A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7E01F953;
	Mon,  5 Jun 2023 15:19:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11F11F92C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:19:57 +0000 (UTC)
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6FCD2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:19:56 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33b36a9fdf8so19696305ab.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685978396; x=1688570396;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mDcpjdnMLD0HE+xQAV5JavmdqXuvu+LhYh8Ei5Yh8Ic=;
        b=S+iyr1buYimFdM0dOt43cK5yB1ANYbeBt1HI6+Y7jQvhoHKSVixztIZncbiEPUEcoC
         fk5v1F4xmPbn1b3ihK52qMEIlXNI/mLhmtCN09gBAnCqoNhJZ15qzPl2LQzhSIU9i+xN
         qUpwhf7I809HoGf0BJNHeSWnK9qWWFk1Y2wDsnuBhjfCRCPIQEnAThVndvFT++U/ap+5
         iJ2i8F1c8xITTyQWK8x5o0tbrrVfOnJsmqJTliq6i1DJ7Cv+ELV8TsskW73j1JatAk/a
         Z0iztZasU2+sxpTv5zgUsZBbnPjP8hnIie+sIS9g8M3jWKlJZSZxdYfx+oRSo7aO8mwf
         xuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685978396; x=1688570396;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mDcpjdnMLD0HE+xQAV5JavmdqXuvu+LhYh8Ei5Yh8Ic=;
        b=eMb8S54Su4A3AeJelkpuHJFP/9xI3KeXHp9HOoaaTz+V1GOO0Iw0IVVr+KrtdVAKQD
         R0H3I5iz/5gxm535V4pmZkkgYZsM07wWYW3TTGTYcoWqGPi799/u5ENr22HAg3C9h5jo
         YkgzR30hf/aK4W/slmYmF/gNeupThG5yY5JWW0Tm3ec6zZ5pvHh/e+7qd4z/aO11CQER
         vGPO8hKvT1BREwvjFMXJON7N2E/qVNecBrug/0qgdmqI1vRGGbWWV0ekCvJhPatVcy6V
         1DyAdHtwabNl5qxZW/98/evXHqi0yruTzH/WwKbpFusFQBXRqeZfbfUHYh4kwjCV49XG
         uZFA==
X-Gm-Message-State: AC+VfDzundKNRYj8736rIAnneEg399tu3rlA/3JQibXfeOkkymoZjWYN
	/QA292w+5GkPg0dYBTHHSRY=
X-Google-Smtp-Source: ACHHUZ6vzpCkcaO8R8Xi1h3qYpp2O7duz4CKP2HMb6SI6KXT/8DbWOrJVzlMqnibz5f5hmtjL0+rjA==
X-Received: by 2002:a92:dc52:0:b0:33d:72c0:1b0 with SMTP id x18-20020a92dc52000000b0033d72c001b0mr132710ilq.17.1685978395888;
        Mon, 05 Jun 2023 08:19:55 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:1084:4e4a:fc45:90c5? ([2601:282:800:7ed0:1084:4e4a:fc45:90c5])
        by smtp.googlemail.com with ESMTPSA id u15-20020a92d1cf000000b0033a6e7ee4e3sm2449773ilg.1.2023.06.05.08.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 08:19:55 -0700 (PDT)
Message-ID: <48d79848-aee9-a127-8cd1-f0a23305c5ac@gmail.com>
Date: Mon, 5 Jun 2023 09:19:53 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2-next v7] ip-link: add support for nolocalbypass
 in vxlan
Content-Language: en-US
To: Ido Schimmel <idosch@idosch.org>,
 Stephen Hemminger <stephen@networkplumber.org>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
 razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
 eyal.birger@gmail.com, jtoppins@redhat.com
References: <20230604140051.4523-1-vladimir@nikishkin.pw>
 <ZH2CeAWH7uMLkFcj@shredder> <87sfb6pfqh.fsf@laptop.lockywolf.net>
 <ZH2cUO7pFnU/tcXL@shredder> <20230605080217.441e1973@hermes.local>
 <ZH376DK12JtBxlig@shredder>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <ZH376DK12JtBxlig@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/5/23 9:14 AM, Ido Schimmel wrote:
> On Mon, Jun 05, 2023 at 08:02:17AM -0700, Stephen Hemminger wrote:
>> David will to a merge from main to next if asked.
> 
> I see he is not even copied. Let me add him.

Thanks.

> 
> David, can you please merge main into next? We need commit 1215e9d38623
> ("vxlan: make option printing more consistent") to make progress with
> the "localbypass" patch.
> 
> Thanks

Done.

