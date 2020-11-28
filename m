Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6EA2C6E44
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgK1BqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730624AbgK1BpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 20:45:08 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67308C0613D1;
        Fri, 27 Nov 2020 17:45:08 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so9948455ejb.13;
        Fri, 27 Nov 2020 17:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lROR2DvaL+uACSo01yoS7KBC9QA7A+qw88WQmIRZXpk=;
        b=L2JjPH0xqdB12f7NKoW6nxbPCOEADrveoGDG4Sc4cqdeScYJ+O0XFldpBH81+wRxCG
         00TtTTEJBUpSxnplcTnh+zgjBVfwWaRBqE6sT9KUUnjuCPSqwFhmTGU1eSwTwAADhnuW
         8UnFbevQ5uVh4PhCBln4Dt/DNJWqLAAN0Pv75e58DWEoQ5WyIBDw+dcBNxOOAv+bCCbx
         gUguYWcGgW3r+4ZAVF0dZo79JeMZoKgAqdjdIDYAjFLhGCYNPHSchEGpLFXmNCBTWFlz
         lQRS9joAox+RujdBxcYa7MC04gOPP0JiTzNLob53OMQciyI2JNfnYUxLpm1f1DAB5+0C
         ccLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lROR2DvaL+uACSo01yoS7KBC9QA7A+qw88WQmIRZXpk=;
        b=JBYAaGz9abFXIw9q51MzpyvKcvFiFtjE9IIChe8vS9qKY/g6LPmGDJYZPln0Rw1sYj
         mnCxbU9yXmGfZSkFZDWghTFvenWLJAxquAYTTZHMybni9BNXv/o2HoC9bp+uUi4DrOPc
         GgRXPxXYKzgYZAGZvEFnbz3BaQ9qEnEv0rCmjU1XumfqgN/X/EiRRirMjCURLQXHwtiE
         FagioPsHaYmvq0rEJJyZ5Wmv9UmSB5CGBu48dxvlKwbksB7AxjQJEBESSSQqvsN6oDKa
         W5lUu4xRgYC5HUsU7ZDnxot5LIiH0S1EtU4TeN4//+/O0fVjv81eMzhkLarESeBX1+53
         ywWQ==
X-Gm-Message-State: AOAM532aypPgbS25zF/sKFWktPhJqtwTDeIjoZoQ+V2IIqNoCMHeBk5M
        p7eUyOMjpfVCk3MzXauoTfJ2O8gc0FA=
X-Google-Smtp-Source: ABdhPJzf49x+RwRdvlfj/gdbEdogRbhL6KJFlEdE3iFTu6ug0mokFbQAtWcXdibYBuPfVDdoH66hiw==
X-Received: by 2002:a17:906:3ecf:: with SMTP id d15mr10733733ejj.297.1606527907150;
        Fri, 27 Nov 2020 17:45:07 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id s15sm5902175edj.75.2020.11.27.17.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 17:45:06 -0800 (PST)
Date:   Sat, 28 Nov 2020 03:45:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201128014505.hl5erlwnatej2io3@skbuf>
References: <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch>
 <20201127233916.bmhvcep6sjs5so2e@skbuf>
 <20201127155649.5ce7ed82@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127155649.5ce7ed82@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 03:56:49PM -0800, Jakub Kicinski wrote:
> What is it with my email today, didn't get this one again.
>
> On Sat, 28 Nov 2020 01:39:16 +0200 Vladimir Oltean wrote:
> > On Sat, Nov 28, 2020 at 12:30:48AM +0100, Andrew Lunn wrote:
> > > > If there is a better alternative I'm all ears but having /proc and
> > > > ifconfig return zeros for error counts while ip link doesn't will lead
> > > > to too much confusion IMO. While delayed update of stats is a fact of
> > > > life for _years_ now (hence it was backed into the ethtool -C API).
> > >
> > > How about dev_seq_start() issues a netdev notifier chain event, asking
> > > devices which care to update their cached rtnl_link_stats64 counters.
> > > They can decide if their cache is too old, and do a blocking read for
> > > new values.
>
> Just to avoid breaking the suggestion that seqfiles don't sleep after
> .start? Hm. I thought BPF slept (or did cond_reshed()) in the middle of
> seq iteration. We should double check that seqfiles really can't sleep.

I don't think that seqfiles must not sleep after start(), at least
that's my interpretation and confirmed by some tests. I added a might_sleep()
in quite a few places and there is no issue now that we don't take the
RCU read-side lock any longer. Have you seen my previous reply to
George:

| > I suppose it doesn't really matter though since the documentation says
| > we can't sleep.
|
| You're talking, I suppose, about these words of wisdom in
| Documentation/filesystems/seq_file.rst?
|
| | However, the seq_file code (by design) will not sleep between the calls
| | to start() and stop(), so holding a lock during that time is a
| | reasonable thing to do. The seq_file code will also avoid taking any
| | other locks while the iterator is active.
|
| It _doesn't_ say that you can't sleep between start() and stop(), right?
| It just says that if you want to keep the seq_file iterator atomic, the
| seq_file code is not sabotaging you by sleeping. But you still could
| sleep if you wanted to.
