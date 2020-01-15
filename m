Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D489713D004
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgAOWWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:22:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729025AbgAOWWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579126972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pb5kk13hCn5LKgLoa/PR7zWqYWBA2ovo8ll8r6arVRU=;
        b=Kq+/z3JmFT1mwVoT5+a2RVAabbyQb2dPBcgGuA0uw8MpxajgeALOhDr5PBAKlRt5Xt+Y+H
        +gL1zsWwFoqqc29RP5osONUnGt6p3I0+BeJEhV9tg4xAj+Dr/jOt4HBWJKuvItx1uAtM21
        zuJjfc0AOXywUsSrpAogP1I4BOAO4rU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-UXEPNjE4OpC031douKJJcQ-1; Wed, 15 Jan 2020 17:22:51 -0500
X-MC-Unique: UXEPNjE4OpC031douKJJcQ-1
Received: by mail-lj1-f197.google.com with SMTP id u9so4477519ljg.12
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 14:22:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Pb5kk13hCn5LKgLoa/PR7zWqYWBA2ovo8ll8r6arVRU=;
        b=ZZ9xxbTjEA3g1n7+X/NkYU2LDx47sRRmm79dIOJxVBdNhPzx/9j+FWhQNpHb5EuoHA
         a9uIAXjQzvScMpwQnTGScZmSdkK0Nurtetsf1CmaXP4/w4iLSPlFwe2CUALpanvr+RTp
         aS7JffINMNfvuSMQ73+Ysj4Yy3UnVEw2nuVZat87mROc7kEC3yYIiFWrUhhXVKyFsc5f
         6dfue12DzgX9jaM0MmUni8TGTd/fdyn+S3b7X8OB5Pvbkt9F1xwLXNHkuj0d7MCArODe
         +tb6R0jWdQ3/gXQYjDEOe6DaTV2YrE3kDqnJFOt1g9Y4Fbc++K+WKcw644Zruliv5Cfw
         Ff7w==
X-Gm-Message-State: APjAAAUc/DvtQVe2uQHF3qp/yEP6se4UE042hcXLxw+br8+fVwEe9axk
        skvBwtA3VzD3oK3w8x5I5zGer4i1Nn++c9bhrTl1OYU+cK0SOdLoEqwbJ7N94sqy//AQOJF1+s8
        ixx2i/JO6VVx2Wuxt
X-Received: by 2002:a05:651c:327:: with SMTP id b7mr375235ljp.22.1579126968751;
        Wed, 15 Jan 2020 14:22:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhxH4gFZXsNjM2JkURV8FcMiFxuLIWJLSeibNOlvTg86PWP63JcNetHVuKrHQveyIzWdbXsg==
X-Received: by 2002:a05:651c:327:: with SMTP id b7mr375222ljp.22.1579126968569;
        Wed, 15 Jan 2020 14:22:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a12sm9783496ljk.48.2020.01.15.14.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 14:22:47 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 56AD01804D6; Wed, 15 Jan 2020 23:22:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: RE: [PATCH bpf-next v2 1/2] xdp: Move devmap bulk queue into struct net_device
In-Reply-To: <5e1f6bd0cb367_72f02acbae15e5c44a@john-XPS-13-9370.notmuch>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk> <157893905569.861394.457637639114847149.stgit@toke.dk> <5e1f6bd0cb367_72f02acbae15e5c44a@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 15 Jan 2020 23:22:47 +0100
Message-ID: <87d0bktl54.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> Commit 96360004b862 ("xdp: Make devmap flush_list common for all map
>> instances"), changed devmap flushing to be a global operation instead of=
 a
>> per-map operation. However, the queue structure used for bulking was sti=
ll
>> allocated as part of the containing map.
>>=20
>> This patch moves the devmap bulk queue into struct net_device. The
>> motivation for this is reusing it for the non-map variant of XDP_REDIREC=
T,
>> which will be changed in a subsequent commit.  To avoid other fields of
>> struct net_device moving to different cache lines, we also move a couple=
 of
>> other members around.
>>=20
>> We defer the actual allocation of the bulk queue structure until the
>> NETDEV_REGISTER notification devmap.c. This makes it possible to check f=
or
>> ndo_xdp_xmit support before allocating the structure, which is not possi=
ble
>> at the time struct net_device is allocated. However, we keep the freeing=
 in
>> free_netdev() to avoid adding another RCU callback on NETDEV_UNREGISTER.
>>=20
>> Because of this change, we lose the reference back to the map that
>> originated the redirect, so change the tracepoint to always return 0 as =
the
>> map ID and index. Otherwise no functional change is intended with this
>> patch.
>>=20
>> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> LGTM. I didn't check the net_device layout with pahole though so I'm
> trusting they are good from v1 discussion.

I believe so; looks like this now:

	/* --- cacheline 14 boundary (896 bytes) --- */
	struct netdev_queue *      _tx __attribute__((__aligned__(64))); /*   896 =
    8 */
	unsigned int               num_tx_queues;        /*   904     4 */
	unsigned int               real_num_tx_queues;   /*   908     4 */
	struct Qdisc *             qdisc;                /*   912     8 */
	unsigned int               tx_queue_len;         /*   920     4 */
	spinlock_t                 tx_global_lock;       /*   924     4 */
	struct xdp_dev_bulk_queue * xdp_bulkq;           /*   928     8 */
	struct xps_dev_maps *      xps_cpus_map;         /*   936     8 */
	struct xps_dev_maps *      xps_rxqs_map;         /*   944     8 */
	struct mini_Qdisc *        miniq_egress;         /*   952     8 */
	/* --- cacheline 15 boundary (960 bytes) --- */
	struct hlist_head  qdisc_hash[16];               /*   960   128 */
	/* --- cacheline 17 boundary (1088 bytes) --- */
	struct timer_list  watchdog_timer;               /*  1088    40 */

	/* XXX last struct has 4 bytes of padding */

	int                        watchdog_timeo;       /*  1128     4 */

	/* XXX 4 bytes hole, try to pack */

	int *                      pcpu_refcnt;          /*  1136     8 */
	struct list_head   todo_list;                    /*  1144    16 */
	/* --- cacheline 18 boundary (1152 bytes) was 8 bytes ago --- */

-Toke

