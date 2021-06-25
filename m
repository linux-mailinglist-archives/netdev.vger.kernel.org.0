Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EDA3B3B38
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 05:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhFYDiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 23:38:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233041AbhFYDiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 23:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624592194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n6YWGZCgKdORiyTIspLBMoxf3AjxZ1H1bG+LhjiRSD4=;
        b=TTVOLjYtD2jTnBzuozcWzxQrfavHmYrmZsAEv5iO9TrD7CVcgUB3nXVwmEkP116b8UQPcU
        /brg66Z/IR2S1+uJIOnoSmpt0uFM6g5ugSm6WDreNfBMgtvu8fwSo1x9dnq4rElqzGCI9U
        QEje9sOL7dcgtwOt1yR3bPzbpNKTUqM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-ZEoD4BVSN9K0vrYOyx437g-1; Thu, 24 Jun 2021 23:36:32 -0400
X-MC-Unique: ZEoD4BVSN9K0vrYOyx437g-1
Received: by mail-pg1-f197.google.com with SMTP id k9-20020a63d1090000b029021091ebb84cso5210860pgg.3
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 20:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=n6YWGZCgKdORiyTIspLBMoxf3AjxZ1H1bG+LhjiRSD4=;
        b=CxL1WRcqcP+EmbOpmG3xCq61tGcwbhfTytUgDhClhR7CW+iKNVoX7tqnvtjJ9F4r/Q
         0IBegv0st+zCuxfKSnZ00oZw8/hKpSvD7/GMgYiEs+86qDE4t9MHtqvhAun+PXtCt9Xs
         LFTpEe1wBhUXocLs6l5cWEaBeQlEn9+YCF/1k1QG5Gf3Gw4vX3S+Wa959V1azJWtZKe4
         xLft2bIkDykfoZ7ncQVDe1PGRGxsOpVnFn8Vg283TqiGxqmw1wc8nNH5J9ITmJdqf34h
         zLQTLjQ/kk91osmXakFH1N4IUkuyqMY9rdMdbYsS3MdvU3DJH5vKTAyJM2F6b7fNLh3w
         kYHA==
X-Gm-Message-State: AOAM531dBrZv2cZW1KusGuT9YWyzk+rvWB+CE8vngbxomUbljkg580il
        qG6lMQQeUxysxx/dD0l9QFrfALF/zX0/9xZ4l1TU718TEdV8FIkuIJmucO6eZfuIxnSifbU+ZjL
        CWUXhZ0nn4UejcqqI
X-Received: by 2002:a62:1914:0:b029:304:502e:8a4c with SMTP id 20-20020a6219140000b0290304502e8a4cmr8395205pfz.63.1624592191580;
        Thu, 24 Jun 2021 20:36:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoLNm1pYRdlFPxoooLwqhPAkuDyU5Xx85yhUXY44HZvMOs5voXOZZ4mcLAUSUMRHvm/vxt4g==
X-Received: by 2002:a62:1914:0:b029:304:502e:8a4c with SMTP id 20-20020a6219140000b0290304502e8a4cmr8395183pfz.63.1624592191332;
        Thu, 24 Jun 2021 20:36:31 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y206sm3980669pfb.3.2021.06.24.20.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 20:36:30 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/2] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com
Cc:     brouer@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        will@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linuxarm@openeuler.org
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-2-git-send-email-linyunsheng@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ff47ed0b-332d-2772-d6e1-8277ac602c8c@redhat.com>
Date:   Fri, 25 Jun 2021 11:36:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624591136-6647-2-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/25 ÉÏÎç11:18, Yunsheng Lin Ð´µÀ:
> Currently ptr_ring selftest is embedded within the virtio
> selftest, which involves some specific virtio operation,
> such as notifying and kicking.
>
> As ptr_ring has been used by various subsystems, it deserves
> it's owner's selftest in order to benchmark different usecase
> of ptr_ring, such as page pool and pfifo_fast qdisc.
>
> So add a simple application to benchmark ptr_ring performance.
> Currently two test mode is supported:
> Mode 0: Both enqueuing and dequeuing is done in a single thread,
>          it is called simple test mode in the test app.
> Mode 1: Enqueuing and dequeuing is done in different thread
>          concurrently, also known as SPSC(single-producer/
>          single-consumer) test.
>
> The multi-producer/single-consumer test for pfifo_fast case is
> not added yet, which can be added if using CAS atomic operation
> to enable lockless multi-producer is proved to be better than
> using r->producer_lock.
>
> Only supported on x86 and arm64 for now.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>   MAINTAINERS                                      |   5 +
>   tools/testing/selftests/ptr_ring/Makefile        |   6 +
>   tools/testing/selftests/ptr_ring/ptr_ring_test.c | 249 +++++++++++++++++++++++
>   tools/testing/selftests/ptr_ring/ptr_ring_test.h | 150 ++++++++++++++
>   4 files changed, 410 insertions(+)


Why can't you simply reuse tools/virtio/ringtest?

Thanks

