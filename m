Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09390366119
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhDTUr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:47:56 -0400
Received: from gateway30.websitewelcome.com ([192.185.184.48]:37756 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233937AbhDTUry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:47:54 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 0858C12E4C
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:24:31 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwtClluZdPkftYwtClzlEm; Tue, 20 Apr 2021 15:22:30 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KwJM85k11Ygmm3CXqmhWgssTpLNcAfQC8MhqcL+cq1A=; b=VE285iWNk3Ah2MNIwY+mY6T2+T
        xh0qoN/YWZRkNlhV00jC8HHdihzApcCR/a3gwr6R63E2uYQk9BympwRF94kn8MJGtg06lI6pBypyX
        cQK7STQXNckoJhG1+CuKaq3NGxjKYeCBwmW2Ww5MFC/SwMVnZPpCiIu3XS6xm+v0E7qJrFc9K+ex1
        unl8R0nAOkGWQAl4nDVEzVRAfD2aCA36CPLDZbTWx/fFYuqFOUWsY+U45h6YJPUgumDViYMNxinXg
        m+gAkopmDlT/D9cErgcnWSjX8Wr4UXQ59H9oHke2xPbcx4ZG2uDEm6U11AZOP/nz96IofQJSRiKVu
        x6GU4v9Q==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49014 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwtA-002z2I-F5; Tue, 20 Apr 2021 15:22:28 -0500
Subject: Re: [PATCH RESEND][next] vxge: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305094735.GA141111@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <e5591c90-1a12-febf-1aca-257895f24d26@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:22:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305094735.GA141111@embeddedor>
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
X-Exim-ID: 1lYwtA-002z2I-F5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49014
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 135
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 03:47, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a return statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/neterion/vxge/vxge-config.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
> index 5162b938a1ac..b47d74743f5a 100644
> --- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
> +++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
> @@ -3784,6 +3784,7 @@ vxge_hw_rts_rth_data0_data1_get(u32 j, u64 *data0, u64 *data1,
>  			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_ENTRY_EN |
>  			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_BUCKET_DATA(
>  			itable[j]);
> +		return;
>  	default:
>  		return;
>  	}
> 
