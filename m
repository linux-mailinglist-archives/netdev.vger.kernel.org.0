Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C6E30E274
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhBCS0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhBCS0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 13:26:02 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24A1C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 10:25:22 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id n201so281725iod.12
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 10:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WjjztR+/zlAQKrs8dpnO1e+WKkxY66i3upDh1BCqw+Q=;
        b=CWM2e1ie40mSBLF6HN55ZVZVOVTWmQAZ8eOuSiD2tL7FHwXtfytgTTI7og8r8AcDpx
         4heekxGCYTO+S04RahZwSdp25jMotGjDDfxgKtrPHqMj5OkKft2qNzrva30a2xFcWBdB
         j5rrOvGCZt+yI4Xiq2k5M1OV2iA9XS0ST5UaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjjztR+/zlAQKrs8dpnO1e+WKkxY66i3upDh1BCqw+Q=;
        b=HmAJ21LckTheBDqZlXcPz1BzIhupwvJKa8jszRRzvffTzq3r1+datfnNJUSez0QGNm
         UWcr6LFNtEz1BTMZApLO95FDC7cg1+/UDkifRspnU56XlfB9gLwkM0zorqCwGaDXu+r5
         i6ak9LeGJ+kwtxVFO/jU5Na4KuEGM3JhKigUKr+hLPG6Ac36dcfP/TgFlbxPPxqGEocJ
         aZz2kCMDpic6iXn6Zp5mQlC8cCtery2zlkUaDiPacDDRy632zCW/6/Z15A36+e7bSFRp
         v2/jDVNSTVrt769sKq3FILStoXcsujSx8HFODBvWkNHeIJHCcdikoD8oAVXfyN9XTuR4
         FRrQ==
X-Gm-Message-State: AOAM533s2UwGWIwJzy/M/ygtdOFMLmx09CqzoBhRDJVB/ubZxpdDHtVj
        pDBytPUsIUrBhH7YQM+bulheWdiliNejeQyMngY9UA==
X-Google-Smtp-Source: ABdhPJxOgQSwPYKPXYEUGlc6AssCQ3ZZKvQs9O54yfY/xtFFhINrnTTXriFd6HEON997/jzSHi35EToT3lAo6Av9lmw=
X-Received: by 2002:a5d:9315:: with SMTP id l21mr3594739ion.66.1612376722301;
 Wed, 03 Feb 2021 10:25:22 -0800 (PST)
MIME-Version: 1.0
References: <20210129001210.344438-1-hari@netflix.com> <20210201140614.5d73ede0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+ZggZvj_bEo7Jd+Ac=kiE9SZGxJ7JQ=NVTHCkM97jE6g@mail.gmail.com>
 <YBrOnJvBGKi0aa7G@google.com> <20210203101622.05539541@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203101622.05539541@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Hariharan Ananthakrishnan <hari@netflix.com>
Date:   Wed, 3 Feb 2021 10:25:11 -0800
Message-ID: <CAL70W4qyRuHaPGw96sx=XKXLPe9OkhtneF+JU9WaQ1ko25TxRA@mail.gmail.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all tcp:tracepoints
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sdf@google.com, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 10:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 3 Feb 2021 08:26:04 -0800 sdf@google.com wrote:
> > On 02/02, Eric Dumazet wrote:
> > > On Mon, Feb 1, 2021 at 11:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > Eric, any thoughts?
> >
> > > I do not use these tracepoints in production scripts, but I wonder if
> > > existing tools could break after this change ?
> >
> > > Or do we consider tracepoints format is not part of the ABI and can be
> > > arbitrarily changed by anyone ?
> >
> > They are not ABI and since we are extending tracepoints with additional
> > info (and not removing any existing fields) it shouldn't be a problem.
>
> Okay, but we should perhaps add the field at the end just to be on the
> safe side (and avoid weird alignment of the IP addresses).
I added it after dport to be consistent with the earlier patch to
sock:inet_sock_set_state
https://lore.kernel.org/patchwork/patch/870492/.
