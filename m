Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE336253DAB
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgH0GXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgH0GXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:23:46 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BEAC06125E;
        Wed, 26 Aug 2020 23:23:46 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id f24so3852014edw.10;
        Wed, 26 Aug 2020 23:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zWlNNLcebc5+UDnlwc66ao5mF5z9QibVWSnplcPmXs=;
        b=IXXgjsgW0GMVWya7DBLaF21KfvO3EMysGfU6BSrKcTom85rkgWY2rRZygdk3/wF8Rg
         bbCjDkIsHEEwXiKBKZO3BDHCPI11l8rpJr88H8UZRq9xE6H1t8zcJ8dXFkhFCgTELuAG
         aF1fgkOtIa88AShMeEZ5ifluHtj/RlFDSvJAZpLuK1Kvjgj10i72Ff4ozn2hYP32q+VN
         jg64PhVTq53pnurJBaHHBG93lP9sqjC5g/5gZTQlVKMEabX5lLzlB3Sv7kwai7F7H4fR
         yBTbTsJ8suxI5vJz3emnJa5Uibqp97gJ8L5I8K8ZLLVbskdRqX7SEaEUtxu3LuMPtUxc
         /3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zWlNNLcebc5+UDnlwc66ao5mF5z9QibVWSnplcPmXs=;
        b=lFDR36F2tFOHbUmPmhzMx5jSvxFanOshJN4LqN8DkZGOmALTh4K4uYdNJsQWYs3Vck
         KuVFb62TneNj+ZEZ7Z2Tim6nV6SCpa2fQD1hz9i7ZclGWFqql+J+d4GugWlgmvzoR/Vi
         6OfgkV1ju7XR5S9D8guOG/6zCgNqoiM/pOx8+wINXcVEKOM51Qlk2e+AFdTyYCMJUNJu
         A+osZ5VDgyOf/xzfl3ELi44C2fKKuUcWXy2IM1bfDC/swI0UURoCaIPgsewdhMv+Ni5l
         lv21Jp6qMlzmaULSL69IRnfihjVnCmhvEgGpLEiv7FBCYliBdR8HYD7Xz13PGgpynxB4
         5ZyA==
X-Gm-Message-State: AOAM532ohRSlx9hdxxDKkLSYsVNlyl2+ZE48MSeZIM3y6g5JeYMEalZQ
        EvoSuUVPwjUiqGzkBctQhXTx5eYuHVQu+MIesY4=
X-Google-Smtp-Source: ABdhPJzGyoszCyB1gP7s9vg+kvlr7AQo49xluw5D8n9lmc5iQ3GKoMjOhpZO/cbm7xAU5c8+0f1zDgQ3Da/SQKbb/jw=
X-Received: by 2002:a05:6402:3da:: with SMTP id t26mr13402854edw.213.1598509424857;
 Wed, 26 Aug 2020 23:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200825052532.15301-1-xiangxia.m.yue@gmail.com> <20200826103137.GC3356257@kroah.com>
In-Reply-To: <20200826103137.GC3356257@kroah.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 27 Aug 2020 14:21:19 +0800
Message-ID: <CAMDZJNWWXm_9VtCEJZJ_OWQbbeu_yJhdyf8-0iibTe9aqJ4eXw@mail.gmail.com>
Subject: Re: [PATCH net backport 5.6.14-5.8.3 v1] net: openvswitch: introduce
 common code for flushing flows
To:     Greg KH <greg@kroah.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 6:31 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Aug 25, 2020 at 01:25:32PM +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > [ Upstream commit 77b981c82c1df7c7ad32a046f17f007450b46954 ]
>
> That is not what this commit is :(
>
> Please fix up and resend with the correct commit.
Sorry for that. v2 is sent, please review.
http://patchwork.ozlabs.org/project/netdev/patch/20200827061952.5789-1-xiangxia.m.yue@gmail.com/
> thanks,
>
> greg k-h



-- 
Best regards, Tonghao
