Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01933F361
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhCQOlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhCQOkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:40:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E70C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:40:49 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h13so2560028eds.5
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=S0qpUqjZ/XZQ9qA0uVRAeakS1p3qKcAJBe1e/CP/igI=;
        b=aroCrSXH1wg8rNYcS6fOP9C61MuiICvF9G9P8QrgDeTLzOKq6dRT2OaEeZedfn7n61
         OSTiBWhmzQgYXI0Pgighp37d0HCWPMxWx3BzZAuhkAUbvAnwtj3uxcR3LdsKQRR9WUwR
         EDeTLrqSTfYH24A6xjvxDnweiVU1QLp/Suj142aBrDwsf4gce4LFczNkl/9jGgj8yMzq
         Iv8FoXlGiqKrVr3+216NTdEyI+UpIevF9cyyZbMLu42957U0/Zqy40eQVWs1YSqKBbre
         30hnjfpaPgapYZk2OLGNErMlFazCcfl9lXlqsk4+3eV9ceB9dJPDRTKZ1tWPuEd8y3Wr
         EGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S0qpUqjZ/XZQ9qA0uVRAeakS1p3qKcAJBe1e/CP/igI=;
        b=pzTAUhaTemx78hEGciS8gou456rq+7DvCFWzu0OXuIr2mZTVncH3vVGPZAEAn3RbK9
         xQgR+pbxzNJP8Sufm+K6LiQoNhRHbkg50x8wORJfe38Bk6kUg0n6sbTvHHbMbYJl+omk
         4D0cuv2IUHAYEEjnPhgEuNPIrACaDvexrrDcFVpCCKrxeGlIWaOwEKfcOhGk8L9o6xg6
         oRlHPPwIKm68yfURZRY6LelbXw6itdPur6gDC1Pg29slyIZwcKxOxI/WTSYwNTspOdOM
         rS/0BXpDQdD+IeVccULqKYcUSqxLoJVKYj2gHnJ5mNOvl9vg1WNPp49zBDJRIFz00SCh
         Eq6g==
X-Gm-Message-State: AOAM533sqKavu+uiIBDaDSEIZ4s4Wz+Y4164WfpAuDN6sw7JG3mntEHq
        e66MkSpkgmMOK1CMQLQa1ek=
X-Google-Smtp-Source: ABdhPJzN1VlkBpPk7nK1xufj6xFh0rgQldls1qs1i3NugaTdLN6Be/daWq5BAoi7Ce178RCE6ZZxzA==
X-Received: by 2002:aa7:d0c2:: with SMTP id u2mr42295712edo.158.1615992048076;
        Wed, 17 Mar 2021 07:40:48 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l1sm13078439edt.59.2021.03.17.07.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:40:47 -0700 (PDT)
Date:   Wed, 17 Mar 2021 16:40:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        lkp@intel.com
Subject: Re: [PATCH net-next v17 2/4] net: dsa: mv88e6xxx: wrap
 .set_egress_port method
Message-ID: <20210317144046.vsf2riblq3pms4be@skbuf>
References: <20210317134643.24463-1-kabel@kernel.org>
 <20210317134643.24463-3-kabel@kernel.org>
 <20210317142235.jgkv2q3743wb47wt@skbuf>
 <20210317153433.5b761964@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317153433.5b761964@dellmb.labs.office.nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 03:34:33PM +0100, Marek Behún wrote:
> On Wed, 17 Mar 2021 16:22:35 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > On Wed, Mar 17, 2021 at 02:46:41PM +0100, Marek Behún wrote:
> > > There are two implementations of the .set_egress_port method, and
> > > both of them, if successful, set chip->*gress_dest_port variable.
> > > 
> > > To avoid code repetition, wrap this method into
> > > mv88e6xxx_set_egress_port.
> > > 
> > > Signed-off-by: Marek Behún <kabel@kernel.org>
> > > Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
> > > ---  
> > 
> > Separately from this series, do you think you can rename the
> > "egress_port" into "monitor_port" across the driver? Seeing an
> > EGRESS_DIR_INGRESS is pretty strange.
> 
> You mean even renaming methods .set_egress_port to .set_monitor_port,
> and type
>   enum mv88e6xxx_egress_direction
> to
>   enum mv88e6xxx_monitor_direction?

Yeah, if I'm not asking for too much. I think the last thing some
hardware with closed documentation needs is a driver that obfuscates the
configuration it applies to it.
