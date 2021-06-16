Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E8D3A94DD
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhFPIXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhFPIXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 04:23:01 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5E2C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 01:20:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gt18so2396169ejc.11
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 01:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ru2SBHmz28+uA3lySyJ2uhSKXc1zhTGt5b7E1wqUV3E=;
        b=ovFsNuYAHIqoJ0khZ+6j3ZwwEv9a29xb8b0xOY9dn/xcyNOfCjsO6AMnM9GubyT4Hk
         0Ys++frhbT1hdZlqZHGsiyPoigvZorskvWtNrDh0THnNQKVQ8oD/k2UA+zHCuydV6G90
         fsGTx3sS/cRcfjalzWVexAt6M9wHFGtNo2erqLueKujwYqJGbvD/kaoyjW2ALVHZWbPU
         6FEWA3362FuRF7/bJytlTbLjHj9kswHKCK8Q04dNcOOWBePAfp4uviyD9isu6NgwFvSZ
         hmRcsqP0mrccIxIUZDlF69JjSAxAQtRdLzwl/47E/az/tnAWUxaEioXjKMcvrdA4NUFg
         96CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ru2SBHmz28+uA3lySyJ2uhSKXc1zhTGt5b7E1wqUV3E=;
        b=AVZl2U8V66agVyM+K5Ud0BHRWDmYM++cWPAGwmmV1YoJUA6d6Qmf3Si6M4TAJ0Lv01
         jqGlVCn1EUIoFAv4IwdXVvY6urlNm7MnX5HFoSX57rN/twJG1268fX8rZcGlR/MU9s6h
         DyzyOvdM4r8x94ots+B3IP8fBtbxsr8TGM0eZhkWw0FU+C1b4sq1GLTfaEmy1VLKDdAm
         m+KfYbs9KPZRCvjkS7R6FUHmkjcux0Smi3uSLcnsXlXfEyBIKZY1KKBF/VFhL8fydw+T
         /+MpcwfSv57vjiamoRM1k7KT36ryWee/eQHspSCzVez7Pg1qIpv4bLewCUj2OWdxmU0+
         L3RQ==
X-Gm-Message-State: AOAM533FQRoGJJ44yPed/OsyoL03tCdLbcDf2W99xINA1WAPvXKBT75w
        Dgv8TwL4ErsOow5Ppy/2WZk=
X-Google-Smtp-Source: ABdhPJzqPgfz250U812I5ukMubkpFI+1n96/E+Nzh+xZ+45Fpz4DwY3rWIfeTLPHdSXuf7JPihYyUg==
X-Received: by 2002:a17:907:10c3:: with SMTP id rv3mr1096571ejb.420.1623831653938;
        Wed, 16 Jun 2021 01:20:53 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id y10sm1054428ejq.50.2021.06.16.01.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 01:20:53 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Wed, 16 Jun 2021 11:20:52 +0300
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210616082052.s56l54vycxilv5is@skbuf>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
 <YMjx6iBD88+xdODZ@lunn.ch>
 <20210615210907.GY22278@shell.armlinux.org.uk>
 <20210615212153.fvfenkyqabyqp7dk@skbuf>
 <YMkcQ6F2FXWvpeKu@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMkcQ6F2FXWvpeKu@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 11:31:47PM +0200, Andrew Lunn wrote:
> > The fwnode_operations declared in drivers/acpi/property.c also suggest
> > the ACPI fwnodes are not refcounted.
> 
> Is this because ACPI is not dynamic, unlike DT, where you can
> add/remove overlays at runtime?
> 

I am really not an expert here but the git history suggests so, yes.

Without the CONFIG_OF_DYNAMIC enabled, the fwnode_handle_get() call is
actually a no-op even in the OF case.

Ioana

