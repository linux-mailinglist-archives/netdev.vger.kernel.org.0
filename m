Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3379525C7F9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgICRTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgICRTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:19:38 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23970C061245
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 10:19:38 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id s62so2153121vsc.7
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 10:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6E34pUevinBPv9nlXlIDgJMiC3srQBnGMK5fNngoX64=;
        b=PmDkVADbtD+P3BALcHVP//xg0AuB6aWvk4S4gu9sCpMAAnIbG5kIKMRDXGJZUnOnpv
         19dDkFukgPEmzBuz5+V4Iiuu06vmhK5xWi/Zd1gnPzov0WQoOplNfg7qsnXCHxRFg3GM
         yOIy36WMvr9ejpSc2O4jD7r/yuxbTIRILzrbpe3p3RVDXBmL/mqj+1m0owASDioa/NpD
         iVSUaCSYRRMtkE3z8dXToCXV53S8oS9lOUapu3JS5LvKkpb4eNNAhKeRNK88j8P3fXBX
         ycuBYY11/Yo/W14NDIm2SBtqfqAPn8UfM9Llgpji/wRYo3yDnhvdN+eWarhXHCIxsbmy
         bZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6E34pUevinBPv9nlXlIDgJMiC3srQBnGMK5fNngoX64=;
        b=dG8sEVDbFHEYozckmxBtlWoE7SR2W/F2nq3Ho3SqTvGXWH7nBJjeSmFVyC79Drtwbp
         EZmmiW8QWU+ogZtwfMIFV1Ptz+x/PJfc1cgUDwbWoNuRRRSiw0jiw+MqopApvnHpY8Cr
         GOxJOLtEkd67Q4XC3Q/Jft5bIBTn3yEl7Bq18r/IYLvtMpnN9DnQZ0FsZOpa0XNoPZpn
         cBQxgYPRhLEHOsKsAuYTXAIUC/8ol5mwWkpax16Sc3Xnff8B5tqb0pfgWgqiXoWKuHCd
         sdRqW4iKz0PKpb5IdSI8u+AVBZH0SyDqbN1EYfrVVTk/wr+42LpsHXv+RrDz7FTPON8/
         U9dA==
X-Gm-Message-State: AOAM5323jsR4c6X/j98ym5VR8mFK2QNz+R6jJ6r+ZjD41oHEpSx06Nvn
        oU9uMlim+mHUz/MC8oxTyVQ+JnWwOErPTw==
X-Google-Smtp-Source: ABdhPJzLWYFKHytbQhiwdgnJe8fCUve1fnTo5JL3Z73vpmlgGcJQnj9WyC9aHPgYyK0YxydkbafqWA==
X-Received: by 2002:a67:ff97:: with SMTP id v23mr2383306vsq.11.1599153576992;
        Thu, 03 Sep 2020 10:19:36 -0700 (PDT)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id w69sm590487vkd.23.2020.09.03.10.19.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 10:19:36 -0700 (PDT)
Received: by mail-ua1-f44.google.com with SMTP id u48so1162581uau.0
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 10:19:36 -0700 (PDT)
X-Received: by 2002:a9f:2237:: with SMTP id 52mr2117679uad.141.1599153575566;
 Thu, 03 Sep 2020 10:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200902150442.2779-1-vadym.kochan@plvision.eu> <20200902150442.2779-6-vadym.kochan@plvision.eu>
In-Reply-To: <20200902150442.2779-6-vadym.kochan@plvision.eu>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 3 Sep 2020 19:18:59 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfNX0vYL2QmomVBrjXzmQ7WUUmOhtyM_9WfMkSQD1EuPw@mail.gmail.com>
Message-ID: <CA+FuTSfNX0vYL2QmomVBrjXzmQ7WUUmOhtyM_9WfMkSQD1EuPw@mail.gmail.com>
Subject: Re: [PATCH net v6 5/6] net: marvell: prestera: Add Switchdev driver implementation
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 5:07 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> The following features are supported:
>
>     - VLAN-aware bridge offloading
>     - VLAN-unaware bridge offloading
>     - FDB offloading (learning, ageing)
>     - Switchport configuration
>
> Currently there are some limitations like:
>
>     - Only 1 VLAN-aware bridge instance supported
>     - FDB ageing timeout parameter is set globally per device
>
> Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Co-developed-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>


> +int prestera_switchdev_init(struct prestera_switch *sw)
> +{
> +       struct prestera_switchdev *swdev;
> +       int err;
> +
> +       swdev = kzalloc(sizeof(*swdev), GFP_KERNEL);
> +       if (!swdev)
> +               return -ENOMEM;
> +
> +       sw->swdev = swdev;
> +       swdev->sw = sw;
> +
> +       INIT_LIST_HEAD(&swdev->bridge_list);
> +
> +       swdev_wq = alloc_ordered_workqueue("%s_ordered", 0, "prestera_br");
> +       if (!swdev_wq) {
> +               err = -ENOMEM;
> +               goto err_alloc_wq;
> +       }
> +
> +       err = prestera_switchdev_handler_init(swdev);
> +       if (err)
> +               goto err_swdev_init;
> +
> +       err = prestera_fdb_init(sw);
> +       if (err)
> +               goto err_fdb_init;
> +
> +       return 0;
> +
> +err_fdb_init:
> +err_swdev_init:
> +err_alloc_wq:
> +       kfree(swdev);
> +
> +       return err;
> +}
> +
> +void prestera_switchdev_fini(struct prestera_switch *sw)
> +{
> +       struct prestera_switchdev *swdev = sw->swdev;
> +
> +       prestera_fdb_fini(sw);
> +       prestera_switchdev_handler_fini(swdev);
> +       destroy_workqueue(swdev_wq);

this cleanup is also needed on the error path of prestera_switchdev_init

> +       kfree(swdev);
> +}
