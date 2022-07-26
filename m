Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD79580FAE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 11:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbiGZJPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 05:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237675AbiGZJPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 05:15:43 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0552124F32;
        Tue, 26 Jul 2022 02:15:40 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id z9so5919483vkb.9;
        Tue, 26 Jul 2022 02:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pAq42ao1YTooOwr1NrQpDBaQLMHRfAHTP/kyLO5Tw4Q=;
        b=VsukYp99jSahECFcFXsodoADb1yDdK1MTzG+DveLz68PrKw0DGfy9SVhkmt8MKBGRf
         n3R0WVRRFJS755SmXdovMz2pCEckMh0oGZW5B89YSzM/DimcGkJIO/sq3X8CFF6c6Mv/
         nyIERB6HMYHNRMz1UsN3GJ+Z02aAw2qhVerainCw05Vw95lqyC5QskewKOmgZsif7n1o
         LcNTIQQ6PH/CPPznjdQFkA/hB2jTJ0zWAIjYxveCP/Oh7/ICLJRjpEo5Mwe7LyB41pL0
         L7FuwiIAno9mN09dE874cj4ZBdjSMQ6GUGMwkNZZiX4pOZDlfJJj+1ps9cVvjvfd9GX1
         tmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pAq42ao1YTooOwr1NrQpDBaQLMHRfAHTP/kyLO5Tw4Q=;
        b=zNhMISWNrIM5ydEpJbuEh1wAddYuksxMbfHTUOArmIxkJ+HbctIiy/bLE+ezoRcbI6
         2GZIG9EtMOZ/vyyLK66rxvQzoP86804CTA6FY2enNrjlF9uvac/dZRnj3hAXodqncy2o
         wX3oWA4+KweRjIvwAeStFgZi+c4peCsLp/OSMjSvXzdqGg9QPHtbOwKUPZqK9tQw1lr7
         /e08Y0FZGhYI70ZM+ezosBHtQbCmVgOrXL7BvP/flRv38nFje3JuNyUeYpz8Nrr2OkCU
         8ALZN477VoN6MKuMMItsysjkc19JokCMDR0UW70jTWA19kvRp6HKvVgEtkcrHFHQ9Qrv
         LDxQ==
X-Gm-Message-State: AJIora/jk4ZxCdyKYAMDNCyZu+CvhOCjZBzPthrrthMXS5+AJUZ8isMx
        J1zdlP25PChECFOyZlNhJtVO8UWFOgTiF6CKwYycjeCn/M51WA==
X-Google-Smtp-Source: AGRyM1vXrGq8JTTQ0kjBCAFa4iMjcJ5I6FumeFgC+iXy9kXKEbu4yjAKo4AJv63dP3el0VM7Vdw87UW9VBwuo3BGnOk=
X-Received: by 2002:a1f:b6c8:0:b0:376:380a:b98d with SMTP id
 g191-20020a1fb6c8000000b00376380ab98dmr3696042vkf.27.1658826939018; Tue, 26
 Jul 2022 02:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20180912093456.23400-4-hdegoede@redhat.com> <20220724210037.3906-1-matwey.kornilov@gmail.com>
 <148f6cb9-aafc-4fd5-9e30-24078866d3fd@linux.intel.com>
In-Reply-To: <148f6cb9-aafc-4fd5-9e30-24078866d3fd@linux.intel.com>
From:   "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date:   Tue, 26 Jul 2022 12:15:28 +0300
Message-ID: <CAJs94EbnDMiHwH44+oHh1Sz5Wb+x80E1K7QCuu+WWZVeYhz7nw@mail.gmail.com>
Subject: Re: [BISECTED] igb initialization failure on Bay Trail
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        carlo@endlessm.com, davem@davemloft.net, hkallweit1@gmail.com,
        js@sig21.net, linux-clk@vger.kernel.org,
        linux-wireless@vger.kernel.org, mturquette@baylibre.com,
        netdev@vger.kernel.org, sboyd@kernel.org
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

=D0=BF=D0=BD, 25 =D0=B8=D1=8E=D0=BB. 2022 =D0=B3. =D0=B2 20:08, Pierre-Loui=
s Bossart
<pierre-louis.bossart@linux.intel.com>:
>
>
>
> On 7/24/22 16:00, Matwey V. Kornilov wrote:
> > Hello,
> >
> > I've just found that the following commit
> >
> >     648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
> >
> > breaks the ethernet on my Lex 3I380CW (Atom E3845) motherboard. The boa=
rd is
> > equipped with dual Intel I211 based 1Gbps copper ethernet.
>
> It's not going to be simple, it's 4 yr old commit that fixes other
> issues with S0i3...

Additionally, it seems that the issue appears only when CONFIG_IGB=3Dm
is used. When CONFIG_IGB=3Dy then both ethernets are initialized
correctly.
However, most (if not all) kernel configs in Linux distros use CONFIG_IGB=
=3Dm

>
> >
> > Before the commit I see the following:
> >
> >      igb 0000:01:00.0: added PHC on eth0
> >      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
> >      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
> >      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
> >      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queu=
e(s)
> >      igb 0000:02:00.0: added PHC on eth1
> >      igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
> >      igb 0000:02:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e5
> >      igb 0000:02:00.0: eth1: PBA No: FFFFFF-0FF
> >      igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queu=
e(s)
> >
> > while when the commit is applied I see the following:
> >
> >      igb 0000:01:00.0: added PHC on eth0
> >      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
> >      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
> >      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
> >      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queu=
e(s)
> >      igb: probe of 0000:02:00.0 failed with error -2
> >
> > Please note, that the second ethernet initialization is failed.
> >
> >
> > See also: http://www.lex.com.tw/products/pdf/3I380A&3I380CW.pdf



--=20
With best regards,
Matwey V. Kornilov
