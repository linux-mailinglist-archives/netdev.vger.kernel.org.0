Return-Path: <netdev+bounces-6258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F56C71566E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B53C82810AB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E65111193;
	Tue, 30 May 2023 07:18:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC65107BD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:18:44 +0000 (UTC)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984D21BB;
	Tue, 30 May 2023 00:18:01 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-5659d85876dso53824267b3.2;
        Tue, 30 May 2023 00:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685431080; x=1688023080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pTM2v7KRX1zHBsEZ+vzIIhOYdbFvMTh0/z9L0wDEuQ=;
        b=bGkyEwuD8FGAx0Upgp67WzsWS6HSk/nSYk+eF777nnYwGCmkz+FCb1DLLQ2jNVsDws
         fGnedvkiPc7G39PclJrn1+VPYousQ7fmV6OghwxgywBK+1sGkuGDUWcBElruiqK0D2Qf
         feP5TjRW5Qxv5CirO6/XqEYqeksi6VFZMulZfpN54qacpAO3Dnn7NLIIEitNNhTTrHtm
         YDQFqPr+UBMhsuw7hWijtcWRKOa0WeMv94muVgQu2LpynbyUvgzjMK2giSRRXoq3zXA8
         Qwy8uTJBtm+0bJddhx3VSfdQk9PXnFD/LpcYKI4DDCfEDUgCMDfyVMefQzZyOCsVEJ3i
         67gQ==
X-Gm-Message-State: AC+VfDxBKvuMXb0k/JkAXrFSUITHuWkPFb0VL6RbvROI41Mw4PtIXvDY
	w60bpVHw9NoSiBVFiSWep8m8Lkp1EOFqvA==
X-Google-Smtp-Source: ACHHUZ4VdLg0MXlLEpiTLoBYTzInqgtowJUNGj30nze/rqgvyW3oZF/WnKLL+J/a5dJOptJzsPJ/nw==
X-Received: by 2002:a81:8a85:0:b0:561:b5cc:e110 with SMTP id a127-20020a818a85000000b00561b5cce110mr1321720ywg.6.1685431080092;
        Tue, 30 May 2023 00:18:00 -0700 (PDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id c1-20020a0dc101000000b005461671a79csm4232815ywd.138.2023.05.30.00.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 00:17:59 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-565cdb77b01so36767497b3.0;
        Tue, 30 May 2023 00:17:59 -0700 (PDT)
X-Received: by 2002:a0d:d70d:0:b0:561:5d6a:9150 with SMTP id
 z13-20020a0dd70d000000b005615d6a9150mr1205800ywd.50.1685431079170; Tue, 30
 May 2023 00:17:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com> <20230529080840.1156458-3-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230529080840.1156458-3-yoshihiro.shimoda.uh@renesas.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 30 May 2023 09:17:46 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV2nRAnW+bMBtO45=VMjCuCOVcyizD-OF4HUidCS8dSTw@mail.gmail.com>
Message-ID: <CAMuHMdV2nRAnW+bMBtO45=VMjCuCOVcyizD-OF4HUidCS8dSTw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] net: renesas: rswitch: Rename GWCA related definitions
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, 
	geert+renesas@glider.be, magnus.damm@gmail.com, netdev@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Shimoda-san,

On Mon, May 29, 2023 at 10:08=E2=80=AFAM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> Rename GWCA related definitions to improve readability.
>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/rswitch.h
> +++ b/drivers/net/ethernet/renesas/rswitch.h

> @@ -959,9 +959,9 @@ struct rswitch_gwca {
>         int num_queues;
>         struct rswitch_gwca_queue ts_queue;
>         struct list_head ts_info_list;
> -       DECLARE_BITMAP(used, RSWITCH_MAX_NUM_QUEUES);
> -       u32 tx_irq_bits[RSWITCH_NUM_IRQ_REGS];
> -       u32 rx_irq_bits[RSWITCH_NUM_IRQ_REGS];
> +       DECLARE_BITMAP(used, GWCA_AXI_CHAIN_N);
> +       u32 tx_irq_bits[GWCA_NUM_IRQ_REGS];
> +       u32 rx_irq_bits[GWCA_NUM_IRQ_REGS];

Not directly related to this patch, but is there a specific reason why
tx_irq_bits and rx_irq_bits are arrays instead of bitmaps declared
using DECLARE_BITMAP()?  I think you can simplify the code that accesses
them by using the bitmap APIs.

>         int speed;
>  };

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

