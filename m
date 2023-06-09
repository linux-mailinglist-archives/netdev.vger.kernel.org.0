Return-Path: <netdev+bounces-9493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 720E4729658
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A02061C20C0A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7064A14AB1;
	Fri,  9 Jun 2023 10:10:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F94D1427F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:10:37 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B394EE7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:10:35 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-977e83d536fso242235966b.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 03:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1686305434; x=1688897434;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yS2aUgQCzMJ3EO5DLspaLc27pVQAPYGHdTdZhOt/Qbc=;
        b=i2R6OiNWJ812k7tEk8MFgXVAEgzGq9TX2uVlV/DmnnzCo8uf5O+u8PxJYF1fmmW7ge
         DiRg2DwX53b52ttYYql5uFw75qFj+mLMxZ1DBtC+j2Pp0/SnDniJ7txxwQbUhs340fZk
         3ogQVRYEmLTJypVD47DipsPJixUqtHjbgHr64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686305434; x=1688897434;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yS2aUgQCzMJ3EO5DLspaLc27pVQAPYGHdTdZhOt/Qbc=;
        b=C+C5ljmAHD95O5x0J/ncn/uG1qwWm37pbrSlI62MD/vYXLclxJwIIjjYD3xKoyZAQi
         AJdN5jJHJ6F4lcjiF0EjdlaZAjmV0fIJXhSlOFuaN+mNIo/4+rvLc00dYcMW2YY2kOR1
         G0DOKj7JXYOZwt4n6TnkYCsFDmDkQsGaHAv7hZDD6awYj713T0k4cRieh078IGpNNLVV
         dM06tCJWIji/6yGTGg54F72sq+NnP7K6kw2YE7bfBG7/1a8gJvqTUDjF/S+2xd8FEfZK
         dmZhHSiyj4QRlISJi8SAPqU/dCqqAfM9dIP+wowZAtBU3sfQW4qgi4iPDGP9UEl7Yo8o
         YIcQ==
X-Gm-Message-State: AC+VfDyO8ItB4nrZLT84OqflMidHf6hG7Rpun+6baGNsR9p4d44Zqkja
	jjnWNoQCp1kzPN7iS689zpQ8Sw==
X-Google-Smtp-Source: ACHHUZ5Fe46ETKwHMoSP+LQWs15Qfo6lZe1H4HUoEyej75n5s0+5nCJkv8ITV8euuQFu5SOXfMwVqw==
X-Received: by 2002:a17:907:86a3:b0:974:5403:ebb with SMTP id qa35-20020a17090786a300b0097454030ebbmr1057697ejc.54.1686305433918;
        Fri, 09 Jun 2023 03:10:33 -0700 (PDT)
Received: from [172.16.11.116] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id ks27-20020a170906f85b00b00977eec5bb2csm1088059ejb.156.2023.06.09.03.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 03:10:33 -0700 (PDT)
Message-ID: <9cd596d9-0ecb-29fc-fe18-f19b86a5ba44@rasmusvillemoes.dk>
Date: Fri, 9 Jun 2023 12:10:29 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
Content-Language: en-US, da
To: Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard@nod.at>, linux-hardening@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>
References: <20230607223755.1610-1-richard@nod.at>
 <202306071634.51BBAFD14@keescook> <ZIHzbBXlxEz6As9N@alley>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <ZIHzbBXlxEz6As9N@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 08/06/2023 17.27, Petr Mladek wrote:
> On Wed 2023-06-07 16:36:12, Kees Cook wrote:

> It seems that userspace implementation of sscanf() and vsscanf()
> returns -ERANGE in this case. It might be a reasonable solution.

Well. _Some_ userspace implementation does that. It's not in POSIX.
While "man scanf" lists that ERANGE error, it also explicitly says that:

CONFORMING TO
       The functions fscanf(), scanf(), and sscanf() conform to C89 and
C99 and POSIX.1-2001.  These standards do  not  specify  the
       ERANGE error.

I can't figure out what POSIX actually says should or could happen with
sscanf("99999999999999", "%i", &x);


> Well, there is a risk of introducing security problems. The error
> value might cause an underflow/overflow when the caller does not expect
> a negative value.

There is absolutely no way we can start letting sscanf() return a
negative err value, in exactly the same way we cannot possibly let
vsnprintf() do that. We can stop early, possibly with a WARNing if it's
the format string we're unhappy about ('cause that should be
compile-time constant or, e.g. in the netdevice name case, carefully
checked by the caller) and return "number of succesful conversions so
far" (scanf) / "number of bytes written to buffer" (printf).

> Alternative solution would be to update the "ip" code so that it
> reads the number separately and treat zero return value as
> -EINVAL.

The netdev naming code _could_ be updated to just not use scanf at all
or the bitmap of in-use numbers, just do the "sprintf(buf, fmt, i)" in a
loop and stop when the name is not in use. That's a win as long as there
are less than ~256 names already matching the pattern, but the
performance absolutely tanks if there are many more than that. So I
won't actually suggest that.

Rasmus


