Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B050E24A837
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHSVJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgHSVJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:09:37 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914C2C061757;
        Wed, 19 Aug 2020 14:09:36 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m22so26931265ljj.5;
        Wed, 19 Aug 2020 14:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iTxH8aQ6zdRm7CatyJufQkitwuTyzjTdgxjetIf5JZ8=;
        b=sI/pA/bxWU4QpNbI8BhohFwPtxLNq/X17X+NHN6XjzDv0pq1QIFr74WK24nXvUJB4E
         Oi/CCeVhd3MlnH2xcTSn5DoISr6FL0THs1RYwWKvl/kbJMY0hCRXxsJakAQG/44Fuas9
         r+tXhztbHu745vKRkuSx8ovGtUmkhJ+79Ea1slRc6ySdeAjDwBKLxT8d+Mh70gR08JDn
         nAKduEozJiqyaxuIcg/KeYPY3/AjaxpRDUM2a/xcfnZfX6ID0w1Sum+olnGWx4WdkaVX
         D4BbQGGkjFHnmmoSItz8LmhW529pmRmFmiVF5FtZaYJwkLLnF6XySpSTX2c6/zHNbvFb
         hWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iTxH8aQ6zdRm7CatyJufQkitwuTyzjTdgxjetIf5JZ8=;
        b=cggPFOWlBKXE5m6aQA32riQSAZpni4CzHlUD5gyr2Yg06Xgw+oH9Wm+XK5hiD2LzLi
         RKYxOl5qIX9N0kJXW1QYa2p25q9STsxx5qZZLTnnEP9gnzGPoq9DLk2DhOA5JPQe7dsJ
         sR7h0oN+34DlKio6+2RroYTzCieGFzQqIttffuyTxD+xww5TuJc6bvhnQw/tQrcSd0rp
         /7UPFoGqS5NvDCRPeDer0i/2DuBixKp45AuRks869YCPxp7nIYhZ8M5kQTu1c4ne+pHy
         GhN+4ds2hLeBSee8SKk9vbTaQZjbAnQmtb6JfOBAuRU0fK5cpjyZmfiMFvdWa728nZPC
         oqVQ==
X-Gm-Message-State: AOAM530o6IonKhxtzHc4oD+IFnIXlEt+UXsVjLkHbZN14XljQwPsZbH6
        b4jEsifM7RbB3emhXxgHoZkgFvJd5bDWe/+IE1vnB4uH
X-Google-Smtp-Source: ABdhPJwm28CPyFoUofLweCmXclD88RUEi+py1iz7v9ic57LNXyY5FVMIKRU84Hu4zvVHjdV/OQGSSRxDuTtrq424zzo=
X-Received: by 2002:a2e:a489:: with SMTP id h9mr49271lji.121.1597871375006;
 Wed, 19 Aug 2020 14:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200819010710.3959310-1-zenczykowski@gmail.com>
In-Reply-To: <20200819010710.3959310-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Aug 2020 14:09:23 -0700
Message-ID: <CAADnVQLJBAgb=kg8WigZU5OBoOzvyuDGeT8bFN5j_e0MydfWfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] net-tun: add type safety to tun_xdp_to_ptr()
 and tun_ptr_to_xdp()
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 6:07 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> This reduces likelihood of incorrect use.
>
> Test: builds
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Applied. Thanks
