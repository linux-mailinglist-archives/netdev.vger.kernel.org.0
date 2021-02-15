Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3EF31BB49
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBOOkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBOOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 09:40:23 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AD6C061574;
        Mon, 15 Feb 2021 06:39:43 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id lw17so2745540pjb.0;
        Mon, 15 Feb 2021 06:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4k/YlfJBwWB/CB9z3j4IwxeWRKuiJsOpEaK3C24WkHk=;
        b=k0cKC4YN6xyUE2B/OZFXTOW9hvFzaOa/URb+GHSCBxTTmvHlMC9Eta86bh6fCS9h2p
         y66p0KfJrrfzJdHwjKlIKVB09VTVbd8uO5LXSTfEckTSNA43ibpSr8FxWBvDdzmW/BWP
         D111hPR6Xc8SNuwH0bo7QeN6FPMIDV5Y47SI04WrnHpsqUW7Pn19GxIBUPAD78SOfWtE
         LysnRjPtGWRF1ja99qJEZ6qCT91Y+1p89jqnovBYM8L3YBS6mmwrAIHWcWUHvpfD2Por
         THlYbftsWLvbsoIK6qHMb55DNXsFpGqLgZr/IxGSdJOXdfxUNuqxPX8Wt22SgCOeFLSW
         hJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4k/YlfJBwWB/CB9z3j4IwxeWRKuiJsOpEaK3C24WkHk=;
        b=etxD76IHjYoaFPmTv7P9BOfwDxHDzdw4H1cJbdN4APskpfst9V1nL02pa3agWQgHgC
         Zpeqp2zEC/5KVrBZO1Ux6XGlaghnQWFnVMU2eDYi2jEEazHrWw/KdrfhQZkPFXCFq1uG
         Y20xCuhGZHE5laTDuR36P79Qgx780X+Yvci0GTa06IfFDS5HNCn1eCbpnafcac3Sz+g4
         4bcLukIH/9u75bgIuCwYIisXaacJqoAM/5F4tG3cA0+HyM4Kw53VetC5iX0FPHQczivU
         KLnv2LFdEC8V5TBViH8oUrP5mj2dnN0W4/hwas5zxzn46TUOmo3caws8TsfOOoUSUaBk
         GTnQ==
X-Gm-Message-State: AOAM530MJyjm8bvQ8wyv1aGlGSfHL7SasDGiAGB+3vb0mj9yTmzEpoWa
        AtOwjVezIKpqMAXOOl8el06PelRFGJLPIq03mOc=
X-Google-Smtp-Source: ABdhPJy9SDAXtfrqtid4Hgf/WmX56bcIzMX0hLwcVyFTihSbcDK6SFjwAfBNq9cDuyKpg4C7ydYrGf9glnfzwN5MZwk=
X-Received: by 2002:a17:90a:1b23:: with SMTP id q32mr16831579pjq.181.1613399982663;
 Mon, 15 Feb 2021 06:39:42 -0800 (PST)
MIME-Version: 1.0
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com> <43456ba7-c372-84cc-4949-dcb817188e21@amd.com>
In-Reply-To: <43456ba7-c372-84cc-4949-dcb817188e21@amd.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 15 Feb 2021 16:39:26 +0200
Message-ID: <CAHp75VfVXnqdVRAPQ36vZeD-ZMCjWmjA_-6T=jnOEVMne4bv0g@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] string: Consolidate yesno() helpers under string.h hood
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        amd-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        netdev <netdev@vger.kernel.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc: Sakari and printk people

On Mon, Feb 15, 2021 at 4:28 PM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
> Am 15.02.21 um 15:21 schrieb Andy Shevchenko:
> > We have already few similar implementation and a lot of code that can b=
enefit
> > of the yesno() helper.  Consolidate yesno() helpers under string.h hood=
.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> Looks like a good idea to me, feel free to add an Acked-by: Christian
> K=C3=B6nig <christian.koenig@amd.com> to the series.

Thanks.

> But looking at the use cases for this, wouldn't it make more sense to
> teach kprintf some new format modifier for this?

As a next step? IIRC Sakari has at some point the series converted
yesno and Co. to something which I don't remember the details of.

Guys, what do you think?

--=20
With Best Regards,
Andy Shevchenko
