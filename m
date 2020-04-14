Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE4B1A782C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 12:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438183AbgDNKLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 06:11:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59414 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438130AbgDNKLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 06:11:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586859100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D19atvj1EDDaX34zHqvHJsCmVyR2GBDOTXVYJehpBEo=;
        b=alqpfRmNAFWpAmK8PY/vr3kOsoSPZkj0CysNsnOxhFkBQi2k9xjuDjJtiBXDaR+Vbvjilc
        EKzFElUahAnd7LF1D+0AtbyORNYvAQ7r0RrSGC89Sc+w+6+sXnrjTmHwLhcormH5nVP5Qq
        zGLRkqFRlwnIUnp5Q7GRcqY7iWdDi6Q=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-AJ1s8Yh9PFuupYqDObHk4Q-1; Tue, 14 Apr 2020 06:11:38 -0400
X-MC-Unique: AJ1s8Yh9PFuupYqDObHk4Q-1
Received: by mail-lf1-f69.google.com with SMTP id t194so4797018lff.20
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 03:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=D19atvj1EDDaX34zHqvHJsCmVyR2GBDOTXVYJehpBEo=;
        b=Jsn5fPsU+QN+MsUPwTSdBFbSZhqkwIdoORvq670eugq1Nrc06MewsvCzG4gn1AZQZD
         8+PLe8zpP0+FidQguNS7DLnk92KblkjxIXSfbY5yLULpm+e7v+Fo5uC0IdSWMiWd+Eh4
         +1FJAsb0Tfxj/nstjEeWKUaLreAoDcSMobu/ZHLjcl6YToKJOtdaWIHIS8KnYKgCs0rw
         hXEb9R5EIjV/uEd/v75l5YZpo60W4luF5SVXvKG5ylhNBHVi+55uvm5lpqwhEsq6t3xI
         gxstiWGLazQs4QcaX1YtCGsX76lGT9XQMZYYGdqdRDmOXDfrRosWeFy9HDNMx2I8BAyY
         5p3g==
X-Gm-Message-State: AGi0PuZT70/wKLvvQAD8BLu/HqHysZFH5wD5hOizyPCbkwx2RbxJQG+N
        +ZieTZsyJzOrea9i/VdZh2YPCrnAyPTFU3ryvLjzrspUAS8Qpm9bVTDIZchnN4dzptyr3gKzykj
        zSxW5bMzlAkhSNoyk
X-Received: by 2002:ac2:528f:: with SMTP id q15mr4889325lfm.132.1586859096598;
        Tue, 14 Apr 2020 03:11:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypISwM5fXffbYEAXsfiMzCS5vQv7dNXolVgJwryaOwSZ+r86BacwyJKvMR5hfnTSGx/FFYKt8A==
X-Received: by 2002:ac2:528f:: with SMTP id q15mr4889309lfm.132.1586859096344;
        Tue, 14 Apr 2020 03:11:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p23sm9931615lfc.95.2020.04.14.03.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 03:11:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CBD0A181586; Tue, 14 Apr 2020 12:11:33 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, brouer@redhat.com
Subject: Re: [PATCH RFC v2 29/33] xdp: allow bpf_xdp_adjust_tail() to grow packet size
In-Reply-To: <20200414115656.2f0e6ac0@carbon>
References: <158634658714.707275.7903484085370879864.stgit@firesoul> <158634678170.707275.10720666808605360076.stgit@firesoul> <20200414115656.2f0e6ac0@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Apr 2020 12:11:33 +0200
Message-ID: <87v9m2nzqi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Wed, 08 Apr 2020 13:53:01 +0200 Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 7628b947dbc3..4d58a147eed0 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3422,12 +3422,26 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>>  
>>  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>>  {
>> +	void *data_hard_end = xdp_data_hard_end(xdp);
>>  	void *data_end = xdp->data_end + offset;
>>  
> [...]
>> +	/* DANGER: ALL drivers MUST be converted to init xdp->frame_sz
>> +	 * - Adding some chicken checks below
>> +	 * - Will (likely) not be for upstream
>> +	 */
>> +	if (unlikely(xdp->frame_sz < (xdp->data_end - xdp->data_hard_start))) {
>> +		WARN(1, "Too small xdp->frame_sz = %d\n", xdp->frame_sz);
>> +		return -EINVAL;
>> +	}
>> +	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
>> +		WARN(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
>> +		return -EINVAL;
>> +	}
>
> Any opinions on above checks?
> Should they be removed or kept?
>
> The idea is to catch drivers that forgot to update xdp_buff->frame_sz,
> by doing some sanity checks on this uninit value.  If I correctly
> updated all XDP drivers in this patchset, then these checks should be
> unnecessary, but will this be valuable for driver developers converting
> new drivers to XDP to have these WARN checks?

Hmm, I wonder if there's a way we could have these kinds of checks
available, but disabled by default? A new macro (e.g.,
XDP_CHECK(condition)) that is only enabled when some debug option is
enabled in the kernel build, perhaps? Or just straight ifdef'ing them
out, but maybe a macro would be generally useful?

-Toke

