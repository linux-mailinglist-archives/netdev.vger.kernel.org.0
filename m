Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7433ACC95F
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 12:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfJEKa4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 06:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbfJEKa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 06:30:56 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4A7D87BDA5
        for <netdev@vger.kernel.org>; Sat,  5 Oct 2019 10:30:55 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id e3so2352183ljj.16
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 03:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0BTW7nl+H/XRQtnoJO4rjId8yr0bcribLIhknb5mLqw=;
        b=fPLXoWuVKxgkcAqP/iUrMgPZRhbysOA4Y5A1Zhw/PFeCAtaRDYdr8YmUYAGla7aC+Q
         4nlX77wRWo2KkeevWa76p8fcvuUnzLQCJcjgGTAJgQ9FXqYq3sNqSKn5CAawIfvRMnmC
         TLI5T7u1+EbfJ4OXfzu6nYB0xxu9KUUPiU7RVvHNwphzoayBNq/nrvvrpaXyDiYysk+/
         iY6hdgc0wdjVmVfvgPhW68fN+oTtEy0pTm43f4tP/jxytVsfxB8fOV20il+WinlRSisk
         j9PBhEqQftt237M3WEFCA3Dg/FX36s7N3oHqxHvUnR4M87qDFYf4/ZmZOMGdQt5AVTYw
         drwg==
X-Gm-Message-State: APjAAAX7/OziT7tECd0oHFKp4gxKdmyywD/8HXFBcukPGiPpMUIDApZi
        kogn4z5d1Oddb67ZV9xKRAXv3BqKF8W84zQtBhBl3wiTlgSWUXJXbtayjXAyvJnmUTaPwu0G3gE
        gTl3RvKqUT32/V6Bx
X-Received: by 2002:a2e:9e8b:: with SMTP id f11mr8734648ljk.153.1570271453843;
        Sat, 05 Oct 2019 03:30:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyJyujM1Er185peAYODficBxekswVKPLsM3E8O4Zeu2pJ+E3A2prNs/g4ezxCnjlv2sPcVXWg==
X-Received: by 2002:a2e:9e8b:: with SMTP id f11mr8734625ljk.153.1570271453536;
        Sat, 05 Oct 2019 03:30:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a23sm1620173lfl.66.2019.10.05.03.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 03:30:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0182218063D; Sat,  5 Oct 2019 12:30:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/5] bpf: Add support for setting chain call sequence for programs
In-Reply-To: <20191004161842.617b8bd8@cakuba.hsd1.ca.comcast.net>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1> <157020976257.1824887.7683650534515359703.stgit@alrua-x1> <20191004161842.617b8bd8@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 05 Oct 2019 12:30:51 +0200
Message-ID: <87a7afo55w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> On Fri, 04 Oct 2019 19:22:42 +0200, Toke Høiland-Jørgensen wrote:
>> From: Alan Maguire <alan.maguire@oracle.com>
>> 
>> This adds support for setting and deleting bpf chain call programs through
>> a couple of new commands in the bpf() syscall. The CHAIN_ADD and CHAIN_DEL
>> commands take two eBPF program fds and a return code, and install the
>> 'next' program to be chain called after the 'prev' program if that program
>> returns 'retcode'. A retcode of -1 means "wildcard", so that the program
>> will be executed regardless of the previous program's return code.
>> 
>> 
>> The syscall command names are based on Alexei's prog_chain example[0],
>> which Alan helpfully rebased on current bpf-next. However, the logic and
>> program storage is obviously adapted to the execution logic in the previous
>> commit.
>> 
>> [0] https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/commit/?h=prog_chain&id=f54f45d00f91e083f6aec2abe35b6f0be52ae85b&context=15
>> 
>> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>
> It'd be good to explain why not just allocate a full prog array (or 
> in fact get one from the user), instead of having a hidden one which
> requires new command to interact with?

Because I consider the reuse of the prog array to be an implementation
detail that we may want to change later. Whereas if we expose it to
userspace it becomes API.

For instance, if we do end up wanting to have support directly in the
JIT for this, we could make the next progs just a linked list that the
JIT will walk and emit direct call instructions for each, instead of
doing the index-lookup.

-Toke
