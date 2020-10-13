Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24DE28DD54
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgJNJXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731200AbgJNJWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:22:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B1C08EADA;
        Tue, 13 Oct 2020 16:37:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w21so822298pfc.7;
        Tue, 13 Oct 2020 16:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jzAjauBIxv54hR0gUghWcQqHfup2oOYjNtE0ULbiSJk=;
        b=QD9qsaix6m/6vNFJMOAIixheqRSIsThKSiUBvn+N6BI7aCMSgtNWCxWiYxnH7qtjbk
         naoz90ULi9g/TItYGJ3zdZvbjf1+euF+omswBpqeDSJuJAJtilq/4Orz0JQn63SfdPUJ
         ed9eNoCse7kbuk1uCO7dWZ6MEq84YPqFjVoYhkjVvR7Rda+W5ikBsqP4qrCw2lYsrJqL
         BwDddIdeWNgNOINWJiPf2KFoTp9NN9snw4IUhXrNi+JikkYIhEVnCCjo0VYjzBT4PZ73
         RaMtlxYatzAFIJ3PtdobecpKzbJJiZpMR9/d9TkiabxKfWBCIoh1ceWYMUX1wF/9rpEx
         zWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jzAjauBIxv54hR0gUghWcQqHfup2oOYjNtE0ULbiSJk=;
        b=gBX8Wz/TcbzbtAmsYtPoYFUN3r8p24VoGN+zbIe8O0/A+OgEdsigWr0zWPbj2+AKGA
         Qi0GvDX84veluCB3toxdbe/DGSycP2XUzc474BQYEKCdzyEQBX7qBCwgsj+j36gnVDcf
         djY4cCXAjoN+nKKnbRRwsXr90XbvX9SMs/v5lO8qjS7Hv33em/DumKct7zCEPHoHIqWS
         1fXapBGUgjHTs9GO6OD6l1Tv8RIQYV9I+zv+RQ/eEzu8lj/V8Io8nCFnK+Vo9m9ud7ow
         nUyohOCAWJmpijJzJRau4wCSc6QP7daAU7ZPwQ3neihuD9T0ks7gAUKeAV/muJ29pFHi
         e8ZA==
X-Gm-Message-State: AOAM533LE0e4898NwE/GrVloafAlTXP/MekR656sz2uYW/iuUPDNS4dc
        2QokTYURD4TKI2g89N7KaJc=
X-Google-Smtp-Source: ABdhPJxhxdLi34aEK91TOXf1Y6Ix/+BdLBXTaSKtGWdcMSXu7EXtjkk+J9i0BmqN9+UeyO0Osmk3JQ==
X-Received: by 2002:aa7:8509:0:b029:156:32b4:ab97 with SMTP id v9-20020aa785090000b029015632b4ab97mr1907940pfn.54.1602632258739;
        Tue, 13 Oct 2020 16:37:38 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:e7d1])
        by smtp.gmail.com with ESMTPSA id hg15sm349533pjb.39.2020.10.13.16.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 16:37:37 -0700 (PDT)
Date:   Tue, 13 Oct 2020 16:37:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201013233734.6z3uyrlr43s7etay@ast-mbp>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
 <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201010124402.606f2d37@carbon>
 <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201013224009.77d6f746@carbon>
 <20201013160726.367e3871@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013160726.367e3871@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 04:07:26PM -0700, Jakub Kicinski wrote:
> On Tue, 13 Oct 2020 22:40:09 +0200 Jesper Dangaard Brouer wrote:
> > > FWIW I took a quick swing at testing it with the HW I have and it did
> > > exactly what hardware should do. The TX unit entered an error state 
> > > and then the driver detected that and reset it a few seconds later.  
> > 
> > The drivers (i40e, mlx5, ixgbe) I tested with didn't entered an error
> > state, when getting packets exceeding the MTU.  I didn't go much above
> > 4K, so maybe I didn't trigger those cases.
> 
> You probably need to go above 16k to get out of the acceptable jumbo
> frame size. I tested ixgbe by converting TSO frames to large TCP frames,
> at low probability.

how about we set __bpf_skb_max_len() to jumbo like 8k and be done with it.

I guess some badly written driver/fw may still hang with <= 8k skb
that bpf redirected from one netdev with mtu=jumbo to another
netdev with mtu=1500, but then it's really a job of the driver/fw
to deal with it cleanly.

I think checking skb->tx_dev->mtu for every xmited packet is not great.
For typical load balancer it would be good to have MRU 1500 and MTU 15xx.
Especially if it's internet facing. Just to drop all known big
packets in hw via MRU check.
But the stack doesn't have MRU vs MTU distinction and XDP_TX doesn't
adhere to MTU. xdp_data_hard_end is the limit.
So xdp already allows growing the packet beyond MTU.
I think upgrading artificial limit in __bpf_skb_max_len() to 8k will
keep it safe enough for all practical cases and will avoid unnecessary
checks and complexity in xmit path.
