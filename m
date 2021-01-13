Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8902F4088
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393532AbhAMAm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392321AbhAMATj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 19:19:39 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0607DC061794
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:18:59 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id f17so524322ljg.12
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 16:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDSBLu/dQ/DU7FQZj8b6YPh8lI8akCH+mH01uvaPees=;
        b=oKYBO4SPdgSBJUsDMIW5CP9v8Ehx9/bCarB8oGP/mHA4+sLd3xf01hYN8meRfn3Z/C
         VRExJAQITYqEfrJHkfEK/+BUy2bi9V125dcXdPXwnGIrz1gChJ8Eagc6sfu5NxDOsM7Q
         s4JHrGiTwBj0egpN48LNdJhwOkgrQljcrnDdfzV8s4tuYkxOP5J3ifDaVQItl+uBWKRi
         hjaQ04uwbDzWLPPYGOzdK8OrUuidnmRBgEslg8HxcWMOGc+R2HncERyeNHOejDUAcGLp
         U6ugLoGlBW/HnCUEp1wdREM2Q0knqc9CwXOGdVRuSBw5YniV+N1wwskoAEZ2xBEOuVvD
         3xUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDSBLu/dQ/DU7FQZj8b6YPh8lI8akCH+mH01uvaPees=;
        b=HNr9ZDpmPt2XNnN4HJGGmUQJRYInb3NAdm/wS6zZsZK09k4fyfOtB4OMqOS6Ui/c5u
         RzE2KfSvgA56E9Fb82dl9COizzk5d00yKcIYWsbagcwJEe2L9A6Gb1HKvdwIC6Vctaa7
         kzlFvdubt3i6YOnsItz4aHLL0AYNp7YBPsWdwNpEIEpw9sCerqcbvczM0oLLCbuN9Jzw
         ulOXSDFqfPMj2bkNwikVGa6yPRJuUhhEApV5s7peWuVd1SPqzeOez7sF2+9cSfRhAOpZ
         y7fTvgERtYd+CxH0cAW6L4KU2hWiYPxbmiOpAqX/SSy1l4tShuSTAjuro+2LF/3McZBW
         3e2A==
X-Gm-Message-State: AOAM530v26P2oCJynqBVlJAcOXYECdzSqpGHDLtz6Q41cvOuGZTlKHXe
        2uFHTIwMVmHwRfUrmFsnKp+eQ76Rc+M5yKMyaVmZoA==
X-Google-Smtp-Source: ABdhPJzLMkGXD6keBgkD1QE7S34ntTTrgx2rICPfCSovNaFVK6UFbwtZ7AQr2ENR3QwGr5QWxwVbsZua9hjphAbv6aQ=
X-Received: by 2002:a2e:9a84:: with SMTP id p4mr715148lji.160.1610497136091;
 Tue, 12 Jan 2021 16:18:56 -0800 (PST)
MIME-Version: 1.0
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
In-Reply-To: <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 12 Jan 2021 16:18:44 -0800
Message-ID: <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
To:     Arjun Roy <arjunroy@google.com>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
>
> On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> >
[snip]
> > Historically we have a corresponding vmstat counter to each charged page.
> > It helps with finding accounting/stastistics issues: we can check that
> > memory.current ~= anon + file + sock + slab + percpu + stack.
> > It would be nice to preserve such ability.
> >
>
> Perhaps one option would be to have it count as a file page, or have a
> new category.
>

Oh these are actually already accounted for in NR_FILE_MAPPED.
