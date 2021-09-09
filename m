Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523B44058EE
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345635AbhIIOYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344809AbhIIOYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:24:46 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15030C123EFB;
        Thu,  9 Sep 2021 05:56:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id e21so3370611ejz.12;
        Thu, 09 Sep 2021 05:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gm+QJBmlGuYlJJE8NRvzi/wtEdQjvZ3XI6fMnIPTwsM=;
        b=mzjv74D6M6QVTsFPXxAixI2KsNk3ufjg9B5h3dgFii5Gd7Vm3YqGoXK3DfX4h/q6m+
         WFbEbuXjS4rPK8dOJc/deOFMc+TYFPb7NWqkXepqdaLa9fprAfDmMViXISbkJcdR/S1L
         dbskrhDVQS26rGSJLcbJcAE/w9G/fOWF+YT/ZufEPE8HucBwVSBbBT0PiZApb4wTc4X0
         /mK96mYE/NTANicat0I+CDAr7aCetk50V8rbmeSyfWmLMMWaFNIoJMujU2PtEjZVWbJ3
         ENng2TlxwraFhPX67fNmND2I/JtIZZd3tKcesbAXy8D5GsKBVyS/+EI7/bGT2O3Mso5B
         TQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gm+QJBmlGuYlJJE8NRvzi/wtEdQjvZ3XI6fMnIPTwsM=;
        b=kOA5Ac81q65YgGYOiLoTh6+62VJVlJpcxl2IA7UayZccP8B+At5vX4vxRdll4q+2WF
         dOR3mQzkk3e3ML6yYWMTceUfs5c3GduaG9S6LgXOX+m6nPLMQaFJjR620PLZY4X4ACAO
         0evkmJlHqBOFQL5HxyaU9Ir/DYlYba6jPkor++HePTz6dYve7L9PpvQlOJ8FbBhAGF5E
         J+T0e2yQThjU64olbRiYzvmTrOiYCK15Z75DPGIiik3ANlKUA1X8fIjiCHBeR41IL2ED
         U4RJCtHv7T+aWZnV1524IqUZFdSKauFK3srX23aMRq702mptbVqjIp/uQNDT96RMTyIn
         Blug==
X-Gm-Message-State: AOAM533MGHE4f8MqqEVcspyYoo339OvaDV7+r0DsvwKgfW7nmiUcb51U
        MGKG+glqJFMi2lGk5Ik4pDw=
X-Google-Smtp-Source: ABdhPJyYBboEmUp4wc4ia5ExKSuSpNUUvr9kqLHseEOaXLzq572y9He7G4it/sEtapDRACXroPqg8A==
X-Received: by 2002:a17:906:d52:: with SMTP id r18mr3215518ejh.47.1631192167570;
        Thu, 09 Sep 2021 05:56:07 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id l16sm966195eje.67.2021.09.09.05.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 05:56:07 -0700 (PDT)
Date:   Thu, 9 Sep 2021 15:56:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210909125606.giiqvil56jse4bjk@skbuf>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114248.aijujvl7xypkh7qe@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 02:42:48PM +0300, Vladimir Oltean wrote:
> I feel that something is missing in your system. Is the device link
> created? Is it deleted before going into effect on shutdown?

So in case my questions were confusing, you can check the presence of
the device links via sysfs.

On my board, eno2 is the top-level DSA master, there is a switch which
is PCIe PF 0000:00:00.5 which is its consumer:

ls -la /sys/class/net/eno2/device/consumer\:pci\:0000\:00\:00.5
lrwxrwxrwx    1 root     root             0 Jan  1 00:00 /sys/class/net/eno2/device/consumer:pci:0000:00:00.5 -> ../../../../../virtual/devlink/pci:0000:00:00.2--pci:0000:00:00.5

In turn, that switch is a DSA master on two ports for SPI-attached switches:

ls -la /sys/class/net/swp0/device/consumer\:spi\:spi2.*
lrwxrwxrwx    1 root     root             0 Jan  1 00:04 /sys/class/net/swp0/device/consumer:spi:spi2.0 -> ../../../../../virtual/devlink/pci:0000:00:00.5--spi:spi2.0
lrwxrwxrwx    1 root     root             0 Jan  1 00:04 /sys/class/net/swp0/device/consumer:spi:spi2.1 -> ../../../../../virtual/devlink/pci:0000:00:00.5--spi:spi2.1

Do you see similar things on your 5.10 kernel?

Please note that I don't think that particular patch with device links
was backported to v5.10, at least I don't see it when I run:

git tag --contains  07b90056cb15f

So how did it reach your tree?
