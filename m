Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048FF485DC6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344042AbiAFA7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344227AbiAFA51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:57:27 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC31EC034004
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 16:57:26 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id p7so1610341ljj.1
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 16:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KXcMivwuU/LaEJGKXpNGyyGHpK/6F76dsLXHN6GKDsU=;
        b=cXk34JlgBvosSIiTXqu5cXW8zYRNhrNEMzA2f8j5SvcKmjQVd6zAogjX2HWVgApV37
         jslMDl+OgK4NrP4s5xe+Z+25gkNJhGcOhzkWqRyEnkHTN+UqC8odv7cZFoHhLht1XIGP
         1CqSrSivBIg4w8t0qPkcZB9s2Fk9D1JhDPbN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KXcMivwuU/LaEJGKXpNGyyGHpK/6F76dsLXHN6GKDsU=;
        b=vbF2MxCVDkeJ4FngjqJhxuOqyDMugH5aZS8S98UwosqJsPrAfY5gXMAYJs+2DHySAz
         2O2nP6GH4MXvu2NpJB3kimCSUTRyJwZuvp2O5M9VAJmX+j6rSFU+czy/7X4RuWfk2sln
         FowX4rmBtRx8las581nggcrp57a5iofSCxnVzuOWvnjDrw3RiLjVeqi45x1U5jTXGPDR
         zf/pMsGOVGOqf3j9FKUfelC6nGg9uv5TeVIJN3xzqe10vWORIY8Gm1r4P27XgtXocG0f
         o+mcKnWByt2p5mn1jRDCVH009ypsDB5qjfRN4cxxF/HyyWqs5Pd9MYETXfcOqLIxAZfH
         ynlA==
X-Gm-Message-State: AOAM530rmfgzmFMbNsGN5Bpz9f0fhRN8F6dfMtZMXZ5EEpV328Cev+C6
        DhLwtW6qp92RKIq/7fgJerwHvrZgzBcPhidZnLM8DcXEsbE=
X-Google-Smtp-Source: ABdhPJzz0N0ekIa23xQ/64C7oj09PO64tYPmW/41zr9bDvnE+bNAg3bkNE/SSNTbEezBF7bEUmRJh6buCbfZr+BQIb8=
X-Received: by 2002:a2e:8190:: with SMTP id e16mr47395066ljg.111.1641430645267;
 Wed, 05 Jan 2022 16:57:25 -0800 (PST)
MIME-Version: 1.0
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-3-dmichail@fungible.com> <20220104180959.1291af97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOkoqZnTv_xc6oB13jdTEK65wbYzyOO1kigmMv7KsJug58bBpA@mail.gmail.com>
 <CAOkoqZmom=Yqxq7FkF=3oBrtd+0BenZZMES3nvUxf2b3CCiyfg@mail.gmail.com> <20220105093258.0b7ac0ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220105093258.0b7ac0ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 5 Jan 2022 16:57:11 -0800
Message-ID: <CAOkoqZmWeNRyEP2HvN6=ZOyNhXroZ+eYSNAmjFN0gPjKAEw0ow@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/8] net/fungible: Add service module for
 Fungible drivers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 9:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 4 Jan 2022 22:12:35 -0800 Dimitris Michailidis wrote:
> > On Tue, Jan 4, 2022 at 8:49 PM Dimitris Michailidis
> > > On Tue, Jan 4, 2022 at 6:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > CHECK: Unnecessary parentheses around 'fdev->admin_q->rq_depth > 0'
> > > > #630: FILE: drivers/net/ethernet/fungible/funcore/fun_dev.c:584:
> > > > +       if (cq_count < 2 || sq_count < 2 + (fdev->admin_q->rq_depth > 0))
> > >
> > > I saw this one but checkpatch misunderstands this expression.
> > > There are different equivalent expressions that wouldn't have them
> > > but this one needs them.
> >
> > What I wrote is probably unclear. By 'them' I meant the parentheses.
>
> I see, perhaps it's better written as:
>
>         if (cq_count < 2 || sq_count < 2 + !!fdev->admin_q->rq_depth)

That's the "different equivalent expression" I alluded to. I won't
call it better
but I'll appease checkpatch.
