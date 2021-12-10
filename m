Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58D046F8E2
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhLJCFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:05:22 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39104 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhLJCFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:05:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA671CE2832;
        Fri, 10 Dec 2021 02:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6165BC004DD;
        Fri, 10 Dec 2021 02:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639101705;
        bh=SXmQe5WrM6g41Qmvq9I6gcho6Cqv58rsLN+1+V8bmuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=coU282+4jqhRwK7sGRshcxpvU1tvnDYwm1pjf57aAUH0CnVFsVUb/dgJUIRgNZ5tx
         oD7K+KAaozn+Kg56HwdrD70dqSyUZ9NVyafqy3AcJkFsja/DDPI2conLvhrgID2au8
         eyLOR6bvLNoyZQKByNiA7wazUbphYL+Jfy00IQG4qwu/vPjjBTOTmgCoN4QeZ40V8A
         quufCy+20oQurQk2dxYyjO6jEkbJvRgZ/Rfz9dKxye7dpKwlP56whH+V8D+kLnHll9
         jsGQXi4W/M6tp3yJuM+bkKLTYxqDyKiW7uLNxVL3KkcqArUrI5JddcgSBIhXqYG3IT
         jN+w53cQjEP9A==
Date:   Thu, 9 Dec 2021 18:01:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mathieu Jadin <mathjadin@gmail.com>
Cc:     bpf@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joe@cilium.io>, David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH bpf-next v2 1/3] net: Parse IPv6 ext headers from TCP
 sock_ops
Message-ID: <20211209180143.6466e43a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207225635.113904-1-mathjadin@gmail.com>
References: <20211207225635.113904-1-mathjadin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 23:56:33 +0100 Mathieu Jadin wrote:
> Add a flag that, if set, triggers the call of eBPF program for each
> packet holding an IPv6 extension header. Also add a sock_ops operator
> that identifies such call.
> 
> This change uses skb_data and skb_data_end introduced for TCP options'
> parsing but these pointer cover the IPv6 header and its extension
> headers.
> 
> For instance, this change allows to read an eBPF sock_ops program to
> read complex Segment Routing Headers carrying complex messages in TLV or
> observing its intermediate segments as soon as they are received.

Can you share example use cases this opens up?
