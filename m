Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9011E2AD1EB
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 09:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgKJI5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 03:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJI5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 03:57:41 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13162C0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 00:57:41 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id s25so16372754ejy.6
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 00:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lQe8pWfr9V0QzwZT/GnDX5RNtwOFA1stDWOmnFmNL4k=;
        b=DEYrxPCIaBBikBWRYa/xIio87HokJTdxer2U8FROiQIIhqaJcffj8L5xbSlxQ/MevF
         zGxfY6mfWf2sP4M2u8mhNL5W/8HeoRlPqNA2K7sRt5SruuaIrAApo9PEbEn4MUxawbzg
         jHyLOIKM6z71V6IzBhtk0+cpBdps8Sz68CVq0fCuB1Egk8OpUN9A3NFAC2oYDWlzYUBc
         armc/9LAke+Lgi0z7i8XITZRfyzyDN4muYUEgV7q89LB227gPdxGexuNVtJKYdE1FXyR
         r5B/jUIhrie7rtYzN6mxtcfCPAWcn++3uFsWfB2HcsVavgHAjaIry96cDSdYYw8voKUb
         iOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lQe8pWfr9V0QzwZT/GnDX5RNtwOFA1stDWOmnFmNL4k=;
        b=bG4BPv/yP0nbrN9+vKOfyJ7i7evjWWQARsMf9mV6pBuPjXZ7/Nh0W/jTNQ6Jem3clL
         Y/T3uP4QmNOj1+4dDckkP1f8JjrkTq8KPuuvzSFySSTfhvq4uyA8HlkvbcdSVI7F0uCH
         qrEC0leen1m/nQ3pPErCWVM1FIGNbuXmhBkJWfw/PbwR92feToRCNi8DpcuqHRUl7FtH
         Rl/IF86SQwzD+qrDvxiBDG4mqOvk20ieQDhyol7NC5gsJSF5H1Ib/whiisTt2Vhzve6V
         wGLqLFBlHgy7scA1OjLNXfjhYXU75MfONyyGJq0S4xxRSR389sIt+DMeuBzVfbPMwxXi
         BOFw==
X-Gm-Message-State: AOAM531eK0+kUgM++6ZEhsuX+L5GvBA8rSNmS+Im+1AsqCEFHu+XfEcf
        wxbBsI1tb+uXo+Uhj3n3SjIVdO/+lS/VvhqN4kJ/ag==
X-Google-Smtp-Source: ABdhPJzZSNVHdUWkL/yVcwvPoxplb8Ehvk16h7MQolXU4XOFA5tTy3nwkTX8ckokUKSFB2n58mqkfuEEoZ/2vKtr3lk=
X-Received: by 2002:a17:906:1f53:: with SMTP id d19mr18788079ejk.255.1604998659714;
 Tue, 10 Nov 2020 00:57:39 -0800 (PST)
MIME-Version: 1.0
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
 <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi-5Qp7jOHDZLZoWKJ4zwU6Sa9ULAts0eY6ObCu91Awx+w@mail.gmail.com> <20201109103946.4598e667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109103946.4598e667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 10 Nov 2020 10:03:29 +0100
Message-ID: <CAMZdPi88N8WjA7ZEU0X_dhX_t-kXkAjhnhjzK7TY7HCurrLSqA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] net: qrtr: Add distant node support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        cjhuang@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, 9 Nov 2020 at 19:39, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 9 Nov 2020 09:49:24 +0100 Loic Poulain wrote:
> > > Looks like patch 1 is a bug fix and patches 2-5 add a new feature.
> > > Is that correct?
> >
> > That's correct, though strictly speaking 2-5 are also bug fix since remote node
> > communication is supposed to be supported in QRTR to be compatible with
> > other implementations (downstream or private implementations).
>
> Is there a spec we can quote to support that, or is QRTR purely
> a vendor interface?

There is no public spec AFAIK, this is a vendor interface.

> What's the end user issue that we're solving? After firmware upgrade
> things stop working? Things don't work on HW platforms on which this
> was not tested? Don't work on new HW platforms?

QRTR is usually something used in SoC context as communication
protocol for accessing the differents IPs (modem, WiFi, DSP, etc)
around the CPU. In that case, these components (nodes), identified
with a 'node ID', are directly reachable by the CPU (QRTR over shared
memory). This case is not impacted by the series, all nodes beeing CPU
immediate neighbours.

But today QRTR is no more a ARCH_QCOM thing only, It is also exposed
as communication channel for QCOM based wireless modules (e.g. SDX55
modem), over PCIe/MHI. In that case, the host is only connected to the
Modem CPU QRTR endpoint that in turn gives access to other embedded
Modem endpoints, acting as a gateway/bridge for accessing
non-immediate nodes from the host. currently, this case is not working
and the series fix it.

However, AFAIK, the only device would request this support is the
SDX55 PCIe module, that just landed in mhi-next. So I assume it's fine
if the related part of the series targets net-next.

Regards,
Loic
