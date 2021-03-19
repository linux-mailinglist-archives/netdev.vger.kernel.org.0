Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB9B34285D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhCSWFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhCSWFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:05:05 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608AAC06175F;
        Fri, 19 Mar 2021 15:05:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l1so3574871plg.12;
        Fri, 19 Mar 2021 15:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GheYJTaOGhwLDSBIb7eWkaM5FXZgdhdQ2xOhE0dwmjM=;
        b=I26obmCQ4BThtYzswWj4cGE8xrKgyvQxAMeG8SGbptfNUVkeFsT6IucTajjvtP1XGS
         SgtILvdseO0ycNhVSRNP7Jn/WOKkzETSQS6xodlo16fCZs4p/ElZYezgCvLZa1YVZxz/
         hnH+GmYk2OVFsBtQEpBqeLtFpUhOZPvciYNAvwlgshejhFo9XJaVOiTgGW0bElUOXO3a
         3WyDV8LSfdeuWWs75kU/TTp8qtjgqC/6OOSchQCrE2Pk6XYCJyVy2awMzlgOHLvvWDuk
         8s4BnlsxyUZJeBMRN/ChfZ3vqh+XY9nyZYUsV8g9MDAT4lw41H9Sv512nBSIHHLAWHcG
         Ka1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GheYJTaOGhwLDSBIb7eWkaM5FXZgdhdQ2xOhE0dwmjM=;
        b=UDGt2Sn7qFKlbR7GWRHqJE6H1qBU61ebaGpdV0Gd4XnhlZ5EsnLEBgvCbH1X37n+Zu
         nEdeRSs3EJMfLDrXl1y6nkY+KqUXxFPBju3meIlXgqpYQ6bdkEZvlL7FXLiBd9MDNKGL
         zeDP1q1vXqdF+iessTjTinF52CYEeY4dQIewPn8U6STNwBaMUj0elkNwj/6vCun7kdu+
         +pZuwytgUkVK5DH9qkOs2CcSUKYPSkMkUhhNyAiuxb932IUt/XdU2pJX6jXGcED+cWBB
         /NwVYRNlEu3BODRwZv8J3fQZCqiDCBGbw6NhPC5uVX8WvtTivZ+H2sj8FnSkzrJ1Md5A
         x42A==
X-Gm-Message-State: AOAM5324QlFqDG8fq0RGBkua8qYemY4tsS7RaeWAsTCanAUDqFyG69+J
        2hJC/3s1hFf/NUxKvF3nQBc=
X-Google-Smtp-Source: ABdhPJx96Q3EOTnSJ1VJxQHl7VHpUuNiozq1qjjcVFzkh4NXcJaQw9tj9E3nWjRl0oaIFSqcOk3Fug==
X-Received: by 2002:a17:90a:e00c:: with SMTP id u12mr568434pjy.133.1616191504916;
        Fri, 19 Mar 2021 15:05:04 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 9sm5599777pgy.79.2021.03.19.15.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:05:04 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 02/16] net: dsa: pass extack to
 dsa_port_{bridge,lag}_join
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ccfa00f0-4f57-fc0b-05d0-025519842ba6@gmail.com>
Date:   Fri, 19 Mar 2021 15:05:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is a pretty noisy change that was broken out of the larger change
> for replaying switchdev attributes and objects at bridge join time,
> which is when these extack objects are actually used.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
