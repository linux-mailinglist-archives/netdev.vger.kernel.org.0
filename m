Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6423EC239
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbhHNLHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbhHNLHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:07:37 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FA4C061764;
        Sat, 14 Aug 2021 04:07:08 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id b10so14551870eju.9;
        Sat, 14 Aug 2021 04:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EWt+VfLQY9iZxl8wtOgsYmjTQHpyDeXMeTimstm7S2s=;
        b=ZNxXGi9l5uktJwHKvKhVeD1QdM95ZPrZ63z/PuMtkzlrRlll9eRW4YuJShBy26VYtx
         L1hD103KebypdNDtYOZRBCJZkdQx5NgYSSDZfCitTZVk8fGQYs1t+YmzYuLOiFup76/6
         JUHKqQTHXbkrkDZK2OLi4BjzOtJfi1Iobas6NNOtN3/vtjEabAFztlzIKJ1A0rD02aNJ
         jCe0G+M+4C7hFJzT8PEATgFBbmWcs0UbhDw+64EMtO2kYXssMlvvvLAOfVhMhKRHw4bT
         fyG7yKKPajyireTArOqGC9PuiSiV6cXgsFRGKIk58lMyQ5zLMydcl2frd1E6zDm4cb1t
         /w1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EWt+VfLQY9iZxl8wtOgsYmjTQHpyDeXMeTimstm7S2s=;
        b=E+ZchhccNt/nSGxHyUyQd9Flfgbi44agih1sm+GsDt92ZxmqrRylg7Sw9RIuT2AVre
         q3vpnaqlhf1xAcaeGOGc9CE7ibLMplsIcMBZ09Gg2dHbz/fhFQCXu2ETV2rRWO/wH+xv
         DiA+FnRSiEyqMCAuftMcBUnm+zr920XiVG6LpS9/vjoIAzkx4FVChtV4aEhgHPB/Ll98
         WuOZysBb1CwYjZBcPmTXwD/vtczoR5Am2Nq0PNfYCZc03+lHhvvvxTZ6CIhUyCqySkuf
         x6lT32XTS/of7ibz6730RGvsvzN4DhSx/yz+IRhd0ZHYb5qMg252H4DfZxO0OXB4V/eh
         7GVg==
X-Gm-Message-State: AOAM530wH/uCe6Fp93Ngi1Tqu4pK9iS2IjxAwSYypy8uYdSngUtT8wuw
        kOG9fTa+H54UyVTZ9ZaG90w=
X-Google-Smtp-Source: ABdhPJxKsZhm9oMJwfikhR5X4Ugdr6jhGsJq3bfj7arHQckL5PKagtoEEqagAr3td6reS+QEywMx7w==
X-Received: by 2002:a17:906:2bcf:: with SMTP id n15mr7091894ejg.414.1628939227423;
        Sat, 14 Aug 2021 04:07:07 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id x15sm1655182ejv.95.2021.08.14.04.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:07:07 -0700 (PDT)
Date:   Sat, 14 Aug 2021 14:07:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 01/10] net: dsa: ocelot: remove
 unnecessary pci_bar variables
Message-ID: <20210814110705.yf7cy7ae2u6l5hcn@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814025003.2449143-2-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:49:54PM -0700, Colin Foster wrote:
> The pci_bar variables for the switch and imdio don't make sense for the
> generic felix driver. Moving them to felix_vsc9959 to limit scope and
> simplify the felix_info struct.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

I distinctly remember giving a Reviewed-by tag for this patch in the
previous series:

https://patchwork.kernel.org/project/netdevbpf/patch/20210710192602.2186370-2-colin.foster@in-advantage.com/

It would be nice if you could carry them along from one series to the
next so we don't have to chase you.

If you use git b4 when you start working on a new version, the extra
tags in the comments are downloaded and appended automatically. That is
if you are not ok with manually copy-pasting them into your commit
message.
