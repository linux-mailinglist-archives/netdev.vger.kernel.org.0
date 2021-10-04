Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68F4420A9B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhJDMIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbhJDMIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 08:08:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4552AC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 05:06:16 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j4so9463017plx.4
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 05:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=WcogweAVLTrIN04rrhEeTekXTpfk+1n7tDhYxqZpBuA=;
        b=mMLpMzzogxwRDIg/wN7qg34fV9mBis7EQLWTl6Gzml4R3nNYBF1ZTVw5hLCvUac/Yb
         q0Ofz5Zu7V9Yh39LuasvwKJZhwYTO4lCDYoEOsnSJkWHbHuzS/5k9BRVNb+CSqLVdYU7
         FSPGzGTQOYvuloxeIgSKZJ9/XF+8whbW3OCgtpt7g+NjsRPM3Fmd7Ewud232klZ9bLsY
         ySJKkvbbbH94zZyXJsHbNreftfqvW+ilbBr49VbPueqy8q9ysp2cE1heI8hrI4SbO/o8
         LH6U5x7Xtzv5WbRJe2uhNiDIDYNBjeBFx5FuO5ZzSHvZLEf0G5C+SWiOCo+ic3D6dqks
         zbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=WcogweAVLTrIN04rrhEeTekXTpfk+1n7tDhYxqZpBuA=;
        b=IHYYARszsxoyuPP7i5DhbDyc869xKNXKDxLvrm+/dpvdpNPM+KcIFGkwrGWp8HX1qX
         kfM2Vuafn4bFiKHWvd9chjliQHXsJrn4aIYKdySIIomuNLZaz1l1zy7bN/h4xSZ/+tOm
         UrWyrEdsvjRPasAKnBkMzI5CLKMDfrgTbDPMZ3chKOh555rXXV7NUy4pz2AvOdZdv0ya
         rpyORSuef/16HaX1uc0n3xgqk1L+W4n31vCnrVlOQdKyKQblgZBIie4w5vvwDGElImWC
         UuWVZ0J+cghoBx4sN9WDBhkL0OnrupwTkFrfya2SBxAsikNarjNZVNxcxmbKzxRoVD6O
         MJbw==
X-Gm-Message-State: AOAM531D/NGHW1EQ+j14inNObabctJcqDMDgpzHz8x/Q9GNYTIJnFMxh
        AdJQMDcLjyN+T8dBz6pkZcA=
X-Google-Smtp-Source: ABdhPJz1oc5M5VRmTqleIcETJMQ8el0V/OzP/JOb2W60UjMw+YIKbDmOtWgIU5o4Jh3PWjR168vOsw==
X-Received: by 2002:a17:90a:ab90:: with SMTP id n16mr29728436pjq.157.1633349175589;
        Mon, 04 Oct 2021 05:06:15 -0700 (PDT)
Received: from localhost (122x211x248x161.ap122.ftth.ucom.ne.jp. [122.211.248.161])
        by smtp.gmail.com with ESMTPSA id fh3sm15469299pjb.8.2021.10.04.05.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 05:06:14 -0700 (PDT)
From:   Punit Agrawal <punitagrawal@gmail.com>
To:     Andreas Rammhold <andreas@rammhold.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based
 devices
References: <20210929135049.3426058-1-punitagrawal@gmail.com>
        <12744188.XEzkDOsqEc@diego>
        <20211001160238.4335a83d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211002213303.bofdao6ar7wvodka@wrt>
        <20211002172056.76c6c2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211003004103.6jdl2v6udxgl5ivx@wrt>
Date:   Mon, 04 Oct 2021 21:06:12 +0900
In-Reply-To: <20211003004103.6jdl2v6udxgl5ivx@wrt> (Andreas Rammhold's message
        of "Sun, 3 Oct 2021 02:41:03 +0200")
Message-ID: <87h7dx2dvv.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andreas Rammhold <andreas@rammhold.de> writes:

> On 17:20 02.10.21, Jakub Kicinski wrote:
>> On Sat, 2 Oct 2021 23:33:03 +0200 Andreas Rammhold wrote:
>> > On 16:02 01.10.21, Jakub Kicinski wrote:
>> > > On Wed, 29 Sep 2021 23:02:35 +0200 Heiko St=C3=BCbner wrote:=20=20
>> > > > On a rk3399-puma which has the described issue,
>> > > > Tested-by: Heiko Stuebner <heiko@sntech.de>=20=20
>> > >=20
>> > > Applied, thanks!=20=20
>> >=20
>> > This also fixed the issue on a RockPi4.
>> >=20
>> > Will any of you submit this to the stable kernels (as this broke within
>> > 3.13 for me) or shall I do that?
>>=20
>> I won't. The patch should be in Linus's tree in around 1 week - at which
>> point anyone can request the backport.
>>=20
>> That said, as you probably know, 4.4 is the oldest active stable branch,
>> the ship has sailed for anything 3.x.
>
> I am sorry. I meant 5.13.

AFAICT, 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
pm_runtime_enable warnings") is not in 5.13 stable.

Either you're not using the stable kernel or there's another issue
breaking things on the RockPi4.
