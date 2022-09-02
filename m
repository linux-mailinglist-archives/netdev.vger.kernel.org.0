Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393735AA60D
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiIBCs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbiIBCsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF732B0293
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 19:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662086903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6KEvl3zUNi9HajmySQBLA/mODmKbbOY/odaiZIlDLHM=;
        b=QVh/puHPrf0zKe5mT+FLIsBBC+KM6hhV9rXvHCpBtOuKw7B8llGdrLfRUIaKXR/uct6Eaf
        f0Y8U9x3vx1ASm5Wt6Q+Iz0ZOtW4oIRYAfNqY4NeShi9PQFRbsZ3VNYkNRkvwvsDBYmuet
        gOpLZ7zj8thIo03ZgckHwNUC71qSuh4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-255-VVRMw1LaNdeP1y561m1Bgg-1; Thu, 01 Sep 2022 22:48:21 -0400
X-MC-Unique: VVRMw1LaNdeP1y561m1Bgg-1
Received: by mail-qv1-f72.google.com with SMTP id o6-20020ad443c6000000b00495d04028a6so438389qvs.18
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 19:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6KEvl3zUNi9HajmySQBLA/mODmKbbOY/odaiZIlDLHM=;
        b=YjoQ+10v3JKDLT6Mm4a3kpSQnz3g+RE5S6RRpv2hmJu1tt6lvZj/9qLpFDFwDQQ4Q3
         q8wuUPWtFhwonBlIoCPDB9ensJJRMxnnkzEu+KDTUGxDeWeefkURCMkhTTeYDxRrbkVw
         ZhtjqH9LW1h7AgIewZRRCvXrmNhk5eY0N4eFdD3O6OrhLyXaUR0ChqDPa8+qH0s/xhVj
         byJBhBIpA44/WsCG/BoWUFqi+YulZ/UHaY1mHxkF/Be95xl+X4oGQrGqKdfv45OyuwKT
         7Nbp4nkHKI6MT98VbFOv7iH1h4yjiO5JOjAAg6/CoY47QT2vUcAXg1SiaXmDmePPztYc
         wTiw==
X-Gm-Message-State: ACgBeo358KcPx82EYaQdo0K30B+derr2EDsOG6XnukdvTRdsMLXHUv+e
        OPRBWS33y9j97cavDwbh4nUMlWxj8mWRaUR+x3qTbKa1nKVUZliJ0rnclWOfhP+HqPsdGoMpGhI
        HsIgbZnjYIc9/VysFrkBUipY/LrcuJG2K
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id q13-20020a05622a04cd00b0034365a4e212mr26028880qtx.526.1662086901408;
        Thu, 01 Sep 2022 19:48:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7kM+aUx6ow6Gtwtn5277EboelJA3nOHPK3W7NAcU9dfPSIyV1OalkAADe0Q4cM5H8qXURXWh9Pty2JrHnEdsw=
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id
 q13-20020a05622a04cd00b0034365a4e212mr26028873qtx.526.1662086901205; Thu, 01
 Sep 2022 19:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220830101237.22782-1-gal@nvidia.com> <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com> <20220830233124.2770ffc2@kernel.org>
 <20220831112150.36e503bd@kernel.org> <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
 <20220831140947.7e8d06ee@kernel.org> <YxBTaxMmHKiLjcCo@unreal> <20220901132338.2953518c@kernel.org>
In-Reply-To: <20220901132338.2953518c@kernel.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 1 Sep 2022 22:48:10 -0400
Message-ID: <CAK-6q+gtcDVCGB0KvhMjQ-WotWuyL7mpw99-36j_TcC7mc2qyA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Sep 1, 2022 at 4:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 1 Sep 2022 09:38:35 +0300 Leon Romanovsky wrote:
> > There is no such thing like experimental UAPI. Once you put something
> > in UAPI headers and/or allowed users to issue calls from userspace
> > to kernel, they can use it. We don't control how users compile their
> > kernels.
> >
> > So it is not break "experimental commands", but break commands that
> > maybe shouldn't exist in first place.
> >
> > nl802154 code suffers from two basic mistakes:
> > 1. User visible defines are not part of UAPI headers. For example,
> > include/net/nl802154.h should be in include/uapi/net/....
> > 2. Used Kconfig option for pseudo-UAPI header.
> >
> > In this specific case, I checked that Fedora didn't enable this
> > CONFIG_IEEE802154_NL802154_EXPERIMENTAL knob, but someone needs
> > to check debian and other distros too.
> >
> > Most likely it is not used at all.
>
> You're right, FWIW. I didn't want to get sidetracked into that before
> we fix the immediate build issue. It's not the only family playing uAPI
> games :(
>

I am not sure how to proceed here now, if removing the
CONFIG_IEEE802154_NL802154_EXPERIMENTAL option is the way to go. Then
do it?

It was a mistake to introduce that whole thing and a probably better
way is to change nl802154 is to mark it deprecated, after a while
rename the enum value to some reserved value and remove the associated
code. Then after some time it can be reused again? If this sounds like
a better idea how to handle the use case we have here?

I am sorry that this config currently causes such a big problem here.

- Alex

