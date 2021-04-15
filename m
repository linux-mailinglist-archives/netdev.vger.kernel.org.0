Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9135FED3
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhDOAYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:24:41 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.125]:48035 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229926AbhDOAYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 20:24:40 -0400
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 20:24:40 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 979DDFF97
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 19:00:53 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id WpRFlhb6UPkftWpRFl0rCN; Wed, 14 Apr 2021 19:00:53 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uQWSJpEDStKyMPkezWD8yO/86/YEs02AMX0F1l0RKbc=; b=f8crfTXNvmmt7lwYVGK+zqY3fL
        k3fA6vID4H3ijXbasgIqQJz7S36UR9CqNM9IHiZq9rZiQ6M0WGTo1J0fth70NOhuADTEZumXmOHPE
        n/ldNl85y5ZV0XMwGv8gPyr+ZSESK3sEokFoyA0H/iOiMzcHduVe0f7iWhHKYIsAPURcV28aeTdik
        1iUNkW/2vu1gyp97tQvg9lLCYijn9dPcJGma9nfqqZBgtf3LPppLiooEBM+74uVpzvWajbnmaIhJF
        lqN2O5brYp6RMNcZhQOHTXeAhqb8vjJHKyzlEiJ7gXgzLVpg+CdzUWm1W5l+p3vWRBN8NndIN1mqZ
        32opyyTw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:37926 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lWpRC-0043fC-6L; Wed, 14 Apr 2021 19:00:50 -0500
Subject: Re: [PATCH v2 0/2][next] wl3501_cs: Fix out-of-bounds warnings
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <cover.1617226663.git.gustavoars@kernel.org>
 <9e0972ef-4d42-3896-d92b-01113c445775@embeddedor.com>
 <87eefdl5p2.fsf@codeaurora.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <1cf06338-76da-5109-4099-2db79c31e6bb@embeddedor.com>
Date:   Wed, 14 Apr 2021 19:00:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87eefdl5p2.fsf@codeaurora.org>
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
X-Exim-ID: 1lWpRC-0043fC-6L
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:37926
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/21 01:51, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
> 
>> Friendly ping: could somebody give us some feedback or take
>> this series, please?
> 
> First patch 2 comment needs to be resolved.

Done:

https://lore.kernel.org/lkml/cover.1618442265.git.gustavoars@kernel.org/

Thanks
--
Gustavo
