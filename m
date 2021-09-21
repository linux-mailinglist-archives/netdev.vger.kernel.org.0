Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C906F412EF5
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhIUHDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhIUHDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 03:03:54 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BD2C061575
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:02:26 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d21so36081963wra.12
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fusWwRhGhDwMDvQIF2rL+xIXyvzxwvV+7P1DjBX2OMs=;
        b=17ypAGfGNToM0JSjgeiOeGU851YZP0qvqVdPT5/wmSGdUXJ3vAdN4BAOh9A7cDHB5a
         AnweVmVoZRkGEn+GBVrYIQJd5My/8znNb84Dvybfp4W0w9vScptNps5QF4U38ECx8tco
         2CUiLk/agsteCVIQEkd6qe8/ZujmvYC530UJdreb3wyzUMUX856xFPlfx76NWSoFwnG1
         TJ/Ec8u3HAEpAo2vhZp3kkGaHNZllUxLafsuh5no2ljfi6wB0kQS2njBg3M1W6AX7AaO
         aSE5wCot9OdHYI6j7SWUcVGhTfLuNKk3qPN4/rl2YtlAcak1FryT5nuJWc9hr7UMCrut
         ETNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fusWwRhGhDwMDvQIF2rL+xIXyvzxwvV+7P1DjBX2OMs=;
        b=UphGAob+eOy9UNjhdVc07SEvuzzJg4JcNRZShP/eYVUtjaagfEbMSxuRJRwwyPYGEc
         qym2afuPuMfvfww0ek40tNGlszxsatJMzopMzdWbQaFvfxc7o5ygyiYDg97ONzcoDzPl
         k7bpyEw1FKC0xQjrTMDknSCBDPJhw1292Xb50ryn2sMZsS1De3dIo16SouAccDJlfSiK
         dJ2SPb/lUhrOn2S8nHZ1n9CApaFZOqw8Oz0EatAWt8ejRyZKFnt9tHQVFjG4QW/2K1wX
         svkhypAh4uqyrxSbxySnNlIx+rI5e2OweuqMNbI6OF5YxJRLGZxBe0kvnKakHReeIdvX
         +viA==
X-Gm-Message-State: AOAM5305oXTSDQ4fATmlrCoQpWXzZr/PoUCKval410FbuqXs7KGx5brT
        4kKWlQrRC2I+fu6xEQ4TnsQchg==
X-Google-Smtp-Source: ABdhPJz0OlMS4q0UvEdCzO4nXU7/PwGZ8ozvQmNUB80OlTlbJwb+ceMDZjLzoyimOSm5UKvaW2UlrA==
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr17856595wrz.439.1632207745235;
        Tue, 21 Sep 2021 00:02:25 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r25sm19674308wrc.26.2021.09.21.00.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 00:02:24 -0700 (PDT)
Date:   Tue, 21 Sep 2021 09:02:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next] devlink: Make devlink_register to be void
Message-ID: <YUmDf3KdLS/4FwoT@nanopsycho>
References: <2e089a45e03db31bf451d768fc588c02a2f781e8.1632148852.git.leonro@nvidia.com>
 <20210920133915.59ddfeef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920133915.59ddfeef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 20, 2021 at 10:39:15PM CEST, kuba@kernel.org wrote:
>On Mon, 20 Sep 2021 17:41:44 +0300 Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>> 
>> devlink_register() can't fail and always returns success, but all drivers
>> are obligated to check returned status anyway. This adds a lot of boilerplate
>> code to handle impossible flow.
>> 
>> Make devlink_register() void and simplify the drivers that use that
>> API call.
>
>Unlike unused functions bringing back error handling may be
>non-trivial. I'd rather you deferred such cleanups until you're 
>ready to post your full rework and therefore give us some confidence 
>the revert will not be needed.

Well, that was the original reason why I made it to return int, so the
drivers are prepared. But truth is that given the time this is on and
the need to return int never really materialized, I tend to ack with the
cleanup.
