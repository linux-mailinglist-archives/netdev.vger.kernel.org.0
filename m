Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1BB658FF7
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 18:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiL2RlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 12:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiL2RlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 12:41:16 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8BBBE6;
        Thu, 29 Dec 2022 09:41:15 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id j130so12022532oif.4;
        Thu, 29 Dec 2022 09:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=XYQD80uNEGE+Edz9Ci11uGtbAeHZ6WrWh2NDOzG580k=;
        b=llTXYN23s1uXyPqDGsKZLYJtLQ6CoAEkxrUTAfIX6tFC9cRdXnVzIeRi3QDvCx+H95
         PjyO68MPpjOLjPnLOs3O+kUDsi3S6bjyAtvAlPmCYkDI8SSKnpcCr/6qN/HrVfO5AmaT
         fIVhqY2kB2PQStsboUeQuStJ8XwBwT5tmMdr0TBF9FjKzc/t+1LCnzMnUZjXusXTE23Z
         I0c0h96VP608LxRzjOA5SZ/IDXNKQttPYsJjIHta1MYGJZzh709P6UMkkQ6Iq8X9Dyf9
         jRCCMUvg07f/qV5VWogxtgKzN67obiI5+FGEYBU/R+BHC87ip6UNYP0PgEtNauIop5os
         +NiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYQD80uNEGE+Edz9Ci11uGtbAeHZ6WrWh2NDOzG580k=;
        b=1KHZ52fMKhQMArKO4VLpWcIc+4U2EVUu9xsN4oD9P2ZnFvHNj3JHZFSTgG8DI6/Jqc
         vX5Xs1a1VCw59US7YhM8OKuCKek8bJY1RCafIvmIuzYtfw+4SCNREH0JQL1CaOrfUoU9
         p71GAHG8zNEAXf2icK2E5J8ph7uzVWkUtKU34PWVoi/CRsomkXHVr8Pf13WymPrXlxxe
         h9WEu4aLjjboFMxHRqUY/r+x2njSff14EMi7v7F3wSq1czsOgAkq/kM8AWOJ08r5yYIG
         Jh27gjBprreqTR7h4xeJygyVaBTJVvghJYZloxXCRSuSh3lInyOq5Xr4Lwxf/YEkipZV
         ASiw==
X-Gm-Message-State: AFqh2koqjztfWzijvJsA8dB3NmabOQMYo6moWwtylS46GAsBsYoovdyY
        egEeyGF2fAmRcX/jdAa8eQM=
X-Google-Smtp-Source: AMrXdXudgEl5TeHy3QtPUtm6c9XuFGNEmEjxCynztwlcWFeDSQpglsPySYbO5RmEbrJSGmnIGQ1hig==
X-Received: by 2002:a05:6808:18c:b0:360:e6ba:eb0d with SMTP id w12-20020a056808018c00b00360e6baeb0dmr13028153oic.13.1672335674395;
        Thu, 29 Dec 2022 09:41:14 -0800 (PST)
Received: from [192.168.0.158] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id m205-20020acabcd6000000b0035763a9a36csm8257194oif.44.2022.12.29.09.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 09:41:13 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <d09d2480-a21e-69b3-90e4-5f361947057b@lwfinger.net>
Date:   Thu, 29 Dec 2022 11:41:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/29/22 06:48, Martin Blumenstingl wrote:
> This series consists of three patches which are fixing existing
> behavior (meaning: it either affects PCIe or USB or both) in the rtw88
> driver.
> 
> The first change adds the packed attribute to the eFuse structs. This
> was spotted by Ping-Ke while reviewing the SDIO support patches from
> [0].
> 
> The remaining three changes relate to locking (barrier hold) problems.
> We previously had discussed patches for this for SDIO support, but the
> problem never ocurred while testing USB cards. It turns out that these
> are still needed and I think that they also fix the same problems for
> USB users (it's not clear how often it happens there though).
> 
> The issue fixed by the second and third patches have been spotted by a
> user who tested rtw88 SDIO support. Everything is working fine for him
> but there are warnings [1] and [2] in the kernel log stating "Voluntary
> context switch within RCU read-side critical section!".
> 
> The solution in the third and fourth patch was actually suggested by
> Ping-Ke in [3]. Thanks again!
> 
> These fixes are indepdent of my other series adding SDIO support to the
> rtw88 driver, meaning they can be added to the wireless driver tree on
> top of Linux 6.2-rc1 or linux-next.
> 
> 
> Changes since v1 at [4]:
> - Keep the u8 bitfields in patch 1 but split the res2 field into res2_1
>    and res2_2 as suggested by Ping-Ke
> - Added Ping-Ke's reviewed-by to patches 2-4 - thank you!
> - Added a paragraph in the cover-letter to avoid confusion whether
>    these patches depend on the rtw88 SDIO support series
> 
> 
> [0] https://lore.kernel.org/linux-wireless/695c976e02ed44a2b2345a3ceb226fc4@realtek.com/
> [1] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366421445
> [2] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366610249
> [3] https://lore.kernel.org/lkml/e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com/
> 
> 
> Martin Blumenstingl (4):
>    rtw88: Add packed attribute to the eFuse structs
>    rtw88: Configure the registers from rtw_bf_assoc() outside the RCU
>      lock
>    rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
>    rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()
> 
>   drivers/net/wireless/realtek/rtw88/bf.c       | 13 +++++++------
>   drivers/net/wireless/realtek/rtw88/mac80211.c |  4 +++-
>   drivers/net/wireless/realtek/rtw88/main.c     |  6 ++++--
>   drivers/net/wireless/realtek/rtw88/main.h     |  6 +++---
>   drivers/net/wireless/realtek/rtw88/rtw8723d.h |  6 +++---
>   drivers/net/wireless/realtek/rtw88/rtw8821c.h |  9 +++++----
>   drivers/net/wireless/realtek/rtw88/rtw8822b.h |  9 +++++----
>   drivers/net/wireless/realtek/rtw88/rtw8822c.h |  9 +++++----
>   8 files changed, 35 insertions(+), 27 deletions(-)
> 

Martin,

I do not feel qualified to review these contributions, but I have some suggestions.

The first is that the subject should start with wifi: rtw88: .... That is a 
fairly recent change that you likely did not catch.

My second comment is that changed patches should have a version number to 
identify that they are new patches. You can generate the correct form using the 
"-v N" option in 'git format-email'. Once you have generated the patches, you 
should then edit them to indicate what change was made to each patch in the 
various versions. Such explanations should go below the --- following the 
Signed-off-by line, and end with another ---. With these additions, the 
community, and more importantly Kalle, can keep track of the various versions, 
and know what reviewer's comments have been addressed.

I know of several people that have asked about SDIO versions of these drivers. 
They will be pleased to see them become available.

Larry

