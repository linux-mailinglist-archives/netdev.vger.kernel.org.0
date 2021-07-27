Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D3B3D7F34
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhG0UZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhG0UZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 16:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2000560FC4;
        Tue, 27 Jul 2021 20:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627417520;
        bh=nHno0VTQJTRoqFedWQI97o8SDCYavOgx2tcuLO2rCms=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FSdTE2QTwhTifQzrRxUnAUzQLHH+20gKFOqBoD+wPx2s8Qton65oE7c6+8V/VeEwO
         SZ9Abrw4I7yuNqfrjrzgkWkouMAWwazIGzXYj3vk178P1kq+OYKmLt3C6crQXxAk9G
         ua7uE/3jOxZPxDq2PKIqmvi5GCk/uoLB5C6Z3iIFIlTmCg0AZNNISPV50I1aUl5vpG
         pSSmx0ngnsSfK9zyHB5YJC/riZlLbLjcOgOiFdCWfnLT2K14UMC86jdcb8xjXCfKw8
         /BkIMjwTmTSv1+cID9/koMkyY6o8aHcHAZHte1IeCPiW5sf4PWVbzJl0zSsM/AtQdD
         6x+CelmyIBpHw==
Received: by mail-ej1-f41.google.com with SMTP id v21so818668ejg.1;
        Tue, 27 Jul 2021 13:25:20 -0700 (PDT)
X-Gm-Message-State: AOAM532MTsYHGvC9vQdwzGRZNHHX5I1jOyYHwXpFIZP9sVVBZzaa9e+u
        FtkXj4Dk95k8wqLLkVX/DkTMZB6KycZ2+UCGhg==
X-Google-Smtp-Source: ABdhPJyw93T01X/3Vp/EzHW3EELHK3Ax39MatcT3IU4mabTDBrIAqpQOaCNaK2mKT6Klo3/sNMni11Smh8+SUOekIZ8=
X-Received: by 2002:a17:907:766c:: with SMTP id kk12mr704023ejc.525.1627417518691;
 Tue, 27 Jul 2021 13:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-3-gerhard@engleder-embedded.com> <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
 <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com>
In-Reply-To: <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 27 Jul 2021 14:25:06 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
Message-ID: <CAL_JsqKq6H471iFoLWRGvNSLpaJmuF+feDFut2p+J725n3U4HA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet controller
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 12:35 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> On Tue, Jul 27, 2021 at 1:35 AM Rob Herring <robh+dt@kernel.org> wrote:
> > > +properties:
> > > +  compatible:
> > > +    oneOf:
> >
> > Don't need oneOf when there is only one entry.
>
> I will fix that.
>
> > > +      - enum:
> > > +        - engleder,tsnep
> >
> > tsnep is pretty generic. Only 1 version ever? Or differences are/will
> > be discoverable by other means.
>
> Differences shall be detected by flags in the registers; e.g., a flag for
> gate control support. Anyway a version may make sense. Can you
> point to a good reference binding with versions? I did not find a
> network controller binding with versions.

Some of the SiFive IP blocks have versions. Version numbers are the
exception though. Ideally they would correspond to some version of
your FPGA image. I just don't want to see 'v1' because that sounds
made up. The above string can mean 'v1' or whatever version you want.
I'm fine if you just add some description here about feature flag
registers.

>
> > > +  reg: true
> >
> > How many? And what is each entry if more than 1.
>
> Only one. I will fix that.
>
> > > +  interrupts: true
> >
> > How many?
>
> Only one. I will fix that.
>
> > > +
> > > +  local-mac-address: true
> > > +  mac-address: true
> > > +  nvmem-cells: true
> >
> > How many?
>
> Is that not inherited from ethernet-controller.yaml?
>   nvmem-cells:
>     maxItems: 1

Ah, right.

> > > +  nvmem-cells-names: true
> >
> > Need to define the names.
>
> Is that not inherited from ethernet-controller.yaml?
>   nvmem-cell-names:
>     const: mac-address

Yes.

Rob
