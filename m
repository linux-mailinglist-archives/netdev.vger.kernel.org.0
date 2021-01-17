Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697762F91D8
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 12:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbhAQLFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 06:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbhAQLF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 06:05:29 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5167C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 03:04:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a10so3015697ejg.10
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 03:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZZOtxL/tegvP/udq+igSiOvxNCKBrmmDeNL0TGl2LNY=;
        b=gZ1yUZ4KhYbnrq3qKU1ym92OvuGh3PlrpGOtM3L2D+x9W2+ymdJd5eGsEbpHUWN669
         0H15dnbVKQxuovx+bBc5xFb2zc7mPrJSidCaKVySnLxbwpKfxLlb2OHvbiKKyneu/FBk
         R4Umx7FFQ9vA/QPiVfmmAoD+6NghaqMRZPau3zPqKhU+8Q6xQ9TaSBh8fmI4fP0u343C
         sQ7HUnNkWY40utOCLPtBEUs0byF4sam1wc6slTk8jB9xz4kzKfsL9PgaR6bVRdGKjUdW
         3DcIwccJeqcw1jwwGDOIyjk50QA5aey7urx0lXJNBOFxgaIrAXWQflRTm3rCaNOQbDqm
         lSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZZOtxL/tegvP/udq+igSiOvxNCKBrmmDeNL0TGl2LNY=;
        b=PQp1z946OOzj093REnyGGepmZM3EjenJ05q0bQaLWbajHDoQlYvBtNhIvoog22k9cB
         Wfe2rfSwWxRyd2Tv+KeafDiQGuAFJY/JxwdScnmlVlS6peNjaskkQbvYZDIEkck329ka
         a7OHKy4Y2+MVrsrsBXLDoEvH+/W/JPJDmxKs9fGFZ7xxJG4r2+qpj0hc0ZurtZcuS/7R
         uao+j0ocali1rrYsUHoy9uuJE+qWW2PjRJettXTALwBYKsWq2j0vbEf/VBwiQdvTOzrx
         659J1GegODMiIFs45zxFGRLFH8UO4igepGdzaOXbggCNn3rdA+DvF37hLgV6DOmuq3+C
         lzWg==
X-Gm-Message-State: AOAM530npsfhEk9u5WtFNCieZujuDPMROx+o1M8j6oc2Sv72LalWdBeq
        EKGspEMQYpYYYizpYrBYWx0=
X-Google-Smtp-Source: ABdhPJzF0hoZ7cVTf6KrRAt46CFun6zEuXV7nQ8rvET9DJAbW652G8Gh4HgOeuy16pe4NgOTx4WvcQ==
X-Received: by 2002:a17:906:2c51:: with SMTP id f17mr3168193ejh.62.1610881484257;
        Sun, 17 Jan 2021 03:04:44 -0800 (PST)
Received: from [192.168.0.112] ([77.126.22.168])
        by smtp.gmail.com with ESMTPSA id dm6sm4631215ejc.32.2021.01.17.03.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 03:04:43 -0800 (PST)
Subject: Re: [PATCH net-next V2 5/8] net/bonding: Implement TLS TX device
 offload
To:     Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
 <20210114180135.11556-6-tariqt@nvidia.com>
 <20210116185425.17636415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <b096ce67-f777-576e-4be5-840fb37101dc@gmail.com>
Date:   Sun, 17 Jan 2021 13:04:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116185425.17636415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2021 4:54 AM, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 20:01:32 +0200 Tariq Toukan wrote:
>> As the bond interface is being bypassed by the TLS module, interacting
>> directly against the slaves, there is no way for the bond interface to
>> disable its device offload capabilities, as long as the mode/policy
>> config allows it.
>> Hence, the feature flag is not directly controllable, but just reflects
>> the current offload status based on the logic under bond_sk_check().
> 
> In that case why set it in ->hw_features ?
> IIRC features set only in ->features but not ->hw_features show up to
> userspace as "fixed" which I gather is what we want here, no?
> 

On one hand, by showing "off [Fixed]" we might hide the fact that bond 
driver now does support the TLS offload feature, you simply need to 
choose the proper mode/xmit_policy.

On the other hand, as the feature flag toggling has totally no impact, I 
don't see a point in opening it for toggling.

So yeah, I'll fix.


>> +#if IS_ENABLED(CONFIG_TLS_DEVICE)
>> +	bond_dev->hw_features |= BOND_TLS_FEATURES;
>> +	if (bond_sk_check(bond))
>> +		bond_dev->features |= BOND_TLS_FEATURES;
>> +#endif
