Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA18456AA8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhKSHMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:12:14 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50657 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232076AbhKSHMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 02:12:12 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A8DA5C0164;
        Fri, 19 Nov 2021 02:09:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Nov 2021 02:09:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=QaZ4kQkBwfl6pmoXTzA36xpXN3r
        RHPjH+yb5eFOnaBg=; b=QZ5evm8dtiVXNdbuGk9932rhY3PzNB0bpS+YAHbnDFd
        RVioXW5W/jiZX92Av3rzcSZQd/S4Bn2XKOSjV/IA+5H+ynCd6pjYktPXtsDoAJbJ
        cMR36n4Zv5h+FFQm5wtAiLXuKlKRpgfehNsiNOMp+Zk8hMtT1USvWfe60WEzHKLB
        IGjaqUfgwjeFbYm7crHFkxlTXW3LK+OyoRoAE8O9rXAdm6onG+yRXlPa6d9hgLRW
        n5y9hSriV1hb9TF3DTFBsd43NmFwD9Qr1qfF/ThtDYnYUlFgshv1aC//tbGBBNRF
        SbH1ZVlqlTTbROYj0AdrslcQE7Yd26ngLumfJLaXJng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QaZ4kQ
        kBwfl6pmoXTzA36xpXN3rRHPjH+yb5eFOnaBg=; b=iQvKEIrYrnYe3RiM2+hh0O
        wz7n1hs4NT9WuxgFpcyKXkrjECiEw5exXaGJU/fdYlVjmJllKnAWksxJARNl3fNR
        BaQ9XixohdyEg+PM0uySwN1yQ6BJfpOTo0PeAPK1pCpe4MQxIYlUzTgnTo5LzZyL
        qoE0gIva67huC7nweiOh+Mjh1L2sDv1KZiTlfNH6naGozlFyObkHzFv6/gZfvzlc
        RaO1S9Nf/Dk4YvBJ8dlwEfEJedHDw9iX3vTXhVp+0+lBZVYKFqBt2u2xqBmwxrAB
        LS9hpc6nKYu8YeWq1DFUEMwZKJGcFoF3hxry1GR7iwaqk9q36t9B28/2AMzVjvYA
        ==
X-ME-Sender: <xms:lk2XYfEFBpHmzw810WH5HcDIFeXVJxeXioZQkgI7DPywTWIFnXaCeQ>
    <xme:lk2XYcUpCelmuj7Evtc9iIjzDrRqeeSrpG6tvG08HbHybIq-rj71YvFaOwKmth1hn
    R-ddUDPh9rkHQ>
X-ME-Received: <xmr:lk2XYRIfasMU_EliYv88rYk7MOJbtfeZnLCjqgcElaLU25eBKQakmXfMNlYZXo60qzWjILHhpxZoV1UjxW-mqtNe9rsy_60m>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeejgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepfdhgrhgvgheskhhrohgrhhdrtghomhdfuceoghhrvghgsehk
    rhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvvefhlefgffeitddtjeeivdeffe
    elheejtdekgfejgeegudfhheeuteetieffheenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lk2XYdHSlBFF5QvcaQG8Txsx6pn9lQTlnNutXQ-PKoPsVSigXvmwyw>
    <xmx:lk2XYVVNtQROyqvJiS-UQzvAEL3XrPI7hLtknzkPPi4Rm11TbPk1lA>
    <xmx:lk2XYYPn7mWvkSl-vI1UQlGHYHXKamRAR5masSMWUEVCwVXsbWBXhw>
    <xmx:lk2XYXLJNJtfCFuYroE-G_WUhMFm1x_E1T6c0PGD2b7PCVkOv273Zg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Nov 2021 02:09:08 -0500 (EST)
Date:   Fri, 19 Nov 2021 08:09:06 +0100
From:   "greg@kroah.com" <greg@kroah.com>
To:     guodaxing <guodaxing@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chenzhe <chenzhe@huawei.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH] net/smc: loop in smc_listen
Message-ID: <YZdNks4CQ7CS8ILg@kroah.com>
References: <aec0a1e1964b4696b8636ce3945e6551@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec0a1e1964b4696b8636ce3945e6551@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:21:16AM +0000, guodaxing wrote:
> The kernel_listen function in smc_listen will fail when all the available

<snip>

You need to resend this without html, as the mailing list rejects html
patches and we can not apply them.

thanks,

greg k-h
