Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4C529EFE7
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgJ2Pax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbgJ2PaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 11:30:05 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16F220724
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603985404;
        bh=XzZtbCkl1jo+TfW5pKpAlerOkwGIGki4vv7UFVKZvtU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uW4bt13OG+P/Et+UsZEf0rEs59mwXoof5q27zLZ6dwSw0dFfr4ufDurPQ6jc4NkjF
         gxSZSuppLX0pvLiancfJ8p6/FGc71o68wYAqCoj4s9aR2g/DRnEo6Cx5LuzqK7kHke
         O+AcIDO4AuJaak4l2PR1gydYgKBUwQZmKiciSeO0=
Received: by mail-qt1-f180.google.com with SMTP id h19so2069749qtq.4
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 08:30:03 -0700 (PDT)
X-Gm-Message-State: AOAM531yVPY1i2wOMwJPpErUsRrEhDBjrAtwHc8NZkFYzRBaG1lJ6p7e
        NI8UPYbtNkcqmGA9z5DoF8MEYLJVt9L/g3k6z8M=
X-Google-Smtp-Source: ABdhPJxOtebNGLJYx/yMw0wSoth8m7OyCBgtL1+OjViPBEEEvdvdOlf0H8Dxb/Bvs/lfaVTzxgRozbhKEuQ5M+Z3Jio=
X-Received: by 2002:ac8:7955:: with SMTP id r21mr4056900qtt.204.1603985403006;
 Thu, 29 Oct 2020 08:30:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201028002235.928999-1-andrew@lunn.ch> <20201028002235.928999-3-andrew@lunn.ch>
 <294bfee65035493fac1e2643a5e360d5@AcuMS.aculab.com> <20201029143121.GN878328@lunn.ch>
 <2c3145a577f84e96b2ec7be15db90331@AcuMS.aculab.com> <20201029151307.GP878328@lunn.ch>
In-Reply-To: <20201029151307.GP878328@lunn.ch>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 29 Oct 2020 16:29:46 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0Hc6+a=Ncf-_SS5rsPH5b5TuaGBTF6iqhqWhqrbF8jZw@mail.gmail.com>
Message-ID: <CAK8P3a0Hc6+a=Ncf-_SS5rsPH5b5TuaGBTF6iqhqWhqrbF8jZw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: rose: Escape trigraph to fix warning
 with W=1
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Laight <David.Laight@aculab.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 4:13 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Oct 29, 2020 at 02:52:52PM +0000, David Laight wrote:
> > From: Andrew Lunn
> > > Sent: 29 October 2020 14:31
>
> I think this trigraph issues popped up because of one of the changes
> you have in your playground, adding more warnings.
>
> What do you think of disabling the trigraph warning as well as
> disabling trigraphs themselves?

The trigraph warnings are currently disabled in mainline, and trigraphs
themselves are disabled in GCC unless explicitly enabled.

My series contained a patch that changes all trigraphs by adding
'\' characters, to let us no longer disable the warning and slightly
simplify the command line:

 drivers/atm/idt77252.c                                  | 2 +-
 drivers/gpu/drm/msm/msm_rd.c                            | 2 +-
 drivers/mtd/maps/sun_uflash.c                           | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                   | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 drivers/s390/block/dasd_proc.c                          | 2 +-
 drivers/scsi/imm.c                                      | 4 ++--
 drivers/scsi/ppa.c                                      | 4 ++--
 drivers/tty/serial/sunsu.c                              | 2 +-
 net/rose/af_rose.c                                      | 4 ++--
 sound/isa/msnd/msnd.c                                   | 2 +-

Sorry you ran into this after you picked up the patches to the
Makefile but not my preparation patch.

I was unsure about whether this is worth changing, so I did not
send that one patch from my series and we can probably just
not drop the -Wno-trigraphs flag.

       Arnd
