Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C1740985B
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344265AbhIMQHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245040AbhIMQHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:07:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D52FC061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:06:21 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v1so6138396plo.10
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s+jGsFife75o0FbQdqZqJJSKxqv/v3jVtCkUcfRwebA=;
        b=EiS+0y/n6iXaykSVmKeGWs72BLrF00386AztZn6xetppCbojnFV9gDqLsOOtzGvJPS
         3qM62Hril7b4FNzmUG6nvAUxibwT1aw7lq0NlZKgvsvlNDDQYUR0ZpTksVh8dNmqv9AF
         pVCwQPDGSAl8axbTSPFyHoFF6dEdu/GR7XPkM7fbkEkdGtWpBx6pdnBsPzDKRURnfmus
         3iOqYHKctIr192E6/MTqgL4xm7Uav2KLN1NbORGaiwcfjDwW4KU++/6hHDyg0dhDW3tW
         wJwGSr4sxn4gE54+FQeWyxIpZPO8XnbbwsWvoZcaIXLFH6gyDryr998Xd52GKJtobbsr
         el4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s+jGsFife75o0FbQdqZqJJSKxqv/v3jVtCkUcfRwebA=;
        b=V3HX8pPANfXdV79OsyIde8niarfvefK6Oywn0CHQeS4142f+aQ8VSkKd0UAV25qAfj
         xxq3lxtN4j8dAZJIRecJ23c3lj01Xt3QAhl1FHa0zEB5obcu4s83VhEKatQMLZMwDF0q
         Vx1LpiEAPq3flP9QrjuhE+Uf3k5bb3VZgGmqDMB5mLX78005sVZXzh/v31M3o5gUVa6M
         1HdxCQVs7i8DQMJqufsRJG1BQlg9FbN2u0B4WVolFqwXv/5PGlCc9QH5mXrgqknspOgA
         86VGEm37RJJGc5L+/MZrU2Wb7oA8qlmD8hG3Y/oXjS9nEyGolTvjc3jFGkOOfBBoixV+
         4eLQ==
X-Gm-Message-State: AOAM531eeuRwmRP3v9zbjznxq0jaL1bc8NtnpkYvAwFeRx33nXPpd6Jw
        cXnl1mzeixRrFI1xV8+uXnIhsCClEMU=
X-Google-Smtp-Source: ABdhPJyrlK5Wq5cDLf5HuLG5eWjMKU1naBmoOEd8qqkX34mO2fqc6qL1pJFEBGTOqnBPrMbbkcOmsg==
X-Received: by 2002:a17:902:7682:b029:12d:3a69:c6cb with SMTP id m2-20020a1709027682b029012d3a69c6cbmr11131069pll.65.1631549180630;
        Mon, 13 Sep 2021 09:06:20 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id q2sm7393626pjo.27.2021.09.13.09.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:06:20 -0700 (PDT)
Message-ID: <3ace5a4b-fd6a-03ac-c703-8a634d4ac6eb@gmail.com>
Date:   Mon, 13 Sep 2021 09:06:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress
 frames
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210913143156.1264570-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/2021 7:31 AM, Linus Walleij wrote:
> This drops the code setting bit 9 on egress frames on the
> Realtek "type A" (RTL8366RB) frames.
> 
> This bit was set on ingress frames for unknown reason,
> and was set on egress frames as the format of ingress
> and egress frames was believed to be the same. As that
> assumption turned out to be false, and since this bit
> seems to have zero effect on the behaviour of the switch
> let's drop this bit entirely.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
