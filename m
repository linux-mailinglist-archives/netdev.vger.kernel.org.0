Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A250739E5DA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhFGRtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhFGRtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:49:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AF5C061766;
        Mon,  7 Jun 2021 10:47:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso515884pjb.4;
        Mon, 07 Jun 2021 10:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+JcPMa7HS/G5uEYOivUU91OgbCiCeeoLi8/ELtNiNKg=;
        b=bji1Z8zuREp+lKQRCaXyfYyYVdP3N0jZ76R3v35FmsLnzxwCmHNSTqM/LsayVQX0Pn
         pOLZaCgJuA6+LacVmFW8aEhmUJDPb9JPxOUjqYk89MUs//uPpxoVE01uMjrTElGk6oU2
         c0CYQp9FWYma99f1z/VQx1hZJrMUcBSskfKakXt2ZJFlrrTp+u0nm3K2KlpqZQqnC5xt
         Lmm/PdZtS+IUs1LJ4lOn87Gi1e8066mzPtL/CTiOBFahdtJFXYNWw7ZlRDZfnkZs/yay
         JkiZhCSsJyIUG+x0uqc0aud7GjJdDKFIRojxLcco5FmRGTiTjp8UYkBovUg34tYzMdO7
         rFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+JcPMa7HS/G5uEYOivUU91OgbCiCeeoLi8/ELtNiNKg=;
        b=K0WwYUVu2meM2J9LH0F7Gv0SEqU51SI3z3hNfjSl0vXjMol4s9YDvIF5UHfObOh/sV
         Df5Y5XugyuMSYTM7ZZw1TFqcyzRSNsO3o5l1Oj000HS8TPBmkq8NBMvVb7TH3z6nUYTI
         MDMGxpbE9WuWF0CuRVlcNh1iG/CYmM1I2v/u2xAcKGc8SzLzPdbV8iQoTidYl8Okyt3J
         cirpUm4HFh7jZrAEJBWJ49b6HsfTtmDVKzJoLWfSOF7QzslkSpoy92O51UKyFDTs38Zb
         BSLjxElNTZqrcgWf4FAs+0cxIcbv+DABSxqbiPuGPou3Xpv4sjiL1bcYRzV4mZdvSUDF
         gOAA==
X-Gm-Message-State: AOAM531XbSZ5Xvn2cMBRyoVLyeNFsm2djiF1DIkyKtYcC1QpuDkzaYde
        DnI8FgJXNr/OQtP4RQ03auc=
X-Google-Smtp-Source: ABdhPJzHqjHk4DE33M4AnFCbLsLHVkL6LnRIFKy3croUU1xW4x0yJzzwOmDQoGtRqJQhbvp5RL/y2g==
X-Received: by 2002:a17:90b:f84:: with SMTP id ft4mr324524pjb.104.1623088040064;
        Mon, 07 Jun 2021 10:47:20 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b195sm9467533pga.47.2021.06.07.10.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 10:47:19 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bcmgenet: check return value after calling
 platform_get_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, davem@davemloft.net, kuba@kernel.org
References: <20210607133837.3579163-1-yangyingliang@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d4a768d9-dde1-76a5-5d02-80bab7ca5225@gmail.com>
Date:   Mon, 7 Jun 2021 10:47:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210607133837.3579163-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2021 6:38 AM, Yang Yingliang wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
