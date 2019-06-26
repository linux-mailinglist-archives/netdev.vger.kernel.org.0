Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801C656E9C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfFZQXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:23:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52311 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:23:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so2744874wms.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kLMxzaay2QkykXOFDyZCKNc9EDUQIVkQWb8zCkxdrHs=;
        b=AdsUazB9SbbTffSdzxzmsVGF+ik4QxrToX3hIfprevn4JUIDd6uVUVWZPO8kPHu+qp
         6xsDLHyDLM/j8HzRlEbYiuMwCODBVtS1x50TxRAMNpF12GT/amRmkrhCs73GJ689kJJO
         0exeboBuYoMkEkojiSwRjbRCcbs780qayvxKWBXnZJPqnzsDbIKWWR/RZh9U0jn9eaZb
         n0/lpZ8vjaAiPpBqQwdHJBHx+M17uwR8Z/F4sgy5EIq4rJ8XqcLmsNYmDb/YZrgglKAD
         hxj99jDZSpxkYP/jOfzUVSMjq8ZnY7PPg3Off2mmqevHhMtzz5DKAfSMfd0pOJ4pGKGe
         F0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLMxzaay2QkykXOFDyZCKNc9EDUQIVkQWb8zCkxdrHs=;
        b=KqZ5eC3af+VrykkEX5D3QxnADnKoq2xiJGFbCqwvjDvsbtegpKSZ580HTsP3ceMWwU
         4QB9EZ4DnlSEjc4+RyntCmfORyO+6vZhxPVfSuho78n1K7ZRTToA3D2GoL83u9PtnpYO
         d1fVI/+J+f5O4N5Gk/AyrhX6LHME8Zdn/IqNNsAnd2zgfmI1+vqQazHOXiWoDFg1Tfxu
         lnAxttnHzVCIH5Q5YoJp3csiMxRULAgJbTKypxOMBtbDW8Q2fRKfu2Nb8h8IhWDIpWKp
         luxiWYbiPwLfXw1HaqzFZzUkb/peLxc5HZFyM1+mBBIgl9F3+tCPii8No04hPWGPsK18
         ONKQ==
X-Gm-Message-State: APjAAAX1yIJPCsZlNyVQq/rFUewWo5fQoFUCoWBGlF3H2GDsriw351du
        02rbFh3pCsXkQUgg6N0JKHk=
X-Google-Smtp-Source: APXvYqwlrdILDJ3oBN+lUiLH7/5GJMHITrXffKuFpoxn4PEUHdlYxWM9PXSvXI+zZwnL2rxyszHFWQ==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr3124769wmi.73.1561566178455;
        Wed, 26 Jun 2019 09:22:58 -0700 (PDT)
Received: from eyal-ubuntu ([176.230.77.167])
        by smtp.gmail.com with ESMTPSA id f12sm37653889wrg.5.2019.06.26.09.22.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Jun 2019 09:22:58 -0700 (PDT)
Date:   Wed, 26 Jun 2019 19:22:54 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, jhs@mojatatu.com
Subject: Re: [PATCH net-next 2/5] net: sched: em_ipt: set the family based
 on the protocol when matching
Message-ID: <20190626192254.2bd41a40@eyal-ubuntu>
In-Reply-To: <9a3be271-af15-3fef-9612-7a3232d09b32@cumulusnetworks.com>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
        <20190626115855.13241-3-nikolay@cumulusnetworks.com>
        <20190626163353.6d5535cb@jimi>
        <9a3be271-af15-3fef-9612-7a3232d09b32@cumulusnetworks.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 16:45:28 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> On 26/06/2019 16:33, Eyal Birger wrote:
> > Hi Nikolay,
> >    
> > On Wed, 26 Jun 2019 14:58:52 +0300
> > Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> >   
> >> Set the family based on the protocol otherwise protocol-neutral
> >> matches will have wrong information (e.g. NFPROTO_UNSPEC). In
> >> preparation for using NFPROTO_UNSPEC xt matches.
> >>
> >> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> >> ---
> >>  net/sched/em_ipt.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
...
> >> -	nf_hook_state_init(&state, im->hook, im->match->family,
> >> +	nf_hook_state_init(&state, im->hook, state.pf,
> >>  			   indev ?: skb->dev, skb->dev, NULL,
> >> em->net, NULL); 
> >>  	acpar.match = im->match;  
> > 
> > I think this change is incompatible with current behavior.
> > 
> > Consider the 'policy' match which matches the packet's xfrm state
> > (sec_path) with the provided user space parameters. The sec_path
> > includes information about the encapsulating packet's parameters
> > whereas the current skb points to the encapsulated packet, and the
> > match is done on the encapsulating packet's info.
> > 
> > So if you have an IPv6 packet encapsulated within an IPv4 packet,
> > the match parameters should be done using IPv4 parameters, not IPv6.
> > 
> > Maybe use the packet's family only if the match family is UNSPEC?
> > 
> > Eyal.
> >   
> 
> Hi Eyal,
> I see your point, I was wondering about the xfrm cases. :)
> In such case I think we can simplify the set and do it only on UNSPEC
> matches as you suggest.
> 
> Maybe we should enforce the tc protocol based on the user-specified
> nfproto at least from iproute2 otherwise people can add mismatching
> rules (e.g. nfproto == v6, tc proto == v4).
> 
Hi Nik,

I think for iproute2 the issue is the same. For encapsulated IPv6 in
IPv4 for example, tc proto will be IPv6 (tc sees the encapsulated
packet after decryption) whereas nfproto will be IPv4 (policy match is
done on the encapsulating state metadata which is IPv4).

I think the part missing in iproute2 is the ability to specify
NFPROTO_UNSPEC.

Thanks,
Eyal

