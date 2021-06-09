Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C44C3A15E8
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbhFINq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhFINqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:46:55 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E45C061574;
        Wed,  9 Jun 2021 06:45:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id k7so38540398ejv.12;
        Wed, 09 Jun 2021 06:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lae0pEYDoJxTdoc7J2gaenEu5PINWazwuAOPWrklAj0=;
        b=kY9wdmgnbumaP+1/UT3o0GU7UPGHQmETQG7mOuOY6xM4MeWV216hcX2duZHnYtGlwO
         eCSN7i9MyDwWmRIudithfuviqLSzH/V36ldjt0HFmqDxviyAm3hxTgEhAeSOFEiLxNUo
         xEqnp0TsVTok7WjqKYeO2wGKrrzGMSCEEh1uS4IjiZ4XNzGnYyIIkNGPHqlnIc1P+DNu
         Vs5057vdHmlZ6eqxAuDBtP93e7jJNrVO/cGjpD09iU4z7z2lju6mTMrhoERzjv6kWLuf
         qsnldh1SVrr/t13ycLh93DfqGEPmArdeS4PUKLMf6f00iQCk3a1+ox4tj6wolaYgy+QB
         3NMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lae0pEYDoJxTdoc7J2gaenEu5PINWazwuAOPWrklAj0=;
        b=CIv5EZSznqJ4++OKEAIhpfMiDkOPuHT5IgWcPmKUWmHeB+g0qw1o5AbSRdKRlA+d8N
         eRlJmmyE9btj/d/ptW/gLVF2wzSWtwx0UqDyDgmvBs2/rqebfhm1lOOLQZWNR2CBDR8m
         gC4s/P86DaCXqmKKblC9WaUJFx0g+L9kFelam+4HG1UMLlrPkV5Il5cyY7N/JJBmVE0f
         hUoMAFv6YlMIGXVXccum2MVGM7vu9hzpi6uNKmjeoOLJIxhvQL0+s9RQiz5/5Wu7hLCC
         QaiOLvS9cwNkntPrdScbYvWaZGH/rZf5leHmTtcjTAx2WJNNxZPa5KlQsHZAv8gvh590
         Vh9Q==
X-Gm-Message-State: AOAM530lbXGTaGd7CP6GJcYgwMkpQUPGiGbNt4eu9Ulz2oRb5go3BW9x
        2Cer/Xqn2BOr0xqgaq8xNlA=
X-Google-Smtp-Source: ABdhPJzTWs9sYiMLhZD96crvN7mLAv9fhHIXCSADRFrsdx3ZEdeX+2tZSbI9Nx1wBfuV6q57uVjZtQ==
X-Received: by 2002:a17:906:4e05:: with SMTP id z5mr28421329eju.520.1623246299168;
        Wed, 09 Jun 2021 06:44:59 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id am5sm1172392ejc.28.2021.06.09.06.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:44:58 -0700 (PDT)
Date:   Wed, 9 Jun 2021 16:44:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2 net-next] net: dsa: qca8k: fix an endian bug in
 qca8k_get_ethtool_stats()
Message-ID: <20210609134456.mim3to3tmns7a2lz@skbuf>
References: <YMCPTLkZumD3Vv/X@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMCPTLkZumD3Vv/X@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 12:52:12PM +0300, Dan Carpenter wrote:
> The "hi" variable is a u64 but the qca8k_read() writes to the top 32
> bits of it.  That will work on little endian systems but it's a bit
> subtle.  It's cleaner to make declare "hi" as a u32.  We will still need
> to cast it when we shift it later on in the function but that's fine.
> 
> Fixes: 7c9896e37807 ("net: dsa: qca8k: check return value of read functions correctly")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
