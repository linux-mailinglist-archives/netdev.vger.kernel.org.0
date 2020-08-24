Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA87924F0FD
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 04:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgHXCGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 22:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgHXCGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 22:06:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E19C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:06:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mt12so3428811pjb.4
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=63EFOx9CP79rHXKBsQVdb1ONQtYE/Pz2fcJGRlxR+ek=;
        b=bAhusmb/eQmTaj0FCuq+0SRUGGEIR+FQ7pYXhqbaHnzLoBKaWBLpQT0WqMzbDAWTuz
         pBHzAb54rZA62VsY3knXxJgvhZsw4BRID7rYEiVW7U0fLSc8pGnR8INOb0fDEBiLqJJq
         YR5MwUxwbu4Bo7FruOpFVlKtmRn4PH59k8GUrE9BenaTT5g2HgEY4IEd8TsOM8fB3I4g
         gDSQWma2pFEmGxMaRE52yU246oTD1szZmlP+eDpWKvxkg7lsuLxZrinyTzxmtMEkfghJ
         5qFFtsCrNctb2DtmR6EtPGiXcdKNnYj4YfPabG49NEslX0P3CclwQeRkC0kpRjrx7GDg
         McBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=63EFOx9CP79rHXKBsQVdb1ONQtYE/Pz2fcJGRlxR+ek=;
        b=O1cZFtknRcFMjRuFWVrAeqULadBlXe/+yUP7Ga/JgslNoz58Zmi2LvWlV2xkdxC7Ye
         pMalUTztwWyXN5/rni93OfskgjFdXOwDPYiDspoAaxmgiBmm5gZ8El5PbILl9BWlDP1w
         S86hocXJPSZm9CmMPqpbr6gwtZxdZfUKyF6xXiXifC+5j/yU9gXW6bCNni1UGok+13j8
         7IBlMMO71MEm7UF9unQVb70hD8yQsKoK4rjeaJASHvPOjjE706XJasUZu8OIDi0r+Wjk
         8+x57lxpQ7EYqHoALzZalWlhOICYHpxM64+2lU/7hwsnjtCAc32oU4r0PIkafgkrRMFf
         urOA==
X-Gm-Message-State: AOAM532WljbgrAP9lRXsZRC0sWMuDCra6LRrSh2sY6M34U1x7Wc4snPL
        hy3vpCKZrkZdT2XUushVhv3UFXG7Wdw=
X-Google-Smtp-Source: ABdhPJx0I/F5ZrcE1Sbzc6lgKeurxs1W+k9lZG4jUWL3rBMN+i0drYUKqL0kDN1ftZQKdADdi16Mnw==
X-Received: by 2002:a17:90a:6903:: with SMTP id r3mr2788684pjj.65.1598234772459;
        Sun, 23 Aug 2020 19:06:12 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f21sm1341540pjj.48.2020.08.23.19.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 19:06:11 -0700 (PDT)
Subject: Re: [net-next PATCH 2/2] net: dsa: rtl8366: Refactor VLAN/PVID init
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <20200823205944.127796-1-linus.walleij@linaro.org>
 <20200823205944.127796-3-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6757c233-b072-837b-e1ce-f88d8819b396@gmail.com>
Date:   Sun, 23 Aug 2020 19:06:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200823205944.127796-3-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/23/2020 1:59 PM, Linus Walleij wrote:
> The VLANs and PVIDs on the RTL8366 utilizes a "member
> configuration" (MC) which is largely unexplained in the
> code.
> 
> This set-up requires a special ordering: rtl8366_set_pvid()
> must be called first, followed by rtl8366_set_vlan(),
> else the MC will not be properly allocated. Relax this
> by factoring out the code obtaining an MC and reuse
> the helper in both rtl8366_set_pvid() and
> rtl8366_set_vlan() so we remove this strict ordering
> requirement.
> 
> In the process, add some better comments and debug prints
> so people who read the code understand what is going on.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

[snip]
> +/**
> + * rtl8366_obtain_mc() - retrieve or allocate a VLAN member configuration
> + * @smi: the Realtek SMI device instance
> + * @vid: the VLAN ID to look up or allocate
> + * @vlanmc: the pointer will be assigned to a pointer to a valid member config
> + * if successful
> + * @index: the pointer will be assigned to the index of the valid member config
> + * if successful
> + * @return: 0 or error number

You could return the index directly, since only negative error codes are 
of interest to deal with failures?

[snip]

> +
> +	dev_err(smi->dev, "all VLAN member configurations are in use\n");
> +	return -EINVAL;

Maybe -ENOSPC?

[snip]

   				vid);
> +
> +		ret = rtl8366_set_pvid(smi, port, vid);
> +		if (ret)
> +			dev_err(smi->dev,
> +				"failed to set PVID on port %d to VLAN %04x",
> +				port, vid);
> +
> +		if (!ret)
> +			dev_dbg(smi->dev, "VLAN add: added VLAN %04x with PVID on port %d\n",
> +				vid, port);

Since you are changing this message to a debug print, can we bring some 
consistency along the way and print the VID as decimal (not hexadecimal) 
to match the prior instances?
-- 
Florian
