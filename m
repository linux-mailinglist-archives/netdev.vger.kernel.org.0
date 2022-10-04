Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599D65F3CFA
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 08:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJDG4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 02:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJDG4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 02:56:20 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151412DABB
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 23:56:19 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id z23so10047758ejw.12
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 23:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+tcn9B7Ym8UONbEc5EvJpUWZ3bzMEiRSGSgK5uDh3Sc=;
        b=ic3g3krgCZxWT2MmFGd0e131DBRZaVGX4SX7ueo5RYe4yrJOBu9UjJJq21eTtuHlwI
         1Us8YtCkExouFVIhzLrZ9mVKOEl94t/XEDZf3W6D6dXA0kHGbQs8lcPlDcewdjmbysMi
         LFyHjWHAQC7KfkcXPfBLaOA9ugwVn+xqRP8iS/55+yFCkZje+bwyOrdxjXYfyiutl0UK
         jHQywcdko5pN9iNdp662Xz6HO3+5Wkis+09uKcYCo8wVyXFWAUUiCDJMNUony8sGOZyL
         epr7+7wMqHYwzNMX8hpr1oOI0LvViTzA4NnbzsRWN+pYkSnlgaoPeNX/plVi/7fpaoI5
         NT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+tcn9B7Ym8UONbEc5EvJpUWZ3bzMEiRSGSgK5uDh3Sc=;
        b=1veztsEolhJ2DnlubFwwlwsT4SlIMCrv5LzqaCUM1K8dcAK3nI/PxcLs/SaFddfnig
         vYTBC33GVER+49T6W78hFCHHjm9+ITUU+KGmkNOzCmMUGQVeykafuV0U2CqT++82kZZV
         xWZFMcefmI/3nmFPdUFi5PldePa9U8bSXvTkmtPUxzt+c5GNnTrw/BY+3eSIGKDnBeLN
         3cN5jlUyhJx8DGH3G00KI2Zasv7VlnCSPYgQ1yiAVgz23IjkSmCJvCmtFcPP6N6nc3V6
         eqW0pQgoqohNJqqazPas1x39X3GPx3N0DgEV3BoXSU5iHirhxDv2XWWsd6FU6sOAzaAh
         euHA==
X-Gm-Message-State: ACrzQf1wFWO8i5XGhcXFpLWhi5p1PKLAHKeWBSnY7xUvWTLRdCGOWS1H
        VUDfsF7qX0FT4Wasg9qttP7/Wg==
X-Google-Smtp-Source: AMsMyM6q7CanQFsXNr9PR5MUNCDJkkeS0Fb8NDXZLxXrJWUQ38BsN/3e2MM+M6lhZxSoagpmZvRbMA==
X-Received: by 2002:a17:907:724e:b0:783:5fba:4298 with SMTP id ds14-20020a170907724e00b007835fba4298mr19360005ejc.28.1664866577564;
        Mon, 03 Oct 2022 23:56:17 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g25-20020a056402321900b004542e65337asm1046089eda.51.2022.10.03.23.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 23:56:16 -0700 (PDT)
Date:   Tue, 4 Oct 2022 08:56:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v2 00/13] net: fix netdev to devlink_port
 linkage and expose to user
Message-ID: <YzvZEDTM1FVOX9BC@nanopsycho>
References: <20221003105204.3315337-1-jiri@resnulli.us>
 <20221003094556.1f16a255@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003094556.1f16a255@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 03, 2022 at 06:45:56PM CEST, kuba@kernel.org wrote:
>On Mon,  3 Oct 2022 12:51:51 +0200 Jiri Pirko wrote:
>> Currently, the info about linkage from netdev to the related
>> devlink_port instance is done using ndo_get_devlink_port().
>> This is not sufficient, as it is up to the driver to implement it and
>> some of them don't do that. Also it leads to a lot of unnecessary
>> boilerplate code in all the drivers.
>> 
>> Instead of that, introduce a possibility for driver to expose this
>> relationship by new SET_NETDEV_DEVLINK_PORT macro which stores it into
>> dev->devlink_port. It is ensured by the driver init/fini flows that
>> the devlink_port pointer does not change during the netdev lifetime.
>> Devlink port is always registered before netdev register and
>> unregistered after netdev unregister.
>> 
>> Benefit from this linkage setup and remove explicit calls from driver
>> to devlink_port_type_eth_set() and clear(). Many of the driver
>> didn't use it correctly anyway. Let the devlink.c to track associated
>> netdev events and adjust type and type pointer accordingly. Also
>> use this events to to keep track on ifname change and remove RTNL lock
>> taking from devlink_nl_port_fill().
>> 
>> Finally, remove the ndo_get_devlink_port() ndo which is no longer used
>> and expose devlink_port handle as a new netdev netlink attribute to the
>> user. That way, during the ifname->devlink_port lookup, userspace app
>> does not have to dump whole devlink port list and instead it can just
>> do a simple RTM_GETLINK query.
>
>Would you be okay if we deferred until 6.2?
>
>It's technically past the deadline and some odd driver could regress.

Sure.
