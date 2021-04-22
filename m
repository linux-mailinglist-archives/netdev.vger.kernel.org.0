Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1A83687B7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbhDVUL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:11:27 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.1]:25267 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236896AbhDVULZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 16:11:25 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id F010834705
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 15:09:47 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ZfdzlQgJJ1cHeZfdzlWgFC; Thu, 22 Apr 2021 15:09:47 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Hgh1FXBMqBCT4Or8zowpdaOw66ShiVWVKkStIsljJiM=; b=SPLZ64d1CCen8kqEK8Y2tgAnLv
        135FUtq9ECH5iHcBbinL4I00bnz4z60XUeOaSGZqCmbVpE4H1RQ7AouIUlZeJGqzKUDJZSKe/uDKu
        l4TJ8EvERTYfCPNwxW9nUzHJJhhhQLGz6gfsXNoeMA7Vsb1mXtoTw2YcYobigZf1Ti3YmGcidBZUq
        tw/Ok51Ca4F+csLpKFEI3rl0PYDLEHp8p3ijCcodgLtukGKdRY5QnbXBOkEU8tdF2Cn8EBZiFqd25
        5gCMOGzMZAhF9brQ1HnnHZmpIRVO9UKHy+VknJjuWt1zMlmL11qgsg4sb0ztE33mBOpmHY6JRZTKP
        Hr5k6JHg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:58642 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lZfdv-0043C0-Pk; Thu, 22 Apr 2021 15:09:43 -0500
Subject: Re: [PATCH v2][next] wireless: wext-spy: Fix out-of-bounds warning
To:     Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210422200032.GA168995@embeddedor>
 <120f5db6566b583cc7050f13e947016f3cb82412.camel@sipsolutions.net>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <20dbd7cd-8001-0dcc-cfe6-f731f65d0a35@embeddedor.com>
Date:   Thu, 22 Apr 2021 15:10:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <120f5db6566b583cc7050f13e947016f3cb82412.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lZfdv-0043C0-Pk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:58642
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 15:04, Johannes Berg wrote:
> On Thu, 2021-04-22 at 15:00 -0500, Gustavo A. R. Silva wrote:
>>
>> Changes in v2:
>>  - Use direct struct assignments instead of memcpy().
>>  - Fix one more instance of this same issue in function
>>    iw_handler_get_thrspy().
>>  - Update changelog text.
> 
> Thanks.
> 
>>  - Add Kees' RB tag. 
> 
> He probably won't mind in this case, but you did some pretty substantial
> changes to the patch, so I really wouldn't recommend keeping it there.

Right.

Kees, could you please confirm you RB tag in this new version?

Thanks
--
Gustavo
