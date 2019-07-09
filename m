Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D1862EB3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfGIDTV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 23:19:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32833 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbfGIDTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:19:17 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <chia-lin.kao@canonical.com>)
        id 1hkgex-00059V-56
        for netdev@vger.kernel.org; Tue, 09 Jul 2019 03:19:15 +0000
Received: by mail-wr1-f69.google.com with SMTP id b14so9017265wrn.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 20:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1QqfQjHI6M6xLQMvNpyZB6ztRCUN973WhV6VSHgEn54=;
        b=kpc2r+6pxlRqnz6V4Yb+JmKzRHi36NGj2Cd4sMEq0a4ToqQCLbHC4itNgRc3t3tjO5
         V/15fIFeK+paLT+37GF2U9NzW5aIexJsPECqj6XCHc3ySxW3YsGoP0s2bJWdifC6SLpf
         4DlOF/TvcbJ7sbeckeZICLaxAV4BAU4I7SHXDC2Ru4ijj/PA4xazpKNmECWPN2ndDDXd
         HHOReI3OjQz3RquSyR11Xj/TQUZperoa2q6nIEhUYhSXByT5qvmMTlvJ/HnFdcv+0LVp
         V9ZVOw2FbGcH8JoRVfrSAuG/Lm9/GacjG2xxny5Ey0zvSnS92RshZzg6hVtvaFcMnhI4
         sxzw==
X-Gm-Message-State: APjAAAVmImHL3/o/dSuzULnHPk6/NLkPg35j4nq1Bt60O+psyIZKn7xJ
        Y5svBn0kClryTX8c0NkYihnLF8n4OE412F71Vq+W8Qq5+6KVLFgh7sk4hu1Y3NsOK+6O3U8zrKx
        4btXghWHXcOA+MS7I2a/MFoMCGmO04SBfv1n5pjr34trMiP7YkQ==
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr18052546wmc.110.1562642353853;
        Mon, 08 Jul 2019 20:19:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzeoDMt0MH/23K6Nq80Yvr7C5VC5zRBuvbMf4w56eRexL9FbXcS7tJELrmIiEFI5hpNDUj8erQcw7cihFoBgcA=
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr18052532wmc.110.1562642353629;
 Mon, 08 Jul 2019 20:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190708063751.16234-1-acelan.kao@canonical.com> <53f82481-ed41-abc5-2e4e-ac1026617219@gmail.com>
In-Reply-To: <53f82481-ed41-abc5-2e4e-ac1026617219@gmail.com>
From:   AceLan Kao <acelan.kao@canonical.com>
Date:   Tue, 9 Jul 2019 11:19:01 +0800
Message-ID: <CAFv23Q=mA9t0j2F4fKdOkgG6sao0m7rR_9-d9OvAmSerZf_=ew@mail.gmail.com>
Subject: Re: [PATCH] r8169: add enable_aspm parameter
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> 於 2019年7月9日 週二 上午2:27寫道：
>
> On 08.07.2019 08:37, AceLan Kao wrote:
> > We have many commits in the driver which enable and then disable ASPM
> > function over and over again.
> >    commit b75bb8a5b755 ("r8169: disable ASPM again")
> >    commit 0866cd15029b ("r8169: enable ASPM on RTL8106E")
> >    commit 94235460f9ea ("r8169: Align ASPM/CLKREQ setting function with vendor driver")
> >    commit aa1e7d2c31ef ("r8169: enable ASPM on RTL8168E-VL")
> >    commit f37658da21aa ("r8169: align ASPM entry latency setting with vendor driver")
> >    commit a99790bf5c7f ("r8169: Reinstate ASPM Support")
> >    commit 671646c151d4 ("r8169: Don't disable ASPM in the driver")
> >    commit 4521e1a94279 ("Revert "r8169: enable internal ASPM and clock request settings".")
> >    commit d64ec841517a ("r8169: enable internal ASPM and clock request settings")
> >
> > This function is very important for production, and if we can't come out
> > a solution to make both happy, I'd suggest we add a parameter in the
> > driver to toggle it.
> >
> The usage of a module parameter to control ASPM is discouraged.
> There have been more such attempts in the past that have been declined.
>
> Pending with the PCI maintainers is a series adding ASPM control
> via sysfs, see here: https://www.spinics.net/lists/linux-pci/msg83228.html
Cool, I'll try your patches and reply on that thread.

>
> Also more details than just stating "it's important for production"
> would have been appreciated in the commit message, e.g. which
> power-savings you can achieve with ASPM on which systems.
I should use more specific wordings rather than "important for
production", thanks.
