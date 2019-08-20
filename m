Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0007C96B03
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbfHTVCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:02:35 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43343 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTVCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 17:02:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id h13so286106edq.10
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 14:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M9VFoVMqZtnhC9z2T6EYvYsOpEZQ1eoAjtitcFP/VJw=;
        b=LnlI6xwG3VPaSNk8jCZVDiso3BkFa2iqWa+Vhv+rpt5gnat/T9fu4leWDLWGq3s5e9
         DJ9eiuTO0+++B7SLyc/gIXn0PsMJi5Y8XkwfOc+JJoq45b6CJmHeiAfrPy6JjjBRdqh8
         ivsmoEDMaUK5j+drpdDUHw+zpuVo34QvzMU1QJt3ni9pwHoTJIYxoPTXAcCwCivjkewe
         LNOD7Ee4/JGcnn0N6O7VNoKELd33lKM/cKk13KPERs6fggk+D0t2Bp1D21HYnVQVOere
         XTSwu/qaSahXxLdMNRUHIqbvjMr7d9/WrIVqMVjk938lJpI7GaDqNHhyTvtyq7g+rKY2
         c/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M9VFoVMqZtnhC9z2T6EYvYsOpEZQ1eoAjtitcFP/VJw=;
        b=tqwcAS2wOpaLkFcgc/QmVZfk6431HxwyTVry3nb6rZKtyVeyepAEcmuQiBDPFKvabu
         ITJ01F3OVl1TvzdhPktcuDFK2k1MAeYXScNQSVeO0ie8UZx0nw75g71matKrF4tBzSTn
         JVhZATdgLTdycLJLB5agUSnOMYGjtG+UPxVkTJalpBtf+IlTB3N96mGxts+5CEXuIG2J
         nTp8VRs812xo1Z69T7brGFTyfBRm4PfEka1fdbCS9J02ka1eo1ycqgfoM/G3mrGwjmT0
         f4mp1mslIVsyg69hHtPUU8T9pFP0KqqN9e4V1zV2A7z0NIRWNYaQyzN0abDkkg3U2tLl
         Cf6g==
X-Gm-Message-State: APjAAAVDUXAhujtKAQ7RjP+lBzodtdS6jY1ikueTNY1BImBlPx+qDenG
        95RkPwpD1dpQR8eewLoMT3Vk7z6Hxj20FD47VjQ=
X-Google-Smtp-Source: APXvYqzFv/TvAuHMwRxtrpie7xKl9GcU4hzcxCDW36J9qbeiWxq8LoUbTMDiYbNG/FzZzCXW32OOME1d1ZL2Ht3iRi4=
X-Received: by 2002:a17:906:4683:: with SMTP id a3mr27399137ejr.47.1566334953422;
 Tue, 20 Aug 2019 14:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain> <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain> <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
 <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com> <20190820165813.GB8523@t480s.localdomain>
In-Reply-To: <20190820165813.GB8523@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 21 Aug 2019 00:02:22 +0300
Message-ID: <CA+h21hrgUxKXmYuzdCPd-GqVyzNnjPAmf-Q29=7=gFJyAfY_gw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 at 23:58, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> On Tue, 20 Aug 2019 23:40:34 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > I don't need this patch. I'm not sure what my thought process was at
> > the time I added it to the patchset.
> > I'm still interested in getting rid of the vlan bitmap through other
> > means (picking up your old changeset). Could you take a look at my
> > questions in that thread? I'm not sure I understand what the user
> > interaction is supposed to look like for configuring CPU/DSA ports.
>
> What do you mean by getting rid of the vlan bitmap? What do you need exactly?

It would be nice to configure the VLAN attributes of the CPU port in
another way than the implicit way it is done currently. I don't have a
specific use case right now.
