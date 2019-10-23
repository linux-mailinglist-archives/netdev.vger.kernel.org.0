Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4263CE1BBD
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405555AbfJWNFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405524AbfJWNFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 09:05:22 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 84F68C057EC6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 13:05:21 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id m17so4116785lfl.11
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 06:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ayShX9eSwI2mf/Z2LSvzkLt/5bIb4viERXJyj+kghaQ=;
        b=fhR1oaA9PMWgG5yJVDLIKIdeGRM6CoQr1hMg+5f/qB62rVKh0GWut3HsNrb9arho+5
         8TZFWkWftZNnvvHI3oJNh1OP189QZasvAnvArnU0BBW28fqso7K5H0HL/PCvLWS5Ktz7
         qOAnetJeWtu0N1ZohH+BgD6q6ZjCelGjYWDrRVTT2qP/1PtxND++gztl3LKTDXKCx186
         +kdHqmAGiCkK/y2HO1WBxAx/3DPk2bqpNS7dfw2ZrJIzMbIa/aHuPLNyPsc+5NN6dBNr
         fjh4mYH/bwxRqtrmhyQMj/+VhC2IGEHCXV9xj2aed05izafpTI2PBAyuln39BkXI/R90
         nxvw==
X-Gm-Message-State: APjAAAUf4e9Ba8khlgEDvY9L4fB3CD6v8rj9PKf++8s2hLn0idJb7OCz
        M//TqoJ9mwTfKwE7zkE1Zg0UW0ZObjNxGIGCGRCEIp2xS07dXVbNZe4Pe4eCgOWm+0ePVhjdmi5
        +22eWW+fLijqSyWDZ
X-Received: by 2002:ac2:46d8:: with SMTP id p24mr19215832lfo.28.1571835920089;
        Wed, 23 Oct 2019 06:05:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzwZtLPghpRsZMbUAONvnb70ijFg4cju+eSJepEBx9DBET3MVwXX1/NPhUB4xKvuIlos6F1jg==
X-Received: by 2002:ac2:46d8:: with SMTP id p24mr19215817lfo.28.1571835919863;
        Wed, 23 Oct 2019 06:05:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g21sm18349357lje.67.2019.10.23.06.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 06:05:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5D77A1804B1; Wed, 23 Oct 2019 15:05:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] libbpf: Support configurable pinning of maps from BTF annotations
In-Reply-To: <6c0e6ebf-aebc-5e80-0e32-aa81857f3a74@iogearbox.net>
References: <157175668770.112621.17344362302386223623.stgit@toke.dk> <157175668991.112621.14204565208520782920.stgit@toke.dk> <CAEf4BzaM32j4iLhvcuwMS+dPDBd52KwviwJuoAwVVr8EwoRpHA@mail.gmail.com> <875zkgobf3.fsf@toke.dk> <CAEf4BzY-buKFadzzAKpCdjAZ+1_UwSpQobdRH7yQn_fFXQYX0w@mail.gmail.com> <87r233n8pl.fsf@toke.dk> <6c0e6ebf-aebc-5e80-0e32-aa81857f3a74@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Oct 2019 15:05:18 +0200
Message-ID: <87a79rmx2p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You are worried about the case where an application should be able to
> unpin the map before loading a new one so it doesn't get reused?

No, I'm worried about the opposite: Someone running (the equivalent of)
'ip link set dev eth0 xdp off', and then wondering why all resources
aren't freed.

I do believe that the common case could be solved by a logic similar to
the one I proposed, though:

>> Hmm, but I guess it could do that anyway; so maybe what we need is just
>> a "try to find all pinned maps of this program" function? That could
>> then to something like:
>> 
>> - Get the maps IDs and names of all maps attached to that program from
>>    the kernel.
>> 
>> - Look for each map name in /sys/fs/bpf
>> 
>> - If a pinned map with the same name exists, compare the IDs, and unlink
>>    if they match
>> 
>> I don't suppose it'll be possible to do all that in a race-free manner,
>> but that would go for any use of unlink() unless I'm missing something?
