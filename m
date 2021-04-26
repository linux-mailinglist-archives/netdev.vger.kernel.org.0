Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4663536B27E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 13:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhDZLsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 07:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhDZLsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 07:48:38 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F760C061574;
        Mon, 26 Apr 2021 04:47:55 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y62so6114036pfg.4;
        Mon, 26 Apr 2021 04:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sFXfbLv5MdulIa6o/mktVMnOLjPpaT+AU4ZaAeR84S8=;
        b=eol+/anqgjuJsZKMh6NhhBErcNmtrT7pUFGduGpoQ9YSyVI/GWwY4gobEbgCqzVvD2
         8Wf7IHv5eqsVB+oX+GCaGXgls+NoFqjyM80jwaI2hv61pxMliXdbF83aKL0AkfQIctY6
         HQcbRF/Yhf7arq7uuX63l0JOSEW13/mKk85rhJmA58fi9xeWFd2ZuyTT8kMnyWpxDhB1
         gUfMNI4BAA6U9FKemcqef5Q2eo3U9hXZkXBNvEkdRgAvYzzkhIDZI4wB9e8WXpqcuShV
         zMJAbRIXV4ZTsQqCwxIIf0fJ439GnbqQzG4kngCiOkSD0tzs5NOWB8BQp/qeMyKKBHjf
         xn6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sFXfbLv5MdulIa6o/mktVMnOLjPpaT+AU4ZaAeR84S8=;
        b=nI/XJn5jKV52ZP2yglnhG4PbwIb31+ggIPJrmUv3stSZyhKBJTiGmcVa1ZfpOK79/l
         47k9PRsXVY4Pl1t+YAZlbSTIAXWWqta48wIVtGTc1ZPbHcTYIpm1QeONJIyT8KkcUhk7
         vfSyjPlS7WRe8k1qQKnZshjg2nv6DxltPNIEMAXH8fuc1WEvaDTzcpGiXewAfrmNTqTS
         V4ARoeK7DsQ8XH3qjLBOfNECpl4uvHbgrvWnwNQHQZvX88OiAYhd97O+M5WYvaon1ym9
         UAu9ouyCKUkK154/QeVYmIZKYzUy2iM738VZOQFtR33PNI5HwZAhsHHV0vmgf+9zUkwh
         QFfg==
X-Gm-Message-State: AOAM533x1RRK7WnuCYJXmE3iKmiw0j3rDfOWmUbkXRuQSk+CKlvxcYy5
        mwr8z7G7w0AW9GQQ+zjrnx8=
X-Google-Smtp-Source: ABdhPJyOGsDk2wgaVvvBLGyWKvYPe+QTVSc2+A/IJlWvuOMR10G3om6rVQZPU7YjaAwK+8J8keUopA==
X-Received: by 2002:a65:6698:: with SMTP id b24mr16582112pgw.297.1619437675229;
        Mon, 26 Apr 2021 04:47:55 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w7sm11188889pff.208.2021.04.26.04.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:47:54 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:47:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
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
Subject: Re: [PATCHv10 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210426114742.GU3465@Leo-laptop-t470s>
References: <20210423020019.2333192-1-liuhangbin@gmail.com>
 <20210423020019.2333192-3-liuhangbin@gmail.com>
 <20210426115350.501cef2a@carbon>
 <20210426114014.GT3465@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426114014.GT3465@Leo-laptop-t470s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 07:40:28PM +0800, Hangbin Liu wrote:
> On Mon, Apr 26, 2021 at 11:53:50AM +0200, Jesper Dangaard Brouer wrote:
> > Decode: perf_trace_xdp_redirect_template+0xba
> >  ./scripts/faddr2line vmlinux perf_trace_xdp_redirect_template+0xba
> > perf_trace_xdp_redirect_template+0xba/0x130:
> > perf_trace_xdp_redirect_template at include/trace/events/xdp.h:89 (discriminator 13)
> > 
> > less -N net/core/filter.c
> >  [...]
> >    3993         if (unlikely(err))
> >    3994                 goto err;
> >    3995 
> > -> 3996         _trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
> 
> Oh, the fwd in xdp xdp_redirect_map broadcast is NULL...
> 
> I will see how to fix it. Maybe assign the ingress interface to fwd?

Er, sorry for the flood message. I just checked the trace point code, fwd
in xdp trace event means to_ifindex. So we can't assign the ingress interface
to fwd.

In xdp_redirect_map broadcast case, there is no specific to_ifindex.
So how about just ignore it... e.g.

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index fcad3645a70b..1751da079330 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -110,7 +110,8 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
                u32 ifindex = 0, map_index = index;

                if (map_type == BPF_MAP_TYPE_DEVMAP || map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-                       ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
+                       if (tgt)
+                               ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
                } else if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
                        ifindex = index;
                        map_index = 0;


Hangbin
