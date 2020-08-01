Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF04235087
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 07:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgHAFIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 01:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgHAFIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 01:08:42 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7774EC06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 22:08:42 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id w9so24645750qts.6
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 22:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l1r6OgCyvxx3DnbfDZyFZ/Ycjl6hyqacVbJGrWHc5MU=;
        b=ZAmKAn2jlepHJ296+c9GqbA1aeBfBCH729VAfu/s/plcBYEGgxGYRUNMY0fN+JLU59
         YtO7hWlcnZZpE57+z4TaPqgRLVOfBXD1kDFhIc+IavW/eq2XNkVpQ3KnV19+jEADuh0x
         O5+wMJipNdlqNHi3eJfokO8T7sAMXUgeCKgDz13edCAG8xRJKbwrDmrW3tZ7cVqGsNtS
         z27AudzXDBI2S8TyJ7WYzWnnfeS7dPpcbf+Po3haXafS8cXV0ZYLoXDYNI0XxpRrRsjY
         7izjh6WEzsKa8u05GTBKUV5wXEVvGy3O1LEtZw6RSb63NxUScJ0P9hakijkZ3ZWgERT/
         HQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l1r6OgCyvxx3DnbfDZyFZ/Ycjl6hyqacVbJGrWHc5MU=;
        b=t1CoOA8FeHlizWyI333aCoOW+3NsEkLvMpr0GIlNhfQKy0S+03kqsgOVktju/xK/oF
         RbKcF5rUMyzzTRfMGQLFMAY2ryB/MRHBgrSjs/Yzoz7AiY1rDXLRw4zZFsbSp/eZQch0
         TP3Z+15v0LgSJoVhcWBgq6g0aImCz6+7nX2EabQj/6qCteioePpGRPJQp43ZAJ26BN1w
         WT2FsvsbIXDq1syJc6s8TuHAatNZLanm2iMGhZPgzhQLz1pAxJ9FlFcib/a8v2M75VSi
         klRMIA2yV9Hl9o/7iJnV1pMcp7icXVOpEJRPL2AMRziSEbhiZux90nE2AJfEI4Q76VoP
         G+yA==
X-Gm-Message-State: AOAM531jmt5QFId++oMPuxI4cF2+tLbQq6dkU6SBdxC+1dASkt4YlLje
        NUVAo6p1TqzTNH8zgx/k7t4=
X-Google-Smtp-Source: ABdhPJzETjGzFvXJ+7FJs4FkduhooIuDNCTFpMvIy5mRk04M0lHAZQqmax7HLkIWHKpAmSeIziZpgw==
X-Received: by 2002:ac8:7650:: with SMTP id i16mr6824007qtr.215.1596258521503;
        Fri, 31 Jul 2020 22:08:41 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 6sm10536414qkj.134.2020.07.31.22.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 22:08:40 -0700 (PDT)
Subject: Re: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case of
 ACPI probe
To:     Vikas Singh <vikas.singh@puresoftware.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Kuldip Dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>
References: <1595938298-13190-1-git-send-email-vikas.singh@puresoftware.com>
 <20200731165455.GD1748118@lunn.ch>
 <CADvVLtUAd0X7c39BX791CuyWBcmfBsp7Xvw9Jyp05w45agJY9g@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7668185a-79c5-0be8-fabf-dec7b3a7983f@gmail.com>
Date:   Fri, 31 Jul 2020 22:08:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADvVLtUAd0X7c39BX791CuyWBcmfBsp7Xvw9Jyp05w45agJY9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/31/2020 9:53 PM, Vikas Singh wrote:
> Hi Andrew,
>  
> As i have already mentioned that this patch is based on
> https://www.spinics.net/lists/netdev/msg662173.html,
> <https://www.spinics.net/lists/netdev/msg662173.html>
> 
> When MDIO bus gets registered itself along with devices on it , the
> function mdiobus_register() inside of_mdiobus_register(), brings
> up all the PHYs on the mdio bus and attach them to the bus with the help
> of_mdiobus_link_mdiodev() inside mdiobus_scan() .
> Additionally it has been discussed with the maintainers that the
> mdiobus_register() function should be capable of handling both ACPI &
> DTB stuff
> without any change to existing implementation.
> Now of_mdiobus_link_mdiodev() inside mdiobus_scan() see if the
> auto-probed phy has a corresponding child in the bus node, and set the
> "of_node" pointer in DT case.
> But lacks to set the "fwnode" pointer in ACPI case which is resulting in
> mdiobus_register() failure as an end result theoretically.
> 
> Now this patch set (changes) will attempt to fill this gap and
> generalise the mdiobus_register() implementation for both ACPI & DT with
> no duplicacy or redundancy.

Please reply in plain text and do not top-post, thank you.
-- 
Florian
