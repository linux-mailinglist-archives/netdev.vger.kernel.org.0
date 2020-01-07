Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD031328AB
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgAGOSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:18:03 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34015 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgAGOSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 09:18:03 -0500
Received: by mail-ed1-f68.google.com with SMTP id l8so50495004edw.1;
        Tue, 07 Jan 2020 06:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKn214CEjBNG7kjYm64uHpt+0exTR9cqmigKTJuL7sc=;
        b=NBgQGkTjIrxkrvtGKzY+LwM7PoXR1+Z4FDvYRNMxUc9sXB9Qj1PtFZw+XxwrxOlXpE
         auCHUKXNXq8TfPhAIj1rX6Z32EJdyqWEc1OsD9efv7+IYrs6Iq9hzaEm8UKv9ukRa/Fk
         8quiK/UFN9IefKKa61fUJM1Af9WBXrCQm91wSHP27u4TBZ5Jy8pt3+LkEVyUYVxvegHm
         MQgrhLCOxpVY55eslwewDXwWFkE5/5h+iSYkHpRtUnyaV7tVki8ds3JPoZHZMtoB5pVy
         gA1WtwllvYO3V7pA6nqb3xqABEDb+xzXpP2H+LeySncQA4yvZIJEZOThMEEHhzBOHrOv
         Q4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKn214CEjBNG7kjYm64uHpt+0exTR9cqmigKTJuL7sc=;
        b=A6qYUz+T3EScvvyNbWyf2dnCWZabOlmP5M1HOJJTQk0CZca3yMfs/0FdhKCPTOwoxv
         zQVLqUjVOrSjwkgO/oIV2yI2zxYs3adEgkHnRpIvfd2GzE89tPsqGIQ5PJ7nmSFiW9lc
         14P68x3JluvK4+6goqCchnNEP9JdIqa2V3c0KiCe2TGpbW3hfwYsJhM5WHsBddnEzNiI
         Cnb8OnTRxdVuQKF2E9tag0yuQPx4xRyAxaoZbPMeoT8tn8pICYLtVMt27PtO+EpLhqbl
         6rNcqdYT3QlHFMGdQZDGov/nNN24np6aI9cxyLHFoufPxyRI3bERLVF/BfFgxcRIbEnO
         nJlQ==
X-Gm-Message-State: APjAAAUi87wAs25ekmlL5/6FlJNQhba9Rd2KGQNKwtLs7UrJJetczQkr
        R6DDclEiDG2VJo0PDf/uAdTLtDSm40rdf+AGU28=
X-Google-Smtp-Source: APXvYqw/Y9vV9nQJHreGqJzWs/xT2A6EuhpCfFQ9oFLIVY4iT1hA01ZNvlNuSvDCq46b5FrIEMv7tnQ1St495dvKquA=
X-Received: by 2002:a17:906:af6d:: with SMTP id os13mr2503286ejb.86.1578406681044;
 Tue, 07 Jan 2020 06:18:01 -0800 (PST)
MIME-Version: 1.0
References: <20200107141454.44420-1-yuehaibing@huawei.com>
In-Reply-To: <20200107141454.44420-1-yuehaibing@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 7 Jan 2020 16:17:50 +0200
Message-ID: <CA+h21hqejk3kJ1RigKe31ZFo-qvqFYf8eyzV616S3BpkHz7Hvw@mail.gmail.com>
Subject: Re: [PATCH net-next] enetc: Fix inconsistent IS_ERR and PTR_ERR
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jan 2020 at 16:16, YueHaibing <yuehaibing@huawei.com> wrote:
>
> The proper pointer to be passed as argument is hw
> Detected using Coccinelle.
>
> Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks a lot!

>  drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> index 87c0e96..ebc635f 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> @@ -27,7 +27,7 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
>         }
>
>         hw = enetc_hw_alloc(dev, port_regs);
> -       if (IS_ERR(enetc_hw_alloc)) {
> +       if (IS_ERR(hw)) {
>                 err = PTR_ERR(hw);
>                 goto err_hw_alloc;
>         }
> --
> 2.7.4
>
>

-Vladimir
