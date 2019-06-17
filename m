Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C3E494EB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbfFQWL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:11:57 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:35443 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfFQWL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:11:56 -0400
Received: by mail-io1-f44.google.com with SMTP id m24so25071408ioo.2
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JI9qoasZnJALg2v/QCGLXcbGsdLCZircfGCvJONIiR0=;
        b=1kzOjvGmh8hzdVG0S9ZpVR9MRDfTxM5AfNs7kXPafQc/dpqSFXlJNEL6/qJ57ggHKC
         ciucsrFtM6H4JUSARowNNBcXqkZwPsA3kmFDmDk1su70152txqf7J/MzBQaGqLmvmNlU
         dS7clgPG6lTLxsFt+dMPHYLvRMBNr9pfpw3ki5Um9xJN4UPCVpRWIaWpYqmhYN2Xpex7
         ozJvtLHjF5w2NwsLntm71wCMQ+TygnO94+lg3bOkUp9vQZQjd2LVzDHwIb6eR29rXuSb
         1GktHO7qn19RyR0LsD8O5qbGzJzx9myn+zcpiOIQptlfh7gHYrjNnK+S99uslxi43251
         qvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JI9qoasZnJALg2v/QCGLXcbGsdLCZircfGCvJONIiR0=;
        b=d9PL+uT3lIn2amhxdlVK0c4LKOrzNouRBiRCRR6siFql18WL0a6M5iUzdgtusyvKhO
         si1BJwJtUbRL84TegjutHItjb92n10/B3F/iAJuGxB5Tlz1I7js/7j0TUdulNTJ8h5Nf
         WIVqh2Aly/MOqChq2/o1BYXVdpGmPkwORPSN7bFVaikVrqAK4irw7axQ1W/ItNNDxpJR
         spbVdPjU6DSP0eSjt1abQZcoxzhI2WNwiAYpYddOqGDktaedFMvzfQFIh0pHqZGvrty1
         BP3vHEQRphKcj66R5yqXiUUxTd+wLhrnTYO2Txh9227SzyvkR1KdgT4712B4yeMntlmy
         qjYw==
X-Gm-Message-State: APjAAAV5YittXOV9lfFAlsX6rxW7tNncL7Ic2B4AdrBL/3BNCW9EHE/D
        EAh5D36UONBi2jarxm/Eu/hOL0bVMLRLP6q4WY6miQ==
X-Google-Smtp-Source: APXvYqxCC/rY5fcJnA40uAprYSik64pxUAvh8F+Z+3T1uab97ryUujF3VjwWLez1CrUdD4GEBcROgrRX1XVedwZlky0=
X-Received: by 2002:a5e:8209:: with SMTP id l9mr1314821iom.303.1560809515904;
 Mon, 17 Jun 2019 15:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
 <1560522831-23952-2-git-send-email-john.hurley@netronome.com> <dbd77b82-5951-8512-bc9d-e47abd400be3@solarflare.com>
In-Reply-To: <dbd77b82-5951-8512-bc9d-e47abd400be3@solarflare.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Mon, 17 Jun 2019 23:11:45 +0100
Message-ID: <CAK+XE==5JZh9Y1KiT0TE=or+ddu4Tf5mCoEzh=Egw1F_sgNSqQ@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: sched: refactor reinsert action
To:     Edward Cree <ecree@solarflare.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 7:44 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 14/06/2019 15:33, John Hurley wrote:
> > Instead of
> > returning TC_ACT_REINSERT, change the type to the new TC_ACT_CONSUMED
> > which tells the caller that the packet has been stolen by another process
> > and that no consume call is required.
> Possibly a dumb question, but why does this need a new CONSUMED rather
>  than, say, taking an additional ref and returning TC_ACT_STOLEN?
>
> Apart from that, the series lgtm.
>

Thanks for comments, Ed.
The CONSUMED was to replace the REINSERT function but yes, this is
probably not required now.
I can respin

> -Ed
