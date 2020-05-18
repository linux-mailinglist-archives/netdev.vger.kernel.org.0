Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300511D7532
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgERKaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 06:30:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26191 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726127AbgERKay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 06:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589797853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LedRmlRu6OajiFgt/NOmsoRP5Y5bC9tTiylGjAvIHJc=;
        b=ALhQiFYuSBcbCJxgYwh//fcT5lUDq4PAGs29Xj7QvqmDBYuDvs6xMfpX45i0i92XNj5iFz
        6kG6Eiw64R5PGb0sW7TWXeP0Kwhn4Z/NchM9iCMrpDBUnpXsYOquC0wEXhmKV7y/tDeu2T
        4T7EAJdUXU65KXPtexBFjSJWoMcwJCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-q21A8RTnOhG4MsjAfhqwLA-1; Mon, 18 May 2020 06:30:50 -0400
X-MC-Unique: q21A8RTnOhG4MsjAfhqwLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A631800D42;
        Mon, 18 May 2020 10:30:47 +0000 (UTC)
Received: from carbon (unknown [10.40.208.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2AC48208F;
        Mon, 18 May 2020 10:30:31 +0000 (UTC)
Date:   Mon, 18 May 2020 12:30:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     sameehj@amazon.com, Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Andrii Nakryiko <andriin@fb.com>, brouer@redhat.com
Subject: Re: unstable xdp tests. Was: [PATCH net-next v4 31/33] bpf: add
 xdp.frame_sz in bpf_prog_test_run_xdp().
Message-ID: <20200518123030.5f316e23@carbon>
In-Reply-To: <20200518115234.3b6925de@carbon>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
        <158945349549.97035.15316291762482444006.stgit@firesoul>
        <CAADnVQLtJotzY==OfOHmA-KdTb6bF7uqKVYGhnPj-oyzSZ8C_g@mail.gmail.com>
        <20200518115234.3b6925de@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 11:52:34 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> ... I'm getting unrelated compile errors for selftests/bpf in
> bpf-next tree (HEAD 96586dd9268d2).
> 
> The compile error, see below signature, happens in ./progs/bpf_iter_ipv6_route.c
> (tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c).
> 
> Related to commit:
>  7c128a6bbd4f ("tools/bpf: selftests: Add iterator programs for ipv6_route and netlink") (Author: Yonghong Song)

After re-compiling the kernel in the same tree, this issue goes away.

I guess this is related to:
  #include "vmlinux.h"

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

