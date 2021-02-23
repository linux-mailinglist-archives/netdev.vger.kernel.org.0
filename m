Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01837322D1B
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhBWPFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 10:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbhBWPFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 10:05:09 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370CFC061574;
        Tue, 23 Feb 2021 07:04:28 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id g9so14353159ilc.3;
        Tue, 23 Feb 2021 07:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=otAXYzJB25wq80J/qQlN459qZ9enJ8yBsIhi5dYhlrE=;
        b=UR3KOz++6uBpQZyfbIP15IDjLGY8TVpeYhwilVKl+xf2Vtdd9PnpbJFjjcILAEtk3V
         i4l/NXVfOG/gUocXZ7GtvIH+OXwRBoC58a8AeB5rcUTmDjPGjXArqeZmTcILLDXs6ByX
         rfssNK7mPnnvY/eid+ooV7ZtLUjZylF6l5X4PJl6pwiUjJl152QMkovo15Ncj35iifwS
         ltbkI51qrqg8iDexymEvYW2PVfGlmG4f1lscJhKEgjYbYbZeksQgW/HMCuncn5nk9efu
         Fvm+fHbV1/QA5pGW6jACPrJIEdI8VEVpXyjs95P2c9JGUIfSwhO3bTPGDe87M+dEL5EU
         C+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=otAXYzJB25wq80J/qQlN459qZ9enJ8yBsIhi5dYhlrE=;
        b=CoMpI0RQI+n/SEVwt0UiWczn1YiKU654CskoGE5S1WKXOYm3upSG2JT7CcKweT7+wk
         xVIRgOITVeU/k/kMg2ut+yO10e3YytSzROCz2/sZH5msfFiHQlizbSMe9zCJUyEATs1w
         PMGYkVVU3fcUYC11mBL6Z5PQHQmZ1zzC+4jqMf2L2SMpTPuL24hBKQ8Ntkpb8v8flK3w
         7toxAPwIZKq7CX22z+Yyqf5Cni37r7A+iz97QrjYSJMFAH1fzPJh2ULNto2jfMqI63hE
         UI6qRl7eZErURJNim15jqoKW5jaeuEwF6su37kcIWufKQufHe8sgS3iF6Wq/PqIIgjWz
         GTKQ==
X-Gm-Message-State: AOAM531p14USqzlAxLx3gtdmAtHqRr9RWNsw4uXFB50xKvgyQDvpLSGR
        o1Fy9ksSCdlsiJIuO1kA0QLgnDnn0HVQqYtIcOfqWAi99eCfQA==
X-Google-Smtp-Source: ABdhPJxW4k0IAEGM46MzSl2u4/CHPhf8xy+ssZYz31trpvYpJSwDU6DLxJ5g4lw5HvKPTGzFL8v8tO1/xH/BQ664w9Q=
X-Received: by 2002:a92:d201:: with SMTP id y1mr6253028ily.129.1614092667399;
 Tue, 23 Feb 2021 07:04:27 -0800 (PST)
MIME-Version: 1.0
References: <20210220065654.25598-1-heiko.thiery@gmail.com>
 <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com> <20210223142726.GA4711@hoboy.vegasvil.org>
In-Reply-To: <20210223142726.GA4711@hoboy.vegasvil.org>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Tue, 23 Feb 2021 16:04:16 +0100
Message-ID: <CAEyMn7Za9z9TUdhb8egf8mOFJyA3hgqX5fwLED8HDKw8Smyocg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Am Di., 23. Feb. 2021 um 15:27 Uhr schrieb Richard Cochran
<richardcochran@gmail.com>:
>
> On Tue, Feb 23, 2021 at 09:00:32AM +0100, Heiko Thiery wrote:
> > HI Jakub,
> >
> > Am Di., 23. Feb. 2021 um 04:00 Uhr schrieb Jakub Kicinski <kuba@kernel.org>:
> > > Why is the PTP interface registered when it can't be accessed?
> > >
> > > Perhaps the driver should unregister the PTP clock when it's brought
> > > down?
>
> I don't see any reason why a clock should stop ticking just because
> the interface is down.  This is a poor driver design, but sadly it
> gets copied and even defended.

It is not only the PHC clock that stops. Rather, it is the entire
ethernet building block in the SOC that is disabled, including the
PHC.

> > Good question, but I do not know what happens e.g. with linuxptp when
> > the device that was opened before will be gone.
>
> If a network interface goes down, ptp4l will notice via rtnl and close
> the interface.  Then it re-opens the sockets on rtnl up.  However, the
> file descriptor representing the dynamic posix clock stays opened.

Thanks,

-- 
Heiko
