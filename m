Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEEE52240
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfFYEo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:44:58 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35306 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFYEo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:44:57 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so15933516otq.2;
        Mon, 24 Jun 2019 21:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Wp4HQypqw0rNbItr1Xs0WBR6fHG0G9gjAl5KxurVdE=;
        b=ICNF3PTZ1ZfG+bAeY8F8Pp7sQzesnEsLfQyVK4xXEW0fE9JbdoeEwICCri9MhuwgDe
         bm/0ejdD98vhkuaDReGiErs7EaKJphiOdNIOX5OTwKFKRbuUyOxVIAk4bHBff8k+v4sW
         T7OmIR81tdf3Fy8cR5DX0+mQ0tZ/Wu4tdvEcn1ySqLThg5Z+Cqiyv07RISHe3YwpWKkU
         mNX0GQfIvmuXGqm24S4OcATnGcJC5dp2nIjKXJ/eVlclscTS4ifWJKJt3gXQIn8V6JDV
         mBBDQVVDx+ijpZkFkPqRJLSkoToQRF0nF2/Dh+zYJ2NvIUQ+MXj1dcWGXJ7WX+IKrAi0
         Ackw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Wp4HQypqw0rNbItr1Xs0WBR6fHG0G9gjAl5KxurVdE=;
        b=Xv186QGPgZP13JAw3vR3DBIJoOTcqbIY4jRNPEBRir2O3epY3OQvJUiFqxRaKKV1xj
         C38jEqXAfy6wujtyZdBzMqnixEtVMbIYJO5s2tHDWqIQ/EV+CmWWc8GAFEAjBJ6opjNH
         UvrLyl0s7mGX6iLpd7Fxr/AJXhnfRMNGdF2F3R/+AdcGmgeO3PBW/lQiRKnVIoWB82Ig
         b4/ysTvtNUVi+9F9m0X5g7QJsXyFYT7pq61L4Vj4AzDrDWQxgP+Fmu2ZqJxpVr8MhZXs
         Nu4SJvPnHS9pWn2tyTl20upmR02WPy5dsAvYA4C9wsKYBVWoWQXkAIa5eYeS7eySVmEv
         /Agw==
X-Gm-Message-State: APjAAAVo9zEl5O5telJB5IZaLgCAmVsHKOstqNaqZLUDiGZa1bcOK49O
        C48aMcu5GvZG/ie3bbY4W3yuArIcuUI9W+KaaMzC0Y8C
X-Google-Smtp-Source: APXvYqxsOdEMaHKmim8mpE6aFtY/5w9wT+CBAa2iQ2fftmNQo7l1oux8418VMI5kU7usdjz86T8c871EA6XxIf+xwSc=
X-Received: by 2002:a9d:14a:: with SMTP id 68mr70034647otu.96.1561437896776;
 Mon, 24 Jun 2019 21:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190617165836.4673-1-colin.king@canonical.com>
 <20190619051308.23582-1-martin.blumenstingl@googlemail.com>
 <92f9e5a6-d2a2-6bf2-ff8a-2430fe977f93@canonical.com> <CAFBinCDmYVPDMcwAAYhMfxxuTsG=xunduN58_8e20zE_Mhmb7Q@mail.gmail.com>
In-Reply-To: <CAFBinCDmYVPDMcwAAYhMfxxuTsG=xunduN58_8e20zE_Mhmb7Q@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 25 Jun 2019 06:44:45 +0200
Message-ID: <CAFBinCC-LLpfXQRFcKBbUpCfKc0S9Xtt60QrhEThsOFV-T7vFw@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: add sanity check to device_property_read_u32_array
 call
To:     Colin Ian King <colin.king@canonical.com>
Cc:     alexandre.torgue@st.com, davem@davemloft.net, joabreu@synopsys.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        peppe.cavallaro@st.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Thu, Jun 20, 2019 at 3:34 AM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> Hi Colin,
>
> On Wed, Jun 19, 2019 at 8:55 AM Colin Ian King <colin.king@canonical.com> wrote:
> >
> > On 19/06/2019 06:13, Martin Blumenstingl wrote:
> > > Hi Colin,
> > >
> > >> Currently the call to device_property_read_u32_array is not error checked
> > >> leading to potential garbage values in the delays array that are then used
> > >> in msleep delays.  Add a sanity check to the property fetching.
> > >>
> > >> Addresses-Coverity: ("Uninitialized scalar variable")
> > >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > I have also sent a patch [0] to fix initialize the array.
> > > can you please look at my patch so we can work out which one to use?
> > >
> > > my concern is that the "snps,reset-delays-us" property is optional,
> > > the current dt-bindings documentation states that it's a required
> > > property. in reality it isn't, there are boards (two examples are
> > > mentioned in my patch: [0]) without it.
> > >
> > > so I believe that the resulting behavior has to be:
> > > 1. don't delay if this property is missing (instead of delaying for
> > >    <garbage value> ms)
> > > 2. don't error out if this property is missing
> > >
> > > your patch covers #1, can you please check whether #2 is also covered?
> > > I tested case #2 when submitting my patch and it worked fine (even
> > > though I could not reproduce the garbage values which are being read
> > > on some boards)
in the meantime I have tested your patch.
when I don't set the "snps,reset-delays-us" property then I get the
following error:
  invalid property snps,reset-delays-us

my patch has landed in the meantime: [0]
how should we proceed with your patch?


Martin


[0] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c?id=84ce4d0f9f55b4f4ca4d4edcbb54a23d9dad1aae
