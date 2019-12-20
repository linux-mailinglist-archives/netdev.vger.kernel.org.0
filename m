Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDB1127390
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 03:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLTCgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 21:36:53 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34702 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfLTCgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 21:36:53 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so4188144pgf.1
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 18:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gM5B2dc7jMpoi04/YsVG8KiK/oAIvguMSC6U8n/3JVs=;
        b=O/WypChgZcJQCbjne8fF6nu1B9DJW89daY0H/+QoR9jcwaMZGMJkcnqe/eoqUGEFIl
         uCyTXOsjKORCTehElYAUOEO/JEU4X0UxROWg/+S5fsyCkz6hmbZkNJzRLFhwStFwzytj
         pezs2zz3+V1YEFfZvoBGCpfouHZAMNE87sD7DF5pUmHgwnMCruRaDetjZ44XWh4IvLxD
         cQvDeHfvEb4gif1D55U3xpkhhJwHXtshiPUzXJFwzBTNuYsB4xmLU70jjKBYVIR3Glp7
         P7xO4hhZbI2jRjVQFdoaCVj0AQrl2UOox2KyjRxB21WIrmoiRkZOIoguhx/LlHe2uXvA
         yu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gM5B2dc7jMpoi04/YsVG8KiK/oAIvguMSC6U8n/3JVs=;
        b=hJKKKQ68vaobX6rfd2PeT1/Ic/f9zWjzS6Fheb78PhUvBXYraSQvXsAgRpugH00rr4
         /KarpZ/jC2fX5n995oQOwMFCunPeVqzU7xBX62lQVCHtswHsMve8LNrCDAczqM67AbyM
         ZgVx8Fe0x+k1TXBi7xvgQWUOjwgeVmjegQVqybvyqthDyj+ajgNaXjuU7agE9U9qSCaA
         1o3tNj2X2w8FJQZgdq+wYgOMbeCdUD1R3AzuaxEU/5HxDVwMidTKuxCFW+EvPea5GLld
         /5O9l4w1cguhFqnH2cHAYGBk6bYs1CPbvV5S8+hmXzyueR7LNw/q9X6aorwQxFYUYnVE
         AZfA==
X-Gm-Message-State: APjAAAXRadPEB6wcgod0rOt7bNj4vllq5SGvr0rs6RIUU6y9PLVnYE74
        mYWYehVFRY2EkpkG+xUaUrE=
X-Google-Smtp-Source: APXvYqxKcZ/D6UVCGNMvClhnwrvJBh8HgdH8oNL0RgmiN9hoLXr5OGAS53EALaaP1MWsONovgll4jg==
X-Received: by 2002:a62:f94d:: with SMTP id g13mr13254950pfm.60.1576809412515;
        Thu, 19 Dec 2019 18:36:52 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q10sm5953768pfn.5.2019.12.19.18.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 18:36:51 -0800 (PST)
Date:   Fri, 20 Dec 2019 10:36:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCH net-next 5/8] tunnel: do not confirm neighbor when do
 pmtu update
Message-ID: <20191220023640.GB27948@dhcp-12-139.nay.redhat.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191218115313.19352-6-liuhangbin@gmail.com>
 <20191219174720.GA14566@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219174720.GA14566@linux.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guillaume,

Thanks a lot for your review.
On Thu, Dec 19, 2019 at 06:47:20PM +0100, Guillaume Nault wrote:
> On Wed, Dec 18, 2019 at 07:53:10PM +0800, Hangbin Liu wrote:
> > When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
> > we should not call dst_confirm_neigh() as there is no two-way communication.
> > 
> > Although ipv4 tunnel is not affected as __ip_rt_update_pmtu() does not call
> > dst_confirm_neigh(), we still not do neigh confirm to keep consistency with
> > IPv6 code.
> > 
> This is a bit confusing. IPv4 tunnels (e.g. gretap) are affected, as show
> by your reproducer. Quoting patch 0:

Ah, yes, I forgot that IPv6 over GRE4 also affects. I will update the
commit description.

> 
> Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")
> 
I will add it


Thanks
Hangbin
