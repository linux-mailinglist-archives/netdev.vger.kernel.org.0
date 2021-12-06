Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2F346A8D5
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349842AbhLFU6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:58:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42168 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbhLFU6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:58:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF52BCE184A;
        Mon,  6 Dec 2021 20:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC0AC341C2;
        Mon,  6 Dec 2021 20:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638824113;
        bh=90p7cycvlHZGfxzaQIFCGfYcquCZTldPs0yaZp8RYKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KONZ9f3NCQEtOeGnz7YgrzluHmar6+JyNGZJX5R8u1A8trnX/0nJGhZ9UFZtey+zl
         1umAR3qZrXxe496Dv4m6bu+8Hqj+0VYWF4X8mlZOvxqFx6dcfUvM3d8qV+ohE+5/So
         hlCb3VwaD6jeXXGTjO46DoET4NjSZCihwAbADLhBGiLQI8nCAAGhxOPpZdrZcJvxgz
         dtNrQQtJeRAcfcw4zfzeHzl/BYXkvIR5W7T+PGCTSZ7RtIZnspIY+/kwsTbHKq+0au
         5b7Y4O1M1r3D1RpRUSVXZw0qg7W0F6MB4leqy6yJSu4Fp9KqhyK26RuRR22gr6Zwxv
         xgrVXxxvnNqgg==
Date:   Mon, 6 Dec 2021 12:55:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Louis Amas <louis.amas@eho.link>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 net 1/1] net: mvpp2: fix XDP rx queues registering
Message-ID: <20211206125513.5e835155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206172220.602024-1-louis.amas@eho.link>
References: <20211206172220.602024-1-louis.amas@eho.link>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 18:22:19 +0100 Louis Amas wrote:
> The registration of XDP queue information is incorrect because the
> RX queue id we use is invalid. When port->id == 0 it appears to works
> as expected yet it's no longer the case when port->id != 0.
> 
> The problem arised while using a recent kernel version on the
> MACCHIATOBin. This board has several ports:
>  * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
>  * eth2 is a 1Gbps interface with port->id != 0.

Still doesn't apply to net/master [1]. Which tree is it based on?
Perhaps you are sending this for the BPF tree? [2] Hm, doesn't apply
there either...

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/
