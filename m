Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1FC1E468E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389399AbgE0O5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:57:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33086 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388738AbgE0O5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 10:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590591437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TIvw6lDhli3JrGwOo8HeQxQ8QQ7gtpt0DCImFAiegBo=;
        b=PplELDCu63ibxKsYTCzoXGPZbWmOWt9vKnwT4sfLBsqoPD0UnrqlZuzUakQr0BqIzt/Xug
        nmKLTdp1bvwNQXYtmFXL0VKCWET+qsp08KiHo9popGWLrpXXZWSmoALMcFIhL/MGCiTVym
        U5dpbrVK7mJPDaXUkHQ0Bgt37zopCl0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-ejfmp1PfNe6n58qipsoJ2A-1; Wed, 27 May 2020 10:57:16 -0400
X-MC-Unique: ejfmp1PfNe6n58qipsoJ2A-1
Received: by mail-ed1-f70.google.com with SMTP id dk23so10217494edb.15
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TIvw6lDhli3JrGwOo8HeQxQ8QQ7gtpt0DCImFAiegBo=;
        b=Yrz48ZeXKNM6fVWuSz0GsYIo9XIHIlNI1/undVcl5dShoFSRD69Vn5mPmaVn/T9GsU
         oB0PEttZThXBTNFk5IC6Htnq+i/x+i+WtA8YcNeMe3z1dg8H1nhpQBgq7lE911SljJoS
         jKP4sXmZZUxlMYvvUqNw1QiUs9funmUGNPYjuCvUbd+ImgPHNO7tkT8TrOIXd4LIZ+c3
         eggw0G75Nw87eRS2a0++ZsDg5riDJQ2W9sPNvvIdycQGHfQd7i9ojXPIwFGIP55DQkhI
         eBaCalF1AQbzPglVqSwUdj4rMh+sA3OjaQOemx2zG0qCRNbo5PxYpWfGc86n9Ii+4tRs
         bvZg==
X-Gm-Message-State: AOAM530xOruSN52bi4zU7EB+OzJde+cJrMRYI0DOb7lusYMtWBM0bNu4
        xWeef/qng1xEr+YWmbiOa19pnskcRB5nVdXiMuVjPwnYt477t/UUrdjfyQpZUpiBd9QrIDxcvzw
        tv1a0ooxbhxwPucWL
X-Received: by 2002:a17:906:3597:: with SMTP id o23mr6389427ejb.174.1590591434816;
        Wed, 27 May 2020 07:57:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWGiuzsmtxIVaogSBAkwhnb3tFNBb9UKvhFi7Uo8SnQNBK0p3XuUz+C56T69cIjmykOMJcew==
X-Received: by 2002:a17:906:3597:: with SMTP id o23mr6389405ejb.174.1590591434572;
        Wed, 27 May 2020 07:57:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qo21sm3073763ejb.105.2020.05.27.07.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 07:57:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 557DA1804EB; Wed, 27 May 2020 16:57:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and DEVMAP_HASH
In-Reply-To: <c58f11be-af67-baff-bd70-753ca84de0dd@gmail.com>
References: <20200527010905.48135-1-dsahern@kernel.org> <20200527010905.48135-2-dsahern@kernel.org> <20200527122612.579fbb25@carbon> <c58f11be-af67-baff-bd70-753ca84de0dd@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 May 2020 16:57:13 +0200
Message-ID: <87tv011l4m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/27/20 4:26 AM, Jesper Dangaard Brouer wrote:
>>> @@ -108,9 +118,13 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>>>  	u64 cost = 0;
>>>  	int err;
>>>  
>>> -	/* check sanity of attributes */
>>> +	/* check sanity of attributes. 2 value sizes supported:
>>> +	 * 4 bytes: ifindex
>>> +	 * 8 bytes: ifindex + prog fd
>>> +	 */
>>>  	if (attr->max_entries == 0 || attr->key_size != 4 ||
>>> -	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
>>> +	    (attr->value_size != 4 && attr->value_size != 8) ||
>> 
>> IMHO we really need to leverage BTF here, as I'm sure we need to do more
>> extensions, and this size matching will get more and more unmaintainable.
>> 
>> With BTF in place, dumping the map via bpftool, will also make the
>> fields "self-documenting".
>> 
>> I will try to implement something that uses BTF for this case (and cpumap).
>> 
>
> as mentioned in a past response, BTF does not make any fields special
> and this code should not assume it either.

Either way you're creating a contract where the kernel says "first four
bytes is the ifindex, second four bytes is the fd/id". BTF just makes
that explicit, and allows userspace to declare that it agrees this is
what the fields should mean. And gives us more flexibility when
extending the API later than just adding stuff at the end and looking at
the size...

> You need to know precisely which 4 bytes is the program fd that needs
> to be looked up, and that AFAIK is beyond the scope of BTF.

Exactly - BTF is a way for userspace to explicitly tell the kernel "I am
going to put the fd into these four bytes of the value field", instead
of the kernel implicitly assuming it's always bytes 5-8.

-Toke

