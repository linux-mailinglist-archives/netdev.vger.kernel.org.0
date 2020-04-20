Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556ED1B1392
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgDTRxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726021AbgDTRxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:53:03 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3A7C061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:53:03 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v4so585620wme.1
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 10:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yDuO8Fy+S+m6nIrVDWWNcZdA24FwvT2RNi23FDb9mcA=;
        b=wZh4dUSIsT++chKcs9TsZrdt3CRuxK24BgaZLY9EV3IQz4AKIavJ27hJTDCGEiRXOW
         1T/ugrAgb6lMmtgJU8+oAawg76cFQ3ZKkem9gQ3Xgog7wo1ciRRIhX9Ivzx59hfzZpNz
         gjYTZIeMGgm4y9MLiZrJOFiy4zl5D2viA00nMQqCJzeueyo41X2EHGSUVLNSSJKTDJrA
         5sJgEGAhMr32RYBpuJATcOV9fPH4ChAuaA7roLbmFBqmLzg7TnRS/nLweMFAqDEQ4goL
         8v+FmnaZ4zKP0u2+lvLIoTKtgkW3xz66HT9OShhl4Q/wM98T8s1duZulw/BsNgzMApk0
         PoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yDuO8Fy+S+m6nIrVDWWNcZdA24FwvT2RNi23FDb9mcA=;
        b=uIYqO08cdrWXbX9TW4R9txChzKo5RXfYAdGLgTm/uBtQFAt7HpFjnbGPCOQl7jEgBY
         iKWYpoi4Gm7K1DG2d/9ZWDEiUcTt+byReQokCrilC7hSyvDNqkzKIWnOhCxKB/bMF7+E
         ByOhjv8C5ea76Tb57s3Z1sy4fRT3Zja6E/5dbOjUp9A3guW5sSCzQjIuF/FSqa1LYDYx
         QScNj0uo/U3APqVHGfowKry4NgIoOFclW14ud2IrMbGoyyWVQc26FiDEgNLDu9GKO0Bz
         7wV9+EfLG5t5NcF87Ve3ZV2i1VqGAOvHigzhaSxiJWxnk+rsTAgsAOWDdiBWJwLU/kYJ
         uNSw==
X-Gm-Message-State: AGi0PuZT1hzRWvTrZA++pSBH0BCsdSEmcSOOATZVa7GduV4zLaM0eEfq
        EI1+7bya96/M7v0VunthAYBbzQ==
X-Google-Smtp-Source: APiQypIHKSEcn+aW53ScKIz/JY3CqqZ1wYM5Ayb2cADscQPoffOjdjw/AOo18YeaXVnsFRWz0hRwSA==
X-Received: by 2002:a1c:e906:: with SMTP id q6mr521770wmc.62.1587405182233;
        Mon, 20 Apr 2020 10:53:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s6sm195298wmh.17.2020.04.20.10.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 10:53:01 -0700 (PDT)
Date:   Mon, 20 Apr 2020 19:53:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
Message-ID: <20200420175300.GT6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420174124.GS6581@nanopsycho.orion>
 <c1c0bed3-3841-8e08-f4bb-297d4420cbf4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1c0bed3-3841-8e08-f4bb-297d4420cbf4@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 07:43:14PM CEST, dsahern@gmail.com wrote:
>On 4/20/20 11:41 AM, Jiri Pirko wrote:
>>>
>>> I disagree. There are multiple master devices and no reason to have a
>>> LAG specific get_slave.
>> 
>> Do you have usecase for any other non-lag master type device?
>> Note the ndo name can change whenever needed. I think the name should
>> reflect the usage.
>> 
>
>right now, no. But nothing about the current need is LAG specific, so
>don't make it seem like it is LAG specific with the name.

I don't care really, I just thought we can make the connection by the
name. Makes sense to me.
