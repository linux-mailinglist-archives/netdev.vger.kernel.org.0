Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5E52E6D84
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 04:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgL2DOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 22:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbgL2DOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 22:14:44 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6446DC0613D6;
        Mon, 28 Dec 2020 19:14:04 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id i5so8474427pgo.1;
        Mon, 28 Dec 2020 19:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5L2BeZxD1fCacxNGn9/AjnA8c7fkk1+lgx9wImsrvOo=;
        b=Suyy89HPcJjLUL9cc4rsW2uCwno+fF//Mhpi0vHW4w2yZNNvjvKq4ZOIL1SNiKyPhy
         LOTl84npheuJ9JImOH5aFfETxvamSrVVqSoOY1Jr7e0vGIouZl82jGNAu2+O3N0siXFE
         NHL9i7hKv0a/N2IkMH+CXsO++Nf6Z/GHuVqO+w7aatfHh3lpteK9NDuxiiNvE3rF0brT
         rJENMvA0wMLQx0UhbNXojX1g+6VXYxO3RvBYFeRhqpdzQCoPt8F2EZvMeBubl7ewSSNb
         RhdXtQoT9p9pOQd0SD3ugeI+yFuvQPUtjpOnWZ37ng3Cjy5ysYhN90nTUY0ukjFE3gsG
         pAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5L2BeZxD1fCacxNGn9/AjnA8c7fkk1+lgx9wImsrvOo=;
        b=j058G13lw8BIyOEWheUiVtdoS13kN43EWDBpjGh3AkRe5HX6p74vNIFlWy90vvDf8Z
         jOjshuPDL+X8jWPK5pLCqnHznKu/4nijuxTp/0Z1C6Qkil6RscXBy0NUVC0KDxvavKAc
         bRZ3T6h8SeTf2D1jmfid9WYZoKLbPR7OdHARI2IPYZmDoNIhRge+BcijCSNJVP7ZpGiv
         LGk+AUiHIYiOccKfoVfneM+Pd7xwWBTgeJgkxD4pqsrZgGoJzL5P0+ZWIs1lVaAyfRVJ
         TRlEsRO07IdGG9VF0KFNGWEekf5gyt6MnJhNqEklAQS1H2eWu6pX3RNpb537HkYAnaGg
         /BXQ==
X-Gm-Message-State: AOAM532TJl17F3BngRMF6g6jslfPMLl4rw9WX4/YyVOysGtM2BZwK6FN
        gdHG9o7WRbdMlQgd2OhzMrxfMNAM93Y=
X-Google-Smtp-Source: ABdhPJzX2KdHNH6xmsS6K3wHej2Qi2qGgtDbbW//GzHfuU11/j1ii/UdeKAsa2CaiDM92DsXclS3Wg==
X-Received: by 2002:aa7:8550:0:b029:19e:46e7:913b with SMTP id y16-20020aa785500000b029019e46e7913bmr42721879pfn.58.1609211643667;
        Mon, 28 Dec 2020 19:14:03 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x15sm36611072pfn.118.2020.12.28.19.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 19:14:01 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/6] bcm63xx_enet: add xmit_more support
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
 <20201224142421.32350-4-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <014d7f14-0eea-0e7b-0b53-d7523b29f72a@gmail.com>
Date:   Mon, 28 Dec 2020 19:13:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224142421.32350-4-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/24/2020 6:24 AM, Sieng Piaw Liew wrote:
> Support bulking hardware TX queue by using netdev_xmit_more().
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
