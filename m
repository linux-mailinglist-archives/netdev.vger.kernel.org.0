Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D6B33D1AB
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbhCPKTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhCPKTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 06:19:04 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D612C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:19:04 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w18so20814292edc.0
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+BTm7OFQw/Kpub4WceuFX57j7TgIW6bHHhkdzvJCW2g=;
        b=C8z5FXjWyrnawU6MGSQI9W8Kvhmm+7JkbR166xgQtwaSB0OYo5cQ/ae3eRtGkg0OIy
         4lZFnse/c+g4b+1WhEn72cBlcZTVMfuGIwffZR/MeLNXWzRuD0J8nmRlBOzePf/btymb
         tZ34dMCNx+hN3SamHa8Zg0fkLHFbQ94mcdJziIqc+2tgNnY/p0dn3t0iHSmLLRiTHrMB
         +fO9LwGgBzsCg6lWjwiWQ5ogoiYLEybCl8OPTgBlqgVv+EQ5MfrrkI2zWn/O1uj6tPTi
         YL5A94BnmTmWvNxLatyJhCTLR3ZS+EejvMiBV+eKI5rofA9+KnykDKvtTLK4Jk402iXQ
         drNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+BTm7OFQw/Kpub4WceuFX57j7TgIW6bHHhkdzvJCW2g=;
        b=TIrbU3LYdDRf4fOhmha/RoV6wAbkXQEO6qamkAKIIeYDOEu9g9JlJM7zCK3MRjNB0o
         nRDdDSy1IYEsvXCoeDpIpVYsL1ryzrX0Kym7Nhg1BUa5w0HOo+6DqEo1t1dYidZRwM0Q
         j10nJu4O4qS7YAoWT02K6lnS3/fk/tzfYj3zExV/31MZbvM87XHeyTWUOxsJvnVAH/To
         2+l/J2dR1H3u4W2MjEzZECEcailQGAuDr55DqdLkTWlyytWfL8UIeTb2rOXwNA0BbqEj
         e7IZQjuMyl9ngCtQyaGzcQXX0LV1K0mn5BUfO/q5QiPqUU9nyFJHiXazzzcz66XgFoH8
         VDMg==
X-Gm-Message-State: AOAM532R1iWGIjm68lbXxyx3JJBhlftBdrsnW2P+mlEJUznELoUNx5gp
        Pd5ZPQExHYxagLlq/FUp1t0=
X-Google-Smtp-Source: ABdhPJx1LAHR4RH0QrudkuMNdMaOMnCn1r4qTSduAIQ67Dn6He9Sm3wGcKiGPX2Z3zakMeMq4Mqx+A==
X-Received: by 2002:a50:ee10:: with SMTP id g16mr34610861eds.215.1615889942404;
        Tue, 16 Mar 2021 03:19:02 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i10sm9212558ejv.106.2021.03.16.03.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 03:19:02 -0700 (PDT)
Date:   Tue, 16 Mar 2021 12:19:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: add a helper to avoid issues with HW TX
 timestamping and SO_TXTIME
Message-ID: <20210316101901.gkcdczquxrtwpydh@skbuf>
References: <DBBPR04MB781851A0F0CD632E2E1AE1A292909@DBBPR04MB7818.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBBPR04MB781851A0F0CD632E2E1AE1A292909@DBBPR04MB7818.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

On Thu, Mar 11, 2021 at 02:30:12AM +0000, Po Liu wrote:
> Hi
>
> Can it just move
>
>  skb->tstamp = ktime_set(0, 0);
>
> into
>
> skb_tstamp_tx(skb, &shhwtstamps);
>
> if it always need to clear for HW tstamp setting.

I don't know if that works under all circumstances. Also, to keep the
driver interface consistent, we would also need to plug that into
skb_complete_tx_timestamp, for the case when the driver is working with
a clone directly.
It just seemed simpler to me to modify the few drivers which use SO_TXTIME.
