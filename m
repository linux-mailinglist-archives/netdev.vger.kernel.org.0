Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286A7102F3C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKSWXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:23:07 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35211 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfKSWXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:23:07 -0500
Received: by mail-pg1-f193.google.com with SMTP id k32so6506567pgl.2
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 14:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=M5GRkEBdJHNNqdaohu1pw7PtQbpWPXTd1qAJLCs6/IM=;
        b=QCz2MmAD3+fh/Uzm4+tc/Xky3O0vcMMRqjrtxDjbH4QJaIqUOmNT2+kKrpEG8E0bXM
         Yxd6lyJDtQk+dxUU5SXBZQn+yvbKBdroAhe/fuKrggiDrMg2Pn9Jlc3fWF84IanjrEl4
         tknSBE5RM9He5B4LGFAp4Rj+KOyU8RSX8ob9xdj1XJzCzCgYM9xwFUnVVq03j5+5EAE/
         0fzeapagiKsYDuVMfd2IfOeDvVwxyTRMO882T68YYyErBpo6IrzrZVYYdCse3qM3NAc0
         clyaPT1fWYfDe6btJX3PAzcH8VOAjZksXMTmzMjGfrH22zbntHZYN3Uk7OrESrslbEp0
         ZHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=M5GRkEBdJHNNqdaohu1pw7PtQbpWPXTd1qAJLCs6/IM=;
        b=jdADYPP3Wg5+nwgKsMbQrd0I8sZBjFweVSQBw9Y6T3VG6WKsiDzH2g5AHfMwQ3iv0F
         ErtHTnTgexdT6rwESagWtHxhwlZSnpxkoWLyCeyWadrs6dlOWzlHbaj7qu5d3+YH+Okn
         GRHuhKWR8J57yN9+U7LvxqTcTGKZIOdTs4G0t2YzYE4NfR2OxRdxwC6UtQD/hoMEW1zg
         BU+gRpWyH1lVtTJHNDJmOsJZjtMDbtXxC083DvjBYI20kXV9Sg/lbSJgRTJUpMxSVeM0
         1OIVJZ9d6CbG47EishcXpXDSu86iWbtj1BFK1KRt74i9gA4rhuwcgjUEPSIjcbM9NHk8
         zUlw==
X-Gm-Message-State: APjAAAXuN0dSnvwqXl3/car1KprAHgzDX9aJjoMB7MemJMQomh/5uIab
        kR2JSFNkAoEaTiNC8MZbquA=
X-Google-Smtp-Source: APXvYqzEZzbZ9LilAAWRhwT1nWcCTtr5IHkH8fyXRD2alzTRzDNeCjvkmcbfnwo49NiE/DtDXMoIWg==
X-Received: by 2002:a62:7f93:: with SMTP id a141mr8601242pfd.82.1574202186581;
        Tue, 19 Nov 2019 14:23:06 -0800 (PST)
Received: from [172.20.54.79] ([2620:10d:c090:200::3:5953])
        by smtp.gmail.com with ESMTPSA id w19sm25560833pga.83.2019.11.19.14.23.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 14:23:05 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Lorenzo Bianconi" <lorenzo.bianconi@redhat.com>
Cc:     "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org, mcroce@redhat.com
Subject: Re: [PATCH v4 net-next 3/3] net: mvneta: get rid of huge dma sync in
 mvneta_rx_refill
Date:   Tue, 19 Nov 2019 14:23:05 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <188EF030-DAB4-4FD0-AFD1-107C24A10943@gmail.com>
In-Reply-To: <20191119153827.GE3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <7bd772e5376af0c55e7319b7974439d4981aa167.1574083275.git.lorenzo@kernel.org>
 <20191119123850.5cd60c0e@carbon>
 <20191119121911.GC3449@localhost.localdomain>
 <20191119155143.0683f754@carbon>
 <20191119153827.GE3449@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Nov 2019, at 7:38, Lorenzo Bianconi wrote:

> [...]
>>>>> -		page_pool_recycle_direct(rxq->page_pool,
>>>>> -					 virt_to_head_page(xdp->data));
>>>>> +		__page_pool_put_page(rxq->page_pool,
>>>>> +				     virt_to_head_page(xdp->data),
>>>>> +				     xdp->data_end - xdp->data_hard_start,
>>>>> +				     true);
>>>>
>>>> This does beg for the question: Should we create an API wrapper for
>>>> this in the header file?
>>>>
>>>> But what to name it?
>>>>
>>>> I know Jonathan doesn't like the "direct" part of the  previous 
>>>> function
>>>> name page_pool_recycle_direct.  (I do considered calling this 
>>>> 'napi'
>>>> instead, as it would be inline with networking use-cases, but it 
>>>> seemed
>>>> limited if other subsystem end-up using this).
>>>>
>>>> Does is 'page_pool_put_page_len' sound better?
>>>>
>>>> But I want also want hide the bool 'allow_direct' in the API name.
>>>> (As it makes it easier to identify users that uses this from 
>>>> softirq)
>>>>
>>>> Going for 'page_pool_put_page_len_napi' starts to be come rather 
>>>> long.
>>>
>>> What about removing the second 'page'? Something like:
>>> - page_pool_put_len_napi()
>>
>> Well, we (unfortunately) already have page_pool_put(), which is used
>> for refcnt on the page_pool object itself.
>
> __page_pool_put_page(pp, data, len, true) is a more generic version of
> page_pool_recycle_direct where we can specify even the length. So what 
> about:
>
> - page_pool_recycle_len_direct
> - page_pool_recycle_len_napi

I'd suggest:

/* elevated refcounts, page may seen by networking stack */
page_pool_drain(pool, page, count)              /* non napi, len = -1 */
page_pool_drain_direct(pool, page, count)       /* len = -1 */

page_pool_check_put_page(page)                  /* may not belong to 
pool */

/* recycle variants drain/expect refcount == 1 */
page_pool_recycle(pool, page, len)
page_pool_recycle_direct(pool, page, len)

page_pool_put_page(pool, page, len, mode)	    /* generic, for 
__xdp_return */


I'd rather add len as a parameter, than add more wrapper variants.
-- 
Jonathan


>
> Regards,
> Lorenzo
>
>>
>> -- 
>> Best regards,
>>   Jesper Dangaard Brouer
>>   MSc.CS, Principal Kernel Engineer at Red Hat
>>   LinkedIn: http://www.linkedin.com/in/brouer
>>
