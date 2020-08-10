Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7543024013D
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 05:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgHJDuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 23:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgHJDuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 23:50:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75284C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 20:50:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p1so4111424pls.4
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 20:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=cmRFdnEKW2cmEvuqp59fJ6fyMLbaBOiFPwb8NljC60Y=;
        b=WLzsoYHuFkh2cVaLTuqqjBq7blLnA1X5UVbvITM/8GD1fRwyZc2bwEkuEzBPqXJo8g
         l9QT14DgVrnrq3ajQYOXad12UMvyWt/jyNbaCpk0LsTwFkyvM43wI7mitPgisWAIY5Lm
         7X28LeYPYfNtp4gkm3g3IlvcU4LxgNGSFbUgsRsvi2OQjSCWaWbgNNi7yJSbSnUEyFmm
         9xbFyC4GkcfTgireDa1q5cQijiDyKYEht64xD/MJ/YSrbW0nA2Xu5JlGLCMX9/4NX+5N
         5BMFJJDFOzsobSIrDm2Xrazo8iKFGL002M48vR2dT9cgzTMuFQUWXZDHqUod3VMD0lON
         9evA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cmRFdnEKW2cmEvuqp59fJ6fyMLbaBOiFPwb8NljC60Y=;
        b=jH+VxPRmYvYm2bPm7KR2+ACEnGTjGreAZdY89Pn/yN4HpanLY/PdJwweYZQAbZk3/m
         2tiXN+22LwySyt+XYmFUZQixqAV1XPFMMRRRyFZxPVHxPONdd5+1hy71cqP9CcopsJ/j
         s+EmF2Z3hl5kRBfZ3lKZuSz0XMpU6j8xkiZZlg7TTK+yWomczuvt+xjcBWelTuCIqUF7
         CTp9GbvJIkS13nCTtHQTYdDL7bBLz/8A5AxHiywPBV8KG8EzFhenZM9JtaQ2aYicMXqm
         KrfWM2TGgAlAI93JYRyVOuuT0ZjZcp4ERBA1vWI4v9BWAfI1zTb1QY8ONfv1ukeINmem
         Oumg==
X-Gm-Message-State: AOAM533qL66XnuuxKxZdiIL5FhUsqPU+g9banRo5Zgp9AaufXXHf5Ff8
        sisyzmsj0/QDZnyj+xQuGZQkJ+uGcHI=
X-Google-Smtp-Source: ABdhPJx36HQ6Tq+0vKHU2mpEQFQQZluNmLKpNMd5rSTcuBP8K/TnjBkSSb7J9p5PJYikJ4MN3W+eKw==
X-Received: by 2002:a17:90a:c781:: with SMTP id gn1mr23952101pjb.151.1597031403585;
        Sun, 09 Aug 2020 20:50:03 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id bj18sm17391208pjb.5.2020.08.09.20.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 20:50:03 -0700 (PDT)
Subject: Re: [PATCH] ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()
To:     Joe Perches <joe@perches.com>, Xu Wang <vulab@iscas.ac.cn>,
        drivers@pensando.io, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200810023807.9260-1-vulab@iscas.ac.cn>
 <4265227298e8d0a943ca4468a4f32222317df197.camel@perches.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <2623670b-09f0-2ab4-d618-e478d98c186a@pensando.io>
Date:   Sun, 9 Aug 2020 20:50:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <4265227298e8d0a943ca4468a4f32222317df197.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/20 8:20 PM, Joe Perches wrote:
> On Mon, 2020-08-10 at 02:38 +0000, Xu Wang wrote:
>> A multiplication for the size determination of a memory allocation
>> indicated that an array data structure should be processed.
>> Thus use the corresponding function "devm_kcalloc".
> []
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> []
>> @@ -412,7 +412,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
>>   
>>   	new->flags = flags;
>>   
>> -	new->q.info = devm_kzalloc(dev, sizeof(*new->q.info) * num_descs,
>> +	new->q.info = devm_kcalloc(dev, num_descs, sizeof(*new->q.info),
>>   				   GFP_KERNEL);
>>   	if (!new->q.info) {
>>   		netdev_err(lif->netdev, "Cannot allocate queue info\n");
> You could also remove these unnecessary allocation error messages.
> There is an existing dump_stack() on allocation failure.
>
Yes, the dump_stack() tells you which function had the allocation 
failure, but since there are multiple allocation operations in this same 
function, I find these helpful in knowing quickly which one of the 
allocations failed, without having to track down the symbols and source 
for whatever distro's kernel this might have happened in.

sln

