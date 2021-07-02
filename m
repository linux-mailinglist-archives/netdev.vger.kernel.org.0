Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F84C3B9C4B
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 08:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhGBGsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 02:48:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhGBGsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 02:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625208361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/O7c7KS2ZRVdGMFFd2++Ca50pPlbd5UuZ6yNPi6lDAE=;
        b=OOEWvbyHNM6LRwtYS1ETPiGzZpoQa+Z5LSKcwqf6QvJtincWbKdwzOH9DRb98i6bJU0+et
        /o3/l4Z8FZYleoz5RFpfYKMyHVfMV39rgpLNHFgheellnqjpjN1F2P3+wDNURR+XQ6oOOr
        pjqNLFHgUYlkaM41O9PdbVXOxfWxyxE=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-1zrLFOm5OoyPt-ziJ61ESw-1; Fri, 02 Jul 2021 02:46:00 -0400
X-MC-Unique: 1zrLFOm5OoyPt-ziJ61ESw-1
Received: by mail-pg1-f197.google.com with SMTP id k9-20020a63d1090000b029021091ebb84cso5997724pgg.3
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 23:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/O7c7KS2ZRVdGMFFd2++Ca50pPlbd5UuZ6yNPi6lDAE=;
        b=Y8G7CUB7T7x3kmL16TySqBiUauroQ48C5Cm8kCCeJFBXdoO2ey/thiPY2SgkqkRa9N
         KkvVbXb3RtNwO0C8IuzHQPwB+EQD5BfSAboln9LaSbQ/TBVUpUAF6Ydpvwauj5kYMP56
         q+3US7Ha55e8DxVRmvUhjDd+THN1k0tP8PfY9dhMjVVd1OK1E0xGj5bbVU+LsdTcER3P
         b4x1c7NyRI0SpyQSwDZiJdOmtTnjYKU4yv27KNHl12AEnSkMFxtXD4mqQSZ/n4X4ayfp
         nh3cGzBwD7qnyA7RtkxyngNfHkvDf9vqpr05Q5ClypV5o96rKzoJENckVw8DKaZ6fmGt
         HQ0w==
X-Gm-Message-State: AOAM530aaowk4v7QmFWxVke7D65hcC/iBE+ZhF3wc4kHd1xgD6yfq6gB
        17WlHmDdnttJ7p7UJzolp6eAKpXfVBHYIffNddg5zFIW2O/LiSIgtOQ0Aoe1orKxfdyTd/SZOSZ
        R/bHjS+7ue25Gnfph
X-Received: by 2002:a63:ed0a:: with SMTP id d10mr3764628pgi.82.1625208359774;
        Thu, 01 Jul 2021 23:45:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwU+krQrKYmsENaTEujQlDuGhxlA9ecxy+LPSz2UsXhoDQ0XnvGZd7MU4dmQcB4bDlyIo4deQ==
X-Received: by 2002:a63:ed0a:: with SMTP id d10mr3764604pgi.82.1625208359591;
        Thu, 01 Jul 2021 23:45:59 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w123sm1770215pff.152.2021.07.01.23.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 23:45:58 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/3] ptr_ring: move r->queue[] clearing after
 r->consumer_head updating
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com
Cc:     brouer@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        will@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linuxarm@openeuler.org
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-3-git-send-email-linyunsheng@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <230f0b91-fe92-c53f-4df0-ec36c7c6e223@redhat.com>
Date:   Fri, 2 Jul 2021 14:45:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1625142402-64945-3-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/1 ÏÂÎç8:26, Yunsheng Lin Ð´µÀ:
> Currently r->queue[] clearing is done before r->consumer_head
> updating, which makes the __ptr_ring_empty() returning false
> positive result(the ring is non-empty, but __ptr_ring_empty()
> suggest that it is empty) if the checking is done after the
> r->queue clearing and before the consumer_head moving forward.
>
> Move the r->queue[] clearing after consumer_head moving forward
> to avoid the above case.
>
> As a side effect of above change, a consumer_head checking is
> avoided for the likely case, and it has noticeable performance
> improvement when it is tested using the ptr_ring_test selftest
> added in the previous patch.
>
> Tested using the "perf stat -r 1000 ./ptr_ring_test -s 1000 -m 1
> -N 100000000", comparing the elapsed time:
>
>   arch     unpatched           patched       improvement
> arm64    2.087205 sec       1.888224 sec      +9.5%
>   X86      2.6538 sec         2.5422 sec       +4.2%


I think we need the number of real workloads here.

Thanks


>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V3: adjust the title and comment log according to disscusion in
>      V2, and update performance data using "perf stat -r".
> V2: Add performance data.
> ---
>   include/linux/ptr_ring.h | 25 ++++++++++++++++---------
>   1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 808f9d3..db9c282 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>   	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>   	 * to work correctly.
>   	 */
> -	int consumer_head = r->consumer_head;
> -	int head = consumer_head++;
> +	int consumer_head = r->consumer_head + 1;
>   
>   	/* Once we have processed enough entries invalidate them in
>   	 * the ring all at once so producer can reuse their space in the ring.
> @@ -271,19 +270,27 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>   	 */
>   	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
>   		     consumer_head >= r->size)) {
> +		int tail = r->consumer_tail;
> +
> +		if (unlikely(consumer_head >= r->size)) {
> +			r->consumer_tail = 0;
> +			WRITE_ONCE(r->consumer_head, 0);
> +		} else {
> +			r->consumer_tail = consumer_head;
> +			WRITE_ONCE(r->consumer_head, consumer_head);
> +		}
> +
>   		/* Zero out entries in the reverse order: this way we touch the
>   		 * cache line that producer might currently be reading the last;
>   		 * producer won't make progress and touch other cache lines
>   		 * besides the first one until we write out all entries.
>   		 */
> -		while (likely(head >= r->consumer_tail))
> -			r->queue[head--] = NULL;
> -		r->consumer_tail = consumer_head;
> -	}
> -	if (unlikely(consumer_head >= r->size)) {
> -		consumer_head = 0;
> -		r->consumer_tail = 0;
> +		while (likely(--consumer_head >= tail))
> +			r->queue[consumer_head] = NULL;
> +
> +		return;
>   	}
> +
>   	/* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>   	WRITE_ONCE(r->consumer_head, consumer_head);
>   }

