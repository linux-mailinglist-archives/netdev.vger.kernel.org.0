Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E376DF793
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjDLNpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjDLNpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:45:10 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9974EF2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:44:49 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1C7E24000B;
        Wed, 12 Apr 2023 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681307088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T3AcBFyiM71YHiZc/PSue8ns55Bi0S/nYikR3IkBaQw=;
        b=XfpDDJgQqdYmfuOpFhrCYkNzxDNmqqTstG7+7eTTvQu2yc47kxon9CWQhqnP9RXGfE7t/B
        +6WDMdTd9/cpMPHpgnUralGoFnGGtgRHxrQYcu6Q7MVoNWHPvwmtRJBfjyjSolmQTnSlLR
        9lGweGg/WWr5g8SeG8Dux9xmNCFk9QeYwUW0iZ8HpcdJp+OngOvKpgygyjvJ2uejaErGXZ
        K/ShtdBdVlZ8nntvIDeyKjceHR2kJ9EStbsyMD6TbHu8UTVqdqN6Upn6eLioBnj64Bq1AH
        YL4YEL9TC+ky2CHdCaf/sVXZmGCAuxEzMODHzaabgNtGqNTM357IJ2TTr6nMfQ==
Date:   Wed, 12 Apr 2023 15:44:46 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add
 timestamp preferred choice property
Message-ID: <20230412154446.23bf09cf@kmaincent-XPS-13-7390>
In-Reply-To: <20230412131421.3xeeahzp6dj46jit@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-4-kory.maincent@bootlin.com>
        <20230412131421.3xeeahzp6dj46jit@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 16:14:21 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> > +  preferred-timestamp:
> > +    enum:
> > +      - phy
> > +      - mac
> > +    description:
> > +      Specifies the preferred hardware timestamp layer.
> > +
> >    pses:
> >      $ref: /schemas/types.yaml#/definitions/phandle-array
> >      maxItems: 1
> > -- 
> > 2.25.1
> >  
> 
> Do we need this device tree functionality?

I would say so. Expected as I wrote the patch. ;)

My point was that the new behavior to MAC as default timestamping does not fit
all the case, especially when a board is designed with PHY like the TI PHYTER
which is a far better timestamping choice (according to Richard). The user
doesn't need to know this, he wants to have the better time stamp selected by
default without any investigation. That's why having devicetree property for
that could be useful. 
