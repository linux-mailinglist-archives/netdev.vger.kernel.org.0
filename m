Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA822F229
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbgG0Oh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730091AbgG0OLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:11:55 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93859C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:11:54 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a14so15067643wra.5
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4JgRbp7y5AMyhvqG5bScPLnAhL+Dr6FW3JEWyK7fnPk=;
        b=Thx0NMVZq3esv/QXucfWm4kQBU20kaxbTvp2huJ8YMSgaOyNpOu2HcIk+4W8IY3A8f
         HjtYp6mAAec55vmuLzIiSogxlGoEU2880uywG1sqaBwr/n1omJywwQw0DKjB060HOv49
         4lWKCNp+doOf1wBGb/+2Ts1l+JExa32v9Wgo0Ndj4HWfA/O6qn5ZCoMu+i8V7sKNq6uv
         cm7mwcqZs7QeMkTXYOmIEjL9AEbmeFfQ+v+C0rhByRRxf4nRuZ7K/NKS0EuxDM7Y/Yuz
         pocwriw+mhSodfDj+M8fa0/rKQ5CI4r36WwUoUc6qFkMVxBjkCfGIS9etNNNYwOx1xQP
         3YQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4JgRbp7y5AMyhvqG5bScPLnAhL+Dr6FW3JEWyK7fnPk=;
        b=aVMjs1OXjJvWNcGkanYCEx6f5CJQnZg9TKHE+eLs7HlIVTcr/4IIxRHvqcXpHa/uVs
         UFf2oxtgvu8ZTAhGbTUJeasd9tXeJtb9p8+mjL8V//sI5bl4Vq1NHtZMGA+iKlr5+a8k
         m3vyvcUZaNZYiYachsusblVPPnyU6XOsa30CF4J5F3sVaOKX5zde6KSoZYCnAf1LeEnM
         AOYj2HBN7HFl9y/nFWSpVsYrQzP4rJvixmDTxbkhHWyQeasXbmquyyJt00Sn+v0B8ai8
         3Z7vGESy1SsrJGWzPk7PQEj911mq55VtYGA0txKW7jRMNKcwoTzLs4PiESb50uArhW39
         BiOQ==
X-Gm-Message-State: AOAM532nlXR0aPS6QhZiUmJtYs6B92PsbBPfDRj67jQjrvt2MYqqo0HS
        quF8asGf+lc6jdcesVyba26DjQ==
X-Google-Smtp-Source: ABdhPJyCLUfbgdOKuyocs1RKy2bsV8tZ+7kkol6NIXVdzCIujtkOmUZ3a4Hrt1NRLIASlK55CYUfXg==
X-Received: by 2002:adf:ee8e:: with SMTP id b14mr9197042wro.213.1595859113354;
        Mon, 27 Jul 2020 07:11:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p6sm13014534wmg.0.2020.07.27.07.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 07:11:52 -0700 (PDT)
Date:   Mon, 27 Jul 2020 16:11:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 2/6] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200727141152.GM2216@nanopsycho>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-3-vadym.kochan@plvision.eu>
 <CAHp75VeWGUB8izyHptfsXXv4GbsDu6_4rr9EaRR9wooXywaP+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeWGUB8izyHptfsXXv4GbsDu6_4rr9EaRR9wooXywaP+g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 27, 2020 at 03:29:17PM CEST, andy.shevchenko@gmail.com wrote:
>On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

[...]

>
>> +       pci_set_drvdata(pdev, fw);
>> +
>> +       err = prestera_fw_init(fw);
>> +       if (err)
>> +               goto err_prestera_fw_init;
>> +
>> +       dev_info(fw->dev.dev, "Switch FW is ready\n");
>> +
>> +       fw->wq = alloc_workqueue("prestera_fw_wq", WQ_HIGHPRI, 1);
>> +       if (!fw->wq)
>> +               goto err_wq_alloc;
>> +
>> +       INIT_WORK(&fw->evt_work, prestera_fw_evt_work_fn);
>> +
>> +       err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
>> +       if (err < 0) {
>> +               pci_err(pdev, "MSI IRQ init failed\n");
>> +               goto err_irq_alloc;
>> +       }
>> +
>> +       err = request_irq(pci_irq_vector(pdev, 0), prestera_pci_irq_handler,
>> +                         0, driver_name, fw);
>> +       if (err) {
>> +               pci_err(pdev, "fail to request IRQ\n");
>> +               goto err_request_irq;
>> +       }
>> +
>> +       err = prestera_device_register(&fw->dev);
>> +       if (err)
>> +               goto err_prestera_dev_register;
>> +
>> +       return 0;
>> +
>> +err_prestera_dev_register:
>> +       free_irq(pci_irq_vector(pdev, 0), fw);
>> +err_request_irq:
>> +       pci_free_irq_vectors(pdev);
>> +err_irq_alloc:
>> +       destroy_workqueue(fw->wq);
>> +err_wq_alloc:
>> +       prestera_fw_uninit(fw);
>
>> +err_prestera_fw_init:
>> +err_pci_dev_alloc:
>> +err_dma_mask:
>
>All three are useless.

This is okay. It is symmetrical with init. err_what_you_init. It is all
over the place.

[...]
