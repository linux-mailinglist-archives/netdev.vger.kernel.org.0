Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CCD369B59
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243971AbhDWUeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:34:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243982AbhDWUeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 16:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619210015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxv+eK3VsonES36bxEQWpXlG3jgPqMbDhIv0ee7Wh+A=;
        b=V16+eTygeoXeJMB75IekiRPwTBB5OnjMucJmM+z6AvCiC7vpbJjJEZeOMfTS1GC6p2oepo
        Wa1a3zSdXJux7/ZvuEZcIby/jzOTmdgQxBsi7O9N/EIQSjxp8Ljlnvsa3dakZSAYnBTpFu
        GK+hLqCbQvptUF2bne99o/F0J29tC7I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-cMieo2xcOMybT7NLzput_A-1; Fri, 23 Apr 2021 16:33:32 -0400
X-MC-Unique: cMieo2xcOMybT7NLzput_A-1
Received: by mail-ed1-f70.google.com with SMTP id f1-20020a0564021941b02903850806bb32so13242983edz.9
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 13:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dxv+eK3VsonES36bxEQWpXlG3jgPqMbDhIv0ee7Wh+A=;
        b=LPSNx7TxqOR4scFmp7WlfTiFkW6aoo9KNxQQv//yelgZLAUMkNPBahqpHN9BohjD5C
         f2tmsRqBZAwDYUVnZO9OHPa96An2iLFQjKkDVmpB7P0zAZcusSQYuMS8oGJB1PpWXSEv
         /+KBfwmH+OA5/sUYguL7x2LfXhU/ieAecK1GcF7J5gfN/a7fEELBd3H4JYtzM8laqz9z
         eU2hVNbeNflFaHwgWoLzFbwy/SCNfBiQeLpBc1hn9xyQbz3KWldRS/V5HygPOMWK0zLo
         MCAcUO7Z13g1R2YSKOxhBFsDPyO9/xtwj0NVFnRZzV4e46AALSJR5PfYnlZYPWDAcnFK
         PrMw==
X-Gm-Message-State: AOAM533/vHkW0ZyJqBFll02WH6jZn1HmucgkKBFD8w2W0iPrE/OtzZ4h
        xjTkbMMXhB42dD5S+FJKNPc41ZZFf2n3oRDYf4H11cK2DFwLBC643a+NWsd+q/8fNRCYFwhhsTu
        hfwq5izLBWVVrssfZ
X-Received: by 2002:a17:907:760a:: with SMTP id jx10mr6320935ejc.126.1619210010773;
        Fri, 23 Apr 2021 13:33:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTC17NMMXiX25qJQ1QoUtqcHewaljQmOwcOb8nTDv7bqobHsMueJkvNlu8YaxXnLe0Ja2cNw==
X-Received: by 2002:a17:907:760a:: with SMTP id jx10mr6320909ejc.126.1619210010403;
        Fri, 23 Apr 2021 13:33:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o17sm5745216edt.92.2021.04.23.13.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 13:33:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 50735180675; Fri, 23 Apr 2021 22:33:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH RFC bpf-next 4/4] i40e: remove rcu_read_lock() around
 XDP program invocation
In-Reply-To: <20210423135704.GC64904@ranger.igk.intel.com>
References: <161917591559.102337.3558507780042453425.stgit@toke.dk>
 <161917591996.102337.9559803697014955421.stgit@toke.dk>
 <20210423135704.GC64904@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 23 Apr 2021 22:33:29 +0200
Message-ID: <87k0oseo6e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Fri, Apr 23, 2021 at 01:05:20PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> The i40e driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
>> program invocations. However, the actual lifetime of the objects referred
>> by the XDP program invocation is longer, all the way through to the call=
 to
>> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
>> turns out to be harmless because it all happens in a single NAPI poll
>> cycle (and thus under local_bh_disable()), but it makes the rcu_read_loc=
k()
>> misleading.
>
> Okay, but what about the lifetime of the xdp_prog itself? Can xdp_prog
> change within a single NAPI poll? After reading previous discussions I
> would say it can't, right?

Well, bpf_prog objects are also RCU-protected so it's at least
guaranteed to stay alive until the end of the NAPI poll. But I don't
think there's anything preventing the program from being changed in the
middle of a NAPI poll.

> There are drivers that have a big RCU critical section in NAPI poll, but =
it
> seems that some read a xdp_prog a single time whereas others read it per
> processed frame.
>
> If we are sure that xdp_prog can't change on-the-fly then first low
> hanging fruit, at least for the Intel drivers, is to skip a test against
> NULL and read it only once at the beginning of NAPI poll. There might be
> also other micro-optimizations specific to each drivers that could be done
> based on that (that of course read the xdp_prog per each frame).

I think the main problem this could cause is that the dispatcher code
could have replaced the program in the dispatcher trampoline while the
driver was still using it, which would hurt performance. However,
ultimately this is under the control of the driver, since the program
install is a driver op. For instance, i40e_xdp_setup() does a
conditional synchronize_rcu() after removing a program; making this
unconditional (and maybe moving it after the writes to the rx_ring prog
pointers?) would ensure that the NAPI cycle had ended before the
bpf_op() call in dev_xdp_install(), which would delay the trampoline
replace.

I guess there could then be a window where the new program is being used
but has not been installed into the trampoline yet, then, so maybe
delaying that replace is not actually terribly important? Adding Bj=C3=B6rn,
maybe he has a better idea.

> Or am I nuts?

No I don't think so :)

I guess it remains to be seen whether there's a real performance
benefit, but at least I don't think there would be any safety or
correctness issues with attempting this.

-Toke

