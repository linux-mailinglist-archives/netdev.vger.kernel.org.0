Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFDC32C4A1
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449938AbhCDAPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388015AbhCCUYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 15:24:15 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E81C061760;
        Wed,  3 Mar 2021 12:23:35 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t29so17084138pfg.11;
        Wed, 03 Mar 2021 12:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zkgxTa1swI7czPihfHxjvpadRXNKE7cU4riRGgz6wYc=;
        b=H0wTIWV6YDtXRsDsVGvbWl59qcAUFOz6CLz9bd9kfWcw5thrryJ63vo6BiBBGk13rn
         VyFwtLUcm8dZYqo24yxrX+PLPvl+dEk0JyDky+bOVviQLPCdeOyH5EcJXTPp14APxGKs
         QJolCmjYo0JUxjDocXXtmdoNqzXMc0f+lj7/55RtEF7pO75Ef6Y7GQKCEEokjSdmrAVS
         6JeSi2IesCXYEmV1iow8iBTNNDtlYYMohMHC7ryhzudG7obhZftFvG/0dlahLeQ8sQ6j
         YB0Hwqre2nJfIsuIF21+wqkiyPgcQQNc+vP3m3L1rgK6aRfFv5Z/YYmB2aaiX1L/nyW9
         foEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zkgxTa1swI7czPihfHxjvpadRXNKE7cU4riRGgz6wYc=;
        b=Y8gD5bsCXsh11ANY/Sr4TJmCTmEfNsW6khurHvbs29UvtYSxabGNd5vL0WejEZ/S6k
         wonVzdbE5qEepuiv4uaCc4aG9c50Gmbepi/DhpEsfD7LWl++AHNQtY4W4ptSv+7u8UQY
         Nti/AwgfHSmFzM2BB/Fx95Y6oW7QLBQAtWhII1WOS45Tz4voD2yKvZuex7K+MBPtRua3
         VC3sPNOUVXkbnYN7ikkDxZwDRoButzgjc5PHq1aZUQFEutuvO3SAj7NLqOp2CBhl0e/t
         cvvQvvwYVbdOjJA7dHysjUiBF8Bq2j/boSg/wzVRyiLdZ40b5IMAzG67epZ9HFryFpOI
         85og==
X-Gm-Message-State: AOAM530fIMCWz8jyVo83QLRDCYW28/eyBFUEQIkKFw9vdG8ZWDRWvhdo
        ucpmRdyTtgPMrBx8qvw9ZHOaF5RFS3P1RdbyZVE=
X-Google-Smtp-Source: ABdhPJzIb/MFBl/1iDElv2ckDbWpVscaiSHzbARRWa8Mg2kRFc5cqa0XVgihYCGPPabh3lgqFYOS7P1IuavjmeqNcFc=
X-Received: by 2002:a65:5c8d:: with SMTP id a13mr601359pgt.63.1614803015304;
 Wed, 03 Mar 2021 12:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal> <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
 <906d8114f1965965749f1890680f2547@dev.tdt.de> <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
 <e1750da4179aca52960703890e985af3@dev.tdt.de> <CAJht_ENP3Y98jgj1peGa3fGpQ-qPaF=1gtyYwMcawRFW_UCpeA@mail.gmail.com>
 <ff200b159ef358494a922a676cbef8a6@dev.tdt.de> <CAJht_EMG27YU+Jxtb2qeq1nXwu8uV8FXQPr62OcNHsE7DozD1g@mail.gmail.com>
 <41b77b1c3cf1bb7a51b750faf23900ef@dev.tdt.de> <20210302153034.5f4e320b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8cac820a181070ac2bad983dc49e4e4e@dev.tdt.de>
In-Reply-To: <8cac820a181070ac2bad983dc49e4e4e@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 3 Mar 2021 12:23:24 -0800
Message-ID: <CAJht_ENFd74+MeqYDk4AtipKFcQ3n7WHG-rNL62Z=K3FxWct=A@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 5:26 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2021-03-03 00:30, Jakub Kicinski wrote:
> >
> > Hard question to answer, existing users seem happy and Xie's driver
> > isn't upstream, so the justification for potentially breaking backward
> > compatibility isn't exactly "strong".
> >
> > Can we cop out and add a knob somewhere to control spawning the extra
> > netdev? Let people who just want a newer kernel carry on without
> > distractions and those who want the extra layer can flip the switch?
>
> Yes, that would be a good compromise.
> I think a compile time selection option is enough here.
> We could introduce a new config option CONFIG_HDLC_X25_LEGACY (or
> something like that) and then implement the new or the old behavior in
> the driver accordingly.
>
> A switch that can be toggled at runtime (e.g. via sethdlc) would also be
> conceivable, but I don't think this is necessary.

Yes, I think adding a new config option would be a good way. Thank you both!!
