Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA49542CF4D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhJMXwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhJMXwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 19:52:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBAAC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 16:50:28 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so16759966edv.12
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 16:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=510ObgM18jX/lFq7VSHe55hUODoT8WQOT31yT/EoTnc=;
        b=YnVB+VQsi9O5VsxkVkm0OTCUU3REoqic6XtUf+dalgNwszRL9fySufRPs8eTHS0LYK
         vOM0t5ouHbe9Pt/R/eohRSnfGXYC7l/VhLcubg9YIDouhj5wjtaWz3lTfD7dJFsGG6wL
         UZvOA726POHBpitWCqianq/lzHFUWWYOKNXpofmbf1Ipbu4Gco5/GAE1DkS/4XJLV3fu
         vrzzjz4EQHocBTFTVtoJGaj7Z0GAba2TZJ4wKmrVhpsBjd7bplAHBHlGY9sowWdq8NM2
         mKyomjPmL/9aJYyQRhWOMWvQHqNSJlbBL/bqAbrBG6yjwjOmmHBYeM64W/QTJZ+9yZgr
         Q/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=510ObgM18jX/lFq7VSHe55hUODoT8WQOT31yT/EoTnc=;
        b=JJqhJAfn3FencbSe4zLNorx+sw5bw9mdhPFFeu/MkPlJsRZFbXaCiq+wdb6J+N4Vab
         HISy+ZE9/EkQOuLAEPJQmTWhIm/HixcKX9U29kE5BTV8lRRZrz/1h8ewUh1LeuaWzZX2
         ahwD+WdI2WoJZrqJUTFGtOHFJflJqLoPx25pXFF+O+jNeRHRtl4VRGeAwDYVh0YWPIlZ
         8BnSpdfGiOEDRjxTFc5uhsbjVE1cfJV8D2DZJNQcaluXem4MJWeegGu2ccHoCI7SU0So
         J/RbxQWC1CtVkd7x/vq4wVzTYVH54XQQzelN/Euqh/EbxVkN8vWBoCYs4Hnxn/yLggDP
         2fvA==
X-Gm-Message-State: AOAM533vZirw6R8Yv6kTuzjxtIQb7T2R8On2E60jrrbEYIGORLEsxKYZ
        ntjfE/IyFQACQOBSCbFLJQLy0u3nAHQzkN1WVZ3gug==
X-Google-Smtp-Source: ABdhPJyli8i5itKCqT3i1bM4X1zwNz7i0+Lb1GXlWBFV9LWdkZU7FRdyN1RKStnvPqqCa7eg4Sx07GsZn6MBL2U7444=
X-Received: by 2002:a17:907:6010:: with SMTP id fs16mr2646778ejc.266.1634169026737;
 Wed, 13 Oct 2021 16:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211013204435.322561-1-kuba@kernel.org> <20211013204435.322561-4-kuba@kernel.org>
In-Reply-To: <20211013204435.322561-4-kuba@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 14 Oct 2021 01:50:15 +0200
Message-ID: <CACRpkdbVqFkNNbJ9RUTJioG3F8Hx=ryvM-uVHV0x5KV8yYUHWQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/7] ethernet: make use of eth_hw_addr_random()
 where appropriate
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, chris.snook@gmail.com,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>, subashab@codeaurora.org,
        stranche@codeaurora.org, Michael Walle <michael@walle.cc>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 10:44 PM Jakub Kicinski <kuba@kernel.org> wrote:

> Number of drivers use eth_random_addr(netdev->dev_addr)
> thus writing to netdev->dev_addr directly, and not setting
> the address type. Switch them to eth_hw_addr_random().
>
>   @@
>   expression netdev;
>   @@
>   - eth_random_addr(netdev->dev_addr);
>   + eth_hw_addr_random(netdev);
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Oh this is better.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
