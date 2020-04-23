Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606141B533F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgDWDyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWDyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:54:41 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2704FC03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:41 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id u12so4320401uau.10
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKQdMrV6LGvjxwtwpOmQRcKySkh+OYzxhvUmUyKUxIw=;
        b=U1nLle41lQwUEC7DovRis/hdXobM/P9whPp2SzVr84QYQntn2+Ggwvj2sVVWwEhUbl
         p2lj/q3MdqBkE44pA35X32IaK15zNxYCeiYp/iw+qVy6da1UX0PxneHBER1n2L6x+Mpa
         sUyExx4T2HJP1b151oDes469VdjObKApZv9nWMs6n+2nDxVPBuchco7fuskh3VtoiMXy
         szEAiNSUIB3PdKXBwbkocJIi52ugBvgEF1U4eeZyXKf3j/QWRMyjPFImH+HLjlgN29Xe
         LtXrpD/DYgjBAFtuQxL8cJG3GFDyhVHPfD2P7J/TWDQD+L1dnbMLJoqR8xLmEeZRQDFs
         sC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKQdMrV6LGvjxwtwpOmQRcKySkh+OYzxhvUmUyKUxIw=;
        b=Q7CgtBkRgSSHEI2Bc3t1bdSnhLyco6Ispi90+ZiNRFBjvW2lghfXWhbkm4VE932tVi
         ygDs7NgGv22xUvV9E/SSPSmKzZt4iBEjOUgJT0Hcvona+ZgHj3JbAL+p5CnZ0tYwldkx
         mgcv34Ir5m0oQrbeCeuxhU/GRECLLzgYfvJhfBwy+qAh13i4y9fX2jKxfpprtFwES/Jw
         rRmrCbngYTqkQ6+hMd+QZCFo7lyAj938MBcMRu/E++dJjj4ar55IljgN1+JEL09trJz5
         FRiucIjMakgltfX5O1ikzz5MCu07pDMDARMw7LCEf9zlLJjwItbfV0fyK+UWR9ja+/sO
         IBqw==
X-Gm-Message-State: AGi0PuaaiMHHAeruXICFDLw7s+/RD+UF8B/Va/a9X0HWRR5IXi1Ooxxx
        mzCMmxjX2zq40SuQ7Ich/DpJX32uTP6vA7q/dRo=
X-Google-Smtp-Source: APiQypItLEuiIpsbT7YvlDNzmngfR7mFH3VwEjFwWEYh4PaH9TnajdSP+leoHOIkpkgW3MH8JHRWyjPQ9zLvo2NFP6M=
X-Received: by 2002:a05:6102:2418:: with SMTP id j24mr1500483vsi.47.1587614080409;
 Wed, 22 Apr 2020 20:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com> <1587575340-6790-3-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587575340-6790-3-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 22 Apr 2020 20:54:29 -0700
Message-ID: <CAOrHB_DVb1wDqQxsqpn_QojQG7QiO+zAakS6Sqbkpa8Vz7DO0g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/5] net: openvswitch: set max limitation to meters
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
> Don't allow user to create meter unlimitedly, which may cause
> to consume a large amount of kernel memory. The max number
> supported is decided by physical memory and 20K meters as default.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/meter.c | 57 +++++++++++++++++++++++++++++++++--------
>  net/openvswitch/meter.h |  2 ++
>  2 files changed, 49 insertions(+), 10 deletions(-)
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
