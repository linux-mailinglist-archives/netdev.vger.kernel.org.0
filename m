Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CB148F747
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 15:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiAOOUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 09:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiAOOUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 09:20:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45521C061574
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 06:20:14 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n16-20020a17090a091000b001b46196d572so2944322pjn.5
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 06:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ncd5IZKvHPrrlUNsXIMwKnuqz7gtjvAHZ3BqHWFsgGI=;
        b=ZKMtG2g6ZqDQnOLci87+dJirsvLkyJiJNPqsvE/eHqAEKvqrcf2pU3pLmhyd5DENec
         LIjxASold+k6sF/b8C07/LsOCcb3b1AVmkvQVEoc4FljwSkSN4/iLdIV5GSR4DSDU3E2
         8B8UYT8eYwOrl4nimmcBKp6h8ONFQrp2AykzmFpUJAzQ7RQwin789tojlVvNKkMMNQua
         GYnPlKP3nKzltcZ6E1RMtYBVEGimI38+kNSVMMqYo6RZBGucKjfvD7gtjg8Pcx9n3ZHp
         +Ydd7vrVJ1hplgSYAKTU7PgROGJPruhDkDVGKgsiQpa/qLz0Bs5in5clcKMTbfialtft
         PCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ncd5IZKvHPrrlUNsXIMwKnuqz7gtjvAHZ3BqHWFsgGI=;
        b=pShAgohqG6UrNrpj7DUB9/sInhetP0SCDzpAhYajrM7e4e28WRC5CFoxwTvBapBLqZ
         P63Tlj0zv1gDBR2S4xLQeBkcRlCWfOpPlmRyfWg3e18+NhjNjNSeEs4cN5P01LxUhOsv
         wfs5BWIcW02Bchhy2M+uCTVdC2Ol1cF3vYv95+de724CXsZ7V+vwmaD+ufon2EYPCkpo
         a+IDsxW+jzFi+578U8rzbQsP3dOYO7WLmTo5JM8jkp8XejJni7QSk9fHx5t8o4xoRPjq
         Tn/OfYhcUiC+NUfBe/bNGxIa6Z2B6YOopEvodqFUddfBazf0gFMWB+diqc5Ex5bDwukj
         svgQ==
X-Gm-Message-State: AOAM5306hKVcKDFGb2yNaQY6C/rsl/P9MS8Y51SX2h6iPWCV3af0fQHt
        tXfmLl/HH8r/Go/LqJisgE3ZXhaJ0uTZQnhTDqphBA==
X-Google-Smtp-Source: ABdhPJxVdXHefdKKHBUfz3c7b53Y2bYtVq5wiy1dOUcQNd//Ceu2Oce8OzpZSMNzZaM3yRErwQo3k5XOWhbFZmd2ET0=
X-Received: by 2002:a17:902:e309:b0:14a:3072:8d1d with SMTP id
 q9-20020a170902e30900b0014a30728d1dmr14172928plc.6.1642256413521; Sat, 15 Jan
 2022 06:20:13 -0800 (PST)
MIME-Version: 1.0
References: <20220115023430.4659-1-slark_xiao@163.com>
In-Reply-To: <20220115023430.4659-1-slark_xiao@163.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sat, 15 Jan 2022 15:18:06 +0100
Message-ID: <CAMZdPi8uc+qHJR_OaWu_12oT1VtVE6TY=nAmfSF9h+f9hpXrcQ@mail.gmail.com>
Subject: Re: [PATCH net] net: wwan: Fix MRU mismatch issue which may lead to
 data connection lost
To:     Slark Xiao <slark_xiao@163.com>
Cc:     Shujun Wang <wsj20369@163.com>, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ryazanov.s.a@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le sam. 15 janv. 2022 =C3=A0 03:35, Slark Xiao <slark_xiao@163.com> a =C3=
=A9crit :
>
> In pci_generic.c there is a 'mru_default' in struct mhi_pci_dev_info.
> This value shall be used for whole mhi if it's given a value for a specif=
ic product.
> But in function mhi_net_rx_refill_work(), it's still using hard code valu=
e MHI_DEFAULT_MRU.
> 'mru_default' shall have higher priority than MHI_DEFAULT_MRU.
> And after checking, this change could help fix a data connection lost iss=
ue.
>
> Fixes: 5c2c85315948 ("bus: mhi: pci-generic: configurable network interfa=
ce MRU")
> Signed-off-by: Shujun Wang <wsj20369@163.com>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
