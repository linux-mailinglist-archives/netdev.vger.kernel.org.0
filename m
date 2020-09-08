Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532DC2614F6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbgIHQlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732045AbgIHQhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:37:15 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FA5C061A0C
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:04:13 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i1so15977247edv.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pFSueD/PsgBNg5dRi4zohukePJNmnDKu8o6l7DjyJKo=;
        b=NDNqSTa7fZTWmXjbEiT8n88ebqol0L6AQtiZu/8Oqe+mwkyHcxNQJF45p8QJ0vEHmj
         7vURBe4Ohu2fjAEu7i/ry1GBIIfFl5TaPBxPz79QVbYcSu/nefGedb+ubeX8CBrtqttl
         vRGrgNRtPpVQZ+TMKn4V+lOBfVl8T3XmT0sIYxxoJEu8HiVHdWijgtU1BxjViT0f9tcH
         voD1jgHdPNU8GQLdGstctvcCBJ8Zt6MVhQfE/PW9Z+rDarmVbuJR0lGYHgfbnujN7om3
         y37QDLUOfw5y6g0/x4GMg5xEeVirg0uNqjcdA2LuSj5fJgji6JndSYaglSRH3naDUxq7
         R8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pFSueD/PsgBNg5dRi4zohukePJNmnDKu8o6l7DjyJKo=;
        b=DqLDmHJGMQ5N5QryG1B5ZU0vN9xRLVGrkj0BLse2Xj1ibNDkxsMQadCmVbVaMXtelP
         U4vPjot2aqIcpOcaw49onbFgXg7nGTXXEiVn6xtPBTwzjAJb0sfw/RMZVb3KksrtAitq
         Cp9B4icmy58WOFcX/c8yobGcP75Aa+4aORwHtAbXt5Mech0AqR1ETCukvBV7OmrLaSYp
         +qL4ENSXrHeyb0yUBmik4Pw1WxeZykBNt5Yb9jiPrUo55yB4Gu2Ybh+P2gwF2fOeteQs
         23J3aRSZkmC94+GtKLYljAoakJt5KSgmaVqRQ1XVZdVSb85H/z6o95LbpDhNSBY+kOyJ
         Uo+Q==
X-Gm-Message-State: AOAM53238/7zzD6g/KhZu1yQUz59Xi742FPS66PQIyU84poUWTmFWACK
        /tFMHbKThbFwbVvyDkYP/82oQg==
X-Google-Smtp-Source: ABdhPJyJCTFd0pn3p9yrebWEYoQaThaFvclLZLNU4bDenEbLK2WJOX0hyPvDit0IltNHfqOzyUsBQQ==
X-Received: by 2002:a50:8e17:: with SMTP id 23mr26671696edw.42.1599573851439;
        Tue, 08 Sep 2020 07:04:11 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v4sm17839598eje.39.2020.09.08.07.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 07:04:10 -0700 (PDT)
Date:   Tue, 8 Sep 2020 16:04:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Aya Levin <ayal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v1 2/4] devlink: Add devlink traps under
 devlink_ports context
Message-ID: <20200908140409.GN2997@nanopsycho.orion>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
 <1599060734-26617-3-git-send-email-ayal@mellanox.com>
 <20200906154428.GA2431016@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906154428.GA2431016@shredder>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 06, 2020 at 05:44:28PM CEST, idosch@idosch.org wrote:
>On Wed, Sep 02, 2020 at 06:32:12PM +0300, Aya Levin wrote:

[...]

>
>I understand how this struct allows you to re-use a lot of code between
>per-device and per-port traps, but it's mainly enabled by the fact that
>you use the same netlink commands for both per-device and per-port
>traps. Is this OK?
>
>I see this is already done for health reporters, but it's inconsistent
>with the devlink-param API:
>
>DEVLINK_CMD_PARAM_GET
>DEVLINK_CMD_PARAM_SET
>DEVLINK_CMD_PARAM_NEW
>DEVLINK_CMD_PARAM_DEL
>
>DEVLINK_CMD_PORT_PARAM_GET
>DEVLINK_CMD_PORT_PARAM_SET
>DEVLINK_CMD_PORT_PARAM_NEW
>DEVLINK_CMD_PORT_PARAM_DEL
>
>And also with the general device/port commands:
>
>DEVLINK_CMD_GET
>DEVLINK_CMD_SET
>DEVLINK_CMD_NEW
>DEVLINK_CMD_DEL
>
>DEVLINK_CMD_PORT_GET
>DEVLINK_CMD_PORT_SET
>DEVLINK_CMD_PORT_NEW
>DEVLINK_CMD_PORT_DEL
>
>Wouldn't it be cleaner to add new commands?
>
>DEVLINK_CMD_PORT_TRAP_GET
>DEVLINK_CMD_PORT_TRAP_SET
>DEVLINK_CMD_PORT_TRAP_NEW
>DEVLINK_CMD_PORT_TRAP_DEL
>
>I think the health API is the exception in this case and therefore might
>not be the best thing to mimic. IIUC, existing per-port health reporters
>were exposed as per-device and later moved to be exposed as per-port
>[1]:
>
>"This patchset comes to fix a design issue as some health reporters
>report on errors and run recovery on device level while the actual
>functionality is on port level. As for the current implemented devlink
>health reporters it is relevant only to Tx and Rx reporters of mlx5,
>which has only one port, so no real effect on functionality, but this
>should be fixed before more drivers will use devlink health reporters."

Yeah, this slipped trough my fingers unfortunatelly :/ But with
introduction of per-port health reporters, we could introduce new
commands, that would be no problem. Pity :/


>
>[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ac4cd4781eacd1fd185c85522e869bd5d3254b96
>
>Since we still don't have per-port traps, we can design it better from
>the start.

I agree. Let's have a separate commands for per-port.


[...]
