Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C80244EA34
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhKLPiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbhKLPiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:38:15 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B149BC061766;
        Fri, 12 Nov 2021 07:35:24 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id s13so16217162wrb.3;
        Fri, 12 Nov 2021 07:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=54vdZc09O3LUxrJ9TuNkhhh4Yy9b5Dj3zojd9EQuDrI=;
        b=deD7J1QRiPdk9m1+zaiV/Y2Va7guS4HF9t4xyqqrdFWdi5ts8OFRQ5HHqBfOheULvC
         KKWLN1CXfnRNxFb6pDxd3+/e3Y3L72a/dVDiXFlembAcN05xMQq2Wx8nylSnSXLAOFeZ
         6g4zjyZgqBH16roGoqVdGm8Scpd5ekRXobVtHl6DMu3RMG8ZhgKtZpIhcaDAI2rXlhNI
         j03PMiGVw1dHQGTfG0AjDQTC6TYdcFNEsr3ci6zlzg+r7bwi5C9Jj+iGfV8ViiKWLUiz
         hMSQdCGSszIGTcwwCaad4pnW3kXEYHt+J5zF3x563NiBZJ4ZJ9XraFY2FTbTiMeUhwvi
         0KIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=54vdZc09O3LUxrJ9TuNkhhh4Yy9b5Dj3zojd9EQuDrI=;
        b=mXXR46GSwmho2XRX5yMBJcXPCnQWpStvk/iAPl3EQi+avQM2T6a2PCQM5UxaMhvWum
         jd7YP4iKFdk2TGPN075YZxW+qK6YED04yq6GV7TPZyy3Y7ttUFUFeeUSir/fJCK3Qyum
         hPDUmA5A2Y52wgOHCE4mH05GNKMKZDeKUtzvyYz8BpP1bdD9CJGGRR4mdNThYw7cfbHu
         ri148Z0iBInh/1C8W42xgnI8u9dDDvkwXxTnHX8jXWKiUnQAUmbo+xrqky7GcvMjJqWs
         sRdymnJj3/TG5LmFnIXZVanr87KuGLfqMvxNtMKm/SlnqZT0uyd/0lOS9Jt20EaYraCL
         hdZw==
X-Gm-Message-State: AOAM530cSo1zBIjTbjSmU+9NwH6W1dlCu3bNbl8uzXpEcA0CZf4shSfp
        9gl8yMdwyKoe9e1peedYA4tyEhPmxAQ=
X-Google-Smtp-Source: ABdhPJyFDA9qUFXCAJLeIuQ1gJQNHXovtiXgGVM/Z0sHHaq4hnX3LfPKGWxc7KD+qr+wOK2H5GoVsQ==
X-Received: by 2002:a5d:6843:: with SMTP id o3mr19194336wrw.174.1636731323141;
        Fri, 12 Nov 2021 07:35:23 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id y12sm5956231wrn.73.2021.11.12.07.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:35:22 -0800 (PST)
Date:   Fri, 12 Nov 2021 16:35:21 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/8] Adds support for PHY LEDs with offload
 triggers
Message-ID: <YY6JufxwvXpZp6yT@Ansuel-xps.localdomain>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
 <20211111031608.11267828@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211111031608.11267828@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 03:16:08AM +0100, Marek Behún wrote:
> On Thu, 11 Nov 2021 02:34:52 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > This is another attempt in adding support for PHY LEDs. Most of the
> > times Switch/PHY have connected multiple LEDs that are controlled by HW
> > based on some rules/event. Currently we lack any support for a generic
> > way to control the HW part and normally we either never implement the
> > feature or only add control for brightness or hw blink.
> > 
> > This is based on Marek idea of providing some API to cled but use a
> > different implementation that in theory should be more generilized.
> > 
> > The current idea is:
> > - LED driver implement 3 API (hw_control_status/start/stop).
> >   They are used to put the LED in hardware mode and to configure the
> >   various trigger.
> > - We have hardware triggers that are used to expose to userspace the
> >   supported hardware mode and set the hardware mode on trigger
> >   activation.
> > - We can also have triggers that both support hardware and software mode.
> > - The LED driver will declare each supported hardware blink mode and
> >   communicate with the trigger all the supported blink modes that will
> >   be available by sysfs.
> > - A trigger will use blink_set to configure the blink mode to active
> >   in hardware mode.
> > - On hardware trigger activation, only the hardware mode is enabled but
> >   the blink modes are not configured. The LED driver should reset any
> >   link mode active by default.
> > 
> > Each LED driver will have to declare explicit support for the offload
> > trigger (or return not supported error code) as we the trigger_data that
> > the LED driver will elaborate and understand what is referring to (based
> > on the current active trigger).
> > 
> > I posted a user for this new implementation that will benefit from this
> > and will add a big feature to it. Currently qca8k can have up to 3 LEDs
> > connected to each PHY port and we have some device that have only one of
> > them connected and the default configuration won't work for that.
> > 
> > I also posted the netdev trigger expanded with the hardware support.
> > 
> > More polish is required but this is just to understand if I'm taking
> > the correct path with this implementation hoping we find a correct
> > implementation and we start working on the ""small details""
> 
> Hello Ansuel,
> 
> besides other things, I am still against the idea of the
> `hardware-phy-activity` trigger: I think that if the user wants the LED
> to indicate network device's link status or activity, it should always
> be done via the existing netdev trigger, and with that trigger only.
> 
> Yes, I know that netdev trigger does not currently support indicating
> different link modes, only whether the link is up (in any mode). That
> should be solved by extending the netdev trigger.
> 
> I am going to try to revive my last attempt and send my proposal again.
> Hope you don't mind.
> 
> Marek

Honestly... It's a bit sad.
The netdev trigger have its limitation and I see introducing an
additional trigger a practical way to correctly support some
strange/specific PHY.
I implemented both idea: expand netdev and introduce a dedicated
trigger and still this is problematic.
Is having an additional trigger for the specific task that bad?

I don't care as long as the feature is implemented but again
pretty sad how this LEDs proposal went.

-- 
	Ansuel
