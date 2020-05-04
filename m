Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923041C485C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgEDUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDUeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:34:15 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B51AC061A0E;
        Mon,  4 May 2020 13:34:15 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t12so14782124edw.3;
        Mon, 04 May 2020 13:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ujQBkedTruUaYli8xYvaDmOGg+LHDXWsK2ccHcdSVw=;
        b=IBszTMXczFe5F/fu85oU0ycVzvAlEnxq50EH4Wp9Euc4Zb2L47c3tvalIDRU0jiNDu
         h3+ksOL0GZW95hQlGBKTs4mmKe8KVvzVkN4qoCy+A1i12umkFk0Vglp/SWNg7ZtS0faU
         coEoWU7Q05dsezdat1dFMLP0m8gEuo1o+hBg1rvFITg3ruBTu7HYQGpVyqUXU4OgNQBk
         PZZyCrgkWpM/uWM7CpKZgtiEl2Ek1j1jAsi5sk/8d2KTQ4YOBuTNw5B/0wEOLwMnRWne
         hadnqjW3MocrscbVh4ak9VJ/R9HBqFAJuMubsBnwv6R3NtgMfx2V06D4aWnwmJJeounJ
         SBfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ujQBkedTruUaYli8xYvaDmOGg+LHDXWsK2ccHcdSVw=;
        b=Fb6tr2Xm8h64VpWNMY/6c209JufZkQkiu43tEiY+1XX3CroLZm4hWylSute/MoVoDU
         t5IcecbKPCrhWU6NLbbmBmtkdkbpKxhtcsb805CqTUgP1RDwv0OjOLrtixj+R9hswOpV
         go4ArFB1mkVVWax1PSk7EuYCU5BsHTymZN1jw/d9nDDjmEwhp0MDM7RdGk4TLBlAwT0E
         u58Xau1LXEAwRHHaJkcrk+aISFov9Bu/QSeAT17XrIa3gsu7Nekjf9XP8xGyiRKugf/Y
         CgL70I6P0JxZhBB5QC69DDPpCqOlUMjmWN8ebs3gMCK0i0QxrmGTAu4g95jBpYrL71Dc
         M7Sg==
X-Gm-Message-State: AGi0PuY5LapGbwxNEtGAOJhyzf5j7+K3PaF6Es3wmH/eRHhlydQzpi4x
        aD3HDQLOSjYONQttUTl8iVcKwoU62WztA5evM5k=
X-Google-Smtp-Source: APiQypLadytmeo0878qVxF3SemwWssYsZnGHJqE8PKI3DwBvWZ6o/+mKKJCpD4dpd6TwjjYR5cZ31Ob2gF6K41EofYk=
X-Received: by 2002:a50:a2e5:: with SMTP id 92mr16631358edm.139.1588624453705;
 Mon, 04 May 2020 13:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200504201806.27192-1-f.fainelli@gmail.com>
In-Reply-To: <20200504201806.27192-1-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 23:34:02 +0300
Message-ID: <CA+h21ho50twA=D=kZYxVuE=C6gf=8JeXmTEHhV30p_30oQZjjA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: Do not leave DSA master with NULL netdev_ops
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, allen.pais@oracle.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, 4 May 2020 at 23:19, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> When ndo_get_phys_port_name() for the CPU port was added we introduced
> an early check for when the DSA master network device in
> dsa_master_ndo_setup() already implements ndo_get_phys_port_name(). When
> we perform the teardown operation in dsa_master_ndo_teardown() we would
> not be checking that cpu_dp->orig_ndo_ops was successfully allocated and
> non-NULL initialized.
>
> With network device drivers such as virtio_net, this leads to a NPD as
> soon as the DSA switch hanging off of it gets torn down because we are
> now assigning the virtio_net device's netdev_ops a NULL pointer.
>
> Fixes: da7b9e9b00d4 ("net: dsa: Add ndo_get_phys_port_name() for CPU port")
> Reported-by: Allen Pais <allen.pais@oracle.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

The fix makes complete sense.
But on another note, if we don't overlay an ndo_get_phys_port_name if
the master already has one, doesn't that render the entire mechanism
of having a reliable way for user space to determine the CPU port
number pointless?

>  net/dsa/master.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/dsa/master.c b/net/dsa/master.c
> index b5c535af63a3..a621367c6e8c 100644
> --- a/net/dsa/master.c
> +++ b/net/dsa/master.c
> @@ -289,7 +289,8 @@ static void dsa_master_ndo_teardown(struct net_device *dev)
>  {
>         struct dsa_port *cpu_dp = dev->dsa_ptr;
>
> -       dev->netdev_ops = cpu_dp->orig_ndo_ops;
> +       if (cpu_dp->orig_ndo_ops)
> +               dev->netdev_ops = cpu_dp->orig_ndo_ops;
>         cpu_dp->orig_ndo_ops = NULL;
>  }
>
> --
> 2.20.1
>

Regards,
-Vladimir
