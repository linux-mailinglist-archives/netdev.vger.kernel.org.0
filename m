Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA69DC9186
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 21:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfJBTJj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 15:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbfJBTJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 15:09:39 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE93769060
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 19:09:37 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id d7so11498952edp.23
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 12:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2tQMWrghaMwoMjWv34nUUSY2iBHmEPWkKzy78LjQ1Z4=;
        b=pQklfvf59DJqgUIO3P/ef1B1JWXQOOhClYSAoPFKX+pVys/gqtzW4e0oHIA1T2GYVZ
         2i15q94ZyyhijGK6I4OupTKmnDKCZgZhGW/r9qt7AaNZvAbpYAZeWN06gVqou9FjP5Lr
         fmIspynIUnEQ3u3WPZKOftbFi4kSfrEkfQzg6gu2Nu9Z1jAmo6Gsan0Y4b4qvrcTauW1
         2liaLIBl/H/EnL/z8lp2JtDyUEBSDiZk5AMwt6Wwzbc9nXKNDlGbPB2o8OEuhS1pZm3x
         NV7f0gF6C4k3LzeyC2NIO16Eh05OatpmtUk/Snt38tFOq9bA58vIS4qBzcVah/2DFsed
         6zkA==
X-Gm-Message-State: APjAAAVc9XgfctlHcDuDEmLhIU4oI37tunhIdBDvGsdRklR4ct/ucC6d
        OL/eSshroVg7aPzeddkMBQL03UAFuF7oX6oblkW6fNhdDNcdxNLB/2fInzzKovBwe339wbuKwss
        WPabH8LcXDvc9nw+r
X-Received: by 2002:a17:906:b283:: with SMTP id q3mr4557881ejz.7.1570043376378;
        Wed, 02 Oct 2019 12:09:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzadcvRQPN5dNJWmvgXDKKyowhYYpsdqB2khB6mli3rMJHB+Ox23QUPTzN/4I0ogE5je7BQBA==
X-Received: by 2002:a17:906:b283:: with SMTP id q3mr4557856ejz.7.1570043376064;
        Wed, 02 Oct 2019 12:09:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id j8sm4255edy.44.2019.10.02.12.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 12:09:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 05B3C18063D; Wed,  2 Oct 2019 21:09:33 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: RE: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <5d94d3c5a238f_22502b00ea21a5b4e9@john-XPS-13-9370.notmuch>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <5d94d3c5a238f_22502b00ea21a5b4e9@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 21:09:33 +0200
Message-ID: <87wodnq80i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke Høiland-Jørgensen wrote:
>> This series adds support for executing multiple XDP programs on a single
>> interface in sequence, through the use of chain calls, as discussed at the Linux
>> Plumbers Conference last month:
>> 
>> https://linuxplumbersconf.org/event/4/contributions/460/
>> 
>> # HIGH-LEVEL IDEA
>> 
>> The basic idea is to express the chain call sequence through a special map type,
>> which contains a mapping from a (program, return code) tuple to another program
>> to run in next in the sequence. Userspace can populate this map to express
>> arbitrary call sequences, and update the sequence by updating or replacing the
>> map.
>> 
>> The actual execution of the program sequence is done in bpf_prog_run_xdp(),
>> which will lookup the chain sequence map, and if found, will loop through calls
>> to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
>> previous program ID and return code.
>> 
>> An XDP chain call map can be installed on an interface by means of a new netlink
>> attribute containing an fd pointing to a chain call map. This can be supplied
>> along with the XDP prog fd, so that a chain map is always installed together
>> with an XDP program.
>> 
>> # PERFORMANCE
>> 
>> I performed a simple performance test to get an initial feel for the overhead of
>> the chain call mechanism. This test consists of running only two programs in
>> sequence: One that returns XDP_PASS and another that returns XDP_DROP. I then
>> measure the drop PPS performance and compare it to a baseline of just a single
>> program that only returns XDP_DROP.
>> 
>> For comparison, a test case that uses regular eBPF tail calls to sequence two
>> programs together is also included. Finally, because 'perf' showed that the
>> hashmap lookup was the largest single source of overhead, I also added a test
>> case where I removed the jhash() call from the hashmap code, and just use the
>> u32 key directly as an index into the hash bucket structure.
>> 
>> The performance for these different cases is as follows (with retpolines disabled):
>
> retpolines enabled would also be interesting.

Yes, I'll try that as well.

>> 
>> | Test case                       | Perf      | Add. overhead | Total overhead |
>> |---------------------------------+-----------+---------------+----------------|
>> | Before patch (XDP DROP program) | 31.0 Mpps |               |                |
>> | After patch (XDP DROP program)  | 28.9 Mpps |        2.3 ns |         2.3 ns |
>
> IMO even 1 Mpps overhead is too much for a feature that is primarily
> about ease of use. Sacrificing performance to make userland a bit
> easier is hard to justify for me when XDP _is_ singularly about
> performance. Also that is nearly 10% overhead which is fairly large.
> So I think going forward the performance gab needs to be removed.

It's not just about ease of use. If we really want XDP to catch on and
be integrated into third-party applications, we *need* to solve the
multi-program problem. Otherwise users are going to have to choose
between running their DDOS protection application and their IDS; which
means no one is going to be able to rely on XDP support, and so no one
is going to bother to implement it. Or at least, I'm afraid it'll end up
that way.

That being said, I agree that the performance impact should be kept at
an absolute minimum. In terms of code it already is: it's a single if
statement to check if a chain map is loaded. I haven't looked into why
that takes 2.3 ns to do yet. I suspect it may just be because we're
taking a cache miss: the chain map pointer is not stored anywhere near
the rest of the XDP data structures...

>> | XDP tail call                   | 26.6 Mpps |        3.0 ns |         5.3 ns |
>> | XDP chain call (no jhash)       | 19.6 Mpps |       13.4 ns |        18.7 ns |
>> | XDP chain call (this series)    | 17.0 Mpps |        7.9 ns |        26.6 ns |
>> 
>> From this it is clear that while there is some overhead from this mechanism; but
>> the jhash removal example indicates that it is probably possible to optimise the
>> code to the point where the overhead becomes low enough that it is acceptable.
>
> I'm missing why 'in theory' at least this can't be made as-fast as
> tail calls? Again I can't see why someone would lose 30% of their
> performance when a userland program could populate a tail call map for
> the same effect. Sure userland would also have to enforce some program
> standards/conventions but it could be done and at 30% overhead that
> pain is probably worth it IMO.
>
> My thinking though is if we are a bit clever chaining and tail calls
> could be performance-wise equivalent?

Oh, I totally agree that 30% overhead is way too much. I just
prioritised getting this to work and send it out for comments to get the
conversation going around the API before I spend too much time
optimising the performance bits.

I think it should be possible to get it pretty close to pure tail calls.
A tail call compiles down to a direct jump instruction without leaving
the BPF execution environment, though, so maybe not *exactly* as fast.
But I'd settle for an overhead of, say, a handful of nanoseconds
compared to a pure tail call. Certainly not the tens of nanoseconds I
get right now.

Also, bear in mind that an overhead of say 4-6 nanoseconds only
translates into such a large percentage-wise overhead in this test
because the XDP programs being run don't actually do anything - not even
touch the packet data. As the programs themselves get larger, the
percentage-wise overhead becomes smaller as well. So a test like this
shows the worst-case performance.

-Toke
