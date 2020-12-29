Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681062E6D83
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 04:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgL2DNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 22:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgL2DNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 22:13:16 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D6AC0613D6;
        Mon, 28 Dec 2020 19:12:36 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id n7so8468482pgg.2;
        Mon, 28 Dec 2020 19:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FbeG9hrkQIB16Z6licGBHxc1RcfAqz7uAriPGX8T860=;
        b=HH4g9Mt2DXYmcaZ7nna8frWTdEd7i7rcmQ2ScJXCQd2kqjGZfhpcYRoorgvyFaD5Tw
         /f81Dt8m1j/hRgKJorwksnDPKoLUBKrASTIgUkRsjipiR7VeqEZhBVyayJJWQGbOwkfJ
         hTz21EcH/GnFxdpsEwyhkf43hNTrg/+AX4LXODobRj5zuwelDAFPQJ7pBdZAsMNvO2Oy
         Vaa7fihiZ1YrlqfYalMAbOlUxraGZOg87FcaiugiQDDWgsvyfYUFSILJHR/myEjv4u7A
         TQiwZ7OGvjI97KfD1LW4DVHwBRPXWK70Ew6kl7E/yU9kqMs6rhWVBIbeoi5PWaKvMmfl
         UivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FbeG9hrkQIB16Z6licGBHxc1RcfAqz7uAriPGX8T860=;
        b=Q4KF4YHzkpOMbSl8HmA8uXbCIyXRi5XZxCptitCJaZrFM2QL3OW67E1Miky2INvA4R
         BauxzYBxKOtGH7uFKzN4OWSJH1adXDhAeWtY3rm2pWXpYA6WFqJQSL++qvsSIJZ7fiM7
         Yu2ApHVvvvS2wP53D7cW+ighjuWnurZ+08SCnnY3JW5KxkltmKZneF3Qh8NsEZL2OxVe
         2FUWXU07BL5NxeXUBhRBQXsoYhzP7ijlio+Ctdo+7OYWoGkQ2u6gxgzBUsoDSctmGWtM
         McgAnbiZl1fleHgjpLIZyfYxe8Gha+Jn3FOiPB6jDX28IOjz/qpOldTv7jQxlZAYJ2ia
         SdeQ==
X-Gm-Message-State: AOAM531MQJZ4oPkO6jkVT6sppm12XBEDQx/8ryqv+jOunX+FC79hwk77
        xYatM4cVsDNkeZ9I6AqJ+5xTQethR2s=
X-Google-Smtp-Source: ABdhPJzBGyh+d69PHVEH1uMQ+VbKEBcuVbsddWrsokwzAj13m64Uyt22CFSshpY9Qb8fub7oJMKh0w==
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id f10-20020a056a00228ab029018b212a1af7mr42873644pfe.55.1609211555541;
        Mon, 28 Dec 2020 19:12:35 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 8sm21636898pfz.93.2020.12.28.19.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 19:12:34 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/6] bcm63xx_enet: add BQL support
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
 <20201224142421.32350-3-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2d98c3b5-ce47-4366-25af-e1be0f1c75b1@gmail.com>
Date:   Mon, 28 Dec 2020 19:12:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224142421.32350-3-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/24/2020 6:24 AM, Sieng Piaw Liew wrote:
> Add Byte Queue Limits support to reduce/remove bufferbloat in
> bcm63xx_enet.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
