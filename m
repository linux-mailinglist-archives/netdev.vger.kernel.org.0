Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9C13838CB
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245329AbhEQQBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344144AbhEQP7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 11:59:08 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCE9C06134D
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 07:44:10 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so5719596otc.12
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 07:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ySw4XsN6qV0AKO6t2BNte/BLCvTi3LB3300YLgDrIU8=;
        b=re6xzmrLdzsy3TWunTe4jKLiD8VmL3L1GtZXMok73BxNwOtZVmE/vt75Zsk8yu0K4i
         C2h5I8a62TWWtgfXKizkV2nR1j2HQ2tg+rAGwnRSnj74mA2MDCR7ONdG8ARp/QMM433U
         gAEo6W8dM9+9OwAeMB36JYhQa7cNJmPADl3O/1rNIwm5L47pu08eSLAL9/nmYmwoL7T/
         /K63wdKI7uaZamOQw1fGNr0MyhKvGR9Uh7kEv+nrmZzdEgyTPRzeePZApfqU3FsOFFU/
         1YD3rsx7RsBRXhDytvujIyJkiYKRXVVEIqPe9msXmtJKL3CX0LKCmmD+qljK+vb7V/vl
         afLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ySw4XsN6qV0AKO6t2BNte/BLCvTi3LB3300YLgDrIU8=;
        b=sEoAuwDREB0jgbh54DPufTlkxZV0nTjK+DR73H5BC5S6eKVfZm8tBS0ZrKT7ZwKs5p
         SoGsM1qQghL1WedD3+ZOuORXjF08s07Dt1lLgr6OgOoQb6gqizBl3vB5kXTqnG/rSv/x
         LHSPrLeMIWLEF3DTCgIXNKm4NAHunUicSISQNeDLRvIOgkOArH09IGvsfvFcz1wLLRbK
         R+dj7J5mH5ONKWaf828XsCwn8PzxpEn1q+slsRgxOWiEe2Hp5gCYgo1D8uhYWv29zxZ9
         jxr0/Dqx8O79Qi2SwOijVS+wdEyLUBbXLAINsz1WzdtKT3ssg+rZAdrEebH/Gg+cfMM8
         xN0A==
X-Gm-Message-State: AOAM532KY/7DIH5A5UjE2pDj2rsq+o2VlOpokqI4qFc/yFskIEtHajuy
        BpA5AaUGCf/NfX+lN6ccDJQ3TaibTz2z2Q==
X-Google-Smtp-Source: ABdhPJylsVQfkzsLa1DQg0qOiH++OYVLzABmBKqWWEEFU2A5F0ZL5Asy5Oe6ZysyWxH3jJxpfBz+Pg==
X-Received: by 2002:a9d:7096:: with SMTP id l22mr43770189otj.345.1621262649693;
        Mon, 17 May 2021 07:44:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id w20sm2754906oic.54.2021.05.17.07.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 07:44:09 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3] libgenl: make genl_add_mcast_grp set errno on
 error
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
References: <20210517051010.1355-1-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <06d411ad-9b64-dd58-bc13-9888af9edb22@gmail.com>
Date:   Mon, 17 May 2021 08:44:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517051010.1355-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/21 11:10 PM, Florian Westphal wrote:
> genl_add_mcast_grp doesn't set errno in all cases.
> 
> On kernels that support mptcp but lack event support (all kernels <= 5.11)
> MPTCP_PM_EV_GRP_NAME won't be found and ip will exit with
> 
>     "can't subscribe to mptcp events: Success"
> 
> Set errno to a meaningful value (ENOENT) when the group name isn't found
> and also cover other spots where it returns nonzero with errno unset.
> 
> Fixes: ff619e4fd370 ("mptcp: add support for event monitoring")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Change since v2: include errno.h
>  Change since v1: fix libgenl instead of setting errno in the caller.
>  lib/libgenl.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

It is assigned to Stephen for main branch.
