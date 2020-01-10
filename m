Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37D71379BC
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgAJWex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:34:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47380 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727324AbgAJWex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 17:34:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578695693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KrXi1+k3ia7AMd/6a7YmVBY47pi1OCDzyNQAgxAfHZE=;
        b=cyxtCxcxLX1udVGft7FLTD4ERLoLNoeNZeu1LjLJVLi556j6hwqoDstz5BRP4Mppo7dLYy
        feS12Zn5bzrILiug+KKWtPQGdC3CwzdDWZDkGpXL8PHyEysh0S5UKQalvIjohXcCxNTGOr
        G0lDDu+6Vq6N9tythrm6A3ZoP7uyZJM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-hfYxD_7IOPqsZJJh7HHO9Q-1; Fri, 10 Jan 2020 17:34:49 -0500
X-MC-Unique: hfYxD_7IOPqsZJJh7HHO9Q-1
Received: by mail-wr1-f72.google.com with SMTP id v17so1526259wrm.17
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 14:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=KrXi1+k3ia7AMd/6a7YmVBY47pi1OCDzyNQAgxAfHZE=;
        b=TmAUABw8v7kkpPdTYeerjquHyYaLqQkQtSjDYtf7jnv/DC+IPnWe+1XFdtOro4AQ1d
         jU0sQgdgi3Ea/s8BcqjHcGULgfkXSpZ4H/OigSKg1/50kfXCWu8cV4cdpUEH5MDlEwub
         0zL16v/sYBr6EJrhNusSmJgoTC4w7eTni64z7LJ/Zij55JJZH4hQxRn8/udONo7g3ZHJ
         gVjtl9OpouwKdWbDnGYB5NI88AA4PvJEDSr0lYih4nh8FuJnVCxu8iJBH7CF8e5qG87q
         hK49rKf3mGdDITbAEIOjSkaLSzkOBqo5peWpAMD19HA3bgrIgYaGk93FKPdghl4MwS8a
         WZCQ==
X-Gm-Message-State: APjAAAVEbplqSvGOQss0bGxXlcTHO+AtfAgj6gT6Y8XaJs1Tnv5yEf/l
        lbyxFRAEWx4G/KSlRipQ7IbOwSw/C1L17uG92SfOd0q5ch6LjTvibLfDmboVV1/RNCdL0suaTkx
        cQZNNfg0oX/472BOt
X-Received: by 2002:adf:a141:: with SMTP id r1mr5622416wrr.285.1578695688777;
        Fri, 10 Jan 2020 14:34:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqza8fTRJyuCD57cHT7K58/ZLUaDtjrRiErZ4czU4XLvwTaWjYQOrKqzwN6EP46m7Y2aPIqsgw==
X-Received: by 2002:adf:a141:: with SMTP id r1mr5622400wrr.285.1578695688560;
        Fri, 10 Jan 2020 14:34:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n189sm4050850wme.33.2020.01.10.14.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 14:34:47 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1877A18009F; Fri, 10 Jan 2020 23:34:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next 1/2] xdp: Move devmap bulk queue into struct net_device
In-Reply-To: <20200110170824.7379adbf@carbon>
References: <157866612174.432695.5077671447287539053.stgit@toke.dk> <157866612285.432695.6722430952732620313.stgit@toke.dk> <20200110170824.7379adbf@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Jan 2020 23:34:47 +0100
Message-ID: <871rs7x7nc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Fri, 10 Jan 2020 15:22:02 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 2741aa35bec6..1b2bc2a7522e 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
> [...]
>> @@ -1993,6 +1994,8 @@ struct net_device {
>>  	spinlock_t		tx_global_lock;
>>  	int			watchdog_timeo;
>>=20=20
>> +	struct xdp_dev_bulk_queue __percpu *xdp_bulkq;
>> +
>>  #ifdef CONFIG_XPS
>>  	struct xps_dev_maps __rcu *xps_cpus_map;
>>  	struct xps_dev_maps __rcu *xps_rxqs_map;
>
> We need to check that the cache-line for this location in struct
> net_device is not getting updated (write operation) from different CPUs.
>
> The test you ran was a single queue single CPU test, which will not
> show any regression for that case.

Well, pahole says:

	/* --- cacheline 14 boundary (896 bytes) --- */
	struct netdev_queue *      _tx __attribute__((__aligned__(64))); /*   896 =
    8 */
	unsigned int               num_tx_queues;        /*   904     4 */
	unsigned int               real_num_tx_queues;   /*   908     4 */
	struct Qdisc *             qdisc;                /*   912     8 */
	struct hlist_head  qdisc_hash[16];               /*   920   128 */
	/* --- cacheline 16 boundary (1024 bytes) was 24 bytes ago --- */
	unsigned int               tx_queue_len;         /*  1048     4 */
	spinlock_t                 tx_global_lock;       /*  1052     4 */
	int                        watchdog_timeo;       /*  1056     4 */

	/* XXX 4 bytes hole, try to pack */

	struct xdp_dev_bulk_queue * xdp_bulkq;           /*  1064     8 */
	struct xps_dev_maps *      xps_cpus_map;         /*  1072     8 */
	struct xps_dev_maps *      xps_rxqs_map;         /*  1080     8 */
	/* --- cacheline 17 boundary (1088 bytes) --- */


of those, tx_queue_len is the max queue len (so only set on init),
tx_global_lock is not used by multi-queue devices, watchdog_timeo also
seems to be a static value thats set on init, and the xps* pointers also
only seems to be set once on init. So I think we're fine?

I can run a multi-CPU test just to be sure, but I really don't see which
of those fields might be updated on TX...

-Toke

