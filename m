Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D76E645C18
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLGOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLGOJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:09:08 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD55101F;
        Wed,  7 Dec 2022 06:09:07 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vv4so14306272ejc.2;
        Wed, 07 Dec 2022 06:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=thread-index:content-language:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HfRbWXj1ryZ5GigKdlnSpxHeKcoIXzKhe5JQwEmq1f8=;
        b=WHXdNthSpVMYh8TQeOUuH5dQ6K2I04nxBLe8eERBlRWZkH4jajaNfBC0xcirw+9zXc
         CzRsbbjgCTnKewSdaeR4Q8eIh66aNHe6uOcVN1E+QQlKshfcLwooa98jI01bExdaEJCh
         QBsci2ey5uTCe2L4RFyUY1Nxzk7MYoGJnP0Q+HKqs5Y8vMbX+zU+YiX6ySKpK4odMiD7
         BS3aUnVW4pjXvvI7H7uHZ552LImRc5bci8nhyJz4QrMQJYjO71AptlKHBpWzwoNtmwDx
         4mFe41gdZgdKn+sksY0zTJsXMoVL10ffFKOTTauBEcCQEDI55eHiMwbVRDJV+92d7REk
         77ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=thread-index:content-language:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HfRbWXj1ryZ5GigKdlnSpxHeKcoIXzKhe5JQwEmq1f8=;
        b=0DiTuUaVmJMYVnzOIAodZ4ooYk1y2Wde1F80oE+iPC5rjX0qoab5SO5REEi9SHVUma
         wv0xG0jKJ8f1KmMFeOUVUjsfiVrkfVNes3ih2H4Kqg0FoZ1/oi5zBbKu1no2gKBjj+vW
         LIphI1xkUbvCW3YQG80hK0uhLOgbIQahTMYl1WliwkRZ+LVY8zrQ2UDUnc7UeJS9s1Yy
         DE+iiuLj8AuUl2CW7frn3fWeqwdnxdbR9KiLvpoH8zX/bwfCzUM7ikXViL5q/1ErD3Xl
         6tHJ95ssup1HcfRV2zCCUSVLqyyDsLK2Iq2Haj/rp1rTvW0+l4NqXgMo5xZEDIrADlPu
         G8XA==
X-Gm-Message-State: ANoB5pkMEINEMAP/toRDpyDI/v7+qOo2S80fm9gwy22GRz6c44Oqoyxm
        izI5FIN9CCzgmSHOvd4v8q0=
X-Google-Smtp-Source: AA0mqf7ZnHqgf3A3Z9YTz+W3oqPd9lBAUCzC6xkNs7SctMaeg0v9SYT3FuDRMeLl+p9+puQm5h6pJw==
X-Received: by 2002:a17:906:22d6:b0:7c0:9e25:8908 with SMTP id q22-20020a17090622d600b007c09e258908mr27501905eja.673.1670422145680;
        Wed, 07 Dec 2022 06:09:05 -0800 (PST)
Received: from NVBTQK6D3 (83.8.188.9.ipv4.supernova.orange.pl. [83.8.188.9])
        by smtp.gmail.com with ESMTPSA id du1-20020a17090772c100b00772061034dbsm8580812ejc.182.2022.12.07.06.09.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Dec 2022 06:09:05 -0800 (PST)
From:   <netdev.dump@gmail.com>
To:     "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Jiri Pirko'" <jiri@resnulli.us>
Cc:     "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        "'Vadim Fedorenko'" <vfedorenko@novek.ru>,
        "'Jonathan Lemon'" <jonathan.lemon@gmail.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
References: <20221129213724.10119-1-vfedorenko@novek.ru>        <Y4dNV14g7dzIQ3x7@nanopsycho>        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>        <Y4oj1q3VtcQdzeb3@nanopsycho> <20221206184740.28cb7627@kernel.org>
In-Reply-To: <20221206184740.28cb7627@kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Date:   Wed, 7 Dec 2022 15:09:03 +0100
Message-ID: <10bb01d90a45$77189060$6549b120$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQGuvSISvoht30pwfXCmDPUNHV3PZAJbzGJCAQIu/1AB4Mb46wHXujcVrn5LKlA=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 7, 2022 3:48 AM
> Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
> 
> On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:
> > >But this is only doable with assumption, that the board is internally
capable
> > >of such internal board level communication, which in case of separated
> > >firmwares handling multiple dplls might not be the case, or it would
require
> > >to have some other sw component feel that gap.
> >
> > Yep, you have the knowledge of sharing inside the driver, so you should
> > do it there. For multiple instances, use in-driver notifier for example.
> 
> No, complexity in the drivers is not a good idea. The core should cover
> the complexity and let the drivers be simple.

But how does Driver A know where to connect its pin to? It makes sense to
share 
pins between the DPLLs exposed by a single driver, but not really outside of
it.
And that can be done simply by putting the pin ptr from the DPLLA into the
pin
list of DPLLB.

If we want the kitchen-and-sink solution, we need to think about corner
cases.
Which pin should the API give to the userspace app - original, or
muxed/parent?
How would a teardown look like - if Driver A registered DPLLA with Pin1 and
Driver B added the muxed pin then how should Driver A properly
release its pins? Should it just send a message to driver B and trust that
it
will receive it in time before we tear everything apart?

There are many problems with that approach, and the submitted patch is not
explaining any of them. E.g. it contains the dpll_muxed_pin_register but no
free 
counterpart + no flows.

If we want to get shared pins, we need a good example of how this mechanism
can be used.

> 
> > >For complex boards with multiple dplls/sync channels, multiple ports,
> > >multiple firmware instances, it seems to be complicated to share a pin
if
> > >each driver would have own copy and should notify all the other about
> changes.
> > >
> > >To summarize, that is certainly true, shared pins idea complicates
stuff
> > >inside of dpll subsystem.
> > >But at the same time it removes complexity from all the drivers which
would
> use
> >
> > There are currently 3 drivers for dpll I know of. This in ptp_ocp and
> > mlx5 there is no concept of sharing pins. You you are talking about a
> > single driver.
> >
> > What I'm trying to say is, looking at the code, the pin sharing,
> > references and locking makes things uncomfortably complex. You are so
> > far the only driver to need this, do it internally. If in the future
> > other driver appears, this code would be eventually pushed into dpll
> > core. No impact on UAPI from what I see. Please keep things as simple as
> > possible.
> 
> But the pin is shared for one driver. Who cares if it's not shared in
> another. The user space must be able to reason about the constraints.
> 
> You are suggesting drivers to magically flip state in core objects
> because of some hidden dependencies?!
> 

If we want to go outside the device, we'd need some universal language
to describe external connections - such as the devicetree. I don't see how
we can reliably implement inter-driver dependency otherwise.

I think this would be better served in the userspace with a board-specific
config file. Especially since the pins can be externally connected anyway.

