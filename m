Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FB535275A
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 10:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhDBIUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 04:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbhDBIUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 04:20:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EE1C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 01:20:11 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 11so1472638pfn.9
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 01:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1NOQATeSLU3LC8PswXvNOu8gepyu3z4t7FGafHb9dCk=;
        b=Txu9YS0Z4ZuEudLDBYH4oNkbe7wGrZwp3d0ye9f+jzEYzV9oO0DlokHbke7eDDn0Bm
         0tmrBQgQ1ByKBLg9hyaXXGq9E0UB3Gm2II0FlV5joAWcXRbVQyHKnwyMESTz2jt93ndg
         BMxtJB6Li7j3TMX17ah0E1w6pyouodbFXvNthtLulAV7EYJoBbiSdpIhD3o1UaQ+QlUA
         C6rM07DpO2fSYRiB/jkagkgRNYJuSeESyoH0wPJk7IhF51oP45h9d4+FE9r5rThZ1BMS
         u+9pkMlDXoyrEkJKwKrqjGYRwgsNuqaA/PiRJ2XBf5RXyQQnziqX/knjotTXAY6MdS5Z
         C38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1NOQATeSLU3LC8PswXvNOu8gepyu3z4t7FGafHb9dCk=;
        b=i7wCF4q9zsomPZZY9u6PensOhbrAojsouAqV2NtYGlMhPLwI5+wCm4fcPTQi9HeyO5
         vTvaPtoc8Vlp96m97DF/JKF0F0b04aMjdXy2hzaMKttplkN6b04Hck9nNU08DijtnXNJ
         V0bedNak+uVAcJG7tuIAw2yYYiDQPWh3Diml+DNhn3TtA3n8sFrvm3ZQAZK1LpcTZk0t
         /eI7DBMeUG3WwyCYfqW2MUI0d5a2FHlqTy8GZI99W/w9hXPChXBU4SLKGTO2rnltCpNv
         lrJgg9D16fauOY68E+4WeY+6sTlFhmFdFQG5eG2m5Uot4GGpzbMfL/HrdyEgz6eSA2AN
         uwpg==
X-Gm-Message-State: AOAM530cm137TsS1+sgboiaalFNpbpmfLKM6HzL4F12AKRNoRpiVRHpp
        bW7Te4tPS2uSN1sDXFBTv18dCUgvzjdnBg==
X-Google-Smtp-Source: ABdhPJy8Bn7vIfzzB0RlGWHgTc8by7B8dT0RRMRlnmxcwFIw4jZmdt/7fsCgssu6uBXsM8iGUT1+PQ==
X-Received: by 2002:a65:5ace:: with SMTP id d14mr10889816pgt.249.1617351610891;
        Fri, 02 Apr 2021 01:20:10 -0700 (PDT)
Received: from gmail.com ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id i1sm7262402pfo.160.2021.04.02.01.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 01:20:10 -0700 (PDT)
Date:   Fri, 2 Apr 2021 01:17:46 -0700
From:   Andrei Vagin <avagin@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: Re: [PATCH net-next] net: Allow to specify ifindex when device is
 moved to another namespace
Message-ID: <YGbTKrb6p1sKGVaw@gmail.com>
References: <20210402073622.1260310-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210402073622.1260310-1-avagin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 12:36:22AM -0700, Andrei Vagin wrote:
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1bdcb33fb561..9508d3a0a28f 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2603,14 +2603,20 @@ static int do_setlink(const struct sk_buff *skb,
>  		return err;
>  
>  	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
> -		struct net *net = rtnl_link_get_net_capable(skb, dev_net(dev),
> -							    tb, CAP_NET_ADMIN);
> +		int new_ifindex = -1;

pls ignore this patch. new_ifindex has to be initialized to 0 here. I
found this when I tested this patch but forgot to commit a fix.

Thanks,
Andrei
