Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49AA55BF2F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfGAPMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:12:44 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39502 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGAPMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:12:44 -0400
Received: by mail-yb1-f194.google.com with SMTP id u9so90088ybu.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WxcZv0DapxbLUTnkApDLiXz5c52jc+Kiux2mB44Onac=;
        b=ZAaLDw++9tkpSw30AdjLs4v/c3tSi0J6czrErFWKtT3ymi6pNEfi9YIw1zm6x+a//H
         0BGE/H0/94luzVFX0Pk6jDxN5EwGNYYpfOJd/wsXlWYHKMZj040P9775bausjnOhNSho
         N9mofnZ5SsvpcYwUh9tUbGDFe3YwVlLUdGkvTz32eSZNLfNJiz0Vw8V4eekGZI29oGHU
         zBKKuK1+H/akuwjlVhqfE9HiyhzBI1FQffzITDsrU3DKwfrdGmI+mcknlBuadbjqHJvf
         XIrorgGWra3GKL0uQVMj4EMNhokU3iBGWjZbw2HIZuHCA3Of0wNnvISZYWE39/v1NKDH
         XmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WxcZv0DapxbLUTnkApDLiXz5c52jc+Kiux2mB44Onac=;
        b=ol2PYo8u2zpglIK+YQWxUdQ6shTW0NPi7qmxaG5k+eUH/++j91/hSrsjAOu2lXNb8H
         GMp/MOucD/mP5runhdqeU0w7LibTHl/hJS4MSLM95zb3TjYLCnEENoXtBdHKvY7TttEi
         Fy2esI37hHI4C0Ms2FY8eebABff3JPzAuRF4HkiuPWE/E82+X8PWJMPvWj6grHe+z+XX
         /esRebOyUOSasch6q6fQuezewTOEFeu4M/Z6hX0uAQtk0XLaqm/3/dmyWdgrD6UBGe8u
         4bdDCDX3YaaKqre35LoGqsfDcl2QUN68nna+Ojg+AmP378hXBtiWntXtshRbR2SEOwo5
         Jl1Q==
X-Gm-Message-State: APjAAAVQh6JwPQLSaSHl+IEgiUikMStfFLx3TWXy/3V3rwN2JXoJDYbp
        16NUFUiOBUSicYHKBQ/vJEqvDYHG
X-Google-Smtp-Source: APXvYqz/BGkt3ErSLiYD2mjBBf00xjHw8haFKw2WpRwzVz3kU0DInY2qk83hlnuC2GOFNRR/weGGYQ==
X-Received: by 2002:a25:aaea:: with SMTP id t97mr3930982ybi.126.1561993962664;
        Mon, 01 Jul 2019 08:12:42 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id w17sm2648107yww.82.2019.07.01.08.12.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 08:12:41 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id j133so72593ybj.12
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:12:40 -0700 (PDT)
X-Received: by 2002:a25:99c4:: with SMTP id q4mr16401842ybo.390.1561993960574;
 Mon, 01 Jul 2019 08:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190701100327.6425-1-antoine.tenart@bootlin.com> <20190701100327.6425-9-antoine.tenart@bootlin.com>
In-Reply-To: <20190701100327.6425-9-antoine.tenart@bootlin.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Jul 2019 11:12:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSecj3FYGd5xnybgNFH7ndceLu9Orsa9O4RFp0U5bpNy7w@mail.gmail.com>
Message-ID: <CA+FuTSecj3FYGd5xnybgNFH7ndceLu9Orsa9O4RFp0U5bpNy7w@mail.gmail.com>
Subject: Re: [PATCH net-next 8/8] net: mscc: PTP Hardware Clock (PHC) support
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     David Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 6:05 AM Antoine Tenart
<antoine.tenart@bootlin.com> wrote:
>
> This patch adds support for PTP Hardware Clock (PHC) to the Ocelot
> switch for both PTP 1-step and 2-step modes.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

>  void ocelot_deinit(struct ocelot *ocelot)
>  {
> +       struct ocelot_port *port;
> +       struct ocelot_skb *entry;
> +       struct list_head *pos;
> +       int i;
> +
>         destroy_workqueue(ocelot->stats_queue);
>         mutex_destroy(&ocelot->stats_lock);
>         ocelot_ace_deinit();
> +
> +       for (i = 0; i < ocelot->num_phys_ports; i++) {
> +               port = ocelot->ports[i];
> +
> +               list_for_each(pos, &port->skbs) {
> +                       entry = list_entry(pos, struct ocelot_skb, head);
> +
> +                       list_del(pos);

list_for_each_safe

> +                       kfree(entry);
> +               }
> +       }
>  }
>  EXPORT_SYMBOL(ocelot_deinit);
