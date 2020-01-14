Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725A813AF94
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgANQjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:39:40 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51515 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgANQjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:39:40 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so14579125wmd.1
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C3p2+I6XIiPde25qdeyIJDGhEFg+Ro6+sG30PTIV69s=;
        b=K3LUyYlH5iR5IyQ+j/0fDj4QB3wJibpxShnNEZ64Amb5wRVrULxame8yGJt05Q7hYO
         0Zf2UR1IoFl848kmBbjY5FLGw80vbJ0jDdoxHJNzs06xEHHPkh+Uq2EA77k6wc0uL+JV
         UL+fuJoB+vywTGlfn109yohW1qbknKxlCcsys3DYbTGXNKlAe8EspL3NKVJQGLUOEV75
         Zj0q2vDCDDn5x28iEERQ5trxLmSSoYNu3SYBxYwftl5EZEJ/SmV6Ki3k23WRcK8u9qrx
         73v/jIUlCvGliIoaVgpIh4+FcL/AjjWhtCPcLxJiCqGAikHldzvwHPuyj+WeuV+duqyq
         nSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C3p2+I6XIiPde25qdeyIJDGhEFg+Ro6+sG30PTIV69s=;
        b=g7fkZuJSmd6tLiC8856VWo6rwUTMUXt8NJbhneYrWcdW/Iqpn0SoEhceJgVqIW/Vw2
         vqSWfRDwrzPO65MjAkb+BleXdk4zbhAD1lsW07SNPvCRr8vJ0OPl2dt/JOjlMr0ZnMol
         lFT600UPdQOAyVubk3a+B6H81H9KYQl/mLSX+MPQZD8gK3kXrOfy44Vzghrfly3AK/Mt
         v9IuVsSY1rYtSw4Dg7w2cs5reGilUEs+19Lf8znZhSCo+nOED3cIcZPLxar+mZBME2/g
         vLQr7j3/T2DjrK2YXtaX86qK/qFFyD8A20BNVtc8trgtGPdm3p4bGQmJIW6RKp1dPA6m
         ceqg==
X-Gm-Message-State: APjAAAWDZEXVJNTd3uWuyCm4GfytZbZ40XwWbOcAhWYOt/jlxviLf5Ro
        axFiQH5dSRkkY8rTpE0Cr6L+rA==
X-Google-Smtp-Source: APXvYqzmeU65JSZAngtS0sJ9jTd2/gdd0+DRDya3tajXcam9X0/s462WcmcW9TwdDZ5ohYHcpE8SGQ==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr27744267wmk.124.1579019978252;
        Tue, 14 Jan 2020 08:39:38 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id k13sm20094102wrx.59.2020.01.14.08.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 08:39:37 -0800 (PST)
Date:   Tue, 14 Jan 2020 17:39:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 03/10] ipv4: Add "offload" and "trap"
 indications to routes
Message-ID: <20200114163936.GN2131@nanopsycho>
References: <20200114112318.876378-1-idosch@idosch.org>
 <20200114112318.876378-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114112318.876378-4-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 14, 2020 at 12:23:11PM CET, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>When performing L3 offload, routes and nexthops are usually programmed
>into two different tables in the underlying device. Therefore, the fact
>that a nexthop resides in hardware does not necessarily mean that all
>the associated routes also reside in hardware and vice-versa.
>
>While the kernel can signal to user space the presence of a nexthop in
>hardware (via 'RTNH_F_OFFLOAD'), it does not have a corresponding flag
>for routes. In addition, the fact that a route resides in hardware does
>not necessarily mean that the traffic is offloaded. For example,
>unreachable routes (i.e., 'RTN_UNREACHABLE') are programmed to trap
>packets to the CPU so that the kernel will be able to generate the
>appropriate ICMP error packet.
>
>This patch adds an "offload" and "trap" indications to IPv4 routes, so
>that users will have better visibility into the offload process.
>
>'struct fib_alias' is extended with two new fields that indicate if the
>route resides in hardware or not and if it is offloading traffic from
>the kernel or trapping packets to it. Note that the new fields are added
>in the 6 bytes hole and therefore the struct still fits in a single
>cache line [1].
>
>Capable drivers are expected to invoke fib_alias_hw_flags_set() with the
>route's key in order to set the flags.
>
>The indications are dumped to user space via a new flags (i.e.,
>'RTM_F_OFFLOAD' and 'RTM_F_TRAP') in the 'rtm_flags' field in the
>ancillary header.
>
>v2:
>* Make use of 'struct fib_rt_info' in fib_alias_hw_flags_set()
>
>[1]
>struct fib_alias {
>        struct hlist_node  fa_list;                      /*     0    16 */
>        struct fib_info *          fa_info;              /*    16     8 */
>        u8                         fa_tos;               /*    24     1 */
>        u8                         fa_type;              /*    25     1 */
>        u8                         fa_state;             /*    26     1 */
>        u8                         fa_slen;              /*    27     1 */
>        u32                        tb_id;                /*    28     4 */
>        s16                        fa_default;           /*    32     2 */
>        u8                         offload:1;            /*    34: 0  1 */
>        u8                         trap:1;               /*    34: 1  1 */
>        u8                         unused:6;             /*    34: 2  1 */
>
>        /* XXX 5 bytes hole, try to pack */
>
>        struct callback_head rcu __attribute__((__aligned__(8))); /*    40    16 */
>
>        /* size: 56, cachelines: 1, members: 12 */
>        /* sum members: 50, holes: 1, sum holes: 5 */
>        /* sum bitfield members: 8 bits (1 bytes) */
>        /* forced alignments: 1, forced holes: 1, sum forced holes: 5 */
>        /* last cacheline: 56 bytes */
>} __attribute__((__aligned__(8)));
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
