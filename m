Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E503CB336
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 09:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbhGPH2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 03:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhGPH2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 03:28:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D30C06175F;
        Fri, 16 Jul 2021 00:25:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v5so10935933wrt.3;
        Fri, 16 Jul 2021 00:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nU2U7Or3rdEtCmOqoYCrwSKKbz4Jehrqvr6IaJKZgTs=;
        b=n6XHovRF0pwJ+4nfLx85sK/DNh8l2vFVpyJorWRYdwDSDW//Brd2EktUnHyKlo4kyE
         CfVJQ3qT3lLCiegT6qFmrG5ugjQ2KKg85vtpaX8Q4TfgMqsqa3y1H/uL+TsG7ioT8FF5
         0jcMXx2DCwY3K9ye5f29eReq5rc3YUl4M+wZgvn4DVW6vJLvjKrS4RgoLbynmg093FJi
         xcsdLpAwrH47URotsOss9dFiOKmKQnnBtEZxS9xZurPlurjNysR4dmucwQKISjnl+p5j
         5DrYaJmDJ1CD3+6pO7nNHDIWzygmzTveOKEZ2LOrqduPF28bm42eysZwSqx4CUXu73we
         Tl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nU2U7Or3rdEtCmOqoYCrwSKKbz4Jehrqvr6IaJKZgTs=;
        b=Bjd3J8Oj7QpYr1GbN5YZ/LaEaAgBS4wbjBLgW1Fq+G3Ci4ZlZeL1EjGrPRpAuiFSGV
         CxIG+pfnSY72UylE0JvuwRUCo3zY9746RRTpp6t9ScyZm3f0tl7LKfhg+riDBKKpuM1U
         LNRnvLyugajMtP47tfThs9PjB1m/hk74KRuJyZR/ql37I+R/QXWnBmJ5fv4ENiD7TM0u
         ITh65SE8dlmmpwj3bNyj/dG0tpVbX694z4gl32LbFIqTfg77K46rFn4dp6LY6RDFJU2g
         43qKjcM1/gWjd679SWQ1n5ajW46V/yYqR4VAUqQ6n4jqsesebLMCAehCw6tJmV9zXF8n
         Q7vA==
X-Gm-Message-State: AOAM53367dHWfZpXp/t5sh8UTfYP0bcc8xhYmGmYV0VSXJvN1TT1pqtu
        3QKIQcFxOzVTEeeX3nqKIe4l7+O9xys=
X-Google-Smtp-Source: ABdhPJxqU2miLwcEmR2R813KcskUW1hFKadA/xanznNK9rVmYmiWsWLV+4zuHPJ/Lqgoe38bflpcDQ==
X-Received: by 2002:a05:6000:18c8:: with SMTP id w8mr10446991wrq.90.1626420322679;
        Fri, 16 Jul 2021 00:25:22 -0700 (PDT)
Received: from debian64.daheim (p5b0d74ab.dip0.t-ipconnect.de. [91.13.116.171])
        by smtp.gmail.com with ESMTPSA id v2sm8870981wro.48.2021.07.16.00.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 00:25:22 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94.2)
        (envelope-from <chunkeey@gmail.com>)
        id 1m4IDV-0002B0-Sf; Fri, 16 Jul 2021 09:25:01 +0200
Subject: Re: [PATCH] intersil: remove obsolete prism54 wireless driver
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210713054025.32006-1-lukas.bulwahn@gmail.com>
 <20210715220644.2d2xfututdoimszm@garbanzo>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <6f490ee6-4879-cac5-d351-112f21c6b23f@gmail.com>
Date:   Fri, 16 Jul 2021 09:25:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715220644.2d2xfututdoimszm@garbanzo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/07/2021 00:06, Luis Chamberlain wrote:
> On Tue, Jul 13, 2021 at 07:40:25AM +0200, Lukas Bulwahn wrote:
>> Commit 1d89cae1b47d ("MAINTAINERS: mark prism54 obsolete") indicated the
>> prism54 driver as obsolete in July 2010.
>>
>> Now, after being exposed for ten years to refactoring, general tree-wide
>> changes and various janitor clean-up, it is really time to delete the
>> driver for good.
>>
>> This was discovered as part of a checkpatch evaluation, investigating all
>> reports of checkpatch's WARNING:OBSOLETE check.
>>
>> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>> ---

noted. Farewell.

Cheers
Christian
