Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762101522E1
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 00:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgBDXNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 18:13:24 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38430 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgBDXNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 18:13:23 -0500
Received: by mail-qk1-f193.google.com with SMTP id 21so19122qki.5;
        Tue, 04 Feb 2020 15:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YF96ySPPnfFFS8eQg9ULBqeK+dN7iPi7BPUsi4Fg9eM=;
        b=cwroxBL9wTqOYJT6JjOp0wdhfgVRLvS8jnsRTUPCkcpBziupMH5lLUhm8bOISd9qTD
         ShZniQKv5atFnVuyETysM1tbtUVuAtecy2U9N9kFUIo6r4J5f9xj1sjVd6R4adSaTu0J
         l3Qg5BaVJlQ3Quo+Z89882qG2zUMO6418an7SRcyVaJ7lUfLwwXppIFJmbiLP/ikfilw
         zPZH5SRI2l7x23gLhgvivvWEsjLRRCFqFCqv3PgJQ72xGTY/zbExjIvISZYxzI80dBsK
         d1cXExI0X9HAJPdAwjF9B8RKi9RoWOKstOQgWH5/+DWiKhJrOKV6X5q/EX2/Z8Skgiqh
         vZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YF96ySPPnfFFS8eQg9ULBqeK+dN7iPi7BPUsi4Fg9eM=;
        b=T4XBFFGHn3gxuLfbeLQ5H7Ptz0zWrDB8uiyouaG+7sGY6NeCwohs3k33RQ594PjAHN
         SogAZeKYdVFRJd8DFbNp2KtoM2k/s/71G5k+GcysZUOoiY4nGrpocv6btu9AObT9cXK8
         MSE3+1DFK7570/I499WtXIgAd8XohE7HKpGQLRtTrCeSeIgrIsudaTKQ1yZkKJyaUT4S
         3tqSbAxClJMoIu5+yPwwwUY0oFJLkWK7Ab/xCmTp8/++UyxaN+y8tDAgtTaN9szfkVQl
         w2KRYAKMVpc3llWHBau67inc1/BB2WgLxiQ3MT40khkKsVDUB2NfTqpvAJKBBnLvS+dP
         4Kow==
X-Gm-Message-State: APjAAAVOkHfOu/I5XjtV2b0ZMbm2lfebQx2cOcjBsbwKmGnxW99sas/r
        u5U3A3AC1DZSEdSa4BQAQqho3jhp+TM=
X-Google-Smtp-Source: APXvYqysaIqvgGJ7GkA7oHMggevj4D4Ip8HsBBm44heTiTtTtkDgaq32M1pOsl64UoFDW0B0Xjynkw==
X-Received: by 2002:a37:4dc1:: with SMTP id a184mr31652814qkb.62.1580858002374;
        Tue, 04 Feb 2020 15:13:22 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:3d10:e33:29a2:f093? ([2601:282:803:7700:3d10:e33:29a2:f093])
        by smtp.googlemail.com with ESMTPSA id r10sm11768749qkm.23.2020.02.04.15.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 15:13:21 -0800 (PST)
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20190820114706.18546-1-toke@redhat.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
 <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk>
 <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk>
 <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
 <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
 <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com>
 <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
 <87h80669o6.fsf@toke.dk>
 <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
 <8736bqf9dw.fsf@toke.dk>
 <CAEf4BzbNZQmDD3Ob+m6yJK2CzNb9=3F2bYfxOUyn7uOp0bhXZA@mail.gmail.com>
 <87tv46dnj6.fsf@toke.dk> <2ab65028-c200-f8f8-b57d-904cb8a7c00c@gmail.com>
 <87r1zadlpx.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d5434db9-1899-776d-c4cd-918e2418175d@gmail.com>
Date:   Tue, 4 Feb 2020 16:13:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87r1zadlpx.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/20 3:35 PM, Toke Høiland-Jørgensen wrote:
> 
>> Most likely, making iproute2 use libbpf statically is going to be
>> challenging and I am not sure it is the right thing to do (unless the
>> user is building a static version of iproute2 commands).
> 
> Linking dynamically would imply a new dependency. I'm not necessarily
> against that, but would it be acceptable from your PoV? And if so,
> should we keep the current internal BPF code for when libbpf is not
> available, or would it be acceptable to not be able to load BPF programs
> if libbpf is not present (similar to how the libelf dependency works
> today)?

iproute2 recently gained the libmnl dependency for extack. Seems like
libbpf falls into the similar category.

> 
>> 2. git submodules can be a PITA to deal with (e.g., jumping between
>> branches and versions), so there needs to be a good reason for it.
> 
> Yes, totally with you on that. Another option could be to just copy the
> files into the iproute2 tree, and update them the same way the kernel
> headers are? Or maybe doing fancy things like this:
> https://github.com/apenwarr/git-subtrac

kernel uapi is a totally different reason to import the headers. bpf
functionality is an add-on.

I would like to see iproute2 work with libbpf. Given libbpf's current
status and availability across OS'es that is going to be a challenge for
a lot of OS'es which is why I suggested the HAVE_LIBBPF check falls back
to existing code if libbpf is not installed.

> 
>> 3. iproute2 code needs to build for a wide range of OSes and not lose
>> functionality compared to what it has today.
> 
> Could you be a bit more specific about "a wide range of OSes"? I guess
> we could do the work to make sure libbpf builds on all the same
> platforms iproute2 supports, but we'd need something a bit more definite
> to go on...
> 

rhel5/centos5? definitely rhel6/centos6 time frame and forward.

Stephen: has the backwards lifetime ever been stated?

Changing configure to check for existence and fall back to existing code
seems to me the safest option.

