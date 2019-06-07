Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA2B38B98
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 15:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbfFGNZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 09:25:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51315 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfFGNZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 09:25:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id f10so2089776wmb.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 06:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lWF7Zmdzma5qVPiqq9W2CiXxJttkoC05tRBABgFXJ/M=;
        b=PCqTuNeZTb7yegrj934+38ehLd680JhdGBUMG3lzhHUpULWtsuAwvF6bT3SQJIzU60
         t4zlFyt0krRu56LktDzV90YaK3Hu3kxXhPZry3+YK67pYb6li8Gc1Dag7A32sDDBhOpi
         dSx579Jz6HSqhhIDYFXnu1hT+6//hQbtrb9alPKyjcgOegWjdYd5QoOi0cCzv7cTH8fR
         qIpqoUvTU4b74w/fBdcdj3NSV+9Beu4wHl2VcVyrxdBbehCvH5HP1MUcIElB/q36HTYx
         3Ub8fQG5OD1v1xEwbBa8CFE5twm6l2zzF9RaoYQgdZUNV6x4kqvTDJ8swChV0yIN5zEK
         MPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lWF7Zmdzma5qVPiqq9W2CiXxJttkoC05tRBABgFXJ/M=;
        b=s39y+1iTXH/DX/gEbSaho7/DiGXceKCnbRAy9A+ZtRvgrHq6sd6/Gdz20+hCau5gPw
         hhmHxRQSdPHDMlzMBtq6Nl5bvJxZljcfQJVsrFYx3UAa6Pq1QGsLdjaXXXyFALpAo1v9
         p0v5bPxQPvqPMZ1WzWfscOvuzv570QX3wyFuLQ9GaX5aF6oPeZDcI5/cD7PL39qUIIrQ
         DzlE/eZPi9ixKxu0nPF9lT7gG8qgBft6BPrsINi+eokpkHL+rYq8v7QvlrJRCLEAHIxh
         srjchXY+mZ45bdmVA1rFFke4zG1EA9vgQPR/+aDfcpXHwWLxozzeVYZeY14TLKaWm5eU
         6blQ==
X-Gm-Message-State: APjAAAWRFt6aMB0CTj4aWKLmm09iab5UgSrAxepw85xPEON8gfGvUFJ8
        MzL6Sw+LyOkECpBg+P5ObnulIA==
X-Google-Smtp-Source: APXvYqy5W/wAqvcKpemRVdye/6mwU+cvstm7Ag3K2FoAuNgn6L1wcePnLICELZYQJ3rkXhpPcV9Zkg==
X-Received: by 2002:a1c:c305:: with SMTP id t5mr3602053wmf.163.1559913918415;
        Fri, 07 Jun 2019 06:25:18 -0700 (PDT)
Received: from brauner.io (p54AC595E.dip0.t-ipconnect.de. [84.172.89.94])
        by smtp.gmail.com with ESMTPSA id f24sm2144087wmb.16.2019.06.07.06.25.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 06:25:18 -0700 (PDT)
Date:   Fri, 7 Jun 2019 15:25:16 +0200
From:   Christian Brauner <christian@brauner.io>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, tyhicks@canonical.com,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de
Subject: Re: [PATCH RESEND net-next 1/2] br_netfilter: add struct netns_brnf
Message-ID: <20190607132516.q3zwmzrynvqo7mzn@brauner.io>
References: <20190606114142.15972-1-christian@brauner.io>
 <20190606114142.15972-2-christian@brauner.io>
 <20190606081440.61ea1c62@hermes.lan>
 <20190606151937.mdpalfk7urvv74ub@brauner.io>
 <20190606163035.x7rvqdwubxiai5t6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190606163035.x7rvqdwubxiai5t6@salvia>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 06:30:35PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 06, 2019 at 05:19:39PM +0200, Christian Brauner wrote:
> > On Thu, Jun 06, 2019 at 08:14:40AM -0700, Stephen Hemminger wrote:
> > > On Thu,  6 Jun 2019 13:41:41 +0200
> > > Christian Brauner <christian@brauner.io> wrote:
> > > 
> > > > +struct netns_brnf {
> > > > +#ifdef CONFIG_SYSCTL
> > > > +	struct ctl_table_header *ctl_hdr;
> > > > +#endif
> > > > +
> > > > +	/* default value is 1 */
> > > > +	int call_iptables;
> > > > +	int call_ip6tables;
> > > > +	int call_arptables;
> > > > +
> > > > +	/* default value is 0 */
> > > > +	int filter_vlan_tagged;
> > > > +	int filter_pppoe_tagged;
> > > > +	int pass_vlan_indev;
> > > > +};
> > > 
> > > Do you really need to waste four bytes for each
> > > flag value. If you use a u8 that would work just as well.
> > 
> > I think we had discussed something like this but the problem why we
> > can't do this stems from how the sysctl-table stuff is implemented.
> > I distinctly remember that it couldn't be done with a flag due to that.
> 
> Could you define a pernet_operations object? I mean, define the id and size
> fields, then pass it to register_pernet_subsys() for registration.
> Similar to what we do in net/ipv4/netfilter/ipt_CLUSTER.c, see
> clusterip_net_ops and clusterip_pernet() for instance.

Hm, I don't think that would work. The sysctls for br_netfilter are
located in /proc/sys/net/bridge under /proc/sys/net which is tightly
integrated with the sysctls infrastructure for all of net/ and all the
folder underneath it including "core", "ipv4" and "ipv6".
I don't think creating and managing files manually in /proc/sys/net is
going to fly. It also doesn't seem very wise from a consistency and
complexity pov. I'm also not sure if this would work at all wrt to file
creation and reference counting if there are two different ways of
managing them in the same subfolder...
(clusterip creates files manually underneath /proc/net which probably is
the reason why it gets away with it.)

Christian
