Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1682414FEB2
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 18:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgBBR7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 12:59:13 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42454 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgBBR7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 12:59:13 -0500
Received: by mail-io1-f68.google.com with SMTP id s6so3725064iol.9
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 09:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7e7urQWuEf6zo8tajlPF09u4D0S1zSeM+Jzm0gn2jn4=;
        b=jSxQ8jtB7nIjGAtfFNqsasreelxCQafeKykYhHkkIjBv2xo7bHtUtk5lNH1RxlNf4R
         0bkqclL443099ciTtLmW5XqM/uRaXTBc0l+C/AD9PInZm3CRp4BvTMUbOUfgpePJthvk
         tsw1z2sNu9ul4Z/t672dm3YrBGgXvhatzPU+gMbIs2KyHJBhqlMq9U3w2Q3+fTSwR9Xs
         ThL6o/FtsVDAixz/8OFoah0zkCZo7sdqfgFHwNA3OLVmUh5cjLzIDReiIDUHnpDAqYS9
         VGHQSAptbBDwPXOjpmmaaRMfqppOXc0zO6UIhKuf3QdjYNQm/FxnFBiepzVO8c0+2DKM
         nCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7e7urQWuEf6zo8tajlPF09u4D0S1zSeM+Jzm0gn2jn4=;
        b=rKGyCrs/T5ZPUoD/5WucKoH79T1dLYyUxZr5PJbqsjaMWDYzvLw/aGpsVIzmY78YYe
         YNy5VM55ISAan+cRUw8y5rmZ8npXjHdjzPdhGYlTrV6CNM1BK6fnAzcA/UKjL8xegw9a
         aeq/BLf4KXfnwVmrl0K+b0V/ddHjql6Xs16bTkpyVpdKw+fPM55eM0JyEsDv/AyY7hxn
         /agzJVs4GbaL3R0Q0dLNs9k2lUrIOZae7yIZXHxupbz/l4XtN0nZvWPZMymNnpmT7PtC
         IlXUoEv9qi8587WEST937vIaxulOlVYhSssjRYJdaVVXeKMamkprJ2l5Lmwm7xVfvhuV
         +6UA==
X-Gm-Message-State: APjAAAUJfR3e1SRQEiDKcH4YwtDEIFijs/05kfzQFdEix/bqjFDFgoZO
        M6JOBFy4Q9XtoEd/apqA820=
X-Google-Smtp-Source: APXvYqxOaXgFl2R6tpAuliGz8oCe4J6GX0Z3zkcjFghvaGA3WR3vfOgtpcXGc6OfIfISf4AcE+zFTg==
X-Received: by 2002:a5e:8214:: with SMTP id l20mr16966637iom.168.1580666352478;
        Sun, 02 Feb 2020 09:59:12 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2529:5ed3:9969:3b0e? ([2601:282:803:7700:2529:5ed3:9969:3b0e])
        by smtp.googlemail.com with ESMTPSA id d9sm4689036ion.22.2020.02.02.09.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 09:59:11 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126045443.f47dzxdglazzchfm@ast-mbp>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8356434b-8c6b-9fe5-ebd2-a30bd7d7c093@gmail.com>
Date:   Sun, 2 Feb 2020 10:59:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200126045443.f47dzxdglazzchfm@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/20 9:54 PM, Alexei Starovoitov wrote:
> On Sat, Jan 25, 2020 at 06:43:36PM -0700, David Ahern wrote:
>>
>> That said, Martin's comment throws a wrench in the goal: if the existing
>> code does not enforce expected_attach_type then that option can not be
>> used in which case I guess I have to go with a new program type
>> (BPF_PROG_TYPE_XDP_EGRESS) which takes a new context (xdp_egress_md),
>> has different return codes, etc.
> 
> This is acceptable risk. We did such thing in the past. The chances of
> user space breakage are extremely low.
> 

Ultimately that is a decision for the maintainers. Code wise both
iproute2 and libbpf always initialize bpf_attr to 0 and given the many
uses of that union it seems odd that someone would initialize one field
at a time.

Unless someone comes back with a strong 'hell, no' I am planning to send
the next RFC version with the current API.
