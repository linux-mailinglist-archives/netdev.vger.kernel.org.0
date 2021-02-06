Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BBC312086
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhBFXoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBFXoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 18:44:07 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA7DC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 15:43:27 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b9so18846829ejy.12
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 15:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ebiXp7HGeS87oJbnqlWGvY6oOwEwX7EI60HYlRmUvHc=;
        b=rm0dtEz3EiVZbIVV4xxCt57IFA89KJobzfDMibl3PsHyeFV9jHZIo7UsaQnBylTRYF
         C/y2SbchkTw95TOZymZBtmVdg4GWZXGi1M+l7jpSzIqxomyonRXFySF3n5qGsktgEo7T
         arR7WKWNPr2oIS47WmiPKooCclF2V/gcKiyFV0V1O2TBIdwXnj+aLn9Yg3dUUH0phIbD
         pN3+Tyj4fSZ+/hXVERRyvO6vBl/41B/qurQM0sVdjg6okn1+Mf7FTHVC1YOKPM3OUkQv
         rIfUTT3EyQkpDWIgzv/detpeBtl5gZpa0iva6wBtEGI1Yr5CWfR4KHh8cxCvNAYFVyan
         Xk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ebiXp7HGeS87oJbnqlWGvY6oOwEwX7EI60HYlRmUvHc=;
        b=bxm1t/gJGxrmHnNMucEFXZzPxGdWrztFyQeXKrm1Y/JzUrxIZGebvFJNVFTFTzL+ZA
         1+kK+VDCacnR/DLChhTQFS+iesG+S/usAslFWr4UhVqQaSUFICDJTXizojtdcafxW0ix
         1EPsBdjRu2kD4ZVjVbdxsKnA8ZJYr1RB78sGNxMVBlRlGCnNpLqvHEGl9jVuc16SYjP9
         NF8ULj6boMGxRIdJR1qL0O6I3ApQmwH21cLriwjybF+dXMPF5VxbWDkhhApjTjz/SRF/
         r7rLLuyY6a8abHSMjJ8R/E7uwlyeaL1lN+G2tjfADS8ljyLQ4R25A+mUN1eZR0JEKOs6
         iW7Q==
X-Gm-Message-State: AOAM5316Cd0uSRTjKPbSh+sKliRSqdZUgYFi1fgp9btX4yW+O+vFMYYi
        ei/V9SAt62IiPEI3SrJZqbUEn6pe5qo=
X-Google-Smtp-Source: ABdhPJyT++8pBuU4yjqweFpj486ECTJ+I1sRVKY79vbU8EuBeoqnip4XS+MF16WshmVoDrOBnYkZtg==
X-Received: by 2002:a17:906:6bc5:: with SMTP id t5mr6317118ejs.253.1612655006104;
        Sat, 06 Feb 2021 15:43:26 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f1sm313222ejt.21.2021.02.06.15.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 15:43:25 -0800 (PST)
Date:   Sun, 7 Feb 2021 01:43:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame
 without HSR tag
Message-ID: <20210206234324.wk676psq3mwslud4@skbuf>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-2-george.mccollister@gmail.com>
 <20210201145943.ajxecwnhsjslr2uf@skbuf>
 <CAFSKS=OR6dXWXdRTmYToH7NAnf6EiXsVbV_CpNkVr-z69vUz-g@mail.gmail.com>
 <20210202003729.oh224wtpqm6bcse3@skbuf>
 <CAFSKS=MhuJtuXGDQHU_5w+AVf9DqdNh=zioJoZOuOYF5Jat-eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFSKS=MhuJtuXGDQHU_5w+AVf9DqdNh=zioJoZOuOYF5Jat-eQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 08:49:25AM -0600, George McCollister wrote:
> > > > Why is it such a big deal if supervision frames have HSR/PRP tag or not?
> > >
> > > Because if the switch does automatic HSR/PRP tag insertion it will end
> > > up in there twice. You simply can't send anything with an HSR/PRP tag
> > > if this is offloaded.
> >
> > When exactly will your hardware push a second HSR tag when the incoming
> > packet already contains one? Obviously for tagged packets coming from
> > the ring it should not do that. It must be treating the CPU port special
> > somehow, but I don't understand how.
>
> From the datasheet I linked before:
> "At input the HSR tag is always removed if the port is in HSR mode. At
> output a HSR tag is added if the output port is in HSR mode."
> I don't see a great description of what happens internally when it's
> forwarding from one redundant port to the other when in HSR (not PRP)
> but perhaps it strips off the tag information, saves it and reapplies
> it as it's going out? The redundant ports are in HSR mode, the CPU
> facing port is not. Anyway I can tell you from using it, it does add a
> second HSR tag if the CPU port sends a frame with one and the frames
> going between the ring redundancy ports are forwarded with their
> single tag.

So if I understand correctly, the CPU port is configured as an interlink
port, which according to the standard can operate in 3 modes:
1) HSR-SAN: the traffic on the interlink is not HSR, not PRP
2) HSR-PRP: the traffic on the interlink is PRP-tagged as “A” or “B”
3) HSR-HSR the traffic on the interlink is HSR-tagged.

What you are saying is equivalent to the CPU port being configured for a
HSR-SAN interlink. If the CPU port was configured as HSR-HSR interlink,
this change would have not been necessary.

However 6.7 Allowed Port Modes of the XRS7000 datasheet you shared says:

| Not every port of XRS is allowed to be configured in every mode, Table
| 25 lists the allowed modes for each port.

That table basically says that while any port can operate as a 'non-HSR,
non-PRP' interlink, only port 3 of the XRS7004 can operate as an HSR
interlink. So it is more practical to you to leave the CPU port as a
normal interlink and leave the switch push the tags.
