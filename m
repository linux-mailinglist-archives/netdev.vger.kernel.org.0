Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E16687D4D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBBM1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBBM12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:27:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1791448C
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675340801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D+u8VFxD7A4IUSzsKSNfKdOYZFxseMRQ9PUPTVzHGxo=;
        b=ZihNjJSnprqeVtRsSQnslXL5+snFCek505vmtOwZGmZiSLzOT2DlNS+gEyCC5fVs1fUEQa
        baz+Kwtz4My1ZqfIpzgQeVkdOsAjl1lEEx9ths2jBFJO7iffzisi6lPz9SU6TdpSjjFnae
        uy5z1gEPn/zU2OLqpeae/iTNosugVNY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-Wcrw6wiUN4eGw-8f5uMZSw-1; Thu, 02 Feb 2023 07:26:40 -0500
X-MC-Unique: Wcrw6wiUN4eGw-8f5uMZSw-1
Received: by mail-qt1-f200.google.com with SMTP id i5-20020ac813c5000000b003b86b748aadso853343qtj.14
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 04:26:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D+u8VFxD7A4IUSzsKSNfKdOYZFxseMRQ9PUPTVzHGxo=;
        b=h30xCU11cc0ly858h7UShIfCFSZ0+Izh9MV67r6DMuMMqRtaLaaeHk1eecN9oxsLg5
         +Ku9WU/j5C5cPTXsomwuQ4dno3OBj+V3ozhYzkGmGawM5Dloe1SJm7ew1XOc1A4hw9q+
         25B8JZT9UkziUFTiJG+0KvbyVfzrNCSaF8vevqVhBpDNRn0TM5ux4pS8+f7YbRa8+qrk
         r1lYTd2eOMFHCglpY6lwSY440fg5Z8UsECebU5JNe+6k0GRoahup66F2araz1FG62RN1
         4SDDISFzuvecrzwB7pdIVA+JHE7C6QJZvfIdTdR/fgQeEjYl7zs4ITu1WjPvFfD2zpVw
         n2Bw==
X-Gm-Message-State: AO0yUKUkD15GebHC33bZ+BzZt3xLWpu8Qb1YkUHf/RxDORM4faJRXkCo
        118YqHCwGnn38yNdaWamYmez7PkZcnijtUIWmB8gmeSuP0hp/46QSi8/xbBRGaysRSVzWBui6X3
        Yx6IUZ1hMydMDP+pf
X-Received: by 2002:ac8:7fc3:0:b0:3b6:35cb:b944 with SMTP id b3-20020ac87fc3000000b003b635cbb944mr10825564qtk.2.1675340799868;
        Thu, 02 Feb 2023 04:26:39 -0800 (PST)
X-Google-Smtp-Source: AK7set9bQ7bVnPTqGd+Gqz4c6owsIHZmePFnDh7PI2yagwN/Wh/3IHDjxpyr3/Byx6/CP33Ao4BxLQ==
X-Received: by 2002:ac8:7fc3:0:b0:3b6:35cb:b944 with SMTP id b3-20020ac87fc3000000b003b635cbb944mr10825435qtk.2.1675340798800;
        Thu, 02 Feb 2023 04:26:38 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id b25-20020ac844d9000000b003b82cb8748dsm11178885qto.96.2023.02.02.04.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 04:26:38 -0800 (PST)
Message-ID: <037f01ade9686fc213bbf3b2d04d90bbc786ea08.camel@redhat.com>
Subject: Re: [PATCH net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
From:   Paolo Abeni <pabeni@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Hao <haokexin@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>
Date:   Thu, 02 Feb 2023 13:26:34 +0100
In-Reply-To: <83e1e852-303b-2460-9034-ce1f91445f47@gmail.com>
References: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
         <20230131215528.7a791a54@kernel.org> <Y9pfBpoZ4cezf6Bb@pek-khao-d2>
         <20230201210754.143357c5@kernel.org>
         <83e1e852-303b-2460-9034-ce1f91445f47@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 07:30 +0100, Heiner Kallweit wrote:
> On 02.02.2023 06:07, Jakub Kicinski wrote:
> > On Wed, 1 Feb 2023 20:45:58 +0800 Kevin Hao wrote:
> > > The "Fixes" tag is used to specify the commit causing regression
> > > instead of patch prerequisite.
> >=20
> > Indeed, what's the tag for the commit where the problem can be first
> > observed? All the way back to:
> >=20
> > Fixes: 7334b3e47aee ("net: phy: Add Meson GXL Internal PHY driver")
> >=20
> > ?
>=20
> The issue popped up with:
> d853d145ea3e ("net: phy: add an option to disable EEE advertisement")
>=20
> This commit added MMD register access to the generic configuration
> path in phylib.

Please post a v2 with an update Fixes tag, and ev, referencing the pre-
requisite  in the the commit message itself, thanks!

Paolo

