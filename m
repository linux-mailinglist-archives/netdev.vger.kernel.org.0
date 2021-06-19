Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA83ADB85
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhFSTdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 15:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhFSTdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 15:33:44 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DE8C061574;
        Sat, 19 Jun 2021 12:31:32 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t19-20020a17090ae513b029016f66a73701so2761110pjy.3;
        Sat, 19 Jun 2021 12:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=gV8xf5sy/tYr5U0izhD1041axQQlpB8Fks85YnieLMw=;
        b=oCP44XcHytr/iXuGVsD7bYfN5ic9QXOmRKSr1xkIF0PtVkeT/YoPfZZJXtAdXK4sKw
         7HJ90YM87kg1DvVoovaKVzNafIBYtUt7MNlvyyBEstC1F14y71FQzWT/8NJpjdhEntfr
         3dQ6BF4hGKq6UeOBLaDK1eIZE1qN6d3lZ101fvzBhMBRigHRwInhB/vw36YvWLV6CsDQ
         1CePEK2HQ6KmPBdnd0m2aqHr/qKRo4zovoZmfKOSF+SSi08DRGcsszfx7tG7lVWWJZOR
         p6aecFTUy/IE74WMHcfXvxqKvdQwMnAZOCreuXN2z+1wzSA1fYNFmV5m+sTNMUUxM8Lp
         83eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=gV8xf5sy/tYr5U0izhD1041axQQlpB8Fks85YnieLMw=;
        b=lvT7aetkrS6hZbmJQ3JPfo3RWhLgzBT9KuMEurT1vaD9KQhcGbqkoRgsT/J97fJpXP
         jCyfog3iIVqu/eEu8br6IFs0Hkp2sUTzRAcTeC4buL89q/gC+s+5wAQ3LXoChsiE/FU1
         v79McnNoeau4TFSBJ3rmmmE7jUxxkOXY+oFA2cWPIkaGh58ZEC+APOtq34flO2PPxqTA
         nqonBHYD/bcgJunGyY1dhpbRaI2G1Z0JVg76KEFPLRZfUHTclQG65DB8xgyvNWcIj3Vn
         0YLf31Ei+a93b9/7HvJaY5DMISEax+hQfVoIfiFM4zCY4KgYwZu1/7gLhUZ9Or2OBKdi
         H+FA==
X-Gm-Message-State: AOAM53134lt+SFCnoWAZeSSzsOyLx9cAh9OdG+cBRH4loxcv1qE4if4l
        9+em25SjMZMJQdJS1kBkhl8XVREPl5E=
X-Google-Smtp-Source: ABdhPJxFFUr9OEwL86iO1DbbMzTy4Pe2Zg3HpzOv3CDB3FLQ3UcbHeW2fslEeDHIMkkckrmX6eXdaw==
X-Received: by 2002:a17:902:8d82:b029:120:4377:8e0e with SMTP id v2-20020a1709028d82b029012043778e0emr10450993plo.32.1624131091828;
        Sat, 19 Jun 2021 12:31:31 -0700 (PDT)
Received: from [10.1.1.25] (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id b10sm11415501pff.14.2021.06.19.12.31.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jun 2021 12:31:31 -0700 (PDT)
Subject: Re: [PATCH net-next v5 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com>
 <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
 <CAMuHMdUSGWGMs6_wqy-CkfuKsdk=EBpEVBf3UugxCuo3qZQCKg@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <5e753883-d8c1-8e2a-9cd8-e6c315862fa2@gmail.com>
Date:   Sun, 20 Jun 2021 07:31:25 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUSGWGMs6_wqy-CkfuKsdk=EBpEVBf3UugxCuo3qZQCKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

thanks for your review!

Am 19.06.2021 um 21:08 schrieb Geert Uytterhoeven:
> Hi Michael,
>
> On Sat, Jun 19, 2021 at 2:35 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Add Kconfig option, module parameter and PCMCIA reset code
>> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>>
>> 10 Mbit and 100 Mbit mode are supported by the same module.
>> A module parameter switches Amiga ISA IO accessors to word
>> access by changing isa_type at runtime. Additional code to
>> reset the PCMCIA hardware is also added to the driver probe.
>>
>> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
>> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
>> Kazik <alex@kazik.de>.
>>
>> CC: netdev@vger.kernel.org
>> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
>> Tested-by: Alex Kazik <alex@kazik.de>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>
> Thanks for your patch!
>
> Note that this patch has a hard dependency on "[PATCH v5 1/2] m68k:
> io_mm.h - add APNE 100 MBit support" in the series, so it must not
> be applied to the netdev tree yet.

Hmm - so we ought to protect the new code by

#ifdef ARCH_HAVE_16BIT_PCMCIA

and set that in the m68k machine Kconfig in the first patch?

(It's almost, but not quite like a config option :-)

>
>> --- a/drivers/net/ethernet/8390/Kconfig
>> +++ b/drivers/net/ethernet/8390/Kconfig
>> @@ -143,6 +143,10 @@ config APNE
>>           To compile this driver as a module, choose M here: the module
>>           will be called apne.
>>
>> +         The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
>> +         CNet Singlepoint). To activate 100 Mbit support at runtime or
>> +         from the kernel command line, use the apne.100mbit module parameter.
>
> According to the recent discussion about that, "at runtime" is not
> really possible?  So that limits it to kernel command line (for the
> builtin case)
> or module parameter (for the modular case).

True - I'll reword that.

Cheers,

	Michael

>
>> +
>>  config PCMCIA_PCNET
>>         tristate "NE2000 compatible PCMCIA support"
>>         depends on PCMCIA
>> diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
>> index fe6c834..8223e15 100644
>> --- a/drivers/net/ethernet/8390/apne.c
>> +++ b/drivers/net/ethernet/8390/apne.c
>> @@ -120,6 +120,10 @@ static u32 apne_msg_enable;
>>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>>
>> +static bool apne_100_mbit;
>> +module_param_named(100_mbit, apne_100_mbit, bool, 0644);
>> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
