Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6070B4B08BC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbiBJIqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:46:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbiBJIqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:46:34 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C601C1;
        Thu, 10 Feb 2022 00:46:35 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id c3so1255088pls.5;
        Thu, 10 Feb 2022 00:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qnDkICl1v3aSjPMGB3QVSLA2e+Ekg246I7MYIMHgLhs=;
        b=TfoWkxJjcgdV7r+Po87QvoFoe7JdBzZ0e9Zne+fEMiAXO5LvnA6KVeOMVVMfob9A4q
         iMRa2/jF+Yb/OHF2ATk1j5puX8AAPNayeB9fNdU1L/l61NiWk/2JAk+0Alw9lkgD/ZD/
         o+oe7jV84HJIS1tmNfJFOQ1So7vpecrayfhGkptPMMyfn8vS2O3/ghEdRya9i72bywbr
         Ugo/e3Hdnmm+g01nslhZ3haUlEoXCrBe30rPQ5OgMv/zD1w5AIjl6FKt4LNfoQhqxyXX
         xGKS/GCKOonIcvQBCeEx84CusMk1/1H5dlW9wLr0JtMDC7LQFbJl8QLrXpU2gPvEjSqV
         VAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qnDkICl1v3aSjPMGB3QVSLA2e+Ekg246I7MYIMHgLhs=;
        b=EPerBIi+O4sAskvaSIB8wwgbWHKu2qdiTiozvUR3gqoWEF0kRXzRQJq8XM+VIj5ZBu
         bR7+hVwSy1Vjje/haDItPNFY+0GYmfaqFOaYmIjqzkPMRuZKQBdMNzLNmTX9HBir6uX+
         rmpDYuikegegraw8fwNnITM8KUYpeb9F0N6FAqndtC2uNu00AKCNSvh2CIy6i8Q9j0np
         HeKalUIM31zHhnLIH4UYRxjTsZXwJckk4WEdvaYFUu/u0WIcYR9bsptfzXUIZupmMeN6
         Wycu8BU2IEpc+QIOGaaYNbXSG0RFiLX/bgGgtAdBqX1FmYVe6jrBExoNAOVfhsN4sGr2
         tXpA==
X-Gm-Message-State: AOAM530gDgoWTBHBv9HU3/ogdoumRJf7gv8B4S1qW7pqJB46R3EyrNlP
        VjVm9RzksgCsi+vHz7m6WcszuGuBuoc=
X-Google-Smtp-Source: ABdhPJw1Ndsh35RsBi7NJVis1HGYYqFY4aNW+vqMzCgzj2MqXhBILHYv7xHFPCc/WAkEf3t5PlU/dA==
X-Received: by 2002:a17:902:b115:: with SMTP id q21mr6266566plr.6.1644482794718;
        Thu, 10 Feb 2022 00:46:34 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a14sm12662pgw.27.2022.02.10.00.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 00:46:34 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:46:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] selftests: netfilter: disable rp_filter on router
Message-ID: <YgTQ5KS1b2CZWvnR@Laptop-X1>
References: <20220210033205.928458-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210033205.928458-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo, Florian,
On Thu, Feb 10, 2022 at 11:32:05AM +0800, Hangbin Liu wrote:
> +ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
> +ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.rp_filter=0 > /dev/null

Oh, disable rp_filter on veth0 is enough for the current testing. But for the
format and maybe a preparation for future testing. Disable veth1 rp_filter
should also be OK. If you think there is no need to do this on veth1.
I can send a v2 patch.

Thanks
Hangbin
