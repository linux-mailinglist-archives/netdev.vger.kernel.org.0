Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AC114F905
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgBAQsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:48:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726669AbgBAQsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580575716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bMQnrNf2XVcrlI0NWWvkv+BfgLieDCMHZ7gq6MV9Fyk=;
        b=hrnLWT5wTCIWHR935xU9yuCI+YnF7qYfSgtkOJBNJfLo3u+EtPm07XVl6Tr83uXFg44loX
        3imbKSm+q8qSde6QfOh5EQQYiM36C0owY+FR7FGjahuVbfVohFgCYzVLuR1nRwKbodsb+9
        hJ4ZZw2PhVoJvu4rnFo1ql94Q7q5JRo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-1xvYXCtwPDSX-4czz41YiA-1; Sat, 01 Feb 2020 11:48:32 -0500
X-MC-Unique: 1xvYXCtwPDSX-4czz41YiA-1
Received: by mail-lj1-f198.google.com with SMTP id d14so2547295ljg.17
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:48:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bMQnrNf2XVcrlI0NWWvkv+BfgLieDCMHZ7gq6MV9Fyk=;
        b=V/kwXbuLU2OXQRwP3d6U0t3qGIJnVVeFerSqTzns0xUG6iL8kQ3BGhZzwf4P82PYod
         m2kULJ/Rw0iMtb89LO0gBrfUDTWHSO5f5VVCWxKtcWXWU+sxGgyqU9MHrQO/GKg1lUn6
         ebekBybUPJc8LI3FPW/Xig7slRfV73cqp22OOzv1QbRP9H/iYDAQP0cw0mTdYfw9Tz05
         q7aamKV8okGlAlgMgosc2magKUhT4Sa/srDiHHI3SLfmOs8PXtQq8fwvs269hANJdd20
         0ji6CpMbEj/3aveph1wWykW9q813dDDHwRKvmvERxq9oamxV047rL2/9G4AKOLZTTpOl
         1L1w==
X-Gm-Message-State: APjAAAXRHJkTrrOA/AImnrAS5INrjSJrOYiJRmavHmXPK2i0Z/d6qtPR
        d+4Gfx0YMMiQ5CfSiaGYhNdAWR9NDzbfsKBnjaJgu7l/6Mj/lPMRwnVNCF0XbTLib39ItjJYNv1
        WnszZm8BErudZD2mC
X-Received: by 2002:ac2:44bc:: with SMTP id c28mr7887982lfm.72.1580575710930;
        Sat, 01 Feb 2020 08:48:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxcG+yQWhqN/j0ZrgrsI+78PKFTm4E81VMgOtPDXVySn2YjmwrnYBYyhT/8Ugj2aDthMMyiCA==
X-Received: by 2002:ac2:44bc:: with SMTP id c28mr7887971lfm.72.1580575710646;
        Sat, 01 Feb 2020 08:48:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z8sm6766169ljk.13.2020.02.01.08.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:48:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D17771800A2; Sat,  1 Feb 2020 17:48:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yossi Kuperman <yossiku@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [RFC] Hierarchical QoS Hardware Offload (HTB)
In-Reply-To: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com>
References: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 01 Feb 2020 17:48:26 +0100
Message-ID: <87y2tmckyt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yossi Kuperman <yossiku@mellanox.com> writes:

> Following is an outline briefly describing our plans towards offloading H=
TB functionality.
>
> HTB qdisc allows you to use one physical link to simulate several
> slower links. This is done by configuring a hierarchical QoS tree;
> each tree node corresponds to a class. Filters are used to classify
> flows to different classes. HTB is quite flexible and versatile, but
> it comes with a cost. HTB does not scale and consumes considerable CPU
> and memory. Our aim is to offload HTB functionality to hardware and
> provide the user with the flexibility and the conventional tools
> offered by TC subsystem, while scaling to thousands of traffic classes
> and maintaining wire-speed performance.=C2=A0
>
> Mellanox hardware can support hierarchical rate-limiting;
> rate-limiting is done per hardware queue. In our proposed solution,
> flow classification takes place in software. By moving the
> classification to clsact egress hook, which is thread-safe and does
> not require locking, we avoid the contention induced by the single
> qdisc lock. Furthermore, clsact filters are perform before the
> net-device=E2=80=99s TX queue is selected, allowing the driver a chance to
> translate the class to the appropriate hardware queue. Please note
> that the user will need to configure the filters slightly different;
> apply them to the clsact rather than to the HTB itself, and set the
> priority to the desired class-id.
>
> For example, the following two filters are equivalent:
> 	1. tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80 clas=
sid 1:10
> 	2. tc filter add dev eth0 egress protocol ip flower dst_port 80 action s=
kbedit priority 1:10
>
> Note: to support the above filter no code changes to the upstream kernel =
nor to iproute2 package is required.
>
> Furthermore, the most concerning aspect of the current HTB
> implementation is its lack of support for multi-queue. All
> net-device=E2=80=99s TX queues points to the same HTB instance, resulting=
 in
> high spin-lock contention. This contention (might) negates the overall
> performance gains expected by introducing the offload in the first
> place. We should modify HTB to present itself as mq qdisc does. By
> default, mq qdisc allocates a simple fifo qdisc per TX queue exposed
> by the lower layer device. This is only when hardware offload is
> configured, otherwise, HTB behaves as usual. There is no HTB code
> along the data-path; the only overhead compared to regular traffic is
> the classification taking place at clsact. Please note that this
> design induces full offload---no fallback to software; it is not
> trivial to partial offload the hierarchical tree considering borrowing
> between siblings anyway.
>
>
> To summaries: for each HTB leaf-class the driver will allocate a
> special queue and match it with a corresponding net-device TX queue
> (increase real_num_tx_queues). A unique fifo qdisc will be attached to
> any such TX queue. Classification will still take place in software,
> but rather at the clsact egress hook. This way we can scale to
> thousands of classes while maintaining wire-speed performance and
> reducing CPU overhead.
>
> Any feedback will be much appreciated.

Other than echoing Dave's concern around baking FIFO semantics into
hardware, maybe also consider whether implementing the required
functionality using EDT-based semantics instead might be better? I.e.,
something like this:
https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-B=
PF

-Toke

