Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095B4786FF
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfG2IGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:06:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33601 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfG2IGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:06:41 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so27130385plo.0;
        Mon, 29 Jul 2019 01:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=2pAUhDKwxtf6yA9o6haMqMvNurh2OyNtCVDu9kkP27Y=;
        b=ko33qF85rx7Kj/E/p5ck0ZVyIEiFrZO3mZoaMCfKVZZdYNT8mU2KWrXNMKiO5sI2q+
         /M6SFPAWaN9+AzqzI0E7Ta1p3yXmthvXvK2oGyn4lkJzELNMf5hovxHQ0XUIAPAHLrPt
         VrrGYOzKw/yLNVy7muXO9Bl/rvdOVzUr9Qp5B8wwTEWWnwHmMaS49eVI55TyzZdcQ8LG
         kmnLmZOOxcKyFGKjAsWVWvyOMgKNJO1L1cry8KR9wbTT1Q62enY+H4L3+ZWh08lcN1+d
         AkXIaYW+PCOj0vK4etWWQWxdbjYoBkXMC7CkxiiWAADMLcr0SryyCIyULLSFUgnkZlmA
         p2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2pAUhDKwxtf6yA9o6haMqMvNurh2OyNtCVDu9kkP27Y=;
        b=XqljnwzGxJP6A07Xf00O3QsGZkdMASDw0dggtyMDBplZZKEnDG0Nm0Imrj/hUTXBdy
         ytZZ9bdkKbfrqVey90Nv77kP4iRRYitDEJi5LynDo3h2diHRXEakdNe96msbJZLtTkyg
         OWE0o/+uqEQjLfaR/rlN1xn+jjxnNuUMaPltIXdHx1mbbxv54Vrk8pXKFcTU6RvUTeE/
         GcScTh2AK6fvTRrg92upXnQSaMrol2NxfDJCewvrKBHH704Cjgt+iZfUJCZHNq7q0dIi
         RUcf128DY53MCyrwcjb7lz/2m6QHAAuNTo/YOnuW8TYOvKLWQB+dPnQIzfPs2S6yceql
         16ZQ==
X-Gm-Message-State: APjAAAXXzkJ/8tQDBEq/43fiwTupTNsY6BJqcZeAbK42jRaSStTzsQO4
        6OTjW/mCZgDcsiaC1gBrMfXE6SaD
X-Google-Smtp-Source: APXvYqzWlcF99hbImVSj/76MU2Juyx+KoQQ8ntf0t7JlnSTTddjw79XM3FCs7jIlPfATgItJaejx/A==
X-Received: by 2002:a17:902:b612:: with SMTP id b18mr82187232pls.8.1564387600832;
        Mon, 29 Jul 2019 01:06:40 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id 21sm60230844pjh.25.2019.07.29.01.06.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 01:06:40 -0700 (PDT)
Subject: Re: [BUG] net: xfrm: possible null-pointer dereferences in
 xfrm_policy()
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <464bb93d-75b2-c21b-ee32-25a10ff61622@gmail.com>
 <20190729080341.GJ2879@gauss3.secunet.de>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <da903311-9fdb-d20a-9584-c35836947302@gmail.com>
Date:   Mon, 29 Jul 2019 16:06:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729080341.GJ2879@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/29 16:03, Steffen Klassert wrote:
> On Mon, Jul 29, 2019 at 11:43:49AM +0800, Jia-Ju Bai wrote:
>> In xfrm_policy(), the while loop on lines 3802-3830 ends when dst->xfrm is
>> NULL.
> We don't have a xfrm_policy() function, and as said already the
> line numbers does not help much as long as you don't say which
> tree/branch this is and which commit is the head commit.
>
>> Then, dst->xfrm is used on line 3840:
>>      xfrm_state_mtu(dst->xfrm, mtu);
>>          if (x->km.state != XFRM_STATE_VALID...)
>>          aead = x->data;
>>
>> Thus, possible null-pointer dereferences may occur.
> I guess you refer to xfrm_bundle_ok(). The dst pointer
> is reoaded after the loop, so the dereferenced pointer
> is not the one that had NULL at dst->xfrm.
>
>> These bugs are found by a static analysis tool STCheck written by us.
>>
>> I do not know how to correctly fix these bugs, so I only report them.
> I'd suggest you to manually review the reports of your
> tool and to fix the tool accordingly.

Oh, sorry for my mistakes.
I have found that dst is updated:
     dst = &xdst->u.dst;

I will fix my tool, thanks.


Best wishes,
Jia-Ju Bai
