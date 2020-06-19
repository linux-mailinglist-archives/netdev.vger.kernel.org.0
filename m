Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5EA201B6C
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389687AbgFSTiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389188AbgFSTiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:38:54 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24919C06174E;
        Fri, 19 Jun 2020 12:38:54 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id cy7so1971984edb.5;
        Fri, 19 Jun 2020 12:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=frpyFy5QhoXErzx9/nthK4q+e/lcRU4mJpRY09aN6PA=;
        b=mYDrt5DrKzmDCQwm9gPQbDVuVr529D863mAn7FNUpRyR1nWf69L967Ke/w51sdoDMA
         hnYfl5nJISwIEdd8VA1WqZer+gFJ5rL8acldeRBfiN0G1d72e4AGWfXpPE5Ku9jva0Hb
         4kwHVxetDRnKvRkgc4lk6og73xQKqdwjomP2wdLkpvcWlopJU9OA/lpWWW86wMuSduMu
         ikdZjv2iGNZHqYXWXOxRjgzyp1PnvfA9WWJAJxtDLzqV3Mfa8PnnT6r2mjQ/PWO5tYlD
         hrmUzIJ8LWrSW3Rap/fzHR0e31fuEnPL2KaJtbLsgW1fXp9VphJqZK3W1CeK+UxWQrHW
         8l4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=frpyFy5QhoXErzx9/nthK4q+e/lcRU4mJpRY09aN6PA=;
        b=fo6Mo+G2a+KI6j7uc5vJWmuPqrg3nSVm1zRY9z6xpoHXk5Rm5e6RAiHwdkGdW8KUC5
         bubeewqalyZ81ZG9u80ZzpEwjQ2/8DKoBJdgGMTOH3ud2cGSboGPRR2mcMxBwsL261IM
         54fDFOMR8y6MRqxM1z1YLoWYEshLjajRflPGODWN3Y2mPbu1dUqldr6ghfm1QAttoLht
         iJnZaFRoho9aSiSE8cJLBGSFwWpG08aveLQ+bNG+dZMHBWKMr3IAzCBikwG3IynBp9O/
         mPwUyeT1PdysPgLlqAj8L9rPQDKFCrSykoOz3afy0ao4YkwOEmXI++4QGexYGP7aFL3d
         uZzg==
X-Gm-Message-State: AOAM530Ru0luJOpeestEMeURvGfWGWbJqcMw9af0zYfbFc1gNuKMehDj
        +3/muqSr+5rDyAeYTvaOQMLWnwVPs8Xl1WzcuB1wEA==
X-Google-Smtp-Source: ABdhPJzV33vZ0/jK36xk96KlbpobiwtmnsYkMISH5S+FKGnGUONvBgrNbgeMkwbM6+OMOGz2GB7d8uU0v45ksH5cwhM=
X-Received: by 2002:aa7:dc50:: with SMTP id g16mr5135478edu.318.1592595532859;
 Fri, 19 Jun 2020 12:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200619181007.GA32353@embeddedor>
In-Reply-To: <20200619181007.GA32353@embeddedor>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 19 Jun 2020 22:38:41 +0300
Message-ID: <CA+h21hoQiRnpiAsLR6ZttbmFMQHb6UNAojaDTH=Y-RPrwwpR0w@mail.gmail.com>
Subject: Re: [PATCH][next] net: dsa: sja1105: Use struct_size() in kzalloc()
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

On Fri, 19 Jun 2020 at 21:04, Gustavo A. R. Silva <gustavoars@kernel.org> wrote:
>
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
>
> This code was detected with the help of Coccinelle and, audited and
> fixed manually.
>
> Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/dsa/sja1105/sja1105_tas.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
> index 3aa1a8b5f766..31d8acff1f01 100644
> --- a/drivers/net/dsa/sja1105/sja1105_tas.c
> +++ b/drivers/net/dsa/sja1105/sja1105_tas.c
> @@ -475,8 +475,7 @@ bool sja1105_gating_check_conflicts(struct sja1105_private *priv, int port,
>         if (list_empty(&gating_cfg->entries))
>                 return false;
>
> -       dummy = kzalloc(sizeof(struct tc_taprio_sched_entry) * num_entries +
> -                       sizeof(struct tc_taprio_qopt_offload), GFP_KERNEL);
> +       dummy = kzalloc(struct_size(dummy, entries, num_entries), GFP_KERNEL);

Before, I could read this line and I knew what it did. Now, I have to
look it up.
But if it's in the interest of kernel coding style, what can I say.

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>         if (!dummy) {
>                 NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory");
>                 return true;
> --
> 2.27.0
>
