Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412C747A823
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhLTLCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:02:43 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:57267 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbhLTLCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:02:42 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4186F580726;
        Mon, 20 Dec 2021 06:02:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 20 Dec 2021 06:02:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=SYYa6YsTGSR/I0GH13kqb+HYdm9
        OONiz3cbnv97oGII=; b=pq5JbqII0DG1nlui9KuHHJyFhoHCPhIpvInQXFreib4
        MowLWD0PiKk1vOiclXL9SZwW132/0PB+0CM4QJEDFfZpJNu9pFb966Dduqkj1Gkm
        aK4qAyukFOzaJBLaw4v6jSLBJiub/DzpTX6MCIDdgWKc7FxAY+3I3boq/TwyQvZI
        COvclSMileKI0Lz/6mEELTzxc+nREe6wlgYRvEQvpJ5Mon+vNbeIi/jCvt4XpXDL
        qT3Rghq6mxFyatdquMzqXODoazHkRzc+hxqpGtUg6UIV9BBPtWbwI1YXF0hQqU+Q
        y1Zv3LaBSM+nd4BTeOUAJpAgOdEQoBAh+DtEuuKH8rw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SYYa6Y
        sTGSR/I0GH13kqb+HYdm9OONiz3cbnv97oGII=; b=m1JtNBB9nemQLbkYlGrcxI
        OBaGF0rsA1hASxzSN1V10IFbJv/Dx4RMw+KeMMXdSVasFAgSCz1PJxe75PPDP43t
        KyPqyzQKWDKlWqD6NJAPMrLqhdvHIsEyLYKOITIQ2SAMQmHwC9QTjfoxpIR3pq2z
        a3/jcLMqeX7BtLOT0emtGRZTqXabX45AMhqQfaV6z4v6f22Zyg9oLx4YmFAJXUi3
        a4klRtycrA6E+YxyaCwo+RzuwZiYqzU3EYD8/kpwpyMnea9qz+fLg0VOaWk+IcJH
        94bsDJg4+LUzrGuRCdnTEIDwZqApBixEzz4AcfwEJ9rqT7K6R2+k0swwzT8cuBBA
        ==
X-ME-Sender: <xms:0WLAYcfjuXObVl3M3X7Gh9au2Ss-TnBV8AJOVkZQZa1q3_bMxazcOw>
    <xme:0WLAYePhNB4_KhD9GFLFLLUveoUskTYnk84Qkdmfiwygd6FVWkHYbQiDR_LO9rJvW
    oTUCYVJU6pe_w>
X-ME-Received: <xmr:0WLAYdh3Gm5cMGIH4591Lt2biZZY9wozVVka7QKzx5h6BjuhCilFksci0VQdEV9j15uwJXUnnkijpxGisRDONtxlBCt-R8wi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtvddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:0mLAYR-D9LgAoe7wYKMKaD6mGls2HmgFsVnK5sJG--ENIDPjwN6wHw>
    <xmx:0mLAYYtywWzCE8pXKBJqi_Qu7K6-WXlZJeZgrRztKz4T2OxY6aX2jQ>
    <xmx:0mLAYYFDUb5wznYbnnp2iAL7kdy_cuRf1fmhi3Nt35qpSHBgJQw0mQ>
    <xmx:0mLAYYEBnH74_aiAcNvkSAy5RtvsDJ5hMeZbXAsgKxnUKxwGCFil1A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Dec 2021 06:02:41 -0500 (EST)
Date:   Mon, 20 Dec 2021 12:02:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH 5.15 0/3] m_can_pci bit timings for Elkhart Lake
Message-ID: <YcBiz/hxgxktWb2E@kroah.com>
References: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1639990483.git.matthias.schiffer@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 10:22:14AM +0100, Matthias Schiffer wrote:
> The automated backport of "can: m_can: pci: use custom bit timings for
> Elkhart Lake" failed because I neglected to add Fixes tags to the other
> two patches it depends on.
> 
> Matthias Schiffer (3):
>   Revert "can: m_can: remove support for custom bit timing"
>   can: m_can: make custom bittiming fields const
>   can: m_can: pci: use custom bit timings for Elkhart Lake
> 
>  drivers/net/can/m_can/m_can.c     | 24 ++++++++++++----
>  drivers/net/can/m_can/m_can.h     |  3 ++
>  drivers/net/can/m_can/m_can_pci.c | 48 ++++++++++++++++++++++++++++---
>  3 files changed, 65 insertions(+), 10 deletions(-)
> 
> -- 
> 2.25.1
> 

All now queued up, thanks.

greg k-h
