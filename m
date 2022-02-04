Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2479B4A9A88
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359067AbiBDOBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbiBDOBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 09:01:09 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AA6C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 06:01:09 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id b5so5645094qtq.11
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 06:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KOpvDW6FKBa3j/GoiEb4WEgCjHkuEzNDz+q3xMFa+Ag=;
        b=RLP2TtOrGERC9ymsYAGGP41Xlum2wfb/bckLfU64IgzhHRkKSF/xEBBu2n7/rkVZUr
         yU3wtZDGnrf8l3q6vx9Rsn5etCP0OU2IWigtT2z/zo6+HcM4tgiM01WACVlJnEeVM5ib
         RrxXOxc6gYmnMOlsd7n0bwiOMVCWkHDUWkosXDT8ewe6LU3eVgTBKyoZLa7S7rBtuym6
         MTrFhOY47KOmGzKpfGcI11v//A91+UENUnhrzeZ458Vn+PjE5NZYrfyoL9jCdqSUvcSw
         SMtvMYUSCb5zRenO7adKlF/InOUiE3c0fHw0jm+jg+/XLvmFh824c6UQm5tll/MGnLEI
         aCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KOpvDW6FKBa3j/GoiEb4WEgCjHkuEzNDz+q3xMFa+Ag=;
        b=TbYVBjEm44rCs2qC6VyyoxsuInGZ/GX+Lz5EEraKDO+6MwNqNnfqYUilw0lDfkvt0j
         YCn6Yd3WGJIwBANXkRFNpp+s4DM/GPQ+CuzAYipnvDJ3j9ypjSCPVGNCER39UnefqlBu
         l187tGwsQEYJ5dH1ZChv+qfwGsi5VTWkNQjeaxH5gUhQ3WeUfZKk9dLZDqRodCM5iuJi
         3iOt7NEmw3pC+4ovYB9R7GOj+dGYI/4MSgInAd+oXfkT1azE4tO24bDMOgA2k/EUNCWK
         a+wOTMpK6K2Nbd0db6Htq9E0up95dKC+O7Pxeot3hU8MCOFKuiSuKk5Jld/6RqwDFyP8
         tMng==
X-Gm-Message-State: AOAM531TmmiLKFSHWbeoPivKzQdu/pyD4p2iYCt0SwJ0+f9cUCHKwMx6
        WWaIyjngLT2V1FG5bbf9W11GUg==
X-Google-Smtp-Source: ABdhPJzDhox2m0yPf2g+R5uz92ZLEywLGJbzlP6oSA3+jZaAZFvQgEfBfBrsM/WnKJh26H5qSxkwgQ==
X-Received: by 2002:ac8:5c83:: with SMTP id r3mr2056643qta.400.1643983268414;
        Fri, 04 Feb 2022 06:01:08 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id h1sm1077095qkn.71.2022.02.04.06.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 06:01:07 -0800 (PST)
Message-ID: <3718680b-5b57-b21f-329a-3740ec63bb5b@mojatatu.com>
Date:   Fri, 4 Feb 2022 09:01:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v3 1/1] net/sched: Enable tc skb ext allocation
 on chain miss only when needed
Content-Language: en-US
To:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220203084430.25339-1-paulb@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220203084430.25339-1-paulb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 03:44, Paul Blakey wrote:
> Currently tc skb extension is used to send miss info from
> tc to ovs datapath module, and driver to tc. For the tc to ovs
> miss it is currently always allocated even if it will not
> be used by ovs datapath (as it depends on a requested feature).
> 
> Export the static key which is used by openvswitch module to
> guard this code path as well, so it will be skipped if ovs
> datapath doesn't need it. Enable this code path once
> ovs datapath needs it.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

For the tc bits:

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
