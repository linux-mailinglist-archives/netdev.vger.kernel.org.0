Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFF324D783
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgHUOnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 10:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHUOnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 10:43:24 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A2EC061573;
        Fri, 21 Aug 2020 07:43:23 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so968040plt.3;
        Fri, 21 Aug 2020 07:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KxSiaalwJaME4ZfRAha7YffGpv+JyYBz2E05xYHBT9o=;
        b=RDvtAUTu0zgMV7yaQDSc9aYO/XI5MPDNeFekaOswDUpcu94OPV5HdA0a54YLa2yA7L
         AL0GDo8vxaDZK9LXJ2179GGJHLSA+j3VQLOwzwf15/ZaZHncVvImEdpjrRIe3bfsefor
         GfzvK10EgBFAt6ZZaTpgtx4CQKjkghmQ38XIhN4I/F1bozSWtTJSKc1V1FPrSCe9Yc+1
         OBGlVWBAdX37jy3efbhRvs7rmaKNZNS36HoT6j2UfD2AhiOhfngZVXjxFwVU/ciblhFS
         FW92LJrc4Z8Lmw1pcUlHM9eLuE4kHoHG8jwozUNPHRPlkEIT/V7vJVF3R5DNaMRU0tfh
         4mYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KxSiaalwJaME4ZfRAha7YffGpv+JyYBz2E05xYHBT9o=;
        b=PvGnpLOu6Ugh4ToaN9MO2SIggFI4mykgxq7+ZD6/D7UaKJ6izw0v6WexWh/JON5Tue
         2oRNlBFxPT4gEmh+y7Rl10gycyd9tXtMqevaKZiRaUOCZpBOTWJv+E7mK3ebZI6nji8I
         cyhR+8zhTM5Mz6ejvZrjK7e5mtnP9k9fjcQNSgu3outtw6WbuEvaFFa842tJSRntJVGC
         9T0HTw9eEcJUE/1w3Of/nHGN1KrYUeRbkMl4cRDA5NMwST82FgmG/J3GbnGIzjfVm+bX
         hBIdoaaxZFaJ80LDrxVwpoWYvbLzryXFEzhmoRCQmkB+0pDgQaf+Knozadz6P93sCBR5
         rK5A==
X-Gm-Message-State: AOAM530grrcXTqEdhESSyqkcetF1yjFA3qPnkcWNAXL3lUoS70oas0/I
        nL9+00oxP0LsBz4xB6ZrtoZZYoDQMfg=
X-Google-Smtp-Source: ABdhPJxgldVhE1PcofC9mYkwJyVlEM4WbizC8HPHrqcEoChF65VDb1ZOAavOBDNY96gC3+eObka9Lg==
X-Received: by 2002:a17:902:221:: with SMTP id 30mr2674485plc.222.1598021002532;
        Fri, 21 Aug 2020 07:43:22 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id n26sm2795181pff.30.2020.08.21.07.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 07:43:21 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: b53: check for timeout
To:     trix@redhat.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200821135600.18017-1-trix@redhat.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b249a607-8963-f6c4-3852-0160b72427fc@gmail.com>
Date:   Fri, 21 Aug 2020 07:43:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200821135600.18017-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/2020 6:56 AM, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis reports this problem
> 
> b53_common.c:1583:13: warning: The left expression of the compound
>    assignment is an uninitialized value. The computed value will
>    also be garbage
>          ent.port &= ~BIT(port);
>          ~~~~~~~~ ^
> 
> ent is set by a successful call to b53_arl_read().  Unsuccessful
> calls are caught by an switch statement handling specific returns.
> b32_arl_read() calls b53_arl_op_wait() which fails with the
> unhandled -ETIMEDOUT.
> 
> So add -ETIMEDOUT to the switch statement.  Because
> b53_arl_op_wait() already prints out a message, do not add another
> one.
> 
> Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")

For future submissions: no need for a newline between your tags here, 
the Fixes tag is just a regular tag in the commit message.

> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
