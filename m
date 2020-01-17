Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CC5140254
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 04:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgAQDdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 22:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgAQDdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 22:33:42 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E168B2083E
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 03:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579232022;
        bh=4Ffa54piw5frE9/sLOsztZ+V22ux5QW/TVxav8XeBoU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dNxkj6TaZHfDKz2w61DB2BsE7Hr+a3WZ/WRuOznInthUpu/aMzydE+il4q3eztaHZ
         uh/XkdVXm5d6ZzdqZ8XJ1TLt3OKk7H+3+FaDuu0NJ1O/GdAWWe4D6pujVirOyeHlHr
         npTNd4qpH571YFihmUUAz+xPWZb3TY5BCG4xL0uQ=
Received: by mail-wm1-f46.google.com with SMTP id f129so6079525wmf.2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 19:33:41 -0800 (PST)
X-Gm-Message-State: APjAAAUxjwYhUykbXsm5NxD2C0h4Vxgx+qa1kwYHZx+JzYbnySPilP8L
        V2qD0cQ5utdMnUc2P8E0ST4bxU9oCB8zWHNUUVo=
X-Google-Smtp-Source: APXvYqyxhY0xUdQ0kbquK/JIWiKm+mqwoI6dikSE5UxcCT0vrGjLP8OOhZfcRDY4FFrW78eVh6xZmWiG2IrAhmrJ0uc=
X-Received: by 2002:a1c:44d5:: with SMTP id r204mr2229397wma.122.1579232020382;
 Thu, 16 Jan 2020 19:33:40 -0800 (PST)
MIME-Version: 1.0
References: <20200116005645.14026-1-ajayg@nvidia.com>
In-Reply-To: <20200116005645.14026-1-ajayg@nvidia.com>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Fri, 17 Jan 2020 11:33:30 +0800
X-Gmail-Original-Message-ID: <CAGb2v64hEN5=2FdxzMLfZm7RT68-+YZ70-_3fCPUyZ47C-9m1g@mail.gmail.com>
Message-ID: <CAGb2v64hEN5=2FdxzMLfZm7RT68-+YZ70-_3fCPUyZ47C-9m1g@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: platform: use generic device api
To:     Ajay Gupta <ajaykuee@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Ajay Gupta <ajayg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jan 17, 2020 at 2:21 AM Ajay Gupta <ajaykuee@gmail.com> wrote:
>
> From: Ajay Gupta <ajayg@nvidia.com>
>
> Use generic device api to allow reading more configuration
> parameter from both DT or ACPI based devices.
>
> Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
> ---
> ACPI support related changes for dwc were reently queued [1]
> This patch is required to read more configuration parameter
> through ACPI table.
>
> [1] https://marc.info/?l=linux-netdev&m=157661974305024&w=2
>
>  .../ethernet/stmicro/stmmac/stmmac_platform.c | 49 +++++++++++--------

Even after your changes, there's still a lot of DT specific code in
there, such as the MDIO device node parsing. Plus the whole thing
is wrapped in "#ifdef CONFIG_OF".

Maybe it would make more sense to split out the generic device API
parts into a separate function?

Regards
ChenYu
