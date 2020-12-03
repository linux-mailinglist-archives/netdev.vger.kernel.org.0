Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB52CCB37
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgLCArm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:47:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728730AbgLCArj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606956373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tn3Df7eygk6Izda6RvZQkxxok8dSHVZu45DeLEEIxTY=;
        b=RNA3WxthAPhDwx/CZ/6WFE4Rh2yRrBeQPgUAE5F8EHT1BfTBVajVbpneKdJzwf68H0V1AM
        /chZ7QnQg/10K/hm31Ns2EEHs4cTDeAmuO2b0ii80estkkyt8DaaHft81S0aCPz64IwxR8
        NF5rTpcQGE1GArOXem8RkG4Z9Qy+hZg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-7geWzDP_PdCseJo2OXgpjw-1; Wed, 02 Dec 2020 19:46:10 -0500
X-MC-Unique: 7geWzDP_PdCseJo2OXgpjw-1
Received: by mail-qt1-f199.google.com with SMTP id n95so245104qte.16
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 16:46:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tn3Df7eygk6Izda6RvZQkxxok8dSHVZu45DeLEEIxTY=;
        b=cyLGm17z6rGp3RIcL1yOdHJrywklFXXe2vOhwRdkMX68mzgwh48mtgOKf9CZvS2D3G
         wsT32C7KZBI9kvyrPQAFiLN2utGblNj/DGHcL7b444EO2pjxm3HSx7IsBNiye+pMGneb
         0RbzE+wYpmpuq1xeX+jqjabUOT4cxBqrPiwhqNG8a3gYMgVZPdgSU//XrNQYr9WrVw3l
         vQH2K+6cBcZIH9HZnU1GCYkLt12cMJIoBQqV76FcMEt3/5YOga0DPq3a8RtA1GR9E70y
         LjhlNQKEyZoIu8q0YD3zXy6lWWrS1qlEXQmFnRG8+v4Oj4jD1jORNaPzY91MuIN/Xhve
         TzKg==
X-Gm-Message-State: AOAM533SUyKvjgugJ4dz8/t/NjDf8pL7VSFX6glIDeMZ/p/KSdNJBfX7
        M6Fb/r+d8kbarayMgGKXSSMR3NY/aiisRKrwooUqfSvIq+L9cXc7yk+bmtYqkGfx9XNW7EFj/CD
        WHg1KDTWEK1Nq8X9v
X-Received: by 2002:a37:7145:: with SMTP id m66mr516127qkc.396.1606956369586;
        Wed, 02 Dec 2020 16:46:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaQv8hATwzHtFhNcgeEgzuieWjSpIuQkb2SlVf60UIlQ0qMAa0FWuaYoO5eZoFUPJPsB6hRw==
X-Received: by 2002:a37:7145:: with SMTP id m66mr515968qkc.396.1606956367260;
        Wed, 02 Dec 2020 16:46:07 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id a6sm347081qkg.136.2020.12.02.16.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 16:46:06 -0800 (PST)
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
 <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
 <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com>
 <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
 <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <7ca84085-f8e1-6792-7d1c-455815986572@redhat.com>
Date:   Wed, 2 Dec 2020 16:46:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/2/20 2:34 PM, Nick Desaulniers wrote:
> On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>>
>>> Yeah, we could go through and remove %h and %hh to solve this, too, right?
>> Yup.
>>
>> I think one of the checkpatch improvement mentees is adding
>> some suggestion and I hope an automated fix mechanism for that.
>>
>> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/
> + Tom, who's been looking at leveraging clang-tidy to automate such
> treewide mechanical changes.
> ex. https://reviews.llvm.org/D91789

This looks like a good one to automate.

If you don't mind, I'll give it a try next.

Need a break from semicolons ;)

Tom

>
> See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
> use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
> related context.

