Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F05B137129
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgAJP0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:26:39 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34321 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727866AbgAJP0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578669997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vAXUBzgCVtjH+yaI1yeAUtLpb8LH57sAuY25T356fo=;
        b=CNZGR5jb4Zk0MrqX8m+xT3pwAIaH21PiaVZctlwkKqTzNkCqbBNCTVUliSKm1QNbwiJh6+
        ZzqOsVq8+FWmYf1juyyT3dkdvnPIADhjPCvX+Kfql2BYPTJ6wkIj5BVrB8fDyx3hNB73py
        GW9UDGfiotQ8IVjHJvX6bb6FocQjahc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-5qlkbj3rNbGQtl0wJTjLYw-1; Fri, 10 Jan 2020 10:26:36 -0500
X-MC-Unique: 5qlkbj3rNbGQtl0wJTjLYw-1
Received: by mail-wr1-f69.google.com with SMTP id j4so1059825wrs.13
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 07:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3vAXUBzgCVtjH+yaI1yeAUtLpb8LH57sAuY25T356fo=;
        b=mgL42cWS+8mXUmzgyor/+keJmiuvia60GB9e3U8JP9Qk0FR1vBCgn2GTvS69G62WXj
         GZBnF9uIr7HCIo5t3M8B09xFrKtRcw/p623DmD+nSJzazOs0RGYVIFn0nEVzm0aSnD5E
         N3eDvedGENYF7qMlKWtJesTDcQu21xvkMvZl90Nwo2YiBBL+wfXjtnyOkwCHn83Ou5ha
         LQZue5V/BwADgJ6sko6N2KoZDxfFJaGsPE/5uPqFj3ATX9iNwoRmRaxFRGJrLLaIS0zi
         83nQtSoGT0aH5UgAzy2c7JTih6YA+DP5XlyfBn198k8OgsVY6oiOP4FcQ2FWHCmEhVhH
         cvVw==
X-Gm-Message-State: APjAAAWTjo3T56xmyzLjyLu0Vhv8WPFIgXvjF9+D+GkisyC4CekG87As
        zEvUZRnG9K+Y7X8p2h3cvPNUiXCrXgQZ1Z/dTp8TqavXuyv/I1/RSTdv4jPTu+t6O5LVIDqbEVK
        M8/Peb+NlxxXPrEfA
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr5165909wma.6.1578669994785;
        Fri, 10 Jan 2020 07:26:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCp80Y1ye3xZIZjQUNlok/NaqdULkmUuIboYWbtJ3IsHrtrf6OqdtizfN4G8oLhtMR62zp3A==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr5165885wma.6.1578669994592;
        Fri, 10 Jan 2020 07:26:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a1sm2487350wmj.40.2020.01.10.07.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:26:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6E5C518009F; Fri, 10 Jan 2020 16:26:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 1/2] xdp: Move devmap bulk queue into struct net_device
In-Reply-To: <CAJ+HfNgkouU8=T2+Of1nAfwBQ-eqCKKAqrNzhhEafw5qW8bO_w@mail.gmail.com>
References: <157866612174.432695.5077671447287539053.stgit@toke.dk> <157866612285.432695.6722430952732620313.stgit@toke.dk> <CAJ+HfNgkouU8=T2+Of1nAfwBQ-eqCKKAqrNzhhEafw5qW8bO_w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Jan 2020 16:26:33 +0100
Message-ID: <87ftgnxrh2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Fri, 10 Jan 2020 at 15:22, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> Commit 96360004b862 ("xdp: Make devmap flush_list common for all map
>> instances"), changed devmap flushing to be a global operation instead of=
 a
>> per-map operation. However, the queue structure used for bulking was sti=
ll
>> allocated as part of the containing map.
>>
>> This patch moves the devmap bulk queue into struct net_device. The
>> motivation for this is reusing it for the non-map variant of XDP_REDIREC=
T,
>> which will be changed in a subsequent commit.
>>
>> We defer the actual allocation of the bulk queue structure until the
>> NETDEV_REGISTER notification devmap.c. This makes it possible to check f=
or
>> ndo_xdp_xmit support before allocating the structure, which is not possi=
ble
>> at the time struct net_device is allocated. However, we keep the freeing=
 in
>> free_netdev() to avoid adding another RCU callback on NETDEV_UNREGISTER.
>>
>> Because of this change, we lose the reference back to the map that
>> originated the redirect, so change the tracepoint to always return 0 as =
the
>> map ID and index. Otherwise no functional change is intended with this
>> patch.
>>
>
> Nice work, Toke!

Thanks!

> I'm getting some checkpatch warnings (>80 char lines), other than
> that:

Oh, right, totally forgot to run checkpatch; will fix and respin :)

-Toke

