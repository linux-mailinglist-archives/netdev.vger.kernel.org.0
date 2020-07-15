Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D3F220306
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgGODpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 23:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbgGODpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 23:45:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA424C061755;
        Tue, 14 Jul 2020 20:45:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u5so1336426pfn.7;
        Tue, 14 Jul 2020 20:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zulDTtzqibVBmFNnDBa8CV+o3nIZkPNYzAcV4j3We1A=;
        b=eXgkEaeEHeLfKTW8nKlxFuWDVsqHGXnAexXsHN+kmm6tyr7zHY4dK8hSow5ov6xxJ+
         /UK4XfwBEvUbVplsTDmwEHH4brrZBbetE3mzPlv35ZM14LfBrQU7SAoDqjkAOBcyhRrF
         B4zq/khYcIPLfGhWQ24l0K0+Ark2X6L/Lci/RcLuYS+lTXJVyI5JMzAesNAROE8q8xO1
         kBt3bGql2N2YE6vlrth4TndnTV2+2NFOA7L+hmakNwNPXD1+Vo6AAiVV7TnM7IvKedbB
         v8Y7nHSu+RUD2BJzBypwWc4wAAxJopF2riHGwX845DHYz6IAa5SK/wBvX3GOWTnLnrvN
         ka9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zulDTtzqibVBmFNnDBa8CV+o3nIZkPNYzAcV4j3We1A=;
        b=MxR/VO24jw94+zAraoXLQ3yMxhqwj3lBxArzdRG1DA+P2VNvXvNdNhJYquqjHFuiMn
         /5JzuNMgHjOyxy8BMlgmQXsGdXT8b/u1XLyn+5xo828ZTgI0prVf314xq2Bz0wJV+JQS
         6VikCA6fd8mIi1vndSL5kyKyt5QPFQHIJN3aHuNfoaGiuSGIZG/W1Wziep7xMGz9FNQ4
         gJ7GC1SI5LP9MZmDeEzPs4jFdlBtK5Ctv8mtGfs5De2gZRRV1cX6bUF8xAcQxwurHxbh
         mrtm+8d/DKpR5XBCi1z+KsOOC57kL6PiL77Z0oDqvzlRMkBStmW0Aix5xP2t+N0KfMaK
         d5Zw==
X-Gm-Message-State: AOAM532CtFpnWMj5O0vp7fJD9WC5iwvj7h42F0/4tigFwu+sSZpoDOoR
        WKqWJENFKdw7VMRzGTlQIPo=
X-Google-Smtp-Source: ABdhPJy1V9OyPJMXY/8QNl8pwzsLx/F4k8urZmSAnm0Kzp21CNhZsE0frl1CPGFHPLwnbQIK6D2rVA==
X-Received: by 2002:a63:371c:: with SMTP id e28mr6128726pga.114.1594784734180;
        Tue, 14 Jul 2020 20:45:34 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x10sm503167pgp.47.2020.07.14.20.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 20:45:33 -0700 (PDT)
Date:   Wed, 15 Jul 2020 11:45:22 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv7 bpf-next 0/3] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200715034522.GF2531@dhcp-12-153.nay.redhat.com>
References: <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200714063257.1694964-1-liuhangbin@gmail.com>
 <87imeqgtzy.fsf@toke.dk>
 <2941a6f5-8c6c-6338-2cea-f3d429a06133@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2941a6f5-8c6c-6338-2cea-f3d429a06133@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:12:59AM -0600, David Ahern wrote:
> >> with pktgen(pkt size 64) to compire with xdp_redirect_map(). Here is the
> >> test result(the veth peer has a dummy xdp program with XDP_DROP directly):
> >>
> >> Version         | Test                                   | Native | Generic
> >> 5.8 rc1         | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> >> 5.8 rc1         | xdp_redirect_map       i40e->veth      |  12.7M |   1.6M
> >> 5.8 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> >> 5.8 rc1 + patch | xdp_redirect_map       i40e->veth      |  12.3M |   1.6M
> >> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   7.2M |   1.5M
> >> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->veth      |   8.5M |   1.3M
> >> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.0M |  0.98M
> >>
> >> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
> >> the arrays and do clone skb/xdpf. The native path is slower than generic
> >> path as we send skbs by pktgen. So the result looks reasonable.
> >>
> >> Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
> >> suggestions and help on implementation.
> >>
> >> [0] https://xdp-project.net/#Handling-multicast
> >>
> >> v7: Fix helper flag check
> >>     Limit the *ex_map* to use DEVMAP_HASH only and update function
> >>     dev_in_exclude_map() to get better performance.
> > 
> > Did it help? The performance numbers in the table above are the same as
> > in v6...
> > 
> 
> If there is only 1 entry in the exclude map, then the numbers should be
> about the same.

Yes, I didn't re-run the test. Because when do the testing, I use null exclude
map + flag BPF_F_EXCLUDE_INGRESS. So the perf number should have no difference
with last patch.

Thanks
Hangbin
