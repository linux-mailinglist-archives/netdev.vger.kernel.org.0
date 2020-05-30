Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF3A1E9388
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgE3URT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3URS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:17:18 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A1EC03E969;
        Sat, 30 May 2020 13:17:17 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id m21so4311065eds.13;
        Sat, 30 May 2020 13:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WorTAicg/tl4LLbo+gTIrR+KMx/IVjqF8KC8y6GQqjk=;
        b=Xr+kZ9aYHh3gBAVyp/sjlBYNCo7woZ5yqrxJNcXlLlyqTdhyefvXGhN6zyYQd6hpVu
         SuH/vCmK8Pwk3+AEMWlYW9yKw6Z/1haily7Ob+Am+ku7UNQ5f8CWtnRo+bruVw6ZNED1
         Xdd/vnnIQcMpcWG99rdq/Z3hpSVTEob/1yJ0tzKeEOGs2t5i3N9mZ0t7M3fSgCUIVO9H
         iuCavwWNUBMnwaFfGmpDR45tM/KyRqOQMsd4sV0pbp/t4EXW/HaEGqez5OD/ErPYVvmX
         ErP89OLDN1GqYjX4FRo/TwxMWSzLjttsC23g3ABVAiengWY4V7Yp7KSuGw4hV+tPQwXF
         gU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WorTAicg/tl4LLbo+gTIrR+KMx/IVjqF8KC8y6GQqjk=;
        b=F9bOBWjOTqSFJNoyHo5Svw/bIuwPhE0+ia9lYqJ5PrEEO5TYPCrny4x9INROufNTyy
         cGeo4Y1pMKcu/GI9usnWtQMdefLOo7lGZ2qLVt3y64UZwBxjGsa8ra8Tv/8YEbH6w7vE
         TKxjfzqIeqXxVqCuQb3/VAjmNfWNpHVoaebHFyNsNpXeUe63y1cEEubBVfdpJSVx1xpt
         RDc90H1rDg/4Fg89/OTGup14D2uxNBMWyrqsF0uMQ2NDcGkuDlf28W3FA8tERM1Mz2z5
         EUXENy1UGFwDd1SVX1+Gm5vcQd/abUH8YgMQhwwxjxlK03o5sXVSO3+gOTcbimRqt3ZJ
         tC+w==
X-Gm-Message-State: AOAM533uIvOCzsOvqcw8BOCQmW+joIIcNW1vaFgXcJy9gniDbvUGj6p2
        xquUckvXZ6CjmU09fbhDrnfPYAVWfPSY2Y1lLmc=
X-Google-Smtp-Source: ABdhPJyfQZV7yxuhSGC92YaR31qWEVFkTIBJ4ejitnXmy5i0XUreJNI2tfLKO0nCVYEF/kNDylLv/WYRLyQlPJ9PDjs=
X-Received: by 2002:a05:6402:417:: with SMTP id q23mr14553576edv.139.1590869836217;
 Sat, 30 May 2020 13:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200530200630.1029139-1-olteanv@gmail.com>
In-Reply-To: <20200530200630.1029139-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 30 May 2020 23:17:05 +0300
Message-ID: <CA+h21hojFvkHTDJ-LjQdUrb8SW2TAEmz1_MweH94z10cXUAm0Q@mail.gmail.com>
Subject: Re: [PATCH] devres: keep both device name and resource name in pretty name
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     sergei.shtylyov@cogentembedded.com, bgolaszewski@baylibre.com,
        mika.westerberg@linux.intel.com, efremov@linux.com,
        ztuowen@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 May 2020 at 23:06, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Some device drivers have many memory regions, and sometimes debugging is
