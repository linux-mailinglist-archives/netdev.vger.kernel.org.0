Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82208325FEC
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhBZJXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhBZJVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:21:34 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE76C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:20:53 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id a17so12390386lfb.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ndqUWIvQWOF/d8LZmKzg4/WosPvKARS58S9vLjqTViI=;
        b=JOrHQU2RMxWUoeGHtv+k60Bq07tTGARTb8fXyfMQ5DD0yvbYWyMEBCRqyI+fIDyX5u
         p6JgALwDrJcj6lAYXW8LgsNDcXbU1ashyOyu9SWPwuencWlZttc2zL8hHiSYEekEDTA+
         74Mdf5eXDP3TXBi/GLk8BPRAvx+YgQUtNBI/a3Blcycr3HBXpFZudzq3DwbsnkYPSSnd
         YbBqzUqjHw/DhceXIJhH4ZUb0QHNv3OXZy2DmeAYkq/tFsyUI2h77iXGvlVpkHeHfARe
         nsixETFb4Z/GcAYFVU3WN/BqGUtRcRvOemX7otLeQW4sdLrZTaEyVz7MdtpmrbhCnq99
         UY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ndqUWIvQWOF/d8LZmKzg4/WosPvKARS58S9vLjqTViI=;
        b=JUJgekDphwSHIHWI62nYa9csie1bOnB5dB3K8Lh7buEH79bTPNS6jPTHDl5eCy4Za1
         eYKS4l7Vgx8FA1sm6JPPCyu+iqfhA5C5UDx6fJT5ZjcWkZJddYqCnydgABavBIdJUJOv
         RwP494g5TGYNpgSykXrYglWaMmsQaAxbj3k7vSLtWKd8xAMMdqEMRYqTHl0Llb4UUBHQ
         HxRRTR4ohjJsBoAq0t1sg3iXUNtbSMUtswivBAfRKHQdZcjrYqblmBYJC7tgMFLkVpNz
         VagQL+4vUgcn5tHe6Rd+QkdVZ34O3IwakBcwJ4pZlVMhiNeAK/3OLCN6HZJFnAGEzE4R
         TEaw==
X-Gm-Message-State: AOAM530R3XPpiB4eLAk7xBuqawsj09TCROMvvSPHxUTLn1k31hC65N98
        B4plvxn5Fhk05+OaXHyu9uhRrw==
X-Google-Smtp-Source: ABdhPJxIalxzKo03yxQ99BxZA/ChkuJVOFSw3q76UO+YwLh7/oW9G45ttvhY7KiwiMJ+qUab13Em/A==
X-Received: by 2002:a19:ec1a:: with SMTP id b26mr1196430lfa.610.1614331251973;
        Fri, 26 Feb 2021 01:20:51 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q13sm807505lfr.99.2021.02.26.01.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 01:20:51 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 01/17] net: dsa: reference count the host mdb addresses
In-Reply-To: <20210224114350.2791260-2-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com> <20210224114350.2791260-2-olteanv@gmail.com>
Date:   Fri, 26 Feb 2021 10:20:43 +0100
Message-ID: <87sg5jqj6c.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 13:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Currently any DSA switch that is strict when implementing the mdb
> operations prints these benign errors after the addresses expire, with
> at least 2 ports bridged:
>
> [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
>
> The reason has to do with this piece of code:
>
> 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
>
> called from:
>
> br_multicast_group_expired
> -> br_multicast_host_leave
>    -> br_mdb_notify
>       -> br_mdb_switchdev_host
>
> Basically, the bridge code is correct.

How about "the bridge code is not wrong"? Is there any reason why we
could not get rid of the duplicated messages at the source
(br_mdb_switchdev_host)?

The forward offloading we have talked about before requires that the
bridge-internal port OFMs are bounded to some low value
(e.g. BITS_PER_LONG) such that they can be tracked in a small
bitfield. I have a patch that does this, it is tiny.

With that in place, imagine a `br_switchdev_for_each_distinct_dev`
helper that would wrap `netdev_for_each_lower_dev`, keeping track of
OFMs it had already visited.

For all host related switchdev calls, we should be able to use that
instead of the full iterator to only contact each switchdev driver once.
