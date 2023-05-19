Return-Path: <netdev+bounces-3872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0AC70957E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 824D8281C29
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C517482;
	Fri, 19 May 2023 10:57:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658DF3D72
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:57:14 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E5A113;
	Fri, 19 May 2023 03:57:12 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d24136685so519808b3a.1;
        Fri, 19 May 2023 03:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684493831; x=1687085831;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qWk0CTBNsQavoEEcKVuGP2bDcBauh6RebXi8l10ycic=;
        b=TzMXqJR8yZA9o2Q0zo6uEueI3z8TJ8Rq1St8ew6a4ohnm+umzTEXdfCPaV9JFxRtrQ
         kZUxLtjqqgnZPtkb46QnXQDwdlaoOg9ulHLQQ58uijX7Y4SX2DsW0SLBBkhBQRFXKLAf
         RS+dFUznCZF/m7A4PUw9XYknKuPSMMt5+DQWHt3imQKqVRvuTaTf2ScQPyMM7xZRSaoV
         aCYgkuiiHlm39LaSfG2tfAeaptec8oeCtkAEgNuTzzzpLeiTkt1K674pdveKIINV1On9
         w7jzCGxETxrMhh/cIp4LThY9AG3y2XeZjZpvAfPOH46fs5lOMF0pIIVx+ExSJY8eAdv8
         Jx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684493831; x=1687085831;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWk0CTBNsQavoEEcKVuGP2bDcBauh6RebXi8l10ycic=;
        b=RYqICF2mfPpt+YH8g04/eDCXujMgix15ijHHKqo29cBqzA85eB9sytdTAYd4ls3l5Z
         cm6i+XZlIgvlfgoKyq0ZkJKaZOdck4V+gwJp4pfrSjfJ6wsm6RE+enWsteKEQyqpj4IZ
         Xrwv0sRZxm4aCuR6lm6HO7jOtTp0J/W1I7q6GkU6QSy/SF6hRnTq6lYDivisn9n6buDd
         VzbqwEeKlCHMZm2+mTS01ixPDyUK3PT9ugpCAw0huduQgs4WFTnqgkWqWMB49Nd5TvaX
         miJUCuq+F5gpeMwpjQmpuJ/rdKt+aGsYGaEq3uGtnPrGPWJWaIPHzDuXOE7+xtoBecxd
         NQ7w==
X-Gm-Message-State: AC+VfDwJ9I24RkqQCMy6YaKdbaK1HvzlEkRcttYoGExWH6+miiMNpqET
	N4I8EiFMcyyB70ut6PxlpLI=
X-Google-Smtp-Source: ACHHUZ5MQLPZbuf4rhqr+C86y7c9P8fkwdJCnGgm2dXoQKTGowxoks0DTP/xnvxhA7l92VlJkcagyQ==
X-Received: by 2002:a05:6a00:290a:b0:643:4608:7c2d with SMTP id cg10-20020a056a00290a00b0064346087c2dmr5911455pfb.12.1684493831325;
        Fri, 19 May 2023 03:57:11 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-22.three.co.id. [116.206.28.22])
        by smtp.gmail.com with ESMTPSA id fe25-20020a056a002f1900b0064d35cdaa54sm792224pfb.218.2023.05.19.03.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 03:57:10 -0700 (PDT)
Message-ID: <e74590da-8044-4605-26d0-f9eaf0bc0e6f@gmail.com>
Date: Fri, 19 May 2023 17:57:04 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net 4/5] net: ethernet: i825xx: Replace unversioned GPL
 (GPL 1.0) notice with SPDX identifier
Content-Language: en-US
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Networking <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Jay Vosburgh <j.vosburgh@gmail.com>, Andy Gospodarek <andy@greyhouse.net>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Sam Creasey <sammy@sammy.net>, Greg Ungerer <gerg@linux-m68k.org>,
 Simon Horman <simon.horman@corigine.com>, Tom Rix <trix@redhat.com>,
 Yang Yingliang <yangyingliang@huawei.com>, Donald Becker <becker@scyld.com>,
 Richard Hirst <richard@sleepie.demon.co.uk>,
 Greg KH <gregkh@linuxfoundation.org>
References: <20230515060714.621952-1-bagasdotme@gmail.com>
 <20230515060714.621952-5-bagasdotme@gmail.com>
 <CAMuHMdWh3an=E0_gyx9cgVbMkm56Uv_KuoEY79yVVaN22gFpZA@mail.gmail.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <CAMuHMdWh3an=E0_gyx9cgVbMkm56Uv_KuoEY79yVVaN22gFpZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/17/23 18:21, Geert Uytterhoeven wrote:
> Hi Bagas,
> 
> On Mon, May 15, 2023 at 8:19 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>> Replace unversioned GPL boilerplate notice with corresponding SPDX
>> license identifier, which is GPL 1.0+.
>>
>> Cc: Donald Becker <becker@scyld.com>
>> Cc: Richard Hirst <richard@sleepie.demon.co.uk>
>> Cc: Sam Creasey <sammy@sammy.net>
>> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 
> Thanks for your patch, which is now commit 9ac40d080befb4a0 ("net:
> ethernet: i825xx: Replace unversioned GPL (GPL 1.0) notice with SPDX
> identifier") in net-next/main and next-20230517.
> 
>>  drivers/net/ethernet/i825xx/82596.c      | 5 ++---
>>  drivers/net/ethernet/i825xx/lasi_82596.c | 5 ++---
>>  drivers/net/ethernet/i825xx/lib82596.c   | 5 ++---
>>  3 files changed, 6 insertions(+), 9 deletions(-)
> 
>> --- a/drivers/net/ethernet/i825xx/82596.c
>> +++ b/drivers/net/ethernet/i825xx/82596.c
>> @@ -1,3 +1,4 @@
>> +// SPDX-License-Identifier: GPL-1.0+
>>  /* 82596.c: A generic 82596 ethernet driver for linux. */
>>  /*
>>     Based on Apricot.c
>> @@ -31,9 +32,7 @@
>>     Driver skeleton
>>     Written 1993 by Donald Becker.
>>     Copyright 1993 United States Government as represented by the Director,
>> -   National Security Agency. This software may only be used and distributed
>> -   according to the terms of the GNU General Public License as modified by SRC,
>> -   incorporated herein by reference.
>> +   National Security Agency.
> 
> This file is not licensed under the "unversioned GPL", but
> under the "GNU General Public License as modified by SRC".
> Cfr. https://elixir.bootlin.com/linux/latest/source/drivers/net/LICENSE.SRC
> Hence you removed important legal information.
> 
> Same for the two other files.
> 

Oops, thanks for pointing it out!

I included Donald Becker in Cc to ask if this conversion is OK,
but emails to him (including this patch series) bounced (unreachable
domain).

-- 
An old man doll... just what I always wanted! - Clara


