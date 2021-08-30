Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C94C3FB2CA
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbhH3JBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhH3JA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:00:59 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D4C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:00:06 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso14115297wmg.4
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qtEvUTNfuqxKvzoy7huhuazVgCyZeX0UrhoXtZliCrQ=;
        b=hfVLS/dggpogV1E/bgJqfhpCjHwOUP+WKlN4DP96Xd4FGEd1VEB1K1hNC68ouVDbHW
         BGT3H8EwGZyD6G4dg1dlF/wfeKAzUeungv76DyEbwtgjCGBLy0jYGyEvjLYy5wJDMFyy
         ixkaMQC6OQOwlpu3dmLOYEZwB2PUW0T7u6VUD1zKcsjG/cphK4urOHXBGvs50OvosITe
         vgfmUQ3tCUIBuNn0qODJGXo1a1jUIU4Y4aqPJjaxgH0W3a5HpYGMc+oPaxQiUzWhuKma
         FSOmNzyK4CR+Zo7biDSeIWQfNAdiHJhN7DJ+x3MQmNVlN2mIxBmLRy9syYNsp+tk9Uys
         otBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qtEvUTNfuqxKvzoy7huhuazVgCyZeX0UrhoXtZliCrQ=;
        b=U3rv1iUFq7YHSPhuE0joTfb6eL0lzTynPJQX9prCaJDHju7bAMeKD3QKc6VHOv4Cgd
         yFqRlgLZqKlaT2vGWUlH9B0s2MMLBUZwvr/IsqV68kRuSjq07McnsFhBthHKpCbgvFJq
         DxMpVJXdz7zXii+z3th9BbeNtT0PwOSxOFCCtBlMdr9FOj/39mrqhsl148XDbcqNb1v+
         5PfkvQDC+CkwRbFD2AyJ+zS5CnP8vgZqABNKSsOWXBMhVMVLQUwrBdcTpHZaijt9f+h2
         n6Oh/NORcwAI6N+/5qhfuw2zSV9P7BVRzjBhG4eAZ7tD4UtUCzKglBv/3yGXLB9uFcAm
         gdGA==
X-Gm-Message-State: AOAM530ac3JPr7Yp3W9ZDHbrdRY3EVb2E8Umdqc6zuF+SPZlj277YjiX
        06CQFOydbqhvmEfvBFP2DeA=
X-Google-Smtp-Source: ABdhPJxW9Yk8N90ndd216Y07C4/xfp0OFTgDsVfkyVXThQ56Y6TG7FZdmEbv5v7X0Va99EqDoC4kRQ==
X-Received: by 2002:a1c:1d84:: with SMTP id d126mr20987898wmd.160.1630314004789;
        Mon, 30 Aug 2021 02:00:04 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id y24sm10776276wma.9.2021.08.30.02.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 02:00:04 -0700 (PDT)
Date:   Mon, 30 Aug 2021 12:00:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
Message-ID: <20210830090003.h4hxnb5icwynh7wk@skbuf>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris,

On Mon, Aug 30, 2021 at 11:08:00AM +0300, Boris Sukholitko wrote:
> The following flower filter fails to match packets:
>
> tc filter add dev eth0 ingress protocol 0x8864 flower \
>     action simple sdata hi64
>
> The protocol 0x8864 (ETH_P_PPP_SES) is a tunnel protocol. As such, it is
> being dissected by __skb_flow_dissect and it's internal protocol is
> being set as key->basic.n_proto. IOW, the existence of ETH_P_PPP_SES
> tunnel is transparent to the callers of __skb_flow_dissect.
>
> OTOH, in the filters above, cls_flower configures its key->basic.n_proto
> to the ETH_P_PPP_SES value configured by the user. Matching on this key
> fails because of __skb_flow_dissect "transparency" mentioned above.
>
> Therefore there is no way currently to match on such packets using
> flower.
>
> To fix the issue add new orig_ethtype key to the flower along with the
> necessary changes to the flow dissector etc.
>
> To filter the ETH_P_PPP_SES packets the command becomes:
>
> tc filter add dev eth0 ingress flower orig_ethtype 0x8864 \
>     action simple sdata hi64
>
> Corresponding iproute2 patch follows.
>
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> ---

It is very good that you've followed up this discussion with a patch:
https://patchwork.kernel.org/project/netdevbpf/patch/20210617161435.8853-1-vadym.kochan@plvision.eu/

I don't seem to see, however, in that discussion, what was the reasoning
that led to the introduction of a new TCA_FLOWER_KEY_ORIG_ETH_TYPE as
opposed to using TCA_FLOWER_KEY_ORIG_ETH_TYPE?

Can you explain in English what is the objective meaning of
TCA_FLOWER_KEY_ORIG_ETH_TYPE, other than "what I need to solve my problem"?
Maybe an entry in the man page section in your iproute2 patch?

How will the VLAN case be dealt with? What is the current status quo on
vlan_ethtype, will a tc-flower key of "vlan_ethtype $((ETH_P_PPP_SES))"
match a VLAN-tagged PPP session packet or not, will the flow dissector
still drill deep inside the packet? I guess this is the reason why you
introduced another variant of the ETH_TYPE netlink attribute, to be
symmetric with what could be done for VLAN? But I don't see VLAN changes?
