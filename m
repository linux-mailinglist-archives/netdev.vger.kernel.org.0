Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84101216F10
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGGOn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 10:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgGGOn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 10:43:26 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72B3C061755;
        Tue,  7 Jul 2020 07:43:25 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e4so50228359ljn.4;
        Tue, 07 Jul 2020 07:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=unO6FiP6OsS3N2Z7cCD5xgoqJV/rBl4QePI8AwEUtKI=;
        b=t8Q3pm/EebY/Ch0SzzzydJR8YQhigTS96x782Gpzfd/vjXS28SkfmriJ+7nMIvF4U2
         ENlu+W27Dbw/XDhRZBifVSYG9srZrFs2mZR3GUpie0yaJt60LvjeZnVKebmRcBqSBZWo
         4kQGn4P+ibBsH1XoNe/qMqRjkedgt8x13Yy/9mjasM0PVn32EHLNq3DKxcJDNREWXxAW
         PcQOIywqPi6PTQVYpowvyS78yNuSiriRmjPf1tAHNKz1o9UDwAicgBuwSaMDIagFPXYV
         6XnR2KymbLRc8YNNxhtLa2VlRwk8Kb5D2m/E0NFIADQ0V2rXELuCoEUrCHQ0BeD80pa2
         3+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=unO6FiP6OsS3N2Z7cCD5xgoqJV/rBl4QePI8AwEUtKI=;
        b=GGl+lT7j/3PAGNbt/h6joatEYNZILvlvXk74MsGn68AlJykerCK8JeH08TFXarP9AJ
         ZaGPLwb2zy8YIY+L9sFRMWlnr07R9vnN4gY79tphQVdMw/lfNfLZq1+LuBavTRZ2cb5+
         6Oq0AZFqnACu2B+G4Yq3cI4G2RWEucFNh87uN4AFMYQJqhWyS45HY+/1tpkUJUtnuVB0
         nB0zObc8qaHAJpzFt0+s1Qcj1aC8t2F6BQw82s91aFn2VomlqYFufoUk9vi939JgGwRK
         0CJad3Iok0AbNjnP1LYcZl7+WzgDFO/VgWrfxfiFRMZoUB9xOWU+14D7TktrjmwoQ8pD
         qJNg==
X-Gm-Message-State: AOAM532NExW/s5yPrxBMRQoph8GnK+bVa8FXvLodnzLl5PMioylwvcCg
        HLqN1l7fzwGqBcD1AWZjM3Q=
X-Google-Smtp-Source: ABdhPJzxQ2Qnzpm6uIBNS8CYeYZEhUMsxENBOQYvUw27cbo6bsvopxb0tqpMtxD5LBvd24mTG4HeIw==
X-Received: by 2002:a2e:81c4:: with SMTP id s4mr28393624ljg.284.1594133004279;
        Tue, 07 Jul 2020 07:43:24 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id k20sm199996ljc.111.2020.07.07.07.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:43:23 -0700 (PDT)
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
Date:   Tue, 07 Jul 2020 17:43:22 +0300
In-Reply-To: <AM6PR0402MB3607DE03C3333B9E4C8D3309FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
        (Andy Duan's message of "Tue, 7 Jul 2020 04:08:08 +0000")
Message-ID: <87tuyj8jxx.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Duan <fugang.duan@nxp.com> writes:

> From: Sergey Organov <sorganov@gmail.com> Sent: Monday, July 6, 2020 10:26 PM
>> Code of the form "if(x) x = 0" replaced with "x = 0".
>> 
>> Code of the form "if(x == a) x = a" removed.
>> 
>> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> ---
>>  drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
>> b/drivers/net/ethernet/freescale/fec_ptp.c
>> index e455343..4152cae 100644
>> --- a/drivers/net/ethernet/freescale/fec_ptp.c
>> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
>> @@ -485,9 +485,7 @@ int fec_ptp_set(struct net_device *ndev, struct ifreq
>> *ifr)
>> 
>>         switch (config.rx_filter) {
>>         case HWTSTAMP_FILTER_NONE:
>> -               if (fep->hwts_rx_en)
>> -                       fep->hwts_rx_en = 0;
>> -               config.rx_filter = HWTSTAMP_FILTER_NONE;
> The line should keep according your commit log.

You mean I should fix commit log like this:

Code of the form "switch(x) case a: x = a; break" removed.

?

I'll do if it's cleaner that way.

Thanks,
-- Sergey


>
>> +               fep->hwts_rx_en = 0;
>>                 break;
>> 
>>         default:
>> --
>> 2.10.0.1.g57b01a3
