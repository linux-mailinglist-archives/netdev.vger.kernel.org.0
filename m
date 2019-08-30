Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7773A34A5
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfH3KLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:11:24 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39592 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfH3KLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 06:11:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id u6so1519223edq.6
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 03:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DNyj3wR0fqYAZJhHY1oTG3r8qz8BZj7YtG+QAaT+Y9k=;
        b=bjr6yB5J60WcAaxfslfqAD7q9yknDVmDVsdUo6DtL6Alxs/Y7kQJkJWa/5LJ6PFXIU
         /WCMbqCwjgbMGnYK1yqwB3h5Q1pkFQiYWv/1/hBi8jEcfqCth4mD3M4InrhC8AOZ6Gu0
         AdZ1+2LALUJLkDuYCOxUhzru29jE+45o8UDeh444qCLepPKQ2Yf88eHl9QUso804vB3K
         QvZtoSxIld+JM9ikqxf+YRDcsqP5tWIGFj3XqAmV16cxOOBJvvE1YyE1uAJVCahoZe5k
         VWLcmtuxc3UpOL3IV+NR5clkSY8mmlMcrPFpDeB5e6HNpEcOjbo2pQM5cN8+noUtsQ3H
         Z1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DNyj3wR0fqYAZJhHY1oTG3r8qz8BZj7YtG+QAaT+Y9k=;
        b=CAGa0tExwos3HrC8Bju8n2utHz1PpXrKQcChZi+VPR4BIhFZp3VcUARvUxDS+bPMmQ
         eIsjw8aFiEVBY91FTY0yuXHRkB4Vni8FjSDG9MfkkgSvHhjNuo5n5DbIYRbQa4Ypye9A
         mXxYu79SZpXiwjdfMBdENrh1+JDXFeAyRjuK7bfjy8kh7+ENB0hPFo+svnvRLcW0Kb49
         YjcdwyJyakiNRgeH57EY4NfCoDaLlTbVKN5+i4UobOOi2YlpdSOHBSC0JzlP+k17yuFJ
         9TQesF5TnjP7so3FZcubiC6FXMGeYNtQmDVtYz1tofvEG/hN7YrmBCeg751BEAsxuxNU
         wr7w==
X-Gm-Message-State: APjAAAUwZ1OrNtf/DiMCyzhQrDl7QqWZtSl+ntmAywSCBxJeFlhS3bv3
        vTz07n6YgYnvMWvhX9X90cvHJWIyBs/DFLavTmE=
X-Google-Smtp-Source: APXvYqw5oj4y4dhs7YlPqPzV/uDzbIumanfbouxoRTaBkPWVpHJShKnuJQDXJJN8tJdcuRMFw22BMYBzQ/OHT6rKVVM=
X-Received: by 2002:a17:906:9607:: with SMTP id s7mr12294865ejx.300.1567159883039;
 Fri, 30 Aug 2019 03:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190830004635.24863-1-olteanv@gmail.com> <20190829182132.43001706@cakuba.netronome.com>
In-Reply-To: <20190829182132.43001706@cakuba.netronome.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 30 Aug 2019 13:11:11 +0300
Message-ID: <CA+h21hr==OStFfgaswzU7HtFg_bHZPoZD5JTQD+-e4jWwZYWHQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next 00/15] tc-taprio offload for SJA1105 DSA
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        xiyou.wangcong@gmail.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, 30 Aug 2019 at 04:21, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 30 Aug 2019 03:46:20 +0300, Vladimir Oltean wrote:
> > - Configuring the switch over SPI cannot apparently be done from this
> >   ndo_setup_tc callback because it runs in atomic context. I also have
> >   some downstream patches to offload tc clsact matchall with mirred
> >   action, but in that case it looks like the atomic context restriction
> >   does not apply.
>
> This sounds really surprising ndo_setup_tc should always be allowed to
> sleep. Can the taprio limitation be lifted somehow?

I need to get more familiar with the taprio internal data structures.
I think you're suggesting to get those updated to a consistent state
while under spin_lock_bh(qdisc_lock(sch)), then call ndo_setup_tc from
outside that critical section?

Also, I just noticed that I introduced a bug in taprio_disable_offload
with my reference counting addition. The qdisc can't just pass stack
memory to the driver, now that it's allowing it to keep it. So
definitely the patch needs more refactoring.

Thanks,
-Vladimir
