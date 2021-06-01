Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AC4397A5E
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhFATDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhFATDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 15:03:32 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA25EC06174A
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 12:01:49 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id bn21so13401648ljb.1
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 12:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RAu0njSTC+kf8drexs7MaZKoE+RFr/l6rpBisM//YE8=;
        b=Ubm1IKre509GEWJnIt1bo0fRJNfmHccoI20TkXQ9yfHdF/oebFoF8keJiNoiUOrs7X
         VfT4DycS9NU6tC6PB5TL9w1v0tqnoJiSrlqYUM0sNWE2MwixNys6XjGaG7v6mpXb57b7
         LWKaKfyXXz9TMrKN2/lbmduSACCMKLBdvT3SM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RAu0njSTC+kf8drexs7MaZKoE+RFr/l6rpBisM//YE8=;
        b=qs+HuSxfpJ8r7obMGvJFFjTPHtsf6Xv5D1DCgtCsXttjTm/c0RSSmsYqbSjG48DepH
         QtahnQ5HSQ41IYxH7mDwqBuL++ntrozuFeUJsLOYULgsialslvoeiuy+l7FIZ98g85lI
         vqWmjoO/DFyOQpKk2Ef2Bl8FTmpU8/Jumdg/ZuIO5jmo3B6MtS8XAwpRdrkuAiAgsS9g
         qwEKhFEB2mLEROWt+Xef8mYQE/1GFwXZcQIYrvFKscHRqKcQorifTJ/oyCA+gMVxTawB
         6DEOITYUXgC+O95/leh47ifiYjpFSZMgJbbn6PtbPLNS/X+K/aQ0R+P7caXULV9cVBOt
         7YKw==
X-Gm-Message-State: AOAM5326xs9CZsZuaDX7Ge+9//nwLRmAfYgpw5NKBHKla9ADK0dcbG4v
        M87SJJ8qzD3Rl0U+953X3V8n4g==
X-Google-Smtp-Source: ABdhPJw9s8bBsmzDHRpKgKg/J93DXW07RWbA/3WaPNRwJsVn9SJW571H6MDEnq3hSiz8E+K7r3/Pmg==
X-Received: by 2002:a05:651c:2c7:: with SMTP id f7mr22407178ljo.255.1622574107996;
        Tue, 01 Jun 2021 12:01:47 -0700 (PDT)
Received: from [172.17.20.140] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id g2sm2103831ljn.35.2021.06.01.12.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 12:01:47 -0700 (PDT)
Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
To:     Matthew Wilcox <willy@infradead.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Justin He <Justin.He@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org>
 <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLZSgZIcWyYTmqOT@casper.infradead.org>
 <CAHp75VfYgEtJeiVp8b10Va54QShyg4DmWeufuB_WGC8C2SE2mQ@mail.gmail.com>
 <YLZVwFh9MZJR3amM@casper.infradead.org> <YLZX9oicn8u4ZVCl@smile.fi.intel.com>
 <YLZcAesVG1SYL5fp@smile.fi.intel.com> <YLZoyjSJyzU5w1qO@casper.infradead.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <39f599a7-9175-f220-3803-b1920ddb8d40@rasmusvillemoes.dk>
Date:   Tue, 1 Jun 2021 21:01:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YLZoyjSJyzU5w1qO@casper.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2021 19.05, Matthew Wilcox wrote:

> Here's some examples, what do you think makes sense?
> 
> snprintf(buf, 16, "bad file '%pD'\n", q);
> 
> what content do you want buf to have when q is variously:
> 
> 1. /abcd/efgh
> 2. /a/bcdefgh.iso
> 3. /abcdef/gh
> 
> I would argue that
> "bad file ''\n"
> is actually a better string to have than any of (case 2)
> "bad file '/a/bc"
> "bad file 'bcdef"
> "bad file 'h.iso"
> 

Whatever ends up being decided, _please_ document that in
machine-readable and -verifiable form. I.e., update lib/test_printf.c
accordingly.

Currently (and originally) it only tests %pd because %pD is/was
essentially just %pd with an indirection to get the struct dentry* from
a struct file*.

The existing framework is strongly centered around expecting '/a/bc (see
all the logic where we do multiple checks with size 0, size random, size
plenty, and for the random case check that the buffer contents match the
complete output up till the randomly chosen size), so adding tests for
some other semantics would require a bit more juggling.

Not that that should be an argument in favor of that behaviour. But FWIW
that would be my preference.

Rasmus


