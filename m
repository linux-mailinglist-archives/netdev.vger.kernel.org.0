Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541DA3EBC81
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhHMT2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhHMT1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:27:55 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC993C061756;
        Fri, 13 Aug 2021 12:27:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so11859949pje.0;
        Fri, 13 Aug 2021 12:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qLzppHAnLEiDz3B2hIlQsIXc4XySlvif9J2q1+S4M2I=;
        b=rwu8JidaH214fXQm/6/mcW05jj8PRk3fPK2XcaFG0P3eS9sDPKRn8vmzzYWu9mr3jq
         In9vkR7xB5WHEprt5Y5Xi1leQo7E+c3wUBA2nAgt/xJ+tOMCnpQDJLdDTO3m/g2Oao9j
         Xp2kSf8tGUqMK3ohP5C1rYg/Mk6+81vx56vLRGE7uSDkh30T+hAgfri8thr2xsK048Zm
         ulBh5aPlxstjzIzu3q3DrE6VPdchKFSbFBIbinarlRbeWwaOb1JgnM1VCFqp1vdz9RNo
         J5nYOgp5wNRGTvzKhHE+XRt6LH9qBoAdJn0MMok52BdWG0j8Ao6EoqklnE8rVrs76khd
         Vngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qLzppHAnLEiDz3B2hIlQsIXc4XySlvif9J2q1+S4M2I=;
        b=smeCTmRsJJmIzMjnuSaDTuLTgI7wfALa6IhrbaCnCKGG/YujECRfRmuQYXycFGcRw3
         HdWYQdVkWlSBEJMZEyNsKN2wRjB4z4pDTgqGOgRmkHq8/NBhs+4IvggZYZgskC73VKQ+
         qx0V/f/hGMR321S4KZ4sgSmNWI3tcgDWlHD+LloO3OP/ye7tr2n/iHGHJJqevYVWw/OW
         ThuCBVIoSg8FnJWcApDJkaHiQTY0RnLeLs9foQTyUoLCenSV2xa+es6oV3ayPEIgufvv
         eTggmAjGR/XDj0fnMpLOQc5qgLe7xbfAZ57kp895tBLYDiQklTMhq/DlAqpxkq0CYCwi
         y4Ig==
X-Gm-Message-State: AOAM533TgxJ7Mbgucm2byveEKh7tAMrDxAjuNII7D1w48Y6o/m0v5Dzu
        Q+fIRQrpsG4IdDilGP/rUbAub50TFqB1mk+XBLc=
X-Google-Smtp-Source: ABdhPJziSyWAdxJS9yG9MSKPhfINSQG7O8XiKt4GElYtu7FsFnISeKdbTKEgwfyi5lPQjVDMQrC1LiDcvRH9LBPAhn4=
X-Received: by 2002:a17:90a:604e:: with SMTP id h14mr4093177pjm.181.1628882848462;
 Fri, 13 Aug 2021 12:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210813122932.46152-4-andriy.shevchenko@linux.intel.com>
 <202108132237.jJSESPou-lkp@intel.com> <YRaMEfTvOCsi40Je@smile.fi.intel.com>
 <YRaSIp4ViWvMrCoP@smile.fi.intel.com> <20210813112312.62f4ac42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813112312.62f4ac42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 13 Aug 2021 22:26:52 +0300
Message-ID: <CAHp75VeszO9iN7D3zG0-Z-V3CVC=mMdqq1ybHpUyD2HPRFH2Aw@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 4/7] ptp_pch: Switch to use
 module_pci_driver() macro
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        kernel test robot <lkp@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild-all@lists.01.org, Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 9:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 13 Aug 2021 18:39:14 +0300 Andy Shevchenko wrote:
> > On Fri, Aug 13, 2021 at 06:13:21PM +0300, Andy Shevchenko wrote:
> > > On Fri, Aug 13, 2021 at 10:34:17PM +0800, kernel test robot wrote:
> > > > Hi Andy,
> > > >
> > > > I love your patch! Yet something to improve:
> > > >
> > > > [auto build test ERROR on net-next/master]
> > > >
> > > > url:    https://github.com/0day-ci/linux/commits/Andy-Shevchenko/pt=
p_pch-use-mac_pton/20210813-203135
> > > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-n=
ext.git b769cf44ed55f4b277b89cf53df6092f0c9082d0
> > > > config: nios2-randconfig-r023-20210813 (attached as .config)
> > > > compiler: nios2-linux-gcc (GCC) 11.2.0
> > > > reproduce (this is a W=3D1 build):
> > > >         wget https://raw.githubusercontent.com/intel/lkp-tests/mast=
er/sbin/make.cross -O ~/bin/make.cross
> > > >         chmod +x ~/bin/make.cross
> > > >         # https://github.com/0day-ci/linux/commit/6c1fff5c80fe8f1a1=
2c20bac2d28ebfa5960bde7
> > > >         git remote add linux-review https://github.com/0day-ci/linu=
x
> > > >         git fetch --no-tags linux-review Andy-Shevchenko/ptp_pch-us=
e-mac_pton/20210813-203135
> > > >         git checkout 6c1fff5c80fe8f1a12c20bac2d28ebfa5960bde7
> > > >         # save the attached .config to linux build tree
> > > >         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-11.2.0 ma=
ke.cross ARCH=3Dnios2
> > > >
> > > > If you fix the issue, kindly add following tag as appropriate
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > Thanks!
> > >
> > > Definitely I have compiled it in my local branch. I'll check what is =
the root
> > > cause of this.
> >
> > Kconfig misses PCI dependency. I will send a separate patch, there is n=
othing
> > to do here.
>
> That patch has to be before this one, tho.

Yes, I have sent it as a fix to the net, this series is to the
net-next. Am I missing something in the process here? Because I have
been told a few times that I mustn't collect net and net-next patches
in one series in the usual cases.

> There is a static inline
> stub for pci_register_driver() etc. if !PCI, but there isn't for
> module_pci_driver(), meaning in builds without PCI this driver used
> to be harmlessly pointless, now it's breaking build.

> Am I missing something?
>
> Adding Bjorn in case he has a preference on adding the dependency vs
> stubbing out module_pci_driver().

I went all the same way but I have checked SPI and I=C2=B2C how they are
doing. It seems the common practice is to use direct dependency.
Nevertheless, the stubs in PCI puzzled me a bit, why do we have them
in the first place?


--=20
With Best Regards,
Andy Shevchenko
