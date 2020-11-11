Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C682AF2A7
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgKKN4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgKKN4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:56:02 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F79EC0613D1;
        Wed, 11 Nov 2020 05:56:02 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id w7so737380pjy.1;
        Wed, 11 Nov 2020 05:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/oTKux9356v8Pnt/DJMB+BRRlhQ3RGH/0wzaQI4OieQ=;
        b=aoLUV7gsuZKu9cjHuuuE0XVTdX/5EWi3Hzj0bxmTd0/gGTsKDirRNhoJrjJhf/Wq+p
         BRqXLUu7e7Gi1z64uJ1Yt2XkEV/eIhaRD4y3T9V1cGIDSqjkScV6S+RyWA77o2xdnxhE
         VnKu+m8G0LVqdW9VX5HPgtC+XqX0ouxqg6zFlLypaKHhM9mBQgyiiO0lIZQv4ANdVM62
         LBZvnh05whMghlBEeHuOck8GP5yXWmM4tgLJ+nlhdrAowbJ5PwF4Bo/ik3PphG+8wXAj
         PNAegFsqhZ7Aub5bm0wdnesWdEkWRx+JBRCg31SBXbhqcMR/Sm5afgDc+L5FXvmDVJhn
         Is+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/oTKux9356v8Pnt/DJMB+BRRlhQ3RGH/0wzaQI4OieQ=;
        b=KC3aBTbyYTYpig035PNg2Y/KxckcCjDtDXRSaoTSULMNjnFdDKfqu9S/R/2osAtI+y
         ea4qWcb7IaczswecK79KtYcAOdy/z2UEyo41AcaIhfl20p7kOsqsB/WiXnLJGCOqnBV3
         7Nik8rHjCtgAbZVjYFUNlgYNYoNCkZ/6V1EBHoGz/cy0rn256i2TVEzDTQS0VvfeHEd5
         KJPJto798umPlZKgNL50iIatRxUd6jnkcngxumGuX7YKs0+lehDS2frDE0RHJCgSlg46
         p9Npm2KAaGexfkSHqiT9jijNRtHcsW0YnA3xoP9D30wPkYQGltkA7RpbmxYPaD4bdqdp
         UlmQ==
X-Gm-Message-State: AOAM531HgBBpIn6sbd1wXDixHG53H9cWeZT6fws6ULP9eWeeTrma47oI
        Dev4pleCKD5Rpctfxke4o2w=
X-Google-Smtp-Source: ABdhPJyaxDNhW4iY3Ax1I/Ns48krhM6shL56VeSVwD0LiykHpu5zQ89bwioiFAPwWzEHibBZhss2Sg==
X-Received: by 2002:a17:90a:e391:: with SMTP id b17mr3983841pjz.209.1605102961640;
        Wed, 11 Nov 2020 05:56:01 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a23sm2734074pgv.35.2020.11.11.05.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 05:56:00 -0800 (PST)
Date:   Wed, 11 Nov 2020 05:55:58 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock
 is ERROR
Message-ID: <20201111135558.GB4928@hoboy.vegasvil.org>
References: <1605086686-5140-1-git-send-email-wangqing@vivo.com>
 <20201111123224.GB29159@hoboy.vegasvil.org>
 <cd2aa8a1-183c-fb15-0a74-07852afb0cb8@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd2aa8a1-183c-fb15-0a74-07852afb0cb8@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 03:24:33PM +0200, Grygorii Strashko wrote:
> 
> Following Richard's comments v1 of the patch has to be applied [1].
> I've also added my Reviewed-by there.
> 
> [1] https://lore.kernel.org/patchwork/patch/1334067/

+1

Jakub, can you please take the original v1 of this patch?


Thanks,
Richard
