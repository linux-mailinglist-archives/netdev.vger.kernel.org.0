Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9FA1FA9D4
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFPHRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgFPHRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:17:12 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBEFC05BD43;
        Tue, 16 Jun 2020 00:17:12 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id a10so6568248uan.8;
        Tue, 16 Jun 2020 00:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9LYtGDwP5PdSta9rN7AHT/0i8mo67vKpZcwwXBQEekc=;
        b=s6q4GSmmT/fgvqjShwMjZBqADAVAr8ri9DjZc1CuRZG3RsZyXDySUL6BCQ//HlRvTG
         IWtUnd23kiKVhKGd7udNxaWI3lRFILnJRU710fqGQiYpmTZYyLzDRCwQ4W2PEa+qpm9M
         2mPYAm63G2r3Gnw+9MjaIea6jsg+H4JeTRtmWo/J3uTZQmc3NLHKJh4uc8m7n1Qcb/QE
         xX148ZwzaT/q3S7StdSmKdwUJZO8ggBq+YZrQ+F1IBlTnDYencE0ibZZ4OYNbwQ0h/Hq
         ajPwDVzOyudAGmISEWGI1PWNhTkgl7VMzTGpEQg/X3eJTcrFE8v1DWMlb+ug7O4rXsTu
         bLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9LYtGDwP5PdSta9rN7AHT/0i8mo67vKpZcwwXBQEekc=;
        b=Il5JdXJXWjLBxWTYDQ9jlq58NR4Gj0mSIcq0EyMAd76YXOA3yc4yYiznUxJKVkFGDc
         s5XiDqbmhfSl8Lrzc3R+oeoEjVKAeq1GEev4CQCbcyYB9zZ/63KQgD+bFmFSq4rwfaQo
         2xs/Mtu1pDQyhI+zSKBWYcs2yukI3EQo8SvXZVcKxkx94pJBH0QNqZsDF46Y7iMv+EXe
         GyfqRyP+jC2KmfBG7qsh684Y8awICG7H3ky5RRChweCsYBzeaTZGA+/DLSTF+GbNynhr
         DxqRKrZkc102UM+1OnK9qQNTaJuPhtwhovG/H37EUY3FjQvTKx6sxR/kGEa52eVbek5d
         gq9w==
X-Gm-Message-State: AOAM530ZSd7jyUoGgul+zyWua6H2LNFNgxRPmVRxA+Pg9MFiGw/FqRef
        98JyVm1dcW9qiHBaIvEedrjjqRMJ1JChVXJBvlk=
X-Google-Smtp-Source: ABdhPJxDc4ltOFg4e2D9idSg8cYMi8y5aUI/B9xqAR/M9yJuX0M5nyLtPkrhcm1sxd5CV8esSUi0dnYIRD5mhFuNJMQ=
X-Received: by 2002:ab0:b0d:: with SMTP id b13mr828924uak.70.1592291831308;
 Tue, 16 Jun 2020 00:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <1592273581-31338-1-git-send-email-wangxidong_97@163.com>
In-Reply-To: <1592273581-31338-1-git-send-email-wangxidong_97@163.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Tue, 16 Jun 2020 00:17:00 -0700
Message-ID: <CAOrHB_C2o31V1duzEFYAc4cqejR+P9m=7KuW=6trQa=aM8v7yg@mail.gmail.com>
Subject: Re: [PATCH 1/1] openvswitch: fix infoleak in conntrack
To:     Xidong Wang <wangxidong_97@163.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 7:13 PM Xidong Wang <wangxidong_97@163.com> wrote:
>
> From: xidongwang <wangxidong_97@163.com>
>
> The stack object =E2=80=9Czone_limit=E2=80=9D has 3 members. In function
> ovs_ct_limit_get_default_limit(), the member "count" is
> not initialized and sent out via =E2=80=9Cnla_put_nohdr=E2=80=9D.
>
> Signed-off-by: xidongwang <wangxidong_97@163.com>

Looks good.
Acked-by: Pravin B Shelar <pshelar@ovn.org>
