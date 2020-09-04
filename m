Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C169825E218
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgIDTlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgIDTlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:41:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59596C061244;
        Fri,  4 Sep 2020 12:41:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so3501408pjb.5;
        Fri, 04 Sep 2020 12:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mcsIlDVMIcUgft0ekyY0X99cCTJAxpVQRIP6nlnBXbc=;
        b=OByOQrFknJxWRmEtf25EpKLbIGtdY0kd9f/fX8Hr7+29+KiLhxQUwDpYDtiN1x45fB
         HCvUGOHS+awokYPhDYzNEA6iI78xlz2hxKQn0+VznHM8nG0zgJNXHrXZX5SwVFctw/MG
         SJ6VJY7fc34fSVGps/b/aZRuNsZeCacJNmh6aUR8Hy0/Jc1PXKdBs//ACx5hcWWOE9NU
         fkTklC1O1mCi08VFUcTGoNzdYMTHKyuf/3/IuD1gU9PnGQSWGc/WC9PpKWA7ZEKMTml+
         EP1UYoRng43nDGN3Atq+/auHq//zUtWaQKFMBkIAoEnKd1Yr77SL8KCAKsaPa3woJgva
         DvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mcsIlDVMIcUgft0ekyY0X99cCTJAxpVQRIP6nlnBXbc=;
        b=TyiSVjNspKvN2hX6N0KlQ/vldXy1YomlbtF5NvMVAdjFPqLRoTERUDv1oOd/Lib3W/
         iD6PyBzfoxlS1lm7Sk0uk9n+3YmwO7V2bPeF/XIPEWJzwRW0oPU8MHTmzJ4Vm1E+ZCIs
         BV6VSrznllaQY883syE3iBOb5g0hUlcjGQrYs0qnpkODfVM5rP1+PdwgMCYorper/F21
         sDMGanzNVzTepPzNdxohSw//e/Lt77SO/JzfHtlvX8rS/7K983rMGFtbOrN2k3xCQkI9
         5+Scb/Ea0e0of2RchcS5yRIBPnS9cewIdgPx1mer5CJbk4cxAUxSSMwaT0GWS40I3gVz
         b5DA==
X-Gm-Message-State: AOAM531YXyJTxkaN+VY1o/b+xh4NCT+Tj2m7bUEH186Lov2R9a67rfc2
        9Czo4CkzeQb13HOEyKSo/Afm3QrAhMJQ8wfIVec=
X-Google-Smtp-Source: ABdhPJxcGLl/CTorXyJAuI6R5EH4tOpOeD365PjwKiKexpa6cad5SSIyiJB8AIAHWBmbvZGIinuJ7nz0IWeS9OZsrgU=
X-Received: by 2002:a17:90a:b387:: with SMTP id e7mr9876038pjr.228.1599248494903;
 Fri, 04 Sep 2020 12:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu> <20200904165222.18444-6-vadym.kochan@plvision.eu>
In-Reply-To: <20200904165222.18444-6-vadym.kochan@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 4 Sep 2020 22:41:17 +0300
Message-ID: <CAHp75VedS=cnE-9KVMFS-CF9YwR_wrkGgwqHROhe0RD-G3O7YQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 5/6] net: marvell: prestera: Add Switchdev
 driver implementation
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> The following features are supported:
>
>     - VLAN-aware bridge offloading
>     - VLAN-unaware bridge offloading
>     - FDB offloading (learning, ageing)
>     - Switchport configuration
>
> Currently there are some limitations like:
>
>     - Only 1 VLAN-aware bridge instance supported
>     - FDB ageing timeout parameter is set globally per device

Similar comments as per previous patches.

> +       struct list_head vlans_list;

How this container is being protected against races?

-- 
With Best Regards,
Andy Shevchenko
