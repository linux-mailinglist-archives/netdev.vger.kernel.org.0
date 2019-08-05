Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2675082747
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbfHEWEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:04:09 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33774 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEWEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 18:04:09 -0400
Received: by mail-oi1-f194.google.com with SMTP id u15so63626504oiv.0;
        Mon, 05 Aug 2019 15:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQkPqzCl0EgO8ejsOWFwcjYDROGmuy2jsvyxtVP20aM=;
        b=FCJwaACzgf1lMLExxkJ0zmSYaGN+RjeBxMMU7Lk33oCV3CEo868GUeLDDxRP8mE1cO
         1+wU+wOa9k11DarcGLU9OVtJ2zAkqSj1yefQviDdYqkf7C9wGG0fb+b0g7bvyVTR1OEY
         VrbnQZMl/kXiahEqmsY3qHI56gsaEJJ02c38h7UtUzchv41TArVnLCeThcrLLMr6eAYk
         Ox4H1/llesBgvumKRwVMvQI87/EbuXwbiPWy2YRdMb2f+Sbtsde13IXtqzgZjhJj86mA
         4b2/CYpjuJX+HfG9w4X9VG/rCkSp5laJerKuNBQTsDY89wMo7+hNSjcRHyWdjIzA1ArD
         uazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQkPqzCl0EgO8ejsOWFwcjYDROGmuy2jsvyxtVP20aM=;
        b=D0F6sWSMaupHC0eMKNG8hdNjMXQW/AojAaSM1fu7SGB/aUP7qA6IVFfWBAML23d9CA
         HYdsBU1gj/7VZ2ybmd8hIkrYHh94y4rVcWTBoAgigV2/o50tMIiEqEnVXEfublHpSYcd
         qc2wdtivg37wTdUJE8ky9ewDThK2fKcGKVXQdUBNCtXjzdMsnd9ngR1yBRSb7tteaAUF
         dEhW9nIbZlr1g4Cg1PjxOK2gSHV0lOgvDu2vtIGxaJI4wIJKewPUAmkG1Uhbk0X4ZB/Y
         YEsDzAqkrvGRiRZUDo0zvIdzbyt58GGQRe8IDzC0ZzqkWPqglsxoQRSlOLgK2Qdc/EG/
         Exvw==
X-Gm-Message-State: APjAAAWz7+a3U5/b4G8h+yLCeACyvt3vHJpE0He8QshbrE6qOpUYo19r
        tiX4xRPnI+kpCgUN6txVVu8Q5+8QLjWh9qQm7OY=
X-Google-Smtp-Source: APXvYqxP7fkzI8bznQi3qLDYrrbEn4kQESZSUqqCHb6GuB5YrW2/rhkANG1qEjqgWRtj1C/ifmeIShJ1bzdlQVNpSss=
X-Received: by 2002:a02:b914:: with SMTP id v20mr567705jan.83.1565042648210;
 Mon, 05 Aug 2019 15:04:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190802105457.16596-1-hslester96@gmail.com> <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40F162@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40F162@ORSMSX104.amr.corp.intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 5 Aug 2019 15:03:57 -0700
Message-ID: <CAKgT0UcDz_NDnft5YsZY3c_0vJABXzmZUDk0W4XKx82dJtSh9A@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 1/2] ixgbe: Explicitly initialize
 reference count to 0
To:     "Bowers, AndrewX" <andrewx.bowers@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 2:42 PM Bowers, AndrewX <andrewx.bowers@intel.com> wrote:
>
> > -----Original Message-----
> > From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> > Behalf Of Chuhong Yuan
> > Sent: Friday, August 2, 2019 3:55 AM
> > Cc: netdev@vger.kernel.org; Chuhong Yuan <hslester96@gmail.com>; linux-
> > kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org; David S . Miller
> > <davem@davemloft.net>
> > Subject: [Intel-wired-lan] [PATCH 1/2] ixgbe: Explicitly initialize reference
> > count to 0
> >
> > The driver does not explicitly call atomic_set to initialize refcount to 0.
> > Add the call so that it will be more straight forward to convert refcount from
> > atomic_t to refcount_t.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 1 +
> >  1 file changed, 1 insertion(+)
>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>

NAK. This patch is badly broken. We should not be resetting the fcoe
refcnt in ixgbe_setup_fcoe_ddp_resources.
