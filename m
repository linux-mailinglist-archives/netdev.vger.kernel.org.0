Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B72C1EAFEA
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgFAUDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgFAUDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:03:41 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B0FC061A0E;
        Mon,  1 Jun 2020 13:03:41 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id s19so8223967edt.12;
        Mon, 01 Jun 2020 13:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKDaq52eODW+ntnFol3ecy2v0dHMmTzzXT8sIsSPLnI=;
        b=iZYzhAt2RbVdrmChKXkH2OD9g1wwdL+cJN/1p3PCAWVW+523Nd2fsIInjxDwnh1BCr
         +naDMYchvYAxYuyNxSIxOUa+uPIcjThQwsypEu2RmlEJvwG1KKtsNvaGw4u2tMbf7L1V
         QcGFHhywW5FhEZioMWoiSXOf8uwUbScCAJ75gqsOGhSz8+gxIvrcCkqpqTBLvGwKUHxp
         L/w4VkIWq+xwU55mnhhRHlMbNvr3QTqhvu+ZVnB+x15SZ2CqRrwHR/Lhqp72hk+Z/kHA
         2ZYshWbrVZx1CHT04Esp1G3QLxoknYcTpNHu5ncKnrkSddMwlsNnTKtspI5Xe1hMSi0z
         7fsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKDaq52eODW+ntnFol3ecy2v0dHMmTzzXT8sIsSPLnI=;
        b=U99yDqysnEIxyFnfdeAaNfXl4bzf7yo/rIG47Wo8ipJ8yAPw4LJxbktz1rXt1QBRUE
         7XeFZRA8p/5XY5k7j7aNrrxwR/1JAEKMbQYugblnbUJ+Lhu+DFaqPxpGH9RHk1mGFonL
         VRG5lKLTNgMWENl92DZLiXCK4KNaJe8OS0sriE7WmBM3KAGucz3ygU24BWejJ7W2+kLu
         NmtiSwp2thiUiLTFczgmZeJ3pTHcZsm+/QvDRlvw5RHt+oJhi1wk1x2VoGn4FeSIuPkQ
         ZJgnfl0SlmDbUCKW7M3/PA0qi0pDB0eKe+qdFoeIN9kTgtpqdOHpCpYZ3DJ2wv+wg8g3
         jVmg==
X-Gm-Message-State: AOAM530M/RIbhvV4hi9DsW/uwRXdaiQTlzVwWPqFt3ySRkkBe5HnH/5h
        q2H/epWINiV+7yuT28dACkUuO4q7zYRGclYG0TY=
X-Google-Smtp-Source: ABdhPJyiAMFmqOPa5W3SEJLU8SiHs1GkPzEW1LyWXAVfMY/86aeh8wxWS6EDO/EpLEkmXrN9iAHiPbzphB8Kn+0ogDo=
X-Received: by 2002:a05:6402:719:: with SMTP id w25mr23551045edx.179.1591041819901;
 Mon, 01 Jun 2020 13:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200601095826.1757621-1-olteanv@gmail.com> <7d88d376-dde7-828e-ad0a-12c0cb596ac1@cogentembedded.com>
In-Reply-To: <7d88d376-dde7-828e-ad0a-12c0cb596ac1@cogentembedded.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 23:03:27 +0300
Message-ID: <CA+h21hotyQhJeMLJz5SaNc+McRF=w2m4m_qAAQV2D6phE6apkA@mail.gmail.com>
Subject: Re: [PATCH v3] devres: keep both device name and resource name in
 pretty name
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        bgolaszewski@baylibre.com, mika.westerberg@linux.intel.com,
        efremov@linux.com, ztuowen@gmail.com,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On Mon, 1 Jun 2020 at 21:48, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
