Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494E036AC01
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 08:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhDZGCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 02:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhDZGCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 02:02:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E09CC061574;
        Sun, 25 Apr 2021 23:01:31 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c3so19436019pfo.3;
        Sun, 25 Apr 2021 23:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=69AoA8tNSsYYpyvV+LtgNiExcNmI/3RLnrIl8Iw0l10=;
        b=X3IVfgFgh1XTI8QaHLrGUCQ6rqfijJZfMV2uGLtQBSU1TVn8hDFYeNRRvKYUp/8Ryw
         m60yGjGyvu0tg8lI3X8f7Pv05hzUkNHPyg86DtWrFnQdajNLe+Dq/W883KGV7f6kH3ZD
         Aev6hmOb+UTyNr5cUxS37WmDD+I4It425Mdy4nXP7vK7rPIhJ94RwYN6yorTfRgt3oV4
         eMi9FnM81xUewXfb0dgYjq7/7WUz/hY6wmRTMeGpYw8ssNJ+o1N8x7V2gJqZEZwYbqJ6
         cEEMRkxNgFftmTbY5Bl7wPmvX2HVIn4R5iehHQXLxERMCgzPoocnBLZ4kMXK7FLnhXXe
         O+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=69AoA8tNSsYYpyvV+LtgNiExcNmI/3RLnrIl8Iw0l10=;
        b=l4PLn771RO4qLR56T2IO3FfumEqn+aZLunzicDrRuInSWE9ARWZ4tMDcXzjLveRAwc
         vhp+ERTMqhf/BrzzEmi1+kmgqNPhYT1S8M3wb3iOo9G0T3C2aVeXWc5zRt/jw++AzjzH
         274xZs5teNAzAkIsgbOVznDAPULtZvvOFk6JVU6rAmAoHRWQh0aDNjTuLbjPrkl1h+Pu
         WwTfI+LZZc5ZfGlRykS44GZrTWRcVypsTtK4D2u85vzUUKDHUCyOxFgM7zUYCFh4H+j1
         ZsEWPCXUhfgzt/Up1ALZxWk2s7LNbRVibl51x6uinADZvYLhz9sa8v6U3XegaZti4jAt
         BgtA==
X-Gm-Message-State: AOAM533aTaEKAq9njVtKJ4YN9jlyM4mrw1vJLC49CuPfM6QVpX+pJc7G
        6iP7RxGqgWAY6puVLORpusc=
X-Google-Smtp-Source: ABdhPJy8Tdv/NnfH53ZOD6DUjan72bTam2NptqKIn36vtTOIF/qKbAfPOF50Y0IJCKtxgLtaT+475A==
X-Received: by 2002:aa7:91d4:0:b029:25a:d5bb:7671 with SMTP id z20-20020aa791d40000b029025ad5bb7671mr15785825pfa.65.1619416890528;
        Sun, 25 Apr 2021 23:01:30 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i18sm10247624pfq.59.2021.04.25.23.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 23:01:30 -0700 (PDT)
Date:   Mon, 26 Apr 2021 14:01:17 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv9 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210426060117.GN3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
 <20210422071454.2023282-3-liuhangbin@gmail.com>
 <20210422185332.3199ca2e@carbon>
 <87a6pqfb9x.fsf@toke.dk>
 <20210423185429.126492d0@carbon>
 <20210424010925.GG3465@Leo-laptop-t470s>
 <20210424090129.1b8fe377@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210424090129.1b8fe377@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 24, 2021 at 09:01:29AM +0200, Jesper Dangaard Brouer wrote:
> > > > >> @@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> > > > >>  	case BPF_MAP_TYPE_DEVMAP:
> > > > >>  		fallthrough;
> > > > >>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > > > >> -		err = dev_map_enqueue(fwd, xdp, dev);
> > > > >> +		map = xchg(&ri->map, NULL);    
> > > > >
> > > > > Hmm, this looks dangerous for performance to have on this fast-path.
> > > > > The xchg call can be expensive, AFAIK this is an atomic operation.    
> > > > 
> > > > Ugh, you're right. That's my bad, I suggested replacing the
> > > > READ_ONCE()/WRITE_ONCE() pair with the xchg() because an exchange is
> > > > what it's doing, but I failed to consider the performance implications
> > > > of the atomic operation. Sorry about that, Hangbin! I guess this should
> > > > be changed to:
> > > > 
> > > > +		map = READ_ONCE(ri->map);
> > > > +		if (map) {
> > > > +			WRITE_ONCE(ri->map, NULL);
> > > > +			err = dev_map_enqueue_multi(xdp, dev, map,
> > > > +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> > > > +		} else {
> > > > +			err = dev_map_enqueue(fwd, xdp, dev);
> > > > +		}  
> > > 
> > > This is highly sensitive fast-path code, as you saw Bjørn have been
> > > hunting nanosec in this area.  The above code implicitly have "map" as
> > > the likely option, which I don't think it is.  
> > 
> > Hi Jesper,
> > 
> > From the performance data, there is only a slightly impact. Do we still need
> > to block the whole patch on this? Or if you have a better solution?
> 
> I'm basically just asking you to add an unlikely() annotation:
> 
> 	map = READ_ONCE(ri->map);
> 	if (unlikely(map)) {
> 		WRITE_ONCE(ri->map, NULL);
> 		err = dev_map_enqueue_multi(xdp, dev, map, [...]
> 
> For XDP, performance is the single most important factor!  You say your
> performance data, there is only a slightly impact, there must be ZERO
> impact (when your added features is not in use).
> 
> You data:
>  Version          | Test                                | Generic | Native
>  5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
>  5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3M
> 
> The performance difference 9.6M -> 9.3M is a slowdown of 3.36 nanosec.
> Bjørn and others have been working really hard to optimize the code and
> remove down to 1.5 nanosec overheads.  Thus, introducing 3.36 nanosec
> added overhead to the fast-path is significant.

I re-check the performance data. The data
> Version          | Test                                | Generic | Native
> 5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
> 5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3M

is done on version 5.

Today I re-did the test, on version 10, with xchg() changed to
READ_ONCE/WRITE_ONCE. Here is the new data (Generic path data was omitted
as there is no change)

Version          | Test                                | Generic | Native
5.12 rc4         | redirect_map        i40e->i40e      |  9.7M
5.12 rc4         | redirect_map        i40e->veth      | 11.8M

5.12 rc4 + patch | redirect_map        i40e->i40e      |  9.6M
5.12 rc4 + patch | redirect_map        i40e->veth      | 11.6M
5.12 rc4 + patch | redirect_map multi  i40e->i40e      |  9.5M
5.12 rc4 + patch | redirect_map multi  i40e->veth      | 11.5M
5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |  3.9M

And after add unlikely() in the check path, the new data looks like

Version          | Test                                | Native
5.12 rc4 + patch | redirect_map        i40e->i40e      |  9.6M
5.12 rc4 + patch | redirect_map        i40e->veth      | 11.7M
5.12 rc4 + patch | redirect_map multi  i40e->i40e      |  9.4M
5.12 rc4 + patch | redirect_map multi  i40e->veth      | 11.4M
5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |  3.8M

So with unlikely(), the redirect_map is a slightly up, while redirect_map
broadcast has a little drawback. But for the total data it looks this time
there is no much gap compared with no this patch for redirect_map.

Do you think we still need the unlikely() in check path?

Thanks
Hangbin
