Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995423660EB
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhDTUbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:31:08 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.218]:30477 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233872AbhDTUbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:31:05 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 899ADDBD9
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:08:10 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwfKlDy0iw11MYwfKlhwyC; Tue, 20 Apr 2021 15:08:10 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QweV4LAY1Y5ifNq4hmSERLYrcoN2XaYQxMKBb1YLCJk=; b=MoT8313qf85Zf+sLYOEs+txXr0
        Z+Wn8c0+v6ZD38Pvt/JMVbORKxQRj9PD0kq4cFYNF5yEGEOmQ4yC/hSY1Q4NdS6Md0NYRCcNlE4/h
        RZ2sE740v7E5WAQ8D6otGMXXFJ6YQrEld5KKf21LUZQ09j6mNl55nq3ceczR3uZ9Ow/mOEPVIA47F
        VejjAAzqLjJIxqIXzgqdu9liEWs0rDv0rHrnStuUqsChECcLgBdhvWueeMLPmJy9YAGe9BRI0saKY
        MRRPz0lafJ57WzUX4/9+peskvSlOh1kyybkMvcLXZ0oiFMLOHE33A3v8PIQtO+nWdqM6C0afDSiru
        wSCE7ftQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48926 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwfH-002aYu-00; Tue, 20 Apr 2021 15:08:07 -0500
Subject: Re: [PATCH RESEND][next] xfrm: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305092319.GA139967@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <fbe896ed-860d-4a92-f92b-bce83ba413ee@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:08:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305092319.GA139967@embeddedor>
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
X-Exim-ID: 1lYwfH-002aYu-00
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48926
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
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

On 3/5/21 03:23, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/xfrm/xfrm_interface.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index 8831f5a9e992..41de46b5ffa9 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -432,6 +432,7 @@ static int xfrmi4_err(struct sk_buff *skb, u32 info)
>  	case ICMP_DEST_UNREACH:
>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>  			return 0;
> +		break;
>  	case ICMP_REDIRECT:
>  		break;
>  	default:
> 
