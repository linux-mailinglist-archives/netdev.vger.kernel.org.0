Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F068350E19
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 06:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhDAEak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 00:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhDAEaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 00:30:17 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23A2C0613E6;
        Wed, 31 Mar 2021 21:30:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s21so468680pjq.1;
        Wed, 31 Mar 2021 21:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YxTk/lpU+LkM2o2udpVxTEZdf8huKmT/Aw7Jdz8+xH8=;
        b=W1D7OImq6T4DAiTLrLF1/hjS6H0EUCWtixO1zqLRsBjXPm3vrv+U0Fl7qGSVsxAXAd
         K5/3yZd/Kwp18DdQUgqp0U4IlWbb9aBH39PHE8QYtVDTEvXd41A2tWabevzdEv0jQH16
         m8iY8PXz0i57K7syefCDlAWnIlulPy7zfibALl9XW7GLmlGGSKXjT47PTo7b0v0U1Bk9
         oOiHpxejxzYb7MAdxE9tsNLtRud20hSShRFjFJjbfqgNW8te0legoXtTbY6FYHaTPn2m
         j3KQJY7Ddqcq4KH15FSxA+3wk0kT5+ekLyqNNOJOaKanFAqgwBj3OmYi0nrCpXbiHMEf
         qy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YxTk/lpU+LkM2o2udpVxTEZdf8huKmT/Aw7Jdz8+xH8=;
        b=XKkV0x4ucjVz79Y/6d5Vwy4aO3v2+btvnhVDNHzW9aETcP47c8SSgpXqtVkauVajD1
         7Z/LBaL85chE9Ezuklm1Ub8sBNZZRCKjR5Zvid2cLKLUIM8FAczMJjK0Uk7oENlrQmWS
         OB6jm5zGRC3P/p2XdF8GR/VIy/KxstBSyLNHW+KX/9cVSr/TZ9U+zRQFP0flxtuyYwly
         VRMdlDZgvD1bd1G+0+barLbSqxmoYX2Q8NVkpLHObS68WpjrzEHakdmWpL7q0uCMqMd+
         JV/WYKWRiQz7/CA/vLXHcF4hajR6iYgWKS7OGYCLaXWv1+nW5ZgxjcCtPxgVdQESkJEJ
         y8gw==
X-Gm-Message-State: AOAM533CMqk83j4fopVL0rkRfH3lyHdmn4C1YCAhCmJlbnBj253bTqL6
        xwR//qc5thckaULfeOvAAwo=
X-Google-Smtp-Source: ABdhPJwVvajXzP7MMGu9z2r6Cc+/UFvXwEPIiuPESm4smBDbrsrhHk0q/YXsxD7NFaT5GP5QVmtoEQ==
X-Received: by 2002:a17:902:7c06:b029:e6:adb4:7c19 with SMTP id x6-20020a1709027c06b02900e6adb47c19mr6378940pll.8.1617251417123;
        Wed, 31 Mar 2021 21:30:17 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f65sm4057993pgc.19.2021.03.31.21.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 21:30:16 -0700 (PDT)
Date:   Thu, 1 Apr 2021 12:30:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv3 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210401043004.GE2900@Leo-laptop-t470s>
References: <20210325092733.3058653-1-liuhangbin@gmail.com>
 <20210325092733.3058653-3-liuhangbin@gmail.com>
 <87lfa3phj6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfa3phj6.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 03:41:17PM +0200, Toke Høiland-Jørgensen wrote:
> > @@ -1491,13 +1492,20 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
> >  		 */
> >  		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
> >  		ri->map_type = BPF_MAP_TYPE_UNSPEC;
> > -		return flags;
> > +		return flags & BPF_F_ACTION_MASK;
> >  	}
> >  
> >  	ri->tgt_index = ifindex;
> >  	ri->map_id = map->id;
> >  	ri->map_type = map->map_type;
> >  
> > +	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
> > +	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
> > +	    (flags & BPF_F_BROADCAST)) {
> > +		ri->flags = flags;
> 
> This, combined with this:
> 
> [...]
> 
> > +	if (ri->flags & BPF_F_BROADCAST) {
> > +		map = READ_ONCE(ri->map);
> > +		WRITE_ONCE(ri->map, NULL);
> > +	}
> > +
> >  	switch (map_type) {
> >  	case BPF_MAP_TYPE_DEVMAP:
> >  		fallthrough;
> >  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > -		err = dev_map_enqueue(fwd, xdp, dev);
> > +		if (ri->flags & BPF_F_BROADCAST)
> > +			err = dev_map_enqueue_multi(xdp, dev, map,
> > +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> > +		else
> > +			err = dev_map_enqueue(fwd, xdp, dev);
> 
> Means that (since the flags value is never cleared again) once someone
> has done a broadcast redirect, that's all they'll ever get until the
> next reboot ;)

How about just get the ri->flags first and clean it directly. e.g.

flags = ri->flags;
ri->flags = 0;

With this we don't need to add an extra field ri->exclude_ingress as you
mentioned later.

People may also need the flags field in future.

> 
> Also, the bpf_clear_redirect_map() call has no effect since the call to
> dev_map_enqueue_multi() only checks the flags and not the value of the
> map pointer before deciding which enqueue function to call.
> 
> To fix both of these, how about changing the logic so that:
> 
> - __bpf_xdp_redirect_map() sets the map pointer if the broadcast flag is
>   set (and clears it if the flag isn't set!)

OK
> 
> - xdp_do_redirect() does the READ_ONCE/WRITE_ONCE on ri->map
>   unconditionally and then dispatches to dev_map_enqueue_multi() if the
>   read resulted in a non-NULL pointer
> 
> Also, it should be invalid to set the broadcast flag with a map type
> other than a devmap; __bpf_xdp_redirect_map() should check that.

The current code only do if (unlikely(flags > XDP_TX)) and didn't check the
map type. I also only set the map when there has devmap + broadcast flag.
Do you mean we need a more strict check? like

if (unlikely((flags & ~(BPF_F_ACTION_MASK | BPF_F_REDIR_MASK)) ||
	      (map->map_type != BPF_MAP_TYPE_DEVMAP &&
	       map->map_type != BPF_MAP_TYPE_DEVMAP_HASH &&
	       flags & BPF_F_REDIR_MASK)))

Thanks
Hangbin

> 
> And finally, with the changes above, you no longer need the broadcast
> flag in do_redirect() at all, so you could just have a bool
> ri->exclude_ingress that is set in the helper and pass that directly to
> dev_map_enqueue_multi().
> 
> A selftest that validates that the above works as it's supposed to might
> be nice as well (i.e., one that broadcasts and does a regular redirect
> after one another)
> 
> -Toke
> 
