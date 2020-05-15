Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E821D5AB7
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEOUce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:32:34 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40207 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgEOUcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 16:32:33 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so1374328plo.7;
        Fri, 15 May 2020 13:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RYXIjhmi8p0VPp986E+C5DkxJffvnyXR/xMPSMVUF4k=;
        b=FTwPiUDwAdxwECBj8QuUA6z8vCb0hLKITgV1FEeHH4VbJUFUEu9LsRKNkvjGPOGujg
         /Nh1GZQGwbUQfvGhkU3mfX6Xj/o7iHbibXDdabE714qKBQaUulS1spc3M5jGNa+6ZhI7
         +G8KbU12KHWUmKn+GG8//6QMVdho16paPO8NtZKd+1pjOFrLGDM6bviXW3roYhx07J2s
         7yqfvncsOygdEZ1cYqkDAJzMyTuiCMnLFlxcSizwnrOyo9w5p+aCuFNY8pBBr+0lzIkv
         GK/p6Nm3vQ0/JQmBZT1g81GeXSmRmX+y37UE0QU5k/gM26w9kH3ol+3z5aedFRQspoaq
         o4Mg==
X-Gm-Message-State: AOAM532MA1t7H9DapehASjwcEgcNTEWE1o5XdJ8iVo0G6e797FnwunhV
        VJ2IAn3lUoK1W3RqaVK0/qQ=
X-Google-Smtp-Source: ABdhPJymbRlSvjODnd1lsY9aeT3Pbs1KtWgTj+HbIx0a5gOTIEm61b7Tz3gwgGkhcTz+6HA6p1BZfg==
X-Received: by 2002:a17:90a:1aa2:: with SMTP id p31mr5231019pjp.233.1589574752783;
        Fri, 15 May 2020 13:32:32 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id b29sm2696978pfp.68.2020.05.15.13.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 13:32:31 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id E467840246; Fri, 15 May 2020 20:32:30 +0000 (UTC)
Date:   Fri, 15 May 2020 20:32:30 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Subject: Re: [EXT] [PATCH 09/15] qed: use new module_firmware_crashed()
Message-ID: <20200515203230.GA11244@42.do-not-panic.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509043552.8745-10-mcgrof@kernel.org>
 <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
 <20200509164229.GJ11244@42.do-not-panic.com>
 <e10b611e-f925-f12d-bcd2-ba60d86dd8d0@marvell.com>
 <20200512173431.GD11244@42.do-not-panic.com>
 <9badaaa7-ca79-9b6d-aa83-b1c28310ec4d@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9badaaa7-ca79-9b6d-aa83-b1c28310ec4d@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 05:53:41PM +0300, Igor Russkikh wrote:
> > 
> > So do you mean like the changes below?
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > index f4eebaabb6d0..95cb7da2542e 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > @@ -7906,6 +7906,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> > *buffer)
> >  		rc = qed_dbg_grc(cdev, (u8 *)buffer + offset +
> >  				 REGDUMP_HEADER_SIZE, &feature_size);
> >  		if (!rc) {
> > +			module_firmware_crashed();
> >  			*(u32 *)((u8 *)buffer + offset) =
> >  			    qed_calc_regdump_header(cdev, GRC_DUMP,
> >  						    cur_engine,
> 
> Please remove this invocation. Its not a place where FW crash is happening.

Will do!

> 
> >  		DP_NOTICE(p_hwfn,
> >  			  "The MFW failed to respond to command 0x%08x
> > [param 0x%08x].\n",
> >  			  p_mb_params->cmd, p_mb_params->param);
> > +		module_firmware_crashed();
> >  		qed_mcp_print_cpu_info(p_hwfn, p_ptt);
> 
> This one is perfect, thanks!

Can I add your Reviewed-by provided I remove the hunk above?

  Luis
