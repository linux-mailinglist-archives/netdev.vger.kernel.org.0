Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF221873B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgGHM0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728920AbgGHM0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 08:26:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AF2C08C5DC;
        Wed,  8 Jul 2020 05:26:13 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z24so29106826ljn.8;
        Wed, 08 Jul 2020 05:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=0WY7VO1/PlvGebx+s+CB42FvRvsrONOzlWyp8GKxJ7U=;
        b=ZagwQbD3LLb8odvDlATd+xSVDqDCBl8YAnvJFXTNS4f1BH0Y5L6FULTXAx+HtFHZvC
         chzo05WRyWo/dfMaLQZUu1oyt9+yFNUyrtoy+EozhJXCeq3wSruZO2H5XArxkCmMMQqL
         fK+ibOalXme93YR6IlUy1c5GItP05ZYBG8wzvypDD83lwDVZqaszOBQ8lEPQUb8IQaXg
         oLZvczX9YG/3g+cn/VakR/OwgMrEqgw4Vp1+uGa1h9cKYjipzCcVMwreI3wmPik7JgN9
         FP+CQBXkv4OzbyC49D8hQ2Qc7khc5hySgFW+/znfsdqlPJkK8BPE1lJ7HzMueP0MhqW0
         JXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=0WY7VO1/PlvGebx+s+CB42FvRvsrONOzlWyp8GKxJ7U=;
        b=DCOP1D5qHVCfbUe4oAByBeSzLoUG8iPi2iZyzCgqoU6H5HAaa6mxHKH8Aqx52L03do
         dBfw8IffjC460l1JABjflWY8yUIjvfw+cuKD71WJvW71+5jQyoqeT86xsw4LVkgGfwCj
         wYoNDoFx8EUxX2EQxKYE92zYqRqz/57LD3Z0KBaNAwo7eBNFJe8Up5rqTQMmRPV11Rj8
         OOyLAdliAUcHE96Nc2IN+47MmgliGMsdw3tLu9r/DQM/N/HPRVt67gDl2GI2Yuz8ZnUN
         xpwAuIdLMuiFTfaHJuJMkBt58XByUY/z6RqPDTEYtM3FWf8eY4civRD0x0it/80rjNqJ
         7Cyw==
X-Gm-Message-State: AOAM530xPg8s6ACdrwBLlXJn8dqqny5afHpzn0MlGnemdqDdJQjQ3pGY
        KTiZoHE8x1xZ9xVPL20vhoQ=
X-Google-Smtp-Source: ABdhPJxzrCBYeG0795WxwsVybW+Dxe+0/dCidOCLBzGrqz2nkUfJudE6NHyG5JSZohu8LSbgehRfoQ==
X-Received: by 2002:a2e:7615:: with SMTP id r21mr24548641ljc.124.1594211171650;
        Wed, 08 Jul 2020 05:26:11 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id h21sm878527ljk.31.2020.07.08.05.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:26:10 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-5-sorganov@gmail.com>
        <AM6PR0402MB3607DE03C3333B9E4C8D3309FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
        <87tuyj8jxx.fsf@osv.gnss.ru>
        <AM6PR0402MB36074EB7107ACF728134FEB0FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
        <87y2nue6jl.fsf@osv.gnss.ru>
        <AM6PR0402MB36070AF1D20C8F1A1E053F07FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Date:   Wed, 08 Jul 2020 15:26:09 +0300
In-Reply-To: <AM6PR0402MB36070AF1D20C8F1A1E053F07FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
        (Andy Duan's message of "Wed, 8 Jul 2020 08:57:07 +0000")
Message-ID: <87lfjub3by.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Duan <fugang.duan@nxp.com> writes:

> From: Sergey Organov <sorganov@gmail.com> Sent: Wednesday, July 8, 2020 4:49 PM
>> Andy Duan <fugang.duan@nxp.com> writes:
>> 
>> > From: Sergey Organov <sorganov@gmail.com> Sent: Tuesday, July 7, 2020
>> > 10:43 PM
>> >> Andy Duan <fugang.duan@nxp.com> writes:
>> >>
>> >> > From: Sergey Organov <sorganov@gmail.com> Sent: Monday, July 6,
>> >> > 2020
>> >> 10:26 PM
>> >> >> Code of the form "if(x) x = 0" replaced with "x = 0".
>> >> >>
>> >> >> Code of the form "if(x == a) x = a" removed.
>> >> >>
>> >> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> >> >> ---
>> >> >>  drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
>> >> >>  1 file changed, 1 insertion(+), 3 deletions(-)
>> >> >>
>> >> >> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
>> >> >> b/drivers/net/ethernet/freescale/fec_ptp.c
>> >> >> index e455343..4152cae 100644
>> >> >> --- a/drivers/net/ethernet/freescale/fec_ptp.c
>> >> >> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
>> >> >> @@ -485,9 +485,7 @@ int fec_ptp_set(struct net_device *ndev,
>> >> >> struct
>> >> ifreq
>> >> >> *ifr)
>> >> >>
>> >> >>         switch (config.rx_filter) {
>> >> >>         case HWTSTAMP_FILTER_NONE:
>> >> >> -               if (fep->hwts_rx_en)
>> >> >> -                       fep->hwts_rx_en = 0;
>> >> >> -               config.rx_filter = HWTSTAMP_FILTER_NONE;
>  
> The original patch seems fine. Thanks!
>
> For the patch: Acked-by: Fugang Duan <fugang.duan@nxp.com>

OK, thanks for reviewing!

-- Sergey
