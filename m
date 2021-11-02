Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA766442D26
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhKBLwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhKBLwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 07:52:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A132CC061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 04:49:56 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id o8so3133210edc.3
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 04:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NGvfx2Yp8NeYjcLZpVAUSqNQbJA3NqlsdrCxKqayquk=;
        b=t9rV82w2sdfOrAwQpC6iGwusW4OVXTQo5iqxIy1H8+uCgSql7RzdWkt8NMSrjuniY1
         GTRDcZGQsrla6OH82/G9fkG/AxcUvyDC/RyHNkBLw6sQC1Hf/eRjlMwV25AM8jq9i1/a
         T1oWQ1pqjQMvKlZhksP95bz51vzckpasmBZyAei5lbHLtzuRvt6xm1mgWGHPLyrDH2Kl
         tvR8c9Ln5v5HYRqGOH4YH/6ygBSWRCn1g+UfR/o77p9B1ww9uAnEhyNWPeDwzvwEhBHz
         2TVuOY8hcJwPtxd+Uzxv+4i8WmFIoqZCJzLxzDKVFlYDmmqI1RdLP4CMovS1AzTNoHgr
         Ebzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NGvfx2Yp8NeYjcLZpVAUSqNQbJA3NqlsdrCxKqayquk=;
        b=XZa9edPrKhmuGO6vQszl0PVaDFGdm+h42JSxc29LJh/FAavVe19AvFLQtFYfKvyIwZ
         dc4llMN0pcEcu/HTYEFpTKtCInpj+w1hJHIk3choCrzwiaSLk5Q15/pbnF9eePBmm/1N
         FSTX3LmyJ+51iGJwbisGStJrb50rEZEX+QAeLUPqLu97WirChJ2BLJk2zJ5YcCcwzy9N
         MGFwtD8vWn491tSKyyD1qo8FSp2xOoqcMT7Y31/IOaa73Vh8op5TpytWhMo38lafL0mW
         UDASqOL9Av2BgpfihE7ckDDd4GULzO2vRGcirPlI4cqqi/NNHIFL0Acm2Wk/IsBdS5Ph
         XbUQ==
X-Gm-Message-State: AOAM5339MGdzbmSxEuC/cM5XFCfttavtzBPO5DNLOSTUgT4k9kT+jAZW
        4QJDz9Qq0gm2bohs9ToyKBINeg==
X-Google-Smtp-Source: ABdhPJzKIPJRB2hu8RjZzTW1mJh4a2lz4FbM9mlaaiU6173xiAlvzaO0EkwbcXCnJVdMMqR7Z6wIbQ==
X-Received: by 2002:a17:907:961a:: with SMTP id gb26mr44101888ejc.527.1635853795220;
        Tue, 02 Nov 2021 04:49:55 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id gt18sm1047284ejc.46.2021.11.02.04.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 04:49:54 -0700 (PDT)
Date:   Tue, 2 Nov 2021 12:49:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] Code movement to br_switchdev.c
Message-ID: <YYEl4QS6iYSJtzJP@nanopsycho>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <YYACSc+qv2jMzg/B@nanopsycho>
 <20211102111159.f5rxiqxnramrnerh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102111159.f5rxiqxnramrnerh@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 02, 2021 at 12:11:59PM CET, vladimir.oltean@nxp.com wrote:
>On Mon, Nov 01, 2021 at 04:05:45PM +0100, Jiri Pirko wrote:
>> Wed, Oct 27, 2021 at 06:21:14PM CEST, vladimir.oltean@nxp.com wrote:
>> >This is one more refactoring patch set for the Linux bridge, where more
>> >logic that is specific to switchdev is moved into br_switchdev.c, which
>> >is compiled out when CONFIG_NET_SWITCHDEV is disabled.
>> 
>> Looks good.
>> 
>> While you are at it, don't you plan to also move switchdev.c into
>> br_switchdev.c and eventually rename to br_offload.c ?
>> 
>> Switchdev is about bridge offloading only anyway.
>
>You mean I should effectively make switchdev part of the bridge?

Yes.

>See commit 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload}
>loosely coupled with the bridge").
