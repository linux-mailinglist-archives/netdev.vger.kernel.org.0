Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2404E4A7403
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiBBO5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiBBO5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:57:12 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D413C061714;
        Wed,  2 Feb 2022 06:57:12 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id t14so29235298ljh.8;
        Wed, 02 Feb 2022 06:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=NvfG6Y/jICS8Pegg+REphis2Q7FSVxtaJ8A4UTNrUos=;
        b=Cujd3jPZsXBnRcJcAY2Xgb3hYhCJcxi/3HHGHeA3iYpwGiACRnorVkWHbh+nOVZv47
         29V2JR3G2CfYW2bfc+0Uz6CyM2l0yWz9gzflB1dOfm4VR7eNn4VxzMxyPlBncFtXRI0/
         GleWaHSbtnauiuy6DFISUyr98fq1hprKa7bUrF8VgE0e4hI5DtYd8VT3ysrlkR3P3XUn
         JK9gOWZtYAREwiw7dR8CY6bWLHiKQu/eacjiivInV58tVHKqES3x1kkmfmqfRlBuLa/I
         VKW2Hkas++m7xekdpszWRJp9hc7Y9FoR8gIIDLIGOaOpiZwFs1PCUXSbtVOu1OlBxQpe
         GAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=NvfG6Y/jICS8Pegg+REphis2Q7FSVxtaJ8A4UTNrUos=;
        b=BTpORF1ST0RZrdOAIqAvrzlQWi99l32HbqYzyHacSGViBv/rlauK8QtNZksJ341lRa
         vzGMxkxbxRqBQdwZjeqvei+GXBsD3Yn4Tv6AAG9uxVmxm7UF2GYHisOVZhkzTAGK111T
         RrYi1IE5kep0jUmFHaOpofvoU6I3kKpYxOsCSFjf5iqrtw6Wn7CphyOc6jvQ0RSkpNz0
         ga0M6oFhxzXw6CaB893fjOTdGQ2/lTmaX0ENCgwoi0yejFM3h8lIDkxq5kdzg73jrPNN
         gPA9KiGtruQoPD9J0ah5LCu3z9NvbCT1j7DnWF2GN9LcX47PSZNXgAQvmigJtIaOVyfI
         1cvg==
X-Gm-Message-State: AOAM5301nE6leqEGXUQbMzokC4Z6iZK8TML+DJwFIvJa5JSIaKqDUTyT
        slnqgE7qPx7fDNQ/GCgIVZ4=
X-Google-Smtp-Source: ABdhPJyZ9Dms/nf+tW92PuEul4f7lASvedP7sEPgrvpSiSDMSwZeZ3Y/gUkkZ0OgjUTnRY5qN8pBTQ==
X-Received: by 2002:a2e:91d9:: with SMTP id u25mr19571057ljg.41.1643813830435;
        Wed, 02 Feb 2022 06:57:10 -0800 (PST)
Received: from [192.168.1.100] ([178.176.72.241])
        by smtp.gmail.com with ESMTPSA id w11sm2973642lfr.201.2022.02.02.06.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 06:57:10 -0800 (PST)
Message-ID: <2de76f03-aea3-cfe4-72b3-a8b93c8b6dd1@gmail.com>
Date:   Wed, 2 Feb 2022 17:57:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/2] sh_eth: sh_eth_close() always returns 0
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
References: <20220129115517.11891-1-s.shtylyov@omp.ru>
 <20220129115517.11891-3-s.shtylyov@omp.ru>
 <CAMuHMdW_AufMOLJjtcO3hp-GwD0Q6iDL1=SD6Fq+Xe5wL46Yow@mail.gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
In-Reply-To: <CAMuHMdW_AufMOLJjtcO3hp-GwD0Q6iDL1=SD6Fq+Xe5wL46Yow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.02.2022 11:58, Geert Uytterhoeven wrote:

[...]
>> sh_eth_close() always returns 0, hence the check in sh_eth_wol_restore()
>> is pointless (however we cannot change the prototype of sh_eth_close() as
>> it implements the driver's ndo_stop() method).
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
>> analysis tool.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> Thanks for your patch!
> 
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Note that there's a second call in sh_eth_suspend().

   Made no sense to change it. :-)

> Gr{oetje,eeting}s,
> 
>                          Geert

MBR, Sergey
