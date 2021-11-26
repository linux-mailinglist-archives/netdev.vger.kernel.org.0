Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F17245F2A9
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbhKZROl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240301AbhKZRMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:12:40 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6086BC061377;
        Fri, 26 Nov 2021 08:43:10 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x6so41117002edr.5;
        Fri, 26 Nov 2021 08:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dVeISUeEVpHClnKkMQ0OE78WRtyIlTFqST8HoKpB/lg=;
        b=DxdnNn4/6AD1BmHYf5TrT1sjjfs9xfvEnRKBa9v7vQ8FsQbzMPj/gIx3zzx7P667bw
         gORGVioI7zFtG9UDXnwAx4Z+MyqSrBIj4BtAD+7nPt9FHDyVITXUDy5HDsREnnK9/wCK
         ea00ohCzpkKNtaztZksg6IZK2BzZVLB1SHJalYy73zDE0SIaVjPWmZqiIZgigyQAg0Ev
         Tn0Q3h6G7I7g99oVl6gnODMV0iZrF/JdDvVzP3L3WigN2d1LG9VRXSd3xyhEwlS8QaYo
         yWOQUZDxIkpw+k03pmvvM3fLErMGtTiskLCbZwrwrJOcFwaEDDyR/UTlMIvBp7YIZXt1
         imOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dVeISUeEVpHClnKkMQ0OE78WRtyIlTFqST8HoKpB/lg=;
        b=7/3xNazpmrJAaIJHvqHh7NWXyKba/11wkMU00UFO+0jWUFwc8KXt7VVtiav6sHE2dS
         oJAXAziTtxo75hnaFr2O5YAEkhnzhnjCn2BbMGXFC01XTtyEKak73ELJuySoXIWuSMLe
         isfmDuv/qAeWAxo2KCuGJKqrr7fbAJGvjRbDOd/PkprN7Ckp9YVeB8GwfuneNy3B1jg5
         EJCPSrPezubS5l3RrgqwaRH8NqPH/KEW6z1kP4co2VfEOl8+lRygEHctWIXof7vxvrmj
         vskzQsbhlwPaxMtoo6jUuPp1A9M+hx15DJKlgvDplns5BVXDO228H3qxBrWZk2dUJl18
         x4sQ==
X-Gm-Message-State: AOAM5315x+082GXHH82z3kqsLnKwn9N+rEpRJgeZp0QFD3PfabC9LAVQ
        iH6p9fakkAT3KHbRGtvsSg6JFx+jPpeQ/LRRo7c=
X-Google-Smtp-Source: ABdhPJySPGwvu3kvPxM2wVnk62RJ8nPgqOlUHoeRsfwBzHAnR9RPDlEl9xHXphDzi/PCEDsHrfxYQXjqMnq1xYxUsPM=
X-Received: by 2002:a17:907:7245:: with SMTP id ds5mr29560062ejc.206.1637944988863;
 Fri, 26 Nov 2021 08:43:08 -0800 (PST)
MIME-Version: 1.0
References: <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org> <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org> <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org> <20211107142703.tid4l4onr6y2gxic@skbuf>
 <20211108144824.GD7170@hoboy.vegasvil.org> <20211125170518.socgptqrhrds2vl3@skbuf>
 <87r1b3nw93.fsf@kurt> <20211126163108.GA27081@hoboy.vegasvil.org>
In-Reply-To: <20211126163108.GA27081@hoboy.vegasvil.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 26 Nov 2021 18:42:57 +0200
Message-ID: <CA+h21hq=6eMrCJ=TS+zdrxHhuxcmVFLU0hzGmhLXUGFU-vLhPg@mail.gmail.com>
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to userspace
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 at 18:31, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Fri, Nov 26, 2021 at 09:42:32AM +0100, Kurt Kanzenbach wrote:
> > On Thu Nov 25 2021, Vladimir Oltean wrote:
> > > Richard, when the request is PTP_V2_EVENT and the response is
> > > PTP_V2_L2_EVENT, is that an upgrade or a downgrade?
> >
> > It is a downgrade, isn't it?
>
> Yes.  "Any kind of PTP Event" is a superset of "Any Layer-2 Event".
>
> When userland asks for "any kind", then it wants to run PTP over IPv4,
> IPv6, or Layer2, maybe even more than one at the same time.  If the
> driver changes that to Layer2 only, then the PTP possibilities have
> been downgraded.

Well, when I said that it's essentially the same pattern, this is what
I was talking about. The b53 driver downgrades everything and the
kitchen sink to HWTSTAMP_FILTER_PTP_V2_L2_EVENT, the ocelot driver to
HWTSTAMP_FILTER_PTP_V2_EVENT, and both are buggy for the same reason.
I don't see why you mention that there is an important difference
between HWTSTAMP_FILTER_PTP_V2_L2_EVENT and
HWTSTAMP_FILTER_PTP_V2_EVENT. I know there is, but the _pattern_ is
the same.
I'm still missing something obvious, aren't I?
