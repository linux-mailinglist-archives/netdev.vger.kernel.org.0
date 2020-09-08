Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6092608E4
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgIHDGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbgIHDGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 23:06:07 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADB8C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 20:06:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d9so3482582pfd.3
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 20:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MGwGZR4Ny9bU3K0pcaanfkMtPGrFMNw8YIxN3PWz/Nw=;
        b=bW6diCA8evSHJ00RuBMNPGOPnijGra05RU4RcLlrpA1zV45PguK6EEfWAV/oMFWZhu
         Sii+omIHMImDAzrzTKLUYUg+f+lHvTGPMddJv6viEauSOPaPCUq3fGehYeG++Tn8qneI
         2O73i9HrS5xIhaG01w2mnoqAL8YWyADZypjsLSLn7Eh8EUDnWw3fffG4Hp9lQa//RRyX
         P+V+gXOWRa7fY5LHbcMm9H+/pf155e3ygnVMxfGbogLOsx/IqXLle4J5F/uBaKJiTdlS
         1zmUA38lOAdNDQAI97dPtZp6z5seVYEd7cKz/AkTlnM27D8dJNIERWqI0fSCI5sXvG7D
         ZY1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGwGZR4Ny9bU3K0pcaanfkMtPGrFMNw8YIxN3PWz/Nw=;
        b=DTkwkBmuxE7qFzcbweriKBx1ItCeJBj3iJkIWgkPscUC2uesGh5NGWQGiUNpuDvQiU
         Q4ddt4LBwppgTA7Jh7/76Wns0tUdMd4LkbZyGX8ebmG+ZQZhGtj9sXYaEyUwFzlsYMzl
         DZhDGgWhSftuEkNKLbkc6IK3/rrRBetqx/CINeH+96XmUTPw6TMmNauBLX6RNjlCej1S
         Af/GHkAbCb+Fvc1tvxo0kXzy6zw+l3BKenqzokq99IVIJzCfHp1hi2Yc//W9uVlPICjz
         lMr1x6yvMNIi/AP6X1OUAJEBdKpiSeHwBztYiuj+ip5bX66G0km21ObSUdxTmHau+sLM
         ybGw==
X-Gm-Message-State: AOAM5301Yncz10XAXqYxixq07Ovona9i1DrLTctgx1lVc+ExpuyxmIIS
        7wU4McHCvOeUCACsL82phkD7SS5F6SI=
X-Google-Smtp-Source: ABdhPJwBf0RCnoedj7R2R01xbLepei8beAu+4vKMXTi5CvpUU2XEWGUkO5Tn9zOax2hwgdB8UtQZtg==
X-Received: by 2002:a63:f1d:: with SMTP id e29mr5070618pgl.358.1599534364288;
        Mon, 07 Sep 2020 20:06:04 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id hg16sm13662646pjb.37.2020.09.07.20.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 20:06:03 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: don't print non-fatal MTU error if not
 supported
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
References: <20200907232556.1671828-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ad5f703-8e03-1d0b-2f93-393e2525b47b@gmail.com>
Date:   Mon, 7 Sep 2020 20:06:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907232556.1671828-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 4:25 PM, Vladimir Oltean wrote:
> Commit 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set
> the MTU") changed, for some reason, the "err && err != -EOPNOTSUPP"
> check into a simple "err". This causes the MTU warning to be printed
> even for drivers that don't have the MTU operations implemented.
> Fix that.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
