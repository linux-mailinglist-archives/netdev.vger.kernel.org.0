Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFCA274BD8
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIVWFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:05:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726629AbgIVWFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 18:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600812314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HuDu6VLipkoXjOvX2ydRAsRN46ZNECZq7n9nX0XdnI=;
        b=K9YFCvRyRtZ+nAFcyjOo1zRHreHcjNEcMaoFHYrz4vMknwVSIZWS1XgM5QyUSdJnVVJXFI
        Au9maU65hgc0OIXEaorDArlVSpUaBQaMDs214G7SRDuxZz5O+jxWiMYwJ32TNjin4T1t62
        IpSlrh09aTIS2gghyeIEGaySS1KH2YU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-BN1CWey_PF67A3VcsB7tIg-1; Tue, 22 Sep 2020 18:05:12 -0400
X-MC-Unique: BN1CWey_PF67A3VcsB7tIg-1
Received: by mail-ot1-f71.google.com with SMTP id y12so4028848oto.22
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 15:05:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1HuDu6VLipkoXjOvX2ydRAsRN46ZNECZq7n9nX0XdnI=;
        b=UMIwAQaBiD781GEVrmpJkdw9Qudwj1xmlS86oBaJvrXAgxj2THYrIClt/ukPWdGVyZ
         t+WLHh8ev4pn4srWF5eoOtErNmyrck/mHHh/2O4SjT4m7YfHcYDqyOKLaO2I0CDFrGop
         Y8dVnIRVSURbpcUUnY9K4CnOJvpHN9oGMMziFSJ9pOOFIbzn8iJ/nN62g5dyi6uAzDSm
         q0SR2YnQwnnzRg/KopJqFsqt0VrR922Wwojec1wmJBG5fHAlR6UF6QpSCBqI1UBPC7s3
         0dlGjKXxDsRJcdC/NpaIHVzaTjUcKp3Tp/MuO1mCFoCQpZSdLniRWRvMOp5FKbV+BEvD
         2chA==
X-Gm-Message-State: AOAM5331pV/a/me8y8OA4ffSKmGHDOBrwTXGEuZEixO0X6XnYwuauDO7
        JVdI+eCUnFfq/LJXk+zpKuod3PkdbJ7ABlQLdKkXtuX6uWeA9XIm99KiNZZQqDdBJzE1JSsLRLl
        1e7SucpekVTIhvUdbYRDUcMMZGsX2TD42
X-Received: by 2002:a4a:a385:: with SMTP id s5mr4526256ool.8.1600812311423;
        Tue, 22 Sep 2020 15:05:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFQQl79LZqD9ewINDxufXtajraSG49Z623jpMmetiwrW8RQQFJ+ZMcncq7gan5aXrAJDcTlr/7rNTZ7uMT/Ok=
X-Received: by 2002:a4a:a385:: with SMTP id s5mr4526237ool.8.1600812311133;
 Tue, 22 Sep 2020 15:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200922133731.33478-1-jarod@redhat.com> <20200922133731.33478-5-jarod@redhat.com>
In-Reply-To: <20200922133731.33478-5-jarod@redhat.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Tue, 22 Sep 2020 18:05:00 -0400
Message-ID: <CAKfmpSfv8L46MjYHfUCMcz+Wxed4EpO1FEu8NjqVU6W8_m9E=w@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] bonding: make Kconfig toggle to disable
 legacy interfaces
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 9:38 AM Jarod Wilson <jarod@redhat.com> wrote:
>
> By default, enable retaining all user-facing API that includes the use of
> master and slave, but add a Kconfig knob that allows those that wish to
> remove it entirely do so in one shot.
> diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
> index abd265d6e975..91ece68607b2 100644
> --- a/drivers/net/bonding/bond_procfs.c
> +++ b/drivers/net/bonding/bond_procfs.c
> @@ -7,6 +7,12 @@
>
>  #include "bonding_priv.h"
>
> +#ifdef CONFIG_BONDING_LEGACY_INTERFACES
> +const char *linkdesc = "Slave";
> +#else
> +const char *linkdesc = "Link";
> +#endif

I've been asked if it would be okay to add extra lines to the
/proc/net/bonding/<bond interface> output, so that for example, both
"Slave Interface: <interface>" and "Link Interface: <interface>" are
both in the default output, with the Slave bits then suppressed by the
Kconfig option being unset, versus the Kconfig option currently
swapping out Slave for Link when disabled. It would bloat the output
by a fair number of lines, but all the same data would be there and
parseable. Wasn't sure on this one, so I wanted to check on it. If it
would be acceptable, I'll rework that bit of code.

-- 
Jarod Wilson
jarod@redhat.com

