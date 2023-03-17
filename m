Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0006BE8C8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCQMG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQMG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:06:56 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6C8618D;
        Fri, 17 Mar 2023 05:06:55 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-54195ef155aso89529227b3.9;
        Fri, 17 Mar 2023 05:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679054815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bccudwjWFdn0cAhrMBEmTFGFFpcmKU2pFnJ0oUGJTE=;
        b=FOWEtV5IyzFZGAVAClxPx0L1hTrVN52vcBg6EgqXlAe6ltcHCMd8vJBu+kJT+xWrv5
         ASKba3BbrghDbZWd2HUVr7gOoKc4bES739sfI10X7V1/MxDTPywNxbOJHdgC7fC2+jv+
         gHrdpcTX4Y7B0kD1QnWQHKPphaCa5YuukZ+MVdcVz69i2gnAXtKAic+Twfl8Aycl0uoV
         C7amQnaPuWE1Je7cdf8e7k66T2NT7KI6Ao2jcDMIbIUZ/FSiHl7S2x4p1x/vh/rItAoK
         6xw0Bact4JJL+xTkZOnFUhwBq5ItnraODROtXi75sNJOHf7IIfkGdo2IgVGTd+sPjhn7
         YooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679054815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bccudwjWFdn0cAhrMBEmTFGFFpcmKU2pFnJ0oUGJTE=;
        b=B4eAsaFZtmkfm/hGW1ukpq31yD7PBqW7WR2Hnd9MFxy9pxNiXUwp6IPNoMhsKq9S3z
         cCxHV8I+NvdV4Ag3b2YRw+gfWRQ+fa13XtE85+uHsT+lHSHd3FpMRe0TyITMa2/uvjvS
         V/nmDYWbA7LFFomLLlR+lyXaP9DjAeyVTYGcpQHY6Sxcd686Y91hYdsr5s/A9u3sVYiU
         SyBMzEt+2pUdZZRU3Olmo4vXIMuZUzA2MN1GDfUbYP7uvhdwBeUkrWdBL3YTAAhk11Ko
         QGocuXZG4XBIYiix8aHkYhGQt6lERlKbv8WXEPGgW16N4XtCuxBatORAfO3cIv2oz7pU
         v4GA==
X-Gm-Message-State: AO0yUKXWANfEwpXSFi0OAVxLOP+h90vF4bRewU1Wvyqtcg3/kDONEHGO
        p/XHb1GVQx7GX+2ytrglnQOr0zbdHY+Vx2W0tI4=
X-Google-Smtp-Source: AK7set+NxKoYSaf3j+38d1PSQKY8glPC4ERwMS/onUoKCSK2/P9pmCXcq8q79v8tat5fJ5JRNcJL8hYtVj+3ZlKAejE=
X-Received: by 2002:a81:ed06:0:b0:540:e6c5:5118 with SMTP id
 k6-20020a81ed06000000b00540e6c55118mr4711051ywm.2.1679054814642; Fri, 17 Mar
 2023 05:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf>
In-Reply-To: <20230317115115.s32r52rz3svuj4ed@skbuf>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 13:06:43 +0100
Message-ID: <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

El vie, 17 mar 2023 a las 12:51, Vladimir Oltean (<olteanv@gmail.com>) escr=
ibi=C3=B3:
>
> On Fri, Mar 17, 2023 at 12:34:26PM +0100, =C3=81lvaro Fern=C3=A1ndez Roja=
s wrote:
> > b53 MMAP devices have a MDIO Mux bus controller that must be registered=
 after
> > properly initializing the switch. If the MDIO Mux controller is registe=
red
> > from a separate driver and the device has an external switch present, i=
t will
> > cause a race condition which will hang the device.
>
> Could you describe the race in more details? Why does it hang the device?

I didn't perform a full analysis on the problem, but what I think is
going on is that both b53 switches are probed and both of them fail
due to the ethernet device not being probed yet.
At some point, the internal switch is reset and not fully configured
and the external switch is probed again, but since the internal switch
isn't ready, the MDIO accesses for the external switch fail due to the
internal switch not being ready and this hangs the device because the
access to the external switch is done through the same registers from
the internal switch.

But maybe Florian or Jonas can give some more details about the issue...

--
=C3=81lvaro
