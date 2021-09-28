Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6252841AD8E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbhI1LIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbhI1LIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:08:04 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6906C061575;
        Tue, 28 Sep 2021 04:06:24 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y28so90490150lfb.0;
        Tue, 28 Sep 2021 04:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nBjFzjWC4IRFGUtaFJjBkOTq/UnF6SfMPkVbWkqJ/wI=;
        b=VqWDFLZqMtfHxYfXUNop5oqrfXktuM3ykAZIOWj9b0xLteSkHHGyZhaIE/xK5V1oJu
         Um6U0bIXRoQoKoTI3nDGVn/5ggtpPv4tyXZhGgNd5CPklQuxf5WQhU2srIR+y7AjpeQS
         Ugja7C//Vcw7Tis1XYit7/Wzmmv+mefrtAQhQaLn1WgPdsFOc7sf+HTsi81Rmmn8UxY/
         c1Kk2wg8nyln6V7RFzpCTOWOd2YEbdpsskTgFDu40o4FzmDYuXfJVXgg7vW3E/aZq8Kt
         GbEBA6lRMvLSUibegnXlBQvdcj9arOhIAeDds9r6Jt2/gU8hu8eOvoySvZGeiO6wvlM0
         QFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nBjFzjWC4IRFGUtaFJjBkOTq/UnF6SfMPkVbWkqJ/wI=;
        b=AzaBTxgt6agWNFzv1EOVOFuhmLCVaLl8pGDR2bygbwN9t5xEqWvdkhyXEqe/CCkC6C
         nlT9EKOkNTw86ZC59k2oOdNRmIJGx6EWrXbH55rWKO+6D6qafvGzWnNkL148owMzxbcm
         BQ0km82hIWE2SaxEwpZtY2lP7V5KrUt2IvvJGlago8cOhxFiqo89LeUFdG/TfK+yAchA
         BN8rFoKynqHd5PdIKuw+42wrEJn9vMC8uClkDIBHNU6FR/yKr8tnEGD+OkZylbl/A+ci
         vF+AevIsRztfe2utMj+BmQimEvXKGzVUHLzd57k6GDph+3uamw6jVQQz/Rd0HFY7+wbV
         wz3Q==
X-Gm-Message-State: AOAM530IhNkTblnONefptiCVoxn38N7/aXHfNzP4Uw9s62q2zcIen9uH
        YKg5BYiBYYlrmnjCG10fINA=
X-Google-Smtp-Source: ABdhPJwIzsGInhBLwJ1DlMNSyo6mjxS12DwzrRjSNcjj2+UYDiz6e5iywGr4MqDiWLxqIYvgJFVdzg==
X-Received: by 2002:a2e:9b98:: with SMTP id z24mr5034006lji.339.1632827181597;
        Tue, 28 Sep 2021 04:06:21 -0700 (PDT)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id m10sm1891225lfr.272.2021.09.28.04.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 04:06:21 -0700 (PDT)
Message-ID: <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
Date:   Tue, 28 Sep 2021 14:06:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili> <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210928105943.GL2083@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 13:59, Dan Carpenter wrote:
> On Tue, Sep 28, 2021 at 01:46:56PM +0300, Pavel Skripkin wrote:
>> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> > index ee8313a4ac71..c380a30a77bc 100644
>> > --- a/drivers/net/phy/mdio_bus.c
>> > +++ b/drivers/net/phy/mdio_bus.c
>> > @@ -538,6 +538,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>> >   	bus->dev.groups = NULL;
>> >   	dev_set_name(&bus->dev, "%s", bus->id);
>> > +	bus->state = MDIOBUS_UNREGISTERED;
>> >   	err = device_register(&bus->dev);
>> >   	if (err) {
>> >   		pr_err("mii_bus %s failed to register\n", bus->id);
>> > 
>> > 
>> yep, it's the same as mine, but I thought, that MDIOBUS_UNREGISTERED is not
>> correct name for this state :) Anyway, thank you for suggestion
>> 
> 
> It's not actually the same.  The state has to be set before the
> device_register() or there is still a leak.
> 
Ah, I see... I forgot to handle possible device_register() error. Will 
send v2 soon, thank you



With regards,
Pavel Skripkin
