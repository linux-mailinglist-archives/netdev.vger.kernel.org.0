Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15AF1CC2D5
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgEIQmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:42:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35840 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgEIQmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 12:42:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id d22so2385591pgk.3;
        Sat, 09 May 2020 09:42:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8jIgzvH4fNfg2RY0Swgxb6K62M+FnWLsvdH44dQgXpM=;
        b=lxGNYsN0gEfYzxH9C4344vbW8PaJ75TkrYscC/8OpIAUtgXGq1hV9U/inqGeahc3mU
         egfEe4XpvbB71A1o2R4HYfaz7wKEWltpo5uHJB33ww2LGs3oXW2qycyZQ2rBWtM9D6CD
         FEBtEY+poitRw2c35OOKUNtEM4DsuN9gJVWst4tqe5HlmCA9/VspFbVDjEPEDCGCDSeb
         UaoFkCFukUUiGTFhLbsy45R2UKKqioA8ef6TbLyGEkyKJ35O1tAvwZQq0k99aTN4YOsE
         qM+3I1jCTABjSbCHVLZ81rhFyuLAgwPgEXnTRf7Ja3/LrIBVgOPAffL4eFFA3w/elZZi
         CadA==
X-Gm-Message-State: AGi0PuZPlAlfMLhDQh8OPknKvw8WACE49Lx+KSy5Kdu9E2lmcmMYIkH8
        QfhQHYBL5yex9Sqb6J7K9OA=
X-Google-Smtp-Source: APiQypIcF3+bU4Vm9XT8ddunGpEipyNfQt5dyqexc745XTg2dKpGxnV/JV4WFmnxGMctTaowHblfYw==
X-Received: by 2002:a62:fc4f:: with SMTP id e76mr8658178pfh.222.1589042551811;
        Sat, 09 May 2020 09:42:31 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 71sm5137262pfw.111.2020.05.09.09.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 09:42:30 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id B449B40605; Sat,  9 May 2020 16:42:29 +0000 (UTC)
Date:   Sat, 9 May 2020 16:42:29 +0000
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
Message-ID: <20200509164229.GJ11244@42.do-not-panic.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509043552.8745-10-mcgrof@kernel.org>
 <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 09:32:51AM +0300, Igor Russkikh wrote:
> 
> > This makes use of the new module_firmware_crashed() to help
> > annotate when firmware for device drivers crash. When firmware
> > crashes devices can sometimes become unresponsive, and recovery
> > sometimes requires a driver unload / reload and in the worst cases
> > a reboot.
> > 
> > Using a taint flag allows us to annotate when this happens clearly.
> > 
> > Cc: Ariel Elior <aelior@marvell.com>
> > Cc: GR-everest-linux-l2@marvell.com
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > index f4eebaabb6d0..9cc6287b889b 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> > @@ -7854,6 +7854,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> > *buffer)
> >  						 REGDUMP_HEADER_SIZE,
> >  						 &feature_size);
> >  		if (!rc) {
> > +			module_firmware_crashed();
> >  			*(u32 *)((u8 *)buffer + offset) =
> >  			    qed_calc_regdump_header(cdev,
> > PROTECTION_OVERRIDE,
> >  						    cur_engine,
> > @@ -7869,6 +7870,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> > *buffer)
> >  		rc = qed_dbg_fw_asserts(cdev, (u8 *)buffer + offset +
> >  					REGDUMP_HEADER_SIZE,
> > &feature_size);
> >  		if (!rc) {
> > +			module_firmware_crashed();
> >  			*(u32 *)((u8 *)buffer + offset) =
> >  			    qed_calc_regdump_header(cdev, FW_ASSERTS,
> >  						    cur_engine,
> > feature_size,
> > @@ -7906,6 +7908,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void
> > *buffer)
> >  		rc = qed_dbg_grc(cdev, (u8 *)buffer + offset +
> >  				 REGDUMP_HEADER_SIZE, &feature_size);
> >  		if (!rc) {
> > +			module_firmware_crashed();
> >  			*(u32 *)((u8 *)buffer + offset) =
> >  			    qed_calc_regdump_header(cdev, GRC_DUMP,
> >  						    cur_engine,
> 
> 
> Hi Luis,
> 
> qed_dbg_all_data is being used to gather debug dump from device. Failures
> inside it may happen due to various reasons, but they normally do not indicate
> FW failure.
> 
> So I think its not a good place to insert this call.
> Its hard to find exact good place to insert it in qed.

Is there a way to check if what happened was indeed a fw crash?

> One more thing is that AFAIU taint flag gets permanent on kernel, but for
> example our device can recover itself from some FW crashes, thus it'd be
> transparent for user.

Similar things are *supposed* to recoverable with other device, however
this can also sometimes lead to a situation where devices are not usable
anymore, and require a full driver unload / load.

> Whats the logical purpose of module_firmware_crashed? Does it mean fatal
> unrecoverable error on device?

Its just to annotate on the module and kernel that this has happened.

I take it you may agree that, firmware crashing *often* is not good design,
and these issues should be reported to / fixed by vendors. In cases
where driver bugs are reported it is good to see if a firmware crash has
happened before, so that during analysis this is ruled out.

  Luis
