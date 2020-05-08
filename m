Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96A61CB9DC
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgEHVdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:33:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbgEHVdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:33:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588973598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+H9gfY0KMqcl7s0gN7cY3Jbt3qmRtoGXjfBzgncuN1Y=;
        b=OhuH6InJbZK+XlvPMBxGXAfQ4qQhO/EJ11t6ERw6nsFB2AFh1y3+r4l/BRbvJV+cBLiSLe
        G7Hya2DHBLWxeVIgnUUyZWyDjL3/PnHkYwFPKZGh5BgLoUoxFulYXP6PIm3q2yosHdD4FS
        5BU7jRLmjH+Vf9xUBKMixMTfqFbYkJQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-0iOrkO8SPNWSD7H6Nd-72g-1; Fri, 08 May 2020 17:33:16 -0400
X-MC-Unique: 0iOrkO8SPNWSD7H6Nd-72g-1
Received: by mail-ed1-f72.google.com with SMTP id b7so1185828edf.9
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 14:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+H9gfY0KMqcl7s0gN7cY3Jbt3qmRtoGXjfBzgncuN1Y=;
        b=DTmd+HkGWkG/8KaYHi7jhpJ2Y+t2Ysy9QHpD+jB6LLRACdSoxuOMttqycL92UBw3lJ
         AxnaO+QWVREhiU2lsEKiRTmhGoujRFyP0o4f6P3EqEgEwJ1p7eX7EqSiTU7Zxq0wxhMx
         +dg1yf1Fw5Ro0Na/MLdG1TgTzwYbTIMLn//bhn7chyQQ1a/FjM8EgTeevk0LYoX4oxlB
         gUJRVZrBpSrAiNSqiERiBAfX7/1TMOgOpPxLOxU8c4/uMmXKrSYURyQ8YDM1Ate8wkR/
         wR33y3BrEpSdWBvjElt9E6hinEApn8zPt5umFFVMM+6Ma1+Dmha3U9E5fExOy1NO7e/5
         pJ2g==
X-Gm-Message-State: AGi0PuZh+bmVe19sJiwQq1tuGcALhIE8kMuQNaKzhgxzf/byOHHUVsOa
        cKDDIcOLpA8rkB8RQ/esdonAvtusnWPHQPmXHNZdM0u2Nh19+J5DZkDPU3Xmx3RJzR0GCam0lqO
        HEcS14j+BTom99VBdMucMk1XKQnORUxvb
X-Received: by 2002:a05:6402:b2a:: with SMTP id bo10mr4129369edb.366.1588973595556;
        Fri, 08 May 2020 14:33:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypLRi5hQTFPQlTZ195xdzNxpyl5BtaV77q52+iFQs62RiNsdmly7ZMm54x5TbFUeeEs7Y4Fty3Q2g2CqPg2zdDs=
X-Received: by 2002:a05:6402:b2a:: with SMTP id bo10mr4129358edb.366.1588973595324;
 Fri, 08 May 2020 14:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200414194753.GB25745@shell.armlinux.org.uk> <20200414.164825.457585417402726076.davem@davemloft.net>
In-Reply-To: <20200414.164825.457585417402726076.davem@davemloft.net>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 8 May 2020 23:32:39 +0200
Message-ID: <CAGnkfhw45WBjaYFcrO=vK0pbYvhzan970vtxVj8urexhh=WU_A@mail.gmail.com>
Subject: Re: [PATCH net v2 0/2] Fix 88x3310 leaving power save mode
To:     David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 1:48 AM David Miller <davem@davemloft.net> wrote:
>
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Tue, 14 Apr 2020 20:47:53 +0100
>
> > This series fixes a problem with the 88x3310 PHY on Macchiatobin
> > coming out of powersave mode noticed by Matteo Croce.  It seems
> > that certain PHY firmwares do not properly exit powersave mode,
> > resulting in a fibre link not coming up.
> >
> > The solution appears to be to soft-reset the PHY after clearing
> > the powersave bit.
> >
> > We add support for reporting the PHY firmware version to the kernel
> > log, and use it to trigger this new behaviour if we have v0.3.x.x
> > or more recent firmware on the PHY.  This, however, is a guess as
> > the firmware revision documentation does not mention this issue,
> > and we know that v0.2.1.0 works without this fix but v0.3.3.0 and
> > later does not.
>
> Series applied, thanks.
>

Hi,

should we queue this to -stable?
The 10 gbit ports don't work without this fix.

Regards,
-- 
Matteo Croce
per aspera ad upstream

