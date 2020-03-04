Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66871789AB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgCDEgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:36:50 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45784 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCDEgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:36:50 -0500
Received: by mail-pl1-f195.google.com with SMTP id b22so422135pls.12;
        Tue, 03 Mar 2020 20:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=7O2LRTpM2yhNi2dntMNIgwz/oqhGVqyhb0AH7YvMO0E=;
        b=dTp0TAkPOCGPHV0zuHwDY0VK0Z0n/j5+xoMcShsuhx5oVPpJvwMh6WC/vCJtdSQX31
         q6eJpFH33gxfnR9WlD5aqzdflxFfSlA1bH3IltvCR2JReJLCn6JcRgmufNfZLaDJzH7/
         DHKhKiLNi97mdXrMLRUKIQOOBjsc+GGhSpum8Rb6J2tz9KHXBLvAI0VYHjEdowvEaBbT
         FZ5c3zVmzuOwJHio9Bc70X4ygvZxGXqpXLgIxFax+4cWGDvB8RXHlsYI3LZsmu5LMrQ4
         N2h/9ekJQeZNIM2zZjJ5wEAbs25ysRw/YXuQvPIKNpzChY21bFyXGohl+8iIJsRNQR6p
         0JQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=7O2LRTpM2yhNi2dntMNIgwz/oqhGVqyhb0AH7YvMO0E=;
        b=QWPOfbtCtcFJwDBfSBMNXg9lOYN0AZaO8xD4GqbhPe++7hRxvtcReWAnTEylv5x66W
         Oz+ExXkoIqqpYQRV1/BhHBd2zZKVYjMXTx2o2gtipnh6U/ONsRG0PNYtvxeYcSbQuNCF
         OevfhWJe3k8IWbmkSuTh4X9m13mekkPaySomIHuj+2rrcV2pUNOMQtc2kKkrev1d3PdC
         27OE9eG7Wps9omLIkFTlddTXHjgPWJpfHwIDH8tYJ4ES+4J4/yQeeaKZ+1wZ0rNpFR2U
         MGdHojKMDP4cdg3Uih2JnLGTnfk+GEm1wxMg0cv3++00CPE09BHczrh9nZp1QKrTtKc2
         g7Rg==
X-Gm-Message-State: ANhLgQ0GzC+JJkXwuyoVgIWwI7ZylBrtJ6ZKy00+ktSabteuhnPNzdUg
        S19BYxce56W0FUxp1dqapZ0=
X-Google-Smtp-Source: ADFU+vs86keVc3R9GW2WlHj/r0yzu6HdXq/cUGX8C4azVI25ILshXIk+weU6XCjMh4ohkYSdxKUnNg==
X-Received: by 2002:a17:902:ac83:: with SMTP id h3mr1365905plr.86.1583296608918;
        Tue, 03 Mar 2020 20:36:48 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:f17b])
        by smtp.gmail.com with ESMTPSA id h132sm22429033pfe.118.2020.03.03.20.36.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:36:48 -0800 (PST)
Date:   Tue, 3 Mar 2020 20:36:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
References: <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
 <87imjms8cm.fsf@toke.dk>
 <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
 <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
 <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
 <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
 <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
 <87k1413whq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k1413whq.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 11:27:13PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <ast@fb.com> writes:
> >
> > Legacy api for tc, xdp, cgroup will not be able to override FD-based
> > link. For TC it's easy. cls-bpf allows multi-prog, so netlink
> > adding/removing progs will not be able to touch progs that are
> > attached via FD-based link.
> > Same thing for cgroups. FD-based link will be similar to 'multi' mode.
> > The owner of the link has a guarantee that their program will
> > stay attached to cgroup.
> > XDP is also easy. Since it has only one prog. Attaching FD-based link
> > will prevent netlink from overriding it.
> 
> So what happens if the device goes away?

I'm not sure yet whether it's cleaner to make netdev, qdisc, cgroup to be held
by the link or use notifier approach. There are pros and cons to both.

> > This way the rootlet prog installed by libxdp (let's find a better name
> > for it) will stay attached.
> 
> Dispatcher prog?

would be great, but 'bpf_dispatcher' name is already used in the kernel.
I guess we can still call the library libdispatcher and dispatcher prog?
Alternatives:
libchainer and chainer prog
libaggregator and aggregator prog?
libpolicer kinda fits too, but could be misleading.
libxdp is very confusing. It's not xdp specific.

> > libxdp can choose to pin it in some libxdp specific location, so other
> > libxdp-enabled applications can find it in the same location, detach,
> > replace, modify, but random app that wants to hack an xdp prog won't
> > be able to mess with it.
> 
> What if that "random app" comes first, and keeps holding on to the link
> fd? Then the admin essentially has to start killing processes until they
> find the one that has the device locked, no?

Of course not. We have to provide an api to make it easy to discover
what process holds that link and where it's pinned.
But if we go with notifier approach none of it is an issue.
Whether target obj is held or notifier is used everything I said before still
stands. "random app" that uses netlink after libdispatcher got its link FD will
not be able to mess with carefully orchestrated setup done by libdispatcher.

Also either approach will guarantee that infamous message:
"unregister_netdevice: waiting for %s to become free. Usage count"
users will never see.

> And what about the case where the link fd is pinned on a bpffs that is
> no longer available? I.e., if a netdevice with an XDP program moves
> namespaces and no longer has access to the original bpffs, that XDP
> program would essentially become immutable?

'immutable' will not be possible.
I'm not clear to me how bpffs is going to disappear. What do you mean
exactly?

> > We didn't come up with these design choices overnight. It came from
> > hard lessons learned while deploying xdp, tc and cgroup in production.
> > Legacy apis will not be deprecated, of course.
> 
> Not deprecated, just less privileged?

No idea what you're referring to.
