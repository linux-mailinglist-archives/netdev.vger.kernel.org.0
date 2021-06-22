Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858723B05F4
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhFVNlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhFVNll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:41:41 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DDFC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:39:25 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q192so9862696pfc.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TAuRlgd+oUb0GuHaqkgWXIzhNuWNehxV0KJB5l+70dc=;
        b=qkK1zp3ZybZAIiTIc4dnMQpdnSZxZ3vErnqMTns65mnSlH9bi+ImbM96g3R8hRKO8A
         pJYPmxFAL3N+oDQKWZx/f80YN289i/gx5rjFjwDLnF/vaN0B+OF/23hLqTJsN57i6ipd
         Y/IHe7el6rvxtH3GU0ibI0IJJVeX/outCxyJbF8U0p3z/YaS8n5xzi8BpjcJqfvw2t6y
         OBAP/tAF8j6YeHK/4Io70n8Wh3DYP4DpF5v3BbyPIYB7TKe+X47BiapQNe3gYXLB5Zb8
         tj3UITn++cvWzP9qntxiNH3Km1Rkx4coAfVLxMdD8QJE0Z4Z7I6EpfattuvJRN8+0hN/
         8+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TAuRlgd+oUb0GuHaqkgWXIzhNuWNehxV0KJB5l+70dc=;
        b=I4I8DcZJuZJe7TwSvS6HLBdBqENiLcKcqBd40A2q9/l98OA0YKO5FMU7ySYj58OZUW
         7pK3gTpgcFfpQ9/0VOiCbCecAVek7jiMlARXbN3l7LANhB+sU6O2zhPD4iI/4QHM4eTq
         mU108pi6r1jd1slIGDOuD8WjO+ZlEIBWIZyv0zxN/iMGWf1To0qp45OEa/pKWFgP6puZ
         dlZMwnoXRzfvviUvKaT5YU+c6eGrJAgKspv9k+3zyxIJIe6oz+7EPtbDgsJBDXZ0NoMR
         HONXIEeL+4mftHczkAWyDssnJiGb8/0ZLjgTgCUlS60PC9amEzgdIqa39OeGlTjgdQnO
         /nWA==
X-Gm-Message-State: AOAM531H8rDlMOLDz7WnAokaX7sDytLWEG5x5abp16CRA90pvXH/oNPz
        VY8f6q0E3chZzHfmk32hamPVwOIgluM3e1mE7P50lQ==
X-Google-Smtp-Source: ABdhPJxYwh00YX+wQWAG3TbJQWlrfK8/otsl070sxS2mZusGD0MwU7cqpDVXnQJ3vbWx80WZJvmNnCG+v6xlN3i8OH4=
X-Received: by 2002:a62:d447:0:b029:291:19f7:ddcd with SMTP id
 u7-20020a62d4470000b029029119f7ddcdmr3771036pfl.54.1624369165261; Tue, 22 Jun
 2021 06:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com> <20210621225100.21005-5-ryazanov.s.a@gmail.com>
In-Reply-To: <20210621225100.21005-5-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 22 Jun 2021 15:48:18 +0200
Message-ID: <CAMZdPi-r2fgi0BeVxaf0U+DtwC0ACUy_-8vZpuPfGS05t_x8cw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 04/10] wwan: core: multiple netdevs deletion support
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 at 00:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Use unregister_netdevice_queue() instead of simple
> unregister_netdevice() if the WWAN netdev ops does not provide a dellink
> callback. This will help to accelerate deletion of multiple netdevs.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
