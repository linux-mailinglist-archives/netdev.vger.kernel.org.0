Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4337435E884
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346831AbhDMVug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:50:36 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.119]:47045 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhDMVuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:50:35 -0400
X-Greylist: delayed 1350 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 17:50:35 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 9EFC0C8966
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 16:27:43 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id WQZTlhK55w11MWQZTlIrIG; Tue, 13 Apr 2021 16:27:43 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TfokYtkeeoGp29/7KUX5x78tAWhkf7xQAs5zdzU8auA=; b=NoT3yarjF9YYL8WIsWkPmrhAGs
        7IbzngQxKKDl26S1M1tscWsoZAXI64kXoRNRQs1oNLr1+6+XzCokT0ewHesrqWbMcvU/LyaLmMh8Y
        7UU45KM5BwrqBSEe5ku5ej77R70rjDtfLaXw2C84fBNz3DgwhJ5lw9vOGwMSP8/OmhKtH1FBRLE50
        RVaQkoqaH54Ltb9nU08om2CdMdAL3iQqpP28eT34pPGLewc1Ssal5av3sPSsOkTCYmKAN0x1tuTb9
        X7haz0w6++MAkqfTMVXszHCMv/goHWeidsX5uFswpMlLogqSR7HafmIXFVFvVxBEFhHnB4OxmqMo/
        Ph8OAGUg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:50214 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lWQZP-003KVE-RB; Tue, 13 Apr 2021 16:27:39 -0500
Subject: Re: [PATCH v2 0/2][next] wl3501_cs: Fix out-of-bounds warnings
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <cover.1617226663.git.gustavoars@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <9e0972ef-4d42-3896-d92b-01113c445775@embeddedor.com>
Date:   Tue, 13 Apr 2021 16:27:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <cover.1617226663.git.gustavoars@kernel.org>
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
X-Exim-ID: 1lWQZP-003KVE-RB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:50214
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: could somebody give us some feedback or take
this series, please?

Thanks
--
Gustavo

On 3/31/21 16:43, Gustavo A. R. Silva wrote:
> Fix the a couple of  out-of-bounds warnings by making the code
> a bit more structured.
> 
> This helps with the ongoing efforts to enable -Warray-bounds and
> avoid confusing the compiler.
> 
> Link: https://github.com/KSPP/linux/issues/109
> 
> Changes in v2:
>  - Update changelog text in patch 1/2.
>  - Replace a couple of magic numbers with new variable sig_addr_len.
> 
> Gustavo A. R. Silva (2):
>   wl3501_cs: Fix out-of-bounds warning in wl3501_send_pkt
>   wl3501_cs: Fix out-of-bounds warning in wl3501_mgmt_join
> 
>  drivers/net/wireless/wl3501.h    | 28 ++++++++++++++++------------
>  drivers/net/wireless/wl3501_cs.c | 11 ++++++-----
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
