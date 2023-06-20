Return-Path: <netdev+bounces-12123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DEE273643A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01D1A1C20880
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 07:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE67246B3;
	Tue, 20 Jun 2023 07:15:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFB31FD0
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:15:44 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0C2119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 00:15:42 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so5609848e87.2
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 00:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1687245341; x=1689837341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jQ/7vwSwxnA7hS2MnkoZC9h+eLxfozOTX4SsBbSZfWo=;
        b=fDYE6VxQSDYEfGR/s2+rSpfd85/UxttrYKcTG6ef1zpy3/1yWRCflPfgahw3gougFE
         z5PFV4J0vBV9LTE14QT0Q8gkpOqT+lEfqjx3T3lVxgOyAnP+jkSezGAK9Lx2Wa+CB9vf
         Fu0I4+zYvf7cPUtlwqJHyPfr8ywptqw28mrBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687245341; x=1689837341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jQ/7vwSwxnA7hS2MnkoZC9h+eLxfozOTX4SsBbSZfWo=;
        b=XnqFKhH4EjZD0hBxdZCwqYjJVNmmeBFRnv2P+6VlZqHhb1IENm9TfnX36+lYGX8tjh
         nLSxz1MWA/gRunYC3sR/ex8fHQX5q7xYfxD2WMfVtQr6i/CjYuqztf1tS8RvgSzzK/Iz
         GgbCXz7EMZwar3Kt19Hisc8OlM3hgxGBd+k1cjF1rHIMqkQsTjLD03/Wr/Pp/Tx+8W9H
         Sp+/ExsRj9MI2ZSTVZi7XFYbvLanqWeF2PvrB6n4oWOrWU5KuH73nZH1GkPaw+eQ5d+Y
         mxL3E9AkykGysUHv8yadMvSIvLIOkqmNxRfS9YxdTnVeuA5yqWX5ufcRMyCFHENqKWxW
         cdOw==
X-Gm-Message-State: AC+VfDyoEypf5fLobdfc/dt5rrZWqZUTcxTgGguCZuHslBE/ZKrDNrcw
	77jVlYUz4DS76zLOLRmrAwZqBw==
X-Google-Smtp-Source: ACHHUZ4xjBRoBVcpZUgDMrmHGOYDVKKcErV9moQOMZcQsZ+O61Oe50C+ZIBOJJqM7eOkUHzfXk8r2Q==
X-Received: by 2002:a19:e348:0:b0:4f6:1c08:e9bb with SMTP id c8-20020a19e348000000b004f61c08e9bbmr6827356lfk.63.1687245340636;
        Tue, 20 Jun 2023 00:15:40 -0700 (PDT)
Received: from [172.21.2.62] ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id i22-20020a056512007600b004f843f31fefsm243075lfo.281.2023.06.20.00.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 00:15:40 -0700 (PDT)
Message-ID: <423d2a3c-6b4d-449f-5fa6-5402467e1b6e@rasmusvillemoes.dk>
Date: Tue, 20 Jun 2023 09:15:39 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] net: dsa: microchip: ksz9477: follow errata
 sheet when applying fixups
To: Robert Hancock <robert.hancock@calian.com>,
 "andrew@lunn.ch" <andrew@lunn.ch>, "olteanv@gmail.com" <olteanv@gmail.com>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "hancock@sedsystems.ca" <hancock@sedsystems.ca>,
 "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
 "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
 "kuba@kernel.org" <kuba@kernel.org>,
 "edumazet@google.com" <edumazet@google.com>,
 "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
 "pabeni@redhat.com" <pabeni@redhat.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230619081633.589703-1-linux@rasmusvillemoes.dk>
 <b91cc419988fe21723f948524c1d7e44e3953ee2.camel@calian.com>
Content-Language: en-US, da
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <b91cc419988fe21723f948524c1d7e44e3953ee2.camel@calian.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 19/06/2023 19.31, Robert Hancock wrote:
> On Mon, 2023-06-19 at 10:16 +0200, Rasmus Villemoes wrote:
>>
>> Fixes: 1fc33199185d ("net: dsa: microchip: Add PHY errata
>> workarounds")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>> While I do believe this is a fix, I don't think it's post-rc7
>> material, hence targeting net-next with cc stable.
> 
> I don't think this will apply to net-next as the relevant code has been
> moved to the Micrel PHY driver and removed from this one in the
> following commits, 

Ah, sorry about that. This code hadn't been touched in a very long time,
so I didn't actually think to check -next.

and effectively the same change to disable autoneg
> before the register writes and re-enable afterwards was incorporated:

Yes, except it seems to always enable autoneg, even if the phy was
strapped otherwise. That's not a problem for our use case.

> However, your patch may be reasonable to apply to -rc7 or stable as a
> more targeted change for those releases.

Well, yes, it could be backported, but then there'd be a (simple)
conflict when net-next is to be merged in the next window. So I don't
think it's worth it.

Unless the net maintainers decide otherwise, please just drop this patch.

Rasmus


