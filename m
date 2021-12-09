Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AC746E830
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhLIMOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhLIMOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:14:44 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C990C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 04:11:11 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id w23so10330846uao.5
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 04:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9b5xBisuK4x3KA4EUoNHvHf5Gu6yWcexSQe2ySnZ6qU=;
        b=PpRsZRE4BxbIei8JmVsVsgBe1gE21qg28U2ZOt5KBpybCMuLJWSQy+uYvg8WCanP9A
         jGUF0isDGYhH/GwPgwYaCq/L3EefdxYBwhsLksPcpwbxKrelub2zgO0wDtIBnGGuZEBc
         jycNvAC4N0sUCDWbQPu6o1Ced8Nmxu7gKY6geTZWel++ObVgvvxAp5w9/30eGE5iKE3q
         QiMrAaeqiC3fFPd0u3zrYvj9MYtBgGoVLpj2wMi+OSICiqQH6qwzHIOsetK3fko1ef7p
         LTIdvESCorQN3FqnBDJmOIlNtjhMbDaCxcv58SmlZSpCBQtn6eOgnVivRvXwFS0NSqCC
         pOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9b5xBisuK4x3KA4EUoNHvHf5Gu6yWcexSQe2ySnZ6qU=;
        b=i0D7raOviTYYe/ISR9+80bd/6YB8mtEhu6tq6kvs2SPY4DED6snUGN6Uj3SDlLJRxB
         YqauNd/5uLmXqrhh2MsWWq6Y52cTU8E4AD/bGvD8w8BXod4e9Jf6gNkj/KkUiH0L1+F7
         YGMjETCEJNf7LbiN5yF0igwZxeTTFDFAF4YPWvA1VnxMHGwzye6Rzp+GLK/+X4ndyUdY
         3ftNXoc/fax9lKZIZxcTTBXB3qhBb+q7xgejkQQYbb5K403XSBP5caIC4ejIJiH0p0Hi
         D4sye+WJ4NxisE5uOqZDYwhyKoB0y7A3gedZLcWDGKep/+bNp+5MYnSwKRIQbhVA8Cyw
         h04Q==
X-Gm-Message-State: AOAM533w5XeYqBtUwdbDhwv90uVKjPos720uJjJ2LFezNiGs5exvwEK1
        eJZaeAGh2uDQGN+0LbXUgDg=
X-Google-Smtp-Source: ABdhPJxoytovpnMGYn3NcRzx3BO0F5ghQ5n+T1xJ7XIOrOtJsLe/Hy2vcZuy20SgypQpn9dqwbHIMA==
X-Received: by 2002:a05:6102:2274:: with SMTP id v20mr7126646vsd.40.1639051870769;
        Thu, 09 Dec 2021 04:11:10 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:c8c6:42ae:ac00:c4d1:ee21])
        by smtp.gmail.com with ESMTPSA id p46sm3762899uad.16.2021.12.09.04.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 04:11:10 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 0F27AECD22; Thu,  9 Dec 2021 09:11:08 -0300 (-03)
Date:   Thu, 9 Dec 2021 09:11:07 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net v2 0/3] net/sched: Fix ct zone matching for invalid
 conntrack state
Message-ID: <YbHyW501AWOUZn7c@t14s.localdomain>
References: <20211209075734.10199-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209075734.10199-1-paulb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 09:57:31AM +0200, Paul Blakey wrote:
> Changelog:
> 	1->2:
> 	  Cover letter wording
> 	  Added blamed CCs

Thanks.

> 
> Paul Blakey (3):
>   net/sched: Extend qdisc control block with tc control block
>   net/sched: flow_dissector: Fix matching on zone id for invalid conns
>   net: openvswitch: Fix matching zone id for invalid conns arriving from tc

I keep getting surprised by how much metadata we have on CT other than
skb->_nfct. :-)

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
