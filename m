Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836154670C8
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344703AbhLCDj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbhLCDj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:39:58 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B37C06174A;
        Thu,  2 Dec 2021 19:36:35 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id p13so1622569pfw.2;
        Thu, 02 Dec 2021 19:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G4ufWlKrmsD64NvZE+u/UiX1KKfjs0sJHrN3kZBh1Yk=;
        b=bQfJ4JrBQ5zRxVpILd0VM5cC22BagMk5keIAvMF8t4pIRmHifQj2hsDH27xNexXI1w
         NnvOkhY+m9dHs8cA+4DWpLEZRJSvhDcWQaj59m3I96CI2qyXZqzsb2BxPggWgT/2L7Dx
         DFbsN1/XVnbHEuOllpR0ggObN0SShSzsu5lOGTymINM4ZVqzqw4rfse2iAvHKFeFbLk3
         hzGX5LTbBgDC1apn/0v2ao7tzagv44ok/NiVI1OnDjJxMASoKYrmHT7hPqQVSXssl7kR
         APtPbFW0YUtCkEkdsP2lGEgm4P6VVVNm1FcOUBmSMSDRZKSZZLvo6C34MZZhFlWMjzvs
         tcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G4ufWlKrmsD64NvZE+u/UiX1KKfjs0sJHrN3kZBh1Yk=;
        b=EXtiUXt0cN5BIkEue+1Nt0P6GiKP++JvESff4oq35MpVLHGhjm8Qtn7XOXyNL1y2/5
         BJBZwnaliEdKPsHonBLZ7HQFfzD43Ux9eywvStUXIpZIdVHp/WPkpolnteU0D+qTcyLO
         EaSM5AlXuawKkNMj9yXM93kcicB51QxnPXHGX6QdqECPvhMrGebuwPpkuTcBz9PkfL9E
         qVTWy3cNeFK7c13kMYPnoxjVnKSaZNHZi+c6XwyVotheadvuken/pVsYsift6l83Y5Vu
         U5WuzyxptbC03hmUk7Do+IyYF3RLWizRxjfrgy/0Fn0pE3FNM49lFnd1bly7VsE6CfLg
         TNBw==
X-Gm-Message-State: AOAM532aHWVEx/Jchvvm57hconyijYG5M+JorItsJv3RwtGq2u1b3XVN
        7ZjD7Y4Z5pEeKDnGdB5tQmc=
X-Google-Smtp-Source: ABdhPJxeY9BaRm3WSgmkCdqARtfvSQVLqrjqidHKvgI1zQiCim6Lkkk8VqfnNftoxhpgR6s35Zgg6Q==
X-Received: by 2002:a63:6a4a:: with SMTP id f71mr2543104pgc.115.1638502594874;
        Thu, 02 Dec 2021 19:36:34 -0800 (PST)
Received: from [10.230.2.23] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id b15sm1195104pfv.48.2021.12.02.19.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 19:36:34 -0800 (PST)
Message-ID: <06dbf340-e6ad-2492-48eb-5c18b5dc689c@gmail.com>
Date:   Thu, 2 Dec 2021 19:36:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v3] net: bcm4908: Handle dma_set_coherent_mask error codes
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, rafal@milecki.pl,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fw@strlen.de
References: <20211203033106.1512770-1-jiasheng@iscas.ac.cn>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211203033106.1512770-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2021 7:31 PM, Jiasheng Jiang wrote:
> The return value of dma_set_coherent_mask() is not always 0.
> To catch the exception in case that dma is not support the mask.
> 
> Fixes: 9d61d138ab30 ("net: broadcom: rename BCM4908 driver & update DT binding")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for the quick turnaround.
-- 
Florian
