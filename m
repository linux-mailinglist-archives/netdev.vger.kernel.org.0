Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB96120FB
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 09:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJ2HZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 03:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJ2HZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 03:25:01 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B203D580
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 00:24:59 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id i5-20020a1c3b05000000b003cf47dcd316so7793359wma.4
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 00:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9UX3tXtk5a3xhXuVryAcO0cg4dz0oNFgoXm7waHykWc=;
        b=shKp6tO6Xjp+ipHl4pzSAeoEmrwgLlG1XPJph0smrZCfLRgmkxMfSgGFFOaslevYwB
         mahZBXpbUHH83iZywrFKSVNhYZBOpGKzVtcy+StHJwETBu2PDuRQu/Y4QnE997F52sRG
         tanabwTnIFrj88NidwNg27Qgmi36XE83Qfy3gGrMw8j965rz4n9PC2UM7Y94mwCOMwD/
         ec2ZA5A4a24SHhK03Ug6HaGfjo9vTWmR355c0JujfEwiNogNf9lOmJlB2q0hiJoKIURy
         FNveEg03IVaVkWyMx5zX2OdzTZp8k654gbt/zD0ftJ3sRomm2zVjLbPe8xTET+aiY01V
         bW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9UX3tXtk5a3xhXuVryAcO0cg4dz0oNFgoXm7waHykWc=;
        b=44bt5ulB5+7Rh5GKByL+Hwio6VGJn1Jgh5ndgvn7DO6r92uOmJw7eHfMzC8k3s++u7
         GZJNuOPnaSLpD0+4HGDEetaf0zME4ooDtmJaBtnIXHwSgtJiOLnMrJSDXJ0dPzHQ0fZn
         Np2hNhdKkT/3xklB7aLWaA6SoOENGkcUy6K0v+XtcVI/8cG7k/+AMCkUhRMxJINwf085
         i1OT377YgJ+ZudPW+SRvXRHoYGtH3Us1wiyAAPNU+UH+cV4FQSbGVPhxxHTosdDZQb2Q
         xaCrO0YmlRVPnUQv20lUJFNEghJvORm/ou6JEcl6NqFSRG0Ok/Z4fM9bV0Fe30vaK7MH
         oP+g==
X-Gm-Message-State: ACrzQf2mUOO+CDBukSI0yay+k9FHXwOqMALQTzs3ulUXLjZ5jRoBRERF
        poK/fOFb72UvDesij5KKZ4VZzplLimI06NCTpMqzHI0shHw=
X-Google-Smtp-Source: AMsMyM64/Mj5SpsOSCgN6u2Fe24xw0ZP0cTMjs5rFhytZa5a8EyisQlgRPwZtUtonkmL/KjgKtxR4DwZFINQARaGBI4=
X-Received: by 2002:a05:600c:1906:b0:3c6:f154:d4b5 with SMTP id
 j6-20020a05600c190600b003c6f154d4b5mr1663757wmq.94.1667028297836; Sat, 29 Oct
 2022 00:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20221028003128.514318-1-shaneparslow808@gmail.com>
 <CAMZdPi-tz4_vxum8SYbYVuv71UYhe4QUGO6_w8TPFBcw9oydfQ@mail.gmail.com> <Y1wa1JR9URGCUo1P@arch-desk>
In-Reply-To: <Y1wa1JR9URGCUo1P@arch-desk>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sat, 29 Oct 2022 09:24:21 +0200
Message-ID: <CAMZdPi90KNu=J4spz0ggEqnCCOsdugW-oKau-govhpGx8sbCEw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wwan: iosm: add rpc interface for xmm modems
To:     Shane Parslow <shaneparslow808@gmail.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 at 20:09, Shane Parslow <shaneparslow808@gmail.com> wrote:
>
> On Fri, Oct 28, 2022 at 12:35:01PM +0200, Loic Poulain wrote:
> > On Fri, 28 Oct 2022 at 02:37, Shane Parslow <shaneparslow808@gmail.com> wrote:
> > >
> > > Add a new iosm wwan port that connects to the modem rpc interface. This
> > > interface provides a configuration channel, and in the case of the 7360, is
> > > the only way to configure the modem (as it does not support mbim).
> >
> > Doesn't the AT channel offer that possibility? what is the status of
> > 7360 support without this change?
>
> Several initialization functions must be called through the RPC channel
> to bring up the 7360. Without this initialization the modem is not
> functional beyond responding to simple AT commands. After initialization
> through this interface the modem works as expected.

Ok, beyond xmm7360-pci project, it would be good to have this protocol
integrated into an existing modem manager.

>
> Because of this, the 7360 is currently nonfunctional beyond responding
> to a limited set of AT commands. As for the 7560, my understanding is that
> it is currently functional, and this interface simply supplements the MBIM
> interface.
>
> >
> > > The new interface is compatible with existing software, such as
> > > open_xdatachannel.py from the xmm7360-pci project [1].
> > >
> > > [1] https://github.com/xmm7360/xmm7360-pci
> > >
> > > Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
[...]
>
> Thanks for the feedback. Should I go ahead and submit a V2?

Yes, please.
