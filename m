Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5546A195DC3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgC0Sjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:39:53 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:55950 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgC0Sjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585334392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HFEM/Ur1BY9SGW8JH4b5ko6dsHwkpfgs391rte+SmAA=;
        b=OtHXQFddf5X58KSAFBmnWWbZG+K3154kAbVIDgsfMWjxNGWpq9LDYJ+L5erP3CIcDxBke/
        sJNKD0+OHbad33ycZH0qnRyzWBAThQZZCes6sy7SPNvrJ8SdzEj79dZFA+9YZ9AgC1OeD3
        2BOS9Acmd/h9hsn620lidtKO/otaHRQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-OEHjxqwuMOa_eyLBvyxNFQ-1; Fri, 27 Mar 2020 14:39:50 -0400
X-MC-Unique: OEHjxqwuMOa_eyLBvyxNFQ-1
Received: by mail-lj1-f197.google.com with SMTP id x12so326665ljj.16
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 11:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HFEM/Ur1BY9SGW8JH4b5ko6dsHwkpfgs391rte+SmAA=;
        b=Eplg0TxY1Cp4lhz2fyQuiXIkomUVp+e4PKmsTzO8uDbHZYJSOHzTW0ue3KnfRdiZz3
         YCLPlAiCGASLh9EPFAYZUUOICowd5r99be11pju5B8japSfdoeT08mvSsyQ1ZoHhfL4r
         9bzwDSmSEqhu1zW8Y6354xalR/jS7+2YMo12vUNbP8+QFVg999804EcS2vrJdp/R5Au+
         iGmHRzK1WQF00ymSqVAMCNoa0QVE6d/iPRqy3LGeFIVxRXcqmUxUTZxpEYXIjw7FNEiy
         QJ2Oz7Czy6PRrYZqlOgPeIWdBwCCyxH3bCZ0JBC9DjPjryR6acgt8OKh4vAFWDcnvJnk
         Y/bg==
X-Gm-Message-State: AGi0PuZu7H/MXUWIA5G/Y0oI9gVsXBoSphmceIOwFCGJPaCos+l/FwiA
        gnSD5sc9UgT/AgFtGFUz2iVkqKKHjajjdXZkhYSW7+0ng+gFUTZpNsdgS0L7qaYAuIgLylbnGrU
        G6gqcxtH9TKceVSMc
X-Received: by 2002:a2e:6809:: with SMTP id c9mr168338lja.251.1585334389126;
        Fri, 27 Mar 2020 11:39:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypIGN4t1K2af+flvIdNNSoGetcHpo2Y3VoXH4b6orMnOAIw1EbziJ9MeAiWGIlvDpbyB23n7Gg==
X-Received: by 2002:a2e:6809:: with SMTP id c9mr168324lja.251.1585334388815;
        Fri, 27 Mar 2020 11:39:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v12sm3056895ljh.6.2020.03.27.11.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 11:39:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D2FC418158B; Fri, 27 Mar 2020 19:39:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: Add bpf_object__rodata getter function
In-Reply-To: <CAEf4BzbRpJsoXb3Bvx0_jKGj4gLk-dhXRqryfO23qMreG2B+Kg@mail.gmail.com>
References: <20200326151741.125427-1-toke@redhat.com> <CAEf4BzYxJjJygu_ZqJJB03n=ZetxhuUE7eLD9dsbkbvzQ5M08w@mail.gmail.com> <87eetem1dm.fsf@toke.dk> <CAEf4BzbRpJsoXb3Bvx0_jKGj4gLk-dhXRqryfO23qMreG2B+Kg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Mar 2020 19:39:44 +0100
Message-ID: <875zepmykv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> > But basically, why can't you use BPF skeleton?
>>
>> Couple of reasons:
>>
>> - I don't need any of the other features of the skeleton
>> - I don't want to depend on bpftool in the build process
>> - I don't want to embed the BPF bytecode into the C object
>
> Just curious, how are you intending to use global variables. Are you
> restricting to a single global var (a struct probably), so it's easier
> to work with it? Or are you resolving all the variables' offsets
> manually? It's really inconvenient to work with global variables
> without skeleton, which is why I'm curious.

Yeah, there's a single:

static volatile const struct xdp_dispatcher_config conf = {};

in the BPF file. Which is defined as:

struct xdp_dispatcher_config {
	__u8 num_progs_enabled;
	__u32 chain_call_actions[MAX_DISPATCHER_ACTIONS];
};

>> > Also, application can already find that map by looking at name.
>>
>> Yes, it can find the map, but it can't access the data. But I guess I
>> could just add a getter for that. Just figured this was easier to
>> consume; but I can see why it might impose restrictions on future
>> changes, so I'll send a v2 with such a map-level getter instead.
>
> Sounds good, I'll go review v2 now.

Great, thanks!

-Toke

