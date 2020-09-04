Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF5225E446
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgIDXju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727921AbgIDXjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 19:39:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06772078E;
        Fri,  4 Sep 2020 23:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262789;
        bh=MbZ8RG/thLc0NaLAdaiUmSBegJyYkMHUTLqZ1wArOqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZCsSf1ewq9vFA6lBG2W3w55CLyFoeH+RRQAGtMC5LgcZNWabBApb8PEHzTRAx2nNo
         xfz+M49ggs0YCiAJQqTGiSiPyrWopOT6yafR0duktO1EUxBkatg/GOoINiMoKj0luN
         YDsgOiiHKr+JyDOm/JDo6UpFdM9T9Fv+/QxhJma0=
Date:   Fri, 4 Sep 2020 16:39:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next] bpf: don't check against device MTU in
 __bpf_skb_max_len
Message-ID: <20200904163947.20839d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <159921182827.1260200.9699352760916903781.stgit@firesoul>
References: <159921182827.1260200.9699352760916903781.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Sep 2020 11:30:28 +0200 Jesper Dangaard Brouer wrote:
> @@ -3211,8 +3211,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>  
>  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
>  {
> -	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> -			  SKB_MAX_ALLOC;
> +	return SKB_MAX_ALLOC;
>  }
>  
>  BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
> 

Looks familiar:

https://lore.kernel.org/netdev/20200420231427.63894-1-zenczykowski@gmail.com/