> easiest using devmem on its register map. Take for example a networking
> switch. Its memory map used to look like this in /proc/iomem:
>
> 1fc000000-1fc3fffff : pcie@1f0000000
>   1fc000000-1fc3fffff : 0000:00:00.5
>     1fc010000-1fc01ffff : sys
>     1fc030000-1fc03ffff : rew
>     1fc060000-1fc0603ff : s2
>     1fc070000-1fc0701ff : devcpu_gcb
>     1fc080000-1fc0800ff : qs
>     1fc090000-1fc0900cb : ptp
>     1fc100000-1fc10ffff : port0
>     1fc110000-1fc11ffff : port1
>     1fc120000-1fc12ffff : port2
>     1fc130000-1fc13ffff : port3
>     1fc140000-1fc14ffff : port4
>     1fc150000-1fc15ffff : port5
>     1fc200000-1fc21ffff : qsys
>     1fc280000-1fc28ffff : ana
>
> But after said patch, the information is now presented in a much more
> opaque way:
>
> 1fc000000-1fc3fffff : pcie@1f0000000
>   1fc000000-1fc3fffff : 0000:00:00.5
>     1fc010000-1fc01ffff : 0000:00:00.5
>     1fc030000-1fc03ffff : 0000:00:00.5
>     1fc060000-1fc0603ff : 0000:00:00.5
>     1fc070000-1fc0701ff : 0000:00:00.5
>     1fc080000-1fc0800ff : 0000:00:00.5
>     1fc090000-1fc0900cb : 0000:00:00.5
>     1fc100000-1fc10ffff : 0000:00:00.5
>     1fc110000-1fc11ffff : 0000:00:00.5
>     1fc120000-1fc12ffff : 0000:00:00.5
>     1fc130000-1fc13ffff : 0000:00:00.5
>     1fc140000-1fc14ffff : 0000:00:00.5
>     1fc150000-1fc15ffff : 0000:00:00.5
>     1fc200000-1fc21ffff : 0000:00:00.5
>     1fc280000-1fc28ffff : 0000:00:00.5
>
> It is a fair comment that /proc/iomem might be confusing when it shows
> resources without an associated device, but we can do better than just
> hide the resource name altogether. Namely, we can print the device
> name _and_ the resource name. Like this:
>
> 1fc000000-1fc3fffff : pcie@1f0000000
>   1fc000000-1fc3fffff : 0000:00:00.5
>     1fc010000-1fc01ffff : 0000:00:00.5 sys
>     1fc030000-1fc03ffff : 0000:00:00.5 rew
>     1fc060000-1fc0603ff : 0000:00:00.5 s2
>     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
>     1fc080000-1fc0800ff : 0000:00:00.5 qs
>     1fc090000-1fc0900cb : 0000:00:00.5 ptp
>     1fc100000-1fc10ffff : 0000:00:00.5 port0
>     1fc110000-1fc11ffff : 0000:00:00.5 port1
>     1fc120000-1fc12ffff : 0000:00:00.5 port2
>     1fc130000-1fc13ffff : 0000:00:00.5 port3
>     1fc140000-1fc14ffff : 0000:00:00.5 port4
>     1fc150000-1fc15ffff : 0000:00:00.5 port5
>     1fc200000-1fc21ffff : 0000:00:00.5 qsys
>     1fc280000-1fc28ffff : 0000:00:00.5 ana
>
> Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I just realized I haven't done any error checking whatsoever on memory
allocation. So let's keep discussing only on the general idea of the
patch, if people are ok with it, I'll send a v2.

>  lib/devres.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/lib/devres.c b/lib/devres.c
> index 6ef51f159c54..25b78b0cb5cc 100644
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>  {
>         resource_size_t size;
>         void __iomem *dest_ptr;
> +       char *pretty_name;
>
>         BUG_ON(!dev);
>
> @@ -129,7 +130,16 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>
>         size = resource_size(res);
>
> -       if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
> +       if (res->name) {
> +               int len = strlen(dev_name(dev)) + strlen(res->name) + 2;
> +
> +               pretty_name = devm_kzalloc(dev, len, GFP_KERNEL);
> +               sprintf(pretty_name, "%s %s", dev_name(dev), res->name);
> +       } else {
> +               pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
> +       }
> +
> +       if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
>                 dev_err(dev, "can't request region for resource %pR\n", res);
>                 return IOMEM_ERR_PTR(-EBUSY);
>         }
> --
> 2.25.1
>

Thanks,
-Vladimir
