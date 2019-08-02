Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C1A7FF48
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404060AbfHBRJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:09:11 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41057 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732476AbfHBRJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:09:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id t187so2655540qke.8
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oS3nEVoGihvyyr8f8rFtFSJ7zKhMaXgQLLAhY5gWvVw=;
        b=oJFfDCoP8yCha1YrlfhCcisDdbS9C1J2UWBMamdQZcF06BgVezQM18Tr0b2sfrhWT4
         8Q0u8uqRs8kxb+iq7KZSfkHxXDjBFUeBRuJN1mqD4oEhMjF8WxIA1cVBnin8O3V5PHfM
         OrwWgUjp3JD+Lfb0TJVEZ/h1xjLyWPdPeEwlKznlchAgCbzdzjudH1xpqgAUIrdnSyC5
         lC8aYwDLY0UKHDLeggwcq64s4SKJ6/imXvvb3NhHBipPzXokccxMm8zNWKu4VjYRF2Ed
         arhXZ77yC8g5gVLfKM+N+JOxQkoVInzb9SFhVmSel02pqrgsAwBeT/bpCSQCGFZq+yRT
         TVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oS3nEVoGihvyyr8f8rFtFSJ7zKhMaXgQLLAhY5gWvVw=;
        b=RYEVc/TV7pGlq7z3DE1hn4W7YmlaAzTN2fd1t0RhPsXM+D0HU1jjKiq2FX4vDXbOk4
         ys3d4rzwfMIOBkIub9Z7A7/pZoFqJ5Byqj1C2lpBO7TWtdULTwirL35nAZPX9Ig/zDMD
         02OCwIeKQ2gpbZ8Zv7h6tiYZeuA4zv84OkpP8QDPKZTWmvKYHsNGFwOlEVJyrOnXE4B2
         fen8m9bte4V9GlNqo9Ihxavqhb70NBBJChBWWHNHNxYbzNz9GYm2NwxzriEdHUTyg3/a
         jYI4V8zex3zPFFX4W2u1/h5wkmHiUmoJyBiukdGVB4G5kP6MHJl8IER75+hZh/ST+x8Q
         dctg==
X-Gm-Message-State: APjAAAU7yXGfID8nubKkIdlzmzDDgZG4p+RcwOn2rwHdjVemdyh1124w
        fI5lPvnVzQ4UkXlxytYbYDfctw==
X-Google-Smtp-Source: APXvYqx7BuW3qQp7HAMkWBCHi4FN0r+FDfhPHSa3kfbiKqT+FqEI3D+85aVB31w9yxwaynZOVLbDcQ==
X-Received: by 2002:a05:620a:15d7:: with SMTP id o23mr90666304qkm.125.1564765750425;
        Fri, 02 Aug 2019 10:09:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm36073771qtd.72.2019.08.02.10.09.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 10:09:10 -0700 (PDT)
Date:   Fri, 2 Aug 2019 10:08:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        xdp-newbies@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        brandon.cazander@multapplied.net,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [net v1 PATCH 4/4] net: fix bpf_xdp_adjust_head regression for
 generic-XDP
Message-ID: <20190802100851.62d67139@cakuba.netronome.com>
In-Reply-To: <20190802095350.7242399b@carbon>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
        <156468243184.27559.7002090473019021952.stgit@firesoul>
        <20190801174406.0b554bb9@cakuba.netronome.com>
        <20190802095350.7242399b@carbon>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Aug 2019 09:53:54 +0200, Jesper Dangaard Brouer wrote:
> On Thu, 1 Aug 2019 17:44:06 -0700
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> 
> > On Thu, 01 Aug 2019 20:00:31 +0200, Jesper Dangaard Brouer wrote:  
> > > When generic-XDP was moved to a later processing step by commit
> > > 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> > > a regression was introduced when using bpf_xdp_adjust_head.
> > > 
> > > The issue is that after this commit the skb->network_header is now
> > > changed prior to calling generic XDP and not after. Thus, if the header
> > > is changed by XDP (via bpf_xdp_adjust_head), then skb->network_header
> > > also need to be updated again.  Fix by calling skb_reset_network_header().
> > > 
> > > Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> > > Reported-by: Brandon Cazander <brandon.cazander@multapplied.net>
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>    
> > 
> > Out of curiosity what was your conclusion regarding resetting the
> > transport header as well?  
> 
> Well, I don't know... I need some review, from e.g. Stephen that
> changed this... I've added code snippets below signature to helper
> reviewers (also helps understand below paragraph).
> 
> I think, we perhaps should call skb_reset_transport_header(), as we
> change skb->data (via either __skb_pull() or __skb_push()), *BUT* I'm
> not sure it is needed/required, as someone/something afterwards still
> need to call skb_set_transport_header(), which also calls
> skb_reset_transport_header() anyway.

Perhaps you've seen this, but just in case - this is the last commit
that touched the transport header setting in __netif_receive_skb(), 
and it sounds like it matters mostly for qdisc accounting?

commit fda55eca5a33f33ffcd4192c6b2d75179714a52c
Author: Eric Dumazet <edumazet@google.com>
Date:   Mon Jan 7 09:28:21 2013 +0000

    net: introduce skb_transport_header_was_set()
    
    We have skb_mac_header_was_set() helper to tell if mac_header
    was set on a skb. We would like the same for transport_header.
    
    __netif_receive_skb() doesn't reset the transport header if already
    set by GRO layer.
    
    Note that network stacks usually reset the transport header anyway,
    after pulling the network header, so this change only allows
    a followup patch to have more precise qdisc pkt_len computation
    for GSO packets at ingress side.
    
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Jamal Hadi Salim <jhs@mojatatu.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
