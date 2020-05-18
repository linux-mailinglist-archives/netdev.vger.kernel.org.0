Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C9C1D87F4
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgERTJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:09:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39340 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgERTJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 15:09:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id u35so5277138pgk.6;
        Mon, 18 May 2020 12:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=optcfcz9D+ja/9wb2m7YbvOvyTdqQ3XVuhu+JjEoz4s=;
        b=XsHf7G4/PYPTGQRXWqedTKv/o16h5OTF2CSkrNQ9kFm0+Y8h+M++IZ/3xqqHWt/r/d
         lVybb45gyOVhmIkplFxVUxduORXjSSTCi4UKgD8Cgodh7+GOg4EsFLnCwogUdosTseV3
         RlG0NpLH6KWLbEd9WPCVdSeXiC/HLG/3C3/cvsYbAqPsEKnj4stW2ESEcl1NGdUoO0JB
         xzMrI7mJCj2yI42zewRTcZ5dIYy8r65HJkIJuvxq8UD9av+JEYnIrPJHasmUFY58EpXh
         ZyDq6syXDb19r8JvFZ+puUpkm4Mc8+vGn+vPB0seb/d5dY3K7an8sVfiq77YNgWNzIbB
         /5Rw==
X-Gm-Message-State: AOAM530gh3Z+Uc1fsXbH5T0BD/u3FZUDxRSM5KknQ+b5Ws6exA+fG9cc
        mBEA0WfRmM9Xq9wu3gat3Vo=
X-Google-Smtp-Source: ABdhPJyt1msTeiE8t2U7hvEnds+2fmRUVsBEjK93qHSSKFraZnPO6frtAUXOyMJQx/L2Vbkvr8vnuw==
X-Received: by 2002:a62:7f03:: with SMTP id a3mr11884771pfd.113.1589828972804;
        Mon, 18 May 2020 12:09:32 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id u17sm8598882pgo.90.2020.05.18.12.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 12:09:31 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 9D2D2404B0; Mon, 18 May 2020 19:09:30 +0000 (UTC)
Date:   Mon, 18 May 2020 19:09:30 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Steve deRosier <derosier@gmail.com>
Cc:     Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>, jeyu@kernel.org,
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
Message-ID: <20200518190930.GO11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <20200518165154.GH11244@42.do-not-panic.com>
 <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
 <20200518170934.GJ11244@42.do-not-panic.com>
 <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
 <20200518171801.GL11244@42.do-not-panic.com>
 <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 11:06:27AM -0700, Steve deRosier wrote:
> On Mon, May 18, 2020 at 10:19 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > From a support perspective it is a *crystal* clear sign that the device
> > and / or device driver may be in a very bad state, in a generic way.
> >
> 
> Unfortunately a "taint" is interpreted by many users as: "your kernel
> is really F#*D up, you better do something about it right now."
> Assuming they're paying attention at all in the first place of course.

Taint historically has been used and still is today to help rule out
whether or not you get support, or how you get support.

For instance, a staging driver is not supported by some upstream
developers, but it will be by those who help staging and Greg. TAINT_CRAP
cannot be even more clear.

So, no, it is not just about "hey your kernel is messed up", there are
clear support boundaries being drawn.

> The fact is, WiFi chip firmware crashes, and in most cases the driver
> is able to recover seamlessly. At least that is the case with most QCA
> chipsets I work with. 

That has not been my exerience with the same driver, and so how do we
know? And this patch set is not about ath10k alone, I want you to
think about *all* device drivers with firmware. In my journey to scrape
the kernel for these cases I was very surprised by the amount of code
which clearly annotates these situations.

> And the users or our ability to do anything
> about it is minimal to none as we don't have access to firmware
> source.

This is not true, we have open firmware in WiFi. Some vendors choose
to not open source their firmware, that is their decision.

These days though, I think we all admit, that firmware crashes can use
a better generic infrastructure for ensuring that clearly affecting-user
experience issues. This patch is about that *when and if these happen*,
we annotate it in the kernel for support pursposes.

> It's too bad and I wish it weren't the case, but we have
> embraced reality and most drivers have a recovery mechanism built in
> for this case.

The mentality about firmware crashes being the end of the world is
certainly what will lead developers to often hide these. Where this
is openly clear, and not obfucscated I'd argue that firmware issues
get fixed likely more common.

So what you describe is not bad, its just accepting evolution.

> In short, it's a non-event. I fear that elevating this
> to a kernel taint will significantly increase "support" requests that
> really are nothing but noise;

That will depend on where you put this on the driver, and that is
why it is important to place it in the right place, if any.

> similar to how the firmware load failure
> messages (fail to load fw-2.bin, fail to load fw-1.bin, yay loaded
> fw-0.bin) cause a lot of noise.

That can be fixed, the developers behind this series gave up on it.
It has to do with a range version of supported firmwares, and all
being optional, but at least one is required.

> Not specifically opposed, but I wonder what it really accomplishes in
> a world where the firmware crashing is pretty much a normal
> occurrence.

Recovery without affecting user experience would be great, the taint is
*not* for those cases. The taint definition has:

+ 18) ``Q`` used by device drivers to annotate that the device driver's firmware
+     has crashed and the device's operation has been severely affected. The    
+     device may be left in a crippled state, requiring full driver removal /   
+     addition, system reboot, or it is unclear how long recovery will take.

Let me know if this is not clear.

> If it goes in, I think that the drivers shouldn't trigger the taint if
> they're able to recover normally. Only trigger on failure to come back
> up.  In other words, the ideal place in the ath10k driver isn't where
> you have proposed as at that point operation is normal and we're doing
> a routine recovery.

Sure, happy to remove it if indeed it is the case that the firwmare
crash is not happening to cripple the device, but I can vouch for the
fact that the exact place where I placed it left my device driver in a
state where I had to remove / add again.

  Luis
