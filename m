Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1102A880A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732240AbgKEUZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgKEUZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:25:04 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AA1C0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 12:25:04 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so4532547ejb.7
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 12:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTjGrprXf/p+7VyJhV9oMQ+mFbRhaf2fd3YnoA+5GTw=;
        b=nrTaXxU+KLiCkwx2prOFqV6fVNRvkt5LEXE3aJxYrnO2FaLmSlKykM2nD1VEHY+PCQ
         QZGQ264x0qIXVF81JCYUR+VVO7S8yrUTIZzsIQP1XjKW7ZnbKrcSIDGcekNi0/QN+Wi1
         umCtdtcvNp7N7oKFBY7ovM8/6KuFP19oZZtIMdtEHAe9gkMfdf0zXP/XG7XkmqyqyEET
         yiPVGpmDHkMUkkcO4CfP7ptPpIEZSxzVMeJfkVuZN3qdNRIA2J+44ZmjcynfBkYklljK
         z/bGMUhRsrYu1+Lh5B90G9zhw5bF2ZMr3Oms5WH5RZF9Ntp3/4NthuRrpgwbmj7n8Ufd
         f4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTjGrprXf/p+7VyJhV9oMQ+mFbRhaf2fd3YnoA+5GTw=;
        b=XK44/dTqbDSx6WcsUg66aqnSiB2mhBJHunNz29PwoChE41uQ55NLjG9I6e3UPPiOPP
         Y1gXk6ol2g2cguliXOSUuQaaD4l+uWHjFyl0FFDZz2Q7YK8N+Qo6U0H2T8ed51uSHipe
         oT/GXP5A+F755nFzS2OLdI9iRNbhjm3bQOmCQVfoqhqmbusg5/fEvbJvtimC6POpMPey
         InYdyHz18OzUk7tS5jZzaIe24nso9pHWh2ZZ86W/2ApxoN3r3WUb38uRTczlwbzPwEEU
         tTH1aJUvzXxfwdvWE7LrHDKPoEXaBHo234BSN3nRTp7XwCN/asKAWpRICgl3H6pQpv2F
         drEA==
X-Gm-Message-State: AOAM530NJE+CCumEm7+5GPjlD8GsrqLZxkfi2B9G7VGknPx8DOvT+3EJ
        4QM3h740pVAb9anWIyOYY72wuuIRaQyxJ3u2CvKtQA==
X-Google-Smtp-Source: ABdhPJzI9LfCzCLX7f+iSxdraoDOaNdVltw0kDFCO6PfxopQK7HxBYytXTWKPFOHrLUr2ii9D/9tKushc/1x+YBdX90=
X-Received: by 2002:a17:906:4306:: with SMTP id j6mr4207795ejm.523.1604607902859;
 Thu, 05 Nov 2020 12:25:02 -0800 (PST)
MIME-Version: 1.0
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com> <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <20201105094719.GQ5429@unreal> <CAPcyv4hmBhkFjSA2Q_p=Ss40CLFs86N7FugJOpq=sZ-NigoSRw@mail.gmail.com>
 <20201105202214.GA1339091@kroah.com>
In-Reply-To: <20201105202214.GA1339091@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 5 Nov 2020 12:24:51 -0800
Message-ID: <CAPcyv4j0Xih_wd5R8KYmWv6ty-WKxVbV54HZqr81+UqSm96LzQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 12:21 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 05, 2020 at 09:12:51AM -0800, Dan Williams wrote:
> > > >
> > > > Per above SPDX is v2 only, so...
> > >
> > > Isn't it default for the Linux kernel?
> >
> > SPDX eliminated the need to guess a default, and MODULE_LICENSE("GPL")
> > implies the "or later" language. The only default assumption is that
> > the license is GPL v2 compatible, those possibilities are myriad, but
> > v2-only is the first preference.
>
> No, MODULE_LICENSE("GPL") does not imply "or later" at all.  Please see
> include/linux/module.h, it means "GPL version 2".
>

Oh, I did, and stopped before getting to:

  "only/or later" distinction is completely irrelevant and does neither
 *replace the proper license identifiers in the corresponding source file

...sorry for the noise.
