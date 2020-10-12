Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7D828AE44
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 08:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgJLGlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 02:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgJLGlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 02:41:04 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3465C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 23:41:03 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a5so15799170ljj.11
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 23:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6CWc5hTXjCf+VxrBjupME5sKSzAv2k0Mojh/jAZ4YRc=;
        b=DfMvyYG9l1FdNSGtLn+/WRhHBRp5NSDJvepsqtZIIw4e+dgqOzFaKZDZ6srjQh8imH
         uYRv1QyvTSPW+lXl7bgmsXS+Fg0CY9MRVEzTS4Ebe6o8Y1V8F0npRivV5Po1ccDdjIGK
         HU0MbKhXz06w8Upro68VBNec91vQHe19+POr8PXWhGNvp5Fw8+/Q3hCanSxgN/Qxfh67
         xkyF2HYnNrmEz+kgA/EKUlLN98KfRXpn22sYzqbv0uMZBPs8kAJyxbA3jY+BHbPFeU/r
         9c49HJayxOajJMt0UObmWMJNhaTecdM3jjUt9UAixI1+y9LZIDpMenizdSBuxHcATBcT
         U7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6CWc5hTXjCf+VxrBjupME5sKSzAv2k0Mojh/jAZ4YRc=;
        b=JNyXRJ8254wexjrYhOo3ro2fpob6wWn2vYg/vVGbqYBTot7QuNBiA2T2G6Pf2IAnLB
         vJmd6ExCVy6nuQl5gzoVnfYctnQFp0bWoIKSCheRC5coireqXfKHLfhNjCjORqeSWXX3
         wIF2oCKLPBsuk99gbLwXXMO4UNUInouPXpEShzmCXwIZ22ZZIUPvJAUFmExrFiwW8ooJ
         nuiPTsdYmUa1SxzLDEYQ2XWgagFoR/ZUEbJ9OqjfWFIOBQ+LJYiL7bOEK6nniq6OAkWP
         5zz+rRLN239eFUVpBAxgea110jSvync3kgbRag1YMkkWigXQQcL4UpYadmshWlREcIbU
         jlTw==
X-Gm-Message-State: AOAM5315AACulgJ/EHGEB8kBXgRy1v836+s3HSxl9nYJuX+N4IXFLMab
        kVh7V01YCEydpajDC/Dh5F1l+vP3+Jf8zISVzfhvLY4M4LI=
X-Google-Smtp-Source: ABdhPJyMbmaieanUH7BpioGmtJDRLzPVfL0xDS0a5sbGyqribBZPMhDdL3QCU7Dw/uWPF/DxBylv5mKXMM2TB/8LpOg=
X-Received: by 2002:a2e:b0fc:: with SMTP id h28mr5951399ljl.226.1602484861982;
 Sun, 11 Oct 2020 23:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20201008184526.3196768-1-jonathan.lemon@gmail.com> <20201011113529.23a26766@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011113529.23a26766@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Date:   Mon, 12 Oct 2020 09:40:51 +0300
Message-ID: <CALkJObfWR-7igG5JOwx42AQHPD6MA69+Gi_uaWgJ4AbzUZ=G_g@mail.gmail.com>
Subject: Re: [PATCH net-next] mlx4: handle non-napi callers to napi_poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        saeedm@nvidia.com, tariqt@nvidia.com, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 at 05:47, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 8 Oct 2020 11:45:26 -0700 Jonathan Lemon wrote:
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > netcons calls napi_poll with a budget of 0 to transmit packets.
> > Handle this by:
> >  - skipping RX processing
> >  - do not try to recycle TX packets to the RX cache
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> Tariq, Saeed - how does this look to you?

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq
