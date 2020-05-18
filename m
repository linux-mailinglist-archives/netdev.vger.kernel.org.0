Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7391D7FB4
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgERRJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:09:37 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54600 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgERRJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:09:37 -0400
Received: by mail-pj1-f68.google.com with SMTP id s69so113222pjb.4;
        Mon, 18 May 2020 10:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BpdZFKBxjPy5g9XACLYMs2Py89NvcD1b96UVdrU1huk=;
        b=HCmPyiD5Axpm3EtzAktC9koUaqP2TxLMd8CW25vWjEsX86kUSjUUcVw4mtX+7GK9qp
         7fDhZYpy2+o+Ces1qabEXeH5XOdUWTsf2OQIJhtNBBuWi/mANCamqDP45SlkeWWldMb4
         NfdcAYlCAJox1Wt7FXqxN0peRarsNVcB34NqTF937OphOk3UtLR+pND8yvxo8OSnZpCt
         OH4rQIM9ZcBXtiYsuFhGc6EDcCWte8/ecOCmpOy8KO1FbMQjjlhDIj4wDwMXFjNO965b
         BTvtSn9a88lv1dTIWclLTT4eszSo4WeCeook6PQbUE85piQHiAbVsGMLA6siOMZAY/XW
         BZOg==
X-Gm-Message-State: AOAM531FYBxHDwk8lK9Jitt1g4aaw4gwwjDA3XaSZWwhaLgKwj094xex
        6mBYhx9bS/XhGeQKgZyYGPQ=
X-Google-Smtp-Source: ABdhPJw35pB+pM+AMb3AfYK730hICV8dwuHZ+BlWJw6Xe+cZu5OTn9VjdyZ0zAS4Kzq+3W/z+TyFsQ==
X-Received: by 2002:a17:902:8a8d:: with SMTP id p13mr16933969plo.32.1589821776222;
        Mon, 18 May 2020 10:09:36 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id q4sm4572021pfu.42.2020.05.18.10.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 10:09:35 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 73E02404B0; Mon, 18 May 2020 17:09:34 +0000 (UTC)
Date:   Mon, 18 May 2020 17:09:34 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518170934.GJ11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <20200518165154.GH11244@42.do-not-panic.com>
 <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 09:58:53AM -0700, Ben Greear wrote:
> 
> 
> On 05/18/2020 09:51 AM, Luis Chamberlain wrote:
> > On Sat, May 16, 2020 at 03:24:01PM +0200, Johannes Berg wrote:
> > > On Fri, 2020-05-15 at 21:28 +0000, Luis Chamberlain wrote:> module_firmware_crashed
> > > 
> > > You didn't CC me or the wireless list on the rest of the patches, so I'm
> > > replying to a random one, but ...
> > > 
> > > What is the point here?
> > > 
> > > This should in no way affect the integrity of the system/kernel, for
> > > most devices anyway.
> > 
> > Keyword you used here is "most device". And in the worst case, *who*
> > knows what other odd things may happen afterwards.
> > 
> > > So what if ath10k's firmware crashes? If there's a driver bug it will
> > > not handle it right (and probably crash, WARN_ON, or something else),
> > > but if the driver is working right then that will not affect the kernel
> > > at all.
> > 
> > Sometimes the device can go into a state which requires driver removal
> > and addition to get things back up.
> 
> It would be lovely to be able to detect this case in the driver/system
> somehow!  I haven't seen any such cases recently,

I assure you that I have run into it. Once it does again I'll report
the crash, but the problem with some of this is that unless you scrape
the log you won't know. Eventually, a uevent would indeed tell inform
me.

> but in case there is
> some common case you see, maybe we can think of a way to detect it?

ath10k is just one case, this patch series addresses a simple way to
annotate this tree-wide.

> > > So maybe I can understand that maybe you want an easy way to discover -
> > > per device - that the firmware crashed, but that still doesn't warrant a
> > > complete kernel taint.
> > 
> > That is one reason, another is that a taint helps support cases *fast*
> > easily detect if the issue was a firmware crash, instead of scraping
> > logs for driver specific ways to say the firmware has crashed.
> 
> You can listen for udev events (I think that is the right term),
> and find crashes that way.  You get the actual crash info as well.

My follow up to this was to add uevent to add_taint() as well, this way
these could generically be processed by userspace.

  Luis
