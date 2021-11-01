Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB46441D1E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 16:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhKAPIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 11:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAPIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 11:08:22 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98734C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 08:05:48 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso166901wmf.0
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cjae5n9hDQeOgk+WpalWcYBHg2QS6ACEIp1c40lLqYw=;
        b=XCh40Vq7I/cjqsEIX3jS9xD6yso5MMd4Yvbz9MV27IGRnB+9pa1bN+crJEZQlKOYBj
         Sq/kIv8Qq5fWLWrJ5wKZ0oCYlBq6oLfg386uzwM2mxQU7ZOQFZE6FLkZdafJhk9CJOi+
         RD8Polk8Wtl6QOJBTQednoByGqZG6M4MRlytXSbmJb8MeAgXSaqHOIws1ytbAL+yy6qH
         zfVWZEeYBsbNwAijkVhiV+cJv2gCs0Kmu0q2wLomAhf9nkSXZbc2aCvNagxmQcllZbQk
         hu+lJQkNQLGFyH45MUJIbIBWK1ed57jtY563byCpRf/4Ujoxm1k0S4UlVn4oyyF9ehTG
         UsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cjae5n9hDQeOgk+WpalWcYBHg2QS6ACEIp1c40lLqYw=;
        b=zy7lSAwtgatwf9Hx6qY2GD5R1jikcOkIQPknnjHVPuSXZyMmTNt5yH2O8efV6g/Trn
         bawBqRk3cY/XnB9nggzTYGO9zkDe02/bMc6CklaNCNRJhxq95fh873X2gIKtqqGHNLnL
         2/YHGfrGnfYINuWT6ePh9ZNZPWXwLOkTwd/uGNiwOfdWrO/3vtEM32Qic6yDI9do3AmP
         4wlrW+lqjR/1VCgNRGPhdzGGm6SQ9ebd/oD+EkNW6vwIYOcb41ijvchvKXLGJDcgQIGi
         kiaZgDk+58k7FLk1+t2g7tTqC9d2Wd6qZz6e6YFsMyd9FJvZhzTVg0s2d7EOhy/79gSU
         EQKQ==
X-Gm-Message-State: AOAM532F80bNj/iFhJBcZETN+Xsh7LuUOd0y0pjEJqc83WUiy2rMhZYU
        I2m/nUP6wyGJeh6GTlHDloN/+A==
X-Google-Smtp-Source: ABdhPJy+xeni/ONEILIRHTd2NBP9A88H7rDCIeS/FIfOKhEJyvpwKW4GRAWOkRPhWGuZWpApGHxQtA==
X-Received: by 2002:a1c:29c6:: with SMTP id p189mr10839940wmp.129.1635779147255;
        Mon, 01 Nov 2021 08:05:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l26sm4128323wms.15.2021.11.01.08.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 08:05:46 -0700 (PDT)
Date:   Mon, 1 Nov 2021 16:05:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] Code movement to br_switchdev.c
Message-ID: <YYACSc+qv2jMzg/B@nanopsycho>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 27, 2021 at 06:21:14PM CEST, vladimir.oltean@nxp.com wrote:
>This is one more refactoring patch set for the Linux bridge, where more
>logic that is specific to switchdev is moved into br_switchdev.c, which
>is compiled out when CONFIG_NET_SWITCHDEV is disabled.

Looks good.

While you are at it, don't you plan to also move switchdev.c into
br_switchdev.c and eventually rename to br_offload.c ?

Switchdev is about bridge offloading only anyway.


>
>Vladimir Oltean (5):
>  net: bridge: provide shim definition for br_vlan_flags
>  net: bridge: move br_vlan_replay to br_switchdev.c
>  net: bridge: split out the switchdev portion of br_mdb_notify
>  net: bridge: mdb: move all switchdev logic to br_switchdev.c
>  net: bridge: switchdev: consistent function naming
>
> net/bridge/br_mdb.c       | 238 +-----------------------
> net/bridge/br_private.h   |  28 ++-
> net/bridge/br_switchdev.c | 371 ++++++++++++++++++++++++++++++++++++--
> net/bridge/br_vlan.c      |  84 ---------
> 4 files changed, 372 insertions(+), 349 deletions(-)
>
>-- 
>2.25.1
>
