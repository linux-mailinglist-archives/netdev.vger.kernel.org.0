Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EF81E63E1
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391116AbgE1O1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:27:12 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54587 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391020AbgE1O1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:27:10 -0400
Received: by mail-pj1-f67.google.com with SMTP id s69so3247322pjb.4;
        Thu, 28 May 2020 07:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I3QwPwj57vR622OFwPIZLJsqn8CMDVU9+E93zXZEl7w=;
        b=YF/3iztQYka2J5/I2/5yt+wFbeAsjeVgVDe27D0ueaY0Ck8XvO/Dih99q88aHLKlWF
         iDCxqeQ9KWeGsr0kPNjD869SYaG5RKPo3T1vyHqX4H1E/dT9P9ez8Evl/62nI6e35OrT
         PKyIiol/r6rrhCyMbfogclx4+EOwzJrScYrLaelHk6yLr5mgL5xsoLLty6p0RrpBZL6a
         oBvCc2EgHFwH/vmIZ4Hbz+x4sA3SCJhs+u7zV5YuTrg5OdZRU1ImHlHWji64y+DB+Tmc
         Kz87C2mT72Hr+vpXcbXCHYUFqFbnn0yjjn5RYonjdP6rw75/DBNZz5NvyyWh3fkMSIc2
         CR9w==
X-Gm-Message-State: AOAM530xkOXVD3W0fuLbAdeZaGCELXC1Uf8N5c4z8nEK1VdgItaCSrm0
        d4iwzcVEcPpvaK47jKbRr9YAMCVd2hhbMg==
X-Google-Smtp-Source: ABdhPJwuh0Oc4ff2wcfSFUmIRhdt4FUOhwhN8DEKt9EhuyeZbKIoIoTb2yzGCCw5NWHwMFGil/J/zw==
X-Received: by 2002:a17:902:a60e:: with SMTP id u14mr3683709plq.176.1590676028933;
        Thu, 28 May 2020 07:27:08 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g27sm5052741pfr.51.2020.05.28.07.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:27:07 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C5BF340605; Thu, 28 May 2020 14:27:05 +0000 (UTC)
Date:   Thu, 28 May 2020 14:27:05 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jeyu@kernel.org, davem@davemloft.net, michael.chan@broadcom.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        derosier@gmail.com, keescook@chromium.org, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/8] kernel: taint when the driver firmware crashes
Message-ID: <20200528142705.GQ11244@42.do-not-panic.com>
References: <20200526145815.6415-1-mcgrof@kernel.org>
 <20200526154606.6a2be01f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200526230748.GS11244@42.do-not-panic.com>
 <20200526163031.5c43fc1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200527031918.GU11244@42.do-not-panic.com>
 <20200527143642.5e4ffba0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527143642.5e4ffba0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 02:36:42PM -0700, Jakub Kicinski wrote:
> On Wed, 27 May 2020 03:19:18 +0000 Luis Chamberlain wrote:
> > I read your patch, and granted, I will accept I was under the incorrect
> > assumption that this can only be used by networking devices, however it
> > the devlink approach achieves getting userspace the ability with
> > iproute2 devlink util to query a device health, on to which we can peg
> > firmware health. But *this* patch series is not about health status and
> > letting users query it, its about a *critical* situation which has come up
> > with firmware requiring me to reboot my system, and the lack of *any*
> > infrastructure in the kernel today to inform userspace about it.
> > 
> > So say we use netlink to report a critical health situation, how are we
> > informing userspace with your patch series about requring a reboot?
> 
> One of main features of netlink is pub/sub model of notifications.
> 
> Whatever you imagine listening to your uevent can listen to
> devlink-health notifications via devlink. 
> 
> In fact I've shown this off in the RFC patches I sent to you, see 
> the devlink mon health command being used.

Yes but I looked at iputils2 devlink and seems I made an incorrect
assumption this can only be used for a network device rather than
a struct device.

I'll take a second look.

  Luis
