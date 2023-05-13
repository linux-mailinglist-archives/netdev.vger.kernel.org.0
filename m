Return-Path: <netdev+bounces-2343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E004C7015B5
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 11:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D45B51C20A78
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 09:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A807F139F;
	Sat, 13 May 2023 09:31:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A8D1391
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 09:31:21 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119CF4EEB;
	Sat, 13 May 2023 02:31:20 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1aad5245571so75094815ad.1;
        Sat, 13 May 2023 02:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683970279; x=1686562279;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QAdx92+LmsDn0JJwfNdgz9hGr4Gzf8ZJ/AEJvNY1jf4=;
        b=jk4zJucSuryHyqGtJk6hs3cLy8JBL2zqWlRTQd2Utvh4M35eSob8TLNZyJsHZ8IkI7
         fcWXnODhT0eOnQbKNXasKxznuETx6KJCO8P8hM5qC3TSDz4ly9I1sW5NggB+x47x+roh
         C3f1ZCverMxu/vm0vUlDpQjdW+81zKx9LVawaBES+kSYV4zDx4QOnSPCqz2hpyqHfZU8
         j6W0IiNMJBl0yQjmZdBGmZI4x7EVelcOzvRix4Kg4R8eiMW3ZkKk7oAhHigDKj3263Q5
         pwEka3n8dGcsZYuENINMghizDwWJPi7L6A8Ulr3GnjC9F0v9ftiLPTozzksF8H36Ocfm
         uBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683970279; x=1686562279;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QAdx92+LmsDn0JJwfNdgz9hGr4Gzf8ZJ/AEJvNY1jf4=;
        b=hiyHItWLUkGDI1O9q9II7/HR2lydPj9B5caKcxCB0eHC7DCoD6eBJ961/YmjS8va8q
         hPhylKojuMuLfq7w83InlBlpZ2290fctGKzDVJ/apSDqUq+vMUDEv5ieyGDTRE0IPAdt
         z3CIYZE9r724ZNcc2c8Fv81sW4SrjivuouV4AaPjn2J0lf4ts40OGeQzT6C9bPuxj1GN
         u2uLPj/yqwlbBiaN55plAmJPjH6ZrQHUAWgIFKNBJJnSmVBkrdmf4eKyNk3tPcyCiVGR
         mXEtw54ROYg3gfY0OGnjJIgnzVFoP6TO5IEr66A4Y4MgRLNdLrxtJhmo5tY0Vem1iDq0
         AHug==
X-Gm-Message-State: AC+VfDw75tfjOtDUd8PWSz4hjMBRs5XtHVc1toe/dRlvtD9PK0EPrVMc
	3FtJvVULcK9rVw5jFj0UyHM=
X-Google-Smtp-Source: ACHHUZ6v0ih3wZYc2Mo8DVX9SfdKV6ex56JOnGaI++f7lQRcblP+yYtZX4/cIdfWc3Wuq98Bj/Q8LA==
X-Received: by 2002:a17:903:1247:b0:1ac:3605:97ec with SMTP id u7-20020a170903124700b001ac360597ecmr36125090plh.62.1683970279417;
        Sat, 13 May 2023 02:31:19 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-69.three.co.id. [180.214.232.69])
        by smtp.gmail.com with ESMTPSA id bc3-20020a170902930300b001aaf92130b2sm9368135plb.115.2023.05.13.02.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 May 2023 02:31:19 -0700 (PDT)
