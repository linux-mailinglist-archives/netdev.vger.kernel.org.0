Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493B3FF810
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 07:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfKQGRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 01:17:52 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46143 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfKQGRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 01:17:52 -0500
Received: by mail-lj1-f196.google.com with SMTP id e9so15067788ljp.13;
        Sat, 16 Nov 2019 22:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+KlNDU4GhURnC5GINda7EPChAxGdO7YxXWlWxudAQPg=;
        b=IYSGNgsVE+JiqMqNFV7kEeMO2IUYpHJvcp9hmeVVR8BfRXtuqkmth62RNzdXoWxHFe
         rG+uCeCf2s8q/xVoYNAVtxH8D24LKn0Bk3M6MW8h9F1cC1KgxoHE8+Hcwxn6NyhEhnoD
         xAOoQsXE2vJvBmvZSnQWJ74I5V3Sm2SDsC2J1QVr3R2gG9rtChOZkpQvwXaIaB/T9egf
         qDAM4pnWpqlZQqir3rEakrPGN6COkEjtqCBrt0WtFTEpe4dRXVu2tfDfzxEiSLBSCT4J
         cocasK3rYFKtJ4DogbOTCl7O5e4rl/GcFj2lAH7HbF2Ldd3B5xX9VUqWCGTKurJl9EMm
         5zYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+KlNDU4GhURnC5GINda7EPChAxGdO7YxXWlWxudAQPg=;
        b=MxQ9siCc0KeifXxBjbibOaI/NIWFPRRvCQoV0l1gKPk7pXqfqI7LArbHctSLcwXlHZ
         8BIYd1lrraJRqwwhHzrl3uX/Wcn190k6uflSaSAvK5YddzZ28dgHbhDX8oIIGsA7nDpq
         1zpYFFbMl46wE4FvGwr6H2kpeMEmvNT0R2AkyKS6bYnW1Wp7xg/hMwmyQPKC00DvIStg
         IdmlbEDCR1wi3XsM9lIo96IAupPiAWPO94h9rk8g++yXRd/hGwpAmLbSBKl+0rSnWH2d
         Pvcu/s91rbUNT1jcTK/5LfthoQbwGqvu2aXaazcEzHsIOwMpVJaNWP9Te16bqA4PFZoF
         /ixQ==
X-Gm-Message-State: APjAAAVDQXQBecLV0DgfXvj67rVY494vqRrfJGoVYOjaTA48f30/ynek
        8pnxTwwDVg85AD0+nhEMMieIXfQP8cfBLfxWoJk=
X-Google-Smtp-Source: APXvYqwEYRdJbHR9zhs3rg5hfCEpeaAWtBSFUHzVCmMviuOPd2+txD4FcFcw9AdwWR2NS0WJQjJxq1p9PUOyzVItvn4=
X-Received: by 2002:a2e:8103:: with SMTP id d3mr17063095ljg.222.1573971470270;
 Sat, 16 Nov 2019 22:17:50 -0800 (PST)
MIME-Version: 1.0
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com> <20191116.125316.1859622454319892445.davem@davemloft.net>
In-Reply-To: <20191116.125316.1859622454319892445.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 17 Nov 2019 15:17:38 +0900
Message-ID: <CAMArcTWUV1iZuACs0FTwC1jdFYSupPNsaV+9E_HQta1Vdyh6gg@mail.gmail.com>
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
To:     David Miller <davem@davemloft.net>
Cc:     wangxiaogang3@huawei.com, dsahern@kernel.org, shrijeet@gmail.com,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        hujunwei4@huawei.com, xuhanbing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Nov 2019 at 05:53, David Miller <davem@davemloft.net> wrote:
>

Hi David,
Thank you for Ccing!

> From: "wangxiaogang (F)" <wangxiaogang3@huawei.com>
> Date: Fri, 15 Nov 2019 14:22:56 +0800
>
> > From: XiaoGang Wang <wangxiaogang3@huawei.com>
> >
> > Recently we get a crash when access illegal address (0xc0),
> > which will occasionally appear when deleting a physical NIC with vrf.
> >
> > [166603.826737]hinic 0000:43:00.4 eth-s3: Failed to cycle device eth-s3;
> > route tables might be wrong!
> > .....
> > [166603.828018]WARNING: CPU: 135 PID: 15382at net/core/dev.c:6875
> > __netdev_adjacent_dev_remove.constprop.40+0x1e0/0x1e8
> > ......
>
> Taehee-ssi, please take a look at this.
>
> It is believed that this may be caused by the adjacency fixes you made
> recently.
>

I will take a look at this
Thank you!

> Thank you.
