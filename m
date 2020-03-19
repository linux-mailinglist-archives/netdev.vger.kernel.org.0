Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E6618C0BE
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCSTvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:51:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33664 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSTvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:51:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id d22so3012757qtn.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 12:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FQz+fPstj07hGd7KH6Oe3yoW/JL1chHoanegZGBYiIs=;
        b=uM7fXEcbetx0DfhNsaa2w7yrlXUD0T6/PIupc4aAoRa4ByYdSyh+ebk8NJvunZPFeM
         Y+QGs4kYF904sQTlhi8Y/0yrfGgIoTyZyDvleMHx+WIPImB4q4Iu3Sd2/C7Pb2BQU8BL
         JE9xqwqg3UdRYJsu5poc9o6oE4/fznl0evULYbipwNQD1+hHoUXwBdJ9IYZr0ELlPPLt
         Tlor3+sJAggG+QOIYeFJ5tA5Z9UWAPpO5t/ZfnDffwc0psrvWoO5qmFW0JiDQCrivKHB
         qk+iHTyugn+ARegMeRlUGt8M+rH7805jnqAAd+mG15aVzlNN5ayZqMuYA1t4s4+9rqCI
         e0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FQz+fPstj07hGd7KH6Oe3yoW/JL1chHoanegZGBYiIs=;
        b=FVYcS723dfNSp0silWSv59yH0UO2XSmIV9aG0HekzxMCzqdn4hbNnZNUEO9LqFKPND
         rEzdrJuxi8iESLGot5SX+e9/3xsjJ1VdcFFrCW8fCjTWD+eq6ttCy3Va2/E18zAYdoov
         AdH87qlDfwHKXomfzHIFXFuhcX8tETHBglYRR47HGlBvlCrR49uEQ9jAZ6oagJMbYwJV
         IN3Ex/5AaDuztcGEub2C3NrCfv+pmRo9yuHu5E8F5qQsaX9QxbovKyifrkCTFYKf3a5X
         pPO7Lf8UAEkqn5qRJU0EPMJ8jwyuBSkXr/OUMFaa0/Jy4BAJQAV85qo26g+KbGvb1D5l
         WizQ==
X-Gm-Message-State: ANhLgQ1HYfzKj5yjfcW6GnD+sAptczjnFoKMSfgSBF73BBVIyRScDwo9
        2PAGDey/W+lk3LJyJgko4szqdbvKxgVlgnXM8mK8Yw==
X-Google-Smtp-Source: ADFU+vs1ehY3PYXuVZqRk44kx+WAkp/jiYALUDAKWmNvk3yiG8hvk8ttMe4HVP6beLJsTKTXznw8v20+AQlzTpKaGYs=
X-Received: by 2002:ac8:110a:: with SMTP id c10mr4146299qtj.365.1584647493822;
 Thu, 19 Mar 2020 12:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <404ccbc9216441393063948ad762f4ab3339fa44.1584101053.git.petrm@mellanox.com>
In-Reply-To: <404ccbc9216441393063948ad762f4ab3339fa44.1584101053.git.petrm@mellanox.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 19 Mar 2020 12:50:55 -0700
Message-ID: <CALDO+SbODKyvzj7Kyufty_pSE2nH+p+AiG3NuK3g2nyuvw866Q@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] ip: link_gre: Do not send ERSPAN attributes
 to GRE tunnels
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Xin Long <lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 5:06 AM Petr Machata <petrm@mellanox.com> wrote:
>
> In the commit referenced below, ip link started sending ERSPAN-specific
> attributes even for GRE and gretap tunnels. Fix by more carefully
> distinguishing between the GRE/tap and ERSPAN modes. Do not show
> ERSPAN-related help in GRE/tap mode, likewise do not accept ERSPAN
> arguments, or send ERSPAN attributes.
>
> Fixes: 83c543af872e ("erspan: set erspan_ver to 1 by default")
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
LGTM, thanks.

Acked-by: William Tu <u9012063@gmail.com>
