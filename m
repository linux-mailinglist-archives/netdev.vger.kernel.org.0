Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83926C70A9
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjCWTEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjCWTED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:04:03 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB0C729E;
        Thu, 23 Mar 2023 12:04:02 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t10so1912384edd.12;
        Thu, 23 Mar 2023 12:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679598241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhjS2ET4hy8RJQZYNpGSzs5fvnIW5XLmy6cILhQMr+0=;
        b=GllRiUuGzIBanpNAGY6v5lchgKPwi+Iq8TAjqPURc0zWIPIolVppztf+4eYrgxECYN
         BiL1xgkTEUUQAf5d+emnslVmAzknK7KKfFDWpG7xYtIIX+6kjPQyefpWeLnXvpsDxnkV
         uaVkmrv2faW/Skaxrv8bs3EbzfkwAp3D2nacefyr3sp+G/FoVRW+q604Wph+O6/cCsaP
         bKJfZRfjnHYe93G/cjT/ORIWIx1N8EMa0vqzGuXMQ9jjN/o/8H5qsU6okl7bLibe+LiC
         JnMJpqUWkeDLtxe8Ed3IEMWQjtw/LWTLMn9+GIbS1wOCmZJpfdBvw+nExwAGZYR+J5bv
         UBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679598241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhjS2ET4hy8RJQZYNpGSzs5fvnIW5XLmy6cILhQMr+0=;
        b=VEx9pTgOp8zn2kSdkY1oUzk/XoPYGMLkDEvqwCfUinfvZj/VkLouIKAZTl3cwNsloN
         Qw6CikLD1+4cHsd6vcP40iar+atAAxp7Iu5Y4ZdhN93XPgkeCDqJcckmOoOHFkWuha2K
         kcqqjGrgaU8IjpVFu8pFQjn3kwmv4o8opXlBuqYEdvDdTw1Fsz5aWBenzlU5YAKczuHM
         /H/lGusdufbohlL2zQGZkC4vJ8zKFLfbXRjZodX4JmhBIYBfNjPrmETj1L85XkAfAZEk
         YO6AH/Z1PudYfHNN6mIkIiLomkt2A/xQuJoUmz3AxQADED/vSaD+Aun+XD347RWyA4v2
         xBNA==
X-Gm-Message-State: AAQBX9f2b1PMHnUj7Dy/t7JAzeAi2ZiICBIRDpV5ixX8FTK947H6Jf0/
        lejXRh6EoN4gEq/sQL2tRAdNYeVo9mrVvs6G+Po=
X-Google-Smtp-Source: AKy350ZywMOIvaakAMRiH31o9WFhuyIxVvT8YYq3Pt2oNkx3kwjjtsUsnDGf4kAwYoXx0Ez0lWBiRuK21Dzi166SV7w=
X-Received: by 2002:a50:ab5a:0:b0:4bb:e549:a2ad with SMTP id
 t26-20020a50ab5a000000b004bbe549a2admr259924edc.4.1679598240975; Thu, 23 Mar
 2023 12:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
 <20230320213508.2358213-3-martin.blumenstingl@googlemail.com>
 <f7b9dda9d852456caffc3c0572f88947@realtek.com> <CAFBinCCspK=GaCMEiHsXi=0H4Sbp2vg_4EK=8bqQLWR8+qg7Sw@mail.gmail.com>
In-Reply-To: <CAFBinCCspK=GaCMEiHsXi=0H4Sbp2vg_4EK=8bqQLWR8+qg7Sw@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 23 Mar 2023 20:03:50 +0100
Message-ID: <CAFBinCAxuEyNkUxsqJ9wVxXupErcp33JCFsJ2hDupWj9MRMYGA@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO
 based chipsets
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ping-Ke,

On Thu, Mar 23, 2023 at 12:16=E2=80=AFPM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
[...]
> > > +       if (direct) {
> > > +               addr =3D rtw_sdio_to_bus_offset(rtwdev, addr);
> > > +               val =3D rtw_sdio_readl(rtwdev, addr, &ret);
> > > +       } else if (addr & 3) {
> >
> > else if (IS_ALIGNED(addr, 4) {
> I'll add these IS_ALIGNED in v4
> Also I found an issue with RTW_WCPU_11N devices where indirect read
> works differently (those can't use
> REG_SDIO_INDIRECT_REG_CFG/REG_SDIO_INDIRECT_REG_DATA but need to go
> through the normal path with WLAN_IOREG_OFFSET instead). I'll also
> include that fix in v4
I have a question about the "indirect" handling.
Let me start with what I know:
- REG_SDIO_INDIRECT_REG_CFG and REG_SDIO_INDIRECT_REG_DATA are only
present on RTW_WCPU_11AC based chips (older RTW_WCPU_11N chips don't
have these registers)
- the name of REG_SDIO_INDIRECT_REG_CFG[20] is not known but we're
polling that bit to check if REG_SDIO_INDIRECT_REG_DATA is ready to be
read or has data from REG_SDIO_INDIRECT_REG_DATA has been written
- REG_SDIO_INDIRECT_REG_CFG[19] configures a read operation
- REG_SDIO_INDIRECT_REG_CFG[18] configures a write operation
- REG_SDIO_INDIRECT_REG_CFG[17] indicates that a DWORD (32-bit) are
written to REG_SDIO_INDIRECT_REG_DATA (+ the following 3), this bit
seems irrelevant for read mode
- REG_SDIO_INDIRECT_REG_CFG[16] indicates that a DWORD (16-bit) are
written to REG_SDIO_INDIRECT_REG_DATA (+ the following 3), this bit
seems irrelevant for read mode
- RTW_WCPU_11N chips are simply using "addr | WLAN_IOREG_OFFSET" for
accesses that would usually be "indirect" reads/writes on
RTW_WCPU_11AC chips

While fixing the issue for the RTW_WCPU_11N chips I discovered that
the "old" approach for indirect register access (without
REG_SDIO_INDIRECT_REG_CFG and REG_SDIO_INDIRECT_REG_DATA) also works
on RTW_WCPU_11AC chips.
(I'm calling it the "old" approach because it's what the RTL8723DS an
RTL8723BS vendor drivers use)
In fact, this series is using the "old" approach for writes, but the
new (REG_SDIO_INDIRECT_REG_CFG and REG_SDIO_INDIRECT_REG_DATA based)
approach for reads.
Naturally I'm curious as to why two different approaches achieve the
same goal. Using the "old" approach (addr | WLAN_IOREG_OFFSET) means a
lot of code could be deleted/simplified.

Now my question:
Do you have any explanation (either from internal documentation or
from the hardware/firmware teams) if and when the
REG_SDIO_INDIRECT_REG_CFG and REG_SDIO_INDIRECT_REG_DATA registers
should be used on RTW_WCPU_11AC chips?


Thank you and best regards,
Martin
