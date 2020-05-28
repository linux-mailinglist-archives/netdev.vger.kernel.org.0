Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809821E5D2F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbgE1K3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 06:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387904AbgE1K3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 06:29:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED0FC05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 03:29:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q11so15167503wrp.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 03:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=diFXK+hIZoJR92YPM4oXaRS6M4r7y2B9XFsqDNpzCGI=;
        b=jvEL9krziHh56HwmVBAJZbdMP+gN5SmhrU8/ZRU3xtlgEa4qzdSGfccdOLYUbmtGmT
         ATzce9XmxKr+W7402rxsk8EhIFUEZPxBR0WI0foSY6h0L5vXqE4VnQQBCe4Wk1o9oSn4
         tMO4fFSuka7rCdoiCvUNM5DvOo8rJsGF7326VCF/UNFN9yLDkobV1BL4Br32LDoTaszp
         uEK6Oe0rHjC8qSga4FjH/M5SNu2jpEd2sr6zJ6ASeYvPXaXiUrvpY0v/AQlZe/YYu0vL
         LBp6w5pd12iBsNQ3aefIBtjKRDyIn7rbCvIfL8RnMKosfV+sEa45wobkk5wnI9ZPKwNQ
         y5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=diFXK+hIZoJR92YPM4oXaRS6M4r7y2B9XFsqDNpzCGI=;
        b=Dzmlvd/7Ii7UAndABhJCLgOZH9xHc19WKe42sZDwiwqoWyreEclx3xNGQyd8n2Cmew
         0MwvZD4umdV8/+aD1CtfC99LThbbxt/3FzSRXzcaHi3hiTtr5PJJ8Lae/fYeGwAWOzj5
         dzRPmxdZaJlX4zVYqPF1R/gP4hL2m3Awi61tr+xuh7+9ENUczK1WsBrHCFydTlFVCkpl
         UMoNedvKtx+4fT9p6IBWqF28XpAcNXBPF5svrFGRxkAG4A38zVWtOF6LYHIJIWTgsETW
         Wfhw9QhfXgTk2yj1CwVcCGSIpu4Oetnvnbyi4iuIAFir7vt4S0xD6KAOnNGF2yO0cBZr
         0vPw==
X-Gm-Message-State: AOAM531uv6bkbYqGg5bg2rGXXAa/4AGBu7z8YdD0MRhALQMNHQF9qtaE
        PV/LfdIBt86YCcNiX1Yj+RPtXg==
X-Google-Smtp-Source: ABdhPJy3vjBd8cPPh9U09SSp76/t0qtS83BhlAtaiZ5Ymt0xFd+Pu4YT6dBwPjOpWaS9ml0vUahfPg==
X-Received: by 2002:adf:eb08:: with SMTP id s8mr2874371wrn.361.1590661784038;
        Thu, 28 May 2020 03:29:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t129sm1274960wmf.41.2020.05.28.03.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 03:29:43 -0700 (PDT)
Date:   Thu, 28 May 2020 12:29:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20200528102942.GG14161@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
 <20200511112346.GG2245@nanopsycho>
 <20200526162644.GA32356@plvision.eu>
 <20200527055305.GF14161@nanopsycho>
 <20200527085538.GA18716@plvision.eu>
 <BY5PR18MB3091C6B195F58EC597BE5925BAB10@BY5PR18MB3091.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR18MB3091C6B195F58EC597BE5925BAB10@BY5PR18MB3091.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 27, 2020 at 02:01:39PM CEST, mickeyr@marvell.com wrote:
>Hi Vadym, Jiri,
>
>> 
>> Hi Jiri,
>> 
>> On Wed, May 27, 2020 at 07:53:05AM +0200, Jiri Pirko wrote:
>> > Tue, May 26, 2020 at 06:26:44PM CEST, vadym.kochan@plvision.eu wrote:
>> > >On Mon, May 11, 2020 at 01:23:46PM +0200, Jiri Pirko wrote:
>> > >> Fri, May 01, 2020 at 01:20:49AM CEST, vadym.kochan@plvision.eu wrote:
>> > >> >Add PCI interface driver for Prestera Switch ASICs family devices, 
>> > >> >which
>> > >> >provides:
>> > >
>> > >[...]
>> > >> 
>> > >> This looks very specific. Is is related to 0xC804?
>> > >> 
>> > >Sorry, I missed this question. But I am not sure I got it.
>> > 
>> > Is 0xC804 pci id of "Prestera AC3x 98DX326x"? If so and in future you 
>> > add support for another chip/revision to this driver, the name 
>> > "Prestera AC3x 98DX326x" would be incorrect. I suggest to use some 
>> > more generic name, like "Prestera".
>> 
>> We are planning to support addition devices within the same family of 'Prestera AC3x' and therefore "Prestera AC3x 98DX32xx" is mentioned.
>> Additional families also up-coming: "Prestera ALD2 98DX84xx"
>> 
>
>Vadym, Please attention we changed 98DX326x --> 98DX32xx
>
>Jiri, the 'Prestera" family includes several sub device families. 
>we think we need to be more accurate with the actual devices that are supported.

Sure, that is why I think that the name should be probably more generic
as prestera_pci_devices is eventually going to contain more pci ids for
more chips of the same family


> 
>> > 
>> > 
>> > 
>> > >
>> > >> 
>> > >> >+	.id_table = prestera_pci_devices,
>> > >> >+	.probe    = prestera_pci_probe,
>> > >> >+	.remove   = prestera_pci_remove,
>> > >> >+};
>> > >> >+
>> > >> >+static int __init prestera_pci_init(void) {
>> > >> >+	return pci_register_driver(&prestera_pci_driver);
>> > >> >+}
>> > >> >+
>> > >> >+static void __exit prestera_pci_exit(void) {
>> > >> >+	pci_unregister_driver(&prestera_pci_driver);
>> > >> >+}
>> > >> >+
>> > >> >+module_init(prestera_pci_init);
>> > >> >+module_exit(prestera_pci_exit);
>> > >> >+
>> > >> >+MODULE_AUTHOR("Marvell Semi.");
>> > >> 
>> > >> Author is you, not a company.
>> > >> 
>> > >> 
>> > >> >+MODULE_LICENSE("Dual BSD/GPL");
>> > >> >+MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
>> > >> >--
>> > >> >2.17.1
>> > >> >
>>
