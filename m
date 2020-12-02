Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D20A2CB3C6
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbgLBEIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgLBEID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 23:08:03 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94906C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 20:07:17 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id k8so331864ilr.4
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 20:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zRcLow9LzMsiL5TSQ+fKaZ0SxCisCyLg6rrZH3uCaPM=;
        b=WGUiPBV62UsG4zS8iPdmCQxxFc7VrwXvyKsZ8waT9ONaqL0LifE22c46rZ9DgiDG64
         PyV1KYlV2y2wZhiuzmjM+aRNEQFCqrFp+w7ZB58YVVB/rJMcDOrIk2cSK5bG+2LBYbGj
         JbSvtr/8K4p07YSKOr582QXbfE4Qfa7B9i6Ti/Su4ljTbrLzFOtPu+RJPqeIR2DDbgUD
         ZH5Cetua/XxfDTrEVFh4waZ8dWuEAivNHeDH30A9DvvaBoQHyAOwCL9Oo/knC63f4N8H
         r8BqxfTjB8urmYReF0OOksjenQslk2g7FxTfiX1DzpGs4Ki5OT39tNnlr7ar1Dqcp5eD
         4XVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zRcLow9LzMsiL5TSQ+fKaZ0SxCisCyLg6rrZH3uCaPM=;
        b=l5iAuh9pm5sCvR5hN1coUTu727hv1qRyeNfJRFHCgDjOnXA1rbA4nvEMhkXkNeEyp5
         WbzrYX5gXAsSEfCTwhOVikUIPnEHpi5avB1SB76yKXHAzwR9OCY6cX8SFiRK2Jjw9fun
         5M18Kk7NSKVRwv3Cpl3agn5AaDvDgdH39aVdlNvbtkyHllvKxP2FZmDg56bDW6kARVq9
         438IytMuzk1QwoKu2zUrR5XEcGa7RFzI7wRRKfPpqy4ZBqItnywJS8quPlZjK1C3s+L2
         s5+ySxm2PMFvhidNZNIS+LtqnBMguS6UE5Zhmny1GNBeKGWVBUp1EtksGMJ+r+8b5Dl0
         goHA==
X-Gm-Message-State: AOAM533Yr134cpN3uY12kYYIcyA+tE6pMZ5A+ih8cQhIUJ9QjENGRuzN
        3FpS8D8XywvJbyzTifIuAfY=
X-Google-Smtp-Source: ABdhPJyAHFvBKnjka7hdErHqIwIO8FdInoQNxdn8VsipcEMqXiZ/2lGqca2QXO5QxomE2kvQ8AjBgA==
X-Received: by 2002:a05:6e02:f14:: with SMTP id x20mr799617ilj.94.1606882036742;
        Tue, 01 Dec 2020 20:07:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f4ef:fcd1:6421:a6de])
        by smtp.googlemail.com with ESMTPSA id m2sm219380ilj.24.2020.12.01.20.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 20:07:15 -0800 (PST)
Subject: Re: [PATCH iproute2-next 3/6] lib: Move sprint_size() from tc here,
 add print_size()
To:     Petr Machata <me@pmachata.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Po.Liu@nxp.com, toke@toke.dk,
        dave.taht@gmail.com, edumazet@google.com, tahiliani@nitk.edu.in,
        leon@kernel.org
References: <cover.1606774951.git.me@pmachata.org>
 <96d90dc75f2c1676b03a119307f068d818b35798.1606774951.git.me@pmachata.org>
 <20201130163904.14110c5c@hermes.local> <87k0u1no8g.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <26d00984-baf6-7d30-9edc-04dfd29193c6@gmail.com>
Date:   Tue, 1 Dec 2020 21:07:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <87k0u1no8g.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20 3:41 PM, Petr Machata wrote:
> 
>> Also, instead of magic SPRINT_BSIZE, why not take a len param (and
>> name it snprint_size)?
> 
> Because keeping the interface like this makes it possible to reuse the
> macroized bits in q_cake. I feel like the three current users are
> auditable enough that the implied length is not a big deal. And no new
> users should pop up, as the comment at the function makes clear.
> 


seems reasonable and this reduces the number of users of sprint_size.


