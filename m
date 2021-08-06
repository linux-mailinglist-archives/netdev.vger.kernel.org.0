Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AD83E27FB
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244798AbhHFKBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:01:00 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57522 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbhHFKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:00:58 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 176A0afM104623;
        Fri, 6 Aug 2021 05:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628244036;
        bh=+lAvhvjDHPHrFjSY2B50SIocEuUB9DsGVaHdriVD8e8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dw326Lwh8ThvQ3S+skUJ9I122H03FdUkNcIjo1/gPaP+h4QxulZKGw0QWJkD3Fa5q
         9yPZf/P2GjwqfIGYv94AhbBGcTiQ/xeFLraB0hmqGh1BscvpXiWj9TclqIkTpWnsLQ
         y8NhMqFBtCnMGGrZAl69PFRW8jzJf2jrzvl3JZ1A=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 176A0adv035514
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Aug 2021 05:00:36 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 6 Aug
 2021 05:00:36 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 6 Aug 2021 05:00:36 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 176A0WQe034347;
        Fri, 6 Aug 2021 05:00:33 -0500
Subject: Re: [PATCH net-next 0/3] net: ethernet: ti: cpsw/emac: switch to use
 skb_put_padto()
To:     <patchwork-bot+netdevbpf@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <ben.hutchings@essensium.com>,
        <vigneshr@ti.com>, <linux-omap@vger.kernel.org>,
        <lokeshvutla@ti.com>
References: <20210805145555.12182-1-grygorii.strashko@ti.com>
 <162824220602.18289.6086651097784470216.git-patchwork-notify@kernel.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <49dbe558-cf18-484b-9167-e43ad1c83db5@ti.com>
Date:   Fri, 6 Aug 2021 13:00:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162824220602.18289.6086651097784470216.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Jakub, David,

On 06/08/2021 12:30, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (refs/heads/master):
> 
> On Thu, 5 Aug 2021 17:55:52 +0300 you wrote:
>> hi
>>
>> Now frame padding in TI TI CPSW/EMAC is implemented in a bit of entangled way as
>> frame SKB padded in drivers (without skb->len) while frame length fixed in CPDMA.
>> Things became even more confusing hence CPSW switcdev driver need to perform min
>> TX frame length correction in switch mode [1].
>>
>> [...]
> 
> Here is the summary with links:
>    - [net-next,1/3] net: ethernet: ti: cpsw: switch to use skb_put_padto()
>      https://git.kernel.org/netdev/net-next/c/1f88d5d566b8
>    - [net-next,2/3] net: ethernet: ti: davinci_emac: switch to use skb_put_padto()
>      https://git.kernel.org/netdev/net-next/c/61e7a22da75b
>    - [net-next,3/3] net: ethernet: ti: davinci_cpdma: drop frame padding
>      https://git.kernel.org/netdev/net-next/c/9ffc513f95ee

I'm terribly sorry for the mess here - this series depends from patch
"net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases" [1]

Not sure what I've being thinking about I've had to note it or include in this series :(

I'm very sorry again - can it be dropped?

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210805145511.12016-1-grygorii.strashko@ti.com/

-- 
Best regards,
grygorii
