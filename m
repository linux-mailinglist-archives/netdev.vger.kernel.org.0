Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E338C2683FC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 07:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgINFPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 01:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgINFPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 01:15:15 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD02C06174A;
        Sun, 13 Sep 2020 22:15:12 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x14so16566589oic.9;
        Sun, 13 Sep 2020 22:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8r6tTvopHEdZA7b/XL9XionMWC8QKCfOdEYGKWnAUnE=;
        b=FH2Fr5kFOM+NDZXwETT5H04vimshlrIecvUEFEV2yPqAW7S1EfZAroFEO3xdzYp5vX
         D8WEuXNRYwnU0rUNpkuyvjt6WscaVZirPgZ6z8mqV72gDoesFzRq2nIXNFocYl2qYy3Y
         9+1BnqjZYeNUyIvLbQTO729eojlGSc9OiSp1KdJ9nYGCOk2IRUvE/A1x23xm5LXxG2l9
         Tr8XIaYlpTY38IGWbNh5jcGWcAqOdJkPmmUI1t+BrsP+shX0cM3pyao9N4miLPXS5tox
         lxHo7cuVB8oVFn++ymUXbJFi+Y6PQ5/24JOi5H2MbXQKFUZAN9gcMxOOIUPPGV3Y+Ony
         dytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8r6tTvopHEdZA7b/XL9XionMWC8QKCfOdEYGKWnAUnE=;
        b=ifQVgOAY+7HQGbq4IP886vpnImOFiwg/5aEqEdYzXmWpOcmbGVXhzWB6DFvsEEdXN8
         Ckoj2kXuFYcUt8zNwTrIT8KcDBg1T3cK0CRir0abQHelZFyRhIzB412a9YCTU2f5knvO
         4R2hIUPJXeSqFO14OAP2FZphriUBj22THCpXVyvAGdHP64AxTa2j6siCq6RjnoFSEOBT
         wQeg9X3mMTWVtIkamOmFhR9z+Q8heCXTalhPWfkITIXYvNGNPvgaq+rB376/c2FaDhkh
         99YQ1s8onM1dPAEJrSbzyrSJDsuNGp2vEqBNzgtDOBxVynAWpJ/A1S6nibNT4ezulzi1
         5yOw==
X-Gm-Message-State: AOAM530wklr6YYhjSZTFmx+2kZXGRdjox5aIIuxV1y6k1La3fkiZKPWT
        WYLkcNJ5C7z7fHcThx8voV7uyXUPI/WXxM3NjJM=
X-Google-Smtp-Source: ABdhPJzV/VJMKhG0emkQ7DQt3+lH0TcnhMR7NKHQ6LDD525VuOTGnlsjGDLXvL61vi9UcnKfgCu2yT1PJu6VdIHxbp4=
X-Received: by 2002:a05:6808:3bb:: with SMTP id n27mr7420488oie.130.1600060505270;
 Sun, 13 Sep 2020 22:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200912144106.11799-1-oded.gabbay@gmail.com> <20200912144106.11799-13-oded.gabbay@gmail.com>
 <50824927-c173-4ab9-1cde-1a55ff27c4a8@gmail.com>
In-Reply-To: <50824927-c173-4ab9-1cde-1a55ff27c4a8@gmail.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Mon, 14 Sep 2020 08:14:39 +0300
Message-ID: <CAFCwf13PR7T_PXyJxVsUjG0+5QwhRoxGv4DsbwJQ3NbAux+brg@mail.gmail.com>
Subject: Re: [PATCH v2 12/14] habanalabs/gaudi: Add ethtool support using coresight
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Omer Shpigelman <oshpigelman@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 4:39 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 9/12/2020 7:41 AM, Oded Gabbay wrote:
> > From: Omer Shpigelman <oshpigelman@habana.ai>
> >
> > The driver supports ethtool callbacks and provides statistics using the
> > device's profiling infrastructure (coresight).
>
> Is there any relationship near or far with ARM's CoreSight:
>
> https://developer.arm.com/ip-products/system-ip/coresight-debug-and-trace
>
> if not, should you rename this?
> --
> Florian

We have a cortex A53 inside our ASIC and we use other ARM IPs.
One of those IPs is the CoreSight infrastructure for trace and profiling.
It also provides us with something they call SPMU (performance monitoring).
Those units provide us counters per port with which we provide the statistics.

Thanks,
Oded
