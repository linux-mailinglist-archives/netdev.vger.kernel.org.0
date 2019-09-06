Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A724AB0F2
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 05:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392122AbfIFDbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 23:31:38 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44018 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392118AbfIFDbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 23:31:38 -0400
Received: by mail-yb1-f194.google.com with SMTP id o82so1696353ybg.10
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 20:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B+cAS7S6JDVsWh+Fo11sZQw1SyPIFidpqagDA1HwWY0=;
        b=GjjLtJxWA1/3/v9bLgQePrd/ouRrhzQ3EzZcWrD68sTrdsk2GncxiN/ix6IIICsbU9
         AZcMrFi1xdDEfIBH2gGF6uAaC5YiOr5Yi65xu9mlC3EA6x0izJ9wO8AYlqS8g/O1wy93
         /zaw96fgF9Caq6Pg27UjHPSFdau8j/YxaS4g/9Zbupd/MN7s8IoGZGUy5XqgQ/7ur7i9
         z3wq4+0VdAOPlJxGFUnTAbE/Q7Q0Uhdygi+NEnTHTAiBguN4V5ezasDLWtJnWxW1qhYk
         c73Letwg9Tf04VFe+9DRZihtNo/iwky92MDShVLHgpMhGAaZqBUpVCxaQPRujpABir2D
         y2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B+cAS7S6JDVsWh+Fo11sZQw1SyPIFidpqagDA1HwWY0=;
        b=eCfz3au+LGtTCy+h/ZpS7oZ/EDZQbN1TdSuGhgH/SgMvllLeuFUAZPCJ21mXHG029q
         0Ow33iKNih5JJAn/npsTBkKnLyb3uZob515jJPS2Zw4hpQipt0wX0m2hGhFOrkFKOLfF
         IzKk5QvbDWOcAvyD7UQvKIQlxyXiLVkHdeqQSokxxBpqcY5sVkPfXeDqCAVVqrapfmXC
         KA9uopdM8uKeCt/3i1O7/Qp4EXwMPu/4YxwkZeqmT4LwluffoINXQ0/aj3NHtpJLUd5a
         L1QpwB1NLcrXJYLH4fpRBYKWDoSUWfvH4NBRxUjlaTIJKLgAAR5BuLbvtqlOMFH/F+G8
         FeMA==
X-Gm-Message-State: APjAAAXvXkYXwCiHrIwKgcd0b7I3YgF1zJTpbcd/kacEgYJMTDLe7dRh
        KPuhqenuH4HkElaOIzustd5B5DAiWBGfWm+FXkAWgA==
X-Google-Smtp-Source: APXvYqzqwbkH5KijRZU2dqgA+IzF5vVB73pDqqQxSgKEoSRpnW34WQ04NImZG0+JcU6gHNOpf5TUDaXT6xILF5+Ar1I=
X-Received: by 2002:a25:f50c:: with SMTP id a12mr4942528ybe.354.1567740696812;
 Thu, 05 Sep 2019 20:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <565e386f-e72a-73db-1f34-fedb5190658a@gmail.com>
 <20190902162336.240405-1-zenczykowski@gmail.com> <98b8a95f-245a-0bdf-6a4c-c07a372d4d0f@gmail.com>
In-Reply-To: <98b8a95f-245a-0bdf-6a4c-c07a372d4d0f@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 6 Sep 2019 05:31:23 +0200
Message-ID: <CANP3RGcbEP2N-CDQ6N649k0-cV4AhQeWqF-niz7EMPFOFpkU1w@mail.gmail.com>
Subject: Re: [PATCH v2] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Shouldn't it use
>
>         if (!IS_ERR(f6i))
>                 f6i->dst_nocount = true;
>
> ???

Yes, certainly.  I'll send a fix.
