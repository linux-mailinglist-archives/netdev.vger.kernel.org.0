Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8943F5217
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 22:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhHWU33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 16:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhHWU32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 16:29:28 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9571C061575;
        Mon, 23 Aug 2021 13:28:45 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f15so8239012ybg.3;
        Mon, 23 Aug 2021 13:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iHUFFdYsb/5FEEi+ueN+k5tBOVMtuTo2uZhx4OT0c4A=;
        b=AoKScfuYp/YPx5H4hGFKd/D+n3q8HkqbcwYlv3ESQ/FwgRjJjzl3nY0MxOBc2Vx+oo
         Sjj2ivgqgrJskVl/1Pc1YHIaCzNgG0N7JTaOAQ7wiSnk/ZRbUdT1VmNAMlaZ57UsBN/w
         BlZJ3Z9sEcBaQ4laz681SkwPz+ePIXCRZgwwh1oQ+ASUrXAy+vrJhXvF41oGsqec2Mqy
         yYidM+8OVRiaZqmUWxzwO5LRZxVXlzCeqIP/FDA1NK89Ni3CTvSMKwUlyYgJMuKVVKTl
         ngHle7TiRHVvgdDdce8D2CRx6iVPYbb4guNQvkExCDXq04NZtORvPr017E1wxeDIgYv+
         u7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iHUFFdYsb/5FEEi+ueN+k5tBOVMtuTo2uZhx4OT0c4A=;
        b=Q5y6JrEqLlRXREUI9KFsvSG85Cfch7kxRoM/03dprfu+K3cgN2pVFBuJD3BGRLX9XS
         ScwQoSbKR7tXRJQj+YXZdIL+g4DCaFw8lcl8LED8zXW1plhfmcNY85qj0Xk2Z5//Pihz
         ryn4j59X4aDePV3ciz+S5Do3UiCQpK+8rYwMHgckJuVK5+OrtkI8Uc54jTflzqMELvox
         5Nx/AzUWR024I4WDqq1kH3fVb649K70y/GwalZBYUIX5Vrli/ds7rNqV6XXh3346ddrk
         ZnPeQ+zZb5nta0nrUEiTmoVad9FVBSDAMakOqIlFUQtdnUVJCrOhQdql6vK3LMj0Gvg6
         LZUw==
X-Gm-Message-State: AOAM530GxmF3D34BAuR22jT7j4W/6oPZtQOATMrEszbYjHWzUThaCw8T
        IBCqjcEjTcNP/49tXbNrpUjeAyxduQacBuwB800=
X-Google-Smtp-Source: ABdhPJwz+OBv2tJhikyv4aLKzXABU2diHct/gnDXSNpSAVhHHsoabfdb3e2k4j0JHsKJuYaVfg899zY/RGJMyF9tsKY=
X-Received: by 2002:a25:f310:: with SMTP id c16mr43477241ybs.464.1629750524959;
 Mon, 23 Aug 2021 13:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAKXUXMzdGdyQg9CXJ2AZStrBk3J10r5r=gyiAuU4WimnoQNyvA@mail.gmail.com>
 <20210823191033.GA23869@breakpoint.cc>
In-Reply-To: <20210823191033.GA23869@breakpoint.cc>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 23 Aug 2021 22:28:45 +0200
Message-ID: <CAKXUXMwZo+HixV+zYWSNvTX0yJNXaFrxCF9hOJ-77upP8qKS0g@mail.gmail.com>
Subject: Re: Suspicious pattern for use of function xt_register_template()
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 9:10 PM Florian Westphal <fw@strlen.de> wrote:
>
> Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> > Dear Florian, dear netfilter maintainers,
> >
> > Commit fdacd57c79b ("netfilter: x_tables: never register tables by
> > default") on linux-next
> > introduces the function xt_register_template() and in all cases but
> > one, the calls to that function are followed by:
> >
> >     if (ret < 0)
> >         return ret;
> >
> > All these checks were also added with the commit above.
> >
> > In the one case, for iptable_mangle_init() in
> > ./net/ipv4/netfilter/iptable_mangle.c, this pattern was not followed.
>
> Thats a bug, the error test is missing.

I send out a patch addressing the issue, please pick it:

https://lore.kernel.org/lkml/20210823202729.2009-1-lukas.bulwahn@gmail.com/

Thanks,

Lukas
