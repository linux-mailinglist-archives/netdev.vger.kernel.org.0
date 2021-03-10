Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452BB334025
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 15:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhCJOSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 09:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhCJOSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 09:18:04 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD02C061761
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 06:18:03 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b7so28307780edz.8
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 06:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZOMbdt2jYhzS0iZSgxipqKARVsc2/K43s6bXyRyClY0=;
        b=FkRJilFssFS42KgiRZWNEogo/vRPslKOuPMmGGuwwc0Qo+g0pNt1peyO7sgMygTXpa
         Ccxf65326ucv6g0X4dYKZ3d2WXfArAWSfZz8G8IIxHYR5pvgtneUYpvXRyGfWSiCGQ3X
         Y7GAPKZraY+yQLD6qermc0BC5tEQdnXNuc7umtbq8g68dbKaM0Zecf2+gsV7w8JIlaKb
         52fYUj3WspFow5NwHpObJEIE/eaJbQA/dhr+7AhoflO2oBSETn/rDJeb6I8/YQgk7uJG
         WT8I0FyXpeFGUIeENWhrwTLpleVq/LexlripenMB9SBapquUrvWiCdDEppCdDOZCq8kB
         CfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZOMbdt2jYhzS0iZSgxipqKARVsc2/K43s6bXyRyClY0=;
        b=J0TJMzVH8UzGysLuarBGsJk44N8vy6RNU+6BOKQ3qJgx9sQCrhyJCFLYM+3BinA1YA
         6EBpf5SccvEVniD7laqg8hFZBeQJYOkwPHd7CP0PZ2llz0t2SkK25xFbhYa1wEVxR2vc
         Y0wggC0uL1B0wWgJTjFcBUVp3HIWxL2fW3GCIrDXPZpO0dK6WuAQekru8w/7JOpYc/ti
         OktqDhlxRR2dD17Ro1zvo+DfMgDIazSXnbv6B7M/dHOE7XZ+bM3YBa+Ceq6F8CZpUR5U
         FG930Lo4Civ3aPpHvCnIl7wP9+U7AZlbvSLuo8nq/ZaxYa5tfLO9vOwac79AZZEhdOUx
         MEnw==
X-Gm-Message-State: AOAM531KIOS/ixtzPX3U4z/qwiU2zO7TVKeG45RmtI/PiUlNzAIgqs0+
        dcc741ctLKby1gjvpRWhyWE=
X-Google-Smtp-Source: ABdhPJwRb9SugRauxW9Wyu3GGtkamG36dtcT9ClPZ5N/gNpnISSTHUM4X1DfnXSU6N97q4pjLTFfeQ==
X-Received: by 2002:a05:6402:1283:: with SMTP id w3mr3522782edv.340.1615385882625;
        Wed, 10 Mar 2021 06:18:02 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id t15sm11571550edc.34.2021.03.10.06.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 06:18:02 -0800 (PST)
Date:   Wed, 10 Mar 2021 16:18:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and
 move out of staging
Message-ID: <20210310141801.v5cq2ndqnoi3wucy@skbuf>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
 <YEi/PlZLus2Ul63I@kroah.com>
 <20210310134744.cjong4pnrfxld4hf@skbuf>
 <YEjT6WL9jp3HCf+w@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEjT6WL9jp3HCf+w@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Greg,

On Wed, Mar 10, 2021 at 03:12:57PM +0100, Greg KH wrote:
> > Ok, I am mainly interested in getting all these patches into net-next as
> > well so that other general switchdev changes do not generate conflicts.
>
> What other general switchdev changes?

During the merge window I sent some RFC patches that change the
interaction between all switchdev drivers and the bridge:
https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-17-olteanv@gmail.com/

I would like to be able to submit that patch as non-RFC (to the net-next
tree, of course) during this release cycle, and it touches the dpaa2
switch.

Let's see what the network maintainers think about dealing with this
cross-tree situation.
