Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48811118F84
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfLJSLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:11:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21572 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727349AbfLJSLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576001484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z5XSliwwrq9s/hk+XiIILzS+SOwRs74eCD9HtmMu754=;
        b=D6rz1AzJf8S3cBst0ACcVWQMOJfPBxjgMNytm4WcMqDWFV5s/e4YjjZ9Kkw0BSejCRnb9j
        tiRiCiJ1DTF9p8SSkT9FuXZZplRJaaU+upSNJeGRRSCqUXcEBXZfp7ScoAw977YH/7pmP2
        7rW6WPox7A2z9MntDrbZj6EtgexigTg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86--Me4mhCxP1aYztbfS8sMbg-1; Tue, 10 Dec 2019 13:11:22 -0500
Received: by mail-lj1-f197.google.com with SMTP id f1so4031301ljp.5
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 10:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Z5XSliwwrq9s/hk+XiIILzS+SOwRs74eCD9HtmMu754=;
        b=JptJJubqPJ4wJrJfICvIql84YCsKKzLOtfyhllcZcvPK4NLqTEwVhYt0UMopMwCJQQ
         SRIY/b+flAdh8hnE8nbjbJU7AbXW8gLPt1VkUjDg4MJiE6Uch7SPBHbK9LqxAoHB2OY4
         KjHKkezFRNFWxRHIlUh//nSA5kCIKQTIf+P8j/tv6qZxDChPx6MYxVzYnTyPGBGm4c+Z
         9NOUrKqAQVMRXzkyEcONQFeboVy0qNDZkNDQ/sqp3Ad90C3xqkWxpuFlf7tc8deDogZt
         U1Dx5zH4sd6UPAe84oyiQDmARjKgVOzNbBUCcLFsYjfbqLK2ATvylQ8wd6wI48npnCoE
         Tv7w==
X-Gm-Message-State: APjAAAUgV9BIOJWy3KiCcbNZC62NVBww/e6VWUBjlmU3WGZs6dM9pp5y
        jS7Qx1uT500NBgPdEQH7QpXFtZUftpaCYN/lzlO62GKjea1je4G6p1YYxvWTVnXV+MWgqpyczWQ
        2aUhP7kbPbMYTPX9r
X-Received: by 2002:a19:7701:: with SMTP id s1mr18277011lfc.180.1576001481256;
        Tue, 10 Dec 2019 10:11:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzlXgyj+NriSETPpZEMOad//9EBC6p8cMANluHa2HW2EzUm0HW2EBh2pLrV6RDm/kCCI3VsiA==
X-Received: by 2002:a19:7701:: with SMTP id s1mr18276999lfc.180.1576001481132;
        Tue, 10 Dec 2019 10:11:21 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z26sm2004779lfq.69.2019.12.10.10.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 10:11:20 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 42A66181AC8; Tue, 10 Dec 2019 19:11:18 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] bpftool: Don't crash on missing jited insns or ksyms
In-Reply-To: <20191210175915.wh7njnvt2xk64ski@kafai-mbp>
References: <20191210143047.142347-1-toke@redhat.com> <20191210175915.wh7njnvt2xk64ski@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 10 Dec 2019 19:11:18 +0100
Message-ID: <87h828giex.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: -Me4mhCxP1aYztbfS8sMbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau <kafai@fb.com> writes:

> On Tue, Dec 10, 2019 at 03:30:47PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> When JIT hardening is turned on, the kernel can fail to return jited_ksy=
ms
> JIT hardening means net.core.bpf_jit_harden?
> From the code, it happens on the bpf_dump_raw_ok() check which is
> actually "kernel.kptr_restrict" instead?

Ah, yeah, you're right. I was looking through the hardening patchset and
the bpf_jit_harden setting was the first thing I hit upon; must admit I
didn't check this too closely :)

I'll send a v2 with an updated commit message...

-Toke

