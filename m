Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB47D4FE0D6
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiDLMuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354217AbiDLMr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:47:29 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E991D27148
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 05:12:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i27so36914199ejd.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 05:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=voEA3xREkBtNhZMe8ZgZ5hDKttcZOGVZTdj/cLemKnY=;
        b=uihFcdftQToCh4VFnJMBMJIsrHC5IYZEwlfuCI66r5vw5QyR1C5PEWXfSHWNFASEvB
         rIHoFh+9NHfgSWYxhoPZnj06HIvG0HJFaJMtMvfCK9dzw9APbwiIHvcXmejf1lBEcFxz
         ePZgmEl3luVgQFqL8x9gBx75e6Ou7uIw9I0u5IMhaH4pfcwkM3USfl5ELY0NVztErWR+
         cTGV0HIRQFlOxvj68Xo23uj1YPBxSvKVPw44owunif74KTqyGC3hZazmvfd9z327Iwt9
         y+UoupeYkYwBslcOMApoiYZQh39wo8LEBOyMpF+/Ns0KkLT/HtiPTl+mT2Uonz9sPM4Q
         uL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=voEA3xREkBtNhZMe8ZgZ5hDKttcZOGVZTdj/cLemKnY=;
        b=pquVct2ZMmbV1IhojrFwNYd/KkjQi3wqb0iTjpFwPbVsih5whA4rzfhc0MgEWVnnOm
         tnbyiedIiMvJQsBzQoFlpxp8/ZJTL5RcN8S2UdHRVuIGOVIIwwYZUDV2scSS4q6G72iZ
         k7GaaS+7ngcPD2RHL+biMZ2yUKV0XZujX7z0Ivv+zYWmn8qVPPPygR4BHYEDgtC+NTew
         LRY6btBFtDjxzkELhQYx/S3HQxOD4KppVi0e0mn2Meb+FYnA2pGZ1I+blPR7W3U+V3jl
         n9K5H/ZyLx3M+QUBXizTdMe65JUw+KLUwudstTiH37lJb7QL0cjSyep9dPVvebNRPsYt
         J23w==
X-Gm-Message-State: AOAM531Wypgk657anUo3sEmBeuyy6Qhm0Hnnb0qDhkqKM5+CBb82E+qe
        WjSJ3TbmaS+V2tngRI4yUHo5Dg==
X-Google-Smtp-Source: ABdhPJwDc5fPkHPk5flbHAsXudGpfZUgseWTsc4cMfsihAuOfA0zOEwtFraMYo0ZIPtApPdz15ktvw==
X-Received: by 2002:a17:906:58d3:b0:6da:bdb2:2727 with SMTP id e19-20020a17090658d300b006dabdb22727mr34090759ejs.549.1649765536359;
        Tue, 12 Apr 2022 05:12:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a1-20020a50da41000000b0041c83587300sm16066327edk.36.2022.04.12.05.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:12:15 -0700 (PDT)
Date:   Tue, 12 Apr 2022 14:12:15 +0200
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
Message-ID: <YlVsn59Cbe+pnTte@nanopsycho>
References: <20220412100236.27244-1-boris.sukholitko@broadcom.com>
 <20220412100236.27244-6-boris.sukholitko@broadcom.com>
 <YlVd79bM00wuK9yW@nanopsycho>
 <20220412114049.GA2451@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412114049.GA2451@noodle>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 12, 2022 at 01:40:49PM CEST, boris.sukholitko@broadcom.com wrote:
>On Tue, Apr 12, 2022 at 01:09:35PM +0200, Jiri Pirko wrote:
>> Tue, Apr 12, 2022 at 12:02:36PM CEST, boris.sukholitko@broadcom.com wrote:
>> >Currently the existence of vlan filters is conditional on the vlan
>> >protocol being matched in the tc rule. I.e. the following rule:
>> >
>> >tc filter add dev eth1 ingress flower vlan_prio 5
>> >
>> >is illegal because we lack protocol 802.1q in the rule.
>> >
>> >Having the num_of_vlans filter configured removes this restriction. The
>> >following rule becomes ok:
>> >
>> >tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>> >
>> >because we know that the packet is single tagged.
>> >
>> >We achieve the above by having is_vlan_key helper look at the number of
>> 
>> Sorry to be a nitpicker, but who's "we"? When I read the patch
>> description, I need to understand clearly what the patch is doing, which
>> is not this case. You suppose to command the codebase what to do.
>> I fail to see that :/
>> 
>> 
>
>What do you think of the following description? The description consists
>of two parts: the first provides motivation for the patch, the second is
>the way the motivation is implemented. I've judiciously edited out the
>"we"-word. :)
>
><description>
>
>Currently the existence of vlan filters is conditional on the vlan
>protocol being matched in the tc rule. I.e. the following rule:
>
>tc filter add dev eth1 ingress flower vlan_prio 5
>
>is illegal because vlan protocol (e.g. 802.1q) does not appear in the rule.
>
>Having the num_of_vlans filter configured removes this restriction. The
>following rule becomes ok:
>
>tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5

So this is what this patch allows? You are talking about it as it is
already possible with the code before this patch being applied.


>
>because having num_of_vlans==1 implies that the packet is single tagged.
>
>To make the above possible, is_vlan_key helper is changed to look at the
>number of vlans in addition to the vlan ethertype.

What "is changed"? You should tell the codebase what to do, what toadd,
remove or change. If you did that, it would be very clear to the reader
what the patch is supposed to do.


>
>Outer tag vlan filters (e.g.  vlan_prio) require the number of vlan tags
>be greater than 0. Inner filters (e.g. cvlan_prio) require the number of
>vlan tags be greater than 1.

Again, unclear what this describes, if the current code before the patch
or the state after this patch.


>
>Number of vlans filter may cause ethertype to be set to 0.
>fl_set_key_vlan is changed to accomodate this.
>
></description>
>
>Thanks,
>Boris.
>
>> >vlans in addition to the vlan ethertype. Outer tag vlan filters (e.g.
>> >vlan_prio) require the number of vlan tags be greater than 0. Inner
>> >filters (e.g. cvlan_prio) require the number of vlan tags be greater
>> >than 1.
>> >
>> >Number of vlans filter may cause ethertype to be set to 0. Check this in
>> >fl_set_key_vlan.
>> >


