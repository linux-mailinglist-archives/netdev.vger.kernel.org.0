Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D7336B19E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhDZK0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhDZK0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:26:48 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C39C061574;
        Mon, 26 Apr 2021 03:26:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y62so5986452pfg.4;
        Mon, 26 Apr 2021 03:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=daWSrn6pTf4teOQ1wPlCpPz0jgw14G5nbrL58qvKcSw=;
        b=J59Dm7Z5ybKBa35edujfEvMm/GYS1jV4vqao6r49P07jlqzrEVB2VP4+L8WwNIu2eW
         zAaiCEM7CRbEpQIYLV7tveBeEqrBCPdZlMrT1x9PIHJU7+lUn/KDB7vMhYO0XhUDepPN
         yXtKkM8LFU3HOxxIxEtSaM/LtMflgNv7Smw14J+D6yQBzDJRjVj6JjXEtBOjYsGCXDQ8
         j0GTLhGAlrCwS97nqLlJ9Z+8MmEMNcwqyNfPXiaq2DDBDpRfowT5fUWi6wS5vARLBcuX
         S+AOl29Wjo10KcCbBM/SEuKjVsiPtrMuTiiycFPBbSkVIBlVBEQOpyrypDE/fl5Jiekv
         arng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=daWSrn6pTf4teOQ1wPlCpPz0jgw14G5nbrL58qvKcSw=;
        b=Q9oyNytXFwoJbmOFGqzHvpY1xCfq9ktr2AoCBek0KmbsrakGjFNtcy5PeKyTRiwrU0
         ThdLZZwlDTkzprPYwtmxWdrITg6PLYPuia+v9yI9/lUIxD5CDd6R8f94tLL3JNpfwITs
         0XUFJjl01O+7KOn/Ioo5XLfSRUmg9Nt6znFIl9p1IdNDryF38GV2B2TyzzY/iOBGIm3b
         gwxW6XML+vxlqIUCFr4UDUS32wgHO7SC6HlE4pg3fyigPDp3aibWyJK55MNjpsDuRiaE
         HclDnHyVjs6SqL4JXNdFPrvar8ekP85n/q7q3ld/de6A/Tc8U0BxyVm5VOhuOkKig8VN
         nOXQ==
X-Gm-Message-State: AOAM530JooIPvq8TwLv3YBCQhT7ulqviQY6CciFfFgkCOtEU88xCb5PE
        bLtFyeTA7T2R/NI/dJLJojo=
X-Google-Smtp-Source: ABdhPJwg0lUGWxlrwy0idVAS6efKyPS3zzzYxKgelChBSZJp42CwAJBoPiNJK55NP5+CDvt5GZT0oA==
X-Received: by 2002:a63:3488:: with SMTP id b130mr8972465pga.252.1619432765564;
        Mon, 26 Apr 2021 03:26:05 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j27sm11732912pgb.54.2021.04.26.03.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 03:26:05 -0700 (PDT)
Date:   Mon, 26 Apr 2021 18:25:52 +0800
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
Message-ID: <20210426102552.GQ3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
 <20210422071454.2023282-3-liuhangbin@gmail.com>
 <20210422185332.3199ca2e@carbon>
 <87a6pqfb9x.fsf@toke.dk>
 <20210423185429.126492d0@carbon>
 <20210424010925.GG3465@Leo-laptop-t470s>
 <20210424090129.1b8fe377@carbon>
 <20210426060117.GN3465@Leo-laptop-t470s>
 <20210426112308.580cf98e@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426112308.580cf98e@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:23:08AM +0200, Jesper Dangaard Brouer wrote:
> > I re-check the performance data. The data
> > > Version          | Test                                | Generic | Native
> > > 5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
> > > 5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3M  
> > 
> > is done on version 5.
> > 
> > Today I re-did the test, on version 10, with xchg() changed to
> > READ_ONCE/WRITE_ONCE. Here is the new data (Generic path data was omitted
> > as there is no change)
> > 
> > Version          | Test                                | Generic | Native
> > 5.12 rc4         | redirect_map        i40e->i40e      |  9.7M
> > 5.12 rc4         | redirect_map        i40e->veth      | 11.8M
> > 
> > 5.12 rc4 + patch | redirect_map        i40e->i40e      |  9.6M
> 
> Great to see the baseline redirect_map (i40e->i40e) have almost no
> impact, only 1.07 ns ((1/9.7-1/9.6)*1000), which is what we want to
> see.  (It might be zero as measurements can fluctuate when diff is
> below 2ns)
> 
> 
> > 5.12 rc4 + patch | redirect_map        i40e->veth      | 11.6M
> 
> What XDP program are you running on the inner veth?

XDP_DROP

> 
> > 5.12 rc4 + patch | redirect_map multi  i40e->i40e      |  9.5M
> 
> I'm very surprised to see redirect_map multi being so fast (9.5M vs.
> 9.6M normal map-redir).  I was expecting to see larger overhead, as the

Yes, with only hash map size 4, one port to one port redirect. The impact are
mainly on looping the map. (This info will be updated to new patch set
description)

> code dev_map_enqueue_clone() would clone the packet in xdpf_clone() via
> allocating a new page (dev_alloc_page) and then doing a memcpy().
> 
> Looking closer at this patchset, I realize that the test
> 'redirect_map-multi' is testing an optimization, and will never call
> dev_map_enqueue_clone() + xdpf_clone().  IMHO trying to optimize
> 'redirect_map-multi' to be just as fast as base 'redirect_map' doesn't
> make much sense.  If the 'broadcast' call only send a single packet,
> then there isn't any reason to call the 'multi' variant.

Yes, that's why there are also i40e->mlx4+veth test.

> 
> Does the 'selftests/bpf' make sure to activate the code path that does
> cloning?

Yes, selftest will redirect packets to 2 or 3 other interfaces.

> 
> > 5.12 rc4 + patch | redirect_map multi  i40e->veth      | 11.5M
> > 5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |  3.9M
> > 
> > And after add unlikely() in the check path, the new data looks like
> > 
> > Version          | Test                                | Native
> > 5.12 rc4 + patch | redirect_map        i40e->i40e      |  9.6M
> > 5.12 rc4 + patch | redirect_map        i40e->veth      | 11.7M
> > 5.12 rc4 + patch | redirect_map multi  i40e->i40e      |  9.4M
> > 5.12 rc4 + patch | redirect_map multi  i40e->veth      | 11.4M
> > 5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |  3.8M
> > 
> > So with unlikely(), the redirect_map is a slightly up, while redirect_map
> > broadcast has a little drawback. But for the total data it looks this time
> > there is no much gap compared with no this patch for redirect_map.
> > 
> > Do you think we still need the unlikely() in check path?
> 
> Yes.  The call to redirect_map multi is allowed (and expected) to be
> slower, because when using it to broadcast packets we expect that
> dev_map_enqueue_clone() + xdpf_clone() will get activated, which will
> be the dominating overhead.

OK, I will.

Hangbin
