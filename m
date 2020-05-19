Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E871D8CE3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgESBFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:05:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40380 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbgESBFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:05:34 -0400
Received: by mail-pl1-f195.google.com with SMTP id t16so4940162plo.7;
        Mon, 18 May 2020 18:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K9aPjeV4NwTg9tl9jzb0nJX+9U/z5KY8RnyA4zhH0iQ=;
        b=saD0XHbQ0OnjTmfgpZU33WtR8Lxyc7JsvrRc/6wS9xSGDEG5yDwaN2P8GFPSbLoDP1
         H8gsMcryUinOIuM54XrhAB/VDt58XBsypkKMEP1Cshp6XK751m8+42ikDGo5ClHs2Lyt
         fmxnGkMEpmugFTeHZiEjgGqHoHKi54rqWdudeFQjJdqfKdRvgUSiXW5xLNyOrvAoLxd1
         vSD/DBhBzjx4pQpeABQCY0HXphy9JH5WB5OKoXGNxNytFz2EkQFf+RuMtKHXeMPfLMct
         HY36Mj8jvewGrSB2BF5uY/d9XyJ2IPS6/cIm+YJFrsbyCOw5r0ON6EiPm3Mz9x/lYDU8
         jNew==
X-Gm-Message-State: AOAM5320XOi+652GhE992ts8Rv+gD2aMol20l2zPQe7D9OBfUrwKtz87
        IQi6sfECbEk9m1HYl37KPPeDUXZzNEk=
X-Google-Smtp-Source: ABdhPJyqsiuMQQ8IrtPAOnXbAbCthJOk4QcQ7xbbMAx9MJhxdNXa/AIAheZ1W7B7s3zmFmh4S/9Rmg==
X-Received: by 2002:a17:90a:b00d:: with SMTP id x13mr720432pjq.11.1589850333253;
        Mon, 18 May 2020 18:05:33 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id l4sm8666640pgo.92.2020.05.18.18.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 18:05:31 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 0ED2640B24; Tue, 19 May 2020 01:05:31 +0000 (UTC)
Date:   Tue, 19 May 2020 01:05:30 +0000
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
Message-ID: <20200519010530.GS11244@42.do-not-panic.com>
References: <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
 <20200518190930.GO11244@42.do-not-panic.com>
 <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
 <20200518132828.553159d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8d7a3bed242ac9d3ec55a4c97e008081230f1f6d.camel@sipsolutions.net>
 <20200518133521.6052042e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d81601b17065d7dc3b78bf8d68faf0fbfdb8c936.camel@sipsolutions.net>
 <20200518134643.685fcb0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200518212202.GR11244@42.do-not-panic.com>
 <20200518151645.4693cf30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518151645.4693cf30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 03:16:45PM -0700, Jakub Kicinski wrote:
> On Mon, 18 May 2020 21:22:02 +0000 Luis Chamberlain wrote:
> > Indeed my issue with devlink is that it did not seem generic enough for
> > all devices which use firmware and for which firmware can crash. Support
> > should not have to be "add devlink support" + "now use this new hook",
> > but rather a very lighweight devlink_crash(device) call we can sprinkly
> > with only the device as a functional requirement.
> 
> We can provide a lightweight devlink_crash(device) which only generates
> the notification, without the need to register the health reporter or a
> devlink instance upfront. But then we loose the ability to control the
> recovery, count errors, etc. So I'd think that's not the direction we
> want to go in.

Care to show me what the diff stat for a non devlink driver would look
like? Just keep in mind this taint is 1 line addition. Granted, if we
can use SmPL grammar to automate addition of an initial framework to a
driver that'd be great, but since the device addition is subsystem
specific (device_add() and friends), I don't suspect this will be easily
automated.

   Luis
