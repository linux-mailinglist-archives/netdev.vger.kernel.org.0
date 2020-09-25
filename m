Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6622785B0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 13:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgIYLYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 07:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgIYLYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 07:24:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBACC0613CE;
        Fri, 25 Sep 2020 04:24:01 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s12so3159682wrw.11;
        Fri, 25 Sep 2020 04:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SFWcfeS5wxuI7eAUUDEBe0a+as5YNy5FGHPEInpElA8=;
        b=YwusCQb4BNAs2qNa8S3uQAN1XOHgiKuS/bWyodzx+julOIpF8cMM+ULqoTh70csgmu
         Tg7LuB4jVQLF7thah9OEj3nFW152KXkekpYFu35kCOSdxD+ycnC44LKNN3PIqZLfOl12
         aW3JvhopCsNsu/CIHKE65qLtfjGq90wIacSzLzBjKAV0wAJC9AhL8sWSXQNlOJPH7J9j
         lfRJJFWnMLq13GfmwodEF09YeJRX0pOsxDuzkN5zxlbQ1ebIFdWAhShHm6aJt+HZyykP
         nJju+fVztQNgTUUzR07a17dNJyr8qTR0WIYQYGRBiNjxDWq7CL02l6imoZj4NOGBeysf
         Wmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SFWcfeS5wxuI7eAUUDEBe0a+as5YNy5FGHPEInpElA8=;
        b=fzB1MNT8PVYxgxRD/8ZwS/Ol7j9Snu3BnMcwwwsCRJ0pVKhkXHPVusyVcXJkdBjddm
         mGUsZ0ffzE6CNEgXEk/wd734BJjOM/JErLQZyPyR8HyPJaferNNBIwuKBu1YGJ1yoUKz
         WjgCPzNr68j5tkgwh85ewgvaBWdHevOENTbWm+T9RQbGL+DE4p4tS/pz5R8IaT/pBQyW
         If4Xe1e8/V2WWOKtta8SLaNmi4oIbfeX1eOR4DN3I+/yLmaxlBZhPy71JAcIz+vcMmcr
         imJJAg/SfolqBx4oq7Tf6vZqBxU4ITn5gO67+sR1d906Gg3qqNpgdNTYQGte5vuCRwPC
         5MbA==
X-Gm-Message-State: AOAM531BhLih2FrnuvFJq04Xo7Xe6cApULKGMgLA9M2FmYHiTStPT/7q
        ZpLgS147XWy5XVuXdT8zO3D3ByRYY6TgxHeNIm8=
X-Google-Smtp-Source: ABdhPJzm9ewJSK7s1bAh20TjRk7fbdnLc3xpXegODgfo/yRdDK42Rrpg+9Cj7gBDCvmWeHhsbWumnOO3fGV9uaN0Ffk=
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr4036971wrm.203.1601033040375;
 Fri, 25 Sep 2020 04:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-4-himadrispandya@gmail.com> <1600856557.26851.6.camel@suse.com>
 <CAOY-YVkHycXqem_Xr6nQLgKEunk3MNc7dBtZ=5Aym4Y06vs9xQ@mail.gmail.com>
 <1600870858.25088.1.camel@suse.com> <CAOY-YVkciMUgtS7USbBh_Uy_=fVWwMMDeHv=Ub_H3GaY0FKZyQ@mail.gmail.com>
 <7f9e20b2eab783303c4e5f5c3244366fa88a6567.camel@suse.com>
In-Reply-To: <7f9e20b2eab783303c4e5f5c3244366fa88a6567.camel@suse.com>
From:   Himadri Pandya <himadrispandya@gmail.com>
Date:   Fri, 25 Sep 2020 16:53:48 +0530
Message-ID: <CAOY-YVmBW52bXF95pTM3fNVUyRt=PNXZ5iGyq6mYsW2_iopnoQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and usb_control_msg_send()
To:     Oliver Neukum <oneukum@suse.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        pankaj.laxminarayan.bharadiya@intel.com,
        Kees Cook <keescook@chromium.org>, yuehaibing@huawei.com,
        petkan@nucleusys.com, ogiannou@gmail.com,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 5:06 PM Oliver Neukum <oneukum@suse.com> wrote:
>
> Am Mittwoch, den 23.09.2020, 20:02 +0530 schrieb Himadri Pandya:
>
> > I meant that it was stupid to change it without properly understanding
> > the significance of GFP_NOIO in this context.
> >
> > So now, do we re-write the wrapper functions with flag passed as a parameter?
>
> Hi,
>
> I hope I set you in CC for a patch set doing exactly that.
>

Yes.

> Do not let me or other maintainers discourage you from writing patches.
> Look at it this way. Had you not written this patch, I would not have
> looked into the matter. Patches are supposed to be reviewed.
> If you want additional information, just ask. We do not want
> people discouraged from writing substantial patches.
>

Understood :).

I'll send v2 after the update in API is merged.

Thanks,
Himadri

>         Regards
>                 Oliver
>
>
