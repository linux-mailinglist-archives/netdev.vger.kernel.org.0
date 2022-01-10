Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D19489545
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbiAJJeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbiAJJeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:34:00 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34E5C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:33:59 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a5so21569641wrh.5
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/VrRVERuHHPdYxRWextA9kGCaMID45vgcMqNGGuxH28=;
        b=iW/KhckXmviVIT97wQIMFMkmNGgbIMU0j3S1Guxss3aE6QAdqdTp2Zp65SNd+7tj6n
         B+wu1pncuprXIyzNGvcidVS02Ncg7/muxejDA41Qdhz3Ac7pCsIBZSy2AposfYmLcdu6
         1OMcVB45BlvfBzl+QEm1Eyh4PFR6LViLzOiZH8ypUEsD/n++SJ/SUcp7Y3sMCdxlLVd2
         PrYX7zXm6wc9doXb6VCMMEqZKu0krDjfFTgmOLnR48yS7Cf6rikKDZ1+iwyBCc8q8vqe
         yKZqiJgWTqbxXU8vpHSsMSKHtrwrtaApI6oIyfM1ghoIbcZFihu0tcnOfZrbVsODWiZ+
         MYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/VrRVERuHHPdYxRWextA9kGCaMID45vgcMqNGGuxH28=;
        b=aGsymcpj4wcuOe9plbME0wiZJAoj71fpKX5/qfQawMMO4crjHZwpKOfn8LcG7Q6GAI
         OsHkVKHYRKYywVvx3jUQZiCMk85sE9wLML0X3nr5jl4q1JmrlxZykB1EhWrjIA6Jcih5
         BJaP7q67bT5//bUFtVjcutTEz/FG2t+eOtIZPmFO+TTqugv7Sk4G0kOkx6EHAoCeKb5e
         Ha88xCrqrbhOfE24Eijznvw/McrhZV2VHW8GEB7E63angJip9BtSqOAmzKwj0b2eAwjf
         j5g4G4dOV1nkcvYPyjZ55+1pOQza35Y1a4iYqnQ1biXhMDVht3W60jeFcLbz89Q9MV8I
         bDfQ==
X-Gm-Message-State: AOAM53186iKpBaDYgG4+VVMl7EvAbtANOA8bURA7zdwGdgFZPpOTXeEU
        lOYdhkDUlOU5bqk40omdttlX0pJOW1HkD+xU
X-Google-Smtp-Source: ABdhPJwblBMtdwaTe/55jD8r+ZdtU/raBuOzXLMfLdMfMC/8JnHU5ISCwJFOcD1Wi2lWfkKkl9u/Gw==
X-Received: by 2002:a05:6000:18a:: with SMTP id p10mr13963353wrx.218.1641807238506;
        Mon, 10 Jan 2022 01:33:58 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d5sm5913510wms.28.2022.01.10.01.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 01:33:58 -0800 (PST)
Date:   Mon, 10 Jan 2022 10:33:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: remove ndo_get_phys_port_name
 and ndo_get_port_parent_id
Message-ID: <Ydv9hZqDFVO4OhCt@nanopsycho>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
 <20220107184842.550334-2-vladimir.oltean@nxp.com>
 <YdsakgRku3ZgF77f@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdsakgRku3ZgF77f@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 09, 2022 at 06:25:38PM CET, idosch@idosch.org wrote:
>On Fri, Jan 07, 2022 at 08:48:41PM +0200, Vladimir Oltean wrote:
>> There are no legacy ports, DSA registers a devlink instance with ports
>> unconditionally for all switch drivers. Therefore, delete the old-style
>> ndo operations used for determining bridge forwarding domains.
>> 
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>Looks correct to me.

+1

>
>If ndo_get_phys_port_name() is not implemented, then
>devlink_compat_phys_port_name_get() is called which invokes
>ndo_get_devlink_port() that you have implemented. Similarly, for
>ndo_get_port_parent_id().
>
>Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
