Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D81831B467
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 04:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhBOD1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 22:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhBOD07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 22:26:59 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D981C061574;
        Sun, 14 Feb 2021 19:26:19 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id n19so1229084ooj.11;
        Sun, 14 Feb 2021 19:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LzroxfWd7edOoXDwMWjBA70dJwW7wAOufrsLlsweXnE=;
        b=pwJuFcp7S3geIeiMoqFRSTzJk+rHmwECWNkEDf9yuK636GiMJn/RYB6ToGQ0XWWIzR
         whq2qzGN/UzMphqOTcxY1Vq6PvX53r2nyOLLrh0w9n5KXF7tceNSHHONnO7mYz9AMMoi
         W/cDjQzoIc3rXLFmk0GLQyKnwp4iwzJJNGERWUNTiVxy+myHwnz1qGxtJYSKBn2WVXu2
         S0JvAsJ3XWqjR1lJTSJ7UR5TF75VnkrDh5KXzv099TWytMSSxcQ5izFDRX1AJBkpQqny
         SPhXauwgzv9eR6gFV+JLr9MhrvMTzdw8SOoJ3gpdAFBdvZy2c6j9npg1CWhN1JVHHORF
         3tuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LzroxfWd7edOoXDwMWjBA70dJwW7wAOufrsLlsweXnE=;
        b=QieYW2Tmew7j00rT4fZRB7+bGakHtwBjvpjzoRpptiAnMtKmvM59kCror4y6ryB9IJ
         wSwR0tCWJ5Q8PBDga+OIUNlH6/UGAie/dpfD10cYYmiz6DxVoTrB3O0f5ITbRKztnvkS
         t5XvRLvKMKB5DYj2wvAPAxJ1rlCakj4KI+AvNaSa+FbpBJJsG6V9OQT/hYuYD/B7c+Uc
         vbRnkVk1w2nXDP1Uvva3RUx8kcBan+WQ4YFf6ZOkwQt1Pg2Q6ylv0Th2R5bpD5FubitE
         MiaBMIGRUhnxIqtivGWhexN9cM+mlX68XiRwgk76SfjJO8Xei/hTl0j57GRq66CZhDE3
         RdeA==
X-Gm-Message-State: AOAM532rdgiMup+A6j9NmR/jUNdWSqXDcggbUZrV7cG9z77HUQV3Gbyg
        +hu0r7vQG8f78oiqnv+M4cVkPCOH1PI=
X-Google-Smtp-Source: ABdhPJwnW7YCPcK7ZcVumVuYhJoTLa9ycN6CeBizSHUnsJVGbRVfxo3FxMAis5uxGnit5//tv+x4jA==
X-Received: by 2002:a4a:8c21:: with SMTP id u30mr9420439ooj.47.1613359578240;
        Sun, 14 Feb 2021 19:26:18 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:a8bf:c38c:3036:ff38])
        by smtp.googlemail.com with ESMTPSA id s18sm3379552oih.53.2021.02.14.19.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 19:26:17 -0800 (PST)
Subject: Re: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument
 handling
To:     Leon Romanovsky <leon@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Ido Kalir <idok@nvidia.com>, linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20210214083335.19558-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com>
Date:   Sun, 14 Feb 2021 20:26:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210214083335.19558-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

what does iproute2-rc mean?
