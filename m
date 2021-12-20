Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE44C47A81C
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhLTK7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:59:39 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37201 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229766AbhLTK7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 05:59:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6BD435806B0;
        Mon, 20 Dec 2021 05:59:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 Dec 2021 05:59:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ZmOBdzc5KRY0yb6PF129oWRTs4g
        SGAWR2I8msz7i93s=; b=MSBvzVlQ2DOGpUNDbRq6TkOaiDbnOfj0iRpTi+bXrN/
        lq/XBZ4nhbr0UrBaOXTDwu0dVMq92HIjoIZzGjXdoYyV/kw2/Zg0UcHMTCHwxxj6
        yhPG9dW7AODlbQqzVG5T/zqTK0xQ77+BhPq1bbpGSgdwn2yZs9l9RWEeSWnp2ojN
        IDEoBKg7NBkITsdDmhscAmuOyATsCdpfYN3Bw4b6SsAEfuCbivS286IjRKNJc9Pq
        OjA/RK7gEFOIb3NUCwfLjgiKi028o8a0IImM+NAdvH3LcvopHLNFkeIlyV7i3gFz
        IJ8zVeyZaF9XPoYDue8icl2zJSNlvr568ePFoGbeKKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZmOBdz
        c5KRY0yb6PF129oWRTs4gSGAWR2I8msz7i93s=; b=n69vDfmztBUE6+EiH/CRpa
        F5A4Xy1MtFrftd2hORn5pM/MIJhqL/M85wz7tIDSW9wKJ2D0i63EJIv13jWMX0NR
        R1xlK6Q2c1YQUxNs9sTuDmo8z+Gyz5sW4PPqcVpExt9d8xzDb7mRzyLTg/tCIhNU
        58IhEdMU+e9SGCXYfXVjw2OJAwS+ZW9wE71UeHKP7Z2265K28J1sHobC+bmMuB1J
        8q80F2hsrtdbSizZSgtvI2k9OoOiE/7Cd++5I2z2v6uedQX2GTtXXW1XGyfn13Pf
        vyZ2EOxZULqLj74F8bmXd3K6JLnyIxwsg59bGc4Z5SqodEmspRnxEJZbX533EBYA
        ==
X-ME-Sender: <xms:GWLAYcofNXoLjYKFElsgwmNasPLfLJL7yNeGPsuDh2aC0EwhlzGm8A>
    <xme:GWLAYSohXIVt6VREATy4BN9vZNqe-j2KfhxdkJIdiqfVB6hLDJuy9eeX-Ogr7m1xM
    mBFpZNxcFj-2A>
X-ME-Received: <xmr:GWLAYRMzHoR1nXOyoahqEYkOVxgWnaXAd11gUmHuxWKvm1cV742ePLX622tm0bL-hktukTS66gZBVY8-IYoNMmvXSVnpKYPi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtvddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:GWLAYT49JjfvdmIGaLIcT5-qHjRE6EfmcmcH6zHalkpRA87qSi4WiQ>
    <xmx:GWLAYb6LuUvzZlzhTjjijU-3XZ-rKLjQTazrPIRl2Uv0QmEGwzyhfQ>
    <xmx:GWLAYTjQmwnWChH06Hs6taD9V1dASEmnmkBmKf1Clog6tNAk39W72g>
    <xmx:GmLAYeJ8a8fACbvHaFpncbIAzOfQaCGbBGbVfpSJ9dGAyg1HSmtcBw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Dec 2021 05:59:36 -0500 (EST)
Date:   Mon, 20 Dec 2021 11:59:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, clang-built-linux@googlegroups.com,
        ulli.kroll@googlemail.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, amitkarwar@gmail.com,
        nishants@marvell.com, gbhat@marvell.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 4.19 6/6] Input: touchscreen - avoid bitwise vs logical
 OR warning
Message-ID: <YcBiFomrxSw1eEUB@kroah.com>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
 <20211217144119.2538175-7-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217144119.2538175-7-anders.roxell@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 03:41:19PM +0100, Anders Roxell wrote:
> From: Nathan Chancellor <nathan@kernel.org>
> 
> commit a02dcde595f7cbd240ccd64de96034ad91cffc40 upstream.
> 
> A new warning in clang points out a few places in this driver where a
> bitwise OR is being used with boolean types:
> 
> drivers/input/touchscreen.c:81:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
>         data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-x",
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This use of a bitwise OR is intentional, as bitwise operations do not
> short circuit, which allows all the calls to touchscreen_get_prop_u32()
> to happen so that the last parameter is initialized while coalescing the
> results of the calls to make a decision after they are all evaluated.
> 
> To make this clearer to the compiler, use the '|=' operator to assign
> the result of each touchscreen_get_prop_u32() call to data_present,
> which keeps the meaning of the code the same but makes it obvious that
> every one of these calls is expected to happen.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://lore.kernel.org/r/20211014205757.3474635-1-nathan@kernel.org
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  drivers/input/touchscreen/of_touchscreen.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Also needed in 5.10.y and 5.4.y.

Please be more careful next time.
