Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1213FD0E2
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241682AbhIABrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241643AbhIABrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:47:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF18C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 18:46:25 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u6so852323pfi.0
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 18:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2tvef3VIraXxrAWFkOkuzj9hSLRIRkjDuH10nIMUABQ=;
        b=nJZwP2a1VuC7e+bEwDsBpvPXh6VTLSm3X9EjM0LFB1/cczR9Sb/5nTguJpXXU3HUa0
         0FdiFm5R6qWkVMCSn2hrLCAa3y+qC71O9IBHmqkhz5cYacfYLHpXjtbpYKWu4e95oCm6
         0rPJW5O7HOq2RRcFxHs2/pZ1OgbNM5irvdpOprZdXB0ierjF388DK4pVNdIdpKJYZnSg
         lJqVXt9qPHlWZ2L9ri/RiWO4b+Xt053l1LNAga9jKpzfEL7GNohsJyYOf8+veMKjWhdq
         Ad9KsLCP4Ctt0/BwVlhs4mHZccPl+zIDvInc8rpZ2LJuSeJQGmWgjnNpD6q/GTyF3VT1
         OxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2tvef3VIraXxrAWFkOkuzj9hSLRIRkjDuH10nIMUABQ=;
        b=pi/WxHJCsB8LsdUnMjz9hDVgDiUu1W2Cb9fcJ2p3Wjv6COx2plYZzDZkWx9hdBvVTh
         DnQIScM9eO6AcWSE9h1e8NTnOmhvCRW3kib9/85CMJaC6Cc1pCkoogWnA+EnYHNUl+0h
         yCla9ccwHAIJc/5t6CtkHkX9YtljctDbwoLPDwUoV2G8Wd7Nb1yVKXYyB9DYo6W9B01f
         NqumURkHGhi9wdv8kuv+u5YSAy4ORu4RXzQx3Gh1sr9kH1/5vlP0dsr+sAQrIGJXlUHt
         AZvwjvKP6q2dVkrCU8c0+xqmu8hwJz+73ihILXR6pg8z63LkTu6GdC1TiDO/htENR/eg
         DGsA==
X-Gm-Message-State: AOAM531/IVptz4G5AR2U9YSvHlU72nTi/YW1DlXfPpBNq/KDuE2jGbAB
        3EwssRtBvjRs2s8dHft/6IY=
X-Google-Smtp-Source: ABdhPJxJpCUpvifvFoj8h3aDwyQnki5XzntlVgoUMGE1HjWPLb6M0UUz9+XyfJ1uLZnctpad/T2APQ==
X-Received: by 2002:a65:528a:: with SMTP id y10mr29135954pgp.103.1630460785266;
        Tue, 31 Aug 2021 18:46:25 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id i21sm3385627pfr.183.2021.08.31.18.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 18:46:24 -0700 (PDT)
Message-ID: <9c86fc7c-43ac-e015-a5fd-083d17dec86e@gmail.com>
Date:   Tue, 31 Aug 2021 18:46:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH net-next v2] bnxt_en: Fix 64-bit doorbell operation on
 32-bit kernels
Content-Language: en-US
To:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, florian.fainelli@broadcom.com
References: <1630458923-14161-1-git-send-email-michael.chan@broadcom.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <1630458923-14161-1-git-send-email-michael.chan@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/2021 6:15 PM, Michael Chan wrote:
> The driver requires 64-bit doorbell writes to be atomic on 32-bit
> architectures.  So we redefined writeq as a new macro with spinlock
> protection on 32-bit architectures.  This created a new warning when
> we added a new file in a recent patchset.  writeq is defined on many
> 32-bit architectures to do the memory write non-atomically and it
> generated a new macro redefined warning.  This warning was fixed
> incorrectly in the recent patch.
> 
> Fix this properly by adding a new bnxt_writeq() function that will
> do the non-atomic write under spinlock on 32-bit systems.  All callers
> in the driver will now call bnxt_writeq() instead.
> 
> v2: Need to pass in bp to bnxt_writeq()
>      Use lo_hi_writeq() [suggested by Florian]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: f9ff578251dc ("bnxt_en: introduce new firmware message API based on DMA pools")
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
