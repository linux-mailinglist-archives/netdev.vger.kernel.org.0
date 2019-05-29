Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9FE2E777
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfE2VaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:30:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46311 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2VaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:30:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so618615pgr.13
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 14:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zqIInZ7u9FocDA0H1JcIPg2m8dIqSr989gc/4vOLzf4=;
        b=AlVOqlZGnq7FyKZWP7f3RfIPaxELGMjnkN0opwHogt0VTYHJ6GBPRm/4PVKVbA7RW4
         Jwwj8GzrcUB8RHJVRpsjcH6J2d9DHg7OYQJgFtZqDtbyUVV55de+V3tVP8zcfKjrqsRF
         J953PZXQ+QHTchz77pjADNUUikSn/cgyrMgWnoA3F6qvai4GxMewEmWYfF0v5lbAdAgA
         wQf/mVqSIloGK5tM95Gl6cXjI0oqqePspAUsddTO+qCidFmE6WvvltHFwV5/A1P1XRTl
         GuuUT089yZOSKZTvy0cVkcHdxzbnyTFuLpnyywDhD/XtcF98AICd7nOutlhAhK7cCROU
         dv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zqIInZ7u9FocDA0H1JcIPg2m8dIqSr989gc/4vOLzf4=;
        b=GyWKyn1Dk+ItSjVVnNP6tQPlhPnQ02kq1SNoNkgCw5D3JPnLEoNBNSXE6WTZyBPj/2
         qYJ5xZSZ4g2FsD2xrkU3In9lzI4KRjjK8Qhk7WWSXMTcS6lUKIGbkUwsZ+iknqaMu8dn
         TQo5UhetmyFSy2HLBl0nR/KvuhkpPHiWm4X6hOCNVypgmTqCp/w+b4MQKvzI7HkaoLFc
         2Xt/kJSgL76KHl5yBhovQpDsGngHWWLoFVCs/DSM1wR7+ve8fQTwwX+1QakX3h4Bgy++
         lLGRPtXv7tG8O7yhSuA36pA+11SGyqYL13ETNU+triuOYaR4WFdX15tCm+HU7TyxT9L2
         BRWg==
X-Gm-Message-State: APjAAAWf92m9yL/D5mOEzbp+Pg3Xe49uiQws0bKO1dlPawdyPzZjJHnu
        TTw0tyLcq7r/LJDaWchUs0flSS2u
X-Google-Smtp-Source: APXvYqz5vYtnNVBiVS8jyXQdVWJcLfi9fdD6C17t//mYShsvfvpysQa3s80GIe4uAbbBdekVfAkSZQ==
X-Received: by 2002:a17:90a:a516:: with SMTP id a22mr15132845pjq.27.1559165418796;
        Wed, 29 May 2019 14:30:18 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id h3sm707278pfq.66.2019.05.29.14.30.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:30:17 -0700 (PDT)
Subject: Re: [PATCH] inet: frags: Remove unnecessary
 smp_store_release/READ_ONCE
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20190524160340.169521-12-edumazet@google.com>
 <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <28815527-83bd-b139-a162-0ed927b88fe5@gmail.com>
Date:   Wed, 29 May 2019 14:30:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/19 10:40 PM, Herbert Xu wrote:

> I see now that it is actually relying on the barrier/locking
> semantics of call_rcu vs. rcu_read_lock.  So the smp_store_release
> and READ_ONCE are simply unnecessary and could be confusing to
> future readers.
> 
> ---8<---
> The smp_store_release call in fqdir_exit cannot protect the setting
> of fqdir->dead as claimed because its memory barrier is only
> guaranteed to be one-way and the barrier precedes the setting of
> fqdir->dead.
> 
> IOW it doesn't provide any barriers between fq->dir and the following
> hash table destruction.
> 
> In fact, the code is safe anyway because call_rcu does provide both
> the memory barrier as well as a guarantee that when the destruction
> work starts executing all RCU readers will see the updated value for
> fqdir->dead.
> 
> Therefore this patch removes the unnecessary smp_store_release call
> as well as the corresponding READ_ONCE on the read-side in order to
> not confuse future readers of this code.  Comments have been added
> in their places.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

David, this targets net-next tree :)


