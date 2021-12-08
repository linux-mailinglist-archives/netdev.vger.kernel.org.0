Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4B546D8B7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbhLHQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhLHQpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:45:07 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F399EC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 08:41:34 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so10113897edb.8
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 08:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iSAh/GfSy61+uPAKJYvyOlahqIHq1QSQQKgMUgUe3M0=;
        b=RcCzvbWglzA7Ua9B3QVx/3ayzD9TC0xEmu1HZV3uWCStn8ki7uRNwbtNaiZyq6k+E2
         N+9olq0trb10CojN2xFV3L8JfECBG05Bw91NGHZ7AzwCk6XmlZoQ9lmPvl3KEcdM4aMY
         44j2Kd8Tx1+4IIYu1woJSVBqhHs3sbDqFFh11Z3UpJ54NW8S7ISZfpcvkaDQKv/c1t8W
         ZXjJTBvW4uam/vysRPafs0r/OvZsfDN9kpc6Qn03zOHmQhxmyVQZEjgO9vZo/jd7cWAs
         487mVkvwAWg2lx/awQo7Pnm+IFiCoXOiEtUfXUApl2SGrhNXE6KKbpMhLxPtVYjAmknP
         URiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iSAh/GfSy61+uPAKJYvyOlahqIHq1QSQQKgMUgUe3M0=;
        b=V0zgD3qfBviEDFlgGhCF5J4AWqClTRXxNAYAGWAcLzBIRkyzTx0xBht/cJVi76iwxH
         MAQQe1zmBnxUyz2VF/OVCNjo5gz+nYDXw0Z4hLKEelxztjBH0Jg0NV4fhZfA/riqBAOz
         64DSNRt7IR1+wyE9IxRLOlPSw8m7l1ssz51AFdtgK6XUGzbJL4J6MLk345KOLp1qOPRt
         rXks3+ttLLbDpXq/lNv/dvJZzDkpNwekMyFpX/UOmqQaLWAAOI0QP+OjU0oBd+1aSDcD
         l5p85NmYrNpauAf9NGA1osvD0Cmln+3PBHHx3s4/X8amXa1f3128jTZ/FOLgx3cFltoK
         m/bQ==
X-Gm-Message-State: AOAM530RqvChQJYxWX71ATTRaPCglG8qp4FzRsgBnt3lVU3ravK9uSd3
        v62Sjn6LRPDN2QlHu5yuxo4=
X-Google-Smtp-Source: ABdhPJz4K98jPXRkCP4A3EEzgCvUAHB5f/QAocY6It8VQResF8fmLNhD57wQfiHkMf9sQYBxzO/h9w==
X-Received: by 2002:a17:907:16ac:: with SMTP id hc44mr8360465ejc.363.1638981693152;
        Wed, 08 Dec 2021 08:41:33 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id jy28sm1676728ejc.118.2021.12.08.08.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:41:32 -0800 (PST)
Date:   Wed, 8 Dec 2021 18:41:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208164131.fy2h652sgyvhm7jx@skbuf>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
 <20211207190730.3076-2-holger.brunck@hitachienergy.com>
 <20211207202733.56a0cf15@thinkpad>
 <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
 <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208171720.6a297011@thinkpad>
 <20211208172104.75e32a6b@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211208172104.75e32a6b@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 05:21:04PM +0100, Marek Behún wrote:
> Hello Vladimir,
> > > > but the mv88e6xxx driver also drives switches that allow changing serdes
> > > > modes. There does not need be dedicated TX amplitude register for each serdes
> > > > mode, the point is that we may want to declare different amplitudes for
> > > > different modes.
> > > >
> > > > So the question is: if we go with your binding proposal for the whole mv88e6xxx
> > > > driver, and in the future someone will want to declare different amplitudes for
> > > > different modes on another model, would he need to deprecate your binding or
> > > > would it be easy to extend?
> > > >
> > >
> > > ok I see. So if I follow your proposal in my case it would be something like:
> > > serdes-sgmii-tx-amplitude-millivolt to start with ?
> > >
> > > I can do that. Andrew what do you think?
> >
> > Or maybe two properties:
> >   serdes-tx-amplitude-millivolt = <700 1000 1100>;
> >   serdes-tx-amplitude-modes = "sgmii", "2500base-x", "10gbase-r";
> > ?
> >
> > If
> >   serdes-tx-amplitude-modes
> > is omitted, then
> >   serdes-tx-amplitude-millivolt
> > should only contain one value, and this is used for all serdes modes.
> >
> > This would be compatible with your change. You only need to define the
> > bidning for now, your code can stay the same - you don't need to add
> > support for multiple values or for the second property now, it can be
> > done later when needed. But the binding should be defined to support
> > those different modes.
>
> Vladimir, can you send your thoughts about this proposal? We are trying
> to propose binding for defining serdes TX amplitude.

I don't have any specific concern here. It sounds reasonable for
different data rates to require different transmitter configurations.
Having separate "serdes-tx-amplitude-millivolt" and "serdes-tx-amplitude-modes"
properties sounds okay, although I think a prefix with "-names" at the
end is more canonical ("pinctrl-names", "clock-names", "reg-names" etc),
so maybe "serdes-tx-amplitude-millivolt-names"?
Maybe we could name the first element "default", and just the others
would be named after a phy-mode. This way, if a specific TX amplitude is
found in the device tree for the currently operating PHY mode, it can be
used, otherwise the default (first) amplitude can be used.
