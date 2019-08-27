Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323039E576
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbfH0KLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:11:55 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45253 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfH0KLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 06:11:54 -0400
Received: by mail-lj1-f194.google.com with SMTP id l1so17880750lji.12
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 03:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HHICw+Tp2z+xL6EJfWAAScDc/8f+gt/WdqhnzOncqsk=;
        b=lJKauEJ8TdPH4oNX2BHuqYH+Y88ysm9qXCA5bkKEILpU6wf6QbbKN++Jo503tfKVLd
         2bJ1WoMlB5LM4G1MCknb1WHzzwv1WoUkSw3fWhNFRG5poLq/3EdWqqgtDeaogoBJk6DY
         oH7kJfudJTNUHFPyRCEjzoEHyfvFC9xhvMFBO80MYx3ENwnRXiSEUS9U5Ncy/2/g6mqT
         h3Ok7TGggPdfdAsUPvqDCbx4S4mcvIftFqgi43wPaUXNXJSeraAijafTNno74VD/CRQv
         qElz2+7Bc16lEzlnu1eD2z6x0z6pzPZVn25UsFyAchyPi/56Io7WEyxFunYOXPETPeHa
         +Vgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHICw+Tp2z+xL6EJfWAAScDc/8f+gt/WdqhnzOncqsk=;
        b=YPj4swif8yKlfaVCGb6EF9stnt1PPQcWZyxZIaIBw8g7UiFZiigrbf20HCAx09z3RC
         zFySCw69ulwWpyO/qZNQYowJL7ebd1xZbJprykNRW6lb67Zp8K39pKzqapwmjjltygaP
         SRfCrXkjsHICDlQTa2q7LCVTdfcPnR7oRoZGJMItUzS+FA4WKVHR/ubIhI/KuiDa0qfi
         WUE1EjC+WQjznqUugi+5orS5y02R6Zh8zj0jV1/x7Hht7HM+RDRN9xwNJlT+VV5IoS23
         SI3DF76WaFNqTXy+0Z70Sw3NrkA53NpGVUHyI60Gs5l0Zas8BVcEjDJhuLaAIaR0Yf6/
         ESyQ==
X-Gm-Message-State: APjAAAX8ICuCXVbJHhtjQzIsQ4geS2z1/CEJJPhJrDOaVqRKc3Z0PNtD
        6LzDBYkkhP47ilYlpDClKTVNNw==
X-Google-Smtp-Source: APXvYqzgl4LL9US1KUnPvvsevaIh9HEZAWTAJ4Ig3yFPd/L/wElSIvaqkxCMhFJnVBiq0OMXmu4nXg==
X-Received: by 2002:a2e:b4d4:: with SMTP id r20mr13418894ljm.5.1566900713180;
        Tue, 27 Aug 2019 03:11:53 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4203:8afc:9cff:f8de:164f:94d3? ([2a00:1fa0:4203:8afc:9cff:f8de:164f:94d3])
        by smtp.gmail.com with ESMTPSA id c10sm2161987lfp.65.2019.08.27.03.11.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 03:11:52 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
To:     Jian Shen <shenjian15@huawei.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, forest.zhouchang@huawei.com,
        linuxarm@huawei.com
References: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <cc52cde5-b114-3bf8-4c4b-fe81c04080ee@cogentembedded.com>
Date:   Tue, 27 Aug 2019 13:11:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2019 5:47, Jian Shen wrote:

> Some ethernet drivers may call phy_start() and phy_stop() from
> ndo_open and ndo_close() respectively.

    ndo_open() for consistency.

> When network cable is unconnected, and operate like below:
> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
> autoneg, and phy is no link.
> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
> phy state machine.
> step 3: plugin the network cable, and autoneg complete, then
> LED for link status will be on.
> step 4: ethtool ethX --> see the result of "Link detected" is no.
> 
> This patch forces phy suspend even phydev->link is off.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
[...]

MBR, Sergei

