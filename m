Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA0C923A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 21:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfJBTXG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 15:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfJBTXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 15:23:06 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82C9787638
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 19:23:05 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id v24so85605ljh.23
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 12:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ub/B1xLl3oHfgYFdtw9xij/+r1A/SqWswRKGttSC7Zw=;
        b=ofBuJ+43BTvrXuqygv17Zbm6wqdSS+bp5k942kRW6umYkzmd6F/LozDui0JtXXKkCP
         s+SpKH5v1NWFbEgLSkOS2GFoL9tddGEoHEuhRFmk5cxRPfhCMw1PznpM01gdyJtCLAHK
         Kh9vOcqQuOyXPrPNlPPuMiuQx9kJApzkZjLgdM9YENm+/JarB9MRd4Hb8YBrdpjmutYC
         fgoTE3KMSz1r6NjoT+3Vn0csxz8sAK/99fA8Z7NsPw2sC+zB4wJAFs3qwsWZkU9A0DvU
         SjTOq4YRARuu3vlwn07+wRds+6HhcKQttG2EbsG+Np/fgW1R8B93MEA/p873DooD8Iev
         xrmA==
X-Gm-Message-State: APjAAAUHDoEHlHtQcDHHQx6Sf5KcmtCER5KiEYS4s/m+In20F6bCrztd
        DdSX12OJq6t/MkcFA/+aOA9/Q1/+JKNkiC56y1fe31QA1k6VnARczDGTdk66GyA3LGGTbPYE4nt
        kgbCQmTl+tL3afXBu
X-Received: by 2002:ac2:5463:: with SMTP id e3mr3250628lfn.117.1570044183969;
        Wed, 02 Oct 2019 12:23:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzYX3k9iv8+gc87K/3BVW9mTTa48DJMwPuK5XYfZ2CncXrm7YPtjOPOFkG1nlrKCR8Om+WTmQ==
X-Received: by 2002:ac2:5463:: with SMTP id e3mr3250607lfn.117.1570044183694;
        Wed, 02 Oct 2019 12:23:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id m15sm73217ljg.97.2019.10.02.12.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 12:23:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E16FF18063D; Wed,  2 Oct 2019 21:23:01 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 21:23:01 +0200
Message-ID: <87tv8rq7e2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu <songliubraving@fb.com> writes:

>> On Oct 2, 2019, at 6:30 AM, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> 
>> This series adds support for executing multiple XDP programs on a single
>> interface in sequence, through the use of chain calls, as discussed at the Linux
>> Plumbers Conference last month:
>> 
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__linuxplumbersconf.org_event_4_contributions_460_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=dR8692q0_uaizy0jkrBJQM5k2hfm4CiFxYT8KaysFrg&m=YXqqHTC51zXBviPBEk55y-fQjFQwcXWFlH0IoOqm2KU&s=NF4w3eSPmNhSpJr1-0FLqqlqfgEV8gsCQb9YqWQ9p-k&e= 
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
>
> Interesting work!
>
> Quick question: can we achieve the same by adding a "retval to
> call_tail_next" map to each program?

Hmm, that's an interesting idea; I hadn't thought of that. As long as
that map can be manipulated outside of the program itself, it may work.
I wonder how complex it gets to modify the call sequence, though; say
you want to change A->B->C to A->C->B - how do you do that without
interrupting the sequence while you're modifying things? Or is it OK if
that is not possible?

> I think one issue is how to avoid loop like A->B->C->A, but this
> should be solvable?

Well, for tail calls there's already a counter that breaks the sequence
after a certain number of calls. We could do the same here.

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
>> 
>> | Test case                       | Perf      | Add. overhead | Total overhead |
>> |---------------------------------+-----------+---------------+----------------|
>> | Before patch (XDP DROP program) | 31.0 Mpps |               |                |
>> | After patch (XDP DROP program)  | 28.9 Mpps |        2.3 ns |         2.3 ns |
>> | XDP tail call                   | 26.6 Mpps |        3.0 ns |         5.3 ns |
>> | XDP chain call (no jhash)       | 19.6 Mpps |       13.4 ns |        18.7 ns |
>> | XDP chain call (this series)    | 17.0 Mpps |        7.9 ns |        26.6 ns |
>> 
>> From this it is clear that while there is some overhead from this mechanism; but
>> the jhash removal example indicates that it is probably possible to optimise the
>> code to the point where the overhead becomes low enough that it is acceptable.
>
> I think we can probably re-jit multiple programs into one based on the
> mapping, which should give the best performance.

Yeah, integrating this into the jit+verifier would obviously give the
best performance. But I wanted to avoid that because I viewed this as an
XDP-specific feature, and I didn't want to add more complexity to the
already somewhat complex verifier.

However, if there's really interest in having this be a general feature
outside of XDP, I guess I can look at that again.

-Toke
