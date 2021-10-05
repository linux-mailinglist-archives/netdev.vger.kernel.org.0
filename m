Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C86422F8B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhJESCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:02:18 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41807 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232869AbhJESCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:02:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A3B1358104F;
        Tue,  5 Oct 2021 14:00:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 05 Oct 2021 14:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=W
        wKIRauzG1K4f0r8zZg//BwjfXC6szb332atZehFcLQ=; b=e6VyM8dEA0Erxneif
        N5qK5rrQX2KKZVfeTVq9oUiaAi6Vq54vS3s/1DRr6x+2bTMzl+hl/c7saD+A0jTb
        FRdw0zk+DqoqihB31dgqIAuvGLcBkScbpW9UfvwvjztfsuLiKK2I5OtBXXkhUs0Z
        kljGJt6UggnnkqNJ4qeoGy3vGwRkdJ22RZ8NjlsZ6KfDL0Sjn9IqpbE024NqH2Y0
        2MsD7XkjZZjyiyF83LkUW0+eBbLhmukQuOszNlkLGA6DOVabgj/CzvAw96NB7HlV
        CYHh8WNw9CYSDegKM5IaSTGqOmtn0IDwLt7mHpmsTLtcdgsJL2QbSAm/LlV4NEN2
        kTTVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=WwKIRauzG1K4f0r8zZg//BwjfXC6szb332atZehFc
        LQ=; b=INLddzxTszqRjVJl3vlqiQAtAw7J6f1lPj/WMlaWB7X9f7rfALNQcGIRL
        VzQSoXQ+GUGvUsDB77olL85yG6xILuFz7poZIj4DVz3HGw5ZzdYB1OCAnlR28UHl
        YXbtSvM+Luo7gHXln8Ut5UFf50fwe5NPzIb+LaK93iKd+Mjzxi3EB9CsfWGofu5Z
        77WHGPYj5/xOp1pgjcLp8ppXvo99ZeGzdLh+2ccFw+xeRKHiV/frNkoh+s1gBkgv
        OOW3BMdU3ZZdGPjRtVwym52DMvbtBw1NuZloFBU7aTP9HXK/13LNOUhFSiDgOoHG
        lCgwygcjgRLuyR2rTGhMILxjmf8pQ==
X-ME-Sender: <xms:upJcYdS5XXFAuAEuIv0l4DxX-gzqLjSnosZy8UJcpO9y1JSSwsFAvQ>
    <xme:upJcYWyzQukYzShHGDf1hm-xH0lLCByMWmm-HKxamgSbxZxwSkUjwy5I1ObsKDSp2
    mBJLHM-US-Xvq29gzI>
X-ME-Received: <xmr:upJcYS3FiUXt_c_UJkEbivMSdNucDy23kSBdWqv92dEer2jZt3Pguq69FIH0Beo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelgedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgr
    gihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqne
    cuggftrfgrthhtvghrnhepheeiuddvvefhkeejfedttdekieethfdukedvieeuueelgfel
    ieejgeehvdekudelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:upJcYVDOLnPJYH2BYn_ZJchzJOR94JXiMHuX4HPAAnz_6KOW7qkJXA>
    <xmx:upJcYWh8TebLJ9BDcpVMtZJNAeaXi2z0TfDiXVtTXxkOQvtRmGGGLA>
    <xmx:upJcYZoEig34LFdh0WUKRd2NE1nDFY9gekBwtr4-rilZB2Id0e-dZA>
    <xmx:upJcYaxpTMPv2ePBP4GKVEIt4WrFlLJwZWqkqBy9glCUHHsudhbrVg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Oct 2021 14:00:24 -0400 (EDT)
Message-ID: <e9e1c9e4-abc1-5fd9-637a-8a7205bbf4c6@flygoat.com>
Date:   Tue, 5 Oct 2021 19:00:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 5/7] mips: bpf: Add JIT workarounds for CPU errata
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, paulburton@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, chenhuacai@kernel.org,
        yangtiezhu@loongson.cn, tony.ambardar@gmail.com,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211005165408.2305108-1-johan.almbladh@anyfinetworks.com>
 <20211005165408.2305108-6-johan.almbladh@anyfinetworks.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <20211005165408.2305108-6-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/10/5 17:54, Johan Almbladh 写道:
> This patch adds workarounds for the following CPU errata to the MIPS
> eBPF JIT, if enabled in the kernel configuration.
>
>    - R10000 ll/sc weak ordering
>    - Loongson-3 ll/sc weak ordering
>    - Loongson-2F jump hang
>
> The Loongson-2F nop errata is implemented in uasm, which the JIT uses,
> so no additional mitigations are needed for that.
>
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

Thanks!

- Jiaxun
> ---
>   
