Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C32D0532
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 14:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLFNeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 08:34:10 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11350 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbgLFNeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 08:34:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fccdda90001>; Sun, 06 Dec 2020 05:33:29 -0800
Received: from [172.27.13.141] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 6 Dec
 2020 13:33:24 +0000
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
To:     Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <1dba7733-53e3-7346-5b02-3178033b215f@nvidia.com>
Date:   Sun, 6 Dec 2020 15:33:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607261609; bh=QZuXY/7OxKtB/DPMo+Qa5Sr95glbPEduJF7Z7Nb6ch8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=h95yIN7J+13GsFY4o3IgstxjH8GeP97Jpv3UmQDyq3ciSS/YOmG1SEMBlx689Kxs+
         +ACd4PjJ631kWH6yhDFl03j2ESg0/jFRiPMmyxf+eE8w+T5489FGUxy5jwmBCWHDEo
         tDIThtjuR5b0DRqySU00hm+xWhRMhvwUEekOVSr1xXd9s6EBbXdW5FGYMpp0GyYpsI
         YEVaUIfyD7zsjhuNPG6tBROuSyBzt5+8yn5hMHpi6ud9LhUYa/NxOTbVrON8H+PPm/
         zcdYP4NK1JgPJHi9V15H1zaclMT8iDlZK+76eglHT3p2psASP+hGqurGoqzruaSRXo
         ZgpvXZsbXZ72Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/2020 11:57 PM, Saeed Mahameed wrote:
> We only forward ptp traffic to the new special queue but we create more
> than one to avoid internal locking as we will utilize the tx softirq
> percpu.
> 
> After double checking the code it seems Eran and Tariq have decided to
> forward all UDP traffic, let me double check with them what happened
> here.

We though about extending the support of these queues to UDP in general, 
and not just PTP. But we can role this back to PTP time critical events 
on dport 319 only.
