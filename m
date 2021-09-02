Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395953FE974
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 08:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbhIBGuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 02:50:03 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54529 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239077AbhIBGt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 02:49:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 82F4E580CA8;
        Thu,  2 Sep 2021 02:48:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 02 Sep 2021 02:48:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wLdsoF
        jidL1GAMNupKB6KhdOpkiskgoBwwDwzSeYQJg=; b=X5a10OTpqNQL2LtwJEYgun
        hRNRyZeZ0dvKiM9QNZHSPBOOHGM4X+YdeimS+wIRuxJOSYGfL7xj3Laj4CtaUQqk
        k0oMoH/2QhK+x/UQm1Gk4+6SQYbLbR1/WiHxkQ5T0OuiFddooGqB9JAFnoqassrx
        hEEFSQVWSSCkOrAg0w2PCwGO227gKnZx7dB3frRYf7zOa1oSrhrklPFBdwixKFD3
        rns3/cwAlnqDwqnPlxWqkr/L5OEze2Qvy32Xt3pLqyGx8snvrOpqWwKBEK1qwVw7
        UrWZkbFwfWqB5l2zOfcCoFwOiRKxXZjFabPj3dXU4OH7Mh6YxjnaSE0SaHKknh/Q
        ==
X-ME-Sender: <xms:2HMwYXZ0KBuL5nWEv0k41eEr3UhoxKjvAYEPV9rEOENUc8Hr7NnaJQ>
    <xme:2HMwYWa2meGQoXxJoHKYDWPflH-dyF1T5CZYdsB7OLPI-wqz5_F4W9WyD3megonzQ
    gok1b6pJLkBXMo>
X-ME-Received: <xmr:2HMwYZ-lurm86Md3Ht_7DEnfwHJAr0jWSfnTLI_FNPjdmgjBrMggfU8PH0y-Rb-zxr4M3atFtv41innkF73fYzaVtcX2iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvgedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2HMwYdrKvJrArq93dFKGlBQwEjgDkuqSR-8lHOh8os7NOFmXF4aU1Q>
    <xmx:2HMwYSr_3ckpcQFTWLD4rOu4QOqX2G17MyNke0wKqR2HqFWQ5Xo-YA>
    <xmx:2HMwYTT9Y446dxssUWUxI6C85XmXco1EqXhhtBBToU6idfD-9Gc1pA>
    <xmx:2XMwYfivyuycs8WOM08O9ovi4BdFRmNkeMmrDxYP5h_OLZf2Cs0PJg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Sep 2021 02:48:55 -0400 (EDT)
Date:   Thu, 2 Sep 2021 09:48:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        tom Herbert <tom@sipanda.io>,
        Felipe Magno de Almeida <felipe@expertise.dev>,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
Message-ID: <YTBz0zitSUrd0Qd1@shredder>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <b05f2736-fa76-4071-3d52-92ac765ca405@mojatatu.com>
 <20210831120440.GA4641@noodle>
 <b400f8c6-8bd8-2617-0a4f-7c707809da7d@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b400f8c6-8bd8-2617-0a4f-7c707809da7d@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 09:18:16AM -0400, Jamal Hadi Salim wrote:
> You have _not_ been unlucky - it is a design issue with flow dissector
> and the wrapping around flower. Just waiting to happen for more
> other use cases..

I agree. I think the fundamental problem is that flower does not set
'FLOW_DISSECTOR_F_STOP_AT_ENCAP' and simply lets the flow dissector
parse as deep as possible. For example, 'dst_ip' will match on the
inner most destination IP which is not intuitive and probably different
than what most hardware implementations do.

This behavior is also very error prone because it means that if the
kernel learns to dissect a new tunnel protocol, filters can be suddenly
broken (match on outer field now matches on inner field).

I don't think that changing the default behavior is a solution as it can
break user space. Maybe adding a 'stop_encap' flag to flower that user
space will have to set?
