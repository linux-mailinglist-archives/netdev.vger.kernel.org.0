Return-Path: <netdev+bounces-2962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA4C704B0F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A1C928167A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BB534CD2;
	Tue, 16 May 2023 10:48:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A9134CC9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:48:10 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319043A99
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:47:51 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-965cc5170bdso2151505366b.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684234069; x=1686826069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Js3YuPgss9QnQgb0ghb/7P0ksUMIVrx2im8eZEBPrko=;
        b=L+dTajnQeDtHHrVal8YzvGE5uYvGo+QGMEUc2KcrDnIEKFbEUgJEEqW29k+GjRVr2d
         35X1YcGFtg5YpAYrzHzORZjhnAS8QgOqQHnlhf4vQDXHVgF61gqErpVXt+aR7fy9Vk2/
         PZAI1w6yyrzaP+YvYAKRCaS0wi8I4qmkgHNZm1cHNDSIhvT6DHNy7LFa0wEDUPr1wABV
         XlrAwTt8BBhkC7rTlJW27pgqt3Kai1rKOQaa5EaJnEwS4go/o7cf7yta2SlAN3iRtuzD
         CFCz4MJ+VsHvH1JljS/Ou5RYgYZDkNoTDStEjglITU6PxrjApNwbg+tl84pcoOPRDsss
         bDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684234069; x=1686826069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Js3YuPgss9QnQgb0ghb/7P0ksUMIVrx2im8eZEBPrko=;
        b=INj6z6MdbGE6kELQSFu2LfgktGeNoDFC2V9+apYcoH44/d6mg/D7H/yUKhPrHvKoSr
         U0dHbiSUTzVFKBQIwvwgaGEOSU+NsSl5uEnX17J9LHv8+Sis1Ulgmy1AJIW8vG0RMQbZ
         hKu2Ofb+jwTp5urSZJ/a3n5HBjUX3TTKbwv1/Gy88wjrQwWNeX1II742/PGAhwH8z4Qs
         VVxlHHa+/fLQ9olacV/A36KFHiITb1tyndAAy5U5SOIgIH61es+fOXejE7rNFaDy65yf
         ghkUNwUg7gz9ZZeViRnMK557/0ux7xnPnt+WdC9RO2kjmo1xIhALSQz+Dtm+kqoQQDRY
         6oNg==
X-Gm-Message-State: AC+VfDzldzUx39fFSyTJTz2Hv249TjZzm8ckDSn5Rq//CZFJ9xs4ne3h
	yFKN46gq08aOPPe6IdIl4SR0mw==
X-Google-Smtp-Source: ACHHUZ6t4tro4CCIk9USgYXdvc3t+cBkHaGNsbCWjB+hKdA78TGD9pSRG4wLWTiciZP1JzEFEdh5Eg==
X-Received: by 2002:a17:907:7251:b0:96a:1ab:b4a2 with SMTP id ds17-20020a170907725100b0096a01abb4a2mr26625215ejc.25.1684234069493;
        Tue, 16 May 2023 03:47:49 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id z23-20020a17090674d700b0096ac911ecb8sm5375855ejl.55.2023.05.16.03.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 03:47:48 -0700 (PDT)
Message-ID: <c05b5623-c096-162f-3a2d-db19ca760098@blackwall.org>
Date: Tue, 16 May 2023 13:47:47 +0300
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
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230516104428.i5ou4ogx7gt2x6gq@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/05/2023 13:44, Vladimir Oltean wrote:
> On Tue, May 16, 2023 at 01:32:05PM +0300, Nikolay Aleksandrov wrote:
>> Let's take a step back, I wasn't suggesting we start with a full-fledged switchdev
>> implementation. :) I meant only to see if the minimum global limit implementation
>> suggested would suffice and would be able to later extend so switchdev can use and
>> potentially modify (e.g. drivers setting limits etc). We can start with a simple
>> support for limits and then extend accordingly. The important part here is to
>> not add any uAPI that can't be changed later which would impact future changes.
> 
> I guess adding a global per-bridge learning limit now makes sense and
> would not unreasonably hinder switchdev later on. The focus is on
> "learning limit" and not a limit to user-created entries as Johannes has
> currently done in v1. I don't necessarily see an urgent need for
> IFLA_BR_FDB_CUR_ENTRIES, given the fact that user space can dump the FDB
> and count what it needs, filtering for FDB types accordingly.

Having the current count is just a helper, if you have a high limit dumping the table
and counting might take awhile. Thanks for the feedback, then we'll polish and move
on with the set for a global limit.

