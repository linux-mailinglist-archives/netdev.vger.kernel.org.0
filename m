Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C54386EB2
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345341AbhERBIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:08:11 -0400
Received: from gateway22.websitewelcome.com ([192.185.46.187]:35189 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239795AbhERBIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:08:11 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id F35AE4A1D
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 20:06:53 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ioCDl4KPjvAWvioCDlEIPz; Mon, 17 May 2021 20:06:53 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4jO4QIVBW/kvv+vPdher+98IyRZOp0HseicLcBinFUg=; b=PAUn55/gRUTa5zNOp/cSe31JAK
        DDwzmeAH+uV3j9PNPEJIHfiPuD1muz6oDn+rYchEY14J54851og6blRkkBL62n31gV9ObmhNjnlab
        zODPEwiJAputNTq8xYO8R4Y3RmkGRTUcDHt7dA5+76XvFpAEht+sfYC19u7GrquZZXDbdX5ezZx9T
        B24g6VqKpQ6kfgySKtNqYucpKDmW3p2yd+aVTgUTKTfmh2DtaIIIqdEMA6je73j7B/PJr1UMoeZ6K
        /+fycDj/pRrVCzg32ajaOL3lSyFMhuNF2prWVatFkJhZEqZWbbQ6Yf58+GKW4ef1jczP3DHbg2Whq
        bwutR+1A==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53610 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lioCA-0038PH-Ef; Mon, 17 May 2021 20:06:50 -0500
Subject: Re: [PATCH RESEND][next] sctp: Fix fall-through warnings for Clang
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305090717.GA139387@embeddedor>
 <91fcca0d-c986-f88e-4a0d-4590de6a5985@embeddedor.com>
 <YH83PToOAiYfHPH3@horizon.localdomain>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <8abc977a-05f9-dc56-fe98-ee274621172b@embeddedor.com>
Date:   Mon, 17 May 2021 20:07:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YH83PToOAiYfHPH3@horizon.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lioCA-0038PH-Ef
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53610
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 18
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thanks, Marcelo.

I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 4/20/21 15:19, Marcelo Ricardo Leitner wrote:
> On Tue, Apr 20, 2021 at 03:09:24PM -0500, Gustavo A. R. Silva wrote:
>> Hi all,
>>
>> Friendly ping: who can take this, please?
> 
> It would go via net/net-next tree, but I can't find this one on
> patchwork. Just the previous version.
> 
> http://patchwork.ozlabs.org/project/netdev/list/?series=&submitter=&state=*&q=sctp%3A+Fix+fall-through+warnings+for+Clang&archive=both&delegate=
> 
> I can, however, find it in the archives.
> 
> https://lore.kernel.org/netdev/20210305090717.GA139387%40embeddedor/T/
> 
> Dave and Jakub will know better.
> 
>   Marcelo
> 
