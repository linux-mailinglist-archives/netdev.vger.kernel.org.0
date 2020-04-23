Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60B41B5341
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgDWDy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWDy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:54:58 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76751C03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:58 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id a6so4359939uao.2
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C+Ey5PXULKyuPPi04ax61gE7OxA+VYAa3h5F+jbJSjs=;
        b=X3OlR+qf0Sfvs+s47pm8fxhQxfDVairbG4tmwumLPy16YrcYpJCpnbYTHXl2HYZ22Z
         NU4Ql37Lz8CPL67JxCu7denAatYNSWhNxr9YRkkiod1OjnVnJi2jwiWE0zAwD3ZxHbX/
         T62vrszZg8faCuGsIy/y+B6Okm9TITo2naMCSbdF9M/hLZ4nXxC0ULo0ENaPt1tWw8+R
         g+T+WNenif8dYvX6mg91eBhGooeIdI9j+BGkfGtEBaoonjq4WTpVl3Y4ybR/pO9mk9HW
         EKRkmm+1OaREgwhieafqSusYn1ORjCvvDoMIZ3R0VKpyIGzO/4gDXE0vn89S8qAbfI+h
         P1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C+Ey5PXULKyuPPi04ax61gE7OxA+VYAa3h5F+jbJSjs=;
        b=PUN9eBy0TAJsGFDNFWTQqV5v2xouUbDNysyZ+jmfbw0XNaOj9tMAfoX/tULGyj5RdP
         SOlbW2NXnWqwCPJeBS00qrtAJNdbEilMHMhLM9xVGKVMn/jHPgg6PmAv5n52okKNKJ4m
         DdsxCOv+A4BNie5kOQBqMf9tUqMOjHGky03C1U6w/ShOGUhlxmzMeEY3K3Ko6BjxpYoL
         r5dahvImRRQGmXVrotrnPdQ5oq1e/dkchQMIbM1gP5COiJgQZM/Ky0qeTNji1vymSTOO
         Fz4GBZbvDBU17cUwzAr4UYiix8l2Lb+4iY8zf9VvNynBQU4lMaoAquuTEvH2c4N+p6H9
         JUsw==
X-Gm-Message-State: AGi0PuYPUoYno6gRaGY5zg7flzNiYw2rJ8RfVK+um/YP8I6O1IcXnuMW
        5uFzCUm75btzRLPf/B3hNBv28SWoz2a6CajPoiY=
X-Google-Smtp-Source: APiQypLt8XkLv0ZHi68zI05Kb2+wtvQvUMglsix8FD67YLPBL1LvyNe0i2ccTUZtSYzE6u0840ITS5xMPqRSPFEGKgE=
X-Received: by 2002:ab0:559a:: with SMTP id v26mr1412967uaa.22.1587614097765;
 Wed, 22 Apr 2020 20:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com> <1587575340-6790-5-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587575340-6790-5-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 22 Apr 2020 20:54:47 -0700
Message-ID: <CAOrHB_D8mGAWFp+ifHcJQWPyjfUOcHss5DYaWE5U+J+a_NM3YA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/5] net: openvswitch: make EINVAL return
 value more obvious
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:10 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/meter.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
