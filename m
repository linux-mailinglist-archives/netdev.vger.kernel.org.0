Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415A4432E99
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhJSGxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:53:02 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46129 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhJSGxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:53:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E917A3200F6F;
        Tue, 19 Oct 2021 02:50:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 19 Oct 2021 02:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=480Xut
        i6WMD7oXbzl7SOf79XKVvGXiS+iqAnhPGVbxw=; b=ViC41NzXT3m4OL0/mMfsDM
        lF6Bthhuh3QBTIsiftzoZsp5KH6Vc+VQivtHD5Ne/PhzMFO2GQop+Aw/llIvco01
        R47K9fZePzmLpklRY2CFOSXDpafAv+nqZWeth5qpXfc/vreL/2bX6RhGVvc0uSfD
        nPa3e/Vb1q3B+TsU5PIf5ytahbGyQazGh7DZr8Hf/u/a13Qm18YFL6T6AjiJMaBd
        m5lu1Kd4ijKPyKBotcNTEns8X7TyiJqRLmroYdRGqmVesEniWM726xDTasrGd/oi
        JvQ7X+udqJVTrsDmhLV0p5DBUbavyEs6q8q3LsFpHjvyrlnMKzYVg4laaWhjGdnw
        ==
X-ME-Sender: <xms:yGpuYexDPGGJl4Y_uVRf0VAk677W725zYTxwEocX2Mwxgj9pbozq8w>
    <xme:yGpuYaQPNRlKZ-HDTo1ozAFG5PszDlLlHW4MY8_DIo548Y7ZKNo6ULLwiZEI_5oRa
    zX-gZOfi6mzUPk>
X-ME-Received: <xmr:yGpuYQVZNQLQy8qCHdsd-AAOgXkAnWV3qp3tctQkR06HlFIP5njsxMZnUDrVLj3H7CVXpb7QcQdMfMTXqpySuJJK0Tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yGpuYUjRMIrRs5fo19Y0b-ifcMzgz_L5yMxMi6nB2MSv5vHwt_F9BA>
    <xmx:yGpuYQCQc01-fSwzYNXcIDJYE0C_b65TzVuBEZ7dLfXfk49hohFIDg>
    <xmx:yGpuYVLseg4aV8KUiH667Han4rrO_CXCUfW04O7CpkOQgKTpwmdVCQ>
    <xmx:yGpuYT-JpC3msax1IgjDFOuDfNCVYxB3AAl771QLyEqex-n1MferwQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 02:50:47 -0400 (EDT)
Date:   Tue, 19 Oct 2021 09:50:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 1/2] net: sched: fix logic error in
 qdisc_run_begin()
Message-ID: <YW5qxB8fovdP0JXh@shredder>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019003402.2110017-2-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 05:34:01PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For non TCQ_F_NOLOCK qdisc, qdisc_run_begin() tries to set
> __QDISC_STATE_RUNNING and should return true if the bit was not set.
> 
> test_and_set_bit() returns old bit value, therefore we need to invert.
> 
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
