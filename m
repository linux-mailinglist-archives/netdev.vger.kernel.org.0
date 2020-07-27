Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDB622ED54
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgG0Nab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgG0Nab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:30:31 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B80C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:30:30 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id b25so17236337ljp.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2UpUNTF5hL6iwvWNovFcbDytHNkGPF2ZuMPRe8hLRkA=;
        b=XJaWkpAvg0BvofKLmI+YcYKAbvN3nbrFpF5kjH80k7eni3RL82fTY5P1J2LwbwVFko
         QoV2qgx3Jf8mj1rsvx7OFlMJaPvmOhOWw1t31C9ir1iSACyYVn9aBMB0cqqQQfStnhSe
         VeQR1AWdfa63oxDb9sktThEgi57E7aFQEwmrQHktd6rdM4aPP1FPjZ7uj7VCUFYHG3aC
         yHveXkJiU7Ypsw0Ck9ggSiiDhx+K4h+PwnsJIfkIr1eviIwhjLKfFeNzNRO47az1AOR2
         dUOcHPHHmFTUWkl2rPd7DCOiElqkW9QIxZYMlOfzp9MBeslm0j2LJ4TcIZNUb/WbypjP
         aUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2UpUNTF5hL6iwvWNovFcbDytHNkGPF2ZuMPRe8hLRkA=;
        b=kp4wiqy1Y725dFgLxpKuedUP2+Xo8CdEeBDBgebMFVFnty1hJF40kbHjAjaxbKrV8t
         3N8AtCZhfZAvrf1iRMhHbnnVzNWWjgiV1WA1am8JxlY7ZcokjAWCwQrayTnxU3Ecr31m
         Myaou79zz2TFDnbiMrOORJp4785Cnwq1y4T8ZtEYMF5Nz1Pw8rj1Tpd+Bnj1aAdFGGH7
         qKpT7ikGF7SKFuKVWr03HxOmSwzq1si+QAE9ajTQpofld5hs21vKq2YALGZqI/JVmsKp
         05VX3dVrnKUNk0R2NbbiuiVrMP4rtCClJ6kB9PBb7YxdKPF+/WX51XaNaBauc7iUe7uZ
         ZDfw==
X-Gm-Message-State: AOAM532XJ12+6RW/C3DilzF5d1zwH71MK3p9etiCTkoPL/Sbe7Zwb1qt
        D4iOe6W+FikFT002FlL//pmM73xoDKAndOnyWfY=
X-Google-Smtp-Source: ABdhPJx8mAyMULLxTYp1EJm0ij++i3QMlAld5CB5HvGMEJH5TGyMp3RTPc0a9/7CnGowk3LxmAv3zQhafQe83eF+psI=
X-Received: by 2002:a2e:9449:: with SMTP id o9mr1336320ljh.403.1595856629466;
 Mon, 27 Jul 2020 06:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com> <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch> <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
 <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
 <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com> <20200727120545.GN1661457@lunn.ch>
In-Reply-To: <20200727120545.GN1661457@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 27 Jul 2020 06:30:17 -0700
Message-ID: <CAFXsbZpk35Zb7kG=sxAODzpHQkwMS=230ej9v8h72O3yPb2OqQ@mail.gmail.com>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I just updated the phy-mode with my board from rgmii to rgmii-id and
> > everything started working fine with net-next again:
>
> Hi Chris
>
> Is this a mainline supported board? Do you plan to submit a patch?
>
Yes, my board is in mainline so I plan on submitting a patch.

> Laurent, does the change also work for your board? This is another one
> of those cases were a bug in the PHY driver, not respecting the
> phy-mode, has masked a bug in the device tree, using the wrong
> phy-mode. We had the same issue with the Atheros PHY a while back.
>
>    Andrew
