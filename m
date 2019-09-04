Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93ACA7BE1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfIDGlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:41:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45966 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDGlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:41:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id 4so7125437pgm.12;
        Tue, 03 Sep 2019 23:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=DMpkUZoYpQuFlQy5IOlVsmVJ1SynRY2j23KVkYnZyyw=;
        b=FjCcM5NcsALyToL+/efgvC10cKWuqAB0RrY/JdhE1rrAavMTWUVT2Va1pxl4+6dfjc
         ATNamgIRbZdeqT26YDOWRLRksxuy2GgYbX0gZQwfAaIBWshGqhVn5qlLbphca4ajsMqJ
         rxOd4uQtu0aFOsIKM8ORWHN/VqnLM7rSY0+Ck0XmrE+7MusNB16oYMpS3HAASXXerExy
         IENPoRF8Yd8lTFWd09ip1MiqKXWHnNTfTp/WKFt45OYwSc8soXmjAiB99WLWyxVUWfiT
         dZ4rxmssPdThUID22OHy0Gr3E2X7mWEfm+4BEBmJ2moopZKpSbKYBZcr3IJ56rPFWe73
         X/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DMpkUZoYpQuFlQy5IOlVsmVJ1SynRY2j23KVkYnZyyw=;
        b=EhPavIaoWVlVEtRML3f4srL+XrZ9roya/Q4PXOzOZsgzxIbnFVr+h7dTM4NuluLtcf
         r+CneR76HUp+kPXkmSARAEId63k328Z4nEs4W/GiLipER9J7smCkfb7Sz0pC4dr+Whqo
         6q5Vltn85rcaALQj7cczKUJQiMzrQzoOOCEaB8XpaA5UiQJ5XZAJdvTjGplMgMppTM1s
         Bgd37U3tivocQNTFPkWjvt1+A/9M1I/oNO+Ya4/NHANznDi0Ry389lVmlWMz5ta+4O4p
         6gSvVniyAkUitEjRWt/8elllMxI5GvfkHMFThh+PM2lzY08nykhy70gJe+inNSmAi1P9
         5xgw==
X-Gm-Message-State: APjAAAUfnDKDhZtM6eLchoTnf1OjjcVKl4NN2vM/oGuH4OV6zNY2AImo
        kTWSzurPOa2WM+ov0MLynD3EzaFD
X-Google-Smtp-Source: APXvYqyfXC8L7rj1syVBr+7repNVVgjAKOV7Ku9+6MkbERA0AwGQUvVilgxRxmnY29sZeht3XH0xuQ==
X-Received: by 2002:a62:65c7:: with SMTP id z190mr45930199pfb.9.1567579309211;
        Tue, 03 Sep 2019 23:41:49 -0700 (PDT)
Received: from localhost ([175.223.23.37])
        by smtp.gmail.com with ESMTPSA id e189sm23617073pgc.15.2019.09.03.23.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 23:41:48 -0700 (PDT)
Date:   Wed, 4 Sep 2019 15:41:44 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904064144.GA5487@jagdpanzerIV>
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
 <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190904061501.GB3838@dhcp22.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/04/19 08:15), Michal Hocko wrote:
> > If you look at the original report, the failed allocation dump_stack() is,
> > 
> >  <IRQ>
> >  warn_alloc.cold.43+0x8a/0x148
> >  __alloc_pages_nodemask+0x1a5c/0x1bb0
> >  alloc_pages_current+0x9c/0x110
> >  allocate_slab+0x34a/0x11f0
> >  new_slab+0x46/0x70
> >  ___slab_alloc+0x604/0x950
> >  __slab_alloc+0x12/0x20
> >  kmem_cache_alloc+0x32a/0x400
> >  __build_skb+0x23/0x60
> >  build_skb+0x1a/0xb0
> >  igb_clean_rx_irq+0xafc/0x1010 [igb]
> >  igb_poll+0x4bb/0xe30 [igb]
> >  net_rx_action+0x244/0x7a0
> >  __do_softirq+0x1a0/0x60a
> >  irq_exit+0xb5/0xd0
> >  do_IRQ+0x81/0x170
> >  common_interrupt+0xf/0xf
> >  </IRQ>
> > 
> > Since it has no __GFP_NOWARN to begin with, it will call,

I think that DEFAULT_RATELIMIT_INTERVAL and DEFAULT_RATELIMIT_BURST
are good when we ratelimit just a single printk() call, so the ratelimit
is "max 10 kernel log lines in 5 seconds".

But the thing is different in case of dump_stack() + show_mem() +
some other output. Because now we ratelimit not a single printk() line,
but hundreds of them. The ratelimit becomes - 10 * $$$ lines in 5 seconds
(IOW, now we talk about thousands of lines). Significantly more permissive
ratelimiting.

	-ss
