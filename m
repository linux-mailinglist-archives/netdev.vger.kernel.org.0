Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C922A49FE58
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350274AbiA1QuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350263AbiA1QuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:50:05 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D779C061747
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:50:05 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso8625075wmj.0
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gWV/XN5zRAIOOyre4Hd3/1fPFNZKmFqNYxQX4mefTd8=;
        b=iQhCP4QJ3ZIaKczGKn75eQyoFch7y+0jad41X5WbyeWpudEj9Y4ji+bpEJSAHZsBVQ
         lkfzhuiReR3tMm3H/dRE67MlOYNdWanSon6m6voT1a3Hgg/f/hxlTZSovUnOa+iyWQIt
         QMLn3rz20Y4HcJS8PGzj121W4jc6nYF/t7H4GAb/RiWV+y3h2cufBDhmTfNLDxyyKZFs
         TyknngVD3tN/8Veb6D86QBy/t8oYJpadm5mFpGO9UH/9MYvD+E0eggjAPfJlL8O2EtWu
         8KS38Yl6BaEEFQzj8k5Vzr/e4NvKpG4vPxTUZVaLcfX9JydZ0tqb8xTmzTjfhkXyDDD1
         iVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gWV/XN5zRAIOOyre4Hd3/1fPFNZKmFqNYxQX4mefTd8=;
        b=41HBpX3kbcgJVfqUkSFrkDjngsjBFq6+Sp5BRdETkuaSq300Bh44UvJgMTodF6eZVH
         ajETA9iqgIR9ipIMlOb+YaGK+38WTEybUy3yanjQfyk7xVeCYiJ421MMXNO95OzKDpHJ
         zcexuWaFYX3p82bCje2nrDfoHkwT9sDDzpmyT/pJp1h/b5d0iH25pu68S5NAf6uVwH6i
         7GCYwL7mcYqtAPt3F4Nwc4GHi0phwOPvz66Ezxv8MdMAnKGt+6Qx+wJPvLvOmRlyTmSM
         gFH34CYDcjV15oLmPjHAYd+G7b//OzH7q+7C7s/v+g8Yi9yHlkFsnxA2JWmbuigZImXg
         L9kA==
X-Gm-Message-State: AOAM533t9SOaxdsMZ8IUChv5jRyAY4FxUhoWk0fK1O8yMpoFumMHHX12
        EgDtTbvGS5evTRsbZqEvUAPK0Q==
X-Google-Smtp-Source: ABdhPJw6QP3li/jhqP7ZNADp8FrhH03P+aiOFZw5bn2VcoRg+qe/gkT7qFizWbRpefPZjrJT/Pw+8A==
X-Received: by 2002:a05:600c:1da5:: with SMTP id p37mr8171246wms.93.1643388603717;
        Fri, 28 Jan 2022 08:50:03 -0800 (PST)
Received: from google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id a14sm6328156wri.25.2022.01.28.08.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 08:50:03 -0800 (PST)
Date:   Fri, 28 Jan 2022 16:50:01 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH 4/7] mfd: hi6421-spmi-pmic: Use generic_handle_irq_safe().
Message-ID: <YfQeuWk0S4bxPVCg@google.com>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-5-bigeasy@linutronix.de>
 <44b42c37-67a4-1d20-e2ff-563d4f9bfae2@gmail.com>
 <YfPwqfmrWEPm/9K0@google.com>
 <d351e221-ddd4-eb34-5bbe-08314d26a2e0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d351e221-ddd4-eb34-5bbe-08314d26a2e0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022, Sergei Shtylyov wrote:

> On 1/28/22 4:33 PM, Lee Jones wrote:
> 
> >>> generic_handle_irq() is invoked from a regular interrupt service
> >>> routing. This handler will become a forced-threaded handler on
> >>
> >>    s/routing/routine/?
> >>
> >>> PREEMPT_RT and will be invoked with enabled interrupts. The
> >>> generic_handle_irq() must be invoked with disabled interrupts in order
> >>> to avoid deadlocks.
> >>>
> >>> Instead of manually disabling interrupts before invoking use
> >>> generic_handle_irq() which can be invoked with enabled and disabled
> >>> interrupts.
> >>>
> >>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >> [...]
> >>
> >> MBR, Sergey
> > 
> > What does that mean?
> 
>    Ah, you were asking about MBR! My best regards then. :-)

Yes this.  It's okay, Dan was kind enough to enlighten me.

Every day is a school day on the list! :)

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
