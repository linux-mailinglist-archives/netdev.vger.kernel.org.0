Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0201A33871B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhCLIL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhCLILU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:11:20 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6441C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 00:11:19 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id c10so51562251ejx.9
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 00:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GSE8y8bIzwkaWbk//Q7yq5aLD9kknS5nbctb3k5BKZQ=;
        b=i4RoYovqjn3gmv9OLHb902+P3Zv95u5vk4yHmh3+kjERn58bqd+uW4hVDRXGSgW4dp
         tfxSBRUiSlkpWWCPYe/nNT6QzPCYedLCv6MXBlEBS31WfrhZsQUkkQ+ADrnbEB98uGFq
         TaGkY6++ptJbn53XYZ8Pgzd2gsQowO+w7H8AjyIZvbEvKu+I0mURf3wSPwXBzVYHwLVS
         O2H6HEoVg7ZI+dPi2rv9fDbH89e97Q2H6RPqMCe4JbjFFMFmMVjwntUY4+NTgABazju9
         3dGMWgZRYmlc9SJIs/ATWjFITP6hit5wgFCrvxhy0tr0f9g8qvQSHvqJsy6xYGUAX31M
         AmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GSE8y8bIzwkaWbk//Q7yq5aLD9kknS5nbctb3k5BKZQ=;
        b=YKSXmJds7AH2FwLn7P8t3HsN8RG1x2PhM0fh+ffEZ/DhR8YbtKD3H51Tx4Ja1Dz+H8
         Z7ngw0pU8FU70kq0j14zFjDUAvtEYtruiAkUA8+0OjnOBj1sCEwtCuk4NMfkZk4nzdlt
         xwpynKR2qdWp7ddQZckM3x+0J+cRJoIQtF52cEiJL45cabgb75po2HDPJveEbHlDGYhi
         6Utl27w8T7ZbVc8fimPml8M7P3cLgconF08AMNjK1DNOcj1CD1Mr+MvqpiJkOWja0//F
         onGE0UIPqxxMavUNk3kynKpdJ8t7G0MBlDMw3UPhVTnhgjlJx8jjicrmDCw2kDoIgjd7
         72fw==
X-Gm-Message-State: AOAM5339u48t6YZSIAw83pAbW9f8VCQs12tPm/3Hjhjzvtk2h4QLnQD8
        yujWN6vJf/KSTPBYJhCgGDxbfg==
X-Google-Smtp-Source: ABdhPJzd7yIu2Mtt/wSmkKfgikCWLHiR0Orv+ZjRzmKUsayaFRB97LPU3kCBn3bvE/gHnjKGKH+uEA==
X-Received: by 2002:a17:907:37a:: with SMTP id rs26mr7211492ejb.336.1615536678651;
        Fri, 12 Mar 2021 00:11:18 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:76a2:a975:2529:ae9a])
        by smtp.gmail.com with ESMTPSA id i10sm2407121ejv.106.2021.03.12.00.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 00:11:18 -0800 (PST)
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, kernel-janitors@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <YEsbGCmx4Jh3fApi@mwanda>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net] mptcp: fix bit MPTCP_PUSH_PENDING tests
Message-ID: <00ef3b75-bc38-a55d-ddcb-cc100dc20e79@tessares.net>
Date:   Fri, 12 Mar 2021 09:11:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YEsbGCmx4Jh3fApi@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On 12/03/2021 08:41, Dan Carpenter wrote:
> The MPTCP_PUSH_PENDING define is 6 and these tests should be testing if
> BIT(6) is set.

Good catch, indeed, BIT() macro is missing!

It was not detected by our tests suite because in -net, that's the only 
flag that is set.

But another patch for net-next is coming and another flag can be set as 
well. What's funny is that this other flag is "9" which works well with 
"6" because their bits are not overlapping :)
Anyway, better with "BIT()" macro!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
