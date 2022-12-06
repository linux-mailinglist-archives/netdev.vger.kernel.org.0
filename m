Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB14A644AE5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLFSKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiLFSKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:10:42 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EAB3AC37;
        Tue,  6 Dec 2022 10:10:41 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b2so8155837eja.7;
        Tue, 06 Dec 2022 10:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0pd1Bx+vO1mPMLGI/2yav/w5xMEH6yvfn2zdahQrbbI=;
        b=pYjmxeA7m4aLhdFTgvTDk86neYn50/tqQYA02zo9L2IdS35OqOOrDank+/WIYeiE5c
         +MGsvjcERxGfIJpr9v6q5PzJ+clC4JwaAlSAxBZS9I0Gwbfvpnwij2ruSam82xOhRWm4
         gA/Bgqy1nkhEJG/lsCHYiCNpCLWdfdNvPt+T3XsAErOv1joFK8BNWkv/GDmnDlJlSl0i
         qeGQFEDFxHv/5G3Vpzo3gUhWfXidAUjYw4fJ7l48eVXGUggYX0e7bmG8+SJ/s8kk9/z6
         Mu6ywN/fMOa75+c73MNl2nt9ZBklxTfJgeL30LzO1kIeq+gePZqIda0Bx8g/Ieus75y1
         SHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pd1Bx+vO1mPMLGI/2yav/w5xMEH6yvfn2zdahQrbbI=;
        b=tzpQc+MsPkH0BlWpMxNONKCgnlqXPJEWeIOOhjvw1kWgx1CnRa6H2sgiZELGuT9nzy
         SlHozUlsBcHTPwKslW+eynNcUIkcK7/375Myc+69JijJaDmYAPmkfZiP+bFkZiLk7cUb
         gM8sfl6cXaEgkJKiRg4jncwmxBJiaNqlBYy1tm6qq1YL9V9FDE5TwGfKbDFOQm4RWWFZ
         Vq5PSzguvdOs0J2F8Qu5RThIt+rxHPSI43+rRGCNEThM+zBISEhj1XJmLHiBFH4kZ8/w
         UEWMTwUx+TgnyIamEQ6lcHZAYq19TufAS0hTU/eYvQwLh63PVM1JVfqAoTajnAGc6sPH
         NOxQ==
X-Gm-Message-State: ANoB5pkgOhzhRxEXRnyh0FWr4nhmre7ODmSz/yd29BMeH0h90Pmw7bQr
        MGwh+EEMr31sq0SKD80vBMM=
X-Google-Smtp-Source: AA0mqf5xXdPJtsEbl2DrVy94lbjCM0hjUZ9t1iZTIDNkeC/um58PtTBJuRGZKZxRbEJHW4Ee7wYgMQ==
X-Received: by 2002:a17:906:b213:b0:7c0:f7af:7c5e with SMTP id p19-20020a170906b21300b007c0f7af7c5emr7882192ejz.406.1670350239854;
        Tue, 06 Dec 2022 10:10:39 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709060a4a00b007c073be0127sm7569378ejf.202.2022.12.06.10.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:10:39 -0800 (PST)
Date:   Tue, 6 Dec 2022 19:10:50 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y4+FqsZLBzDzadcC@gvm01>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
 <Y49IBR8ByMQH6oVt@lunn.ch>
 <Y49THkXZdLBR6Mxv@gvm01>
 <Y49yxcd6m7K3G3ZA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49yxcd6m7K3G3ZA@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:50:13PM +0100, Andrew Lunn wrote:
> > OK, as you see I'm a bit "outdated" :-)
> > What would be the alternative? There is a bunch of vendor-specific PHY
> > features that I would like to expose at some point (e.g. regulation of
> > TX voltage levels). Thanks!
> 
> TX voltages sound like they are board specific, so use DT properties.
> 
> For runtime properties, look at phy tunables.
Ok, but as far as I understand tunables, these need to be "generalized".
I was wondering if there is some interface (sysfs / proc / other) to set
parameters which are very specific to a PHY implementation?

Thanks,
Piergiorgio
