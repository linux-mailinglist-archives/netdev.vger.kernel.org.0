Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF123687D7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhDVUZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:25:15 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.206]:15269 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhDVUZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 16:25:14 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id DDB1B17F38
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 15:03:00 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ZfXQl1GUKw11MZfXQlT26f; Thu, 22 Apr 2021 15:03:00 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=d/5pgn0pMDu8YtsMnk0jcfxUVg079cO2Qvp35naLjTM=; b=FqjaVKwRkgTWGoIjNppT5PAzvz
        Faf5IKuEfZOR5uDeV/Ct+uMF24hXv9ZDUe04YCBYOVAkoTV2/n1gBVWGLN23NQI3rMbKcRV4A/7fg
        G6hwB/0pyXGloe+gpEHQMr25zU7gN1DJ65PALPBQZAELVhb76HXUtateby7iMEu7TbePLjFK0nkr/
        tuZnwpc0VQOcAhxkBuf7XaApXe9S5g02Y/jcBoz/FGhoFHiiXsCdqbz9a6q/cEP6iqu1cANZWYJL3
        m222t0x3R7YXQX75o9IgYB4lspRzmocEx5CHEBVub2P8u+B8JeWihB45Uv7nQJn25a8XszI2TdFGa
        UuoQqKgw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:58614 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lZfXN-003qnV-A4; Thu, 22 Apr 2021 15:02:57 -0500
Subject: Re: [PATCH][next] wireless: wext-spy: Fix out-of-bounds warning
To:     Johannes Berg <johannes@sipsolutions.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
References: <20210421234337.GA127225@embeddedor>
 <317099c78edb9fdde3db3f1e7c9a4f77529b281a.camel@sipsolutions.net>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <07fc2c3a-ffba-8dad-1ddf-d4da7482c65a@embeddedor.com>
Date:   Thu, 22 Apr 2021 15:03:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <317099c78edb9fdde3db3f1e7c9a4f77529b281a.camel@sipsolutions.net>
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
X-Exim-ID: 1lZfXN-003qnV-A4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:58614
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 02:04, Johannes Berg wrote:
> On Wed, 2021-04-21 at 18:43 -0500, Gustavo A. R. Silva wrote:
>>
>>  	/* Just do it */
>> -	memcpy(&(spydata->spy_thr_low), &(threshold->low),
>> -	       2 * sizeof(struct iw_quality));
>> +	memcpy(&spydata->spy_thr_low, &threshold->low, sizeof(threshold->low));
>> +	memcpy(&spydata->spy_thr_high, &threshold->high, sizeof(threshold->high));
>>
> 
> It would've been really simple to stick to 80 columns here (and
> everywhere in the patch), please do that.
> 
> Also, why not just use struct assigments?
> 
> 	spydata->spy_thr_low = threshold->low;
> 
> etc.
> Done: https://lore.kernel.org/lkml/20210422200032.GA168995@embeddedor/
> Seems far simpler (and shorter lines).

Done:
	https://lore.kernel.org/lkml/20210422200032.GA168995@embeddedor/

Thanks for the feedback.
--
Gustavo
