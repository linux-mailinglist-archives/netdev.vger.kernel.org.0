Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208E415D661
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgBNLO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:14:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727965AbgBNLO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 06:14:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581678896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ocM5p8eMfKJh7s1dzfUoLzimRthVD4HZk5UGN7Sdio=;
        b=dKFblidvKmaxDrTAmFyu+oK2BinxQ5v5gkJFLPbYiiO6EjOkgtVPda8vmw8r/nxLVShlCF
        65tVfZ/vJVeoLjhEh7gdC2qXwYuccQ9j1sfACKpHNMYfvMVNsMYodunSr2svn0O8Hb7f6y
        3b7q5qFadveES6kYSc5E2C44gXewyH0=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-V6mU9nfcORm9lbx5cgNZyw-1; Fri, 14 Feb 2020 06:14:47 -0500
X-MC-Unique: V6mU9nfcORm9lbx5cgNZyw-1
Received: by mail-lj1-f199.google.com with SMTP id t11so3273949ljo.13
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 03:14:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6ocM5p8eMfKJh7s1dzfUoLzimRthVD4HZk5UGN7Sdio=;
        b=RlRdEAxqz2aDHlgmeCz5RwB63lxnuXd4EwF2y6Ds1E1WsfxFMf6l7MI/HdvTQRTCcc
         9YxpOxiPLMdMB+G9oLTHK9u9KGcWPiS/Bg47hYD+nPF1CJwC1Cmk8TO3lV7FMj08w7tH
         sUK68+UxDlRGty5dGQQqR+QRp8PnHgqLGf3IEqRAxwTgVji2+JyLuxP0se3n5JSGkg44
         v5wCsEM9GUmaGPUV72uCQ78pU6bdz/LhFa/gFUbL4rbCQJMjFVii7+2y9aZhni+NfKmn
         zxxnFl6jqCMJH0OrU42yBWrXhGmci15w/mQeAaECGegMqeh4rTOJ9lCIWo8xhgzxMFDK
         JOww==
X-Gm-Message-State: APjAAAV+F2D95FUXsKnPF+cX2GdjFUkJV10XleKY6n9AtR+WLkpRKj9y
        DO85k8/Cji4+agbCSeb7kX0ILn9AnLsNbeKjmlzp7I/f3wgEMlo7m9KLibW1RUK7UXhBAVOU4s5
        Biir/YE9mDGohGq1B
X-Received: by 2002:a05:651c:111a:: with SMTP id d26mr1750545ljo.153.1581678886129;
        Fri, 14 Feb 2020 03:14:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyfUK4dSp4/TUbirU5/SpddXby8+Y9Cjdsvt2uBLyFZMRhFFUJVFeWiWiMC/c8FQWBL9PXfiw==
X-Received: by 2002:a05:651c:111a:: with SMTP id d26mr1750527ljo.153.1581678885791;
        Fri, 14 Feb 2020 03:14:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j7sm2835353lfh.25.2020.02.14.03.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 03:14:44 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 567E8180371; Fri, 14 Feb 2020 12:14:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yossi Kuperman <yossiku@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [RFC] Hierarchical QoS Hardware Offload (HTB)
In-Reply-To: <bbafbd41-2a3b-3abd-e57c-18175a7c9e3f@mellanox.com>
References: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com> <87y2tmckyt.fsf@toke.dk> <bbafbd41-2a3b-3abd-e57c-18175a7c9e3f@mellanox.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 14 Feb 2020 12:14:42 +0100
Message-ID: <877e0pe7z1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yossi Kuperman <yossiku@mellanox.com> writes:

> On 01/02/2020 18:48, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Yossi Kuperman <yossiku@mellanox.com> writes:
>>
>>> Following is an outline briefly describing our plans towards offloading=
 HTB functionality.
>>>
>>> HTB qdisc allows you to use one physical link to simulate several
>>> slower links. This is done by configuring a hierarchical QoS tree;
>>> each tree node corresponds to a class. Filters are used to classify
>>> flows to different classes. HTB is quite flexible and versatile, but
>>> it comes with a cost. HTB does not scale and consumes considerable CPU
>>> and memory. Our aim is to offload HTB functionality to hardware and
>>> provide the user with the flexibility and the conventional tools
>>> offered by TC subsystem, while scaling to thousands of traffic classes
>>> and maintaining wire-speed performance.=C2=A0
>>>
>>> Mellanox hardware can support hierarchical rate-limiting;
>>> rate-limiting is done per hardware queue. In our proposed solution,
>>> flow classification takes place in software. By moving the
>>> classification to clsact egress hook, which is thread-safe and does
>>> not require locking, we avoid the contention induced by the single
>>> qdisc lock. Furthermore, clsact filters are perform before the
>>> net-device=E2=80=99s TX queue is selected, allowing the driver a chance=
 to
>>> translate the class to the appropriate hardware queue. Please note
>>> that the user will need to configure the filters slightly different;
>>> apply them to the clsact rather than to the HTB itself, and set the
>>> priority to the desired class-id.
>>>
>>> For example, the following two filters are equivalent:
>>> 	1. tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80 cl=
assid 1:10
>>> 	2. tc filter add dev eth0 egress protocol ip flower dst_port 80 action=
 skbedit priority 1:10
>>>
>>> Note: to support the above filter no code changes to the upstream kerne=
l nor to iproute2 package is required.
>>>
>>> Furthermore, the most concerning aspect of the current HTB
>>> implementation is its lack of support for multi-queue. All
>>> net-device=E2=80=99s TX queues points to the same HTB instance, resulti=
ng in
>>> high spin-lock contention. This contention (might) negates the overall
>>> performance gains expected by introducing the offload in the first
>>> place. We should modify HTB to present itself as mq qdisc does. By
>>> default, mq qdisc allocates a simple fifo qdisc per TX queue exposed
>>> by the lower layer device. This is only when hardware offload is
>>> configured, otherwise, HTB behaves as usual. There is no HTB code
>>> along the data-path; the only overhead compared to regular traffic is
>>> the classification taking place at clsact. Please note that this
>>> design induces full offload---no fallback to software; it is not
>>> trivial to partial offload the hierarchical tree considering borrowing
>>> between siblings anyway.
>>>
>>>
>>> To summaries: for each HTB leaf-class the driver will allocate a
>>> special queue and match it with a corresponding net-device TX queue
>>> (increase real_num_tx_queues). A unique fifo qdisc will be attached to
>>> any such TX queue. Classification will still take place in software,
>>> but rather at the clsact egress hook. This way we can scale to
>>> thousands of classes while maintaining wire-speed performance and
>>> reducing CPU overhead.
>>>
>>> Any feedback will be much appreciated.
>> Other than echoing Dave's concern around baking FIFO semantics into
>> hardware, maybe also consider whether implementing the required
>> functionality using EDT-based semantics instead might be better? I.e.,
>> something like this:
>> https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-an=
d-BPF
>
> Sorry for the long delay.
>
> The above talk description is quite concise, I can only speculate how
> this EDT+BPF+FQ might work. Anyway, we have a requirement from a
> customer to provide HTB-like semantics including borrowing and
> rate-limiting flow-aggregates. We have a working PoC, which closely
> resembles the aforementioned description, including hardware
> offload.=C2=A0=C2=A0
>
> Is it possible to construct hierarchical QoS (for borrowing purposes)
> using EDT+BPF+FQ?

I believe so. Haven't worked out the details of how to make it
equivalent, though, but I'm hoping that is what that talk will do.
Adding some of the speakers to Cc, maybe they can comment? :)

> Is it applicable only for TCP?

No, EDT is applicable to all packets.

-Toke

