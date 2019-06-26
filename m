Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3538F5728A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFZUYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:24:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60473 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfFZUYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:24:47 -0400
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hgETF-00018o-97
        for netdev@vger.kernel.org; Wed, 26 Jun 2019 20:24:45 +0000
Received: by mail-wr1-f70.google.com with SMTP id v7so35661wrt.6
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 13:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q8e0cQcjtNecIM29dBcL0Lfdw9lK8pi0Bnd8zPrOvpQ=;
        b=aChIm/1TCbUYMtwz5P8VHoY5463eEwLtS3/KSHDAfs5YVeyknfr7hFsH1NorrnathR
         YtGsb+K6IEfc0arkjkN8RnRFvBuPAm01SpIyy43TAacRVvHlkEEAUZRaSf4Rd/HBqMaq
         WYC7zg7GzppungY/agczHuNs/KRbY5suXavPf0mc/fk/gfLE+uN9446xlm8hu/EvKh+p
         czsOUsbjJe8/ys7zysWOPIA0rselkYxWG+jXCe3RgsHYBauV2+ViUD3GwuhEzFT5PI5J
         N3LZ94J7tFepML0lhTcn/nqgUnJPzhyX/gX2gNtt6SWxz8L8pmOLa+0wQ+pisZoQhzwY
         jDJQ==
X-Gm-Message-State: APjAAAXiiB7ji5gWZlrZ9q6dh9ESacBc6Rzu+wS+uzVxxDi4OIl8FQFG
        A4+CHmvw3BzZDFnctqLRRasUMTKC3JJLd0cN3TzaERyIQoNfWf6xUtbUcI1j1eg9Ex98yig/yyh
        uSH1d492VRwv3bmXyji+CtB8UOsehJE6Tj5tr0iyAMIA1CWgaFw==
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr5067709wrv.114.1561580685058;
        Wed, 26 Jun 2019 13:24:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyHEhQq4Nh6haEIn99u4e89QGD/+sHLbj6xDuJPIADSkG0N7U8A+xyjKhWG+gkA3vLgrOTnX5ldr8jUpKvREIA=
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr5067702wrv.114.1561580684914;
 Wed, 26 Jun 2019 13:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190624222356.17037-1-gpiccoli@canonical.com>
 <MN2PR18MB2528BCB89AC93EB791446BABD3E30@MN2PR18MB2528.namprd18.prod.outlook.com>
 <CAHD1Q_y7v5fVeDRT+KDimQ-RBJMujMCL2DPvdBh==YEJ3+2ZaQ@mail.gmail.com>
 <CAHD1Q_y5wWqOkPaC+JsuGMfBHbwPHbQF93Y-+06Nck=HKrif2g@mail.gmail.com> <MN2PR18MB2528569269272880338B8E4CD3E20@MN2PR18MB2528.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB2528569269272880338B8E4CD3E20@MN2PR18MB2528.namprd18.prod.outlook.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Wed, 26 Jun 2019 17:24:08 -0300
Message-ID: <CAHD1Q_wzNDnzStrbjng8CFx3jHhjAYqyr04OGzZGJ2SisY2VCQ@mail.gmail.com>
Subject: Re: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled indefinitely
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 5:25 AM Sudarsana Reddy Kalluru
<skalluru@marvell.com> wrote:
> > Sudarsana, let me ask you something: why does the register is reading value
> > 0x0 always in the TX timestamp routine if the RX filter is set to None? This is
> > the main cause of the thread reschedule thing.
>
> The register value of zero indicates there is no pending Tx timestamp to be read by the driver.
> FW writes/latches the Tx timestamp for PTP event packet in this register. And it does the latching only if the register is free.
> In this case user/app look to be requesting  the Timestamp (via skb->tx_flags) for non-ptp Tx packet. In the Tx path, driver schedules a thread for reading the Tx timestamp,
>    bnx2x_start_xmit()
>    {
>         if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
>                         schedule_work(&bp->ptp_task);
>    }
> FW seem to be not timestamping the packet at all and driver is indefinitely waiting for it.
>

Thanks Sudarsana! I've tried to implement the qede-like approach
again, with the 2s timeout before
bailing-out the thread reschedule. This time, I've remove _all_log
messages, including the DP() ones...
Unfortunately kthread is still consuming 100% of CPU, which makes
sense, since it reschedules itself
the most times it can in this 2s window...I think we really should
have small pauses before retrying to
read the registers. I've worked a V3, implementing 1ms-starting
pauses, which worked well:
https://marc.info/?l=linux-netdev&m=156158032618932

I hope this way we don't harm the PTP applications, nor introduce
delays in the FW wait-queue,
and at same time we can fix the indefinitely reschedule in bnx2x.
Thanks again for your support,


Guilherme
