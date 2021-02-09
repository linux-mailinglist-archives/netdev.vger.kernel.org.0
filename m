Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CB6315678
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhBITFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbhBISwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:52:04 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33461C0613D6
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 10:51:23 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id df22so25274229edb.1
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 10:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=95pwxLL5ZwHwKKlHdf85VbQrB+heR6WO9wqwi1sDnic=;
        b=n1aZYZKV3JTeySPjTkbZEiZWvBeQcpxrx5c3V0wxQRjqios18tOLLeFXXup+LT/CFn
         zw2t6kSlnTAS2mIHLtroBzvEVATKpAjRD7kC3JSIFZByyFAIH+JuV1Rd3Wal/VfdXWNn
         6x9w6jY4MZ8DyTzY1/N6gLy4wIgLYn6FzrbJs1MpF8/c7a1BsAKgIBDGgIVu7eySixNN
         eGvZ8NcF+veyB4hBf1xwJeQiL1xfZmP33oaOdzLoFnRkts4f8EWBlFQEm3rrwpMSeHEt
         GE0IGr/u2yxGsq+/pLL0smt7tqZtTanW3bDovVbmpsbeEzv7EblZTEzSrEJ3KVBLTSK6
         3H/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=95pwxLL5ZwHwKKlHdf85VbQrB+heR6WO9wqwi1sDnic=;
        b=W3FawmxNPownJiclk+D/8YjFkqYxWagi+dJvd49FpxK4VOC2PqCGmr2GJLu3MnBdMB
         yqgB3yONjFkLWdzCUTPXAU6QHbkynQKQtC/rm3xW8uM+VVTqiH1qL9oUv9ZsYFzcCfNE
         6R7qvHLUEjouFn1o02tjmI9UnXL3y9gQMm6nrF2WQedL1M9aHMDpPLH8HXCqVfUlr3X8
         rwQ7aCZDuLEdAfY8fKakDGm7oYYoV5VdtrfrhZmup7ay0YNZBZT3/SRWOaRWkLTH6MM5
         4i4rgPG+5aYChhgdfVi+H1AayxMvjdHJr/HbjmOWzvlvodtewz4bZyG7VBJTnmA460RX
         aESg==
X-Gm-Message-State: AOAM533VtCOvbwrn0xKFaQhaZzCC58iY3WzHfwsZGSg1cfET7DjVLKd6
        NQ4s9Y3pnXDlEHqt9Fm+MWQ=
X-Google-Smtp-Source: ABdhPJxk3O5T+WZ0FfbOsu2od4Apw+MPGtJafHuQw9+yoLi0+wYGSa8EG/myO0H8HBgiVoWdec23sQ==
X-Received: by 2002:aa7:c0cd:: with SMTP id j13mr24650436edp.319.1612896681919;
        Tue, 09 Feb 2021 10:51:21 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b3sm12331604edw.14.2021.02.09.10.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 10:51:20 -0800 (PST)
Date:   Tue, 9 Feb 2021 20:51:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] net: dsa: add support for offloading HSR
Message-ID: <20210209185119.a4zptdw2xxufzkxp@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-4-george.mccollister@gmail.com>
 <20210206232931.pbdvtx3gyluw2s4u@skbuf>
 <CAFSKS=MbXJ5VOL1aPWsNyxZfhOUh9XJ7taGMrNnNv5F2OQPJzA@mail.gmail.com>
 <20210209172024.qlpomxk6siiz5tbr@skbuf>
 <CAFSKS=OZqpO8=XgZOf8AGFbqPjKu1FryR-1+Qefdt7ku9PSU0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=OZqpO8=XgZOf8AGFbqPjKu1FryR-1+Qefdt7ku9PSU0w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 12:37:38PM -0600, George McCollister wrote:
> On Tue, Feb 9, 2021 at 11:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Mon, Feb 08, 2021 at 11:21:26AM -0600, George McCollister wrote:
> > > > If you return zero, the software fallback is never going to kick in.
> > >
> > > For join and leave? How is this not a problem for the bridge and lag
> > > functions? They work the same way don't they? I figured it would be
> > > safe to follow what they were doing.
> >
> > I didn't say that the bridge and LAG offloading logic does the right
> > thing, but it is on its way there...
> >
> > Those "XXX not offloaded" messages were tested with cases where the
> > .port_lag_join callback _is_ present, but fails (due to things like
> > incompatible xmit hashing policy). They were not tested with the case
> > where the driver does not implement .port_lag_join at all.
> >
> > Doesn't mean you shouldn't do the right thing. I'll send some patches
> > soon, hopefully, fixing that for LAG and the bridge, you can concentrate
> > on HSR. For the non-offload scenario where the port is basically
> > standalone, we also need to disable the other bridge functions such as
> > address learning, otherwise it won't work properly, and that's where
> > I've been focusing my attention lately. You can't offload the bridge in
> > software, or a LAG, if you have address learning enabled. For HSR it's
> > even more interesting, you need to have address learning disabled even
> > when you offload the DANH/DANP.
> 
> Do I just return -EOPNOTSUPP instead of 0 in dsa_switch_hsr_join and
> dsa_switch_hsr_leave?

Yes, return -EOPNOTSUPP if the callbacks are not implemented please.

> I'm not sure exactly what you're saying needs to be done wrt to
> address learning with HSR. The switch does address learning
> internally. Are you saying the DSA address learning needs to be
> disabled?

I'm saying that when you're doing any sort of redundancy protocol, the
switch will get confused by address learning if it performs it at
physical port level, because it will see the same source MAC address
coming in from 2 (or more) different physical ports. And when it sees a
packet coming in through a port that it had already learned it should be
the destination for the MAC address because an earlier packet came
having that MAC address as source, it will think it should do
hairpinning which it's configured not to => it'll drop the packet.

Now, your switch might have some sort of concept of address learning at
logical port level, where the "logical port" would roughly correspond to
the hsr0 upper (I haven't opened the XRS700x manual to know if it does
this, sorry). Basically if you support RedBox I expect that the switch
is able to learn at the level of "this MAC address came from the HSR
ring, aka from one or both of the individual ring ports". But for
configuring that in Linux, you'd need something like:

ip link set hsr0 master br0
ip link set hsr0 type bridge_slave learning on

and then catch from DSA the switchdev notification emitted for hsr0, and
use that to configure learning on the logical port of your switch
corresponding to hsr0, instead of learning on the physical ports that
offload it.

There are similar issues related to address learning for everything
except a bridge port, basically.

> If that's something I need for this patch some tips on what
> to do would be appreciated because I'm a bit lost.

I didn't say you need to change something related to learning for this
series, because you can't anyway - DSA doesn't give you the knobs to
configure address learning yet. The series where I try to add those are
here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210209151936.97382-1-olteanv@gmail.com/

The take-away is that with those changes, a DSA driver should start its
ports in standalone mode with learning disabled and flooding of all
kinds enabled, and then treat the .port_bridge_flags callback which
should do the right thing and enable/disable address learning only when
necessary.

All I said is that address learning remaining enabled has been an issue
that prevented the non-offload scenarios from really working, but you
shouldn't be too hung up on that, and still return -EOPNOTSUPP, thereby
allowing the software fallback to kick in, even if it doesn't work.
