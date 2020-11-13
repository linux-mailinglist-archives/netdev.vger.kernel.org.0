Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C692B16AE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgKMHrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKMHq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:46:58 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959D4C0613D1;
        Thu, 12 Nov 2020 23:46:55 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id oq3so11956319ejb.7;
        Thu, 12 Nov 2020 23:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=zyH6jySFIoq48BBBi1yvzlVxpEUnMEvJ2blkKXb2ejk=;
        b=bEl00iZItlntDGZuIkXa6sMVaVGUt41Wyi9S0lSGP5FH2Hsq/DrNvWNNU5mATx0B6D
         jllI7bcT2JyD/IYA47SnFBRXuhLNZ2eu+ouhd+qB+Y2nTq8Kg692pw4IjOyBvBIOMA82
         TyvofO83VsbKq70O2ifPjICthFbVGJi43792c2CDPqrKL+i3Rk4pbFYlqzoa0YxAZxNt
         BXD0iRkqfm1tTKUIFfOHgjNu+RKeconXv869ZyuOgMQnWZasCuwzpko76a/o+uZsJHsN
         LjZ+BH8S5rSf5/tVHHgu6uPbDa3GoUaw7cc9UD6ua+HgJVCHPnvGiGFx71ZzD+LMCxbH
         c57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=zyH6jySFIoq48BBBi1yvzlVxpEUnMEvJ2blkKXb2ejk=;
        b=dB1I4gSUmg/Z9EXCFDR39g3YJhR+wXsESMC5U8q+npaLg7K6tLT5vydDsvd9Xvls6G
         DtshFt72JSvp669MLc6IHQJuCsOKIH0mcRjROnS9upwoJQyEvzC0YdWPNW9cSTmpfCXi
         URUpbtog+6wYWK0sKnpqyra2LcUuteBO2xtL+WbuK0R6RwbCivnVkpuK5ZwYbfIZBxxw
         rIdSrbyOZLRJkImjMMIVEdQRVmLLjShQPM0+Ty3J2lb0FUiLswDyEQA1BFJyyW8KWtvS
         HJDI3HOrkn31VCN8WwQAhOlXR28BiSs9nwaH7C0nYKjFbUHo49yqS9ZTwEJy6Arf1WQJ
         oGnQ==
X-Gm-Message-State: AOAM533GPxInP5vzuOpDW6mUv7VTPS+b1mdCFBZf5T7UMbTGMVN3tZvn
        xVv8KStqZf8leF9r7T2/Ayo=
X-Google-Smtp-Source: ABdhPJx007OIBw73gx0ZA0eYIhjdlBIlq90Y2I46cNGiUiZZdvE98WfrkEudmmO7whYgxb9lVudr2w==
X-Received: by 2002:a17:906:cd0f:: with SMTP id oz15mr793397ejb.228.1605253614306;
        Thu, 12 Nov 2020 23:46:54 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id s26sm3364319edy.1.2020.11.12.23.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 23:46:53 -0800 (PST)
Subject: Re: [PATCH 1/3] net: mac80211: use core API for updating TX stats
To:     Jakub Kicinski <kuba@kernel.org>,
        Lev Stipakov <lstipakov@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lev Stipakov <lev@openvpn.net>
References: <20201112110953.34055-1-lev@openvpn.net>
 <20201112153042.23df4eb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <320aa95d-2954-a69a-007b-177b2b5dac46@gmail.com>
Date:   Fri, 13 Nov 2020 08:14:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112153042.23df4eb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 13.11.2020 um 00:30 schrieb Jakub Kicinski:
> On Thu, 12 Nov 2020 13:09:53 +0200 Lev Stipakov wrote:
>> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add")
>> has added function "dev_sw_netstats_tx_add()" to update
>> net device per-cpu TX stats.
>>
>> Use this function instead of ieee80211_tx_stats().
>>
>> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> 
> Heiner is actively working on this.
> 
> Heiner, would you mind looking at these three patches? If you have
> these changes queued in your tree I'm happy to wait for them.
> 
This series is a good follow-up to what I did already.
I'll have a look at it.
