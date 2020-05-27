Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18B31E3898
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 07:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgE0FxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 01:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgE0FxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 01:53:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59004C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 22:53:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so17360907wrp.2
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 22:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XoX8iu4I3ZFviArrP42/5RmVAs+JDEH8lQ8orXJoYxw=;
        b=V56dU3k0V6NLI+gE8hjrfKiEGG7+26ookv6y+ZEr1W+YOBs5WSYzaSKKwkiTkkEmYI
         XDaONKHnsaxZy21L8ZXTIQCJS7e8x2NY4vZdyVjlnVWH5UHpC4ud0uJyMm1KqQPr3BQh
         D6kpshpJw08MS6rYyuGhRj5pSsUByI3DuEw+8R+bbYrXDAeJFFjgb3aT1GzWgqb6VXTm
         no2jK94xRmeMAypZL5r4kYqxlcTLtreCxlgIQbD3rScTQgRrjDzNslMBFga4te8AMe3+
         pmhGkKPXhtsfJhEtYMs2PmKoqSv9QRlC2gH1A1hQGEVQW1ALVOIJULyXnwZ7YgZ+0D1z
         YYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XoX8iu4I3ZFviArrP42/5RmVAs+JDEH8lQ8orXJoYxw=;
        b=EapIXtKnlWwB2MbErhA/IkXOWFV3r8ji2JBooiSJyRvdLHZCUUHOx0gstHLHzddcgZ
         DXbcmrG/PHmOUtdLOethUnYShsDxowacDt6R/LUDoW5Et2jHU0w5znDUw/Awn25sbMrD
         KzNxi/gWuiqmH3Wb2F/8z47vJWyum6un3m3B06FuwmwFwqX484mJE8f90fFNrrvTN2GZ
         2sTRNgCem1/CE7z/9l6yl7IlH3OzjDhIyMDENfhsh52KvLZjQ7pbvH/qolNELg5DRV4e
         jJ5pu9x7fu0wMzzI6uDNm2FexrkE+LZsBRbIpM48vTWwiwgGhIbLhQXfOnA2CDPiVe4j
         XHxg==
X-Gm-Message-State: AOAM530zA6p8C4hyzV2s1T470cmxGgZB01n82N3qddC2OO8KMQWH2sQx
        0JSoEfJoHQscsp2/frZEVuZe9Q==
X-Google-Smtp-Source: ABdhPJzVK/zfRJagm/i7HAeN9TOBNRM4d8KYiW487pIiljxru5HC5qhfM8tuO2sSVF6GblseC80cxw==
X-Received: by 2002:adf:f0c6:: with SMTP id x6mr21704423wro.301.1590558786899;
        Tue, 26 May 2020 22:53:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k17sm1596594wmj.15.2020.05.26.22.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 22:53:06 -0700 (PDT)
Date:   Wed, 27 May 2020 07:53:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200527055305.GF14161@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
 <20200511112346.GG2245@nanopsycho>
 <20200526162644.GA32356@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526162644.GA32356@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 26, 2020 at 06:26:44PM CEST, vadym.kochan@plvision.eu wrote:
>On Mon, May 11, 2020 at 01:23:46PM +0200, Jiri Pirko wrote:
>> Fri, May 01, 2020 at 01:20:49AM CEST, vadym.kochan@plvision.eu wrote:
>> >Add PCI interface driver for Prestera Switch ASICs family devices, which
>> >provides:
>
>[...]
>> 
>> This looks very specific. Is is related to 0xC804?
>> 
>Sorry, I missed this question. But I am not sure I got it.

Is 0xC804 pci id of "Prestera AC3x 98DX326x"? If so and in future you
add support for another chip/revision to this driver, the name "Prestera
AC3x 98DX326x" would be incorrect. I suggest to use some more generic
name, like "Prestera".



>
>> 
>> >+	.id_table = prestera_pci_devices,
>> >+	.probe    = prestera_pci_probe,
>> >+	.remove   = prestera_pci_remove,
>> >+};
>> >+
>> >+static int __init prestera_pci_init(void)
>> >+{
>> >+	return pci_register_driver(&prestera_pci_driver);
>> >+}
>> >+
>> >+static void __exit prestera_pci_exit(void)
>> >+{
>> >+	pci_unregister_driver(&prestera_pci_driver);
>> >+}
>> >+
>> >+module_init(prestera_pci_init);
>> >+module_exit(prestera_pci_exit);
>> >+
>> >+MODULE_AUTHOR("Marvell Semi.");
>> 
>> Author is you, not a company.
>> 
>> 
>> >+MODULE_LICENSE("Dual BSD/GPL");
>> >+MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
>> >-- 
>> >2.17.1
>> >
