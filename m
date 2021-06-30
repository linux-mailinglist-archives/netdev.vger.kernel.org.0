Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21003B81FE
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhF3MYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:24:13 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60021 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbhF3MYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:24:12 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MmUcL-1lYXsV2q7l-00iVws; Wed, 30 Jun 2021 14:21:42 +0200
Received: by mail-wr1-f51.google.com with SMTP id a13so3362430wrf.10;
        Wed, 30 Jun 2021 05:21:42 -0700 (PDT)
X-Gm-Message-State: AOAM530WakbCHpA1tgG69QVBM7Pw0X7PUFrYEpnT4JUnfBIQlnUcyOVH
        nxgT4g5+suYjbRisJcd9jXMfOo1Q1i6XWKbOWq8=
X-Google-Smtp-Source: ABdhPJzbMwqO0UqMwf08cToMR/xIYXkh4mMK63b049cBHLY2kvkRRGsefeAfve5VBN+0PclfxL041WfPnXFS6N7HuDs=
X-Received: by 2002:adf:ee10:: with SMTP id y16mr1601608wrn.99.1625055702317;
 Wed, 30 Jun 2021 05:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210622202345.795578-1-jernej.skrabec@gmail.com>
 <CAK8P3a1mvRTTFHtxqREmcbgJS+e94BHajCtAU_fzBhNNKjJBcg@mail.gmail.com>
 <CAPDyKFqFTCzXFMar88CYdZKc=eMjKszsOCS1LwLmnF0uNQyPAw@mail.gmail.com>
 <CAK8P3a2yo6eAe+jZQ7XB9ERYOYvBdCfjMKCYgm=gh-Ekd=SQ3Q@mail.gmail.com> <CAPDyKFp4BkfEW+wKwED97FNvnb4_5AWDO8KwpQvVXaHa7pSywQ@mail.gmail.com>
In-Reply-To: <CAPDyKFp4BkfEW+wKwED97FNvnb4_5AWDO8KwpQvVXaHa7pSywQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 30 Jun 2021 14:21:26 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0gMv9d9Pqm-tjPScL404DSiQx8x8oFim8cvypx2ao14A@mail.gmail.com>
Message-ID: <CAK8P3a0gMv9d9Pqm-tjPScL404DSiQx8x8oFim8cvypx2ao14A@mail.gmail.com>
Subject: Re: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>, pizza@shaftnet.org,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:a/U8MAMPEw2KACok6Xjsaf8/I2V/gxbsq6rUtKS5+gFDLaJF+nV
 7TaFLFfeh/BOoB0TybuxZll+jHHaDF9XqF4cWy7XViMr7xSD4MBxCnwkjesKWEwV5cboOjl
 NZrBF8RQmoy4nm4QGa6RMCXNL2jSYgur10xx86pPjLzocbyudK0LbGpp4CV1ISXrexTygse
 pYOVAyk4NqMXoreWPYlmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+5lFCng3GbQ=:7r5+yyrDTv1YIInn8eb7JY
 JEIVXUz0Op1LRbt2THBuNnIfJDkQZiz3u7/5lKvXMjFeRcPHnVmwP0lAfn2ExTgLBrCZ4KNXi
 4l/1kkv2fpuIU8yL7JX31IP1/VijimXRSkjQlfyyUoxNOJOsxu39DZqa6UQJmB6kwQhKs/+oO
 2FQIpjfcxdx17bWWlWQ2LYLujF+lLB+PVUH99ahNl2SoAWuJ3mUc2v+INhH4W+K3vkXcCzu6n
 2Fq8hvBw61araw8UggHKFOZbvC+KGSADdUzd8yz0KTgjc7NvK9yC5TQIigKl4+H1WJsVmjTJU
 oRQXW5gCfY6uIW1TcuZ3Z++kB2g/xKD8egEB9QViOCsuq/tEx9jw6sYlcC3Lp0OBRbwpfNFHY
 CgZQCnw6Nd+AGS/IrE4IaAPWciZN4GcDKPQB9LqvVxufrRkhtOeGDyHtxDXUowK21Ih+yFstk
 vQgin0EH3XvjtJC8eVviXGs9zpayUVO/bT4htAXbdMDgUSVeakiWlZTzblCMIf4Ubp0yoOvZe
 ziTXBmLoFlzI/Dnz1wkQBV2CO4Au7+0AbiZ8643b+P8jDuOPjbWYV+y74vZqw8D1V2mh8DeD+
 CVInLFld6QyM7MGSdyVHWl0RBTa/Gsa+KQDgsfb80zHDJU36ivtJILZzNDlqaOf85p76uWbSz
 0YdLUqnsqTpQQpTDk7I0pTQUikx7auh0LQQI9oJlSDL/Fkt6JH9ruMwkxLTaij6wR+PLeGUBu
 FyNvKIVZWlDCXdAx43G6OvUCNAR0XzMH3v2wksZLGb/H7vbBovzI4P21D7Xqq53Yd2I+L/NwQ
 ZfqBwnf7YQQAhWPqOVdjBlE7m8sLHetotSBkrbNK3iRvcSqDMrB31fa8Y+5rObZfLh869BXKp
 1glk+uI9XConiJIiZ1zKBK1Q0zthQG1L3fCXQZVgePctJ1m4HoQGVNOWm92QacVSLqEndKLyi
 UEQ+NyhbalDA4jMvClf7fGSnINtvPFv9ansH8Q9YjaJtpTJ4kK6wI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 2:03 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:

> > diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> > index 4c229dd2b6e5..845f9ca3b200 100644
> > --- a/drivers/mmc/core/sdio_ops.c
> > +++ b/drivers/mmc/core/sdio_ops.c
> > @@ -124,6 +124,7 @@ int mmc_io_rw_extended(struct mmc_card *card, int
> > write, unsigned fn,
> >         int err;
> >
> >         WARN_ON(blksz == 0);
> > +       WARN_ON_ONCE(is_vmalloc_or_module_addr(buf) || object_is_on_stack(buf));
>
> Looks reasonable to me, at least we should start giving a warning.
> Would you like to send a formal patch that we can test?

Done.

        Arnd
