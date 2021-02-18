Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F040E31F081
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhBRTyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhBRTtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:49:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84CA864E76;
        Thu, 18 Feb 2021 19:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613677743;
        bh=SYtSkHlu2EXJRk0tbziB5xsPkOTfkNrnnAOYvujKArE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZyHxabcqlg9QpnFzGtIihpM6W47iTuCK0OeMwURWsdjwxpTDQi0q/upqPCoDkE50C
         himXD2B5vFKS2LSXT6YDWNYNkAqagtEDsWYiHMYtuSNxoSLbP3h4HhyJpTEjZb9dB7
         MrW1/6KBXPMlYPOIGYKUAfb9ZydKHMNOMwH8nY778hfW4OmMPeP8X3Mpr1ltFA6IWI
         eQEZibOPM+Dj+htyT2pmu/3wLQPX0z7AYnIm/H/AXk5liRzHNrGv1eNMj6IMECJp7T
         vjwequUCAoCyRwee2UkQJPjj6UB62nbKoECOUVPvJFBEcQ0lFHNuKtWJL4zRNGQM6g
         aXSPUub2lX86g==
Date:   Thu, 18 Feb 2021 11:49:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v7 bpf-next 0/6] xsk: build skb by page (aka generic
 zerocopy xmit)
Message-ID: <20210218114901.1787c7f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <602e0477af4c2_1f0ef2088e@john-XPS-13-9370.notmuch>
References: <20210217120003.7938-1-alobakin@pm.me>
        <602e0477af4c2_1f0ef2088e@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021 22:08:55 -0800 John Fastabend wrote:
> > ---------------- Performance Testing ------------
> > 
> > The test environment is Aliyun ECS server.
> > Test cmd:
> > ```
> > xdpsock -i eth0 -t  -S -s <msg size>
> > ```
> > 
> > Test result data:
> > 
> > size    64      512     1024    1500
> > copy    1916747 1775988 1600203 1440054
> > page    1974058 1953655 1945463 1904478
> > percent 3.0%    10.0%   21.58%  32.3%
> >   
> 
> For the series, but might be good to get Dave or Jakub to check
> 2/6 to be sure they agree.

Not sure if Dave would consider holding this series just because of
this, but I'm not a huge fan. I think moving towards a bitfield would
be a better direction an all these flags and defines.

This series is not the place for such effort, so perhaps drop patch 2,
leave it be and follow up with a conversion to a bitfield?