Message-ID: <22b3e6c7-895c-c972-bc3f-9390b9b7fb08@gmail.com>
Date: Sat, 13 May 2023 16:31:09 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 09/10] udf: Replace license notice with SPDX identifier
Content-Language: en-US
To: Richard Fontana <rfontana@redhat.com>
Cc: Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
 Linux DRI Development <dri-devel@lists.freedesktop.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Networking <netdev@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Linux Staging Drivers <linux-staging@lists.linux.dev>,
 Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
 Linux Kernel Actions <linux-actions@lists.infradead.org>,
 Diederik de Haas <didi.debian@cknow.org>,
 Kate Stewart <kstewart@linuxfoundation.org>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Thomas Gleixner <tglx@linutronix.de>, David Airlie <airlied@redhat.com>,
 Karsten Keil <isdn@linux-pingi.de>, Jay Vosburgh <j.vosburgh@gmail.com>,
 Andy Gospodarek <andy@greyhouse.net>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Sam Creasey <sammy@sammy.net>, Dominik Brodowski
 <linux@dominikbrodowski.net>, Daniel Mack <daniel@zonque.org>,
 Haojian Zhuang <haojian.zhuang@gmail.com>,
 Robert Jarzmik <robert.jarzmik@free.fr>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck
 <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
 =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
 Manivannan Sadhasivam <mani@kernel.org>, =?UTF-8?Q?Pali_Roh=c3=a1r?=
 <pali@kernel.org>, Simon Horman <simon.horman@corigine.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
 <20230512100620.36807-10-bagasdotme@gmail.com>
 <CAC1cPGzSpMZC3oJOpzjqiEDvgWUszzSztMri6uxW6vZ7oZtD5w@mail.gmail.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <CAC1cPGzSpMZC3oJOpzjqiEDvgWUszzSztMri6uxW6vZ7oZtD5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/12/23 20:21, Richard Fontana wrote:
> On Fri, May 12, 2023 at 6:07 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> 
>> diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
>> index de17a97e866742..b2b5bca45758df 100644
>> --- a/fs/udf/ecma_167.h
>> +++ b/fs/udf/ecma_167.h
>> @@ -1,3 +1,4 @@
>> +/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0+ */
>>  /*
>>   * ecma_167.h
>>   *
>> @@ -8,29 +9,6 @@
>>   * Copyright (c) 2017-2019  Pali Rohár <pali@kernel.org>
>>   * All rights reserved.
>>   *
>> - * Redistribution and use in source and binary forms, with or without
>> - * modification, are permitted provided that the following conditions
>> - * are met:
>> - * 1. Redistributions of source code must retain the above copyright
>> - *    notice, this list of conditions, and the following disclaimer,
>> - *    without modification.
>> - * 2. The name of the author may not be used to endorse or promote products
>> - *    derived from this software without specific prior written permission.
>> - *
> 
> This is not BSD-2-Clause. Ignoring the interior statement about the
> GPL, I think the closest SPDX identifier might be
> https://spdx.org/licenses/BSD-Source-Code.html
> but it doesn't quite match.
> 

BSD-2-Clause but the second clause is the third one on BSD-3-Clause.
Weird...

>> diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
>> index fce4ad976c8c29..d0fce5348fd3f3 100644
>> --- a/fs/udf/udftime.c
>> +++ b/fs/udf/udftime.c
>> @@ -1,21 +1,4 @@
>> -/* Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, Inc.
>> -   This file is part of the GNU C Library.
>> -   Contributed by Paul Eggert (eggert@twinsun.com).
>> -
>> -   The GNU C Library is free software; you can redistribute it and/or
>> -   modify it under the terms of the GNU Library General Public License as
>> -   published by the Free Software Foundation; either version 2 of the
>> -   License, or (at your option) any later version.
>> -
>> -   The GNU C Library is distributed in the hope that it will be useful,
>> -   but WITHOUT ANY WARRANTY; without even the implied warranty of
>> -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> -   Library General Public License for more details.
>> -
>> -   You should have received a copy of the GNU Library General Public
>> -   License along with the GNU C Library; see the file COPYING.LIB.  If not,
>> -   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> -   Boston, MA 02111-1307, USA.  */
>> +// SPDX-License-Identifier: GPL-2.0-only
> 
> Shouldn't this be
> // SPDX-License-Identifier: LGPL-2.0-or-later ?
> (or are you implicitly using the obscure LGPLv2.x section ... 3 mechanism?)
> 

That's right. I missed the exact notice above when I submitted this
series.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara


