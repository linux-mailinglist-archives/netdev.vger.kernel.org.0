Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C1E281A59
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbgJBSBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgJBSBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 14:01:08 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3E5C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 11:01:08 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g9so765244pgh.8
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 11:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=44IM2n2A6dHJLyjqFwV42IbtgnaCN/W1DstGsAhBASA=;
        b=jeC6f2o+XvI3gAHqqClbK3PgWQFek4Byq8qygRrmk/cHle5spkPW8wbGitL7ZAB9Bz
         cfA/nmL/BP+QhWhnLuwBTzsjW8IZtBlNf36jZICQs7HkM2FZWcU4KDOe//U1b5kCg7r+
         p/2jyAEY2Gg4eFMi/89BtkkdEPuJuQXDce13yrkLvnU+tb+x35EiBa1uwj3g+5DAyGhd
         P4l5jtIFJtwsfBDWxAlIu7ePvABHedgLa8HhyMCsse5nyXMisd02NHsPmwUCs5d9OUhA
         PT3SW/uqbylWMxuOHBlR5WsCu2Iif2wj75kCwhptHVEaDBGtXXpF5xRtJJaVaCQdTJ+a
         hyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=44IM2n2A6dHJLyjqFwV42IbtgnaCN/W1DstGsAhBASA=;
        b=pJ9kTVt8p1pwWq+3XbCsnBO6S/Y7f2D4KwJmYKzGjOLfqJZkDqeEYM0yOPTILftKwl
         R2TEjcSK6zsJqRsZJXeY3IwsvwSWOFGK9znpBtrdGycHV3VvnQVIJMv3I1fFtXJ8GYtV
         OatRGP1H9AW6cEeq5BzBJWPL+CACLFyYkxNrcKY465YmZC1rCnV2Ubs4Im6cw5X8yS0T
         Y/hYz9b5zv1k72FVhlcfmMNp2jzYfdM5if+AjgXZIRv4283TfK4FNjTaSaR1u7kuKO5Q
         /IohkxOS2W+lURu35h+HHmCfLFmiU2ki7SAuIBNzQXjxxa7je1th5pTbSHADjNAhu9Zj
         Fk2Q==
X-Gm-Message-State: AOAM530mssMp89YzC5kPK3ZYJESf6nR5Rbb8lpIlRrRn1rKpWPqIDXNp
        w0/ThSkUBGjQF9UgnTxQmHMXZWKIAhE=
X-Google-Smtp-Source: ABdhPJwwtVbXDZR8z4FAOWQLJJHq/rN77N2tLxNUD0SWE1xPL4Jra28+3N/aNOZr4uBknoWVCS3nQg==
X-Received: by 2002:a62:88c6:0:b029:151:fa4e:a52f with SMTP id l189-20020a6288c60000b0290151fa4ea52fmr3832274pfd.50.1601661667735;
        Fri, 02 Oct 2020 11:01:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id i62sm2793920pfe.140.2020.10.02.11.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 11:01:05 -0700 (PDT)
Subject: Re: [PATCH] genl: ctrl: print op -> policy idx mapping
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
References: <20201002102609.224150-1-johannes@sipsolutions.net>
 <248a5646-9dc8-c640-e334-31e9d50495e8@gmail.com>
 <58172ec0f7e74c63206121bf6d8f02481f47ee5a.camel@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <661566db-8fb2-85a2-3147-821c4cb26a1f@gmail.com>
Date:   Fri, 2 Oct 2020 11:01:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <58172ec0f7e74c63206121bf6d8f02481f47ee5a.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/20 7:39 AM, Johannes Berg wrote:
> On Fri, 2020-10-02 at 07:29 -0700, David Ahern wrote:
>> On 10/2/20 3:26 AM, Johannes Berg wrote:
>>> diff --git a/genl/ctrl.c b/genl/ctrl.c
>>> index 68099fe97f1a..c62212b40fa3 100644
>>> --- a/genl/ctrl.c
>>> +++ b/genl/ctrl.c
>>> @@ -162,6 +162,16 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>>>  		__u32 *ma = RTA_DATA(tb[CTRL_ATTR_MAXATTR]);
>>>  		fprintf(fp, " max attribs: %d ",*ma);
>>>  	}
>>> +	if (tb[CTRL_ATTR_OP_POLICY]) {
>>> +		const struct rtattr *pos;
>>> +
>>> +		rtattr_for_each_nested(pos, tb[CTRL_ATTR_OP_POLICY]) {
>>> +			__u32 *v = RTA_DATA(pos);
>>> +
>>> +			fprintf(fp, " op %d has policy %d",
>>> +				pos->rta_type, *v);
>>
>> did you look at pretty printing the op and type? I suspect only numbers
>> are going to cause a lot of staring at header files while counting to
>> decipher number to text.
> 
> I didn't really, but it's also rather tricky?
> 
> The policy index can't be pretty printed anyway, it's literally an
> ephemeral index that's valid only within that dump operation. Not that a
> next one might be different, but if you change the kernel it may well
> be.
> 
> Pretty-printing the op would mean maintaining all those strings in the
> policy (or so) in the kernel? That seems like a _lot_ of memory usage
> (as well as new code), just for this?

does not have to be in the kernel. Usability is important. Since you
have this compiled and easy to test, what is an example of the output
for this dump?

