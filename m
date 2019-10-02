Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F27C90E2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfJBScG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 14:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12245 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfJBScG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 14:32:06 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC8317BDB4
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 18:32:05 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id x20so3602667lfe.14
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tpiuaEG9l6GxqSR8dzmp9ArjjlxkZogiEdK6l7dzOz4=;
        b=ZP3Np2HmJ/3smyzMI/Sv8YKyXBZ8Bmun/hxtV2ub0Ic6mEBq+I9oCk97QGdAtKoBjM
         BVs0rht+D2GfjZncA4wieof49YC0Q3Id2Y/EfkLY/22F8jETL1sJl6+ejGYOs7viOepS
         a6yrr/1M8+Ik66an/o2pMD6W5zv3og7VaXzD1EjYBhMyBEqvS0jwSsE3xHe/+2V+SaQ8
         zJgheFsxNE+LQbR6B9yeNlCaC5k+Ne7jcAmE8N1qDRNaI/d5MAza9+wTrVV4h0W4keLD
         CiTZ20zuxQFmhMeRbOCrt4+zIxsOkFJNXfoR4VBaAsd3EWhHnfWpuqutwDijZ/3nSe+M
         T3nw==
X-Gm-Message-State: APjAAAV4v7v3vt7Y2oJAGJAoI2Z2xVU+cKFKtU7ooSAr+iRwYFRbxYfx
        +AHoveRR3Rt/UL+pr7v9ECxSQmyukQPSnoY9Vf2ZqDSMY74P+joxQY+/vkxjHuJ+pQF6QG4IKYm
        PsPmoKeUWZA2A4E1f
X-Received: by 2002:a19:2207:: with SMTP id i7mr3192223lfi.185.1570041124367;
        Wed, 02 Oct 2019 11:32:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxsfZ3eeEC61s97JpcBTkgVTsw5G0KXI0qnAnZgdE7SO/1xyJL1h1Svk6LNFtR7LPAv1SBCvw==
X-Received: by 2002:a19:2207:: with SMTP id i7mr3192209lfi.185.1570041124169;
        Wed, 02 Oct 2019 11:32:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id t24sm4736516lfq.13.2019.10.02.11.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:32:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A674118063D; Wed,  2 Oct 2019 20:32:02 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/9] xdp: Support setting and getting device chain map
In-Reply-To: <CACAyw9-vS7zC0dg-rqkt=hwWkKD-a=WvX92-apiD=wp9vSsGcA@mail.gmail.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <157002302784.1302756.2073486805381846919.stgit@alrua-x1> <CACAyw9-vS7zC0dg-rqkt=hwWkKD-a=WvX92-apiD=wp9vSsGcA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 20:32:02 +0200
Message-ID: <875zl7robh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer <lmb@cloudflare.com> writes:

> On Wed, 2 Oct 2019 at 14:30, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> This adds support to rtnetlink for setting and getting the per-device XDP
>> chain map. The map is set by means of a new netlink attribute that contains
>> a pointer to a BPF map of the XDP chain type. If such an attribute is
>> included, it will be inserted into the struct net_device so that the XDP
>> chain call code will pick it up on program execution.
>>
>> To prevent old userspace programs that do not understand the chain map
>> attribute from messing up the chain call order, a netlink message with no
>> chain map attribute set will be rejected if a chain map has already been
>> installed.
>>
>> When installing a new chain call map, an XDP program fd must also be
>> provided, otherwise the operation will be rejected.
>
> Why is the program required? I kind of expected the chain call map to
> override any program.

Mainly because drivers expect to attach an XDP program, not a map. We
could conceivably emulate this by pulling out the first program from the
map on attach (after we define semantics for this; just lookup ID 0?)
and pass that down to the driver. But then we'd either need to make that
first program immutable in the map, or we'd need to propagate map
updates all the way down to the driver. Or alternatively, we'd need to
teach all the drivers how to attach a map instead of a program. Lots of
cans of worms there I'd rather not open... :)

A userspace application or library could emulate all of this, though, by
just accepting "attach" of a map, and turning that into the right
netlink message. It would have the same problem re: map updates, but if
it controls those that should be doable...

-Toke
