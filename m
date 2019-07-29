Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A1478660
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 09:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfG2HcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 03:32:01 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37538 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfG2HcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 03:32:01 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so27179440plr.4;
        Mon, 29 Jul 2019 00:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=kchq7srFNNnQej0FuA0OClC0TaerJgYlzJ7LEi/VOUo=;
        b=bNjt42sboPYQB7y//DMTQDhTsSpnpt0//n63Gt7u2QeVZmOjHih58FEfRcxITnl7sd
         gscWwkd3Fg7xDMMZWAdB/yzW69PKf1fFp8eFNemclvm6+9gssvR2e3VRjafYw9coCOMi
         TjXjwovVU0EbyDimR5uRpYUB2Gl2hbOJfH5bCojm/lrVJhNlqg2KIkQZnUrgf4hlMKzS
         KWnOlWLBOB+yqDH3AFBfQMa1xzRqne5LiGhX2Vjw9jEWVxt+P6WfnpzCNt16i6d1FGe8
         TOO83BcpFaiZDKJk83BBcmnAugUp+7LEeP4P5nhUQlM5J6ngehRfzNyc3pGlaKA49PmN
         tb2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kchq7srFNNnQej0FuA0OClC0TaerJgYlzJ7LEi/VOUo=;
        b=A4n/dlccl4Hg6vGSPWU7sII5OTXTdB+9wxfU6ypbw+oEC6opCaC2fahwQ+k9cHHb0v
         kaAhJH8mWhJAkmh9ea9rpWSSIenrQJUA+JKrUHGqOv0LjrQTJCz9QcQqyfqqiKwyTyO7
         3zXnQ5vLAYlFvk1faxJ/5Vw8R0wnwTuiZFgm+bIYYTFMlrOb/yhSuihViIL4N1+og83o
         T3OLaqDXzZEGzG+pTauioJ72Ta2rFVJHTNawi6/JYHwUs52x8bUqi8KQwwJ+Ax8NGQgn
         BCvVIU/uJ9XzZFoWDibLpyWnBVHJyR6wlFJOzxaIdqoaTLv7JcKoJDadgVl24JjXDB+D
         Jf2Q==
X-Gm-Message-State: APjAAAUVTLjewypKo0j90zEcOiYlAAuA4U439pMXx5ltVCJU7RjqH4GZ
        KRbDXZYuyc4xJ2JliFt/XlQM8oIy
X-Google-Smtp-Source: APXvYqzksUM4T9kWfQkETZnrTNQlrjPAcYkIwFmRNDP0cDAYvvNt0zVFR9kJwPGQ8EtRj1kb+cJtjg==
X-Received: by 2002:a17:902:da4:: with SMTP id 33mr99311122plv.209.1564385520477;
        Mon, 29 Jul 2019 00:32:00 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id u134sm59112458pfc.19.2019.07.29.00.31.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 00:32:00 -0700 (PDT)
Subject: Re: [PATCH] net: sched: Fix a possible null-pointer dereference in
 dequeue_func()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190729022157.18090-1-baijiaju1990@gmail.com>
 <20190729065653.GA2211@nanopsycho>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <4752bf67-7a0c-7bc9-3d54-f18361085ba2@gmail.com>
Date:   Mon, 29 Jul 2019 15:32:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729065653.GA2211@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/29 14:56, Jiri Pirko wrote:
> Mon, Jul 29, 2019 at 04:21:57AM CEST, baijiaju1990@gmail.com wrote:
>> In dequeue_func(), there is an if statement on line 74 to check whether
>> skb is NULL:
>>     if (skb)
>>
>> When skb is NULL, it is used on line 77:
>>     prefetch(&skb->end);
>>
>> Thus, a possible null-pointer dereference may occur.
>>
>> To fix this bug, skb->end is used when skb is not NULL.
>>
>> This bug is found by a static analysis tool STCheck written by us.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Fixes tag, please?

Sorry, I do not know what "fixes tag" means...
I just find a possible bug and fix it in this patch.


Best wishes,
Jia-Ju Bai
