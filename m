Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBAF6A4B75
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjB0Tq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjB0Tq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:46:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8309327998
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:46:01 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so7266740pja.5
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=edOsSqKeutXsiRqa8gBs+LVUPkMQejaeyeVY3P9KlEQ=;
        b=NPlXz+gK3ubZjB+bo9NoWiFlk49tPxBbfUve8U8gu4w6MSBjszOF7To4qWwwJ6T3cd
         WOmEcpPW46y+VWh1U6gmIV6lOfOYrryAj4De2KUGQ3m5sTlciMZd9noAyseTuxXe0sYB
         w1ClP1LbJ663Zu8Eomq1OThRFQNE4RLn350vK7lH8qRJz+8xTiAHKx7aS7ARluYUDCnI
         3rKq5PWo7z3pdjMaVbJaVNSgYAysIbfRjikN92Mx/jM6IO7E1hzDaS2YLQpWAgfJkA6e
         aUzV+U2GUW5ruueJDPdcS89aWlrFJX3fDBG4Kq5EiFQRR3WXEDsKoKM7XdZhS76ZNBut
         lwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edOsSqKeutXsiRqa8gBs+LVUPkMQejaeyeVY3P9KlEQ=;
        b=NwMTeuUO6SiCq+86VPgLVYqFp90JasBfgHxLmWs5gD7icMV6jbgPAoO5c0o38gpXGA
         ooiflKbeP65qmodsSTWuiD9hZOFF9QHkGJjJCUZwqe1k88nDKewyjlSQp4xU8bCX7fHO
         poR8SsPruTqqNh9s7zOx38SJ5NLRif99X9aK3AMtf6YIXkj341Sbm5xlLMXDNILzGSU2
         i2R5toS9zAhJ+QLyM28z78Akqo+mPyNEKdrK2DcR2Lu3chGe0L5xNbDQE8tiWgEJ6EUF
         9z115QCufawx6C/hH6fMJhQjbSJZYsrW54iobd/1MWvCXIu6WKBH8WHyILoSrCmXr14Q
         kyAQ==
X-Gm-Message-State: AO0yUKUXGfrPp9SjxX6eMnR5SP3eM/VLfou14SEd1i2Wdu03Z9fw+giB
        Bblz0w1lYNfPrbM9OEiCRhU=
X-Google-Smtp-Source: AK7set8BJ6LWbAFhI6KdwicVNr/Iu7LDf5NizNmSM1TtYCLRsSvP/3XFFFpuEEic4U+rhfwDnFPuig==
X-Received: by 2002:a17:90a:4ca5:b0:230:a082:b085 with SMTP id k34-20020a17090a4ca500b00230a082b085mr345355pjh.0.1677527160855;
        Mon, 27 Feb 2023 11:46:00 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z17-20020a17090a8b9100b0022335f1dae2sm4766127pjn.22.2023.02.27.11.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 11:46:00 -0800 (PST)
Date:   Mon, 27 Feb 2023 11:45:58 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 03:20:05PM +0000, Russell King (Oracle) wrote:

> Attempting to fix this problem was basically rejected by the PTP
> maintainer, and thus we're at a deadlock over the issue, and Marvell
> PHY PTP support can never be merged into mainline.

FWIW, here was my attempt to solve the issue by making the PHY/MAC
layer selectable at run time, while preserving PHY as the default.

https://lore.kernel.org/netdev/20220103232555.19791-1-richardcochran@gmail.com/

There was a fair amount of discussion, and it seemed to me that
everyone wanted a pony.

If anyone wants to take up that series, or present a more creative
solution, then by all means, please go ahead.  I still have a working
board with the PHYTER, and so I would be happy to help validate the
new feature.

Thanks,
Richard


