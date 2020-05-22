Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A9A1DDF46
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgEVFX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:23:58 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:32996 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgEVFX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:23:58 -0400
Received: by mail-pj1-f68.google.com with SMTP id z15so1894920pjb.0;
        Thu, 21 May 2020 22:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tIS20nIVD3N2tOP8HqpGQTGvTajJC3k9skSycjshVvo=;
        b=OelwsbVASVPz58GDVNV3N1pIB8GrBLnDJHUL4Si4vNutNwlrFbz+RI8ICE+COFq2pv
         pfRSNrgtB5HdKh7G8zInrPyTAsCwy4olC9ZqqAAiXOscUwSB5jXU1VxkZhy7xn5He/eW
         Py3ArJHCpGfKE4qnWZ0Rx78hZNSTxaPWLHUGdXPYuqgO+Ndy2y3m18dtAQ89UtKUOCU/
         hqmsSRQL7wiYjT73W8TSB1ndHiviZ1Yy/ojsu2WSCv9XKaZN1c4AhmUe3jAFm1By0v34
         HAJ+XOKPhQGdcLEcml5M1zofNNwLDtNxGj9NxpGreAj3+O1pkqH6YVajz+8SODR5EsoH
         Z/fQ==
X-Gm-Message-State: AOAM5305Od7L5F6Zk75Rmut+VrFm1ZS6uBD5wmMF4dc8UgQV6+67DHXp
        D7zYFo8fCvA1ork8VrAlVXA=
X-Google-Smtp-Source: ABdhPJwrA8Ug/bhBlMQocPIWph3Tg+gvIO2vU/EDcU5VOBbAHGT6IBZ5MccngBHWe4I5el1EFY91Dw==
X-Received: by 2002:a17:90a:150:: with SMTP id z16mr2536283pje.37.1590125037470;
        Thu, 21 May 2020 22:23:57 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id l3sm5931550pjb.39.2020.05.21.22.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 22:23:56 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 531AD4088B; Fri, 22 May 2020 05:23:55 +0000 (UTC)
Date:   Fri, 22 May 2020 05:23:55 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Emmanuel Grumbach <egrumbach@gmail.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        aquini@redhat.com, peterz@infradead.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        mchehab+samsung@kernel.org, will@kernel.org, bhe@redhat.com,
        ath10k@lists.infradead.org, Takashi Iwai <tiwai@suse.de>,
        mingo@redhat.com, dyoung@redhat.com, pmladek@suse.com,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, gpiccoli@canonical.com,
        Steven Rostedt <rostedt@goodmis.org>, cai@lca.pw,
        tglx@linutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        schlad@suse.de, Linux Kernel <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200522052355.GZ11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
 <CA+ASDXOg9oKeMJP1Mf42oCMMM3sVe0jniaWowbXVuaYZ=ZpDjQ@mail.gmail.com>
 <20200519140212.GT11244@42.do-not-panic.com>
 <CA+ASDXMUHOcvJ_7UWgyANMxSz15Ji7TcLDXVCtSPa+fOr=+FGA@mail.gmail.com>
 <CANUX_P1pnV46gOo0aL6QV0b+49ubB7C5nuUOuOfoT7aOM+ye9w@mail.gmail.com>
 <CA+ASDXPAVJwyThAXRQT0_ao4s1nDYOEQifxMc+JsEMa=cTEGJA@mail.gmail.com>
 <CANUX_P2thzh9oB4KkrAoyT6H-E6MDFUNQ_p0e9QZtScgMuKm7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P2thzh9oB4KkrAoyT6H-E6MDFUNQ_p0e9QZtScgMuKm7Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 08:12:59AM +0300, Emmanuel Grumbach wrote:
> >
> > On Tue, May 19, 2020 at 10:37 PM Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> > > So I believe we already have this uevent, it is the devcoredump. All
> > > we need is to add the unique id.
> >
> > I think there are a few reasons that devcoredump doesn't satisfy what
> > either Luis or I want.
> >
> > 1) it can be disabled entirely [1], for good reasons (e.g., think of
> > non-${CHIP_VENDOR} folks, who can't (and don't want to) do anything
> > with the opaque dumps provided by closed-source firmware)
> 
> Ok, if all you're interested into is the information that this event
> happen (as opposed to report a bug and providing the data), then I
> agree. 

I've now hit again a firmware crash with ath10k with the latest firwmare
and kernel and the *only* thing that helped recovery was a full reboot,
so that is a crystal clear case that this needs to taint the kernel, and
yes we do want to inform users too, so I've just added uevent support
for a few panic / taint events in the kernel now and rolled into my
series. I'll run some final tests and then post this as a follow up.

devlink didn't cut it, its networking specific.

  Luis
