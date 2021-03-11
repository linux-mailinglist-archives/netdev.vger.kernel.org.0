Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB16336D34
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhCKHjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:39:08 -0500
Received: from gateway24.websitewelcome.com ([192.185.50.252]:17314 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231905AbhCKHio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 02:38:44 -0500
X-Greylist: delayed 1346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2021 02:38:44 EST
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 239E8AD1C
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:16:18 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id KFYQldfUOqvFOKFYQlhiAL; Thu, 11 Mar 2021 01:16:18 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P4Y38n76j62lvthTB0qszyWArTxZMSacXEcyaFhm0Ps=; b=nEEmjHx/6wNVcHPvj0mBJauBXh
        mlfX6bQmPo5qB5ENedRT46pN4eCpVnY/cwL+kdkebtuhNjubEA26ySEvrjGAtl3AmC1G0SmK3Dk66
        4iwYPBaPiDH+HLThkZ9Z65V1e7tyyl9Es0oZCKR/xwpyGlDJLjbrUuiCrP0bmzP8VtECXD7dZBRYH
        EtRYN6Y6U89lFdENoDRQhp0t9HF0fsTKi19cGbtmtN6fY89k7lSRAQVcqqoKwDZYFmXZOb30tw3tO
        gIemvgm1gVguNNGhCZTxbk9MNdEG3RdJcKlRjSNuS3Hgp+55ZmUiG2e/9d1mGTpJOvSNNN/0ar5GV
        VrDltHng==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48552 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lKFYP-001Uab-MY; Thu, 11 Mar 2021 01:16:17 -0600
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305094850.GA141221@embeddedor>
 <871rct67n2.fsf@codeaurora.org> <202103101107.BE8B6AF2@keescook>
 <878s6uyy30.fsf@codeaurora.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <e10b2a6a-d91a-9783-ddbe-ea2c10a1539a@embeddedor.com>
Date:   Thu, 11 Mar 2021 01:16:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <878s6uyy30.fsf@codeaurora.org>
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
X-Exim-ID: 1lKFYP-001Uab-MY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48552
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/21 01:00, Kalle Valo wrote:
> Kees Cook <keescook@chromium.org> writes:
> 
>> On Fri, Mar 05, 2021 at 03:40:33PM +0200, Kalle Valo wrote:
>>> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
>>>
>>>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
>>>> multiple warnings by replacing /* fall through */ comments with
>>>> the new pseudo-keyword macro fallthrough; instead of letting the
>>>> code fall through to the next case.
>>>>
>>>> Notice that Clang doesn't recognize /* fall through */ comments as
>>>> implicit fall-through markings.
>>>>
>>>> Link: https://github.com/KSPP/linux/issues/115
>>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>>
>>> It's not cool that you ignore the comments you got in [1], then after a
>>> while mark the patch as "RESEND" and not even include a changelog why it
>>> was resent.
>>>
>>> [1] https://patchwork.kernel.org/project/linux-wireless/patch/d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org/
>>
>> Hm, this conversation looks like a miscommunication, mainly? I see
>> Gustavo, as requested by many others[1], replacing the fallthrough
>> comments with the "fallthrough" statement. (This is more than just a
>> "Clang doesn't parse comments" issue.)
> 
> v1 was clearly rejected by Jes, so sending a new version without any
> changelog or comments is not the way to go. The changelog shoud at least
> have had "v1 was rejected but I'm resending this again because <insert
> reason here>" or something like that to make it clear what's happening.

Why the fact that I replied to that original thread with the message
below is being ignored?

"Just notice that the idea behind this and the following patch is exactly
the same:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=3f95e92c8a8516b745594049dfccc8c5f8895eea

I could resend this same patch with a different changelog text, but I
don't think such a thing is necessary. However, if people prefer that
approach, just let me know and I can do it.

Thanks
--
Gustavo"

Why no one replied to what I was proposing at the time?

It seems to me that the person that was ignored was actually me, and not the
other way around. :/

--
Gustavo

> 
>> This could be a tree-wide patch and not bother you, but Greg KH has
>> generally advised us to send these changes broken out. Anyway, this
>> change still needs to land, so what would be the preferred path? I think
>> Gustavo could just carry it for Linus to merge without bothering you if
>> that'd be preferred?
> 
> I agree with Greg. Please don't do cleanups like this via another tree
> as that just creates more work due to conflicts between the trees, which
> is a lot more annoying to deal with than applying few patches. But when
> submitting patches please follow the rules, don't cut corners.
> 
> Jes, I don't like 'fallthrough' either and prefer the original comment,
> but the ship has sailed on this one. Maybe we should just take it?
> 
