Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268D928DBC5
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgJNIjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgJNIjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:39:37 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616DCC045871;
        Tue, 13 Oct 2020 23:13:56 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id t25so3060082ejd.13;
        Tue, 13 Oct 2020 23:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aeWyu0fhicZ35ndvB5G7CKdKzKpJv3Q8+/dMeny8r3E=;
        b=ngUoDnD3ez3wPljEH7V6ZRJPxi6VyKPo3NxCEGkokrtq2QA/+s/lV/gHCbtL1ccOZM
         y4RF2dEUkDYGhH4MNBxZg/1KDQafk1w8ITyco6/45YqH8gEgwjnp0z6zsFzKn4IOHj4s
         SEgx35DPjNeiQzLyJktDf8AGW15iQC8AEp6CWP5YKxFjWBgY54Ck35nwJlqfo9PVt8+y
         bOUQNnEc8FKh9al2GBvmeJd6AXmxiWSD5M3XIfYFKi7rr36blaxM8b/XEUh/rGL1Hk8R
         zvF+ytnIvMGQMQUTRgQmPC6Nm15fiVz3SDDpT9DWCqkOjC2BvUYWeMwsgd6Mu48AXDAk
         ln9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aeWyu0fhicZ35ndvB5G7CKdKzKpJv3Q8+/dMeny8r3E=;
        b=Tm9Kt/lLPAzdk9crNClC2f2jWoJjmuysUv/qxZidTNJe8m4l1kD7ue1rNVXN5bQx9B
         WqyIuwXa+VVVPIdD+3J9cWR80kh7P1VppdTMfZdwXQ0TceS0opbJFLh2w2eL+jFMJ8du
         /ohjdzr5w0A7rX27y9IyzVxCLlPA0Dx8GdxrQ3tyhlpaqtn4M5gg50NpepFxOLI4iC7m
         9haBTGdHJdbvTZIaEMqancmL5X4lhLlo4tGvvetlXdOBTCw4bRg4y7q3MNcZlvYiyBAF
         d4lelbTx94MTxOBp6yMPkoX1oJpmqzGSzJPgvldA4qgZBGKj+eK7fIunKn6r6Zo+iKfZ
         1pGQ==
X-Gm-Message-State: AOAM530MUIWlQf/fNc6Y1IbnQFinVRwCLtj7k9PH2k6e8/qoC6Rs7urx
        O0mE9HWnjSDHVrFzITTmY7w=
X-Google-Smtp-Source: ABdhPJyZIBVV6msuVArNaw4EDCFq2Apl0m8HnRD2XrtAzYoL6edLcNmhgdgke6mQaAV0e1pcOOmFPA==
X-Received: by 2002:a17:907:2179:: with SMTP id rl25mr3703878ejb.450.1602656034995;
        Tue, 13 Oct 2020 23:13:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:e563:1e0d:2b0d:aba7? (p200300ea8f232800e5631e0d2b0daba7.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e563:1e0d:2b0d:aba7])
        by smtp.googlemail.com with ESMTPSA id oa19sm1016118ejb.95.2020.10.13.23.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 23:13:54 -0700 (PDT)
Subject: Re: [PATCH net-next v2 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
To:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
 <20201013173951.25677bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201014054250.GB6305@unreal>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3be8fd19-1c7e-0e05-6039-e5404b2682b9@gmail.com>
Date:   Wed, 14 Oct 2020 08:13:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201014054250.GB6305@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.10.2020 07:42, Leon Romanovsky wrote:
> On Tue, Oct 13, 2020 at 05:39:51PM -0700, Jakub Kicinski wrote:
>> On Mon, 12 Oct 2020 10:00:11 +0200 Heiner Kallweit wrote:
>>> In several places the same code is used to populate rtnl_link_stats64
>>> fields with data from pcpu_sw_netstats. Therefore factor out this code
>>> to a new function dev_fetch_sw_netstats().
>>>
>>> v2:
>>> - constify argument netstats
>>> - don't ignore netstats being NULL or an ERRPTR
>>> - switch to EXPORT_SYMBOL_GPL
>>
>> Applied, thank you!
> 
> Jakub,
> 
> Is it possible to make sure that changelogs are not part of the commit
> messages? We don't store previous revisions in the git repo, so it doesn't
> give too much to anyone who is looking on git log later. The lore link
> to the patch is more than enough.
> 
I remember that once I did it the usual way (changelog below the ---) David
requested the changelog to be part of the commit message. So obviously he
sees some benefit in doing so. 

> 44fa32f008ab ("net: add function dev_fetch_sw_netstats for fetching pcpu_sw_netstats")
> 
> Thanks
> 

