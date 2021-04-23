Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E025368BEC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbhDWETV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWETU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:19:20 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59404C061574;
        Thu, 22 Apr 2021 21:18:43 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id l21so4519848iob.1;
        Thu, 22 Apr 2021 21:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9rzZYVq39OR6Qkj8gqXLwD19tpWV3cWzF0YtPe2dTjM=;
        b=gfiLm60zKUk0E1zjwnRq9DTjBqTOJGkVuT/xyApI/WUJtQsSoVgNpWkk5muLdXHtPZ
         iaxN97bnFWE5dYHZVhlwtuOXyi5h+3dngh5nOFHQSxnVmxIPQCYtPSD2bNKQnmbTU6Cs
         tiumUx7v+M2AFRxhO896b5HRTtk44zo/gPNtONClSTt+W7seilUxqpED7411za6x3RZn
         CO8v9NP6J1XUmiFmwzlIIHAfRx51hm7CJSv+D3BRHiAzfWfVdtzhiC5r7mlaNagv6rOv
         QN5dEgkIISngYr3eVGAECrZXyuV6o2HYZAnwIZ9Xf2Mr4yH237OkGinM/kIW7KuhNlHY
         DfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9rzZYVq39OR6Qkj8gqXLwD19tpWV3cWzF0YtPe2dTjM=;
        b=IvGpO2FyplD6425QsGsfeKbw8tKLsoGAho7TD/124XmetB7c5AZl083UFrF5xwMqmH
         qs7Y+X1jpUHAwv4BBhvL/MaaBlkr30l9CxPS0prLD9FoRzxaQYNIEZuk8s3h9rIMbj2O
         qOwZj+LPoHvdaswBiM69URH31rcYLhIL/1pCbw5IwjM9m6JslFF+klTVC3pkPOZLlTnQ
         XT33yDolAqu/o3B02MRQqpWDpEQTTXmcZWuPYvAyoUg6WJOLUTL7p0c0XtzmoQuFS3WT
         OQ3AWC0gDZelw9Lhx6Fp3eRPL56fQADWOlyxcPiaJozhkZIFNJYWt9dzzN/h9NBrktsI
         Uyaw==
X-Gm-Message-State: AOAM533jEsAk5ZdVMTmE1YTbT7fkQWIMcgYuCmooYXygx6tZKvU2xLKo
        M+vq96GGWE2uZeASAadKm7mm+vN/eGoDcI0xf48=
X-Google-Smtp-Source: ABdhPJyvoO2pw2VSnbVSN1Ed7gAtROTBAk1433lH3abSM0SN9hl7oYq1cfZ0OGgovzbh24m6f97C5qqpgJP+XR0Eh+E=
X-Received: by 2002:a02:662b:: with SMTP id k43mr1903647jac.139.1619151522887;
 Thu, 22 Apr 2021 21:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com> <YIFq2NIhdMWTDshX@lunn.ch>
In-Reply-To: <YIFq2NIhdMWTDshX@lunn.ch>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Thu, 22 Apr 2021 21:18:31 -0700
Message-ID: <CALCv0x1k+Bi+nCY+yJ-n+EYbRW1keRgF35QDNPe-WCO-z8qxBw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/14] mtk_eth_soc: fixes and performance improvements
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:23 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Apr 21, 2021 at 09:09:00PM -0700, Ilya Lipnitskiy wrote:
> > Most of these changes come from OpenWrt where they have been present and
> > tested for months.
> >
> > First three patches are bug fixes. The rest are performance
> > improvements. The last patch is a cleanup to use the iopoll.h macro for
> > busy-waiting instead of a custom loop.
>
> Do you have any benchmark numbers you can share?
No. Felix, do you have anything handy?

If needed, I'll run some tests before and after the patch series on
OpenWrt against v5.10, but I only have an MT7621 device - should be
better than nothing though...

Ilya
