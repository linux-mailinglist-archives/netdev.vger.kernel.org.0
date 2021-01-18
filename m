Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464AE2FA0C8
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392010AbhARNE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 08:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391984AbhARNEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 08:04:14 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6184DC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 05:03:33 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 7so9146910wrz.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 05:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RLAEcWWDORO8DwbPSfRV6twdmYvuyhVRUfasBTOU8aQ=;
        b=uiK1SFUy/zhnEpJeYAiYZ9cT3lg3Lllim4aF6jLTR5AQTuw/t63fYw/wkhwpsZvTBm
         3Wv0m5UP4PchmqNurOzdPDszWCOZzRRl05NsKvLYSyyrvTE1ydJpXvs71sWgemm8E+7G
         UFwtX5UcPbdyoYm81h7Xidsr510toUZWNEgrkWfrX/SLI3zye2XiOu2Fu3in35SF/jUm
         gBcUlA1DOASiiNeBM5aINV2jTbyrlMBD9vpaUuJl4H0dpeR/tMhjLNYlkw6ssxxp/wLR
         z7NLgnHdryLpNz2DUGZbCasWca+pLGYZYeUigwxRONkS3pUWrHf5JdjpKiArxvKBuuN2
         UvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RLAEcWWDORO8DwbPSfRV6twdmYvuyhVRUfasBTOU8aQ=;
        b=ctS/k6loqTTJeun15SL7nTeVUC9CYVj91rjpsbRsjRxmknMzpLHjly/DHFffoAtbi4
         9R+SO4cgCc6VXtAKzwn/0APvNfww911Gr62ovTEullrr99iWE+1BSqz452UApkDywloZ
         Eh5XkDTTPKkRPtzSsRSjFv72yiSFCHlAWURm1KiaTBH5tuPKCF/5GIFKchb0ot8DkcWv
         MLjwUvqJj9ZzLSHKkZxKU4tYwguXQQitz272BcrtA8TMI8A+QAUpF/XfXQCjJANUHwt7
         25eKxz0sf+mz3obpeIB3wD8N/d5KGJRn+qsigjmMMJI7kAWNucBELD+uxq3ujvHW92EC
         VVaA==
X-Gm-Message-State: AOAM530ApFT1/okL67hw4ojjgEse+rAT3sWCMsmJkM1SHLLgfuSFJXsp
        DVqRfOoT69RWsdqWs0oCCXGjfQ==
X-Google-Smtp-Source: ABdhPJyibPuXjkOer++8JFTKrjUGIYNkrdsRCcVd88lWBEmKpc9IVvQbgRwQidMmMzYxZYpHkjp6Ng==
X-Received: by 2002:adf:9525:: with SMTP id 34mr26415084wrs.389.1610975012184;
        Mon, 18 Jan 2021 05:03:32 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id k16sm12057804wmj.45.2021.01.18.05.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 05:03:31 -0800 (PST)
Date:   Mon, 18 Jan 2021 14:03:31 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210118130331.GV3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210115154357.GA2064789@shredder.lan>
 <20210115165559.GS3565223@nanopsycho.orion>
 <20210115180145.GA2074023@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115180145.GA2074023@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 07:01:45PM CET, idosch@idosch.org wrote:
>On Fri, Jan 15, 2021 at 05:55:59PM +0100, Jiri Pirko wrote:
>> Fri, Jan 15, 2021 at 04:43:57PM CET, idosch@idosch.org wrote:
>> >On Wed, Jan 13, 2021 at 01:12:12PM +0100, Jiri Pirko wrote:
>> >> # Create a new netdevsim device, with no ports and 2 line cards:
>> >> $ echo "10 0 2" >/sys/bus/netdevsim/new_device
>> >> $ devlink port # No ports are listed
>> >> $ devlink lc
>> >> netdevsim/netdevsim10:
>> >>   lc 0 state unprovisioned
>> >>     supported_types:
>> >>        card1port card2ports card4ports
>> >>   lc 1 state unprovisioned
>> >>     supported_types:
>> >>        card1port card2ports card4ports
>> >> 
>> >> # Note that driver advertizes supported line card types. In case of
>> >> # netdevsim, these are 3.
>> >> 
>> >> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
>> >
>> >Why do we need a separate command for that? You actually introduced
>> >'DEVLINK_CMD_LINECARD_SET' in patch #1, but it's never used.
>> >
>> >I prefer:
>> >
>> >devlink lc set netdevsim/netdevsim10 index 0 state provision type card4ports
>> 
>> This is misleading. This is actually not setting state. The state gets
>> changed upon successful provisioning process. Also, one may think that
>> he can set other states, but he can't. I don't like this at all :/
>
>So make state a read-only attribute. You really only care about setting
>the type.
>
>To provision:
>
># devlink lc set netdevsim/netdevsim10 index 0 type card4ports
>
>To unprovsion:
>
># devlink lc set netdevsim/netdevsim10 index 0 type none
>
>Or:
>
># devlink lc set netdevsim/netdevsim10 index 0 notype

