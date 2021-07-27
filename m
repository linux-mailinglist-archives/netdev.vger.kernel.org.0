Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD203D7EFB
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhG0USL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhG0USK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 16:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F07360FC0;
        Tue, 27 Jul 2021 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627417090;
        bh=L8MwKcVmUwG3t+BfPG0sncaEzJPE7beNlA8x15HdaLU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wh64jWUtAioVtP4AZkUz8aD7++2Btw0DSr4yITjJoSGXp1OYewM5YXGR8iUJY5efw
         Mr0XdGZo1Mc1tS2dF9BPmjA7o5pF+rsBlmCjo+RsLmF6V0cTZxGMIorVzPSgBY5ptH
         b8ZOeheYumzyfHrJyWGypZpTFosnZeIabf8kWJX/VwwoeA5SWNd42Sy8B2rWL5JyYj
         N031+ZlBg0KZGwLv45VWN09gs8IglWfeXqn7velMw80SlrLy80r3gPTCAoBgBhjW3I
         9VmqizykabQ4n9dii6F4UmjKTJqFWlj1oH4U3PYN6imczCG0ZtSYw6hFrSaPA2JaK7
         y+BJTRXkJ94eg==
Received: by mail-ej1-f51.google.com with SMTP id nb11so768003ejc.4;
        Tue, 27 Jul 2021 13:18:10 -0700 (PDT)
X-Gm-Message-State: AOAM5331qCCBDBhEhiIuaCf5AB39aZNKQFxR9qshd1YsgigZu8X/drPp
        FLyX9h8uUPhpgptevru3ttG7tjzmldA+4LoQtA==
X-Google-Smtp-Source: ABdhPJx1e3h/zk0QDj7sxpvnO3D72Q9RcnkJAA+LQSH0VQapZ9qbAxFml+6Y/GNdgoJjM2rlDKcTBnvET83wBMmVEW4=
X-Received: by 2002:a17:906:af7c:: with SMTP id os28mr23849481ejb.341.1627417089070;
 Tue, 27 Jul 2021 13:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-6-gerhard@engleder-embedded.com> <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
 <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com>
In-Reply-To: <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 27 Jul 2021 14:17:57 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
Message-ID: <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN endpoint
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 2:11 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> On Tue, Jul 27, 2021 at 1:41 AM Rob Herring <robh+dt@kernel.org> wrote:
> > > +       compatible = "engleder,zynqmp-tsnep", "xlnx,zynqmp-zcu104-revC",
> > > +                    "xlnx,zynqmp-zcu104", "xlnx,zynqmp";
> >
> > I don't think this will pass schema validation.
>
> You are right. I did rerun the validation and now I see the error.
>
> > In general, do we need a new top-level compatible for every possible
> > FPGA image? Shouldn't this be an overlay?
>
> All the devices I have dealt with so far had just a single FPGA image.
> There were no dynamic selection of the FPGA image or partial
> reconfiguration of the FPGA. So the FPGA image could be seen as part
> of the schematics. In this case the FPGA image stuff shall be in the
> device tree of the device. For me the question is: Does this combination
> of evaluation boards with its own FPGA image form a new device?
>
> The evaluation platform is based on ZCU104. The difference is not
> only the FPGA image. Also a FMC extension card with Ethernet PHYs is
> needed. So also the physical hardware is different.

Okay, that's enough of a reason for another compatible. You'll have to
update the schema.

> From my point of view it is a separate hardware platform with its own
> device tree. It's purpose is to show two tsnep Ethernet controllers in
> action. So far it worked good for me to see the FPGA image as part of
> the schematics like the list of devices on the SPI bus. No special handling
> just because an FPGA is used, which in the end is not relevant for the
> software because software cannot and need not differentiate between
> normal hardware and FPGA based hardware.
>
> But I also understand the view of just another FPGA image for an existing
> hardware.
>
> My goal is to get all necessary stuff, which is needed to run the evaluation
> platform, into mainline. I must confess, I have not thought about using an
> overlay. Is it right that overlays are not part of the kernel tree?

There's some work in progress on it. We can build and apply overlays
at build time now, but we haven't added any overlays under /arch.

Given the overall h/w is different, it doesn't seem like overlay will
buy you anything here.

Rob