> On 06/01/2020 12:58 PM, Vladimir Oltean wrote:
>
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Sometimes debugging a device is easiest using devmem on its register
> > map, and that can be seen with /proc/iomem. But some device drivers have
> > many memory regions. Take for example a networking switch. Its memory
> > map used to look like this in /proc/iomem:
> >
> > 1fc000000-1fc3fffff : pcie@1f0000000
> >   1fc000000-1fc3fffff : 0000:00:00.5
> >     1fc010000-1fc01ffff : sys
> >     1fc030000-1fc03ffff : rew
> >     1fc060000-1fc0603ff : s2
> >     1fc070000-1fc0701ff : devcpu_gcb
> >     1fc080000-1fc0800ff : qs
> >     1fc090000-1fc0900cb : ptp
> >     1fc100000-1fc10ffff : port0
> >     1fc110000-1fc11ffff : port1
> >     1fc120000-1fc12ffff : port2
> >     1fc130000-1fc13ffff : port3
> >     1fc140000-1fc14ffff : port4
> >     1fc150000-1fc15ffff : port5
> >     1fc200000-1fc21ffff : qsys
> >     1fc280000-1fc28ffff : ana
> >
> > But after the patch in Fixes: was applied, the information is now
> > presented in a much more opaque way:
> >
> > 1fc000000-1fc3fffff : pcie@1f0000000
> >   1fc000000-1fc3fffff : 0000:00:00.5
> >     1fc010000-1fc01ffff : 0000:00:00.5
> >     1fc030000-1fc03ffff : 0000:00:00.5
> >     1fc060000-1fc0603ff : 0000:00:00.5
> >     1fc070000-1fc0701ff : 0000:00:00.5
> >     1fc080000-1fc0800ff : 0000:00:00.5
> >     1fc090000-1fc0900cb : 0000:00:00.5
> >     1fc100000-1fc10ffff : 0000:00:00.5
> >     1fc110000-1fc11ffff : 0000:00:00.5
> >     1fc120000-1fc12ffff : 0000:00:00.5
> >     1fc130000-1fc13ffff : 0000:00:00.5
> >     1fc140000-1fc14ffff : 0000:00:00.5
> >     1fc150000-1fc15ffff : 0000:00:00.5
> >     1fc200000-1fc21ffff : 0000:00:00.5
> >     1fc280000-1fc28ffff : 0000:00:00.5
> >
> > That patch made a fair comment that /proc/iomem might be confusing when
> > it shows resources without an associated device, but we can do better
> > than just hide the resource name altogether. Namely, we can print the
> > device name _and_ the resource name. Like this:
> >
> > 1fc000000-1fc3fffff : pcie@1f0000000
> >   1fc000000-1fc3fffff : 0000:00:00.5
> >     1fc010000-1fc01ffff : 0000:00:00.5 sys
> >     1fc030000-1fc03ffff : 0000:00:00.5 rew
> >     1fc060000-1fc0603ff : 0000:00:00.5 s2
> >     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
> >     1fc080000-1fc0800ff : 0000:00:00.5 qs
> >     1fc090000-1fc0900cb : 0000:00:00.5 ptp
> >     1fc100000-1fc10ffff : 0000:00:00.5 port0
> >     1fc110000-1fc11ffff : 0000:00:00.5 port1
> >     1fc120000-1fc12ffff : 0000:00:00.5 port2
> >     1fc130000-1fc13ffff : 0000:00:00.5 port3
> >     1fc140000-1fc14ffff : 0000:00:00.5 port4
> >     1fc150000-1fc15ffff : 0000:00:00.5 port5
> >     1fc200000-1fc21ffff : 0000:00:00.5 qsys
> >     1fc280000-1fc28ffff : 0000:00:00.5 ana
> >
> > Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > Changes in v2:
> > Checking for memory allocation errors and returning -ENOMEM.
> >
> > Changes in v3:
> > Using devm_kasprintf instead of open-coding it.
> >
> >  lib/devres.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/devres.c b/lib/devres.c
> > index 6ef51f159c54..ca0d28727cce 100644
> > --- a/lib/devres.c
> > +++ b/lib/devres.c
> > @@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
> >  {
> >       resource_size_t size;
> >       void __iomem *dest_ptr;
> > +     char *pretty_name;
> >
> >       BUG_ON(!dev);
> >
> > @@ -129,7 +130,15 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
> >
> >       size = resource_size(res);
> >
> > -     if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
> > +     if (res->name)
> > +             pretty_name = devm_kasprintf(dev, GFP_KERNEL, "%s %s",
>
>    What about "%s:%s"? I suspect it'd be better on the ABI side of things?
>
> [...]
>
> MBR, Sergei

I don't have a particular preference, but out of curiosity, why would
it be better?

Thanks,
-Vladimir
