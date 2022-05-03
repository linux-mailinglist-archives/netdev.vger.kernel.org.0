Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C889051836F
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbiECLr4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 May 2022 07:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbiECLrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:47:55 -0400
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64D31F617;
        Tue,  3 May 2022 04:44:22 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id k25-20020a056830169900b00605f215e55dso8123617otr.13;
        Tue, 03 May 2022 04:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cU3Z6ykdejESNcgy+emYbv3uxVtClhcVte+gZSY0vNY=;
        b=q+mrMdmWF1qiQScO3xKSXJKVWB0Zh+Cm1A4P7nHU3esX5tKqr1wZqn073cdHQepmfu
         lb1HvQMe8ZrekrcLcWIuYzTpJhwSHN+cO7dJCDKGnIl/JwuM9507zYyWTzEHyziii/4A
         HsUPCoD3s+5EyAUrKszKV2h5C/XIiqnLwwNUNnIX5wQtbJ7VtBg+yrL9Mn0eVLi2v4us
         5BAAoBo75ZmrHHlO2hf80LpbUi99cd+xUftIMkdrqxTuetrKxgXnAAs5CCvNCXAX2vD4
         l8vnFa76pE3/Y+ztRy0G8xG4zPXqwPj5yFV1eY4Guw6MSjAbMeFaVoW3WOjQqBNr5d0K
         kVFA==
X-Gm-Message-State: AOAM532IUQWCYvQrudP38wClQ9Wbpz/aromsLlMhpH6WY0rxQ+2ijKDx
        8+HwvMJX72DuB9dR7JM1gl6CsTXoPV0GzQ==
X-Google-Smtp-Source: ABdhPJx9f5FEJqVlsJPj0zsNWKMHxl/aKPrh3i9MhHT6FFHZdudw6RbpQv4Hzan15Xafq4SD0Xy6dw==
X-Received: by 2002:a9d:34b:0:b0:605:f0f1:e28e with SMTP id 69-20020a9d034b000000b00605f0f1e28emr5558412otv.304.1651578262024;
        Tue, 03 May 2022 04:44:22 -0700 (PDT)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id bl23-20020a056808309700b00325f4f40f9esm2033390oib.22.2022.05.03.04.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 04:44:21 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id z5-20020a9d62c5000000b00606041d11f1so5659639otk.2;
        Tue, 03 May 2022 04:44:21 -0700 (PDT)
X-Received: by 2002:a25:6157:0:b0:645:8d0e:f782 with SMTP id
 v84-20020a256157000000b006458d0ef782mr14366337ybb.36.1651577879447; Tue, 03
 May 2022 04:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz> <4d5c53499bafe7717815f948801bd5aedaa05c12.1647904780.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <4d5c53499bafe7717815f948801bd5aedaa05c12.1647904780.git.pisa@cmp.felk.cvut.cz>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 3 May 2022 13:37:46 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXY_sHw4W8_y+r1LMhGM+CF7RQtRFQzEC8wYKYSR98Daw@mail.gmail.com>
Message-ID: <CAMuHMdXY_sHw4W8_y+r1LMhGM+CF7RQtRFQzEC8wYKYSR98Daw@mail.gmail.com>
Subject: Re: [PATCH v8 5/7] can: ctucanfd: CTU CAN FD open-source IP core -
 platform/SoC support.
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

On Tue, Mar 22, 2022 at 1:06 AM Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> Platform bus adaptation for CTU CAN FD open-source IP core.
>
> The core has been tested together with OpenCores SJA1000
> modified to be CAN FD frames tolerant on MicroZed Zynq based
> MZ_APO education kits designed by Petr Porazil from PiKRON.com
> company. FPGA design
>
>   https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top.
>
> The kit description at the Computer Architectures course pages
>
>   https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mz_apo/start .
>
> Kit carrier board and mechanics design source files
>
>   https://gitlab.com/pikron/projects/mz_apo/microzed_apo
>
> The work is documented in Martin Jeřábek's diploma theses
> Open-source and Open-hardware CAN FD Protocol Support
>
>   https://dspace.cvut.cz/handle/10467/80366
> .
>
> Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> Signed-off-by: Martin Jerabek <martin.jerabek01@gmail.com>
> Signed-off-by: Ondrej Ille <ondrej.ille@gmail.com>

Thanks for your patch, which is now commit e8f0c23a2415fa8f ("can:
ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.") in
linux-can-next/master.

> --- /dev/null
> +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c

> +/* Match table for OF platform binding */
> +static const struct of_device_id ctucan_of_match[] = {
> +       { .compatible = "ctu,ctucanfd-2", },

Do you need to match on the above compatible value?
The driver seems to treat the hardware the same, and the DT
bindings state the compatible value below should always be present.

> +       { .compatible = "ctu,ctucanfd", },
> +       { /* end of list */ },
> +};
> +MODULE_DEVICE_TABLE(of, ctucan_of_match);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
