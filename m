Return-Path: <netdev+bounces-8440-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A315A7240FE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:35:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 072C11C20F1A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4616115AEF;
	Tue,  6 Jun 2023 11:35:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C31B15ADB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:35:28 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DA2F4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:35:23 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f6d7abe934so51876715e9.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686051322; x=1688643322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lvATKcdZSwuPOJh2GRkP6X8hkhA21/bnoihEc7xpbVg=;
        b=kkLLVCklE5BWE+AJ9mXI4TIQutfTJhTLR6Slhen4KahnxjKdtVRy37/sFU0L+Q+db2
         OExJHd2WMUVHHy6wUwwAkaF0vfd6P3q5pVBjt3o7stpyWEZOq3L8HRzNPiMaojaJLjvA
         whYeOY1676CfIKjVytE6OXhftebOvEjMHDq20m/8J6oZs00MR0GXwk1eU3rxIHHGqhh8
         EuxOG3+EJPg4oM57NrpX2KBsoJcBNhnVVlRpCMXbWhC9nT7WpY69fpV4TqBQpCaZrLgy
         nT5NAmrWS8vxhM7J1Fvq3uGiN0E7zVpqBdei+OWDlOZs4r4YLUzw9/phQ76BHDNAFTls
         H0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686051322; x=1688643322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lvATKcdZSwuPOJh2GRkP6X8hkhA21/bnoihEc7xpbVg=;
        b=bsGQHHFJU1UtR0SVhvzk4lyTD7IRFcrF1eWh7F5NzMX5+vO3GJcG4+1cvRpSknXAcC
         mh8zT3orbdTuuLkFsCtEIwBMknn70k3PeGt5FfBvsPrO7uXxkZ06pAoY0MkgJC4hW5bD
         2ub6C4NRidGaxu72RfDcflTyZA5jVAFvEjHsjmqDcJpEs3lDOAxLXuJuCl5Tlpk4qUr9
         LtMDe+/vVIzt+V9H0TwelkagR3lgGB4v5DUhYAUuEJct+xKuymFxQFsNnlHELys5wbHX
         molWBIOZPvd5Mm/7NDzIbfP9mqWgn19Y4bCj+PDDr7YWAZP6kg03p4PPXKI9SPnLCt9+
         nbTA==
X-Gm-Message-State: AC+VfDz8I7HYhIbHAWPvaLXvIqHwJds57780VgmcoOBgD0LjdbxwXfYQ
	6pfaSlJ/TuiaLevI/3PTe4Jtmg==
X-Google-Smtp-Source: ACHHUZ5kD2v+8EkF8x2chCUib+bgiV9eyH42+QjLZKwrasuxwl/S8sfhnB72NeeoY1SloBs4skJaXQ==
X-Received: by 2002:a1c:6a12:0:b0:3f0:b1c9:25d4 with SMTP id f18-20020a1c6a12000000b003f0b1c925d4mr1855738wmc.21.1686051322295;
        Tue, 06 Jun 2023 04:35:22 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:426c:bb31:d569:3738? ([2a02:578:8593:1200:426c:bb31:d569:3738])
        by smtp.gmail.com with ESMTPSA id m16-20020a7bcb90000000b003f6028a4c85sm17233920wmi.16.2023.06.06.04.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 04:35:22 -0700 (PDT)
Message-ID: <c709b7d0-6b06-4fc9-a99a-520ec13550ac@tessares.net>
Date: Tue, 6 Jun 2023 13:35:20 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v5] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Content-Language: en-GB
To: Breno Leitao <leitao@debian.org>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Remi Denis-Courmont <courmisch@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>, David Ahern <dsahern@kernel.org>,
 Mat Martineau <martineau@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, axboe@kernel.dk, asml.silence@gmail.com,
 leit@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 dccp@vger.kernel.org, linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
 linux-sctp@vger.kernel.org
References: <20230602163044.1820619-1-leitao@debian.org>
 <CAF=yD-Kk9mVWPZN50NUu8uGwEbySNS-WzvJ=1HTTcVsA6OOuvA@mail.gmail.com>
 <ZHxEX0TlXX7VV9kX@gmail.com>
 <CAF=yD-LvTDmWp+wAqwuQ7vKLT0hAHcQjV9Ef2rEag5J4cSZrkA@mail.gmail.com>
 <ZH8Ga15IFIUUA7j8@gmail.com>
From: Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <ZH8Ga15IFIUUA7j8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Breno,

On 06/06/2023 12:11, Breno Leitao wrote:
> On Sun, Jun 04, 2023 at 11:17:56AM +0200, Willem de Bruijn wrote:
>>> On Sat, Jun 03, 2023 at 10:21:50AM +0200, Willem de Bruijn wrote:
>>>> On Fri, Jun 2, 2023 at 6:31 PM Breno Leitao <leitao@debian.org> wrote:
>>>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>>>
>>>> Please check the checkpatch output
>>>>
>>>> https://patchwork.hopto.org/static/nipa/753609/13265673/checkpatch/stdout
>>>
>>> I am checking my current checkpatch before sending the patch, but I am
>>> not seeing the problems above.
>>>
>>> My tree is at 44c026a73be8038 ("Linux 6.4-rc3"), and I am not able to
>>> reproduce the problems above.
>>>
>>>         $ scripts/checkpatch.pl v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch
>>>         total: 0 errors, 0 warnings, 0 checks, 806 lines checked
>>>         v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch has no obvious style problems and is ready for submission.
>>>
>>> Let me investigate what options I am missing when running checkpatch.
>>
>> The reference is to the checkpatch as referenced by patchwork:
>>
>> https://patchwork.kernel.org/project/netdevbpf/patch/20230602163044.1820619-1-leitao@debian.org/
>>
>> The 80 character limit is a soft limit. But also note the CHECK
>> statements on whitespace.
> 
> Right. In order to enable the "CHECK" statments, we need to pass the
> "--subjective" parameter to checpatch.pl
> 
> That said, I am able to reproduce the same output now, using the
> following command line:
> 
> 	$ scripts/checkpatch.pl --subjective --max-line-length=80

The different results visible on Patchwork are posted by a CI using
scripts hosted there:

  https://github.com/kuba-moo/nipa

If you are interested to know how checkpatch.pl is executed, you can
have a look there:


https://github.com/kuba-moo/nipa/blob/master/tests/patch/checkpatch/checkpatch.sh#L16

I guess what you need is the "--strict" argument:

>   $ ./scripts/checkpatch.pl --strict --max-line-length=80 \
>       --ignore=COMMIT_LOG_LONG_LINE,MACRO_ARG_REUSE,ALLOC_SIZEOF_STRUCT,NO_AUTHOR_SIGN_OFF,GIT_COMMIT_ID,CAMELCASE \
>       -g HEAD

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

