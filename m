Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6772D8A4F7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfHLR4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:56:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43852 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHLR4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:56:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id v12so2274606pfn.10
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 10:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxHwheKBdbsdbbglkfDawW5E2I39A77wHuQOIwAfeTY=;
        b=Ixs0O4IXRLYP8STI4hBYcImD13d+UfNgOx4So6Rf+15CxMGG1ZF2ooeg68lyQaoT5a
         i2m+S2P8pxtc18es7Y4cwtoVCIojWlDQiBTdtbMF+rP3Cj5UpCvZqW+3ql4UjaO7YEW7
         IbSHAUu1/0RgESLb9rG5Vhn7BiAoCzTJ73OabI/Lb6fkd/pk2wvG84ey0icVih2dzh9h
         n7QvoYGeeg3pdJvUu17Il7st2S/rh4D2hwghwwFoAsJAfroyIiScz4DRhHSyykCVKZGZ
         Kc3vu2zDZcK2h1LJV+t5hExv3DeIf9qivfr4Liqxe1NqieF/Yu7kduq21JMWFh5u21ty
         YbWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxHwheKBdbsdbbglkfDawW5E2I39A77wHuQOIwAfeTY=;
        b=bW56U8FxLU3EOMOHFBvd6fkYrlVXbTzwPuFwvKQwab4Z87ka0zi2OqX3uDqFx+SAVq
         JYckA64mWXXPdjLjxze6YduTuwIf4AvIerfaGH1m+ic/aNSUWSu3HCUiM5tLjePrxeeE
         PxC7WI6m8DKF7QhamRMt1/ZyJA2rbCGmApsWBdn1ZJPIVY6joE4xkxrjphN1YnBDoABy
         KB8/cr6xTKEbJT4yjPmaXn1ASvSMw42B4DH+nkohgX/hc0PWOy9bhqi2TOtwvfQkcA9n
         D2g624lhxICo3ly5DJZ0eeqgR9XpRJYT7tBnH3zgjG94z/EnAtLbvanttwUW6RV0Tlg1
         YdAA==
X-Gm-Message-State: APjAAAXYUFpziiEpcVtm5ZCdd2J1eOyizWHuoD7jsw/VM84PcZ4AtI90
        K4/BXYYi6VGpvwLvd+LD6HT6vWIHpPvB27CbH5MPTg==
X-Google-Smtp-Source: APXvYqxp+Gpy995KYtiSbRlKGeS6ZhsEYwM0zzW0uwVZomgwBvkQOHqIvIb7lZ9LFuJixOs5iD0b5tokFB/HZlZlx9k=
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr436839pjs.73.1565632562461;
 Mon, 12 Aug 2019 10:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190810101732.26612-1-gregkh@linuxfoundation.org> <20190810101732.26612-14-gregkh@linuxfoundation.org>
In-Reply-To: <20190810101732.26612-14-gregkh@linuxfoundation.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 10:55:51 -0700
Message-ID: <CAKwvOdnP4OU9g_ebjnT=r1WcGRvsFsgv3NbguhFKOtt8RWNHwA@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] mvpp2: no need to check return value of
 debugfs_create functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 10, 2019 at 3:17 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.

Maybe adding this recommendation to the comment block above the
definition of debugfs_create_dir() in fs/debugfs/inode.c would help
prevent this issue in the future?  What failure means, and how to
proceed can be tricky; more documentation can only help in this
regard.

>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Nathan Huckleberry <nhuck@google.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  .../ethernet/marvell/mvpp2/mvpp2_debugfs.c    | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> index 274fb07362cb..4a3baa7e0142 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> @@ -452,8 +452,6 @@ static int mvpp2_dbgfs_flow_port_init(struct dentry *parent,
>         struct dentry *port_dir;
>
>         port_dir = debugfs_create_dir(port->dev->name, parent);
> -       if (IS_ERR(port_dir))
> -               return PTR_ERR(port_dir);
>
>         port_entry = &port->priv->dbgfs_entries->port_flow_entries[port->id];
>
> @@ -480,8 +478,6 @@ static int mvpp2_dbgfs_flow_entry_init(struct dentry *parent,
>         sprintf(flow_entry_name, "%02d", flow);
>
>         flow_entry_dir = debugfs_create_dir(flow_entry_name, parent);
> -       if (!flow_entry_dir)
> -               return -ENOMEM;
>
>         entry = &priv->dbgfs_entries->flow_entries[flow];
>
> @@ -514,8 +510,6 @@ static int mvpp2_dbgfs_flow_init(struct dentry *parent, struct mvpp2 *priv)
>         int i, ret;
>
>         flow_dir = debugfs_create_dir("flows", parent);
> -       if (!flow_dir)
> -               return -ENOMEM;
>
>         for (i = 0; i < MVPP2_N_PRS_FLOWS; i++) {
>                 ret = mvpp2_dbgfs_flow_entry_init(flow_dir, priv, i);
> @@ -539,8 +533,6 @@ static int mvpp2_dbgfs_prs_entry_init(struct dentry *parent,
>         sprintf(prs_entry_name, "%03d", tid);
>
>         prs_entry_dir = debugfs_create_dir(prs_entry_name, parent);
> -       if (!prs_entry_dir)
> -               return -ENOMEM;
>
>         entry = &priv->dbgfs_entries->prs_entries[tid];
>
> @@ -578,8 +570,6 @@ static int mvpp2_dbgfs_prs_init(struct dentry *parent, struct mvpp2 *priv)
>         int i, ret;
>
>         prs_dir = debugfs_create_dir("parser", parent);
> -       if (!prs_dir)
> -               return -ENOMEM;
>
>         for (i = 0; i < MVPP2_PRS_TCAM_SRAM_SIZE; i++) {
>                 ret = mvpp2_dbgfs_prs_entry_init(prs_dir, priv, i);
> @@ -688,8 +678,6 @@ static int mvpp2_dbgfs_port_init(struct dentry *parent,
>         struct dentry *port_dir;
>
>         port_dir = debugfs_create_dir(port->dev->name, parent);
> -       if (IS_ERR(port_dir))
> -               return PTR_ERR(port_dir);
>
>         debugfs_create_file("parser_entries", 0444, port_dir, port,
>                             &mvpp2_dbgfs_port_parser_fops);
> @@ -716,15 +704,10 @@ void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
>         int ret, i;
>
>         mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
> -       if (!mvpp2_root) {
> +       if (!mvpp2_root)
>                 mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
> -               if (IS_ERR(mvpp2_root))
> -                       return;
> -       }
>
>         mvpp2_dir = debugfs_create_dir(name, mvpp2_root);
> -       if (IS_ERR(mvpp2_dir))
> -               return;
>
>         priv->dbgfs_dir = mvpp2_dir;
>         priv->dbgfs_entries = kzalloc(sizeof(*priv->dbgfs_entries), GFP_KERNEL);
> --
> 2.22.0
>


-- 
Thanks,
~Nick Desaulniers
