Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3AB364E5B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhDSW7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:59:15 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.46]:11053 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233317AbhDSW7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:59:04 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 488FA5FDA7
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 17:58:33 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ycqfl1jcdMGeEYcqflPxqC; Mon, 19 Apr 2021 17:58:33 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HSwcUpoOJnXwy9FUWCUDqISxnv3zkq1DVf8wvqzFEr0=; b=BvljQjnbdpu8RmeO4AFnQNsFrG
        NidTTAVI57LZ/J2KDjmbAu7FNej4A6OqWy0McVvbePr1On80nZDp5d6dSdFLLtoXvfqalwR/mtox5
        vfu7kaWx0KLLVyZ/PosuE8v8JjIOtytLvU7MbVb5zSrPu91Ph1caCNssqaZp9zcJJQj2y/er+2PFS
        hX+Y47e2dakcdxmAf8/3vpInY9DiLqH+HVOPB5utF++XyeO8IPnAuFGdjfvZAxGS8gP2O8LTQzmc1
        kr6oXcd1YuK5Wf82wKLg29FuGD2Y5sVty7f79O2n+sZseztgxiE2hoN7uym6RNvrUTRrccEHd11ge
        jChUgS+g==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48156 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYcqb-0044Xd-ON; Mon, 19 Apr 2021 17:58:29 -0500
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
References: <20210305094850.GA141221@embeddedor>
 <20210417175201.280F9C4338A@smtp.codeaurora.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <0b096033-7daf-fae7-9ea9-37038b979616@embeddedor.com>
Date:   Mon, 19 Apr 2021 17:58:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210417175201.280F9C4338A@smtp.codeaurora.org>
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
X-Exim-ID: 1lYcqb-0044Xd-ON
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48156
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 19
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/21 12:52, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:
> 
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
>> multiple warnings by replacing /* fall through */ comments with
>> the new pseudo-keyword macro fallthrough; instead of letting the
>> code fall through to the next case.
>>
>> Notice that Clang doesn't recognize /* fall through */ comments as
>> implicit fall-through markings.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 
> bf3365a856a1 rtl8xxxu: Fix fall-through warnings for Clang

Thanks for this, Kalle.

Could you take this series too, please?

https://lore.kernel.org/lkml/cover.1618442265.git.gustavoars@kernel.org/

Thanks
--
Gustavo

