Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57100304DA3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733175AbhAZXM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbhAZVlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 16:41:32 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32863C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:40:52 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id a12so16603945lfb.1
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 13:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8vg8nrSBbokWCvOz2GKxHA+4NetSMNLDLIlMKnGWdE=;
        b=AgyPUMtnaKDhD61MpdEBnwRiL9IUryf2zXzIPYO/0rVtT1/9xR+mR/KSM4sv0l06Hf
         gOPl3KERBL397kiT1frpON2Y/gCSajh7GF+ZkAV3T+3cjW56mmZqzv8z8pqDRcd9dIsT
         YkcJQeY1MIE7kxU9oFydfc55A1l69qzUxhP/PvK6J0YPj3NlQ9oe+Eqzjr4aG+/xosll
         NrIt3hf9iiQxVw7QU/xlrK9YGn8vRCoyhXq4Vxu0YSAfD7iq3RJXoZOARVk/W/r1N6At
         h0mdE5wuOqnjdkBxXYKWRILUIHcJ2XutIkoZAIYkyGCsgdsOzrzbmE1STCFnN5ULNI1H
         qDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8vg8nrSBbokWCvOz2GKxHA+4NetSMNLDLIlMKnGWdE=;
        b=tchJtNXIsst/4rbwrwl7+d5grGjr31QcGADb6rAMCFQ3T8mvc8OG20baJGnsifOQvx
         ftz2StgT+9IYNwywDGoJiVn4inh9FhjG8+1kXI6ss6AuoGb6MsyQaNy4Zfo8ax+gpave
         B9XqKP6uVwaen9BmT7HRF7yTEXben05iaoHiy8kc5MkV+sPPRv8s5rvBtfgRmVkeWg5m
         863nl2AzYM5aP7CILgxnuG/XOKWpfiXNZsHwbQ5GgepSYO/sfaVBvc6f9BOkQLGP6dor
         81khzB/tDkx3pbszaq+c5KtP14KRSJUIF2pzzRqTn6vnszf/wmHM87NOSyUkN6xSYomQ
         2xXQ==
X-Gm-Message-State: AOAM530CDXEfb3XmpU2c2F4zeOLWnxky+Uu4nO6nU4YYRSvUNdH4ukk7
        s/QqJMoWIh2PcPJ/e3bw+BSNf/mXgvgXo7VO3xO6Pw==
X-Google-Smtp-Source: ABdhPJwcce3gQgPU5zJRC5HMuJbs9MinMXFfQiG08SzQDzs+LzF/WKC0wOfsLt4XOzEYE7kdtL7mbfEVW6/Q7SzhYFM=
X-Received: by 2002:a19:495d:: with SMTP id l29mr3434206lfj.465.1611697250578;
 Tue, 26 Jan 2021 13:40:50 -0800 (PST)
MIME-Version: 1.0
References: <20210125045631.2345-1-lorenzo.carletti98@gmail.com>
 <20210125045631.2345-2-lorenzo.carletti98@gmail.com> <20210126210837.7mfzkjqsc3aui3fn@skbuf>
In-Reply-To: <20210126210837.7mfzkjqsc3aui3fn@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 26 Jan 2021 22:40:39 +0100
Message-ID: <CACRpkdZnVAR2VTY7UM=qt5yLwA0C5z1LUJ2pW7NgmcY5KS2rzw@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: dsa: rtl8366rb: standardize init jam tables
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:08 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Jan 25, 2021 at 05:56:31AM +0100, Lorenzo Carletti wrote:

> > In the rtl8366rb driver there are some jam tables which contain
> > undocumented values.
> > While trying to understand what these tables actually do,
> > I noticed a discrepancy in how one of those was treated.
>
> And did you manage to find out what these tables actually do?

I think Lorenzo mentioned that he found some settings in there,
I don't know if it was anything substantial though?

I put Lorenzon on track to investigate the driver, we thought
it could be an 8051 CPU so that some of the arrays could
be decoded into 8051 instructions, but so far we didn't get
anywhere with it.

The background was some mumble on the internet on
8051 in RTL8366 switches:
https://news.ycombinator.com/item?id=21040488
https://web.archive.org/web/20190922094616if_/https://twitter.com/whitequark/status/1175701730819895296

> > Most of them were plain u16 arrays, while the ethernet one was
> > an u16 matrix.
> > By looking at the vendor's droplets of source code these tables came from,
> > I found out that they were all originally u16 matrixes.
> >
> > This commit standardizes the jam tables, turning them all into
> > u16 matrixes.
>
> Why? What difference does it make?

I think it's nice that the format is the same on all tables.

Yours,
Linus Walleij
