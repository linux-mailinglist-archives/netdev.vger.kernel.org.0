Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9696A067E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbjBWKoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbjBWKoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:44:18 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09DB2799A;
        Thu, 23 Feb 2023 02:44:16 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f41so13220879lfv.13;
        Thu, 23 Feb 2023 02:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8KJNQkPS1xRs8w538hvvfNuowvEksAqrtLYqByFypzY=;
        b=gRcOvjZMKhjHcRGRhOO6sqET9r8ao6SZV8Bb5rVGPpJuj9n92GIy55LkW12HwgIjgW
         tXXr7bE9Nrd58QKPOpWx6tmnHV9XgedAewTXOrOhLn6Bb1KsKLOR+uIz1fCGuLNfJlTA
         5ynVv/Q20N5s0IE8nekitwEgMzgQzW7nOHYoGmIoOUR01DYeRgFwNcMXtoddMXrZemVf
         dJnRnupr4dLjxg8TKRqLEj+o+5Ed5Mr8IiQU0GIoKXb56GHlX3AP9ovt+drrxr0DJi2L
         usK+7LLtTHHfbjj8V8cMdMwrn0SHMEa3s3TOMjUf6Rsceh8ju8RCFI92RwOMnuWG+VEv
         Yjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8KJNQkPS1xRs8w538hvvfNuowvEksAqrtLYqByFypzY=;
        b=cSr2XQpJST8pHgmVm6gg4yUOCgEY2v0W74pvu7BRSSeIRmQWa7v9L4e6/NT2D597u6
         y/asv/CK04NTkbruZnwKkyvp2Zqy4iCBedVeUW6D3TQuhGSKtarpJ0aEsQ4eiA/6nxok
         11uAQFFXXQyX/LN07i+G5ic7cWK9+YojbdhpckmnOyCL8ljvvgNoDshF7iHwKb4w8mDu
         uc9KFrdUJCB+pkitA3s5VFOw+PvdusCVfgE+Ip7K5oW6KMi0gVr5brMD0oKrIoQi/9HN
         sXcT+c+WyzH4Rbj57+Av5i+iEl0RPi0XLchQpbo3USPkOFO2nxeV0Auu/nRE3Hxur5ns
         ykgw==
X-Gm-Message-State: AO0yUKUzsnTGz0uPcs8pN1lRI/6EDO01N4c7mJoIaTgEd2+WKXXwI7aH
        25UF5qKyQAhVy9rzrQIG3HtbLJvv0AbbdISCqR4=
X-Google-Smtp-Source: AK7set80k+mfJgTfbfnNdqNLcwbVTmntr4JkTl3nJ0PxtbFn5LahfgVM++6FG+N4QatgwGX9m3lZYhH5suO9PVZXhi4=
X-Received: by 2002:ac2:5495:0:b0:4d5:ca32:68a2 with SMTP id
 t21-20020ac25495000000b004d5ca3268a2mr3617379lfk.7.1677149054727; Thu, 23 Feb
 2023 02:44:14 -0800 (PST)
MIME-Version: 1.0
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com> <20230209094825.49f59208@kernel.org>
 <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com> <20230209130725.0b04a424@kernel.org>
 <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc> <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
 <87bkm1x47n.fsf@kernel.org> <2c2e656e-6dad-67d9-8da0-d507804e7df3@microchip.com>
 <aef63f6a367896950f9e61041cfcff4b99bd6c7d.camel@redhat.com> <e455e26830a0d8f2ce728461b74e6dbd4b315df5.camel@sipsolutions.net>
In-Reply-To: <e455e26830a0d8f2ce728461b74e6dbd4b315df5.camel@sipsolutions.net>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Thu, 23 Feb 2023 11:44:02 +0100
Message-ID: <CAEyMn7Z-4apxxSns+eJDv6nHqGz6UvGCWa4+MmFTv4NXHyYiqw@mail.gmail.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Dan Williams <dcbw@redhat.com>, Ajay.Kathat@microchip.com,
        kvalo@kernel.org, michael@walle.cc, kuba@kernel.org,
        Claudiu.Beznea@microchip.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Amisha.Patel@microchip.com,
        thaller@redhat.com, bgalvani@redhat.com,
        Sripad.Balwadgi@microchip.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ajay,

Am Mi., 15. Feb. 2023 um 21:14 Uhr schrieb Johannes Berg
<johannes@sipsolutions.net>:
>
> On Fri, 2023-02-10 at 15:28 -0600, Dan Williams wrote:
> > >
> > > In wilc1000, the bus interface is up in probe but we don't have
> > > access
> > > to mac address via register until the driver starts the wilc firmware
> > > because of design limitation. This information is only available
> > > after
> > > the MAC layer is initialized.
> >
> > So... initialize the MAC layer and read the address, then stop the card
> > until dev open which reloads and reinits? That's what eg Atmel does
>
> For a more modern example, iwlwifi also ;-)
>
> You should also load the firmware async, so it becomes:
>
> probe
>  -> load firmware
>
> firmware success callback
>  - boot device
>  - read information
>  - register with mac80211
>  - shut down device
>
> mac80211 start callback
>  - boot device again
>  - etc.

Do you have a meaning about that? That sounds like a viable solution.
What do you think?

-- 
Heiko

> johannes
