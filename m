Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243894FDFC3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbiDLMKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354122AbiDLMJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:09:59 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621836C1E0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:09:38 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g18so11648780ejc.10
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yNEjCnsZ8Ok4GE24ZZB1eOeuUntHqjn6YDnpHQYpIUU=;
        b=Z0lawRMq8qavym1elBuA7rs8UA4rk3soUSne7+zNAUkJwv7xvzXO81NeqRkxcJW9aA
         bw2+qs4jdmJo9OohUOzYj5Bx+Dq7CmF0H4IrXQ97fhruC0pWCB1xCkPMXsr8NTKzFrVI
         oUOYvrLsYIxRiwJpj4Rj31ATRM8nxt22e9ehPKmVMlXjajVChypo5MSNHqoVL433Rx+u
         iL57Pyv7nJVx+iQMEEqzcEewoHj6qjfKF3kZ3DeQ4eEisjFv7W9YFgBu579neAwLqQWE
         0sfiwiARQUniYIC8eT2YZcPlF3uM4BGQu2wEHYOpGmi/6WYpBGAtjgoaze/RsBIrsR24
         laEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yNEjCnsZ8Ok4GE24ZZB1eOeuUntHqjn6YDnpHQYpIUU=;
        b=8En8Ff3QlgoJcGhv2TKL7hztXXpyJQyE6Ns+2mNC4da6Cd5LvNiEr6i2RKSwSjRu6V
         yjn0bvOUg1TDyc4/9pc958enlGlwOs9QeGuNuguaWcFKyrT5bvlWO6SGacRxLsldQYHd
         CgRbXJ8pxJcCdvemeu2aEGZm9iTBnNVhHcdty89CNmazDgXpjsbM0F8WIc8jMjRRDM9M
         52/D7OuXLSj4ZrgHQdSCJi57fxJgFlfhQ3gRHHfZ3HcfM7QVR1JbuC1FZra+CdF3GmQs
         WWmm4MZs7/rt3BJLEG9sT7ousLfZ/Uyq+TpvDjsqPb41VRcFXpP9hpytx9FIzEPErKhZ
         4q5A==
X-Gm-Message-State: AOAM530fqA8BolmK0owCbN6eZksGA9D2be5Kr/d10Hrw0uk7FoXCBAEJ
        61A59XDlswbWTbPDUA2zWaMubg==
X-Google-Smtp-Source: ABdhPJx6r9S/hqtzqfcnbxxGv0MPI135kFY6IYm0Ad4Iy9V+2+90G8OECcqNutavWkXzut7ECiCfxA==
X-Received: by 2002:a17:906:8514:b0:6e8:966f:3004 with SMTP id i20-20020a170906851400b006e8966f3004mr7523501ejx.115.1649761776818;
        Tue, 12 Apr 2022 04:09:36 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z2-20020a17090674c200b006e13403964asm13122183ejl.77.2022.04.12.04.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 04:09:36 -0700 (PDT)
Date:   Tue, 12 Apr 2022 13:09:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next v2 5/5] net/sched: flower: Consider the number
 of tags for vlan filters
Message-ID: <YlVd79bM00wuK9yW@nanopsycho>
References: <20220412100236.27244-1-boris.sukholitko@broadcom.com>
 <20220412100236.27244-6-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412100236.27244-6-boris.sukholitko@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 12, 2022 at 12:02:36PM CEST, boris.sukholitko@broadcom.com wrote:
>Currently the existence of vlan filters is conditional on the vlan
>protocol being matched in the tc rule. I.e. the following rule:
>
>tc filter add dev eth1 ingress flower vlan_prio 5
>
>is illegal because we lack protocol 802.1q in the rule.
>
>Having the num_of_vlans filter configured removes this restriction. The
>following rule becomes ok:
>
>tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>
>because we know that the packet is single tagged.
>
>We achieve the above by having is_vlan_key helper look at the number of

Sorry to be a nitpicker, but who's "we"? When I read the patch
description, I need to understand clearly what the patch is doing, which
is not this case. You suppose to command the codebase what to do.
I fail to see that :/


>vlans in addition to the vlan ethertype. Outer tag vlan filters (e.g.
>vlan_prio) require the number of vlan tags be greater than 0. Inner
>filters (e.g. cvlan_prio) require the number of vlan tags be greater
>than 1.
>
>Number of vlans filter may cause ethertype to be set to 0. Check this in
>fl_set_key_vlan.
>
