Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935686E133F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjDMRNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDMRM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:12:59 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7B061BE
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:12:57 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1842e8a8825so18689818fac.13
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681405977; x=1683997977;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LSXwkXBchEWpt1wH2gWLxy2J6syLDyFSqFiB87bgTpo=;
        b=jEmtFVkUS3Ob3wdx5Jrd1VDyz8/zN9P1pb+U/syVnZMxt3VAyIcBlrMSaWOo5N2XTh
         9BphMJwTvf4Jw0q2Do8IR+8Mkskrq1hhUJev4swSH1fHyZW1eSgU2fOZ/NxITwM1p3mR
         2hqKOQ/DA3hX90PiumR0wh90Eb6F5hZzbkvq45dG/aN4DjLrtHADmGTlGfzBmWf16QMR
         2cWcZMHA6VAkY4ZwxN06j8ZZ8qf1+wK7IxGC2IaWDYmpd0AqeojYXSS1iyR+Xiicvlfi
         GbBQ4RR2o9CtasPVMsT8l89a0+cMnIx72nkLVUJGAl6teGrRgxJUub9h3BGXFThu7XK0
         o2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681405977; x=1683997977;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSXwkXBchEWpt1wH2gWLxy2J6syLDyFSqFiB87bgTpo=;
        b=Wpf4lqiUSkN/1qkvhpwwGusxdNCA6NnT/l0nkcvB2b1TUgbMFK8joOO2Ez8hCr2rQg
         LFg7MkxX62R+FGKz/U2KmhLPCLQMLiRtNxZNhS5gTFRuy35mchTosWz602MN4O0mUiNB
         PIXUTw4MJtaj6DIzAYs+F5sAUGY8WgfXmx2OCW0J6s5yFt37GNvqvk/SDzgAtt3hiPWV
         /alBvNsC88/LnCEaZx1B8kKmC7AsZMbDWd6zA52mrfljMlwfJzHxb7KP0CqBA2N9Af5K
         A0cIQ2UBSlN1LB4r+QzDrxKD9DgVrgABZgNhkfswlwrvIYzN7pqSsREoERsWYoGBWXT+
         1CgA==
X-Gm-Message-State: AAQBX9eaIDA4uM1PtSg2o2wq3Y1+R7YG5P+U1m+V4TlLIVQMsBj6YrH9
        ak86FfAJMtfdURy6wtloQocOqEz9BgjmtbjYMUULTg==
X-Google-Smtp-Source: AKy350Z6CgGBT8geQanGD2h8Z3itr4+w1XNFvcel+aEVGIuDu05Ea+ygaFlkoZh6baRZP7YH+OMYmsLQQRmFfuvLZvU=
X-Received: by 2002:a05:6870:40d3:b0:187:88f8:e9b5 with SMTP id
 l19-20020a05687040d300b0018788f8e9b5mr1581575oal.6.1681405976861; Thu, 13 Apr
 2023 10:12:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230412114402.1119956-1-slark_xiao@163.com> <CAMZdPi9gHzPaKcwoRR8-gQtiSxQupL=QickXqNE2owVs-nOrxg@mail.gmail.com>
 <5372bdf6.533d.1877981651f.Coremail.slark_xiao@163.com>
In-Reply-To: <5372bdf6.533d.1877981651f.Coremail.slark_xiao@163.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 13 Apr 2023 19:12:20 +0200
Message-ID: <CAMZdPi98JvDdOAS9Ft6udkxZTMW57yQ4mqXMTsa1ySc4UZYqvQ@mail.gmail.com>
Subject: Re: Re: [PATCH net] wwan: core: add print for wwan port attach/disconnect
To:     Slark Xiao <slark_xiao@163.com>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 at 09:26, Slark Xiao <slark_xiao@163.com> wrote:
>
> At 2023-04-13 15:07:21, "Loic Poulain" <loic.poulain@linaro.org> wrote:
> >On Wed, 12 Apr 2023 at 13:45, Slark Xiao <slark_xiao@163.com> wrote:
> >>
> >> Refer to USB serial device or net device, there is notice to
> >> let end user know the status of device, like attached or
> >> disconnected. Add attach/disconnect print for wwan device as
> >> well. This change works for MHI device and USB device.
> >
> >This change works for wwan port devices, whatever the bus is.
> >
> Sure. Since wwan support USB device as well after integrating
> WWAN framework into cdc-wdm.
> >>
> >> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> >> ---
> >>  drivers/net/wwan/wwan_core.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> >> index 2e1c01cf00a9..d3ac6c5b0b26 100644
> >> --- a/drivers/net/wwan/wwan_core.c
> >> +++ b/drivers/net/wwan/wwan_core.c
> >> @@ -492,6 +492,8 @@ struct wwan_port *wwan_create_port(struct device *parent,
> >>         if (err)
> >>                 goto error_put_device;
> >>
> >> +       dev_info(&wwandev->dev, "%s converter now attached to %s\n",
> >> +                wwan_port_dev_type.name, port->dev.kobj.name);
> >
> >You should use `dev_name()` instead of direct reference to kobj.
> >
> Will update this in v2.
> >Why 'converter' ? If you really want to print, it should be something like:
> >wwan0: wwan0at1 port attached
> This refer to USB device attached info:
>   696.444511] usb 2-3: GSM modem (1-port) converter now attached to ttyUSB0
> [  696.444877] usb 2-3: GSM modem (1-port) converter now attached to ttyUSB1
> [  696.445065] usb 2-3: GSM modem (1-port) converter now attached to ttyUSB2
> currently, we will print it as below with above patch:
> [  233.192123] wwan wwan0: wwan_port converter now attached to wwan0mbim0
> [  694.530781] wwan wwan0: wwan_port converter now disconnected from wwan0mbim0

Ok, but we don't have to mimic USB, and it's not a converter, keep
that simple (e.g. 'port %s attached').

Regards,
Loic
