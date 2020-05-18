Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1171D89FC
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 23:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgERVWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 17:22:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46645 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgERVWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 17:22:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id 145so5529587pfw.13;
        Mon, 18 May 2020 14:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y/wo2Runc9bAB/6pd6AKP8cw8s6s3rSoWBtx05F6YCY=;
        b=FymUGAi+qHWAnxN2+dkVooEaU1xb5GgkL3l9TdVi8pj91FwAf/vneT/RnRU83rXd5V
         aWyIVXA+9fydUAc6CLWRPBL0+rtCesAVIPP3dydOT0lIymqFBd/kENFUT/ubRhBnVx20
         l7O3suq4A/cB3T3PHC3+QtA5AaBr3EF42bHX0V44AHsvKjh/A4kyRKE9qOkb9iezvRAS
         NmD233UMq8VYGV/aMF5qGNFwO0HZUFYypsjsaeiOw92dtsnVBiZzMqF8NYDQSTbz+zAI
         +SCjMuhh3g85BVNm0Gr6iqPQkJ1Dv5j+W7VjYSxiQBaMcMtomAfxl+qDmZYDswRJ3lMj
         KvJg==
X-Gm-Message-State: AOAM531C1Enou/GtjWf2HyPqpcBVZLhTHNwckICyVYq1pkPi8nRoNQi1
        LO0fqaTXk14Z9FH9eoq+MA0=
X-Google-Smtp-Source: ABdhPJxRLL0rTq2IGsFVxmB6BhC8z1lsUdqt1OZAfIGKtPauSAho1gbrv5Utwt5N1LUfBc32tNhgtg==
X-Received: by 2002:a62:15c7:: with SMTP id 190mr8308823pfv.190.1589836924550;
        Mon, 18 May 2020 14:22:04 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id l6sm9387019pfl.128.2020.05.18.14.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:22:03 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 90999404B0; Mon, 18 May 2020 21:22:02 +0000 (UTC)
Date:   Mon, 18 May 2020 21:22:02 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518212202.GR11244@42.do-not-panic.com>
References: <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
 <20200518171801.GL11244@42.do-not-panic.com>
 <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
 <20200518190930.GO11244@42.do-not-panic.com>
 <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
 <20200518132828.553159d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8d7a3bed242ac9d3ec55a4c97e008081230f1f6d.camel@sipsolutions.net>
 <20200518133521.6052042e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d81601b17065d7dc3b78bf8d68faf0fbfdb8c936.camel@sipsolutions.net>
 <20200518134643.685fcb0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518134643.685fcb0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 01:46:43PM -0700, Jakub Kicinski wrote:
> On Mon, 18 May 2020 22:41:48 +0200 Johannes Berg wrote:
> > On Mon, 2020-05-18 at 13:35 -0700, Jakub Kicinski wrote:
> > > It's intended to be a generic netlink channel for configuring devices.
> > > 
> > > All the firmware-related interfaces have no dependencies on netdevs,
> > > in fact that's one of the reasons we moved to devlink - we don't want
> > > to hold rtnl lock just for talking to device firmware.  
> > 
> > Sounds good :)
> > 
> > So I guess Luis just has to add some way in devlink to hook up devlink
> > health in a simple way to drivers, perhaps? I mean, many drivers won't
> > really want to use devlink for anything else, so I guess it should be as
> > simple as the API that Luis proposed ("firmware crashed for this struct
> > device"), if nothing more interesting is done with devlink?
> > 
> > Dunno. But anyway sounds like it should somehow integrate there rather
> > than the way this patchset proposed?
> 
> Right, that'd be great. Simple API to register a devlink instance with
> whatever number of reporters the device would need. I'm happy to help.

Indeed my issue with devlink is that it did not seem generic enough for
all devices which use firmware and for which firmware can crash. Support
should not have to be "add devlink support" + "now use this new hook",
but rather a very lighweight devlink_crash(device) call we can sprinkly
with only the device as a functional requirement.

  Luis
