Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F399F34B5F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfFDPCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:02:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35557 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfFDPCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:02:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so375162wrv.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 08:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oXElFlC1nmJaL3v6YFn53FxqpyRpE/8xy6Xrh90NmJo=;
        b=NeCu1OH1LzaV/yOeHCfh2AQGBi3uaCFpfL6P3u8pWVkHeu1M3nK1tN2/n6gYIjSf3s
         WSQm7bbGbeTF+4cl9p6Dv8YMNgZzpXUgak0HYZiDkqXv2y2+56jl2sX4dzcvHd0UjvYN
         znYt1rVYIDekmGkzZqeH7VWe0WABgbAz+qMG0r3pGOWqrgYc69GzxEadF7k3FG1vH7Tz
         t0OVUj3AHe+vd3StVy74He+1f8oAve8bWLfBBJ/o+28QWMzZkXBt6Ah3jvi4o6paY9qG
         mrGe038tCPVPyvoxMn6P+nQodcrvmz1bdJR8l2L09Vq6xoc1wLmJK/69EQ9oqddKukKo
         6pNQ==
X-Gm-Message-State: APjAAAVmwSgkOBF/2PJSCeLO25sRe/1Zbh0Od8gPEdQyPTUOKg3OCORJ
        dHUjJv5gqKbZEVYWSEMvtFQm8g==
X-Google-Smtp-Source: APXvYqzEmwcG0d8lQX/kl0QdpL4L3hcIIUwoksIwqLVAG+qxWZ32BNihUk7BC4wUe4xNai/y/ebwjA==
X-Received: by 2002:adf:ef09:: with SMTP id e9mr7072720wro.79.1559660543558;
        Tue, 04 Jun 2019 08:02:23 -0700 (PDT)
Received: from linux.home (aputeaux-655-1-151-164.w86-217.abo.wanadoo.fr. [86.217.126.164])
        by smtp.gmail.com with ESMTPSA id q9sm22413544wmq.9.2019.06.04.08.02.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 08:02:22 -0700 (PDT)
Date:   Tue, 4 Jun 2019 17:02:21 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] netfilter: ipv6: nf_defrag: fix leakage of unqueued
 fragments
Message-ID: <20190604150218.GA12962@linux.home>
References: <51d82a9bd6312e51a56ccae54e00452a0ef957dd.1559480671.git.gnault@redhat.com>
 <20190604132605.jlhxljrzaqkw4f2j@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604132605.jlhxljrzaqkw4f2j@salvia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 03:26:05PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jun 02, 2019 at 03:13:47PM +0200, Guillaume Nault wrote:
> > With commit 997dd9647164 ("net: IP6 defrag: use rbtrees in
> > nf_conntrack_reasm.c"), nf_ct_frag6_reasm() is now called from
> > nf_ct_frag6_queue(). With this change, nf_ct_frag6_queue() can fail
> > after the skb has been added to the fragment queue and
> > nf_ct_frag6_gather() was adapted to handle this case.
> 
> Applied, thanks.

Thanks. Can you also please queue it for -stable?
