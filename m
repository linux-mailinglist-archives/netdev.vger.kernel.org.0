Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EF32F7E68
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbhAOOlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbhAOOlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:41:02 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D529C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:40:22 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r5so9732496eda.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NkAob7weQbytAUb47KCyGwPf60aE3wgeQlOCueKUJKQ=;
        b=1tfVsTqSNLe89JX6g5oAhmymkV+xU9g7ofyhCf0XSbNp1KNrUdRY65sG8pBQ+6Ac//
         mzMOQvn4XVAV0M9xBRh2vTew8wz4Q+dPCCxvK3yPNxs+EDiH+WjXodwiut/dRnTiyUvk
         TeYwaSokqcqjovvdL8AgX7TGKe+mR/U4jNDK1Oo3DodOUcdMbtebyfTWF8baolrBCUSh
         4SQ7qDhQKIsiZsDmrVSsTVxDR0/Tk1fYXzERuaxj/EzrP48sa8Vfo5alqfxPtzpPx9ts
         e6TMCENR0K1G4KadD7jocVmFvNXa4XMZQnZqsuYhBlsAO0s48OXwB52N3/cdwjY/2BLG
         Wb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NkAob7weQbytAUb47KCyGwPf60aE3wgeQlOCueKUJKQ=;
        b=DR+R79NAN/SmmmAWkbLWojX2VFFeoOFu4GFhSPiLISOTK+RhHsijO7cP+E63fhhRGg
         9QB8o/i7XNfghkbKh3aVoTiak0TYqCRqIENd86EmcAxHPJr5Gsx54en5KHYoT7AICfPp
         MwtK2mK1mNMKQ5UBJMHEWux8eco5zzKWcTsd5agYiFKdNi3kqwSPHzUUt6IlXFqPIFg6
         V9sTpwpj0Ig1+5a9vS8l1+qGRESroX1z6Vh8E8ezSN0VI18nIRCQW8RTSeYrgyTfRX4T
         oHhCb176T7X0B+NFPqOb35Q2NPuscCJGnG8/Q7K+aR2hmnfoSI5TJ8+vB8QtyHm39Qfg
         bCug==
X-Gm-Message-State: AOAM53373ZFortCY6v4vlP2OK5eRAOkgSAF7ZyqXW9mGkM3OWmq2NIcC
        3EoZGeVy4BP527BM2tdFp6QBsg==
X-Google-Smtp-Source: ABdhPJzT2Z0W/Ylqw1tL9ABBHWoUt5pXQSCLhU8HeXWj6WSXLGqIO+yVzd/FJJ8zLoW4GxQWDKzEMg==
X-Received: by 2002:a05:6402:d0a:: with SMTP id eb10mr9869200edb.249.1610721620865;
        Fri, 15 Jan 2021 06:40:20 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id k23sm3567412ejs.100.2021.01.15.06.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:40:20 -0800 (PST)
Date:   Fri, 15 Jan 2021 15:40:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        davem@davemloft.net, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210115144019.GN3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <13348f01-2c68-c0a6-3bd8-a111fb0e565b@intel.com>
 <20210114152058.704c9f6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114152058.704c9f6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 12:20:58AM CET, kuba@kernel.org wrote:
>On Thu, 14 Jan 2021 14:58:33 -0800 Jacob Keller wrote:
>> > There is no way to tell a breakout cable from normal one, so the
>> > system has no chance to magically configure itself. Besides SFP
>> > is just plugging a cable, not a module of the system.. 
>> >   
>> If you're able to tell what is plugged in, why would we want to force
>> user to provision ahead of time? Wouldn't it make more sense to just
>> instantiate them as the card is plugged in? I guess it might be useful
>> to allow programming the netdevices before the cable is actually
>> inserted... I guess I don't see why that is valuable.
>> 
>> It would be sort of like if you provision a PCI slot before a device is
>> plugged into it..
>
>Yup, that's pretty much my thinking as well.

Please see my reply in the other sub-tread of this thread. Thanks!
