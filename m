Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36512CF3FE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbgLDSZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbgLDSZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:25:10 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8159C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 10:24:29 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id j13so3647396pjz.3
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 10:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v/8DYHhbQBwAb7XdKv49rtrA3IQIxMZXujuKKb3/YCY=;
        b=e2ftBDG4LzufYbDDQPh0n1MwEpaYXtMOyEUtsAiYUPMlkrXncaG6X7bL39HrL/qYdJ
         Qq5clP9nYCgnNquBwMLllnkJyGDFq5K/6MaIem9HCqc+ptvzhzjK/IABj5hkk1iTsGWU
         9nnGuFzMuuTGkq/2EijYBXerqBpMx5JmRj9ZlddNY9e5RB2q/zkI0xOGsa4jeGi+jvoc
         pajqaBqOSoXwM+ezGU2gGzTY3kksXghf395g6h43xSfFLLHJn6OfYdYBOli1ipZW+um3
         P970POhMQaBSujQHYchImoRef+jV2erjkMlIvSnEuiRzdi9WbVJL8nnWc0qtoGUBzJVM
         FMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v/8DYHhbQBwAb7XdKv49rtrA3IQIxMZXujuKKb3/YCY=;
        b=WpUjDkxNWkzmouu/3wgAMwO6iSg4uokzrxSxE9bEs1y7PViEsWOQGLGb4QloVM/vyB
         tA1T4r3RtNSHvcuEvajE9LodIJSEjeXrkMQUwBW2+up7Q3KJUyz/BzHRvBTsMOr7hQpn
         UpQQVpQlXiZhZzutslOmp1GqlZo/A2mKQnSzsOrmCrbpLO2/EyTbU6bGp2dE4gLeBxfn
         vwnZlEaDs4E9hWQ3XaiEPxXWxnwp55WVNkCC3p/CyRmeS0JLgPNVbIU5z7ejzYHc5KGF
         gj/hj7FnDPboWVaU9FyDZqWXEoEZWrfNIPWZH+W4OoH8gYlbfd8eBc80WWlMmOnMpaWx
         vjww==
X-Gm-Message-State: AOAM533NRVVLJaoYM4r1SBmU9tEsvJHRDrfZfpnnNv8cACHOFTN2Tp8n
        MergShBo6KWFdkXpFFN58V1jwpLMlc4=
X-Google-Smtp-Source: ABdhPJzgMF1hHGa58TGNjy4HrbF5vcyPdEBi+8P40rAXEIsUlkS/zyONtE89QQzhH88r5ZNIBpdgYg==
X-Received: by 2002:a17:902:9341:b029:d9:e385:bca2 with SMTP id g1-20020a1709029341b02900d9e385bca2mr5100364plp.64.1607106269034;
        Fri, 04 Dec 2020 10:24:29 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o198sm5461990pfg.102.2020.12.04.10.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 10:24:28 -0800 (PST)
Subject: Re: [PATCH net-next] bcm63xx_enet: batch process rx path
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc2e563a-80f4-bee4-c46f-6ebcec13d157@gmail.com>
Date:   Fri, 4 Dec 2020 10:24:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204054616.26876-1-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/2020 9:46 PM, Sieng Piaw Liew wrote:
> Use netif_receive_skb_list to batch process rx skb.
> Tested on BCM6328 320 MHz using iperf3 -M 512, increasing performance
> by 12.5%.
> 
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-30.00  sec   120 MBytes  33.7 Mbits/sec  277         sender
> [  4]   0.00-30.00  sec   120 MBytes  33.5 Mbits/sec            receiver
> 
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-30.00  sec   136 MBytes  37.9 Mbits/sec  203         sender
> [  4]   0.00-30.00  sec   135 MBytes  37.7 Mbits/sec            receiver
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Your patches are all dependent on one another and part of a series to
please have a cover letter and order them so they can be applied in the
correct order, after you address Eric's feedback. Thank you
-- 
Florian
