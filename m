Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927CE3D7DC4
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 20:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhG0SfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 14:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0SfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 14:35:09 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FF8C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 11:35:09 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id l18so17063284ioh.11
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 11:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zrEt6H15num0xNPtPS+QEBLlhe17gtDgPinwM2RusM4=;
        b=vEBMYJRbHqGaFVM+/ZCTnLd6sdm+m7dsPHLkQbmSj8HLn9hwowEy4toZAHJ+KDKcye
         zdnPz0zxVTvTcnEex/8BaAkLDlxMaJnp/1iiPeCqC8wf4rsyz9/hGYJYu/QJNslCaze9
         96aa92AiQwuQCujbO1xA1ht3D45QtoBjHVMlZP/ySA/vhOPJwpQMnk1WgvaQ3S5in/Ja
         lX4xknDWFhthRc0K2lfUAk1fu4/8VASZXLblq0LqZc9mbZ7KMzi8jYev39XmLrEO+Nft
         ZBxIk8dv74acbnn6dGj5MhzFuxigeDi4fdkFZoIZALuJznolI1ejnNhYKqC1jCaaeyVW
         qi+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zrEt6H15num0xNPtPS+QEBLlhe17gtDgPinwM2RusM4=;
        b=kisnrhveloP4xKlTmKQP9fdeoXSjA+O/Dbh5VjFCSn9Q+BImJsolSWMzwKpGNQK4nN
         HXDo00uJVtyMA4+TDEvQiDuF5+c0XyXxL2BqmoA3WDsoZ6k/GdgtIctP6MATFx4l5WE9
         ISnVY1B3hoK+uoNvVlmfZZTCSMeMVwh7wU8+540469MnjP8s2j9kUfACzNpSMlTBUB2w
         zv7/+N3Y7L02KlNctZYq51eI85Zbs4TvyOmq/enLzH8tIDlAKIeu/UnvmOFzDC1kZLs1
         sXIQa9MUJ5MP0d2VTicN3TlXmeedSfFhrY1LYkQIkmqdidJaDhSEAp/qhlq3jzfxYv4R
         vLig==
X-Gm-Message-State: AOAM531Wp3+8ktSJdC0rAPaJJ2BWCogMFYhMIZmImwoYNHA9lwSnsOGT
        iypi5QfXrlvSmN5IfU9V2Zv0++RV9yZpwYbFR88Opg==
X-Google-Smtp-Source: ABdhPJz0P0OXbr/xdFP+81etR+Xbi99dD45tDqsK5EzgIyhIwDE6sI0BpyrZw3uzVWgs+9J8o/gnFwjx7tRsJh/Br90=
X-Received: by 2002:a05:6638:41a7:: with SMTP id az39mr22609350jab.52.1627410908785;
 Tue, 27 Jul 2021 11:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-3-gerhard@engleder-embedded.com> <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
In-Reply-To: <CAL_JsqLe0XScBgCJ+or=QdnnUGp36cyxr17BhKrirbkZ_nrxkA@mail.gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 27 Jul 2021 20:34:57 +0200
Message-ID: <CANr-f5wscRwY1zk4tu2qY_zguLf+8qNcEqp46GzpMka8d-qxjQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet controller
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 1:35 AM Rob Herring <robh+dt@kernel.org> wrote:
> > +properties:
> > +  compatible:
> > +    oneOf:
>
> Don't need oneOf when there is only one entry.

I will fix that.

> > +      - enum:
> > +        - engleder,tsnep
>
> tsnep is pretty generic. Only 1 version ever? Or differences are/will
> be discoverable by other means.

Differences shall be detected by flags in the registers; e.g., a flag for
gate control support. Anyway a version may make sense. Can you
point to a good reference binding with versions? I did not find a
network controller binding with versions.

> > +  reg: true
>
> How many? And what is each entry if more than 1.

Only one. I will fix that.

> > +  interrupts: true
>
> How many?

Only one. I will fix that.

> > +
> > +  local-mac-address: true
> > +  mac-address: true
> > +  nvmem-cells: true
>
> How many?

Is that not inherited from ethernet-controller.yaml?
  nvmem-cells:
    maxItems: 1

> > +  nvmem-cells-names: true
>
> Need to define the names.

Is that not inherited from ethernet-controller.yaml?
  nvmem-cell-names:
    const: mac-address

> > +  phy-connection-type: true
> > +  phy-mode: true
>
> All the modes the generic binding support are supported by this device?

Only GMII and RGMII are supported. I will fix that.

> > +  phy-handle: true
> > +
> > +  '#address-cells':
> > +    description: Number of address cells for the MDIO bus.
>
> No need to re-describe common properties unless you have something
> special to say.
>
> Anyway, put an MDIO bus under an 'mdio' node.
>
> > +    const: 1
> > +
> > +  '#size-cells':
> > +    description: Number of size cells on the MDIO bus.
> > +    const: 0
> > +
> > +patternProperties:
> > +  "^ethernet-phy@[0-9a-f]$":
> > +    type: object
> > +    $ref: ethernet-phy.yaml#
>
> Referencing mdio.yaml will do all this.

I will reference mdio.yaml.
