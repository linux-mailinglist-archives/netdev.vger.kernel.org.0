Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CBF4E6863
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352041AbiCXSL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347622AbiCXSL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:11:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D886516C
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 11:09:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u26so6532212eda.12
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 11:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c9rOFXITwuFs5tlwnG8W+SSMKJe0FhkRabHSeuP4T6w=;
        b=dRNnV/e9SYJPFqDjx6ODTBUE+aJaEvnvWjsNJ+XeBD9En93VVQpFKff9XqyV2JYc6h
         4VJzHsqkSh1dnL8Bn3T1p3gO8xk3VwzzV59VxHc5iy1hc3rnudUSnjUGuNlfh9esV0UO
         BMnI6d3ad3NM45Je4KcH+4rE8aaCJeLpD96tpNqO7KUQwDVqgPHWIvXIgn0VIzPN4Uwx
         tgWJdzXT012uTWSoxPpxEa5IkD5RrSTWXyIyTHAePjYa7f96dhC1Gc9bGgu5AYnnbj5z
         wjYfDy2dEje5+RjJ8bk64BaZilYlk56uZl9RtYDxlOoye47+c74WfjBSzj3lqB2xxpi/
         8GKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c9rOFXITwuFs5tlwnG8W+SSMKJe0FhkRabHSeuP4T6w=;
        b=Iq+iG8hRQ8AHEmmHawDRX+et71uX95h5cLtgHfkPLF8yGqKWqXBbpowOCaf0xogUIH
         Jt7Tqel3ijUztfmoJe8PMA29k0UF/BpsCSsmxKkLDENl9k/is4QPFlZ1Ndn1T2pqV+yO
         i4dROcxZY96RL3YiMfITmiKQPNLW9YOGBXo9FoTQM+11LxO6Sz34ywF2d4VE3UJEeuaG
         BAPPnBzmp4m69Fuqebiog1RRkwxXFsh+tUqcmR9zlT/NS9CKMfjn3wWB6DH4n1IXCRR9
         hkH8nPaXfsDBA13Go+276DL2FRPo7E55Gy957xXnqY1iJcr3blAPE5olNV27C86aaZnp
         rygA==
X-Gm-Message-State: AOAM533aJ9BEDAiNxbTL9AekIJidu9lD+sLZPiM8OlpFF4a+L9vmM4Rp
        gN/KioN20x3WDKh2zIfSMaE5Kw==
X-Google-Smtp-Source: ABdhPJw2UFihJ++KA+tfiJ39FvJzyglHZNTC+mEi0BRUu68pDp7bK24adQCft59/DtjDT+/xoFuaFA==
X-Received: by 2002:a50:9f64:0:b0:410:801c:4e2f with SMTP id b91-20020a509f64000000b00410801c4e2fmr8143483edf.179.1648145394163;
        Thu, 24 Mar 2022 11:09:54 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id jg39-20020a170907972700b006e047c810dbsm1435609ejc.56.2022.03.24.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 11:09:53 -0700 (PDT)
Date:   Thu, 24 Mar 2022 18:09:28 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     linuxarm@openeuler.org, ilias.apalodimas@linaro.org,
        salil.mehta@huawei.com, netdev@vger.kernel.org,
        moyufeng@huawei.com, alexanderduyck@fb.com, brouer@redhat.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: hns3: support skb's frag page
 recycling based on page pool
Message-ID: <Yjyz2DIcXiyf7/pL@myrica>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
 <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
 <YfFbDivUPbpWjh/m@myrica>
 <3315a093-582c-f464-d894-cb07522e5547@huawei.com>
 <YfO1q52G7GKl+P40@myrica>
 <ff54ec37-cb69-cc2f-7ee7-7974f244d843@huawei.com>
 <Yfuk11on6XiaB6Di@myrica>
 <e0795eee-26d8-1289-e241-b88c967027d7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0795eee-26d8-1289-e241-b88c967027d7@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry for the delay, I had to focus on other issues.

On Mon, Feb 07, 2022 at 10:54:40AM +0800, Yunsheng Lin wrote:
> When there are more than two steps for the freeing side, the only case I know
> about the skb cloning and expanding case, which is fixed by the below commit:
> 2cc3aeb5eccc (skbuff: Fix a potential race while recycling page_pool packets)
> 
> Maybe there are other case we missed?

Yes it's something similar, I found the problem in skb_try_coalesce().
I sent a possible fix, we can continue the discussion there:

https://lore.kernel.org/netdev/20220324172913.26293-1-jean-philippe@linaro.org/

Thanks,
Jean

