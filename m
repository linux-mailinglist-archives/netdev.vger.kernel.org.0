Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01A2682B2B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjAaLKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjAaLKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:10:12 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E35C113E9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:10:10 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so4740649wms.1
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=MA8S/y1Gs1MEQ7N3aRN+Al5XCapmAfGlB4c1wqU7XjM=;
        b=FH1Unjui52IkGTPhUHp5BhDuROTGf59RbUbqmNWz0chvb22Xg8klEm/bOXb9jpHk4Z
         3pkGXLCer5EoKOLjwFN0tfkh4eD+XS1GSbhejlA/rM2HlUlqIge3HcdECKalAdKq6EqS
         aSwpCw93y/OK0ZSnSUjDzLFWg+cTI2YcGXx56J+g3z1wyYdzMaPUu2SONAe+WuR6rjxa
         DICsf2xUoC++LOoDjZwX4OsdocheSi0vFp3HJWBtt3XufCQLz2DKNPQzM5dKT0YthFQ+
         zbaX8HjN1jWP+tJXYb0b3LrNpptrMcrPyoUNtRYOiKC5f5ZZ524Kmlj1Tjt1ViWu0+Iv
         hOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MA8S/y1Gs1MEQ7N3aRN+Al5XCapmAfGlB4c1wqU7XjM=;
        b=625Y/YvtXuUkclVI1AoyEB/U76fu1nwwgpYwFnC0St0L4sX12UOu32+wJvqk+3/vgH
         6iOQF/zBwGeoduChvJqu61WR4wLdc/ADVk83J8ExleIafWiCO+PYS/8N5XhxPc7s8y+2
         vTiKlm/HTA6rEJU26oeaHxhqs4yc+WPaPmwdjp4fxoYnFVzsv03PKujFQPjM71VtEd6p
         FGhYtJz3N6ZQ9Ia4buaSQxd7+U4nEczZuLleDxtWbp60FTxwro3XlcAwMUVLAyRFWnGg
         y0/e6zvBdhPu03e2lVQqzIj6VEOPoL7DMDMLu4T15FPyoE3dxNnwzrAJXqM0R8p3KkBX
         YDLg==
X-Gm-Message-State: AO0yUKVWC+BjtzT8hSsbXwptm3qXFdQAP7KVLTR1vNen1B/KxD9x1r+G
        xpqNUuJcc6FnMTXEptXa8+daSA==
X-Google-Smtp-Source: AK7set/pFaDuIxJKAHREd2WyfYMwlWeiG3tW5Bw04KC3h7MBM3BvQaR9xw+dGlgqTh3NU841lYLFdw==
X-Received: by 2002:a05:600c:1e0d:b0:3dc:3f1b:6757 with SMTP id ay13-20020a05600c1e0d00b003dc3f1b6757mr14844157wmb.15.1675163408692;
        Tue, 31 Jan 2023 03:10:08 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id g10-20020a05600c310a00b003dc4480df80sm11959003wmo.34.2023.01.31.03.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:10:07 -0800 (PST)
References: <20230130231402.471493-1-cphealy@gmail.com>
 <1jbkmf2ewn.fsf@starbuckisacylon.baylibre.com>
 <671d564e-db1c-ed61-3538-97dd1916714d@gmail.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>, cphealy@gmail.com,
        andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
Subject: Re: [PATCH v3] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
Date:   Tue, 31 Jan 2023 11:59:40 +0100
In-reply-to: <671d564e-db1c-ed61-3538-97dd1916714d@gmail.com>
Message-ID: <1j7cx32c4y.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 31 Jan 2023 at 11:38, Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 31.01.2023 11:05, Jerome Brunet wrote:
>> 
>> On Mon 30 Jan 2023 at 15:14, Chris Healy <cphealy@gmail.com> wrote:
>> 
>>> From: Chris Healy <healych@amazon.com>
>>>
>>> The Meson G12A Internal PHY does not support standard IEEE MMD extended
>>> register access, therefore add generic dummy stubs to fail the read and
>>> write MMD calls. This is necessary to prevent the core PHY code from
>>> erroneously believing that EEE is supported by this PHY even though this
>>> PHY does not support EEE, as MMD register access returns all FFFFs.
>> 
>> This is definitely something that should be done, Thx !
>> 
>>>
>>> Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")
>> 
>> This commit does not seems appropriate, especially since only the GXL ops
>> are changed, not the g12a variant.
>> 
> The diff is a little bit misleading. The patch affects the G12A PHY.
>
>> This brings a 2nd point, any reason for not changing the g12 variant ?
>> I'm fairly confident it does support EEE either.
>> 
> Supposedly it's a typo and you mean "doesn't". Neither Chris nor me

Indeed ;)

> have GXL HW and we didn't want to submit a patch just based on speculation.
>

Ah - Ok.
I've tested something similar recently while working on the PHY.
I confirm that both GXL and G12a should stub those calls.

... maybe in separate patches to help stable backports.

Do you want to handle this or should I ?

>>> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> Signed-off-by: Chris Healy <healych@amazon.com>
>>>

Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>

>>> ---
>>>
>>> Changes in v3:
>>> * Add reviewed-by
>>> Change in v2:
>>> * Add fixes tag
>>>
>>>  drivers/net/phy/meson-gxl.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
>>> index c49062ad72c6..5e41658b1e2f 100644
>>> --- a/drivers/net/phy/meson-gxl.c
>>> +++ b/drivers/net/phy/meson-gxl.c
>>> @@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
>>>  		.handle_interrupt = meson_gxl_handle_interrupt,
>>>  		.suspend        = genphy_suspend,
>>>  		.resume         = genphy_resume,
>>> +		.read_mmd	= genphy_read_mmd_unsupported,
>>> +		.write_mmd	= genphy_write_mmd_unsupported,
>>>  	},
>>>  };
>> 

