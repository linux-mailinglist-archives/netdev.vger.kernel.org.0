Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FBF1EA19F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFAKNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFAKN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:13:29 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BE9C061A0E;
        Mon,  1 Jun 2020 03:13:28 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a25so1483791ejg.5;
        Mon, 01 Jun 2020 03:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqNUR4MSIicJxwTqODWkb4nWYD+Gqo3yaTC/YrSgY/0=;
        b=kEsmvL3l8qAXlCshnoFKub+/k14frs+Or7UVObjs02NciMlf4ttW8sCYpDnBb5/yvS
         F5Ds+SSQOQatY0eT/p/1DjG0iGizMlwcsGoUQ7OPcNq5lbReTw92VCcWCAjVOaE6y21X
         vWovueUYHKyS7pLps57cpaOJm0bn1QedBHAahtv6gr7SRRPgiUPrje06HXcDjdhmEpN3
         E6HMxSoBptXzQvquBH7rXD4uljs0M+M9S8ywi2GuMxXc1jHkYk7yAqRBQwjFRMssuqJa
         19+G0pgWtB9h15VHTJylKzLnRAE48u9+IGrbNUJJ4G/yBm7B7ZU5f1SFKS3ugI97XdhW
         twGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqNUR4MSIicJxwTqODWkb4nWYD+Gqo3yaTC/YrSgY/0=;
        b=gO1p+YjJ5mOxL4jYQnT+tSgR7bzwpQs0z3gsRHf91GlDUDSRegucYe9O99u9U/KnCx
         yi03yTaq3aul0YAw3Js/92B8Q1dZA+n2mH1ZJBSyL+lNKNTG8tZ9Q4vMzqpcUGK2ifsb
         strHolG2Lml1bvVY5u1ThzACdqmsz4hbkTBAYE+zaaq9QD3ZdsyB2Br/xyU8UtDgZfOu
         pEqVM1g62AsvFM7GrJUwDHOqAfl8fH1D+Qx5HZENZkAZza22686YbH/NAhGyixr0sP1S
         qWkfGO+xGYVIWIZ6aJaGuYFs4Xy/B5zIfmpeSQoHlv195iIo0z1tHg4pk4Sbb0+ATCPh
         5KiQ==
X-Gm-Message-State: AOAM531dE3TZOOZwSzA+A6BneNpU8wKG0kKhvkqQf2ubZIknZC7mxDZe
        eeNBDahQEkD7Y1c5VTNczKolvAheJF9P1Qe3vmU=
X-Google-Smtp-Source: ABdhPJyr/p3kIEUH9CTjnMMnEFMFj6ZcOeiUQGXAUKlOKgg3JtX4ZI7CWVx4TkOCbfJV1wzv9ChAQyU1KmE4tDXGMPY=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr18249609eji.305.1591006407219;
 Mon, 01 Jun 2020 03:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200601095826.1757621-1-olteanv@gmail.com> <20200601100441.GA1845725@kroah.com>
In-Reply-To: <20200601100441.GA1845725@kroah.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 13:13:16 +0300
Message-ID: <CA+h21hp2UmMqE_=Ky5J=B=X-ZdU78Fp52zb=vWEPGw9CbcjjVw@mail.gmail.com>
Subject: Re: [PATCH v3] devres: keep both device name and resource name in
 pretty name
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        sergei.shtylyov@cogentembedded.com, bgolaszewski@baylibre.com,
        mika.westerberg@linux.intel.com, efremov@linux.com,
        ztuowen@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Mon, 1 Jun 2020 at 13:04, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 01, 2020 at 12:58:26PM +0300, Vladimir Oltean wrote:
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
>
> As this is changing the format of a user-visable file, what tools just
> broke that are used to parsing the old format?
>

All the same tools that broke after 8d84b18f5678 was merged. I am not
entirely sure why the 'stable ABI' argument was not brought up there
as well.

> And are you sure about this?  That's not how my system looks at all, I
> have fun things like:
>
>    ac000000-da0fffff : PCI Bus 0000:03
>     ac000000-da0fffff : PCI Bus 0000:04
>       ac000000-c3efffff : PCI Bus 0000:06
>       c3f00000-c3ffffff : PCI Bus 0000:39
>         c3f00000-c3f0ffff : 0000:39:00.0
>           c3f00000-c3f0ffff : xhci-hcd
>       c4000000-d9ffffff : PCI Bus 0000:3a
>         c4000000-d9ffffff : PCI Bus 0000:3b
>           c4000000-c40fffff : PCI Bus 0000:3c
>           c4000000-c400ffff : 0000:3c:00.0
>           c4000000-c400ffff : xhci-hcd
>           c4010000-c4010fff : 0000:3c:00.0
>           c4011000-c4011fff : 0000:3c:00.0
>           c4100000-c41fffff : PCI Bus 0000:3d
>           c4100000-c410ffff : 0000:3d:00.0
>           c4100000-c410ffff : xhci-hcd
>           c4110000-c4110fff : 0000:3d:00.0
>           c4111000-c4111fff : 0000:3d:00.0
>           c4200000-c42fffff : PCI Bus 0000:3e
>           c4200000-c4207fff : 0000:3e:00.0
>           c4200000-c4207fff : xhci-hcd
>           c4300000-c43fffff : PCI Bus 0000:3f
>           c4300000-c437ffff : 0000:3f:00.0
>           c4380000-c4383fff : 0000:3f:00.0
>           c4400000-d9ffffff : PCI Bus 0000:40
>       da000000-da0fffff : PCI Bus 0000:05
>         da000000-da03ffff : 0000:05:00.0
>         da040000-da040fff : 0000:05:00.0
>
>
> which is a mix of the resources in some places, and just driver names in
> others.
>
> But, that does imply that your change will not break anything as the
> parsing of this mess is probably just "anything after the ':'
> character...
>
> thanks,
>
> greg k-h

With this patch you'll just have more (potentially redundant)
information. I'm not really sure how to satisfy everyone here. I was
completely fine with pre-8d84b18f5678 behavior.

Thanks,
-Vladimir
