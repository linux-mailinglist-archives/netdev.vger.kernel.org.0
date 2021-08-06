Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630633E298D
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbhHFL2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:28:49 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:46186
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245371AbhHFL2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:28:47 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id E19764065E;
        Fri,  6 Aug 2021 11:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628249310;
        bh=TSF6syblnU+wYbj7noZ2K9gDs7lGPeoRUp1P79rvg7w=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=rLiwQ60cBvjSxqmgY/q8PBEs0eDonpUuvxGqCCCANYZehYbTN9nocTlIWu+cqPZWI
         YTsM2PGBM3zHpkilwfjZO9I8p541EoD0un7uVZ+8p4MKCKQ7bnXRRZhGQLoEemGe8y
         9uG2WQ8T3KexgkMcDWKnnYShk+tGaRJ5Fx2gpLISt/gxQc0uJ/iVVjt5yWweVhbYFG
         MJB9VzYli3lZGZS6wFsz0FOZ5GzLg0ZX5ySAOZPYUtl1a7nuVcpYyPaqwRZVvzhTWl
         TwILdGJJqxDIlYzxNoTB7MLOM6k4X94hMYwV0BtkXgtBcH6dFEbjn2sM1vnsl2IJbJ
         XIxZwueXEFquw==
Subject: Re: [PATCH][next] brcmfmac: firmware: Fix uninitialized variable ret
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210803150904.80119-1-colin.king@canonical.com>
 <CACRpkdZ5u-C8uH2pCr1689v_ndyzqevDDksXvtPYv=FfD=x_xg@mail.gmail.com>
 <875ywkc80d.fsf@codeaurora.org>
 <96709926-30c6-457e-3e80-eb7ad6e9d778@broadcom.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <b2034ac5-0080-a2fb-32ef-61ad50dfd248@canonical.com>
Date:   Fri, 6 Aug 2021 12:28:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <96709926-30c6-457e-3e80-eb7ad6e9d778@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/08/2021 12:23, Arend van Spriel wrote:
> On 05-08-2021 15:53, Kalle Valo wrote:
>> Linus Walleij <linus.walleij@linaro.org> writes:
>>
>>> On Tue, Aug 3, 2021 at 5:09 PM Colin King <colin.king@canonical.com>
>>> wrote:
>>>
>>>> From: Colin Ian King <colin.king@canonical.com>
>>>>
>>>> Currently the variable ret is uninitialized and is only set if
>>>> the pointer alt_path is non-null. Fix this by ininitializing ret
>>>> to zero.
>>>>
>>>> Addresses-Coverity: ("Uninitialized scalar variable")
>>>> Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware
>>>> binaries")
>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>>
>>> Nice catch!
>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I assume this will be fixed by Linus' patch "brcmfmac: firmware: Fix
>> firmware loading" and I should drop Colin's patch, correct?
> 
> That would be my assumption as well, but not sure when he will submit
> another revision of it. You probably know what to do ;-)

I'd prefer my patch to be dropped in preference to Linus' fix.

> 
> Regards,
> Arend

