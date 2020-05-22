Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FD51DF171
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbgEVVtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:49:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44893 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVVtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:49:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id p30so5601415pgl.11;
        Fri, 22 May 2020 14:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=witZhMJ16Agl4OwIfL5pB8EM3wxhLaftmrS7Z3KmwGo=;
        b=aPn+uE5LHAcTPt68wbrFmA8vQhr/NQc96OjF4bX0IABr4tpP9PX3ll7N9IvPxGjoWp
         Ys4bt/wA6mquWUdE/alebaQmJR2Xeyuq7pemGwR32MTjUt/94eXeJlcozITZ3Wh44yx8
         1SofT/Jp/8+C9mWm1Xawtx3ndew6lCSnnjMLRsk379nRMHWltATmVyyX+W7Dap2TYsEK
         a+AfnhQcrDV0idjEWn6gebFwwFDzWck3sOLf5RdOSiHDTTOzs+M9wFk6eLxWwsFp5iXm
         qTuv8IPvDsTqChz8YN0GwBixNOeTermTEYnZmbnciLUs7i/MJpJz3DcwCpPaMDvptIY8
         UjaA==
X-Gm-Message-State: AOAM5327knA0ctdImbysQwQxBTrKrLvCPuEWEBKKMczzn6U1/BHfDXEB
        61dWLEQzbYbe2tXnuKZtRSg=
X-Google-Smtp-Source: ABdhPJyBq9LZCZJmpi4fQfFbSbNhR4Ql67aNRQjxVYgQP0yBZhIDm5eUIjVEbj0mW3rKV0Gj+0RIIQ==
X-Received: by 2002:a65:52c3:: with SMTP id z3mr15634431pgp.146.1590184172241;
        Fri, 22 May 2020 14:49:32 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y7sm7633645pjn.13.2020.05.22.14.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 14:49:30 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D524C40321; Fri, 22 May 2020 21:49:29 +0000 (UTC)
Date:   Fri, 22 May 2020 21:49:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     johannes@sipsolutions.net, derosier@gmail.com,
        greearb@candelatech.com, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
Message-ID: <20200522214929.GB11244@42.do-not-panic.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
 <20200519211531.3702593-1-kuba@kernel.org>
 <20200522052046.GY11244@42.do-not-panic.com>
 <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 10:17:38AM -0700, Jakub Kicinski wrote:
> On Fri, 22 May 2020 05:20:46 +0000 Luis Chamberlain wrote:
> > > diff --git a/net/core/Makefile b/net/core/Makefile
> > > index 3e2c378e5f31..6f1513781c17 100644
> > > --- a/net/core/Makefile
> > > +++ b/net/core/Makefile
> > > @@ -31,7 +31,7 @@ obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
> > >  obj-$(CONFIG_BPF_STREAM_PARSER) += sock_map.o
> > >  obj-$(CONFIG_DST_CACHE) += dst_cache.o
> > >  obj-$(CONFIG_HWBM) += hwbm.o
> > > -obj-$(CONFIG_NET_DEVLINK) += devlink.o
> > > +obj-$(CONFIG_NET_DEVLINK) += devlink.o devlink_simple_fw_reporter.o  
> > 
> > This was looking super sexy up to here. This is networking specific.
> > We want something generic for *anything* that requests firmware.
> 
> You can't be serious. It's network specific because of how the Kconfig
> is named?

Kconfig? What has that to do with anything? The issue I have is that the
solution I am looking for is for it to be agnostic to the subsystem. I
have found similar firmware crashes on gpu, media, scsci.

> Working for a company operating large data centers I would strongly
> prefer if we didn't have ten different ways of reporting firmware
> problems in the fleet.

Indeed.

> > I'm afraid this won't work for something generic. I don't think its
> > throw-away work though, the idea to provide a generic interface to
> > dump firmware through netlink might be nice for networking, or other
> > things.
> > 
> > But I have a feeling we'll want something still more generic than this.
> 
> Please be specific. Saying generic a lot is not helpful. The code (as
> you can see in this patch) is in no way network specific. Or are you
> saying there are machines out there running without netlink sockets?

No, I am saying I want something to work with any struct device.

> > So networking may want to be aware that a firmware crash happened as
> > part of this network device health thing, but firmware crashing is a
> > generic thing.
> > 
> > I have now extended my patch set to include uvents and I am more set on
> > that we need the taint now more than ever.
> 
> Please expect my nack if you're trying to add this to networking
> drivers.

The uevent mechanism is not for networking.

The taint however is, and I'd like to undertand how it is you do not see
that an undesirable requirement for a reboot is a clear case for a taint.

> The irony is you have a problem with a networking device and all the
> devices your initial set touched are networking. Two of the drivers 
> you touched either have or will soon have devlink health reporters
> implemented.

That is all great, and I don't think its a bad idea to add
infrastructure / extend it to get more information about a firmware
crash dump. However, suggesting that devlink is the only solution we
need in the kernel without considering other subsystems is what I am
suggesting doesn't suit my needs. Networking was just the first
subsystem I am taclking now but I have patches where similar situations
happen across the kernel.

  Luis
