Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136FDF5A51
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfKHVnI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 16:43:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732101AbfKHVnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:43:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D74BA153873A8;
        Fri,  8 Nov 2019 13:43:07 -0800 (PST)
Date:   Fri, 08 Nov 2019 13:43:07 -0800 (PST)
Message-Id: <20191108.134307.2153170175114525963.davem@davemloft.net>
To:     toke@redhat.com
Cc:     daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/6] libbpf: Propagate EPERM to caller on
 program load
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157324878850.910124.10106029353677591175.stgit@toke.dk>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
        <157324878850.910124.10106029353677591175.stgit@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 13:43:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Fri, 08 Nov 2019 22:33:08 +0100

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> When loading an eBPF program, libbpf overrides the return code for EPERM
> errors instead of returning it to the caller. This makes it hard to figure
> out what went wrong on load.
> 
> In particular, EPERM is returned when the system rlimit is too low to lock
> the memory required for the BPF program. Previously, this was somewhat
> obscured because the rlimit error would be hit on map creation (which does
> return it correctly). However, since maps can now be reused, object load
> can proceed all the way to loading programs without hitting the error;
> propagating it even in this case makes it possible for the caller to react
> appropriately (and, e.g., attempt to raise the rlimit before retrying).
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