Hmm, okay, that might work. And I can add state "FAILED_PROVISION" what
would indicate that after the type was set by the user, driver was not
able to successfully provision. The the user has to set "notype" & "type
x" again. Sounds good?


>
>> 
>> 
>> >devlink lc set netdevsim/netdevsim10 index 0 state unprovision
>> >
>> >It is consistent with the GET/SET/NEW/DEL pattern used by other
>> >commands.
>> 
>> Not really, see split port for example. This is similar to that.
>
>It's not. The split command creates new objects whereas this command
>modifies an existing object.

You are right.


>
>> 
>> >
>> >> $ devlink lc
>> >> netdevsim/netdevsim10:
>> >>   lc 0 state provisioned type card4ports
>> >>     supported_types:
>> >>        card1port card2ports card4ports
>> >>   lc 1 state unprovisioned
>> >>     supported_types:
>> >>        card1port card2ports card4ports
>> >> $ devlink port
>> >> netdevsim/netdevsim10/1000: type eth netdev eni10nl0p1 flavour physical lc 0 port 1 splittable false
>> >> netdevsim/netdevsim10/1001: type eth netdev eni10nl0p2 flavour physical lc 0 port 2 splittable false
>> >> netdevsim/netdevsim10/1002: type eth netdev eni10nl0p3 flavour physical lc 0 port 3 splittable false
>> >> netdevsim/netdevsim10/1003: type eth netdev eni10nl0p4 flavour physical lc 0 port 4 splittable false
>> >> #                                                 ^^                    ^^^^
>> >> #                                     netdev name adjusted          index of a line card this port belongs to
>> >> 
>> >> $ ip link set eni10nl0p1 up 
>> >> $ ip link show eni10nl0p1   
>> >> 165: eni10nl0p1: <NO-CARRIER,BROADCAST,NOARP,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>> >>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>> >> 
>> >> # Now activate the line card using debugfs. That emulates plug-in event
>> >> # on real hardware:
>> >> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>> >> $ ip link show eni10nl0p1
>> >> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>> >>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>> >> # The carrier is UP now.
>> >> 
>> >> Jiri Pirko (10):
>> >>   devlink: add support to create line card and expose to user
>> >>   devlink: implement line card provisioning
>> >>   devlink: implement line card active state
>> >>   devlink: append split port number to the port name
>> >>   devlink: add port to line card relationship set
>> >>   netdevsim: introduce line card support
>> >>   netdevsim: allow port objects to be linked with line cards
>> >>   netdevsim: create devlink line card object and implement provisioning
>> >>   netdevsim: implement line card activation
>> >>   selftests: add netdevsim devlink lc test
>> >> 
>> >>  drivers/net/netdevsim/bus.c                   |  21 +-
>> >>  drivers/net/netdevsim/dev.c                   | 370 ++++++++++++++-
>> >>  drivers/net/netdevsim/netdev.c                |   2 +
>> >>  drivers/net/netdevsim/netdevsim.h             |  23 +
>> >>  include/net/devlink.h                         |  44 ++
>> >>  include/uapi/linux/devlink.h                  |  25 +
>> >>  net/core/devlink.c                            | 443 +++++++++++++++++-
>> >>  .../drivers/net/netdevsim/devlink.sh          |  62 ++-
>> >>  8 files changed, 964 insertions(+), 26 deletions(-)
>> >> 
>> >> -- 
>> >> 2.26.2
>> >> 
